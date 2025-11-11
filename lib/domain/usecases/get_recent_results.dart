import '../entities/assessment_result.dart';
import '../repositories/assessment_repository.dart';

class GetRecentResults {
  const GetRecentResults(this._repository);

  final AssessmentRepository _repository;

  Future<List<AssessmentResult>> call() => _repository.getRecentResults();
}
