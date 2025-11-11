import React, { useEffect, useState } from 'react';
import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { getRecentResults } from '@application/useCases/getRecentResults';
import { AssessmentResult } from '@domain/entities/assessmentResult';
import '@styles/insights.css';

type Props = {
  repository: AssessmentRepository;
};

export const InsightsPage: React.FC<Props> = ({ repository }) => {
  const [results, setResults] = useState<AssessmentResult[]>([]);

  useEffect(() => {
    getRecentResults(repository).then(setResults);
  }, [repository]);

  return (
    <section>
      <header>
        <h1 className="page-title">مختبر التحليلات التنبؤية</h1>
        <p className="page-subtitle">
          اعتمد على لوحات البيانات الغنية بالرسوم البيانية، تحليلات المخاطر، وتوصيات الذكاء الاصطناعي
          لتوجيه القرارات السريرية بسرعة ودقة.
        </p>
      </header>

      <div className="grid grid-2 insights-grid">
        <div className="card insight-card">
          <h3>نموذج التدهور المعرفي</h3>
          <p>
            يراقب معدلات التغير في وقت الاستجابة، دقة الذاكرة العاملة، ونبرة الصوت لقياس احتمالية التدهور
            المبكر خلال 6 أشهر.
          </p>
          <div className="chart-simulation">
            <div className="chart-bar" style={{ height: '68%' }}>
              <span>68%</span>
              <small>استقرار</small>
            </div>
            <div className="chart-bar warning" style={{ height: '44%' }}>
              <span>44%</span>
              <small>مراقبة</small>
            </div>
            <div className="chart-bar danger" style={{ height: '22%' }}>
              <span>22%</span>
              <small>خطر</small>
            </div>
          </div>
        </div>

        <div className="card insight-card">
          <h3>تحليل المخاطر المجمعة</h3>
          <ul className="insight-list">
            {results.slice(0, 4).map((result) => (
              <li key={result.id}>
                <div>
                  <strong>{result.patient.fullName}</strong>
                  <span>{result.scale.name}</span>
                </div>
                <div className={`badge ${result.scoreLabel.toLowerCase()}`}>
                  {result.scoreLabel === 'Critical'
                    ? 'حرج'
                    : result.scoreLabel === 'Watch'
                    ? 'متابعة'
                    : 'مستقر'}
                </div>
              </li>
            ))}
          </ul>
        </div>

        <div className="card insight-card wide">
          <h3>خريطة رحلة المريض المؤتمتة</h3>
          <div className="journey-map">
            <div>
              <span className="badge">قبل الجلسة</span>
              <h4>تذكير متكامل متعدد القنوات</h4>
              <p>إشعارات واتساب، بريد إلكتروني، وتطبيق محمول مع تعليمات باللغة العربية الفصحى واللهجة المحلية.</p>
            </div>
            <div>
              <span className="badge">أثناء الجلسة</span>
              <h4>مساعد سريري فوري</h4>
              <p>ملاحظات صوتية مباشرة، قراءة آلية للغة الجسد، وإرشادات للتدخل في الوقت الفعلي.</p>
            </div>
            <div>
              <span className="badge">بعد الجلسة</span>
              <h4>متابعة ذكية</h4>
              <p>خطة علاجية ديناميكية مع محتوى مرئي قصير وتمارين يقظة يومية.</p>
            </div>
          </div>
        </div>

        <div className="card insight-card">
          <h3>جاهزية العمل دون اتصال</h3>
          <p>
            يتم تخزين البيانات داخل الجهاز باستخدام تشفير AES-256 مع مزامنة متأخرة إلى السحابة، ما يضمن
            العمل في العيادات الميدانية دون فقدان البيانات.
          </p>
          <ul className="readiness-list">
            <li>
              <strong>آخر مزامنة:</strong>
              <span>منذ 12 دقيقة</span>
            </li>
            <li>
              <strong>محاولات فاشلة:</strong>
              <span>0</span>
            </li>
            <li>
              <strong>نسخ احتياطية محلية:</strong>
              <span>3</span>
            </li>
          </ul>
        </div>
      </div>
    </section>
  );
};
