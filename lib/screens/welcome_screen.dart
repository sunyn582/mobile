import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../models/user_profile.dart';
import '../models/habit.dart';
import '../utils/user_provider.dart';
import '../utils/user_storage_service.dart';
import '../utils/habit_storage_service.dart';
import 'home_screen.dart';
import 'onboarding_profile_screen.dart';
import 'current_habits_input_screen.dart';
import 'habit_analysis_result_screen.dart';

/// HƯỚNG DẪN CHUYỂN ĐỔI GIỮA 3 TÀI KHOẢN TRONG CODE:
/// 
/// 1. TÀI KHOẢN ĐANG DÙNG (Current User):
///    - await UserStorageService.getCurrentUser()
///    - await UserStorageService.saveCurrentUser(profile)
/// 
/// 2. TÀI KHOẢN CŨ (Previous User):
///    - await UserStorageService.getPreviousUser()
///    - Tự động được backup khi lưu người mới
/// 
/// 3. CHUYỂN ĐỔI TÀI KHOẢN:
///    - Chuyển từ cũ sang hiện tại:
///      await UserStorageService.switchToPreviousUser()
/// 
/// 4. XÓA TẤT CẢ TÀI KHOẢN (reset):
///    - await UserStorageService.clearAllUserData()
/// 
/// 5. KIỂM TRA TỒN TẠI:
///    - await UserStorageService.hasUserProfile()
///    - await UserStorageService.hasPreviousUser()

class WelcomeScreen extends StatefulWidget {
  final bool isFirstTime;
  
  const WelcomeScreen({super.key, required this.isFirstTime});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _nameController = TextEditingController();
  UserProfile? _existingProfile;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _loadExistingProfile();
  }
  
  Future<void> _loadExistingProfile() async {
    if (!widget.isFirstTime) {
      // Load người đang dùng hiện tại
      final profile = await UserStorageService.getCurrentUser();
      
      // DEBUG: Uncomment để xem thông tin người cũ
      // final previousProfile = await UserStorageService.getPreviousUser();
      // print('Current User: ${profile?.name}');
      // print('Previous User: ${previousProfile?.name}');
      
      if (mounted) {
        setState(() {
          _existingProfile = profile;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continueAsExistingUser() async {
    if (_existingProfile != null) {
      // Lưu lại thông tin và chuyển sang HomeScreen
      await UserStorageService.markAsReturningUser();
      await UserStorageService.saveCurrentUser(_existingProfile!);
      
      if (mounted) {
        context.read<UserProvider>().updateProfile(_existingProfile!);
        _navigateToHome();
      }
    }
  }
  
  void _showNewProfileInput() {
    // Navigate to onboarding flow for new users
    _startOnboardingFlow();
  }
  
  Future<void> _startOnboardingFlow() async {
    // Step 1: Get user profile info
    final profile = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingProfileScreen(),
      ),
    );
    
    if (profile == null) return; // User cancelled
    
    // Step 2: Get current habits (REQUIRED - không thể bỏ qua)
    if (!mounted) return;
    final currentHabits = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(
        builder: (context) => const CurrentHabitsInputScreen(),
      ),
    );
    
    if (currentHabits == null || currentHabits.isEmpty) {
      // User cancelled or didn't input any habits - show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần nhập ít nhất 1 thói quen để tiếp tục'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    // Step 3: Show analysis result and suggestions
    if (!mounted) return;
    final selectedHabits = await Navigator.push<List<Habit>>(
      context,
      MaterialPageRoute(
        builder: (context) => HabitAnalysisResultScreen(currentHabits: currentHabits),
      ),
    );
    
    // Save profile and continue to home with habits
    await _saveProfileAndContinue(profile, selectedHabits ?? []);
  }
  
  Future<void> _saveProfileAndContinue(UserProfile profile, List<Habit> habits) async {
    // Check if this is a new user (different from current user)
    final currentUser = await UserStorageService.getCurrentUser();
    
    if (currentUser != null && currentUser.name != profile.name) {
      // This is a NEW user, clear old habits from previous user
      await HabitStorageService.clearAllHabits();
    }
    
    // Save profile
    await UserStorageService.markAsReturningUser();
    await UserStorageService.saveCurrentUser(profile);
    
    if (mounted) {
      context.read<UserProvider>().updateProfile(profile);
      _navigateToHome(initialHabits: habits);
    }
  }

  void _navigateToHome({List<Habit>? initialHabits}) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeScreen(initialHabits: initialHabits),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo with scale animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: AppShadows.large,
                    ),
                    child: const Center(
                      child: Text(
                        '🌱',
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingXLarge),
                
                // App name or Welcome back message
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.isFirstTime 
                        ? AppLocalizations.of(context)!.appTitle
                        : AppLocalizations.of(context)!.welcomeBack,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingMedium),
                
                // Slogan with fade animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    AppLocalizations.of(context)!.welcomeSlogan,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const Spacer(),
                
                // Nội dung khác nhau cho người dùng mới vs cũ
                if (widget.isFirstTime)
                  _buildFirstTimeWelcome(isDarkMode)
                else
                  _buildReturningUserContent(isDarkMode),
                
                const SizedBox(height: AppDimensions.paddingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Nội dung cho người dùng lần đầu
  Widget _buildFirstTimeWelcome(bool isDarkMode) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Welcome message
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: AppShadows.medium,
            ),
            child: Column(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 48)),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  'Chào mừng bạn đến với Habit Tracker!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  'Bắt đầu xây dựng thói quen tốt ngay hôm nay',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Start button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startOnboardingFlow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.letsStart,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Nội dung cho người dùng đã từng dùng
  Widget _buildReturningUserContent(bool isDarkMode) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Hiển thị thông tin người dùng
          if (_existingProfile != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: AppShadows.medium,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      _existingProfile!.name[0].toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _existingProfile!.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _existingProfile!.bio,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingMedium),
            
            // Nút "Tiếp tục"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _continueAsExistingUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.continueAsUser(_existingProfile!.name),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingSmall),
            
            // Nút "Tạo hồ sơ mới"
            TextButton(
              onPressed: _showNewProfileInput,
              child: Text(
                AppLocalizations.of(context)!.createNewProfile,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
