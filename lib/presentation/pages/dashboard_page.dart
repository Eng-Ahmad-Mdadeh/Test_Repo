import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/assessment_result.dart';
import '../state/app_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/trend_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final metrics = state.dashboardSnapshot.entries.toList();
    final dateFormat = DateFormat('d MMMM، y', 'ar');

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 720
            ? 1
            : constraints.maxWidth < 1080
                ? 2
                : 4;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'مرحباً بك في نيورو بالانس',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text('آخر تحديث: ${dateFormat.format(DateTime.now())}'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metrics.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: crossAxisCount == 1 ? 2 : 1.2,
                ),
                itemBuilder: (context, index) {
                  final entry = metrics[index];
                  final value = '${(entry.value * 100).toStringAsFixed(0)}%';
                  final trend = index.isEven ? 0.12 : -0.06;
                  final icon = switch (index) {
                    0 => Icons.schedule_outlined,
                    1 => Icons.spa_outlined,
                    2 => Icons.nightlight_outlined,
                    _ => Icons.chat_bubble_outline,
                  };
                  return MetricCard(
                    title: entry.key,
                    value: value,
                    trend: trend,
                    icon: icon,
                  );
                },
              ),
              const SizedBox(height: 24),
              TrendChart(points: state.currentTrend),
              const SizedBox(height: 24),
              Text('آخر النتائج السريرية', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final AssessmentResult result = state.recentResults[index];
                  return ListTile(
                    tileColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text('المريض ${result.patientId}'),
                    subtitle: Text('المقياس ${result.scaleId} • ${dateFormat.format(result.completedOn)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${result.score.toStringAsFixed(0)} / 100',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text(result.level, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: state.recentResults.length,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
