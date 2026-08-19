import { PublicFooter, PublicHeader } from "@/components/public-header";
import { DemoBanner } from "@/components/demo-banner";
import { DemoLogin } from "@/components/demo-login";
export default function Login(){return <><PublicHeader/><main id="main"><div className="login-wrap"><section className="login-card"><div className="eyebrow">Preview ortamı</div><h2>Bir demo rolüyle devam edin</h2><p className="muted">Tüm kullanıcılar ve kayıtlar kurgusaldır. Rol seçimi yalnız kontrollü pilot deneyimini göstermek içindir; gerçek yetkilendirme değildir.</p><DemoBanner/><DemoLogin/></section></div></main><PublicFooter/></>}
