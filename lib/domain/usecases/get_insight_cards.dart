import '../repositories/assessment_repository.dart';

class GetInsightCards {
  const GetInsightCards(this._repository);

  final AssessmentRepository _repository;

  Future<List<InsightCard>> call() => _repository.getInsightCards();
}
