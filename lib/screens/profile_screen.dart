import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _isVietnamese = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    'User Name',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    'Building great habits every day',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Settings Section
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Theme Toggle
            Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark theme'),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
                secondary: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                activeTrackColor: AppColors.primary,
              ),
            ),

            // Language Toggle
            Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: SwitchListTile(
                title: Text(_isVietnamese ? 'Tiếng Việt' : 'English'),
                subtitle: Text(_isVietnamese
                    ? 'Chuyển đổi ngôn ngữ'
                    : 'Switch language'),
                value: _isVietnamese,
                onChanged: (value) {
                  setState(() {
                    _isVietnamese = value;
                  });
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
              'About This Project',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Project', 'Habit Tracker App'),
                  const Divider(height: 24),
                  _buildInfoRow('Course', 'Mobile Application Development'),
                  const Divider(height: 24),
                  _buildInfoRow('Student Name', 'Nguyễn Văn A'),
                  const Divider(height: 24),
                  _buildInfoRow('Student ID', '2024XXXX'),
                  const Divider(height: 24),
                  _buildInfoRow('Instructor', 'Giảng viên hướng dẫn'),
                  const Divider(height: 24),
                  _buildInfoRow('Version', '1.0.0'),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // About App
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
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
                              'Habit Tracker',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Build good habits, one day at a time.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    'This project was developed for the Mobile Development course. '
                    'It helps users track and build positive habits through daily consistency.',
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
                    title: const Text('Help & Support'),
                    content: const Text(
                      'For help or support, please contact your instructor or visit the project documentation.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: const Text('Help & Support'),
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
