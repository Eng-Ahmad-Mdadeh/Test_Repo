import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { AssessmentScale } from '@domain/entities/assessmentScale';
import { Patient } from '@domain/entities/patient';
import { AssessmentResult } from '@domain/entities/assessmentResult';

const patients: Patient[] = [
  {
    id: 'p1',
    fullName: 'Leen Hassan',
    age: 28,
    gender: 'female',
    occupation: 'UX Researcher',
    riskLevel: 'moderate',
    lastAssessmentDate: '2024-04-14'
  },
  {
    id: 'p2',
    fullName: 'Mohammed Al Zaher',
    age: 35,
    gender: 'male',
    occupation: 'Civil Engineer',
    riskLevel: 'high',
    lastAssessmentDate: '2024-04-10'
  },
  {
    id: 'p3',
    fullName: 'Aya Rahman',
    age: 24,
    gender: 'female',
    occupation: 'Graduate Student',
    riskLevel: 'low',
    lastAssessmentDate: '2024-04-17'
  }
];

const scales: AssessmentScale[] = [
  {
    id: 's1',
    name: 'Arabic BDI-II',
    description:
      'Validated Arabic adaptation of the Beck Depression Inventory for monitoring depressive symptoms.',
    durationMinutes: 10,
    focusArea: 'depression',
    items: [
      {
        id: 'q1',
        prompt: 'How often did you feel joyless during the last week?',
        type: 'likert',
        options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always']
      },
      {
        id: 'q2',
        prompt: 'Rate your sleep quality in the last seven days.',
        type: 'likert',
        options: ['Very poor', 'Poor', 'Moderate', 'Good', 'Excellent']
      },
      {
        id: 'q3',
        prompt: 'I had difficulty concentrating on tasks.',
        type: 'likert',
        options: ['Strongly disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly agree']
      }
    ]
  },
  {
    id: 's2',
    name: 'Anxiety Digital Scale',
    description:
      'Short-form anxiety assessment optimized for touch-input tablets with clinical scoring guidance.',
    durationMinutes: 8,
    focusArea: 'anxiety',
    items: [
      {
        id: 'q1',
        prompt: 'I experienced sudden feelings of panic.',
        type: 'likert',
        options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always']
      },
      {
        id: 'q2',
        prompt: 'I felt calm and composed.',
        type: 'likert',
        options: ['Strongly disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly agree']
      }
    ]
  },
  {
    id: 's3',
    name: 'Cognitive Flexibility Screening',
    description:
      'Gamified decision-making and reaction time tasks to detect early cognitive decline.',
    durationMinutes: 12,
    focusArea: 'cognitive',
    items: [
      {
        id: 'task',
        prompt: 'Follow the visual cues and tap the opposite icon as quickly as possible.',
        type: 'text'
      }
    ]
  }
];

let recentResults: AssessmentResult[] = [
  {
    id: 'r1',
    patient: patients[0],
    scale: scales[0],
    score: 18,
    scoreLabel: 'Watch',
    recordedAt: '2024-04-14T09:20:00Z',
    recommendations: [
      'Schedule weekly CBT-focused sessions',
      'Introduce mindfulness breathing routine',
      'Monitor sleep hygiene with daily journaling'
    ],
    clinicianNotes: 'Patient responding well to guided meditations, continue remote monitoring.'
  },
  {
    id: 'r2',
    patient: patients[1],
    scale: scales[1],
    score: 26,
    scoreLabel: 'Critical',
    recordedAt: '2024-04-10T12:05:00Z',
    recommendations: [
      'Escalate for psychiatrist evaluation',
      'Enable real-time HRV monitoring',
      'Provide emergency coping strategies toolkit'
    ]
  }
];

export class MockAssessmentRepository implements AssessmentRepository {
  async getPatients(): Promise<Patient[]> {
    return new Promise((resolve) => setTimeout(() => resolve(patients), 120));
  }

  async getScales(): Promise<AssessmentScale[]> {
    return new Promise((resolve) => setTimeout(() => resolve(scales), 140));
  }

  async getRecentResults(): Promise<AssessmentResult[]> {
    return new Promise((resolve) => setTimeout(() => resolve(recentResults), 160));
  }

  async submitAssessment(
    patientId: string,
    scaleId: string,
    responses: Record<string, number | boolean | string>
  ): Promise<AssessmentResult> {
    const patient = patients.find((p) => p.id === patientId);
    const scale = scales.find((s) => s.id === scaleId);

    if (!patient || !scale) {
      throw new Error('Invalid patient or assessment scale.');
    }

    const computedScore = Object.values(responses).reduce((acc, value) => {
      if (typeof value === 'number') return acc + value;
      if (typeof value === 'boolean') return acc + (value ? 2 : 0);
      return acc + 1;
    }, 0);

    const normalizedScore = Math.round((computedScore / (scale.items.length * 5)) * 40);
    const scoreLabel = normalizedScore > 25 ? 'Critical' : normalizedScore > 15 ? 'Watch' : 'Stable';

    const result: AssessmentResult = {
      id: `r${recentResults.length + 1}`,
      patient,
      scale,
      score: normalizedScore,
      scoreLabel,
      recordedAt: new Date().toISOString(),
      recommendations:
        scoreLabel === 'Critical'
          ? [
              'Escalate for psychiatrist evaluation',
              'Enable AI-guided emergency coping module',
              'Schedule follow-up within 48 hours'
            ]
          : scoreLabel === 'Watch'
          ? [
              'Continue weekly telehealth check-ins',
              'Activate adaptive breathing exercises',
              'Review nutrition plan focused on mood regulation'
            ]
          : [
              'Maintain monthly remote monitoring',
              'Promote community well-being workshops',
              'Encourage journaling for resilience tracking'
            ]
    };

    recentResults = [result, ...recentResults].slice(0, 6);

    return new Promise((resolve) => setTimeout(() => resolve(result), 180));
  }
}
