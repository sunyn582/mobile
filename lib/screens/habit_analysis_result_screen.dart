import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/habit.dart';
import '../utils/habit_contribution_service.dart';
import '../utils/habit_classifier.dart';
import '../utils/habit_auto_classifier.dart';
import 'suggested_habits_screen.dart';

class HabitAnalysisResultScreen extends StatefulWidget {
  final List<Map<String, String>> currentHabits;

  const HabitAnalysisResultScreen({
    super.key,
    required this.currentHabits,
  });

  @override
  State<HabitAnalysisResultScreen> createState() => _HabitAnalysisResultScreenState();
}

class _HabitAnalysisResultScreenState extends State<HabitAnalysisResultScreen> {
  // Keep track of user classifications
  final Map<int, String> _userClassifications = {};
  
  int get _goodHabitsCount =>
      widget.currentHabits.where((h) {
        final index = widget.currentHabits.indexOf(h);
        final type = _userClassifications[index] ?? h['type'];
        return type == 'good';
      }).length;
  
  int get _badHabitsCount =>
      widget.currentHabits.where((h) {
        final index = widget.currentHabits.indexOf(h);
        final type = _userClassifications[index] ?? h['type'];
        return type == 'bad';
      }).length;
  
  int get _uncertainHabitsCount =>
      widget.currentHabits.where((h) {
        final index = widget.currentHabits.indexOf(h);
        final type = _userClassifications[index] ?? h['type'];
        return type == 'uncertain';
      }).length;

  void _continueToSuggestions(BuildContext context) async {
    final suggestedHabits = await Navigator.push<List<Habit>>(
      context,
      MaterialPageRoute(
        builder: (context) => const SuggestedHabitsScreen(),
      ),
    );
    
    if (!mounted) return;
    
    if (suggestedHabits != null) {
      // Combine current habits with suggested habits
      final allHabits = <Habit>[];
      int index = 0;
      
      // Add current habits with user classifications
      for (int i = 0; i < widget.currentHabits.length; i++) {
        final habitData = widget.currentHabits[i];
        final finalType = _userClassifications[i] ?? habitData['type']!;
        
        allHabits.add(
          Habit(
            id: '${DateTime.now().millisecondsSinceEpoch}_current_$index',
            name: habitData['name']!,
            icon: _getIconForHabit(finalType),
            category: 'Custom',
            color: _getColorForType(finalType),
            targetMinutes: finalType == 'good' ? 30 : 0,
            completedDates: {},
            createdAt: DateTime.now(),
            habitType: finalType == 'bad' ? 'bad' : 'good',
          ),
        );
        index++;
      }
      
      // Add suggested habits
      allHabits.addAll(suggestedHabits);
      
      if (!context.mounted) return;
      Navigator.pop(context, allHabits);
    }
  }

  void _skipToHome(BuildContext context) {
    // Convert current habits to Habit objects with user classifications
    final habits = <Habit>[];
    
    for (int i = 0; i < widget.currentHabits.length; i++) {
      final habitData = widget.currentHabits[i];
      final finalType = _userClassifications[i] ?? habitData['type']!;
      
      habits.add(
        Habit(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          name: habitData['name']!,
          icon: _getIconForHabit(finalType),
          category: 'Custom',
          color: _getColorForType(finalType),
          targetMinutes: finalType == 'good' ? 30 : 0,
          completedDates: {},
          createdAt: DateTime.now(),
          habitType: finalType == 'bad' ? 'bad' : 'good',
        ),
      );
    }
    
    Navigator.pop(context, habits);
  }
  
  Future<void> _classifyUncertainHabit(int index, String habitName) async {
    final userOpinion = await showDialog<String>(
      context: context,
      builder: (context) => _ClassifyHabitDialog(habitName: habitName),
    );
    
    if (userOpinion != null) {
      // Show thank you and verification message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cảm ơn! Chúng tôi sẽ kiểm tra lại ý kiến của bạn 🙏'),
            backgroundColor: Color(0xFF6FCF97),
            duration: Duration(seconds: 3),
          ),
        );
      }
      
      // Save user opinion (not classification yet)
      await _saveUserOpinion(habitName, userOpinion);
      
      // Verify the user's opinion
      final verifiedType = await _verifyHabitClassification(habitName, userOpinion);
      
      // Only update if verification succeeds
      if (verifiedType != null && mounted) {
        setState(() {
          _userClassifications[index] = verifiedType;
        });
        
        // Show verification result
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              verifiedType == userOpinion 
                ? 'Xác nhận: "$habitName" là ${verifiedType == "good" ? "thói quen tốt" : "thói quen xấu"} ✅'
                : 'Đã kiểm tra lại phân loại cho "$habitName"',
            ),
            backgroundColor: const Color(0xFF6FCF97),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (mounted) {
        // If verification fails, keep as uncertain
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chưa thể xác minh. Thói quen vẫn ở trạng thái phân vân'),
            backgroundColor: Color(0xFFF2C94C),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  Future<void> _saveUserOpinion(String habitName, String userOpinion) async {
    // Save user's opinion to local storage for future reference
    // This is NOT the final classification, just the user's input
    await HabitContributionService.saveUserOpinion(habitName, userOpinion);
  }
  
  Future<String?> _verifyHabitClassification(String habitName, String userOpinion) async {
    // Step 1: Try to verify using online classification
    try {
      final onlineClassification = await HabitAutoClassifier.classifyHabitOnline(habitName);
      
      // If online classification matches user opinion, accept it
      if (onlineClassification == userOpinion) {
        // Save as verified classification
        await HabitContributionService.saveHabitClassification(habitName, onlineClassification);
        return onlineClassification;
      }
      
      // If online classification is certain (not uncertain), use it instead
      if (onlineClassification != 'uncertain') {
        await HabitContributionService.saveHabitClassification(habitName, onlineClassification);
        return onlineClassification;
      }
      
      // If online is also uncertain, check with built-in database
      final builtInClassification = HabitClassifier.classifyHabit(habitName);
      if (builtInClassification != 'uncertain') {
        await HabitContributionService.saveHabitClassification(habitName, builtInClassification);
        return builtInClassification;
      }
      
      // If still uncertain but user has strong opinion, we can accept after multiple confirmations
      // For now, keep as uncertain
      return null;
      
    } catch (e) {
      // If verification fails, return null to keep as uncertain
      return null;
    }
  }

  String _getIconForHabit(String type) {
    switch (type) {
      case 'good':
        return '✅';
      case 'bad':
        return '⛔';
      default:
        return '📌';
    }
  }

  String _getColorForType(String type) {
    switch (type) {
      case 'good':
        return '#6FCF97';
      case 'bad':
        return '#EB5757';
      default:
        return '#F2C94C';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả phân tích'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    children: [
                      // Success icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '🎯',
                            style: TextStyle(fontSize: 64),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Title
                      Text(
                        'Phân tích hoàn tất!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppDimensions.paddingSmall),

                      Text(
                        'Chúng tôi đã phân tích ${widget.currentHabits.length} thói quen của bạn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppDimensions.paddingXLarge),

                      // Statistics cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: '✅',
                              count: _goodHabitsCount,
                              label: 'Thói quen tốt',
                              color: const Color(0xFF6FCF97),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: _buildStatCard(
                              icon: '⛔',
                              count: _badHabitsCount,
                              label: 'Thói quen xấu',
                              color: const Color(0xFFEB5757),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),

                      if (_uncertainHabitsCount > 0) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _buildStatCard(
                          icon: '❓',
                          count: _uncertainHabitsCount,
                          label: 'Chưa phân loại',
                          color: const Color(0xFFF2C94C),
                          isDarkMode: isDarkMode,
                        ),
                      ],

                      const SizedBox(height: AppDimensions.paddingXLarge),

                      // Message based on results
                      _buildMessage(isDarkMode, context),
                      
                      // Show help message if there are uncertain habits
                      if (_uncertainHabitsCount > 0) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2C94C).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            border: Border.all(
                              color: const Color(0xFFF2C94C).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '🤔',
                                style: TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: AppDimensions.paddingSmall),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thói quen đang ở trạng thái phân vân',
                                      style: TextStyle(
                                        color: Color(0xFFF2C94C),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bạn có thể giúp phân loại $_uncertainHabitsCount thói quen hoặc để chúng tôi tìm hiểu thêm về bạn!',
                                      style: TextStyle(
                                        color: const Color(0xFFF2C94C).withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Habits list
                      _buildHabitsList(isDarkMode),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  children: [
                    if (_badHabitsCount > 0)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _continueToSuggestions(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                          ),
                          child: const Text(
                            'Xem gợi ý thói quen tốt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: AppDimensions.paddingSmall),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _skipToHome(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        child: Text(
                          _badHabitsCount > 0 ? 'Bỏ qua, bắt đầu ngay' : 'Bắt đầu hành trình',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required int count,
    required String label,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(bool isDarkMode, BuildContext context) {
    String message;
    String emoji;
    Color bgColor;

    if (_badHabitsCount == 0 && _goodHabitsCount > 0) {
      emoji = '🎉';
      message = 'Tuyệt vời! Bạn đang có những thói quen rất tốt. Hãy tiếp tục duy trì và phát triển chúng!';
      bgColor = const Color(0xFF6FCF97);
    } else if (_badHabitsCount > _goodHabitsCount) {
      emoji = '💪';
      message = 'Đừng lo lắng! Chúng tôi sẽ giúp bạn thay thế thói quen xấu bằng thói quen tốt. Hành trình thay đổi bắt đầu từ hôm nay!';
      bgColor = const Color(0xFFEB5757);
    } else if (_badHabitsCount > 0) {
      emoji = '🌟';
      message = 'Bạn đang trên con đường đúng! Chúng tôi có một số gợi ý để giúp bạn loại bỏ thói quen xấu.';
      bgColor = AppColors.primary;
    } else {
      emoji = '🚀';
      message = 'Tuyệt vời! Hãy bắt đầu hành trình xây dựng thói quen tốt của bạn!';
      bgColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: bgColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bgColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thói quen của bạn:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        ...List.generate(widget.currentHabits.length, (index) {
          final habit = widget.currentHabits[index];
          final originalType = habit['type']!;
          final currentType = _userClassifications[index] ?? originalType;
          final color = currentType == 'good'
              ? const Color(0xFF6FCF97)
              : currentType == 'bad'
                  ? const Color(0xFFEB5757)
                  : const Color(0xFFF2C94C);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getIconForHabit(currentType),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habit['name']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                // Show classify button for uncertain habits
                if (currentType == 'uncertain')
                  TextButton(
                    onPressed: () => _classifyUncertainHabit(index, habit['name']!),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Giúp phân loại',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFF2C94C),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// Dialog for classifying uncertain habits
class _ClassifyHabitDialog extends StatelessWidget {
  final String habitName;

  const _ClassifyHabitDialog({required this.habitName});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🤝',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'Giúp chúng tôi phân loại',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              '"$habitName"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'Theo bạn, đây là thói quen tốt hay xấu?',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, 'bad'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFEB5757)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '⛔',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Thói quen xấu',
                          style: TextStyle(
                            color: Color(0xFFEB5757),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'good'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF6FCF97),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '✅',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Thói quen tốt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Để sau, tôi vẫn đang phân vân',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
