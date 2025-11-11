import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { AssessmentResult } from '@domain/entities/assessmentResult';

export const submitAssessment = async (
  repository: AssessmentRepository,
  patientId: string,
  scaleId: string,
  responses: Record<string, number | boolean | string>
): Promise<AssessmentResult> => {
  return repository.submitAssessment(patientId, scaleId, responses);
};
