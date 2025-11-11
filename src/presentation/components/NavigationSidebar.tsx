import React from 'react';
import '@styles/sidebar.css';

type Props = {
  active: 'dashboard' | 'assessments' | 'patients' | 'insights';
  onNavigate: (view: Props['active']) => void;
};

const NAV_ITEMS: Array<{ id: Props['active']; label: string; icon: string; hint: string }> = [
  { id: 'dashboard', label: 'الرئيسية', icon: '💠', hint: 'مؤشرات لحظية' },
  { id: 'assessments', label: 'التقييمات', icon: '🧠', hint: 'جلسات تفاعلية' },
  { id: 'patients', label: 'المرضى', icon: '🩺', hint: 'ملفات شخصية' },
  { id: 'insights', label: 'التقارير', icon: '📊', hint: 'تحليلات ذكية' }
];

export const NavigationSidebar: React.FC<Props> = ({ active, onNavigate }) => {
  return (
    <aside className="sidebar">
      <div className="sidebar__brand">
        <span className="sidebar__logo">NB</span>
        <div>
          <h1>NeuroBalance</h1>
          <p>منصة التحليل السريري المؤتمت</p>
        </div>
      </div>

      <nav className="sidebar__nav">
        {NAV_ITEMS.map((item) => (
          <button
            key={item.id}
            className={`sidebar__nav-item ${item.id === active ? 'active' : ''}`}
            onClick={() => onNavigate(item.id)}
          >
            <span className="sidebar__icon" aria-hidden>
              {item.icon}
            </span>
            <div>
              <strong>{item.label}</strong>
              <small>{item.hint}</small>
            </div>
          </button>
        ))}
      </nav>

      <div className="sidebar__cta">
        <h2>جلسة مباشرة خلال 10 دقائق</h2>
        <p>ابدأ تقييمًا جديدًا مع وضعية العمل دون اتصال وإشعارات فورية.</p>
        <button>ابدأ جلسة تقييم</button>
      </div>
    </aside>
  );
};
