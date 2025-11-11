import 'dart:math';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/assessment_result.dart';
import '../../domain/entities/assessment_scale.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/assessment_repository.dart';

class MockAssessmentRepository implements AssessmentRepository {
  MockAssessmentRepository() {
    _seedData();
  }

  final List<Patient> _patients = [];
  final List<AssessmentScale> _scales = [];
  final List<AssessmentResult> _results = [];

  void _seedData() {
    final now = DateTime.now();
    _patients
      ..clear()
      ..addAll([
        Patient(
          id: 'p-001',
          name: 'ليان السبيعي',
          age: 28,
          status: 'تحت المتابعة الأسبوعية',
          focusArea: 'اضطراب القلق العام',
          lastSession: now.subtract(const Duration(days: 2)),
          profileCompletion: 0.92,
        ),
        Patient(
          id: 'p-002',
          name: 'سالم الخالدي',
          age: 35,
          status: 'جلسة تقييم قادمة',
          focusArea: 'اضطرابات النوم',
          lastSession: now.subtract(const Duration(days: 6)),
          profileCompletion: 0.76,
        ),
        Patient(
          id: 'p-003',
          name: 'عائشة الأحمد',
          age: 41,
          status: 'خطة علاجية نشطة',
          focusArea: 'اكتئاب متوسط',
          lastSession: now.subtract(const Duration(days: 1)),
          profileCompletion: 0.88,
        ),
      ]);

    _scales
      ..clear()
      ..addAll([
        AssessmentScale(
          id: 'scale-001',
          title: 'مؤشر التوازن العاطفي',
          description: 'قياس مستويات التوتر، اليقظة، والتكيف النفسي.',
          dimensions: [
            ScaleDimension(
              id: 'dim-1',
              name: 'التوتر اللحظي',
              questions: [
                ScaleQuestion(
                  id: 'q-1',
                  prompt: 'ما مستوى التوتر الذي شعرت به اليوم؟',
                  minLabel: 'منخفض',
                  maxLabel: 'عالٍ',
                ),
                ScaleQuestion(
                  id: 'q-2',
                  prompt: 'إلى أي درجة واجهت صعوبة في التركيز؟',
                  minLabel: 'بسيطة',
                  maxLabel: 'كبيرة',
                ),
              ],
            ),
            ScaleDimension(
              id: 'dim-2',
              name: 'المرونة المعرفية',
              questions: [
                ScaleQuestion(
                  id: 'q-3',
                  prompt: 'إلى أي مدى تمكنت من إعادة تأطير الأفكار السلبية؟',
                  minLabel: 'نادراً',
                  maxLabel: 'دائماً',
                ),
                ScaleQuestion(
                  id: 'q-4',
                  prompt: 'كيف تقيم قدرتك على اتخاذ قرارات هادئة؟',
                  minLabel: 'ضعيفة',
                  maxLabel: 'ممتازة',
                ),
              ],
            ),
          ],
        ),
        AssessmentScale(
          id: 'scale-002',
          title: 'استبيان جودة النوم',
          description: 'يقيّم جودة النوم واليقظة الصباحية والروتين الليلي.',
          dimensions: [
            ScaleDimension(
              id: 'dim-3',
              name: 'دورة النوم',
              questions: [
                ScaleQuestion(
                  id: 'q-5',
                  prompt: 'كم ساعة نمت في الليلة الماضية؟',
                  minLabel: 'أقل من 4',
                  maxLabel: 'أكثر من 8',
                ),
                ScaleQuestion(
                  id: 'q-6',
                  prompt: 'ما مدى سهولة الاستغراق في النوم؟',
                  minLabel: 'صعب جداً',
                  maxLabel: 'سهل جداً',
                ),
              ],
            ),
            ScaleDimension(
              id: 'dim-4',
              name: 'اليقظة الصباحية',
              questions: [
                ScaleQuestion(
                  id: 'q-7',
                  prompt: 'كيف تشعر بطاقة الصباح لديك؟',
                  minLabel: 'منخفضة',
                  maxLabel: 'مرتفعة',
                ),
                ScaleQuestion(
                  id: 'q-8',
                  prompt: 'ما مدى اعتمادك على المنبهات؟',
                  minLabel: 'نادراً',
                  maxLabel: 'بشكل يومي',
                ),
              ],
            ),
          ],
        ),
      ]);

    _results
      ..clear()
      ..addAll(
        _patients.mapIndexed(
          (index, patient) => AssessmentResult(
            patientId: patient.id,
            scaleId: 'scale-001',
            score: 60 + index * 8,
            level: index == 0 ? 'معتدل' : index == 1 ? 'مرتفع' : 'منخفض',
            completedOn: now.subtract(Duration(days: index + 1)),
          ),
        ),
      );
  }

  @override
  Future<List<AssessmentScale>> getAssessmentScales() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _scales;
  }

  @override
  Future<DashboardSnapshot> getDashboardSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'التزام الجلسات': 0.86,
      'تراجع مستوى التوتر': 0.24,
      'تحسن جودة النوم': 0.31,
      'المشاركات اليومية': 0.72,
    };
  }

  @override
  Future<List<InsightCard>> getInsightCards() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [
      (
        title: 'قابلية الانتكاس',
        subtitle: 'انخفاض المخاطر بنسبة 12% هذا الأسبوع',
        change: -0.12,
      ),
      (
        title: 'الالتزام بالتمارين',
        subtitle: 'تم تسجيل 18 نشاطاً علاجياً منزلياً',
        change: 0.18,
      ),
      (
        title: 'حالة الدعم الأسري',
        subtitle: 'ارتفع مؤشر الدعم إلى 74 من 100',
        change: 0.07,
      ),
    ];
  }

  @override
  Future<List<Patient>> getPatients() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return _patients;
  }

  @override
  Future<List<AssessmentResult>> getRecentResults() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _results;
  }

  @override
  Future<AssessmentResult> submitAssessment({
    required String patientId,
    required String scaleId,
    required Map<String, int> answers,
  }) async {
    final random = Random();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final score = answers.values.fold<double>(0, (acc, value) => acc + value) * 8;
    final normalized = min(100, max(0, score / answers.length));
    final level = normalized > 75
        ? 'عالٍ'
        : normalized > 50
            ? 'متوسط'
            : 'منخفض';

    final result = AssessmentResult(
      patientId: patientId,
      scaleId: scaleId,
      score: normalized,
      level: level,
      completedOn: DateTime.now().subtract(Duration(hours: random.nextInt(6))),
    );
    _results.insert(0, result);
    return result;
  }

  @override
  Future<List<TrendPoint>> getProgressTrend(String patientId) async {
    final format = DateFormat('E');
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return List.generate(
      7,
      (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        return (label: format.format(date), value: 55 + Random().nextInt(30));
      },
    );
  }
}
