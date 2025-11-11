import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { Patient } from '@domain/entities/patient';

export const getPatients = async (repository: AssessmentRepository): Promise<Patient[]> => {
  return repository.getPatients();
};
