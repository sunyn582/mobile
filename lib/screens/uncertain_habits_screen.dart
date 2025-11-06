import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/habit.dart';
import '../widgets/habit_reclassify_dialog.dart';
import '../utils/habit_classifier.dart';

class UncertainHabitsScreen extends StatefulWidget {
  final List<Habit> uncertainHabits;

  const UncertainHabitsScreen({super.key, required this.uncertainHabits});

  @override
  State<UncertainHabitsScreen> createState() => _UncertainHabitsScreenState();
}

class _UncertainHabitsScreenState extends State<UncertainHabitsScreen> {
  late List<Habit> _habits;

  @override
  void initState() {
    super.initState();
    _habits = List.from(widget.uncertainHabits);
  }

  void _reclassifyHabit(Habit habit, String newType) {
    setState(() {
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit.copyWith(habitType: newType);
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newType == 'good'
              ? '✅ Đã chuyển "${habit.name}" thành thói quen tốt'
              : newType == 'bad'
                  ? '⛔ Đã chuyển "${habit.name}" thành thói quen xấu'
                  : '❓ Đã đánh dấu "${habit.name}" là chưa phân loại',
        ),
        backgroundColor: newType == 'good'
            ? Colors.green
            : newType == 'bad'
                ? Colors.red
                : const Color(0xFFF2C94C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thói quen chưa phân loại'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2C94C).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '❓',
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Giúp chúng tôi hiểu rõ hơn',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      'Những thói quen này chưa được phân loại rõ ràng. Bạn hãy giúp chúng tôi xác định chúng là thói quen tốt hay xấu nhé!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Habits list
              Expanded(
                child: _habits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🎉',
                              style: TextStyle(fontSize: 64),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            Text(
                              'Tất cả thói quen đã được phân loại!',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.paddingLarge),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, _habits),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Quay lại',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                        itemCount: _habits.length,
                        itemBuilder: (context, index) {
                          final habit = _habits[index];
                          return _buildHabitCard(habit, isDarkMode);
                        },
                      ),
              ),

              // Bottom button
              if (_habits.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _habits),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                      child: const Text(
                        'Hoàn thành',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitCard(Habit habit, bool isDarkMode) {
    // Find similar habits for suggestions
    final suggestions = HabitClassifier.findSimilarHabits(habit.name);
    final topSuggestions = suggestions.take(3).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: const Color(0xFFF2C94C).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    habit.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2C94C).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Chưa phân loại',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFF2C94C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Suggestions
          if (topSuggestions.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingMedium),
            const Divider(),
            const SizedBox(height: AppDimensions.paddingSmall),
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Color(0xFFF2C94C),
                ),
                const SizedBox(width: 4),
                Text(
                  'Có thể giống với:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFF2C94C),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topSuggestions.map((suggestion) {
                final type = suggestion['type'] as String;
                final displayName = suggestion['displayName'] as String;
                final color = type == 'good'
                    ? const Color(0xFF6FCF97)
                    : const Color(0xFFEB5757);
                final icon = type == 'good' ? '✅' : '⛔';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Action button
          const SizedBox(height: AppDimensions.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showReclassifyDialog(
                  context,
                  habit,
                  (newType) => _reclassifyHabit(habit, newType),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2C94C),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Phân loại thói quen này',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
