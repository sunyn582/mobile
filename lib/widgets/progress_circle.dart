import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;
  final double size;
  final String centerText;
  final Color? color;

  const ProgressCircle({
    super.key,
    required this.progress,
    this.size = 120,
    this.centerText = '',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.grey.shade200,
              ),
            ),
          ),
          
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: progress,
              ),
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? AppColors.primary,
                  ),
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          
          // Center text
          if (centerText.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Complete',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
