"use client";
export default function ErrorPage({reset}:{reset:()=>void}){return <main id="main" className="login-wrap"><section className="login-card"><div className="eyebrow">Beklenmeyen hata</div><h2>İşlem tamamlanamadı</h2><p className="muted">İç sistem ayrıntıları güvenlik nedeniyle gösterilmez.</p><button className="btn btn-primary" onClick={reset}>Yeniden dene</button></section></main>}
