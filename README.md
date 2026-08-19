# KDPÜ Mikro Yeterlilik Yönetim Sistemi — Kontrollü Pilot

Kütahya Dumlupınar Üniversitesi için hazırlanan çalışan MYYS mock-up’ıdır. Başvuru, ön inceleme, komisyon karar desteği, akademik aktarım ve mali süreçlerin rol bazlı deneyimini gösterir.

> Production kararı: **NO-GO**. Canlı kurumsal sistemlere veri göndermez.

## Teknoloji

Next.js App Router, TypeScript, Tailwind CSS, Supabase Postgres/Auth/Storage veri modeli, Zod, Vitest ve Playwright.

## Kurulum

```bash
pnpm install
cp .env.example .env.local
pnpm dev
```

Gerekli değişkenler:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`
- `NEXT_PUBLIC_DEMO_MODE=true`

Secret/service-role anahtarı tarayıcıda kullanılmaz ve repoya eklenmez.

## Kontroller

```bash
pnpm lint
pnpm typecheck
pnpm test
pnpm build
pnpm test:e2e
```

## Demo giriş

`/giris` sayfasında kurgusal roller arasında seçim yapılabilir. Bu seçim yalnız UI akışını göstermek içindir. Preview prototipindeki yeni form kayıtları tarayıcının yerel pilot deposunda tutulur. Gerçek yetkilendirme için Supabase Auth ve migration dosyasındaki RLS politikaları esas alınır.

## Dış entegrasyonlar

ÖBİS, YÖKSİS, e-Devlet, MYS/MAYS, ödeme, biyometrik gözetim ve dijital yeterlilik üretimi yalnız simülasyondur.

## Dokümantasyon

- `docs/role-matrix.md`
- `docs/decisions/0001-controlled-pilot.md`
- `docs/production-checklist.md`
- `supabase/migrations/` ve `supabase/seed.sql`
