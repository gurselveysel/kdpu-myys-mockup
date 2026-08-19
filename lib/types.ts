export type RoleKey = "ogrenci" | "ic-egitici" | "dis-egitici" | "komisyon" | "komisyon-baskani" | "koordinator" | "ogrenci-isleri" | "bilgi-islem" | "mali-isler" | "sistem-yoneticisi";

export type ApplicationStatus = "taslak" | "gonderildi" | "on-incelemede" | "eksik-belge" | "duzeltme-bekliyor" | "komisyon-gundeminde" | "onaylandi" | "reddedildi" | "egitim-acildi" | "devam-ediyor" | "degerlendirme-tamamlandi" | "belge-duzenlendi" | "aktarim-bekliyor" | "aktarildi" | "arsivlendi";

export type DemoApplication = {
  id: string;
  title: string;
  type: "program" | "recognition";
  owner: string;
  unit: string;
  status: ApplicationStatus;
  ects: number;
  remoteRate: number;
  matchScore: number;
  slaDaysLeft: number;
};
