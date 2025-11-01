import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../utils/theme_provider.dart';
import '../utils/language_provider.dart';
import 'theme_loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '👤',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    l10n.userName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    l10n.buildingHabitsEveryDay,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

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

            // Project Info Section
            Text(
              l10n.aboutThisProject,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(l10n.project, l10n.projectName),
                  const Divider(height: 24),
                  _buildInfoRow(l10n.course, l10n.courseName),
                  const Divider(height: 24),
                  _buildInfoRow(l10n.studentName, l10n.studentNamePlaceholder),
                  const Divider(height: 24),
                  _buildInfoRow(l10n.studentId, l10n.studentIdPlaceholder),
                  const Divider(height: 24),
                  _buildInfoRow(l10n.instructor, l10n.instructorPlaceholder),
                  const Divider(height: 24),
                  _buildInfoRow(l10n.version, '1.0.0'),
                ],
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
                                  l10n.welcomeSlogan,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    l10n.aboutApp,
                    style: Theme.of(context).textTheme.bodyMedium,
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
