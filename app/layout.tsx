import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: { default: "KDPÜ Mikro Yeterlilik Yönetim Sistemi", template: "%s | KDPÜ MYYS" },
  description: "Kütahya Dumlupınar Üniversitesi Mikro Yeterlilik Yönetim Sistemi kontrollü pilotu.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="tr">
      <body>
        <a className="skip-link" href="#main">Ana içeriğe geç</a>
        {children}
      </body>
    </html>
  );
}
