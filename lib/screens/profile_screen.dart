import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../utils/theme_provider.dart';
import '../utils/language_provider.dart';
import '../utils/user_provider.dart';
import '../models/habit.dart';
import 'theme_loading_screen.dart';
import 'edit_profile_screen.dart';
import 'group_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  final List<Habit> habits;
  
  const ProfileScreen({super.key, this.habits = const []});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _handleThemeToggle(bool value, ThemeProvider themeProvider) {
    // Show loading screen overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ThemeLoadingScreen(
          isDarkMode: value,
          onComplete: () {
            // Close the dialog
            Navigator.of(context).pop();
            // Toggle the theme
            themeProvider.toggleTheme();
          },
        );
      },
    );
  }

  double? _calculateBMI(double? height, double? weight) {
    if (height != null && weight != null && height > 0) {
      final heightInMeters = height / 100;
      return weight / (heightInMeters * heightInMeters);
    }
    return null;
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Get habits by type
  List<Habit> _getHabitsByType(String type) {
    return widget.habits.where((h) => h.habitType == type).toList();
  }

  // Build habits section with 3 columns
  Widget _buildHabitsSection(bool isDarkMode) {
    final goodHabits = _getHabitsByType('good');
    final badHabits = _getHabitsByType('bad');
    final uncertainHabits = _getHabitsByType('uncertain');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thói quen',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            children: [
              // Column headers
              Row(
                children: [
                  Expanded(
                    child: _buildColumnHeader('Thói quen tốt', Colors.green, goodHabits.length),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildColumnHeader('Thói quen xấu', Colors.red, badHabits.length),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildColumnHeader('Phân vân', Colors.orange, uncertainHabits.length),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Habit items in 3 columns
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHabitColumn(goodHabits, 'Chưa có thói quen tốt'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildHabitColumn(badHabits, 'Chưa có thói quen xấu'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildHabitColumn(uncertainHabits, 'Chưa có thói quen phân vân'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String title, Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitColumn(List<Habit> habits, String emptyMessage) {
    if (habits.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(int.parse(habit.color.substring(1), radix: 16) + 0xFF000000)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(int.parse(habit.color.substring(1), radix: 16) + 0xFF000000)
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Text(habit.icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  habit.name,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileAndSettings),
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
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: userProvider.userProfile.imagePath != null
                                ? Image.file(
                                    File(userProvider.userProfile.imagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                          '👤',
                                          style: TextStyle(fontSize: 48),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      '👤',
                                      style: TextStyle(fontSize: 48),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode ? AppColors.darkCard : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    userProvider.userProfile.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    userProvider.userProfile.bio,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.editProfile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // User Information Section
            Text(
              l10n.personalInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                children: [
                  _buildInfoRow(l10n.name, userProvider.userProfile.name),
                  if (userProvider.userProfile.email?.isNotEmpty ?? false) ...[
                    const Divider(height: 24),
                    _buildInfoRow(l10n.email, userProvider.userProfile.email!),
                  ],
                  if (userProvider.userProfile.phone?.isNotEmpty ?? false) ...[
                    const Divider(height: 24),
                    _buildInfoRow(l10n.phone, userProvider.userProfile.phone!),
                  ],
                  if (userProvider.userProfile.dateOfBirth != null) ...[
                    const Divider(height: 24),
                    _buildInfoRow(
                      l10n.dateOfBirth, 
                      DateFormat('dd/MM/yyyy').format(userProvider.userProfile.dateOfBirth!),
                    ),
                  ],
                  const Divider(height: 24),
                  _buildInfoRow(l10n.bio, userProvider.userProfile.bio),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Health Information Section
            if (userProvider.userProfile.height != null || 
                userProvider.userProfile.weight != null ||
                userProvider.userProfile.medicalHistory != null ||
                userProvider.userProfile.currentHealthStatus != null) ...[
              Text(
                l10n.healthInformation,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),

              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  boxShadow: AppShadows.small,
                ),
                child: Column(
                  children: [
                    if (userProvider.userProfile.height != null) ...[
                      _buildInfoRow(
                        l10n.height, 
                        '${userProvider.userProfile.height!.toStringAsFixed(0)} cm',
                      ),
                    ],
                    if (userProvider.userProfile.weight != null) ...[
                      if (userProvider.userProfile.height != null) const Divider(height: 24),
                      _buildInfoRow(
                        l10n.weight, 
                        '${userProvider.userProfile.weight!.toStringAsFixed(1)} kg',
                      ),
                    ],
                    if (userProvider.userProfile.height != null && 
                        userProvider.userProfile.weight != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        l10n.bmi, 
                        () {
                          final bmi = _calculateBMI(
                            userProvider.userProfile.height, 
                            userProvider.userProfile.weight,
                          );
                          if (bmi != null) {
                            return '${bmi.toStringAsFixed(1)} (${_getBMICategory(bmi)})';
                          }
                          return 'N/A';
                        }(),
                      ),
                    ],
                    if (userProvider.userProfile.currentHealthStatus != null) ...[
                      if (userProvider.userProfile.height != null || 
                          userProvider.userProfile.weight != null) 
                        const Divider(height: 24),
                      _buildInfoRow(
                        l10n.currentHealthStatus, 
                        userProvider.userProfile.currentHealthStatus!,
                      ),
                    ],
                    if (userProvider.userProfile.medicalHistory != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        l10n.medicalHistory, 
                        userProvider.userProfile.medicalHistory!,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),
            ],

            // Habits Section
            if (widget.habits.isNotEmpty) ...[
              _buildHabitsSection(isDarkMode),
              const SizedBox(height: AppDimensions.paddingLarge),
            ],

            // Settings Section
            Text(
              l10n.settings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Theme Toggle
            Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: SwitchListTile(
                title: Text(l10n.darkMode),
                subtitle: Text(l10n.switchTheme),
                value: isDarkMode,
                onChanged: (value) => _handleThemeToggle(value, themeProvider),
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                activeTrackColor: AppColors.primary,
              ),
            ),

            // Language Toggle
            Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: SwitchListTile(
                title: Text(l10n.language),
                subtitle: Text(l10n.switchLanguage),
                value: languageProvider.isVietnamese,
                onChanged: (value) {
                  languageProvider.toggleLanguage();
                },
                secondary: const Icon(
                  Icons.language,
                  color: AppColors.primary,
                ),
                activeTrackColor: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Group Info Button
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(l10n.groupInformation),
                subtitle: Text(l10n.viewProjectDetails),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupInfoScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // About App
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '🌱',
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.appTitle,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${l10n.version}: 1.0.0',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Action Buttons
            OutlinedButton.icon(
              onPressed: () {
                // Show help dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.helpAndSupport),
                    content: Text(l10n.helpMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.ok),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: Text(l10n.helpAndSupport),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
