import Image from "next/image";
import Link from "next/link";
import { DPU_LOGO_DATA, GO_ICON_DATA } from "@/lib/brand-assets";

export function Brand({ compact = false }: { compact?: boolean }) {
  return (
    <Link href="/" className={compact ? "sidebar-brand" : "brand"} aria-label="KDPÜ MYYS ana sayfa">
      <span className="brand-logos">
        <Image
          src={DPU_LOGO_DATA}
          unoptimized
          width={compact ? 38 : 48}
          height={compact ? 38 : 48}
          sizes={compact ? "38px" : "48px"}
          alt="Kütahya Dumlupınar Üniversitesi logosu"
          priority
        />
        {!compact && <span className="brand-divider" aria-hidden="true" />}
        <Image
          src={GO_ICON_DATA}
          unoptimized
          width={compact ? 42 : 48}
          height={compact ? 34 : 38}
          sizes={compact ? "42px" : "48px"}
          alt="KampüsGO çözüm ortağı ikonu"
          priority
        />
      </span>
      <span className="brand-title">
        <strong>KDPÜ Mikro Yeterlilik</strong>
        <span>Yönetim Sistemi · Kontrollü pilot</span>
      </span>
    </Link>
  );
}
