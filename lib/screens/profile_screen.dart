import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../utils/theme_provider.dart';
import '../utils/language_provider.dart';
import '../utils/user_provider.dart';
import '../utils/health_assessment_service.dart';
import '../models/habit.dart';
import 'theme_loading_screen.dart';
import 'edit_profile_screen.dart';
import 'group_info_screen.dart';
import 'suggested_habits_screen.dart';
import 'health_recommendations_screen.dart';

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

  // Handle reclassify habits based on new profile
  Future<void> _handleReclassifyHabits() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.darkCard 
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Đang phân tích thói quen...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    
    Navigator.pop(context); // Close loading dialog
    
    // Navigate to suggested habits screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuggestedHabitsScreen(),
      ),
    );
    
    if (!mounted) return;
    
    if (result != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thói quen đã được cập nhật thành công!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      
      // Return to home screen or refresh
      Navigator.pop(context);
    }
  }

  // Build health alert banner
  Widget? _buildHealthAlertBanner(bool isDarkMode, UserProvider userProvider) {
    final assessment = HealthAssessmentService.assessHealth(userProvider.userProfile);
    
    // Only show if needs attention
    if (!assessment.needsAttention()) {
      return null;
    }

    final severityColor = Color(
      int.parse(assessment.getSeverityColor().substring(1), radix: 16) + 0xFF000000,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push<List<Habit>>(
              context,
              MaterialPageRoute(
                builder: (context) => HealthRecommendationsScreen(
                  assessment: assessment,
                ),
              ),
            );

            if (result != null && result.isNotEmpty && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm ${result.length} thói quen mới!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: severityColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: severityColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        assessment.getSeverityIcon(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đánh giá sức khỏe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: severityColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assessment.message,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.healing,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Xem gợi ý thói quen để cải thiện sức khỏe',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
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
        const SizedBox(height: AppDimensions.paddingLarge),
      ],
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
                    onTap: () async {
                      final shouldReclassify = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                      
                      if (shouldReclassify == true && mounted) {
                        await _handleReclassifyHabits();
                      }
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
                    onPressed: () async {
                      final shouldReclassify = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                      
                      if (shouldReclassify == true && mounted) {
                        await _handleReclassifyHabits();
                      }
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

            // Health Alert Banner (if needs attention)
            if (_buildHealthAlertBanner(isDarkMode, userProvider) != null)
              _buildHealthAlertBanner(isDarkMode, userProvider)!,

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
