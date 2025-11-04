import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../constants/app_constants.dart';

class OnboardingProfileScreen extends StatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  State<OnboardingProfileScreen> createState() => _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _currentHealthStatusController = TextEditingController();
  
  DateTime? _selectedDate;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicalHistoryController.dispose();
    _currentHealthStatusController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      // Validate current step
      bool isValid = false;
      
      switch (_currentStep) {
        case 0: // Basic Info
          isValid = _nameController.text.trim().isNotEmpty;
          if (!isValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.pleaseEnterName),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          break;
        case 1: // Health Info (optional but need date)
          isValid = _selectedDate != null;
          if (!isValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng chọn ngày sinh'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          break;
      }
      
      setState(() {
        _currentStep++;
      });
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text.trim(),
        bio: 'Building great habits every day',
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        dateOfBirth: _selectedDate,
        height: _heightController.text.trim().isEmpty ? null : double.tryParse(_heightController.text.trim()),
        weight: _weightController.text.trim().isEmpty ? null : double.tryParse(_weightController.text.trim()),
        medicalHistory: _medicalHistoryController.text.trim().isEmpty ? null : _medicalHistoryController.text.trim(),
        currentHealthStatus: _currentHealthStatusController.text.trim().isEmpty ? null : _currentHealthStatusController.text.trim(),
      );

      Navigator.pop(context, profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    children: List.generate(3, (index) {
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
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                          ),
                          child: Text(
                            _currentStep < 2 ? 'Tiếp tục' : 'Hoàn thành',
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
    );
  }

  Widget _buildStepContent(bool isDarkMode) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(isDarkMode);
      case 1:
        return _buildPersonalInfoStep(isDarkMode);
      case 2:
        return _buildHealthInfoStep(isDarkMode);
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào! 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Để bắt đầu hành trình xây dựng thói quen tốt, hãy cho chúng tôi biết về bạn',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        // Name field (required)
        _buildTextField(
          controller: _nameController,
          label: 'Tên của bạn *',
          hint: 'Nhập tên của bạn',
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
          required: true,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Email field (optional)
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'email@example.com',
          icon: Icons.email_outlined,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.emailAddress,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Phone field (optional)
        _buildTextField(
          controller: _phoneController,
          label: 'Số điện thoại',
          hint: '0123456789',
          icon: Icons.phone_outlined,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin cá nhân 📋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Những thông tin này giúp chúng tôi cá nhân hóa trải nghiệm của bạn',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        // Date of birth (required)
        Text(
          'Ngày sinh *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Chọn ngày sinh',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _selectedDate != null
                              ? null
                              : (isDarkMode ? Colors.white54 : Colors.grey),
                        ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Height (optional)
        _buildTextField(
          controller: _heightController,
          label: 'Chiều cao (cm)',
          hint: '170',
          icon: Icons.height,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.number,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Weight (optional)
        _buildTextField(
          controller: _weightController,
          label: 'Cân nặng (kg)',
          hint: '65',
          icon: Icons.monitor_weight_outlined,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildHealthInfoStep(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin sức khỏe 🏥',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          'Những thông tin này giúp chúng tôi đề xuất thói quen phù hợp với bạn (không bắt buộc)',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.paddingXLarge),
        
        // Current health status
        _buildTextField(
          controller: _currentHealthStatusController,
          label: 'Tình trạng sức khỏe hiện tại',
          hint: 'VD: Khỏe mạnh, Đang điều trị...',
          icon: Icons.favorite_outline,
          isDarkMode: isDarkMode,
          maxLines: 2,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Medical history
        _buildTextField(
          controller: _medicalHistoryController,
          label: 'Tiền sử bệnh',
          hint: 'VD: Tiểu đường, cao huyết áp...',
          icon: Icons.medical_information_outlined,
          isDarkMode: isDarkMode,
          maxLines: 3,
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
              Icon(
                Icons.lock_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: Text(
                  'Thông tin của bạn được lưu trữ an toàn và chỉ dùng để cải thiện trải nghiệm',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
            ),
            validator: required
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Trường này là bắt buộc';
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
