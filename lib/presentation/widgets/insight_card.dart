import 'package:flutter/material.dart';

class InsightCardWidget extends StatelessWidget {
  const InsightCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.change,
  });

  final String title;
  final String subtitle;
  final double change;

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final color = isPositive ? Colors.tealAccent : Colors.pinkAccent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Row(
              children: [
                Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: color),
                const SizedBox(width: 8),
                Text(
                  '${(change * 100).abs().toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
