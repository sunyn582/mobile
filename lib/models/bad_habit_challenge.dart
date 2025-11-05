class BadHabitChallenge {
  final String id;
  final String habitId;
  final String habitName;
  final String habitIcon;
  final String level; // 'gradual', 'moderate', 'strict'
  final DateTime startDate;
  final DateTime targetEndDate;
  final Map<String, bool> dailyProgress; // Date string -> completed (no relapse)
  final List<DateTime> milestones; // Dates when milestones were achieved
  final bool isCompleted;
  final DateTime? completedDate;

  BadHabitChallenge({
    required this.id,
    required this.habitId,
    required this.habitName,
    required this.habitIcon,
    required this.level,
    required this.startDate,
    required this.targetEndDate,
    Map<String, bool>? dailyProgress,
    List<DateTime>? milestones,
    this.isCompleted = false,
    this.completedDate,
  })  : dailyProgress = dailyProgress ?? {},
        milestones = milestones ?? [];

  // Get duration in days
  int getTotalDays() {
    return targetEndDate.difference(startDate).inDays;
  }

  // Get days completed successfully
  int getDaysCompleted() {
    return dailyProgress.values.where((completed) => completed).length;
  }

  // Get current streak
  int getCurrentStreak() {
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    while (true) {
      final dateKey = _dateToString(currentDate);
      if (dailyProgress[dateKey] == true) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  // Get completion percentage
  double getCompletionPercentage() {
    final total = getTotalDays();
    if (total == 0) return 0;
    return getDaysCompleted() / total;
  }

  // Check if today is marked
  bool isTodayMarked() {
    final today = _dateToString(DateTime.now());
    return dailyProgress[today] == true;
  }

  // Mark today as completed
  BadHabitChallenge markToday(bool succeeded) {
    final today = _dateToString(DateTime.now());
    final newProgress = Map<String, bool>.from(dailyProgress);
    newProgress[today] = succeeded;
    
    // Check if challenge is completed
    final daysCompleted = newProgress.values.where((v) => v).length;
    final totalDays = getTotalDays();
    final isNowCompleted = daysCompleted >= totalDays;
    
    return BadHabitChallenge(
      id: id,
      habitId: habitId,
      habitName: habitName,
      habitIcon: habitIcon,
      level: level,
      startDate: startDate,
      targetEndDate: targetEndDate,
      dailyProgress: newProgress,
      milestones: milestones,
      isCompleted: isNowCompleted,
      completedDate: isNowCompleted ? DateTime.now() : completedDate,
    );
  }

  // Add milestone
  BadHabitChallenge addMilestone(DateTime milestone) {
    final newMilestones = List<DateTime>.from(milestones);
    if (!newMilestones.any((m) => _dateToString(m) == _dateToString(milestone))) {
      newMilestones.add(milestone);
    }
    
    return BadHabitChallenge(
      id: id,
      habitId: habitId,
      habitName: habitName,
      habitIcon: habitIcon,
      level: level,
      startDate: startDate,
      targetEndDate: targetEndDate,
      dailyProgress: dailyProgress,
      milestones: newMilestones,
      isCompleted: isCompleted,
      completedDate: completedDate,
    );
  }

  // Check if challenge is over and calculate final result
  Map<String, dynamic> checkChallengeCompletion() {
    final now = DateTime.now();
    final isOver = now.isAfter(targetEndDate);
    
    if (!isOver) {
      return {
        'isOver': false,
        'isSuccess': false,
        'completionRate': 0.0,
      };
    }
    
    // Auto-mark missed days as failed
    _autoMarkMissedDays();
    
    final totalDays = getTotalDays();
    final successDays = dailyProgress.values.where((v) => v == true).length;
    final completionRate = totalDays > 0 ? successDays / totalDays : 0.0;
    final isSuccess = completionRate >= 0.9; // 90% threshold
    
    return {
      'isOver': true,
      'isSuccess': isSuccess,
      'completionRate': completionRate,
      'successDays': successDays,
      'totalDays': totalDays,
    };
  }

  // Auto-mark days that weren't checked in as failed
  void _autoMarkMissedDays() {
    final now = DateTime.now();
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(now) && currentDate.isBefore(targetEndDate)) {
      final dateKey = _dateToString(currentDate);
      if (!dailyProgress.containsKey(dateKey)) {
        // If user didn't check in by 22:00, mark as failed
        final checkInDeadline = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          23,
          59,
        );
        
        if (now.isAfter(checkInDeadline)) {
          dailyProgress[dateKey] = false; // Failed
        }
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }
  String? checkMilestone() {
    final daysCompleted = getDaysCompleted();
    final totalDays = getTotalDays();
    
    // Check for 1/3 milestone
    if (daysCompleted >= totalDays / 3 && daysCompleted < totalDays / 2) {
      if (!milestones.any((m) => _isSameDay(m, DateTime.now()))) {
        return 'one_third';
      }
    }
    
    // Check for 1/2 milestone
    if (daysCompleted >= totalDays / 2 && daysCompleted < totalDays) {
      if (!milestones.any((m) => _isSameDay(m, DateTime.now()))) {
        return 'half';
      }
    }
    
    // Check for completion
    if (isCompleted && completedDate != null) {
      if (_isSameDay(completedDate!, DateTime.now())) {
        return 'complete';
      }
    }
    
    return null;
  }

  // Get notification frequency in hours based on level
  List<int> getNotificationHours() {
    switch (level) {
      case 'gradual': // 1 time per day at 6 AM
        return [6];
      case 'moderate': // 2 times per day at 6 AM and 6 PM
        return [6, 18];
      case 'strict': // Every 3 hours from 6 AM to midnight
        return [6, 9, 12, 15, 18, 21];
      default:
        return [6];
    }
  }

  // Get level name in Vietnamese
  String getLevelName() {
    switch (level) {
      case 'gradual':
        return 'Từ từ';
      case 'moderate':
        return 'Vừa phải';
      case 'strict':
        return 'Kiên quyết';
      default:
        return 'Không xác định';
    }
  }

  // Get level icon
  String getLevelIcon() {
    switch (level) {
      case 'gradual':
        return '🐢';
      case 'moderate':
        return '🚶';
      case 'strict':
        return '🏃';
      default:
        return '❓';
    }
  }

  // Get level color
  String getLevelColor() {
    switch (level) {
      case 'gradual':
        return '#2196F3'; // Blue
      case 'moderate':
        return '#FF9800'; // Orange
      case 'strict':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Helper method to convert date to string key
  static String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Helper to check if two dates are the same day
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'habitName': habitName,
      'habitIcon': habitIcon,
      'level': level,
      'startDate': startDate.toIso8601String(),
      'targetEndDate': targetEndDate.toIso8601String(),
      'dailyProgress': dailyProgress,
      'milestones': milestones.map((m) => m.toIso8601String()).toList(),
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  // Create from JSON
  factory BadHabitChallenge.fromJson(Map<String, dynamic> json) {
    return BadHabitChallenge(
      id: json['id'],
      habitId: json['habitId'],
      habitName: json['habitName'],
      habitIcon: json['habitIcon'],
      level: json['level'],
      startDate: DateTime.parse(json['startDate']),
      targetEndDate: DateTime.parse(json['targetEndDate']),
      dailyProgress: Map<String, bool>.from(json['dailyProgress'] ?? {}),
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((m) => DateTime.parse(m as String))
              .toList() ??
          [],
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
    );
  }

  // Create a copy with modified fields
  BadHabitChallenge copyWith({
    String? id,
    String? habitId,
    String? habitName,
    String? habitIcon,
    String? level,
    DateTime? startDate,
    DateTime? targetEndDate,
    Map<String, bool>? dailyProgress,
    List<DateTime>? milestones,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return BadHabitChallenge(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitName: habitName ?? this.habitName,
      habitIcon: habitIcon ?? this.habitIcon,
      level: level ?? this.level,
      startDate: startDate ?? this.startDate,
      targetEndDate: targetEndDate ?? this.targetEndDate,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      milestones: milestones ?? this.milestones,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
