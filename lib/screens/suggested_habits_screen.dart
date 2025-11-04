import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';
import '../constants/habit_data.dart';
import 'onboarding_habit_screen.dart';

class SuggestedHabitsScreen extends StatefulWidget {
  const SuggestedHabitsScreen({super.key});

  @override
  State<SuggestedHabitsScreen> createState() => _SuggestedHabitsScreenState();
}

class _SuggestedHabitsScreenState extends State<SuggestedHabitsScreen> {
  final Set<String> _selectedHabitIds = {};
  String _selectedCategory = 'All';
  String _selectedType = 'good'; // 'good' or 'bad'

  // Danh sách thói quen TỐT gợi ý phân theo danh mục
  final Map<String, List<Map<String, dynamic>>> _suggestedGoodHabits = {
    'Health': [
      {
        'name': 'Uống 2 lít nước mỗi ngày',
        'icon': '💧',
        'color': '#56CCF2',
        'minutes': 5,
        'description': 'Duy trì độ ẩm cho cơ thể, cải thiện da và tiêu hóa',
      },
      {
        'name': 'Tập thể dục 30 phút',
        'icon': '🏃',
        'color': '#6FCF97',
        'minutes': 30,
        'description': 'Tăng cường sức khỏe tim mạch và thể lực',
      },
      {
        'name': 'Ngủ đủ 8 tiếng',
        'icon': '😴',
        'color': '#BB6BD9',
        'minutes': 480,
        'description': 'Phục hồi năng lượng và cải thiện sức khỏe tinh thần',
      },
      {
        'name': 'Ăn rau củ mỗi bữa',
        'icon': '🥗',
        'color': '#6FCF97',
        'minutes': 15,
        'description': 'Cung cấp vitamin và chất xơ cho cơ thể',
      },
      {
        'name': 'Đi bộ 10,000 bước',
        'icon': '🚶',
        'color': '#F2994A',
        'minutes': 60,
        'description': 'Cải thiện tuần hoàn và sức khỏe tổng thể',
      },
    ],
    'Mind': [
      {
        'name': 'Thiền 10 phút',
        'icon': '🧘',
        'color': '#9B51E0',
        'minutes': 10,
        'description': 'Giảm stress và tăng khả năng tập trung',
      },
      {
        'name': 'Viết nhật ký',
        'icon': '📔',
        'color': '#F2C94C',
        'minutes': 15,
        'description': 'Ghi lại suy nghĩ và cảm xúc, tự soi chiếu',
      },
      {
        'name': 'Thực hành biết ơn',
        'icon': '🙏',
        'color': '#EB5757',
        'minutes': 5,
        'description': 'Ghi lại 3 điều biết ơn mỗi ngày',
      },
      {
        'name': 'Ngắt kết nối thiết bị',
        'icon': '📵',
        'color': '#828282',
        'minutes': 30,
        'description': 'Tránh xa điện thoại trước khi ngủ',
      },
    ],
    'Study': [
      {
        'name': 'Đọc sách 20 phút',
        'icon': '📚',
        'color': '#2F80ED',
        'minutes': 20,
        'description': 'Mở rộng kiến thức và từ vựng',
      },
      {
        'name': 'Học ngoại ngữ',
        'icon': '🗣️',
        'color': '#56CCF2',
        'minutes': 30,
        'description': 'Luyện tập từ vựng và ngữ pháp hàng ngày',
      },
      {
        'name': 'Xem khóa học online',
        'icon': '💻',
        'color': '#2F80ED',
        'minutes': 45,
        'description': 'Học kỹ năng mới hoặc phát triển chuyên môn',
      },
      {
        'name': 'Nghe podcast',
        'icon': '🎧',
        'color': '#F2994A',
        'minutes': 25,
        'description': 'Học hỏi từ chuyên gia và người thành công',
      },
    ],
    'Work': [
      {
        'name': 'Lập kế hoạch ngày mới',
        'icon': '📝',
        'color': '#2F80ED',
        'minutes': 10,
        'description': 'Sắp xếp công việc ưu tiên cho ngày',
      },
      {
        'name': 'Deep work 2 tiếng',
        'icon': '🎯',
        'color': '#EB5757',
        'minutes': 120,
        'description': 'Tập trung cao độ không bị phân tâm',
      },
      {
        'name': 'Dọn dẹp bàn làm việc',
        'icon': '🗂️',
        'color': '#F2C94C',
        'minutes': 10,
        'description': 'Giữ không gian làm việc gọn gàng',
      },
    ],
    'Social': [
      {
        'name': 'Gọi điện cho người thân',
        'icon': '📞',
        'color': '#EB5757',
        'minutes': 15,
        'description': 'Duy trì kết nối với gia đình',
      },
      {
        'name': 'Gặp gỡ bạn bè',
        'icon': '👥',
        'color': '#F2994A',
        'minutes': 60,
        'description': 'Xây dựng và nuôi dưỡng tình bạn',
      },
      {
        'name': 'Giúp đỡ người khác',
        'icon': '🤝',
        'color': '#6FCF97',
        'minutes': 30,
        'description': 'Làm việc tình nguyện hoặc giúp đỡ cộng đồng',
      },
    ],
  };
  
  // Danh sách thói quen XẤU cần loại bỏ
  final Map<String, List<Map<String, dynamic>>> _suggestedBadHabits = {
    'Health': [
      {
        'name': 'Hút thuốc',
        'icon': '🚬',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Gây hại nghiêm trọng cho phổi, tim mạch và tăng nguy cơ ung thư',
      },
      {
        'name': 'Ăn đồ ăn nhanh thường xuyên',
        'icon': '🍔',
        'color': '#F2994A',
        'minutes': 0,
        'description': 'Tăng nguy cơ béo phì, tiểu đường và bệnh tim mạch',
      },
      {
        'name': 'Ngồi quá nhiều',
        'icon': '🪑',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Ảnh hưởng xấu đến cột sống và sức khỏe tổng thể',
      },
      {
        'name': 'Thức khuya',
        'icon': '🌙',
        'color': '#BB6BD9',
        'minutes': 0,
        'description': 'Làm giảm chất lượng giấc ngủ và sức khỏe',
      },
      {
        'name': 'Uống nhiều nước ngọt',
        'icon': '🥤',
        'color': '#F2994A',
        'minutes': 0,
        'description': 'Tăng nguy cơ tiểu đường và các vấn đề sức khỏe',
      },
    ],
    'Mind': [
      {
        'name': 'Lướt mạng xã hội quá nhiều',
        'icon': '📱',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Gây phân tâm, giảm năng suất và ảnh hưởng sức khỏe tinh thần',
      },
      {
        'name': 'Nghĩ tiêu cực',
        'icon': '😔',
        'color': '#828282',
        'minutes': 0,
        'description': 'Ảnh hưởng đến tâm trạng và sức khỏe tinh thần',
      },
      {
        'name': 'Trì hoãn công việc',
        'icon': '⏰',
        'color': '#F2994A',
        'minutes': 0,
        'description': 'Gây stress và giảm hiệu suất công việc',
      },
      {
        'name': 'Lo lắng quá mức',
        'icon': '😰',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Gây căng thẳng và ảnh hưởng sức khỏe tâm lý',
      },
    ],
    'Work': [
      {
        'name': 'Làm việc không tập trung',
        'icon': '💭',
        'color': '#F2C94C',
        'minutes': 0,
        'description': 'Giảm năng suất và chất lượng công việc',
      },
      {
        'name': 'Không lập kế hoạch',
        'icon': '❌',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Dẫn đến lãng phí thời gian và hiệu quả thấp',
      },
      {
        'name': 'Làm việc quá sức',
        'icon': '💼',
        'color': '#828282',
        'minutes': 0,
        'description': 'Gây kiệt sức và mất cân bằng cuộc sống',
      },
    ],
    'Social': [
      {
        'name': 'Cô lập bản thân',
        'icon': '🚪',
        'color': '#828282',
        'minutes': 0,
        'description': 'Ảnh hưởng đến sức khỏe tinh thần và mối quan hệ',
      },
      {
        'name': 'Nói xấu sau lưng',
        'icon': '🗣️',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Phá hủy mối quan hệ và uy tín cá nhân',
      },
      {
        'name': 'Phủ định người khác',
        'icon': '👎',
        'color': '#F2994A',
        'minutes': 0,
        'description': 'Gây mất lòng tin và ảnh hưởng quan hệ',
      },
    ],
    'Study': [
      {
        'name': 'Không đọc sách',
        'icon': '📚',
        'color': '#828282',
        'minutes': 0,
        'description': 'Giới hạn kiến thức và khả năng phát triển',
      },
      {
        'name': 'Học tủ không hiểu',
        'icon': '📖',
        'color': '#F2994A',
        'minutes': 0,
        'description': 'Lãng phí thời gian và không hiệu quả',
      },
      {
        'name': 'Không ghi chú',
        'icon': '✍️',
        'color': '#EB5757',
        'minutes': 0,
        'description': 'Khó nhớ và ôn tập kiến thức',
      },
    ],
  };

  List<String> get _categories {
    return ['All', ...HabitCategories.categories];
  }

  Map<String, List<Map<String, dynamic>>> get _currentHabitMap {
    return _selectedType == 'good' ? _suggestedGoodHabits : _suggestedBadHabits;
  }

  List<Map<String, dynamic>> get _filteredHabits {
    if (_selectedCategory == 'All') {
      return _currentHabitMap.values.expand((list) => list).toList();
    }
    return _currentHabitMap[_selectedCategory] ?? [];
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
      case 'All':
        return 'Tất cả';
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
      default:
        return category;
    }
  }

  void _toggleHabit(String habitId) {
    setState(() {
      if (_selectedHabitIds.contains(habitId)) {
        _selectedHabitIds.remove(habitId);
      } else {
        _selectedHabitIds.add(habitId);
      }
    });
  }

  void _continueWithSelectedHabits() {
    // Allow continuing even with 0 habits selected
    // User can add habits later from HomeScreen
    
    // Tạo danh sách habits từ các thói quen đã chọn
    final selectedHabits = <Habit>[];
    int index = 0;
    
    // Process good habits
    for (var entry in _suggestedGoodHabits.entries) {
      for (var habitData in entry.value) {
        final habitId = 'good_${entry.key}_${habitData['name']}';
        if (_selectedHabitIds.contains(habitId)) {
          selectedHabits.add(
            Habit(
              id: '${DateTime.now().millisecondsSinceEpoch}_$index',
              name: habitData['name'],
              icon: habitData['icon'],
              category: entry.key,
              color: habitData['color'],
              targetMinutes: habitData['minutes'],
              completedDates: {},
              createdAt: DateTime.now(),
              habitType: 'good',
              description: habitData['description'],
            ),
          );
          index++;
        }
      }
    }
    
    // Process bad habits
    for (var entry in _suggestedBadHabits.entries) {
      for (var habitData in entry.value) {
        final habitId = 'bad_${entry.key}_${habitData['name']}';
        if (_selectedHabitIds.contains(habitId)) {
          selectedHabits.add(
            Habit(
              id: '${DateTime.now().millisecondsSinceEpoch}_$index',
              name: habitData['name'],
              icon: habitData['icon'],
              category: entry.key,
              color: habitData['color'],
              targetMinutes: habitData['minutes'],
              completedDates: {},
              createdAt: DateTime.now(),
              habitType: 'bad',
              description: habitData['description'],
            ),
          );
          index++;
        }
      }
    }

    Navigator.pop(context, selectedHabits);
  }

  void _skipSuggestions() {
    Navigator.pop(context, <Habit>[]);
  }
  
  Future<void> _createCustomHabit() async {
    final habit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingHabitScreen(),
      ),
    );
    
    if (habit != null) {
      // Return the custom habit as a single-item list
      if (mounted) {
        Navigator.pop(context, [habit]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedType == 'good' ? 'Chọn thói quen tốt' : 'Chọn thói quen cần loại bỏ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipSuggestions,
            child: Text(
              'Bỏ qua',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ),
        ],
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
                    Text(
                      'Bắt đầu hành trình của bạn 🎯',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      _selectedType == 'good'
                          ? 'Chọn thói quen tốt bạn muốn xây dựng và thói quen xấu bạn muốn loại bỏ'
                          : 'Chọn thói quen xấu bạn muốn loại bỏ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    
                    // Selected count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Đã chọn: ${_selectedHabitIds.length} thói quen',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Type selector (Good/Bad habits)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = 'good';
                            _selectedCategory = 'All';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == 'good'
                                ? AppColors.primary
                                : (isDarkMode ? AppColors.darkCard : Colors.white),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: _selectedType == 'good'
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '✅ ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Thói quen tốt',
                                style: TextStyle(
                                  color: _selectedType == 'good'
                                      ? Colors.white
                                      : (isDarkMode ? Colors.white70 : AppColors.textPrimary),
                                  fontWeight: _selectedType == 'good'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = 'bad';
                            _selectedCategory = 'All';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == 'bad'
                                ? const Color(0xFFEB5757)
                                : (isDarkMode ? AppColors.darkCard : Colors.white),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: _selectedType == 'bad'
                                  ? const Color(0xFFEB5757)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '⛔ ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Thói quen xấu',
                                style: TextStyle(
                                  color: _selectedType == 'bad'
                                      ? Colors.white
                                      : (isDarkMode ? Colors.white70 : AppColors.textPrimary),
                                  fontWeight: _selectedType == 'bad'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingMedium),

              // Category filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_getLocalizedCategory(context, category)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: isDarkMode ? AppColors.darkCard : Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDarkMode ? Colors.white70 : AppColors.textPrimary),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppDimensions.paddingSmall),

              // Habits list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: _filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habitData = _filteredHabits[index];
                    // Find category for this habit
                    String category = 'Custom';
                    for (var entry in _currentHabitMap.entries) {
                      if (entry.value.contains(habitData)) {
                        category = entry.key;
                        break;
                      }
                    }
                    final habitId = '${_selectedType}_${category}_${habitData['name']}';
                    final isSelected = _selectedHabitIds.contains(habitId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                      child: _buildHabitCard(
                        habitData: habitData,
                        habitId: habitId,
                        isSelected: isSelected,
                        isDarkMode: isDarkMode,
                      ),
                    );
                  },
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  children: [
                    // Main button - Continue with selected habits
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _continueWithSelectedHabits,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        child: Text(
                          _selectedHabitIds.isEmpty
                              ? 'Tiếp tục (Thêm sau)'
                              : 'Bắt đầu với ${_selectedHabitIds.length} thói quen',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingSmall),
                    
                    // Secondary button - Create custom habit
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _createCustomHabit,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        child: const Text(
                          'Tự tạo thói quen của riêng tôi',
                          style: TextStyle(
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

  Widget _buildHabitCard({
    required Map<String, dynamic> habitData,
    required String habitId,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    final color = _getColor(habitData['color']);

    return GestureDetector(
      onTap: () => _toggleHabit(habitId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.small,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  habitData['icon'],
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.paddingMedium),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habitData['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? color : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habitData['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDarkMode ? Colors.white60 : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habitData['minutes']} phút/ngày',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDarkMode ? Colors.white60 : AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
