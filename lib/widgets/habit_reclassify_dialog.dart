import 'package:flutter/material.dart';
import '../models/habit.dart';

/// Dialog to manually reclassify a habit when AI classification is uncertain
class HabitReclassifyDialog extends StatefulWidget {
  final Habit habit;
  final Function(String newType) onReclassify;
  
  const HabitReclassifyDialog({
    super.key,
    required this.habit,
    required this.onReclassify,
  });
  
  @override
  State<HabitReclassifyDialog> createState() => _HabitReclassifyDialogState();
}

class _HabitReclassifyDialogState extends State<HabitReclassifyDialog> {
  String? _selectedType;
  
  @override
  void initState() {
    super.initState();
    _selectedType = widget.habit.habitType;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Text(widget.habit.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Phân loại thói quen',
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habit.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.habit.habitType == 'uncertain')
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hệ thống chưa chắc chắn về thói quen này. Bạn hãy giúp phân loại nhé!',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Đây là thói quen gì?',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Good habit option
            _buildOption(
              type: 'good',
              icon: '✅',
              title: 'Thói quen tốt',
              description: 'Thói quen có lợi, nên duy trì và phát triển',
              color: Colors.green,
            ),
            
            const SizedBox(height: 12),
            
            // Bad habit option
            _buildOption(
              type: 'bad',
              icon: '❌',
              title: 'Thói quen xấu',
              description: 'Thói quen có hại, nên tránh hoặc loại bỏ',
              color: Colors.red,
            ),
            
            const SizedBox(height: 12),
            
            // Uncertain option
            _buildOption(
              type: 'uncertain',
              icon: '❓',
              title: 'Không chắc chắn',
              description: 'Tùy thuộc vào ngữ cảnh và cách thực hiện',
              color: Colors.orange,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _selectedType != null
              ? () {
                  widget.onReclassify(_selectedType!);
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
  
  Widget _buildOption({
    required String type,
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
              ),
          ],
        ),
      ),
    );
  }
}

/// Show reclassify dialog
Future<void> showReclassifyDialog(
  BuildContext context,
  Habit habit,
  Function(String) onReclassify,
) async {
  return showDialog(
    context: context,
    builder: (context) => HabitReclassifyDialog(
      habit: habit,
      onReclassify: onReclassify,
    ),
  );
}
