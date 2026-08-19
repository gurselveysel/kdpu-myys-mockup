import { describe, expect, it } from "vitest";
import { canTransition, ectsRate, remoteRate, slaDaysLeft } from "./workflow";

describe("MYYS kural motoru",()=>{
  it("izinli durum geçişini kabul eder",()=>expect(canTransition("taslak","gonderildi")).toBe(true));
  it("yetkisiz durum sıçramasını reddeder",()=>expect(canTransition("taslak","onaylandi")).toBe(false));
  it("AKTS oranını hesaplar",()=>expect(ectsRate(24,240)).toBe(10));
  it("uzaktan eğitim oranını hesaplar",()=>expect(remoteRate(3,6)).toBe(50));
  it("SLA kalan gününü alt sınırla hesaplar",()=>expect(slaDaysLeft(new Date("2026-08-01"),new Date("2026-08-20"))).toBe(11));
});
