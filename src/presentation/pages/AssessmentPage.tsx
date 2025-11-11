import React, { useEffect, useMemo, useState } from 'react';
import { AssessmentRepository } from '@domain/repositories/assessmentRepository';
import { AssessmentScale } from '@domain/entities/assessmentScale';
import { Patient } from '@domain/entities/patient';
import { getAssessmentScales } from '@application/useCases/getAssessmentScales';
import { getPatients } from '@application/useCases/getPatients';
import { submitAssessment } from '@application/useCases/submitAssessment';
import '@styles/assessments.css';

type Props = {
  repository: AssessmentRepository;
};

type Responses = Record<string, number | boolean | string>;

type Tab = 'guided' | 'ai' | 'offline';

export const AssessmentPage: React.FC<Props> = ({ repository }) => {
  const [scales, setScales] = useState<AssessmentScale[]>([]);
  const [patients, setPatients] = useState<Patient[]>([]);
  const [selectedScale, setSelectedScale] = useState<string>('');
  const [selectedPatient, setSelectedPatient] = useState<string>('');
  const [tab, setTab] = useState<Tab>('guided');
  const [responses, setResponses] = useState<Responses>({});
  const [submissionMessage, setSubmissionMessage] = useState<string>('');

  useEffect(() => {
    getAssessmentScales(repository).then((items) => {
      setScales(items);
      if (items.length) setSelectedScale(items[0].id);
    });
    getPatients(repository).then((items) => {
      setPatients(items);
      if (items.length) setSelectedPatient(items[0].id);
    });
  }, [repository]);

  const activeScale = useMemo(
    () => scales.find((scale) => scale.id === selectedScale),
    [scales, selectedScale]
  );

  const handleResponseChange = (itemId: string, value: number | boolean | string) => {
    setResponses((prev) => ({ ...prev, [itemId]: value }));
  };

  const handleSubmit = async () => {
    if (!selectedPatient || !selectedScale) return;
    const result = await submitAssessment(repository, selectedPatient, selectedScale, responses);
    setSubmissionMessage(
      `تم إنشاء تحليل ${result.scoreLabel === 'Critical' ? 'حرج' : 'متابعة'} للمريض ${result.patient.fullName}`
    );
    setResponses({});
  };

  return (
    <section>
      <header>
        <h1 className="page-title">جلسات تقييم متعددة الطبقات</h1>
        <p className="page-subtitle">
          تتيح الواجهة التفاعلية العمل باللمس، دعم اللغتين، وضعية دون اتصال، ومسار إرشادي يضمن اكتمال
          التقييمات حتى في بيئات العيادات الميدانية.
        </p>
      </header>

      <div className="tab-bar">
        <button className={tab === 'guided' ? 'active' : ''} onClick={() => setTab('guided')}>
          النمط الموجه
        </button>
        <button className={tab === 'ai' ? 'active' : ''} onClick={() => setTab('ai')}>
          مساعد الذكاء الاصطناعي
        </button>
        <button className={tab === 'offline' ? 'active' : ''} onClick={() => setTab('offline')}>
          وضع دون اتصال
        </button>
      </div>

      <div className="grid grid-2 assessment-layout">
        <div className="card assessment-panel">
          <h3>إعداد الجلسة</h3>
          <div className="form-group">
            <label htmlFor="patient">اختر المريض</label>
            <select
              id="patient"
              value={selectedPatient}
              onChange={(event) => setSelectedPatient(event.target.value)}
            >
              {patients.map((patient) => (
                <option key={patient.id} value={patient.id}>
                  {patient.fullName} — مستوى الخطر {patient.riskLevel}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label htmlFor="scale">أداة القياس</label>
            <select
              id="scale"
              value={selectedScale}
              onChange={(event) => setSelectedScale(event.target.value)}
            >
              {scales.map((scale) => (
                <option key={scale.id} value={scale.id}>
                  {scale.name} — {scale.durationMinutes} دقيقة
                </option>
              ))}
            </select>
          </div>

          <div className="session-highlights">
            <div>
              <span className="badge">Biofeedback + Video</span>
              <p>تكامل فوري مع الكاميرا وحساسات معدل النبض مع تعليمات صوتية.</p>
            </div>
            <div>
              <span className="badge">إدخال مبسط</span>
              <p>بطاقات بحجم كبير ولون متباين لتقليل إجهاد العين وتحسين دقة الإدخال.</p>
            </div>
          </div>

          <button onClick={handleSubmit}>بدء الجلسة التحليلية</button>
          {submissionMessage && <p className="submission-message">{submissionMessage}</p>}
        </div>

        <div className="card assessment-preview">
          <header>
            <h3>{activeScale?.name}</h3>
            <p>{activeScale?.description}</p>
          </header>

          <div className="assessment-cards">
            {activeScale?.items.map((item, index) => (
              <div key={item.id} className="assessment-card">
                <div className="assessment-card__meta">
                  <span className="badge">{item.type === 'likert' ? 'تدرج ليكرت' : 'مهمة'}</span>
                  <span className="assessment-card__step">
                    سؤال {index + 1} من {activeScale.items.length}
                  </span>
                </div>
                <h4>{item.prompt}</h4>
                {item.type === 'likert' && (
                  <div className="options">
                    {item.options?.map((option, index) => (
                      <button
                        key={option}
                        className={responses[item.id] === index ? 'selected' : ''}
                        onClick={() => handleResponseChange(item.id, index)}
                      >
                        {option}
                      </button>
                    ))}
                  </div>
                )}
                {item.type === 'boolean' && (
                  <div className="options">
                    <button
                      className={responses[item.id] === true ? 'selected' : ''}
                      onClick={() => handleResponseChange(item.id, true)}
                    >
                      نعم
                    </button>
                    <button
                      className={responses[item.id] === false ? 'selected' : ''}
                      onClick={() => handleResponseChange(item.id, false)}
                    >
                      لا
                    </button>
                  </div>
                )}
                {item.type === 'text' && (
                  <textarea
                    rows={4}
                    placeholder="اكتب ملاحظاتك البصرية أو الزمنية"
                    value={(responses[item.id] as string) ?? ''}
                    onChange={(event) => handleResponseChange(item.id, event.target.value)}
                  />
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
