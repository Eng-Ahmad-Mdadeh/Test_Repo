import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/insight_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final recommendations = [
      'خصص وقتاً أسبوعياً لاجتماعات المتابعة متعددة التخصصات.',
      'ادمج تمارين التنفس مع مذكرات النوم لتحسين جودة الراحة.',
      'وجه الفريق العلاجي لتوثيق الملاحظات النوعية بعد كل جلسة.',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 720
            ? 1
            : constraints.maxWidth < 1080
                ? 2
                : 3;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الرؤى والتحليلات', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text('مؤشرات قابلة للتنفيذ لتوجيه القرارات السريرية القادمة.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.insights.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: crossAxisCount == 1 ? 1.7 : 1.1,
                ),
                itemBuilder: (context, index) {
                  final insight = state.insights[index];
                  return InsightCardWidget(
                    title: insight.title,
                    subtitle: insight.subtitle,
                    change: insight.change,
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E2A4A), Color(0xFF201B34)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.amberAccent),
                        const SizedBox(width: 12),
                        Text('توصيات استراتيجية', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final item in recommendations)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, size: 18, color: Colors.tealAccent),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
