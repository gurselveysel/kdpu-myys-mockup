begin;
insert into public.organizations(id,name,slug) values ('10000000-0000-0000-0000-000000000001','Kütahya Dumlupınar Üniversitesi','kdpu') on conflict(slug) do nothing;

insert into public.roles(key,name) values
('ogrenci','Öğrenci'),('ic-egitici','Üniversite içi eğitici'),('dis-egitici','Kurum dışı eğitici'),
('komisyon','Komisyon üyesi'),('komisyon-baskani','Komisyon başkanı'),('koordinator','SEM / Koordinatörlük'),
('ogrenci-isleri','Öğrenci İşleri'),('bilgi-islem','Bilgi İşlem'),('mali-isler','Mali işler'),('sistem-yoneticisi','Sistem yöneticisi')
on conflict(key) do update set name=excluded.name;

insert into public.programs(id,organization_id,code,title,summary,tyc_level,ects,delivery_mode,is_published) values
('20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','MY-DIJ-101','Dijital Yetkinlikler ve Veri Okuryazarlığı','Kurgusal kontrollü pilot programı.',6,3,'hibrit',true),
('20000000-0000-0000-0000-000000000002','10000000-0000-0000-0000-000000000001','MY-YES-204','Yeşil Dönüşüm Uygulamaları','Kurgusal kontrollü pilot programı.',6,2,'yuz-yuze',true),
('20000000-0000-0000-0000-000000000003','10000000-0000-0000-0000-000000000001','MY-SAG-310','Sağlık Eğitiminde Dijital Tasarım','Kurgusal kontrollü pilot programı.',7,3,'hibrit',true)
on conflict(code) do update set title=excluded.title,summary=excluded.summary,is_published=true;

insert into public.credentials(id,program_id,public_code,status,metadata,is_cryptographic_simulation) values
('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','KDPU-MY-2026-DEMO','demo','{"learner":"Kurgusal Pilot Öğrencisi","notice":"Gerçek kriptografik imza değildir"}'::jsonb,true)
on conflict(public_code) do nothing;
commit;
