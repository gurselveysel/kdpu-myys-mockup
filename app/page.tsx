import Link from "next/link";
import { ArrowRight, BookOpenCheck, Building2, FileSearch, GraduationCap, ShieldCheck } from "lucide-react";
import { DemoBanner } from "@/components/demo-banner";
import { PublicFooter, PublicHeader } from "@/components/public-header";

const phases = [
  ["Başvuru ve talep", "İç program önerisi veya dış kazanım tanıma"],
  ["Ön inceleme", "Belge, AKTS ve müfredat kuralları"],
  ["Eğitim ve değerlendirme", "Şeffaf, izlenebilir ölçme kanıtları"],
  ["Dijital yeterlilik", "Doğrulanabilir belge demonstrasyonu"],
  ["Akademik entegrasyon", "ÖBİS ve transkript aktarım kuyruğu"],
  ["Finansal yönetim", "Tahsilat ve hak ediş süreçleri"],
];

export default function Home() {
  return <>
    <PublicHeader />
    <main id="main">
      <section className="hero"><div className="container hero-grid">
        <div>
          <div className="eyebrow">Kütahya Dumlupınar Üniversitesi</div>
          <h1>Mikro yeterliliğin tüm yaşam döngüsü, tek kurumsal akışta.</h1>
          <p className="lead">Başvurudan komisyon kararına, belgelendirmeden akademik kayıt hazırlığına kadar izlenebilir ve rol temelli kontrollü pilot.</p>
          <div className="actions">
            <Link className="btn btn-primary" href="/giris">Pilot uygulamaya gir <ArrowRight size={17}/></Link>
            <Link className="btn btn-secondary" href="/sistem">Sistemi incele</Link>
          </div>
        </div>
        <div className="hero-card">
          <DemoBanner />
          <h3 style={{marginTop:22}}>Mevzuat kuralları sonradan eklenen değil, sürecin başındaki kontrollerdir.</h3>
          <div className="rule-grid">
            <div className="rule"><b>30</b><span>günlük karar SLA’sı</span></div>
            <div className="rule"><b>%10</b><span>mikro yeterlilik AKTS tavanı</span></div>
            <div className="rule"><b>%50</b><span>uzaktan eğitim sınırı</span></div>
          </div>
          <p className="hint" style={{marginBottom:0,marginTop:16}}>Kurallar kaynak belgelerden alınmıştır; kurumsal ve hukuki doğrulama gerektirir.</p>
        </div>
      </div></section>

      <section className="section section-white"><div className="container">
        <div className="section-heading"><div className="eyebrow">İki başvuru kapısı</div><h2>Tek portal, birbirinden farklı iki akademik süreç</h2><p className="muted">Her dosya için sahibi, beklediği rol, zaman damgası ve karar gerekçesi görünür.</p></div>
        <div className="grid-2">
          <article className="card"><div className="card-icon"><GraduationCap/></div><h3>Yeni program önerisi</h3><p className="muted">Üniversite birimleri, akademisyenler ve doğrulanmış dış eğiticiler; öğrenme çıktısı, iş yükü ve değerlendirme planıyla teklif oluşturur.</p><Link href="/giris" className="btn btn-secondary">Program öner <ArrowRight size={16}/></Link></article>
          <article className="card"><div className="card-icon"><FileSearch/></div><h3>Dış kazanımın tanınması</h3><p className="muted">Öğrenci, kurum dışında tamamladığı eğitimin kanıtlarını sunar; mükerrerlik, AKTS ve uzaktan eğitim sınırları incelenir.</p><Link href="/giris" className="btn btn-secondary">Tanıma başvurusu yap <ArrowRight size={16}/></Link></article>
        </div>
      </div></section>

      <section className="section"><div className="container">
        <div className="section-heading"><div className="eyebrow">Uçtan uca yaşam döngüsü</div><h2>Altı evre, tek denetim izi</h2></div>
        <div className="lifecycle">{phases.map(([t,d])=><div className="phase" key={t}><b>{t}</b><small>{d}</small></div>)}</div>
      </div></section>

      <section className="section section-white"><div className="container">
        <div className="section-heading"><div className="eyebrow">Akademik sorumluluk</div><h2>Yapay zekâ karar vermez; karşılaştırılabilir kanıt üretir.</h2></div>
        <div className="grid-3">
          <article className="card"><div className="card-icon"><BookOpenCheck/></div><h3>Kural motoru</h3><p className="muted">AKTS, uzaktan eğitim ve mükerrerlik risklerini karar öncesinde görünür kılar.</p></article>
          <article className="card"><div className="card-icon"><Building2/></div><h3>Rol ve yetki</h3><p className="muted">Başvuran, koordinatörlük, komisyon ve öğrenci işleri aynı kaydın yalnız yetkili bölümünü yönetir.</p></article>
          <article className="card"><div className="card-icon"><ShieldCheck/></div><h3>Denetlenebilirlik</h3><p className="muted">Her değişiklik, gerekçe ve karar zaman damgalı bir denetim izi oluşturur.</p></article>
        </div>
        <div style={{marginTop:24}}><DemoBanner>Bu sonuç karar desteğidir. Nihai akademik ve idari sorumluluk yetkili komisyondadır.</DemoBanner></div>
      </div></section>
    </main>
    <PublicFooter />
  </>;
}
