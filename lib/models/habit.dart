class Habit {
  final String id;
  final String name;
  final String icon;
  final String category;
  final String color;
  final int targetMinutes;
  final String? reminderTime;
  final Map<String, bool> completedDates; // Date string -> completed status
  final DateTime createdAt;
  final String habitType; // 'good', 'bad', or 'uncertain'
  final List<String>? suggestedHabits; // Suggestions for uncertain habits
  final String? description; // Description for the habit

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.color,
    required this.targetMinutes,
    this.reminderTime,
    Map<String, bool>? completedDates,
    DateTime? createdAt,
    this.habitType = 'uncertain',
    this.suggestedHabits,
    this.description,
  })  : completedDates = completedDates ?? {},
        createdAt = createdAt ?? DateTime.now();

  // Get completion status for a specific date
  bool isCompletedOnDate(DateTime date) {
    final dateKey = _dateToString(date);
    return completedDates[dateKey] ?? false;
  }

  // Toggle completion for a specific date
  Habit toggleCompletion(DateTime date) {
    final dateKey = _dateToString(date);
    final newCompletedDates = Map<String, bool>.from(completedDates);
    newCompletedDates[dateKey] = !(completedDates[dateKey] ?? false);
    
    return Habit(
      id: id,
      name: name,
      icon: icon,
      category: category,
      color: color,
      targetMinutes: targetMinutes,
      reminderTime: reminderTime,
      completedDates: newCompletedDates,
      createdAt: createdAt,
      habitType: habitType,
      suggestedHabits: suggestedHabits,
      description: description,
    );
  }

  // Get current streak
  int getStreak() {
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    while (isCompletedOnDate(currentDate)) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    
    return streak;
  }

  // Get completion rate for last 7 days
  double getWeeklyCompletionRate() {
    int completed = 0;
    DateTime today = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      DateTime date = today.subtract(Duration(days: i));
      if (isCompletedOnDate(date)) {
        completed++;
      }
    }
    
    return completed / 7;
  }

  // Helper method to convert date to string key
  static String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'category': category,
      'color': color,
      'targetMinutes': targetMinutes,
      'reminderTime': reminderTime,
      'completedDates': completedDates,
      'createdAt': createdAt.toIso8601String(),
      'habitType': habitType,
      'suggestedHabits': suggestedHabits,
      'description': description,
    };
  }

  // Create from JSON
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      category: json['category'],
      color: json['color'],
      targetMinutes: json['targetMinutes'],
      reminderTime: json['reminderTime'],
      completedDates: Map<String, bool>.from(json['completedDates'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      habitType: json['habitType'] ?? 'uncertain',
      suggestedHabits: json['suggestedHabits'] != null 
          ? List<String>.from(json['suggestedHabits']) 
          : null,
      description: json['description'],
    );
  }

  // Create a copy with modified fields
  Habit copyWith({
    String? id,
    String? name,
    String? icon,
    String? category,
    String? color,
    int? targetMinutes,
    String? reminderTime,
    Map<String, bool>? completedDates,
    DateTime? createdAt,
    String? habitType,
    List<String>? suggestedHabits,
    String? description,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      color: color ?? this.color,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      reminderTime: reminderTime ?? this.reminderTime,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      habitType: habitType ?? this.habitType,
      suggestedHabits: suggestedHabits ?? this.suggestedHabits,
      description: description ?? this.description,
    );
  }
}
