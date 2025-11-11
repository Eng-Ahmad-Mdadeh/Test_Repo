import '../repositories/assessment_repository.dart';

class GetDashboardSnapshot {
  const GetDashboardSnapshot(this._repository);

  final AssessmentRepository _repository;

  Future<DashboardSnapshot> call() => _repository.getDashboardSnapshot();
}
