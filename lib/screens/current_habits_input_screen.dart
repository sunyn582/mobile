import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/habit_classifier.dart';

class CurrentHabitsInputScreen extends StatefulWidget {
  const CurrentHabitsInputScreen({super.key});

  @override
  State<CurrentHabitsInputScreen> createState() => _CurrentHabitsInputScreenState();
}

class _CurrentHabitsInputScreenState extends State<CurrentHabitsInputScreen> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addHabitField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeHabitField(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
      });
    }
  }

  void _continue() async {
    // Kiểm tra ít nhất phải có 1 thói quen
    final habitNames = <String>[];
    
    for (var controller in _controllers) {
      final name = controller.text.trim();
      if (name.isNotEmpty) {
        habitNames.add(name);
      }
    }

    if (habitNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập ít nhất 1 thói quen hiện tại của bạn'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog và phân loại tất cả thói quen
    if (!mounted) return;
    
    final results = await showDialog<List<Map<String, String>>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ClassifyingDialog(habitNames: habitNames),
    );

    if (results != null && mounted) {
      Navigator.pop(context, results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thói quen hiện tại của bạn'),
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
                    const Text(
                      '📝',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Liệt kê thói quen bạn đang có',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      'Chúng tôi sẽ giúp bạn phân loại và đưa ra gợi ý phù hợp',
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                      child: _buildHabitInput(index, isDarkMode),
                    );
                  },
                ),
              ),

              // Add more button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
                child: TextButton.icon(
                  onPressed: _addHabitField,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Thêm thói quen khác'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),

              // Info box
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Expanded(
                        child: Text(
                          'Ví dụ: Tập thể dục, Hút thuốc, Đọc sách, Thức khuya, Uống nước...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingLarge,
                  0,
                  AppDimensions.paddingLarge,
                  AppDimensions.paddingLarge,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: const Text(
                      'Tiếp tục',
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

  Widget _buildHabitInput(int index, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Text field
          Expanded(
            child: TextField(
              controller: _controllers[index],
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'Nhập tên thói quen...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),

          // Remove button
          if (_controllers.length > 1)
            IconButton(
              onPressed: () => _removeHabitField(index),
              icon: const Icon(Icons.close, size: 20),
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}

// Loading dialog that classifies all habits
class _ClassifyingDialog extends StatefulWidget {
  final List<String> habitNames;

  const _ClassifyingDialog({required this.habitNames});

  @override
  State<_ClassifyingDialog> createState() => _ClassifyingDialogState();
}

class _ClassifyingDialogState extends State<_ClassifyingDialog> {
  int _currentIndex = 0;
  final List<Map<String, String>> _results = [];

  @override
  void initState() {
    super.initState();
    _classifyAllHabits();
  }

  Future<void> _classifyAllHabits() async {
    for (int i = 0; i < widget.habitNames.length; i++) {
      setState(() {
        _currentIndex = i;
      });

      final habitName = widget.habitNames[i];
      final type = await HabitClassifier.classifyHabitAsync(habitName);

      _results.add({
        'name': habitName,
        'type': type,
      });

      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // All done, return results
    if (mounted) {
      Navigator.pop(context, _results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final progress = (_currentIndex + 1) / widget.habitNames.length;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🔍',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Title
            Text(
              'Đang phân tích thói quen...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.paddingSmall),

            // Current habit
            Text(
              widget.habitNames[_currentIndex],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDarkMode
                    ? AppColors.darkSurface
                    : Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingSmall),

            // Progress text
            Text(
              '${_currentIndex + 1}/${widget.habitNames.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                  ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Loading indicator
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
