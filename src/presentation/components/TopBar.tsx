import React from 'react';
import '@styles/topbar.css';

export const TopBar: React.FC = () => {
  return (
    <header className="topbar">
      <div>
        <p className="topbar__date">الأربعاء، 17 أبريل 2024</p>
        <h2 className="topbar__greeting">مرحبًا د. لمى 👋</h2>
      </div>

      <div className="topbar__actions">
        <div className="topbar__status">
          <span className="dot online" />
          وضع العمل دون اتصال متاح
        </div>
        <button className="ghost">إرسال تقرير فوري</button>
        <div className="topbar__avatar" aria-label="حساب الطبيب">
          <img src="https://i.pravatar.cc/100?img=47" alt="الطبيبة" />
        </div>
      </div>
    </header>
  );
};
