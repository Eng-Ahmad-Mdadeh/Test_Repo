import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.icon,
  });

  final String title;
  final String value;
  final double? trend;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isPositive = trend != null && trend! >= 0;
    final trendColor = isPositive ? Colors.tealAccent : Colors.pinkAccent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: Icon(icon, color: Theme.of(context).colorScheme.primary),
                  ),
                if (icon != null) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: trendColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: trendColor),
                        const SizedBox(width: 4),
                        Text('${(trend! * 100).abs().toStringAsFixed(0)}%', style: TextStyle(color: trendColor)),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}
