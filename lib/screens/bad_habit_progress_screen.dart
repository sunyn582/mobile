import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bad_habit_challenge.dart';
import '../constants/app_constants.dart';

class BadHabitProgressScreen extends StatefulWidget {
  final BadHabitChallenge challenge;
  final Function(BadHabitChallenge) onUpdate;

  const BadHabitProgressScreen({
    super.key,
    required this.challenge,
    required this.onUpdate,
  });

  @override
  State<BadHabitProgressScreen> createState() => _BadHabitProgressScreenState();
}

class _BadHabitProgressScreenState extends State<BadHabitProgressScreen>
    with SingleTickerProviderStateMixin {
  late BadHabitChallenge _challenge;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    
    // Check for milestone celebration or completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkChallengeStatus();
    });
  }

  void _checkChallengeStatus() {
    // Check if challenge is complete
    final completionData = _challenge.checkChallengeCompletion();
    
    if (completionData['isOver'] == true) {
      _showCompletionDialog(completionData);
    } else {
      // Check for milestone if not complete
      _checkAndCelebrateMilestone();
    }
  }

  void _showCompletionDialog(Map<String, dynamic> data) {
    final isSuccess = data['isSuccess'] as bool;
    final completionRate = data['completionRate'] as double;
    final successDays = data['successDays'] as int;
    final totalDays = data['totalDays'] as int;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSuccess ? '🏆' : '💪',
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              isSuccess ? 'Hoàn thành!' : 'Chưa hoàn thành',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSuccess
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Tỷ lệ thành công',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(completionRate * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isSuccess ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$successDays/$totalDays ngày thành công',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isSuccess
                  ? 'Chúc mừng! Bạn đã vượt qua thử thách với tỷ lệ thành công trên 90%! Bạn đã chứng minh được ý chí và quyết tâm của mình. Hãy tiếp tục duy trì thói quen tốt này nhé! 🎉'
                  : 'Đừng nản lòng! Mặc dù lần này chưa đạt 90%, nhưng bạn đã nỗ lực rất nhiều. Mỗi ngày bạn kiểm soát được thói quen xấu là một chiến thắng. Hãy thử lại với quyết tâm mạnh mẽ hơn! Bạn làm được mà! 💪',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close progress screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.green : Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isSuccess ? 'Tuyệt vời! 🎉' : 'Tôi sẽ cố gắng hơn! 💪',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAndCelebrateMilestone() {
    final milestone = _challenge.checkMilestone();
    if (milestone != null) {
      _showMilestoneCelebration(milestone);
    }
  }

  void _showMilestoneCelebration(String milestone) {
    String title = '';
    String message = '';
    String emoji = '';
    
    switch (milestone) {
      case 'one_third':
        title = 'Chúc mừng! 🎉';
        message = 'Bạn đã hoàn thành 1/3 hành trình! Tiếp tục phát huy nhé!';
        emoji = '🌟';
        break;
      case 'half':
        title = 'Tuyệt vời! 🎊';
        message = 'Đã đi được nửa đường rồi! Bạn làm được mà!';
        emoji = '💪';
        break;
      case 'complete':
        title = 'Hoàn thành! 🏆';
        message = 'Bạn đã thành công bỏ thói quen xấu này! Thật đáng tự hào!';
        emoji = '🎯';
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add milestone
                final updatedChallenge = _challenge.addMilestone(DateTime.now());
                setState(() {
                  _challenge = updatedChallenge;
                });
                widget.onUpdate(updatedChallenge);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tiếp tục!',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markToday(bool succeeded) {
    final updatedChallenge = _challenge.markToday(succeeded);
    setState(() {
      _challenge = updatedChallenge;
    });
    widget.onUpdate(updatedChallenge);
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded
              ? '✅ Tuyệt vời! Bạn đã giữ được hôm nay!'
              : '💪 Đừng nản lòng! Ngày mai sẽ tốt hơn!',
        ),
        backgroundColor: succeeded ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Check milestone after marking
    if (succeeded) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _checkAndCelebrateMilestone();
      });
    }
  }

  Color _getLevelColor() {
    return Color(
      int.parse(_challenge.getLevelColor().substring(1), radix: 16) + 0xFF000000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final levelColor = _getLevelColor();
    final percentage = _challenge.getCompletionPercentage();
    final daysRemaining = _challenge.getTotalDays() - _challenge.getDaysCompleted();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến độ bỏ thói quen'),
        backgroundColor: levelColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [AppColors.darkBackground, Color(0xFF2D2D2D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Habit Info Card
              _buildHabitInfoCard(isDarkMode, levelColor),
              
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Progress Card
              _buildProgressCard(isDarkMode, levelColor, percentage, daysRemaining),
              
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Daily Check-in Card
              if (!_challenge.isCompleted) _buildDailyCheckinCard(isDarkMode),
              
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Calendar View
              _buildCalendarView(isDarkMode),
              
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Statistics
              _buildStatistics(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitInfoCard(bool isDarkMode, Color levelColor) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
        border: Border.all(color: levelColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            _challenge.habitIcon,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 12),
          Text(
            _challenge.habitName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: levelColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _challenge.getLevelIcon(),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mức độ: ${_challenge.getLevelName()}',
                  style: TextStyle(
                    color: levelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(bool isDarkMode, Color levelColor, double percentage, int daysRemaining) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: levelColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(levelColor),
              minHeight: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${_challenge.getDaysCompleted()}',
                'Ngày thành công',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatItem(
                '$daysRemaining',
                'Ngày còn lại',
                Icons.timer,
                Colors.orange,
              ),
              _buildStatItem(
                '${_challenge.getCurrentStreak()}',
                'Chuỗi hiện tại',
                Icons.local_fire_department,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDailyCheckinCard(bool isDarkMode) {
    final isTodayMarked = _challenge.isTodayMarked();
    final now = DateTime.now();
    final canCheckIn = now.hour >= 22 || now.hour < 1; // 22:00 - 00:59
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.today, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Điểm danh hôm nay',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isTodayMarked)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bạn đã điểm danh hôm nay! Tuyệt vời! 🎉',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (!canCheckIn)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.orange, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Điểm danh mở từ 22:00 - 00:59 mỗi ngày.\nHiện tại: ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hôm nay bạn đã kiểm soát được thói quen xấu này chưa?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _markToday(true),
                        icon: const Icon(Icons.check),
                        label: const Text('Có, tôi đã kiểm soát'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _markToday(false),
                        icon: const Icon(Icons.close),
                        label: const Text('Không, tôi thất bại'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch sử 7 ngày gần nhất',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildWeekCalendar(),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final today = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final date = today.subtract(Duration(days: 6 - index));
        final dateKey = _dateToString(date);
        final isMarked = _challenge.dailyProgress[dateKey] == true;
        final isFailed = _challenge.dailyProgress[dateKey] == false;
        final isToday = _isSameDay(date, today);
        
        return Column(
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontSize: 12,
                color: isToday ? AppColors.primary : Colors.grey,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isMarked
                    ? Colors.green
                    : isFailed
                        ? Colors.orange.withValues(alpha: 0.3)
                        : Colors.grey[300],
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: isMarked
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : isFailed
                        ? const Icon(Icons.refresh, color: Colors.orange, size: 20)
                        : Text(
                            '${date.day}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper methods
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildStatistics(bool isDarkMode) {
    final totalDays = _challenge.getTotalDays();
    final daysCompleted = _challenge.getDaysCompleted();
    final successRate = totalDays > 0 ? (daysCompleted / totalDays * 100) : 0;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống kê',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Ngày bắt đầu:', DateFormat('dd/MM/yyyy').format(_challenge.startDate)),
          const SizedBox(height: 8),
          _buildStatRow('Ngày kết thúc dự kiến:', DateFormat('dd/MM/yyyy').format(_challenge.targetEndDate)),
          const SizedBox(height: 8),
          _buildStatRow('Tổng số ngày:', '$totalDays ngày'),
          const SizedBox(height: 8),
          _buildStatRow('Tỷ lệ thành công:', '${successRate.toStringAsFixed(1)}%'),
          const SizedBox(height: 8),
          _buildStatRow('Chuỗi dài nhất:', '${_challenge.getCurrentStreak()} ngày'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
