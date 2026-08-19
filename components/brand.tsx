import Image from "next/image";
import Link from "next/link";

export function Brand({ compact = false }: { compact?: boolean }) {
  return (
    <Link href="/" className={compact ? "sidebar-brand" : "brand"} aria-label="KDPÜ MYYS ana sayfa">
      <span className="brand-logos">
        <Image
          src="/brand/dpu-logo.png"
          width={compact ? 38 : 48}
          height={compact ? 38 : 48}
          sizes={compact ? "38px" : "48px"}
          alt="Kütahya Dumlupınar Üniversitesi logosu"
          priority
        />
        {!compact && <span className="brand-divider" aria-hidden="true" />}
        <Image
          src="/brand/go-icon.png"
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
