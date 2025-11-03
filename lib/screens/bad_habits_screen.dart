import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';

class BadHabitsScreen extends StatefulWidget {
  final List<Habit> badHabits;

  const BadHabitsScreen({super.key, required this.badHabits});

  @override
  State<BadHabitsScreen> createState() => _BadHabitsScreenState();
}

class _BadHabitsScreenState extends State<BadHabitsScreen> {
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

  void _handleActionSelected(BuildContext context, Habit habit, String actionType) {
    String message = '';
    String actionPlan = '';
    
    switch (actionType) {
      case 'gradual':
        message = 'Bạn đã chọn phương pháp "Từ từ"';
        actionPlan = 'Mỗi tuần giảm 20% tần suất thực hiện thói quen này. Bạn sẽ hoàn toàn bỏ được sau 5 tuần.';
        break;
      case 'moderate':
        message = 'Bạn đã chọn phương pháp "Vừa phải"';
        actionPlan = 'Giảm 50% tần suất ngay từ tuần đầu, sau đó giảm dần hoàn toàn trong 3 tuần.';
        break;
      case 'strict':
        message = 'Bạn đã chọn phương pháp "Kiên quyết"';
        actionPlan = 'Dừng hoàn toàn ngay từ hôm nay. Hãy tìm hoạt động thay thế khi có cảm giác muốn quay lại.';
        break;
    }

    showDialog(
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hãy theo dõi tiến độ hàng ngày để đạt kết quả tốt nhất!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Lưu kế hoạch và bắt đầu theo dõi
            },
            child: const Text('Bắt đầu ngay'),
          ),
        ],
      ),
    );
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
                              
                              // Action Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
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
