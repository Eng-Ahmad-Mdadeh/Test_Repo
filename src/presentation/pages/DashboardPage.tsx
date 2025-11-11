import React, { useEffect, useState } from 'react';
import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { getDashboardSnapshot, DashboardSnapshot } from '@application/useCases/getDashboardSnapshot';
import { getRecentResults } from '@application/useCases/getRecentResults';
import { AssessmentResult } from '@domain/entities/assessmentResult';
import '@styles/dashboard.css';

type Props = {
  repository: AssessmentRepository;
};

export const DashboardPage: React.FC<Props> = ({ repository }) => {
  const [snapshot, setSnapshot] = useState<DashboardSnapshot | null>(null);
  const [recentResults, setRecentResults] = useState<AssessmentResult[]>([]);

  useEffect(() => {
    getDashboardSnapshot(repository).then(setSnapshot);
    getRecentResults(repository).then(setRecentResults);
  }, [repository]);

  return (
    <section>
      <header>
        <h1 className="page-title">لوحة التحكم العصبية</h1>
        <p className="page-subtitle">
          تتبع تطور المرضى في الزمن الحقيقي، مع مراقبة مؤشرات الخطر المدعومة بالذكاء الاصطناعي
          ووضعية العمل دون اتصال لتجربة أكثر أمانًا وموثوقية.
        </p>
      </header>

      <div className="grid grid-4 metrics">
        <div className="metric-card">
          <h3>المرضى النشطون</h3>
          <p className="metric-value">{snapshot?.totalPatients ?? '—'}</p>
          <span>مزامنة في الوقت الفعلي</span>
        </div>
        <div className="metric-card">
          <h3>تنبيهات حرجة</h3>
          <p className="metric-value accent">{snapshot?.activeAlerts ?? '—'}</p>
          <span>التدخل المبكر يقلل الأخطاء</span>
        </div>
        <div className="metric-card">
          <h3>متوسط مدة الجلسة</h3>
          <p className="metric-value">{snapshot?.avgSessionDuration ?? '—'} دقيقة</p>
          <span>تجربة مريحة وسهلة الاستخدام</span>
        </div>
        <div className="metric-card">
          <h3>نسبة الإكمال</h3>
          <p className="metric-value">{snapshot?.completionRate ?? '—'}%</p>
          <span>بفضل التصميم الداعم للـ UX</span>
        </div>
      </div>

      <div className="grid grid-2 dashboard-panels">
        <div className="card panel">
          <div className="panel__header">
            <h3>رحلة المريض التكيفية</h3>
            <span className="badge">Instant AI Copilot</span>
          </div>
          <ul className="timeline">
            <li>
              <span className="timeline__dot" />
              <div>
                <strong>استقبال مهيأ للمريض</strong>
                <p>يتم تحليل النبرة الصوتية ونبضات القلب لتخصيص التدخل منذ الدقيقة الأولى.</p>
              </div>
            </li>
            <li>
              <span className="timeline__dot" />
              <div>
                <strong>جلسة تقييم تفاعلية</strong>
                <p>بطاقات لمس كبيرة، دعم لغة عربية كاملة، وتلميحات مرئية تسهل الإجابات.</p>
              </div>
            </li>
            <li>
              <span className="timeline__dot" />
              <div>
                <strong>تحليل فوري دون اتصال</strong>
                <p>يتم معالجة البيانات محليًا مع تشفير طرفي وإرسال النتائج لاحقًا عند الاتصال.</p>
              </div>
            </li>
          </ul>
        </div>

        <div className="card panel">
          <div className="panel__header">
            <h3>آخر النتائج السريرية</h3>
            <span className="badge">Auto Insights</span>
          </div>
          <div className="results">
            {recentResults.map((result) => (
              <article key={result.id} className="result-card">
                <div>
                  <h4>{result.patient.fullName}</h4>
                  <p>{result.scale.name}</p>
                </div>
                <div className={`badge ${result.scoreLabel.toLowerCase()}`}>
                  {result.scoreLabel === 'Critical'
                    ? 'حالة حرجة'
                    : result.scoreLabel === 'Watch'
                    ? 'تحتاج متابعة'
                    : 'مستقر'}
                </div>
                <ul className="result-recommendations">
                  {result.recommendations.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ul>
              </article>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
