import { ApplicationForm } from "@/components/application-form";
import { DemoBanner } from "@/components/demo-banner";
export default function NewApplication(){return <><div className="page-head"><div><div className="eyebrow">İki başvuru kapısı</div><h1>Yeni başvuru</h1><p className="muted">Program önerisi veya dış kazanım tanıma talebi oluşturun.</p></div></div><DemoBanner>Preview prototipinde form kaydı tarayıcının yerel pilot deposunda tutulur. Supabase üretim RLS şeması ayrıca kurulmuştur.</DemoBanner><div style={{marginTop:18}}><ApplicationForm/></div></>}
