import '../entities/assessment_result.dart';
import '../entities/assessment_scale.dart';
import '../entities/patient.dart';

typedef DashboardSnapshot = Map<String, double>;

typedef TrendPoint = ({String label, double value});

typedef InsightCard = ({String title, String subtitle, double change});

typedef AssessmentFlow = ({
  AssessmentScale scale,
  List<ScaleQuestion> flattenedQuestions,
});

abstract class AssessmentRepository {
  Future<DashboardSnapshot> getDashboardSnapshot();

  Future<List<Patient>> getPatients();

  Future<List<AssessmentResult>> getRecentResults();

  Future<List<AssessmentScale>> getAssessmentScales();

  Future<AssessmentResult> submitAssessment({
    required String patientId,
    required String scaleId,
    required Map<String, int> answers,
  });

  Future<List<TrendPoint>> getProgressTrend(String patientId);

  Future<List<InsightCard>> getInsightCards();
}
