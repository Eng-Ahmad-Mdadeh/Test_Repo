import '../repositories/assessment_repository.dart';

class GetProgressTrend {
  const GetProgressTrend(this._repository);

  final AssessmentRepository _repository;

  Future<List<TrendPoint>> call(String patientId) {
    return _repository.getProgressTrend(patientId);
  }
}
