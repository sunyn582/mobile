import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../constants/app_constants.dart';
import '../utils/health_assessment_service.dart';

class HealthRecommendationsScreen extends StatefulWidget {
  final HealthAssessment assessment;

  const HealthRecommendationsScreen({
    super.key,
    required this.assessment,
  });

  @override
  State<HealthRecommendationsScreen> createState() =>
      _HealthRecommendationsScreenState();
}

class _HealthRecommendationsScreenState
    extends State<HealthRecommendationsScreen> {
  final Set<String> _selectedHabitIds = {};
  late List<Map<String, dynamic>> _suggestedHabits;

  @override
  void initState() {
    super.initState();
    _suggestedHabits = HealthAssessmentService.getSuggestedHabits(widget.assessment);
  }

  Color _getSeverityColor() {
    return Color(
      int.parse(widget.assessment.getSeverityColor().substring(1), radix: 16) +
          0xFF000000,
    );
  }

  void _toggleHabit(String habitId) {
    setState(() {
      if (_selectedHabitIds.contains(habitId)) {
        _selectedHabitIds.remove(habitId);
      } else {
        _selectedHabitIds.add(habitId);
      }
    });
  }

  void _addToSchedule() {
    // Create habits from selected items
    final selectedHabits = <Habit>[];
    int index = 0;

    for (var habitData in _suggestedHabits) {
      final habitId = 'health_${habitData['name']}';
      if (_selectedHabitIds.contains(habitId)) {
        selectedHabits.add(
          Habit(
            id: '${DateTime.now().millisecondsSinceEpoch}_$index',
            name: habitData['name'],
            icon: habitData['icon'],
            category: habitData['category'],
            color: habitData['color'],
            targetMinutes: habitData['minutes'],
            completedDates: {},
            createdAt: DateTime.now(),
            habitType: 'good',
            description: habitData['description'],
          ),
        );
        index++;
      }
    }

    Navigator.pop(context, selectedHabits);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final severityColor = _getSeverityColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá sức khỏe'),
        backgroundColor: severityColor,
        foregroundColor: Colors.white,
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
        child: Column(
          children: [
            // Health Status Card
            _buildHealthStatusCard(isDarkMode, severityColor),

            // Recommendations List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                children: [
                  // General Recommendations
                  _buildRecommendationsSection(isDarkMode),

                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Suggested Habits Header
                  Row(
                    children: [
                      Text(
                        'Thói quen được gợi ý',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_suggestedHabits.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn thói quen bạn muốn thêm vào lịch trình',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),

                  // Suggested Habits List
                  ..._suggestedHabits.map((habitData) {
                    final habitId = 'health_${habitData['name']}';
                    final isSelected = _selectedHabitIds.contains(habitId);
                    return _buildHabitCard(
                      habitData: habitData,
                      habitId: habitId,
                      isSelected: isSelected,
                      isDarkMode: isDarkMode,
                    );
                  }),
                ],
              ),
            ),

            // Bottom Action Bar
            _buildBottomActionBar(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatusCard(bool isDarkMode, Color severityColor) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.small,
        border: Border.all(color: severityColor, width: 2),
      ),
      child: Column(
        children: [
          // Icon and Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.assessment.getSeverityIcon(),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đánh giá sức khỏe',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.assessment.message,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // BMI and Age Info
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'BMI',
                  widget.assessment.bmi?.toStringAsFixed(1) ?? 'N/A',
                  widget.assessment.getBMICategoryText(),
                  Icons.monitor_weight,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildInfoItem(
                  'Tuổi',
                  '${widget.assessment.age ?? 'N/A'}',
                  widget.assessment.getAgeGroupText(),
                  Icons.cake,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String category, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          category,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(bool isDarkMode) {
    return Container(
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
              const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Khuyến nghị',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.assessment.recommendations.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHabitCard({
    required Map<String, dynamic> habitData,
    required String habitId,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    final color = Color(
      int.parse(habitData['color'].substring(1), radix: 16) + 0xFF000000,
    );

    return GestureDetector(
      onTap: () => _toggleHabit(habitId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.small,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  habitData['icon'],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.paddingMedium),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habitData['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? color : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habitData['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Skip Button
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, <Habit>[]),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Bỏ qua'),
              ),
            ),

            const SizedBox(width: AppDimensions.paddingMedium),

            // Add to Schedule Button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _selectedHabitIds.isEmpty ? null : _addToSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  _selectedHabitIds.isEmpty
                      ? 'Chọn thói quen'
                      : 'Thêm ${_selectedHabitIds.length} thói quen',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
