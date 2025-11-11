import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { AssessmentResult } from '@domain/entities/assessmentResult';

export const getRecentResults = async (
  repository: AssessmentRepository
): Promise<AssessmentResult[]> => {
  return repository.getRecentResults();
};
