import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/bad_habit_challenge.dart';
import '../constants/app_constants.dart';
import '../utils/bad_habit_notification_service.dart';
import 'bad_habit_progress_screen.dart';

class BadHabitsScreen extends StatefulWidget {
  final List<Habit> badHabits;

  const BadHabitsScreen({super.key, required this.badHabits});

  @override
  State<BadHabitsScreen> createState() => _BadHabitsScreenState();
}

class _BadHabitsScreenState extends State<BadHabitsScreen> {
  final Map<String, BadHabitChallenge> _activeChallenges = {};

  void _showActionOptions(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Chọn cách bỏ thói quen',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${habit.icon} ${habit.name}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              
              // Option 1: Từ từ
              _buildActionOption(
                context: context,
                icon: Icons.trending_down,
                iconColor: Colors.blue,
                title: 'Từ từ',
                description: 'Giảm dần tần suất, cho phép bạn thích nghi từ từ',
                gradientColors: [Colors.blue.shade50, Colors.blue.shade100],
                onTap: () {
                  Navigator.pop(context);
                  _handleActionSelected(context, habit, 'gradual');
                },
              ),
              
              const SizedBox(height: AppDimensions.paddingMedium),
              
              // Option 2: Vừa phải
              _buildActionOption(
                context: context,
                icon: Icons.speed,
                iconColor: Colors.orange,
                title: 'Vừa phải',
                description: 'Cân bằng giữa quyết tâm và linh hoạt',
                gradientColors: [Colors.orange.shade50, Colors.orange.shade100],
                onTap: () {
                  Navigator.pop(context);
                  _handleActionSelected(context, habit, 'moderate');
                },
              ),
              
              const SizedBox(height: AppDimensions.paddingMedium),
              
              // Option 3: Kiên quyết
              _buildActionOption(
                context: context,
                icon: Icons.block,
                iconColor: Colors.red,
                title: 'Kiên quyết',
                description: 'Dừng ngay lập tức, yêu cầu ý chí mạnh mẽ',
                gradientColors: [Colors.red.shade50, Colors.red.shade100],
                onTap: () {
                  Navigator.pop(context);
                  _handleActionSelected(context, habit, 'strict');
                },
              ),
              
              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: iconColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
          ],
        ),
      ),
    );
  }

  void _handleActionSelected(BuildContext context, Habit habit, String actionType) async {
    String message = '';
    String actionPlan = '';
    int minDays = 0;
    int maxDays = 0;
    
    switch (actionType) {
      case 'gradual':
        message = 'Bạn đã chọn phương pháp "Từ từ"';
        actionPlan = 'Giảm dần từ 3-6 tháng. Thông báo nhắc nhở 1 lần/ngày lúc 6h sáng.';
        minDays = 90; // 3 months
        maxDays = 180; // 6 months
        break;
      case 'moderate':
        message = 'Bạn đã chọn phương pháp "Vừa phải"';
        actionPlan = 'Giảm dần từ 1.5-3 tháng. Thông báo nhắc nhở 2 lần/ngày (6h sáng, 6h chiều).';
        minDays = 45; // 1.5 months
        maxDays = 90; // 3 months
        break;
      case 'strict':
        message = 'Bạn đã chọn phương pháp "Kiên quyết"';
        actionPlan = 'Dừng hoàn toàn từ 15 ngày - 1 tháng. Thông báo nhắc nhở mỗi 3 tiếng (6h-0h).';
        minDays = 15; // 15 days
        maxDays = 30; // 1 month
        break;
    }
    
    // Show duration picker
    final selectedDays = await _showDurationPicker(context, actionType, minDays, maxDays);
    if (selectedDays == null || !mounted) return; // User cancelled

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 8),
            const Expanded(child: Text('Kế hoạch đã chọn')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kế hoạch hành động:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(actionPlan),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Thời gian: $selectedDays ngày',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Điểm danh mỗi ngày vào 22h. Nếu bỏ lỡ sẽ tự động đánh dấu thất bại.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hoàn thành ≥90%: Thành công! 🎉',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Bắt đầu ngay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _createChallenge(habit, actionType, selectedDays);
    }
  }

  Future<int?> _showDurationPicker(BuildContext context, String actionType, int minDays, int maxDays) async {
    int selectedDays = minDays;
    
    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Chọn thời gian cam kết'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bạn muốn cam kết trong bao lâu?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$selectedDays ngày',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '(~${(selectedDays / 30).toStringAsFixed(1)} tháng)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: selectedDays.toDouble(),
                  min: minDays.toDouble(),
                  max: maxDays.toDouble(),
                  divisions: maxDays - minDays,
                  label: '$selectedDays ngày',
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value.toInt();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$minDays ngày',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '$maxDays ngày',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedDays),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Tiếp tục', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _createChallenge(Habit habit, String actionType, int durationDays) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: durationDays));

    final challenge = BadHabitChallenge(
      id: '${habit.id}_${DateTime.now().millisecondsSinceEpoch}',
      habitId: habit.id,
      habitName: habit.name,
      habitIcon: habit.icon,
      level: actionType,
      startDate: now,
      targetEndDate: endDate,
    );

    setState(() {
      _activeChallenges[habit.id] = challenge;
    });

    // Schedule notifications
    try {
      await BadHabitNotificationService.scheduleNotifications(challenge);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã lên lịch nhắc nhở!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Không thể lên lịch thông báo. Vui lòng kiểm tra quyền.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    // Navigate to progress screen
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BadHabitProgressScreen(
            challenge: challenge,
            onUpdate: (updatedChallenge) {
              setState(() {
                _activeChallenges[habit.id] = updatedChallenge;
              });
            },
          ),
        ),
      );
    }
  }

  List<Widget> _buildChallengeStatus(BadHabitChallenge challenge, bool isDarkMode) {
    final levelColor = Color(
      int.parse(challenge.getLevelColor().substring(1), radix: 16) + 0xFF000000,
    );
    final percentage = challenge.getCompletionPercentage();
    final daysCompleted = challenge.getDaysCompleted();
    final totalDays = challenge.getTotalDays();

    return [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: levelColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: levelColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      challenge.getLevelIcon(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đang thực hiện: ${challenge.getLevelName()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: levelColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$daysCompleted/$totalDays',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔥 Chuỗi: ${challenge.getCurrentStreak()} ngày',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}% hoàn thành',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: levelColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: AppDimensions.paddingMedium),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thói quen cần bỏ'),
        backgroundColor: Colors.red,
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
        child: widget.badHabits.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Tuyệt vời!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bạn không có thói quen xấu nào',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: widget.badHabits.length,
                itemBuilder: (context, index) {
                  final habit = widget.badHabits[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      boxShadow: AppShadows.small,
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppDimensions.radiusMedium),
                              topRight: Radius.circular(AppDimensions.radiusMedium),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                habit.icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        habit.category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Description
                        Padding(
                          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Colors.orange[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tại sao cần bỏ:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                habit.description ?? 'Thói quen này có thể ảnh hưởng tiêu cực đến sức khỏe và cuộc sống của bạn.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppDimensions.paddingMedium),
                              
                              // Show active challenge status if exists
                              if (_activeChallenges.containsKey(habit.id))
                                ..._buildChallengeStatus(_activeChallenges[habit.id]!, isDarkMode),
                              
                              // Action Button
                              SizedBox(
                                width: double.infinity,
                                child: _activeChallenges.containsKey(habit.id)
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BadHabitProgressScreen(
                                                challenge: _activeChallenges[habit.id]!,
                                                onUpdate: (updatedChallenge) {
                                                  setState(() {
                                                    _activeChallenges[habit.id] = updatedChallenge;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.trending_up),
                                        label: const Text('Xem tiến độ'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: () => _showActionOptions(context, habit),
                                        icon: const Icon(Icons.rocket_launch),
                                        label: const Text('Hành động ngay'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
