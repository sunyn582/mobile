import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import '../widgets/progress_circle.dart';
import '../constants/app_constants.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'profile_screen.dart';
import 'bad_habits_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Habit>? initialHabits;
  
  const HomeScreen({super.key, this.initialHabits});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize with provided habits or default habits
    if (widget.initialHabits != null && widget.initialHabits!.isNotEmpty) {
      habits = widget.initialHabits!;
    } else {
      // Load default demo habits
      habits = [
        Habit(
          id: '1',
          name: 'Morning Meditation',
          icon: '🧘',
          category: 'Mind',
          color: '#6FCF97',
          targetMinutes: 15,
          habitType: 'good',
          completedDates: {
            '2025-10-28': true,
            '2025-10-29': true,
            '2025-10-30': true,
          },
        ),
        Habit(
          id: '2',
          name: 'Read Books',
          icon: '📚',
          category: 'Study',
          color: '#2F80ED',
          targetMinutes: 30,
          habitType: 'good',
          completedDates: {
            '2025-10-28': true,
            '2025-10-29': false,
            '2025-10-30': true,
          },
        ),
        Habit(
          id: '3',
          name: 'Drink Water',
          icon: '💧',
          category: 'Health',
          color: '#56CCF2',
          targetMinutes: 5,
          habitType: 'good',
          completedDates: {
            '2025-10-30': true,
          },
        ),
        Habit(
          id: '4',
          name: 'Smoking',
          icon: '🚬',
          category: 'Health',
          color: '#EB5757',
          targetMinutes: 0,
          habitType: 'bad',
          completedDates: {},
          description: 'Hút thuốc gây hại nghiêm trọng cho sức khỏe, ảnh hưởng đến phổi, tim mạch và tăng nguy cơ ung thư.',
        ),
        Habit(
          id: '5',
          name: 'Late Night Social Media',
          icon: '📱',
          category: 'Health',
          color: '#EB5757',
          targetMinutes: 0,
          habitType: 'bad',
          completedDates: {},
          description: 'Sử dụng điện thoại vào ban đêm làm giảm chất lượng giấc ngủ, ảnh hưởng đến sức khỏe tinh thần và thể chất.',
        ),
      ];
    }
  }

  String _getGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n.goodMorning;
    } else if (hour < 18) {
      return l10n.goodAfternoon;
    } else {
      return l10n.goodEvening;
    }
  }

  int _getCompletedToday() {
    final today = DateTime.now();
    // Only count good habits for progress
    final goodHabits = habits.where((h) => h.habitType == 'good');
    return goodHabits.where((habit) => habit.isCompletedOnDate(today)).length;
  }

  double _getTodayProgress() {
    final goodHabits = habits.where((h) => h.habitType == 'good').toList();
    if (goodHabits.isEmpty) return 0;
    return _getCompletedToday() / goodHabits.length;
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      final index = habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        habits[index] = habit.toggleCompletion(DateTime.now());
      }
    });
  }

  void _navigateToAddHabit() async {
    final newHabit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddHabitScreen(),
      ),
    );

    if (newHabit != null) {
      setState(() {
        habits.add(newHabit);
      });
    }
  }

  void _navigateToHabitDetail(Habit habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(habit: habit),
      ),
    );

    if (result == 'delete') {
      // Delete the habit from list
      setState(() {
        habits.removeWhere((h) => h.id == habit.id);
      });
    } else if (result is Habit) {
      // Update the habit
      setState(() {
        final index = habits.indexWhere((h) => h.id == habit.id);
        if (index != -1) {
          habits[index] = result;
        }
      });
    }
  }

  void _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(habits: habits),
      ),
    );
    
    // If result contains new habits, update the habits list
    if (result != null && result is List<Habit>) {
      setState(() {
        // Add new habits to the existing list
        for (var newHabit in result) {
          // Check if habit doesn't already exist
          if (!habits.any((h) => h.id == newHabit.id)) {
            habits.add(newHabit);
          }
        }
      });
      
      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã cập nhật ${result.length} thói quen mới!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Get habits by type
  List<Habit> _getHabitsByType(String type) {
    return habits.where((h) => h.habitType == type).toList();
  }

  // Build bad habits notification banner
  Widget _buildBadHabitsNotification() {
    final badHabits = _getHabitsByType('bad');
    if (badHabits.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BadHabitsScreen(badHabits: badHabits),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Thói quen cần bỏ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${badHabits.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badHabits.map((habit) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(habit.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        habit.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completedToday = _getCompletedToday();
    final todayProgress = _getTodayProgress();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final goodHabits = _getHabitsByType('good');
    final goodHabitsCount = goodHabits.length;

    return Scaffold(
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
              // App Bar
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.myHabits,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: _navigateToProfile,
                      icon: const Icon(Icons.person_outline),
                      style: IconButton.styleFrom(
                        backgroundColor: isDarkMode 
                            ? AppColors.darkCard 
                            : Colors.white,
                        foregroundColor: isDarkMode 
                            ? Colors.white 
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Bad Habits Notification (if any)
              _buildBadHabitsNotification(),

              // Greeting Section
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                  boxShadow: AppShadows.small,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(context),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.keepBuildingHabits,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '🌟',
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Today's Progress
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.todayProgress,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    ProgressCircle(
                      progress: todayProgress,
                      centerText: '$completedToday/$goodHabitsCount',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Good Habits List Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Thói quen tốt',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${goodHabits.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _navigateToAddHabit,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addNew),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingSmall),

              // Good Habits List
              Expanded(
                child: goodHabits.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa có thói quen tốt nào.\nHãy thêm thói quen tốt để bắt đầu!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingMedium,
                        ),
                        itemCount: goodHabits.length,
                        itemBuilder: (context, index) {
                          final habit = goodHabits[index];
                          return HabitCard(
                            habit: habit,
                            onTap: () => _navigateToHabitDetail(habit),
                            onToggle: () => _toggleHabit(habit),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
