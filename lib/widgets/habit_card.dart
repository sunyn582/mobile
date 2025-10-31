import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggle,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.habit.isCompletedOnDate(DateTime.now());
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleToggle() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    
    _controller.forward().then((_) {
      _controller.reverse();
    });
    
    widget.onToggle();
  }

  Color _getColor() {
    try {
      return Color(int.parse(widget.habit.color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final completionRate = widget.habit.getWeeklyCompletionRate();
    final streak = widget.habit.getStreak();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: AppShadows.small,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Center(
                        child: Text(
                          widget.habit.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppDimensions.paddingMedium),
                  
                  // Habit name and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.habit.category,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            if (streak > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '🔥 $streak day${streak > 1 ? 's' : ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Toggle button
                  GestureDetector(
                    onTap: _handleToggle,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isCompleted 
                            ? color 
                            : (isDarkMode ? AppColors.darkSurface : Colors.grey.shade200),
                        shape: BoxShape.circle,
                      ),
                      child: _isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.paddingMedium),
              
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${(completionRate * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completionRate,
                      backgroundColor: isDarkMode 
                          ? AppColors.darkSurface 
                          : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.paddingSmall),
              
              // Time target
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.habit.targetMinutes} mins/day',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
