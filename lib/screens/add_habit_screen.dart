import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';
import '../constants/habit_data.dart';
import '../utils/habit_classifier.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedIcon = '🌱';
  String _selectedCategory = 'Health';
  String _selectedColor = '#6FCF97';
  int _targetMinutes = 15;
  TimeOfDay? _reminderTime;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _selectedIcon = widget.habit!.icon;
      _selectedCategory = widget.habit!.category;
      _selectedColor = widget.habit!.color;
      _targetMinutes = widget.habit!.targetMinutes;
    }
  }

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
        id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        icon: _selectedIcon,
        category: _selectedCategory,
        color: _selectedColor,
        targetMinutes: _targetMinutes,
        reminderTime: _reminderTime?.format(context),
        completedDates: widget.habit?.completedDates ?? {},
        createdAt: widget.habit?.createdAt ?? DateTime.now(),
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
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? l10n.addNewHabit : l10n.editHabit),
        actions: [
          TextButton(
            onPressed: _isAnalyzing ? null : _saveHabit,
            child: Text(l10n.save),
          ),
        ],
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
            child: Form(
              key: _formKey,
              child: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            children: [
              // Habit Name
              Text(
                l10n.habitName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.habitNameHint,
                  prefixIcon: const Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterHabitName;
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Icon Picker
              Text(
                l10n.chooseIcon,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
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

              const SizedBox(height: AppDimensions.paddingLarge),

              // Category Picker
              Text(
                l10n.category,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
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
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Color Picker
              Text(
                l10n.chooseColor,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
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
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Target Minutes
              Text(
                l10n.dailyTarget,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_targetMinutes ${l10n.minutes}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '⏱️',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
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
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Reminder Time
              Text(
                l10n.reminderOptional,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              GestureDetector(
                onTap: _selectReminderTime,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: _getColor(_selectedColor),
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(
                        child: Text(
                          _reminderTime != null
                              ? l10n.remindMeAt(_reminderTime!.format(context))
                              : l10n.setReminderTime,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXLarge),

              // Save Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isAnalyzing ? null : _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getColor(_selectedColor),
                  ),
                  child: Text(
                    widget.habit == null ? l10n.createHabit : l10n.updateHabit,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
}
