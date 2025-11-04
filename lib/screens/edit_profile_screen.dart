import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../utils/theme_provider.dart';
import '../utils/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _healthStatusController;
  DateTime? _selectedDateOfBirth;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.userProfile.name);
    _bioController = TextEditingController(text: userProvider.userProfile.bio);
    _emailController = TextEditingController(text: userProvider.userProfile.email ?? '');
    _phoneController = TextEditingController(text: userProvider.userProfile.phone ?? '');
    _medicalHistoryController = TextEditingController(text: userProvider.userProfile.medicalHistory ?? '');
    _heightController = TextEditingController(text: userProvider.userProfile.height?.toString() ?? '');
    _weightController = TextEditingController(text: userProvider.userProfile.weight?.toString() ?? '');
    _healthStatusController = TextEditingController(text: userProvider.userProfile.currentHealthStatus ?? '');
    _selectedDateOfBirth = userProvider.userProfile.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _medicalHistoryController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _showImageSourceDialog(BuildContext context, UserProvider userProvider) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                  title: Text(l10n.takePhoto),
                  onTap: () async {
                    Navigator.pop(context);
                    await userProvider.takePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.primary),
                  title: Text(l10n.chooseFromGallery),
                  onTap: () async {
                    Navigator.pop(context);
                    await userProvider.pickImageFromGallery();
                  },
                ),
                if (userProvider.userProfile.imagePath != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: Text(l10n.removePhoto),
                    onTap: () async {
                      Navigator.pop(context);
                      await userProvider.removeProfileImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateProfileFields(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        medicalHistory: _medicalHistoryController.text.trim().isEmpty ? null : _medicalHistoryController.text.trim(),
        height: _heightController.text.trim().isEmpty ? null : double.tryParse(_heightController.text.trim()),
        weight: _weightController.text.trim().isEmpty ? null : double.tryParse(_weightController.text.trim()),
        currentHealthStatus: _healthStatusController.text.trim().isEmpty ? null : _healthStatusController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              l10n.save,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
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
                                        style: TextStyle(fontSize: 56),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    '👤',
                                    style: TextStyle(fontSize: 56),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showImageSourceDialog(context, userProvider),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                TextButton.icon(
                  onPressed: () => _showImageSourceDialog(context, userProvider),
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.changePhoto),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Name Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterName;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      hintText: l10n.emailHint,
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return l10n.pleaseEnterValidEmail;
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Phone Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phone,
                      hintText: l10n.phoneHint,
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Bio Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: l10n.bio,
                      prefixIcon: const Icon(Icons.edit_note, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterBio;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Date of Birth Field
                GestureDetector(
                  onTap: () => _selectDateOfBirth(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      boxShadow: AppShadows.small,
                    ),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: l10n.dateOfBirth,
                          hintText: l10n.selectDate,
                          prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                        ),
                        controller: TextEditingController(
                          text: _selectedDateOfBirth != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedDateOfBirth!)
                              : '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Height Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.height,
                      hintText: l10n.heightHint,
                      prefixIcon: const Icon(Icons.height, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Weight Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.weight,
                      hintText: l10n.weightHint,
                      prefixIcon: const Icon(Icons.monitor_weight, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Medical History Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _medicalHistoryController,
                    decoration: InputDecoration(
                      labelText: l10n.medicalHistory,
                      hintText: l10n.medicalHistoryHint,
                      prefixIcon: const Icon(Icons.medical_information, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Current Health Status Field
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: AppShadows.small,
                  ),
                  child: TextFormField(
                    controller: _healthStatusController,
                    decoration: InputDecoration(
                      labelText: l10n.currentHealthStatus,
                      hintText: l10n.healthStatusHint,
                      prefixIcon: const Icon(Icons.favorite, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? AppColors.darkCard : Colors.white,
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXLarge),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: Text(
                      l10n.saveChanges,
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
      ),
    );
  }
}
