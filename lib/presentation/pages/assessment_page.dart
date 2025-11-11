import 'package:flutter/material.dart';

import '../../domain/entities/assessment_scale.dart';
import '../../domain/entities/patient.dart';
import '../state/app_state.dart';
import '../widgets/assessment_question_card.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key, required this.state});

  final AppState state;

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  String? _selectedPatientId;
  String? _selectedScaleId;
  Map<String, double> _answers = const {};

  void _ensureDefaults() {
    if (_selectedPatientId == null && widget.state.patients.isNotEmpty) {
      _selectedPatientId = widget.state.patients.first.id;
    }
    if (_selectedScaleId == null && widget.state.assessmentScales.isNotEmpty) {
      _selectedScaleId = widget.state.assessmentScales.first.id;
      _seedAnswers();
    }
  }

  void _seedAnswers() {
    final scale = _currentScale;
    if (scale == null) return;
    final questions = scale.dimensions.expand((d) => d.questions);
    _answers = {
      for (final question in questions) question.id: 3,
    };
  }

  AssessmentScale? get _currentScale {
    if (_selectedScaleId == null) return null;
    return widget.state.assessmentScales.firstWhere(
      (scale) => scale.id == _selectedScaleId,
      orElse: () => widget.state.assessmentScales.isNotEmpty
          ? widget.state.assessmentScales.first
          : throw StateError('No scales registered'),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureDefaults();
    final patients = widget.state.patients;
    final scales = widget.state.assessmentScales;
    final questions = _currentScale?.dimensions.expand((d) => d.questions).toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إنشاء جلسة تقييم', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('اختر المريض والمقياس ثم قيّم الإجابات باستخدام مقياس من 1 إلى 5.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                value: _selectedPatientId,
                items: [
                  for (final Patient patient in patients)
                    DropdownMenuItem(value: patient.id, child: Text(patient.name)),
                ],
                onChanged: (value) => setState(() => _selectedPatientId = value),
                decoration: const InputDecoration(labelText: 'المريض'),
              ),
            ),
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                value: _selectedScaleId,
                items: [
                  for (final AssessmentScale scale in scales)
                    DropdownMenuItem(value: scale.id, child: Text(scale.title)),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedScaleId = value;
                    _seedAnswers();
                  });
                },
                decoration: const InputDecoration(labelText: 'المقياس'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: questions.isEmpty
              ? Center(
                  child: Text('لا توجد أسئلة متاحة للمقياس المختار حالياً.',
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final value = _answers[question.id] ?? 3;
                    return AssessmentQuestionCard(
                      prompt: question.prompt,
                      minLabel: question.minLabel,
                      maxLabel: question.maxLabel,
                      value: value,
                      onChanged: (newValue) {
                        setState(() {
                          _answers = {
                            ..._answers,
                            question.id: newValue,
                          };
                        });
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: questions.length,
                ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            icon: const Icon(Icons.send_rounded),
            label: const Text('إرسال التقييم'),
            onPressed: () async {
              if (_selectedPatientId == null || _selectedScaleId == null || questions.isEmpty) return;
              final answers = {
                for (final entry in _answers.entries) entry.key: entry.value.round(),
              };
              final result = await widget.state.submit(
                patientId: _selectedPatientId!,
                scaleId: _selectedScaleId!,
                answers: answers,
              );
              if (!mounted) return;
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('تم الحفظ بنجاح'),
                  content: Text('المستوى ${result.level} مع مجموع ${result.score.toStringAsFixed(0)}.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
