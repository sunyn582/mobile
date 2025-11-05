import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ThemeLoadingScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onComplete;
  final String? loadingText;
  final Duration? duration;

  const ThemeLoadingScreen({
    super.key,
    required this.isDarkMode,
    required this.onComplete,
    this.loadingText,
    this.duration,
  });

  @override
  State<ThemeLoadingScreen> createState() => _ThemeLoadingScreenState();
}

class _ThemeLoadingScreenState extends State<ThemeLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    final animationDuration = widget.duration ?? const Duration(milliseconds: 2000);
    
    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Wait for specified duration then complete
    final completeDuration = widget.duration ?? const Duration(seconds: 3);
    Future.delayed(completeDuration, () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode 
        ? AppColors.darkBackground 
        : AppColors.background;
    final textColor = widget.isDarkMode ? Colors.white : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.isDarkMode
              ? const LinearGradient(
                  colors: [AppColors.darkBackground, Color(0xFF2D2D2D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : AppColors.backgroundGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: widget.isDarkMode 
                          ? AppColors.darkCard 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: widget.isDarkMode
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : AppShadows.large,
                    ),
                    child: const Center(
                      child: Text(
                        '🌱',
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isDarkMode 
                          ? AppColors.primary 
                          : AppColors.primary,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Loading text
                Text(
                  widget.loadingText ?? 
                  (widget.isDarkMode 
                      ? 'Switching to Dark Mode...' 
                      : 'Switching to Light Mode...'),
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
