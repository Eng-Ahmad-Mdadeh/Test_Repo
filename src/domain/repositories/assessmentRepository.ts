import { AssessmentResult } from '../entities/assessmentResult';
import { AssessmentScale } from '../entities/assessmentScale';
import { Patient } from '../entities/patient';

export interface AssessmentRepository {
  getPatients(): Promise<Patient[]>;
  getScales(): Promise<AssessmentScale[]>;
  getRecentResults(): Promise<AssessmentResult[]>;
  submitAssessment(
    patientId: string,
    scaleId: string,
    responses: Record<string, number | boolean | string>
  ): Promise<AssessmentResult>;
}
