import '../entities/patient.dart';
import '../repositories/assessment_repository.dart';

class GetPatients {
  const GetPatients(this._repository);

  final AssessmentRepository _repository;

  Future<List<Patient>> call() => _repository.getPatients();
}
