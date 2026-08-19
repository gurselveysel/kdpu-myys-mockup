import { FlaskConical } from "lucide-react";

export function DemoBanner({ children = "Demo simülasyonu — canlı kurumsal sisteme veri gönderilmemektedir." }: { children?: React.ReactNode }) {
  return <div className="simulation"><FlaskConical size={15} style={{verticalAlign:"-3px",marginRight:7}} />{children}</div>;
}
