export interface AssessmentItem {
  id: string;
  prompt: string;
  type: 'likert' | 'boolean' | 'text';
  options?: string[];
}

export interface AssessmentScale {
  id: string;
  name: string;
  description: string;
  durationMinutes: number;
  items: AssessmentItem[];
  focusArea: 'anxiety' | 'depression' | 'stress' | 'cognitive';
}
