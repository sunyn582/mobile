import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';
import '../constants/habit_data.dart';
import '../utils/habit_classifier.dart';

class OnboardingHabitScreen extends StatefulWidget {
  const OnboardingHabitScreen({super.key});

  @override
  State<OnboardingHabitScreen> createState() => _OnboardingHabitScreenState();
}

class _OnboardingHabitScreenState extends State<OnboardingHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedIcon = '🌱';
  String _selectedCategory = 'Health';
  String _selectedColor = '#6FCF97';
  int _targetMinutes = 15;
  TimeOfDay? _reminderTime;
  bool _isAnalyzing = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }
  
  String _getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Health':
        return l10n.categoryHealth;
      case 'Study':
        return l10n.categoryStudy;
      case 'Mind':
        return l10n.categoryMind;
      case 'Work':
        return l10n.categoryWork;
      case 'Social':
        return l10n.categorySocial;
      case 'Custom':
        return l10n.categoryCustom;
      default:
        return category;
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      // Validate current step
      bool isValid = false;
      
      switch (_currentStep) {
        case 0: // Name
          isValid = _nameController.text.trim().isNotEmpty;
          if (!isValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.pleaseEnterHabitName),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          break;
        case 1: // Category & Icon
        case 2: // Target & Color
        case 3: // Reminder
          isValid = true;
          break;
      }
      
      setState(() {
        _currentStep++;
      });
    } else {
      _saveHabit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      // Show loading screen
      setState(() {
        _isAnalyzing = true;
      });

      // Simulate analysis delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Classify habit
      final habitType = HabitClassifier.classifyHabit(_nameController.text);
      final suggestions = HabitClassifier.findSimilarHabits(_nameController.text);
      
      final suggestedHabitNames = suggestions
          .map((s) => s['displayName'] as String)
          .toList();

      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        icon: _selectedIcon,
        category: _selectedCategory,
        color: _selectedColor,
        targetMinutes: _targetMinutes,
        reminderTime: _reminderTime?.format(context),
        completedDates: {},
        createdAt: DateTime.now(),
        habitType: habitType,
        suggestedHabits: suggestedHabitNames.isNotEmpty ? suggestedHabitNames : null,
      );

      setState(() {
        _isAnalyzing = false;
      });

      if (!mounted) return;
      Navigator.pop(context, habit);
    }
  }

  void _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo thói quen đầu tiên'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: Row(
                        children: List.generate(4, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 4,
                              decoration: BoxDecoration(
                                color: index <= _currentStep
                                    ? AppColors.primary
                                    : (isDarkMode ? AppColors.darkSurface : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                        child: _buildStepContent(isDarkMode),
                      ),
                    ),
                    
                    // Navigation buttons
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousStep,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                  ),
                                ),
                                child: const Text('Quay lại'),
                              ),
                            ),
                          if (_currentStep > 0)
                            const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isAnalyzing ? null : _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getColor(_selectedColor),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                ),
                              ),
                              child: Text(
                                _currentStep < 3 ? 'Tiếp tục' : 'Tạo thói quen',
                                style: const TextStyle(
                                  color: Colors.white,
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
          ),
          
          // Loading Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        'Đang phân tích thói quen...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vui lòng đợi trong giây lát',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent(bool isDarkMode) {
    switch (_currentStep) {
      case 0:
        return _buildNameStep(isDarkMode);
      case 1:
        return _buildCategoryIconStep(isDarkMode);
      case 2:
        return _buildTargetColorStep(isDarkMode);
      case 3:
        return _buildReminderStep(isDarkMode);
      default:
        return Container();
    }
  }

  Widget _buildNameStep(bool isDarkMode) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thói quen của bạn là gì? 🎯',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Hãy đặt tên cho thói quen bạn muốn xây dựng',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.medium,
          ),
          child: TextFormField(
            controller: _nameController,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: l10n.habitNameHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimensions.paddingLarge),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingLarge),
        
        // Examples
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(
                    'Gợi ý:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                '• Đọc sách mỗi ngày\n• Tập thể dục buổi sáng\n• Uống 2 lít nước\n• Thiền 10 phút',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIconStep(bool isDarkMode) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn danh mục và biểu tượng 📂',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Giúp phân loại và dễ nhận biết thói quen',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        // Category
        Text(
          l10n.category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HabitCategories.categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getColor(_selectedColor)
                        : (isDarkMode ? AppColors.darkSurface : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getLocalizedCategory(context, category),
                    style: TextStyle(
                      color: isSelected 
                          ? Colors.white 
                          : (isDarkMode ? Colors.white70 : AppColors.textPrimary),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingLarge),
        
        // Icon
        Text(
          l10n.chooseIcon,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: HabitIcons.availableIcons.map((iconData) {
              final isSelected = _selectedIcon == iconData['emoji'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = iconData['emoji']!;
                  });
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getColor(_selectedColor).withValues(alpha: 0.2)
                        : (isDarkMode ? AppColors.darkSurface : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? _getColor(_selectedColor)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      iconData['emoji']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetColorStep(bool isDarkMode) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mục tiêu và màu sắc 🎨',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Đặt mục tiêu hàng ngày và chọn màu yêu thích',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        // Target minutes
        Text(
          l10n.dailyTarget,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
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
                    '$_targetMinutes ${l10n.minutes}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _getColor(_selectedColor),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('⏱️', style: TextStyle(fontSize: 32)),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Slider(
                value: _targetMinutes.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                activeColor: _getColor(_selectedColor),
                onChanged: (value) {
                  setState(() {
                    _targetMinutes = value.toInt();
                  });
                },
              ),
              Text(
                'Bạn sẽ dành $_targetMinutes phút mỗi ngày cho thói quen này',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingLarge),
        
        // Color picker
        Text(
          l10n.chooseColor,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: HabitColors.availableColors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getColor(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhắc nhở hàng ngày ⏰',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Đặt thời gian nhắc nhở để không bỏ lỡ thói quen (không bắt buộc)',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        GestureDetector(
          onTap: _selectReminderTime,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: AppShadows.medium,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: _getColor(_selectedColor),
                  size: 64,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  _reminderTime != null
                      ? _reminderTime!.format(context)
                      : 'Chưa đặt nhắc nhở',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _getColor(_selectedColor),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  _reminderTime != null
                      ? 'Nhấn để thay đổi thời gian'
                      : 'Nhấn để đặt thời gian nhắc nhở',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingLarge),
        
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: Text(
                  'Bạn có thể bỏ qua bước này và thêm nhắc nhở sau',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
