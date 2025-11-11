import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { AssessmentScale } from '@domain/entities/assessmentScale';

export const getAssessmentScales = async (
  repository: AssessmentRepository
): Promise<AssessmentScale[]> => {
  return repository.getScales();
};
