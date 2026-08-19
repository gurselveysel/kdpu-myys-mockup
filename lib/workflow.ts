import type { ApplicationStatus } from "./types";

export const allowedTransitions: Record<ApplicationStatus, ApplicationStatus[]> = {
  taslak: ["gonderildi"],
  gonderildi: ["on-incelemede"],
  "on-incelemede": ["eksik-belge", "komisyon-gundeminde"],
  "eksik-belge": ["duzeltme-bekliyor"],
  "duzeltme-bekliyor": ["gonderildi"],
  "komisyon-gundeminde": ["onaylandi", "reddedildi", "duzeltme-bekliyor"],
  onaylandi: ["egitim-acildi", "aktarim-bekliyor"],
  reddedildi: ["arsivlendi"],
  "egitim-acildi": ["devam-ediyor"],
  "devam-ediyor": ["degerlendirme-tamamlandi"],
  "degerlendirme-tamamlandi": ["belge-duzenlendi"],
  "belge-duzenlendi": ["aktarim-bekliyor"],
  "aktarim-bekliyor": ["aktarildi"],
  aktarildi: ["arsivlendi"],
  arsivlendi: [],
};

export function canTransition(from: ApplicationStatus, to: ApplicationStatus) {
  return allowedTransitions[from].includes(to);
}

export function ectsRate(current: number, degreeTotal: number) {
  if (degreeTotal <= 0) throw new Error("Toplam AKTS sıfırdan büyük olmalıdır.");
  return Number(((current / degreeTotal) * 100).toFixed(2));
}

export function remoteRate(remoteEcts: number, transferredEcts: number) {
  if (transferredEcts <= 0) return 0;
  return Number(((remoteEcts / transferredEcts) * 100).toFixed(2));
}

export function slaDaysLeft(submittedAt: Date, now = new Date(), limit = 30) {
  const elapsed = Math.floor((now.getTime() - submittedAt.getTime()) / 86_400_000);
  return Math.max(0, limit - elapsed);
}
