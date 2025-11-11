import 'package:flutter/material.dart';

class AssessmentQuestionCard extends StatelessWidget {
  const AssessmentQuestionCard({
    super.key,
    required this.prompt,
    required this.minLabel,
    required this.maxLabel,
    required this.value,
    required this.onChanged,
  });

  final String prompt;
  final String minLabel;
  final String maxLabel;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prompt, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minLabel, style: Theme.of(context).textTheme.bodySmall),
                Text(maxLabel, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Slider(
              value: value,
              onChanged: onChanged,
              divisions: 4,
              min: 1,
              max: 5,
            ),
          ],
        ),
      ),
    );
  }
}
