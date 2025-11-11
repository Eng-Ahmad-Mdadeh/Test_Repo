import { AssessmentScale } from './assessmentScale';
import { Patient } from './patient';

export interface AssessmentResult {
  id: string;
  patient: Patient;
  scale: AssessmentScale;
  score: number;
  scoreLabel: 'Stable' | 'Watch' | 'Critical';
  recommendations: string[];
  recordedAt: string;
  clinicianNotes?: string;
}
