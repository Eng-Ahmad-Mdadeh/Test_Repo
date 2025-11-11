export interface Patient {
  id: string;
  fullName: string;
  age: number;
  gender: 'male' | 'female' | 'other';
  occupation: string;
  profileImage?: string;
  riskLevel: 'low' | 'moderate' | 'high';
  lastAssessmentDate: string;
}
