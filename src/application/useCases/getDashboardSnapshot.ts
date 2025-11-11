import { AssessmentRepository } from '@domain/repositories/assessmentRepository';

export interface DashboardSnapshot {
  totalPatients: number;
  activeAlerts: number;
  avgSessionDuration: number;
  completionRate: number;
}

export const getDashboardSnapshot = async (
  repository: AssessmentRepository
): Promise<DashboardSnapshot> => {
  const [patients, results] = await Promise.all([
    repository.getPatients(),
    repository.getRecentResults()
  ]);

  const activeAlerts = results.filter((result) => result.scoreLabel !== 'Stable').length;
  const avgSessionDuration = patients.length ? 14 : 0;
  const completionRate = patients.length ? 92 : 0;

  return {
    totalPatients: patients.length,
    activeAlerts,
    avgSessionDuration,
    completionRate
  };
};
