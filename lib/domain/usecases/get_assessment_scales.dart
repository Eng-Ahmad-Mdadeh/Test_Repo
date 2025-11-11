import '../entities/assessment_scale.dart';
import '../repositories/assessment_repository.dart';

class GetAssessmentScales {
  const GetAssessmentScales(this._repository);

  final AssessmentRepository _repository;

  Future<List<AssessmentScale>> call() => _repository.getAssessmentScales();
}
