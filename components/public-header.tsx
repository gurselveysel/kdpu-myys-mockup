import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Brand } from "./brand";

export function PublicHeader() {
  return <>
    <div className="topbar"><div className="container"><span>Kütahya Dumlupınar Üniversitesi</span><span>Kontrollü pilot · Canlı kurumsal sisteme bağlı değildir</span></div></div>
    <header className="header">
      <div className="container header-row">
        <Brand />
        <nav className="nav" aria-label="Ana menü">
          <Link href="/sistem">Sistem</Link>
          <Link href="/mikro-yeterlilik">Mikro yeterlilik</Link>
          <Link href="/programlar">Programlar</Link>
          <Link href="/belge-dogrulama">Belge doğrula</Link>
          <Link href="/giris" className="btn btn-primary">Pilota gir <ArrowRight size={16} /></Link>
        </nav>
      </div>
    </header>
  </>;
}

export function PublicFooter() {
  return <footer className="footer"><div className="container footer-grid">
    <div><Brand /><p style={{color:"#cbc7e4",maxWidth:520}}>Bu çalışma, mikro yeterlilik süreçlerini kurumsal karara hazırlamak amacıyla oluşturulmuş kontrollü bir pilot uygulamadır.</p></div>
    <div><b>Pilot kapsamı</b><p style={{color:"#cbc7e4"}}>Gerçek öğrenci verisi kullanılmaz. Dış sistemlere veri gönderilmez.</p></div>
    <div><b>Çözüm geliştirme</b><p style={{color:"#cbc7e4"}}>KampüsGO<br/>Gürsel Online Eğitim ve Bilgi Teknolojileri A.Ş.</p></div>
  </div></footer>;
}
