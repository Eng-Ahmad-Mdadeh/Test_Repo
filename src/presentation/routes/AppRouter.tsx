import React, { useMemo, useState } from 'react';
import { MockAssessmentRepository } from '@infrastructure/data/mockAssessmentRepository';
import { DashboardPage } from '@presentation/pages/DashboardPage';
import { AssessmentPage } from '@presentation/pages/AssessmentPage';
import { PatientsPage } from '@presentation/pages/PatientsPage';
import { InsightsPage } from '@presentation/pages/InsightsPage';
import { NavigationSidebar } from '@presentation/components/NavigationSidebar';
import { TopBar } from '@presentation/components/TopBar';
import '@styles/layout.css';

type AppView = 'dashboard' | 'assessments' | 'patients' | 'insights';

const repository = new MockAssessmentRepository();

const AppRouter: React.FC = () => {
  const [view, setView] = useState<AppView>('dashboard');

  const CurrentPage = useMemo(() => {
    switch (view) {
      case 'assessments':
        return <AssessmentPage repository={repository} />;
      case 'patients':
        return <PatientsPage repository={repository} />;
      case 'insights':
        return <InsightsPage repository={repository} />;
      default:
        return <DashboardPage repository={repository} />;
    }
  }, [view]);

  return (
    <div className="app-shell">
      <NavigationSidebar active={view} onNavigate={setView} />
      <main className="app-content">
        <TopBar />
        <div className="app-scroll-area">{CurrentPage}</div>
      </main>
    </div>
  );
};

export default AppRouter;
