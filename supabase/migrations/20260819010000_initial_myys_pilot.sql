begin;

create extension if not exists pgcrypto;
create schema if not exists private;

create type public.application_type as enum ('program', 'recognition');
create type public.application_status as enum (
  'taslak','gonderildi','on-incelemede','eksik-belge','duzeltme-bekliyor',
  'komisyon-gundeminde','onaylandi','reddedildi','egitim-acildi','devam-ediyor',
  'degerlendirme-tamamlandi','belge-duzenlendi','aktarim-bekliyor','aktarildi','arsivlendi'
);
create type public.decision_type as enum ('onay','ret','duzeltme');
create type public.job_status as enum ('bekliyor','isleniyor','basarili','hatali','iptal');

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  organization_id uuid not null references public.organizations(id),
  full_name text not null,
  unit_name text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.roles (
  id uuid primary key default gen_random_uuid(),
  key text not null unique check (key in ('ogrenci','ic-egitici','dis-egitici','komisyon','komisyon-baskani','koordinator','ogrenci-isleri','bilgi-islem','mali-isler','sistem-yoneticisi')),
  name text not null,
  created_at timestamptz not null default now()
);

create table public.user_roles (
  user_id uuid not null references public.profiles(id) on delete cascade,
  role_id uuid not null references public.roles(id) on delete cascade,
  organization_id uuid not null references public.organizations(id) on delete cascade,
  assigned_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  primary key (user_id, role_id, organization_id)
);

create table public.applications (
  id uuid primary key default gen_random_uuid(),
  reference_no text not null unique,
  organization_id uuid not null references public.organizations(id),
  applicant_id uuid not null references public.profiles(id),
  type public.application_type not null,
  title text not null check (char_length(title) between 5 and 240),
  unit_name text not null,
  status public.application_status not null default 'taslak',
  ects numeric(5,2) check (ects > 0 and ects <= 30),
  remote_rate numeric(5,2) check (remote_rate between 0 and 100),
  submitted_at timestamptz,
  sla_due_at timestamptz,
  assigned_commission_member_id uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index applications_org_status_idx on public.applications(organization_id,status);
create index applications_applicant_idx on public.applications(applicant_id,created_at desc);
create index applications_sla_idx on public.applications(sla_due_at) where status not in ('onaylandi','reddedildi','arsivlendi');

create table public.application_status_history (
  id bigint generated always as identity primary key,
  application_id uuid not null references public.applications(id) on delete cascade,
  actor_id uuid references public.profiles(id),
  previous_status public.application_status,
  new_status public.application_status not null,
  reason text,
  decision_no text,
  created_at timestamptz not null default now()
);
create index application_history_app_idx on public.application_status_history(application_id,created_at desc);

create table public.program_proposals (
  application_id uuid primary key references public.applications(id) on delete cascade,
  tyc_level smallint check (tyc_level between 5 and 8),
  delivery_mode text not null check (delivery_mode in ('yuz-yuze','uzaktan','hibrit')),
  assessment_plan text not null,
  target_audience text,
  instructor_qualifications text,
  created_at timestamptz not null default now()
);

create table public.external_recognition_requests (
  application_id uuid primary key references public.applications(id) on delete cascade,
  provider_name text not null,
  verification_url text,
  certificate_code text,
  earned_at date,
  requested_course_code text,
  created_at timestamptz not null default now()
);

create table public.learning_outcomes (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  position smallint not null check (position > 0),
  outcome_text text not null check (char_length(outcome_text) >= 15),
  unique(application_id,position)
);

create table public.workload_items (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  activity_name text not null,
  quantity numeric(8,2) not null default 1 check (quantity >= 0),
  hours_each numeric(8,2) not null check (hours_each >= 0),
  total_hours numeric(10,2) generated always as (quantity * hours_each) stored
);

create table public.application_documents (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  uploaded_by uuid not null references public.profiles(id),
  bucket_id text not null default 'application-documents' check (bucket_id = 'application-documents'),
  object_path text not null unique,
  file_name text not null,
  mime_type text not null check (mime_type in ('application/pdf','image/png','image/jpeg')),
  size_bytes bigint not null check (size_bytes > 0 and size_bytes <= 10485760),
  document_type text not null,
  created_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  reviewer_id uuid not null references public.profiles(id),
  review_stage text not null check (review_stage in ('on-inceleme','akademik','mali','teknik')),
  recommendation public.decision_type,
  notes text not null,
  is_final boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.commission_decisions (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete restrict,
  decision public.decision_type not null,
  rationale text not null check (char_length(rationale) >= 20),
  decision_no text not null unique,
  decided_by uuid not null references public.profiles(id),
  decided_at timestamptz not null default now()
);

create table public.rule_checks (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  rule_key text not null check (rule_key in ('ects-10','remote-50','duplicate-course','documents','sla')),
  result text not null check (result in ('pass','warn','block','not-run')),
  measured_value numeric,
  threshold_value numeric,
  explanation text,
  is_simulation boolean not null default true,
  checked_at timestamptz not null default now(),
  unique(application_id,rule_key)
);

create table public.curriculum_match_results (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  compared_course_code text,
  match_score numeric(5,2) not null check (match_score between 0 and 100),
  risk_band text generated always as (case when match_score <= 40 then 'guvenli' when match_score <= 70 then 'uyari' else 'yuksek-risk' end) stored,
  explanation text,
  is_simulation boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.programs (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id),
  source_application_id uuid unique references public.applications(id),
  code text not null unique,
  title text not null,
  summary text not null,
  tyc_level smallint check (tyc_level between 5 and 8),
  ects numeric(5,2) not null check (ects > 0),
  delivery_mode text not null,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);
create index programs_published_idx on public.programs(is_published,created_at desc);

create table public.enrollments (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references public.programs(id),
  learner_id uuid not null references public.profiles(id),
  status text not null check (status in ('kayitli','devam-ediyor','tamamlandi','basarisiz','iptal')),
  enrolled_at timestamptz not null default now(),
  completed_at timestamptz,
  unique(program_id,learner_id)
);

create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  method text not null,
  score numeric(5,2) check (score between 0 and 100),
  passed boolean,
  evidence_summary text,
  proctoring_score numeric(5,2) check (proctoring_score between 0 and 100),
  is_proctoring_simulation boolean not null default true,
  assessed_at timestamptz not null default now()
);

create table public.credentials (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid references public.enrollments(id),
  learner_id uuid references public.profiles(id),
  program_id uuid not null references public.programs(id),
  public_code text not null unique,
  status text not null default 'demo' check (status in ('demo','issued','revoked')),
  metadata jsonb not null default '{}'::jsonb,
  is_cryptographic_simulation boolean not null default true,
  issued_at timestamptz not null default now()
);

create table public.integration_jobs (
  id uuid primary key default gen_random_uuid(),
  application_id uuid references public.applications(id),
  integration_key text not null check (integration_key in ('obis','yoksis','e-devlet','mys-mays','digital-wallet')),
  status public.job_status not null default 'bekliyor',
  attempt_count smallint not null default 0 check (attempt_count >= 0),
  payload_summary jsonb not null default '{}'::jsonb,
  last_error_masked text,
  is_simulation boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  href text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.finance_records (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id),
  program_id uuid references public.programs(id),
  record_type text not null check (record_type in ('tahsilat','iade','egitici-hakedis','vergi','doner-sermaye')),
  amount numeric(14,2) not null check (amount >= 0),
  currency char(3) not null default 'TRY',
  status public.job_status not null default 'bekliyor',
  is_simulation boolean not null default true,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.audit_logs (
  id bigint generated always as identity primary key,
  organization_id uuid references public.organizations(id),
  actor_id uuid references public.profiles(id),
  entity_type text not null,
  entity_id text not null,
  action text not null,
  old_data jsonb,
  new_data jsonb,
  created_at timestamptz not null default now()
);
create index audit_logs_entity_idx on public.audit_logs(entity_type,entity_id,created_at desc);
create index audit_logs_actor_idx on public.audit_logs(actor_id,created_at desc);

create or replace function private.has_role(requested_role text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) is not null and exists (
    select 1 from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    join public.profiles p on p.id = ur.user_id and p.organization_id = ur.organization_id
    where ur.user_id = (select auth.uid()) and r.key = requested_role and p.is_active
  );
$$;

create or replace function private.can_manage_app(target public.applications)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) = target.applicant_id
    or (select auth.uid()) = target.assigned_commission_member_id
    or (target.organization_id = (select p.organization_id from public.profiles p where p.id = (select auth.uid()))
      and (private.has_role('koordinator') or private.has_role('komisyon') or private.has_role('komisyon-baskani') or private.has_role('sistem-yoneticisi')));
$$;

create or replace function private.is_valid_transition(old_status public.application_status,new_status public.application_status)
returns boolean language sql immutable set search_path='' as $$
  select (old_status,new_status) in (
    ('taslak','gonderildi'),('gonderildi','on-incelemede'),('on-incelemede','eksik-belge'),('on-incelemede','komisyon-gundeminde'),
    ('eksik-belge','duzeltme-bekliyor'),('duzeltme-bekliyor','gonderildi'),('komisyon-gundeminde','onaylandi'),
    ('komisyon-gundeminde','reddedildi'),('komisyon-gundeminde','duzeltme-bekliyor'),('onaylandi','egitim-acildi'),
    ('onaylandi','aktarim-bekliyor'),('reddedildi','arsivlendi'),('egitim-acildi','devam-ediyor'),
    ('devam-ediyor','degerlendirme-tamamlandi'),('degerlendirme-tamamlandi','belge-duzenlendi'),
    ('belge-duzenlendi','aktarim-bekliyor'),('aktarim-bekliyor','aktarildi'),('aktarildi','arsivlendi')
  );
$$;

create or replace function private.track_application_status()
returns trigger language plpgsql security definer set search_path='' as $$
begin
  if tg_op='INSERT' then
    insert into public.application_status_history(application_id,actor_id,new_status,reason)
    values(new.id,(select auth.uid()),new.status,'Başvuru oluşturuldu');
    return new;
  end if;
  if new.status is distinct from old.status then
    if not private.is_valid_transition(old.status,new.status) then
      raise exception 'Geçersiz durum geçişi: % -> %',old.status,new.status;
    end if;
    if new.status='gonderildi' and new.submitted_at is null then
      new.submitted_at=now(); new.sla_due_at=now()+interval '30 days';
    end if;
    insert into public.application_status_history(application_id,actor_id,previous_status,new_status,reason)
    values(new.id,(select auth.uid()),old.status,new.status,'Durum değiştirildi');
  end if;
  new.updated_at=now();
  return new;
end;
$$;
create trigger applications_status_history before insert or update on public.applications for each row execute function private.track_application_status();

create or replace function private.audit_change()
returns trigger language plpgsql security definer set search_path='' as $$
declare row_new jsonb; row_old jsonb; entity text; org uuid;
begin
  row_new=case when tg_op='DELETE' then null else to_jsonb(new) end;
  row_old=case when tg_op='INSERT' then null else to_jsonb(old) end;
  entity=coalesce(row_new->>'id',row_old->>'id',row_new->>'application_id',row_old->>'application_id','unknown');
  org=coalesce((row_new->>'organization_id')::uuid,(row_old->>'organization_id')::uuid);
  insert into public.audit_logs(organization_id,actor_id,entity_type,entity_id,action,old_data,new_data)
  values(org,(select auth.uid()),tg_table_name,entity,tg_op,row_old,row_new);
  return coalesce(new,old);
exception when invalid_text_representation then
  insert into public.audit_logs(actor_id,entity_type,entity_id,action,old_data,new_data)
  values((select auth.uid()),tg_table_name,entity,tg_op,row_old,row_new);
  return coalesce(new,old);
end;
$$;
create trigger audit_applications after insert or update or delete on public.applications for each row execute function private.audit_change();
create trigger audit_reviews after insert or update or delete on public.reviews for each row execute function private.audit_change();
create trigger audit_decisions after insert or update or delete on public.commission_decisions for each row execute function private.audit_change();
create trigger audit_integration_jobs after insert or update or delete on public.integration_jobs for each row execute function private.audit_change();
create trigger audit_finance after insert or update or delete on public.finance_records for each row execute function private.audit_change();

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values
('application-documents','application-documents',false,10485760,array['application/pdf','image/png','image/jpeg']),
('credential-assets','credential-assets',false,10485760,array['application/pdf','image/png','image/jpeg'])
on conflict(id) do update set public=false,file_size_limit=excluded.file_size_limit,allowed_mime_types=excluded.allowed_mime_types;

-- Privileges and RLS are separate layers. Start closed, then grant only required operations.
revoke all on all tables in schema public from anon,authenticated;
grant usage on schema public to anon,authenticated;
grant select on public.programs,public.credentials to anon;
grant select on public.organizations,public.roles,public.profiles,public.user_roles to authenticated;
grant select,insert,update on public.applications,public.program_proposals,public.external_recognition_requests,public.learning_outcomes,public.workload_items,public.application_documents,public.reviews,public.rule_checks,public.curriculum_match_results,public.enrollments,public.assessments,public.notifications to authenticated;
grant select on public.application_status_history to authenticated;
grant select,insert on public.commission_decisions to authenticated;
grant select,insert,update on public.programs,public.credentials,public.integration_jobs,public.finance_records to authenticated;
grant select on public.audit_logs to authenticated;
grant usage,select on all sequences in schema public to authenticated;

alter table public.organizations enable row level security;
alter table public.profiles enable row level security;
alter table public.roles enable row level security;
alter table public.user_roles enable row level security;
alter table public.applications enable row level security;
alter table public.application_status_history enable row level security;
alter table public.program_proposals enable row level security;
alter table public.external_recognition_requests enable row level security;
alter table public.learning_outcomes enable row level security;
alter table public.workload_items enable row level security;
alter table public.application_documents enable row level security;
alter table public.reviews enable row level security;
alter table public.commission_decisions enable row level security;
alter table public.rule_checks enable row level security;
alter table public.curriculum_match_results enable row level security;
alter table public.programs enable row level security;
alter table public.enrollments enable row level security;
alter table public.assessments enable row level security;
alter table public.credentials enable row level security;
alter table public.integration_jobs enable row level security;
alter table public.notifications enable row level security;
alter table public.finance_records enable row level security;
alter table public.audit_logs enable row level security;

create policy organizations_member_read on public.organizations for select to authenticated using (id=(select organization_id from public.profiles where id=(select auth.uid())));
create policy profiles_self_or_admin_read on public.profiles for select to authenticated using (id=(select auth.uid()) or (organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and private.has_role('sistem-yoneticisi')));
create policy profiles_self_update on public.profiles for update to authenticated using(id=(select auth.uid())) with check(id=(select auth.uid()));
create policy roles_authenticated_read on public.roles for select to authenticated using(true);
create policy user_roles_self_or_admin_read on public.user_roles for select to authenticated using(user_id=(select auth.uid()) or (organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and private.has_role('sistem-yoneticisi')));

create policy applications_authorized_read on public.applications for select to authenticated using(private.can_manage_app(applications) or (private.has_role('ogrenci-isleri') and status in ('onaylandi','belge-duzenlendi','aktarim-bekliyor','aktarildi')) or private.has_role('bilgi-islem') or private.has_role('mali-isler'));
create policy applications_owner_insert on public.applications for insert to authenticated with check(applicant_id=(select auth.uid()) and organization_id=(select organization_id from public.profiles where id=(select auth.uid())));
create policy applications_authorized_update on public.applications for update to authenticated using(private.can_manage_app(applications)) with check(private.can_manage_app(applications));
create policy history_authorized_read on public.application_status_history for select to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)) or private.has_role('ogrenci-isleri') or private.has_role('bilgi-islem'));

create policy program_proposals_authorized on public.program_proposals for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy recognition_authorized on public.external_recognition_requests for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy outcomes_authorized on public.learning_outcomes for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy workload_authorized on public.workload_items for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy documents_authorized on public.application_documents for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(uploaded_by=(select auth.uid()) and exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy reviews_authorized_read on public.reviews for select to authenticated using(reviewer_id=(select auth.uid()) or exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy reviews_reviewer_write on public.reviews for insert to authenticated with check(reviewer_id=(select auth.uid()) and (private.has_role('komisyon') or private.has_role('komisyon-baskani') or private.has_role('koordinator')));
create policy reviews_reviewer_update on public.reviews for update to authenticated using(reviewer_id=(select auth.uid())) with check(reviewer_id=(select auth.uid()));
create policy decisions_authorized_read on public.commission_decisions for select to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)) or private.has_role('ogrenci-isleri'));
create policy decisions_chair_insert on public.commission_decisions for insert to authenticated with check(decided_by=(select auth.uid()) and private.has_role('komisyon-baskani'));
create policy rule_checks_authorized on public.rule_checks for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));
create policy match_results_authorized on public.curriculum_match_results for all to authenticated using(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a))) with check(exists(select 1 from public.applications a where a.id=application_id and private.can_manage_app(a)));

create policy programs_public_read on public.programs for select to anon using(is_published);
create policy programs_authenticated_read on public.programs for select to authenticated using(is_published or organization_id=(select organization_id from public.profiles where id=(select auth.uid())));
create policy programs_coordinator_write on public.programs for all to authenticated using(private.has_role('koordinator') or private.has_role('sistem-yoneticisi')) with check(organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and (private.has_role('koordinator') or private.has_role('sistem-yoneticisi')));
create policy enrollments_learner_or_staff on public.enrollments for select to authenticated using(learner_id=(select auth.uid()) or private.has_role('koordinator') or private.has_role('ogrenci-isleri'));
create policy enrollments_staff_write on public.enrollments for insert to authenticated with check(private.has_role('koordinator'));
create policy enrollments_staff_update on public.enrollments for update to authenticated using(private.has_role('koordinator')) with check(private.has_role('koordinator'));
create policy assessments_learner_or_staff on public.assessments for select to authenticated using(exists(select 1 from public.enrollments e where e.id=enrollment_id and (e.learner_id=(select auth.uid()) or private.has_role('koordinator') or private.has_role('ogrenci-isleri'))));
create policy assessments_staff_write on public.assessments for insert to authenticated with check(private.has_role('koordinator'));
create policy assessments_staff_update on public.assessments for update to authenticated using(private.has_role('koordinator')) with check(private.has_role('koordinator'));
create policy credentials_public_demo_read on public.credentials for select to anon using(status in ('demo','issued'));
create policy credentials_owner_or_staff_read on public.credentials for select to authenticated using(learner_id=(select auth.uid()) or private.has_role('ogrenci-isleri') or private.has_role('koordinator'));
create policy credentials_staff_write on public.credentials for insert to authenticated with check(private.has_role('ogrenci-isleri'));
create policy credentials_staff_update on public.credentials for update to authenticated using(private.has_role('ogrenci-isleri')) with check(private.has_role('ogrenci-isleri'));

create policy integration_it_read on public.integration_jobs for select to authenticated using(private.has_role('bilgi-islem') or private.has_role('ogrenci-isleri') or private.has_role('sistem-yoneticisi'));
create policy integration_it_insert on public.integration_jobs for insert to authenticated with check(private.has_role('bilgi-islem') or private.has_role('ogrenci-isleri'));
create policy integration_it_update on public.integration_jobs for update to authenticated using(private.has_role('bilgi-islem')) with check(private.has_role('bilgi-islem'));
create policy notifications_owner_read on public.notifications for select to authenticated using(user_id=(select auth.uid()));
create policy notifications_owner_update on public.notifications for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy finance_staff_read on public.finance_records for select to authenticated using(private.has_role('mali-isler') or private.has_role('sistem-yoneticisi'));
create policy finance_staff_insert on public.finance_records for insert to authenticated with check(private.has_role('mali-isler') and organization_id=(select organization_id from public.profiles where id=(select auth.uid())));
create policy finance_staff_update on public.finance_records for update to authenticated using(private.has_role('mali-isler')) with check(private.has_role('mali-isler'));
create policy audit_authorized_read on public.audit_logs for select to authenticated using(actor_id=(select auth.uid()) or (organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and (private.has_role('sistem-yoneticisi') or private.has_role('bilgi-islem'))));

create policy storage_application_select on storage.objects for select to authenticated using(bucket_id='application-documents' and exists(select 1 from public.application_documents d join public.applications a on a.id=d.application_id where d.object_path=name and private.can_manage_app(a)));
create policy storage_application_insert on storage.objects for insert to authenticated with check(bucket_id='application-documents' and owner_id=(select auth.uid())::text);
create policy storage_application_update on storage.objects for update to authenticated using(bucket_id='application-documents' and owner_id=(select auth.uid())::text) with check(bucket_id='application-documents' and owner_id=(select auth.uid())::text);
create policy storage_credential_select on storage.objects for select to authenticated using(bucket_id='credential-assets' and (private.has_role('ogrenci-isleri') or private.has_role('koordinator')));
create policy storage_credential_insert on storage.objects for insert to authenticated with check(bucket_id='credential-assets' and private.has_role('ogrenci-isleri'));
create policy storage_credential_update on storage.objects for update to authenticated using(bucket_id='credential-assets' and private.has_role('ogrenci-isleri')) with check(bucket_id='credential-assets' and private.has_role('ogrenci-isleri'));

revoke all on schema private from public,anon;
grant usage on schema private to authenticated;
revoke all on all functions in schema private from public,anon,authenticated;
grant execute on function private.has_role(text),private.can_manage_app(public.applications) to authenticated;

commit;
