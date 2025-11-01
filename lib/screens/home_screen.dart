import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import '../widgets/progress_circle.dart';
import '../constants/app_constants.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [
    Habit(
      id: '1',
      name: 'Morning Meditation',
      icon: '🧘',
      category: 'Mind',
      color: '#6FCF97',
      targetMinutes: 15,
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
      completedDates: {
        '2025-10-30': true,
      },
    ),
  ];

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
    return habits.where((habit) => habit.isCompletedOnDate(today)).length;
  }

  double _getTodayProgress() {
    if (habits.isEmpty) return 0;
    return _getCompletedToday() / habits.length;
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
    final updatedHabit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(habit: habit),
      ),
    );

    if (updatedHabit != null) {
      setState(() {
        final index = habits.indexWhere((h) => h.id == habit.id);
        if (index != -1) {
          habits[index] = updatedHabit;
        }
      });
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completedToday = _getCompletedToday();
    final todayProgress = _getTodayProgress();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                      centerText: '$completedToday/${habits.length}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Habits List Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.yourHabits,
                      style: Theme.of(context).textTheme.titleMedium,
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

              // Habits List
              Expanded(
                child: habits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🌱',
                              style: TextStyle(fontSize: 64),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            Text(
                              l10n.noHabitsYet,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppDimensions.paddingSmall),
                            Text(
                              l10n.tapAddNewHabit,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingMedium,
                        ),
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
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
