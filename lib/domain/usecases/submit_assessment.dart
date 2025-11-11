import '../entities/assessment_result.dart';
import '../repositories/assessment_repository.dart';

class SubmitAssessment {
  const SubmitAssessment(this._repository);

  final AssessmentRepository _repository;

  Future<AssessmentResult> call({
    required String patientId,
    required String scaleId,
    required Map<String, int> answers,
  }) {
    return _repository.submitAssessment(
      patientId: patientId,
      scaleId: scaleId,
      answers: answers,
    );
  }
}
