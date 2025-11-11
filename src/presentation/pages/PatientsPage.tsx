import React, { useEffect, useState } from 'react';
import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { Patient } from '@domain/entities/patient';
import { getPatients } from '@application/useCases/getPatients';
import '@styles/patients.css';

type Props = {
  repository: AssessmentRepository;
};

export const PatientsPage: React.FC<Props> = ({ repository }) => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [search, setSearch] = useState('');
  const [riskFilter, setRiskFilter] = useState<'all' | Patient['riskLevel']>('all');

  useEffect(() => {
    getPatients(repository).then(setPatients);
  }, [repository]);

  const filteredPatients = patients.filter((patient) => {
    const matchesName = patient.fullName.toLowerCase().includes(search.toLowerCase());
    const matchesRisk = riskFilter === 'all' || patient.riskLevel === riskFilter;
    return matchesName && matchesRisk;
  });

  return (
    <section>
      <header>
        <h1 className="page-title">الملفات السريرية المتصلة</h1>
        <p className="page-subtitle">
          استعرض كل مريض مع سجل التقييمات، المؤشرات الحيوية، والتوصيات الشخصية المدعومة بخوارزميات
          التنبؤ بالانتكاسة.
        </p>
      </header>

      <div className="filters card">
        <div className="search-box">
          <input
            type="text"
            placeholder="ابحث بالاسم أو المهنة"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
          />
        </div>

        <div className="chip-group">
          {['all', 'low', 'moderate', 'high'].map((level) => (
            <button
              key={level}
              className={`chip ${riskFilter === level ? 'active' : ''}`}
              onClick={() => setRiskFilter(level as typeof riskFilter)}
            >
              {level === 'all'
                ? 'كل المستويات'
                : level === 'low'
                ? 'مستقر'
                : level === 'moderate'
                ? 'متابعة'
                : 'حرج'}
            </button>
          ))}
        </div>
      </div>

      <div className="grid grid-3 patient-cards">
        {filteredPatients.map((patient) => (
          <article key={patient.id} className="card patient-card">
            <div className={`risk-indicator ${patient.riskLevel}`}>
              <span />
              مستوى الخطر: {patient.riskLevel === 'high' ? 'حرج' : patient.riskLevel === 'moderate' ? 'متابعة' : 'مستقر'}
            </div>
            <div className="patient-card__header">
              <div className="avatar">
                <img src={`https://i.pravatar.cc/150?u=${patient.id}`} alt={patient.fullName} />
              </div>
              <div>
                <h3>{patient.fullName}</h3>
                <p>{patient.occupation}</p>
              </div>
            </div>
            <ul className="patient-card__stats">
              <li>
                <strong>العمر</strong>
                <span>{patient.age} عامًا</span>
              </li>
              <li>
                <strong>آخر جلسة</strong>
                <span>{new Date(patient.lastAssessmentDate).toLocaleDateString('ar-EG')}</span>
              </li>
              <li>
                <strong>التدخل المقترح</strong>
                <span>{patient.riskLevel === 'high' ? 'جلسة طارئة + مراقبة' : 'متابعة أسبوعية'}</span>
              </li>
            </ul>
            <button>فتح ملف المريض</button>
          </article>
        ))}
      </div>
    </section>
  );
};
