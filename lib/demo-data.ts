import type { DemoApplication, RoleKey } from "./types";

export const roles: { key: RoleKey; name: string; description: string }[] = [
  { key: "ogrenci", name: "Öğrenci", description: "Dış sertifika tanıma başvurusu ve dijital cüzdan" },
  { key: "ic-egitici", name: "Üniversite içi eğitici", description: "Yeni mikro yeterlilik programı önerisi" },
  { key: "dis-egitici", name: "Kurum dışı eğitici", description: "Yetkinlik kanıtlarıyla program önerisi" },
  { key: "komisyon", name: "Komisyon üyesi", description: "Atanmış dosyaları akademik inceleme" },
  { key: "komisyon-baskani", name: "Komisyon başkanı", description: "Gündem, karar ve gerekçe yönetimi" },
  { key: "koordinator", name: "SEM / Koordinatörlük", description: "Ön inceleme, sevk ve katalog yönetimi" },
  { key: "ogrenci-isleri", name: "Öğrenci İşleri", description: "Onaylanan kayıt ve aktarım kuyruğu" },
  { key: "bilgi-islem", name: "Bilgi İşlem", description: "Entegrasyon, olay ve sistem sağlığı" },
  { key: "mali-isler", name: "Mali işler", description: "Tahsilat ve hak ediş simülasyonu" },
  { key: "sistem-yoneticisi", name: "Sistem yöneticisi", description: "Rol matrisi ve denetim kayıtları" },
];

export const applications: DemoApplication[] = [
  { id: "MY-2026-0014", title: "Dijital Sağlıkta Veri Okuryazarlığı", type: "program", owner: "Dr. Ece Aydın", unit: "Sağlık Bilimleri Fakültesi", status: "komisyon-gundeminde", ects: 3, remoteRate: 40, matchScore: 35, slaDaysLeft: 4 },
  { id: "MY-2026-0013", title: "Endüstride Üretken Yapay Zekâ", type: "recognition", owner: "Deniz Kara", unit: "Mühendislik Fakültesi", status: "eksik-belge", ects: 2, remoteRate: 100, matchScore: 58, slaDaysLeft: 12 },
  { id: "MY-2026-0012", title: "Proje Yönetimine Giriş", type: "program", owner: "Doç. Dr. Selim Aras", unit: "İİBF", status: "onaylandi", ects: 2, remoteRate: 50, matchScore: 28, slaDaysLeft: 18 },
  { id: "MY-2026-0011", title: "Temel Programlama Becerileri", type: "recognition", owner: "Eylül Demir", unit: "Fen Edebiyat Fakültesi", status: "reddedildi", ects: 4, remoteRate: 75, matchScore: 82, slaDaysLeft: 0 },
  { id: "MY-2026-0010", title: "Yeşil Dönüşüm ve Sürdürülebilirlik", type: "program", owner: "Dr. Mert Onat", unit: "Lisansüstü Eğitim Enstitüsü", status: "aktarim-bekliyor", ects: 3, remoteRate: 20, matchScore: 31, slaDaysLeft: 9 },
];

export const programs = [
  { code: "MY-DİJ-101", title: "Dijital Yetkinlikler ve Veri Okuryazarlığı", level: "TYÇ 6", ects: 3, mode: "Hibrit", unit: "SEM" },
  { code: "MY-YEŞ-204", title: "Yeşil Dönüşüm Uygulamaları", level: "TYÇ 6", ects: 2, mode: "Yüz yüze", unit: "Mühendislik Fakültesi" },
  { code: "MY-SAĞ-310", title: "Sağlık Eğitiminde Dijital Tasarım", level: "TYÇ 7", ects: 3, mode: "Hibrit", unit: "Sağlık Bilimleri Fakültesi" },
];
