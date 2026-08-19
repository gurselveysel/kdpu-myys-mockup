begin;
create index application_documents_application_idx on public.application_documents(application_id);
create index application_documents_uploader_idx on public.application_documents(uploaded_by);
create index application_history_actor_idx on public.application_status_history(actor_id);
create index applications_assignee_idx on public.applications(assigned_commission_member_id);
create index assessments_enrollment_idx on public.assessments(enrollment_id);
create index audit_logs_organization_idx on public.audit_logs(organization_id,created_at desc);
create index commission_decisions_application_idx on public.commission_decisions(application_id);
create index commission_decisions_decider_idx on public.commission_decisions(decided_by);
create index credentials_enrollment_idx on public.credentials(enrollment_id);
create index credentials_learner_idx on public.credentials(learner_id);
create index credentials_program_idx on public.credentials(program_id);
create index curriculum_match_application_idx on public.curriculum_match_results(application_id);
create index enrollments_learner_idx on public.enrollments(learner_id);
create index finance_created_by_idx on public.finance_records(created_by);
create index finance_organization_idx on public.finance_records(organization_id);
create index finance_program_idx on public.finance_records(program_id);
create index integration_jobs_application_idx on public.integration_jobs(application_id);
create index notifications_user_idx on public.notifications(user_id,created_at desc);
create index profiles_organization_idx on public.profiles(organization_id);
create index programs_organization_idx on public.programs(organization_id);
create index reviews_application_idx on public.reviews(application_id);
create index reviews_reviewer_idx on public.reviews(reviewer_id);
create index user_roles_assigned_by_idx on public.user_roles(assigned_by);
create index user_roles_organization_idx on public.user_roles(organization_id);
create index user_roles_role_idx on public.user_roles(role_id);
create index workload_application_idx on public.workload_items(application_id);

drop policy programs_coordinator_write on public.programs;
create policy programs_coordinator_insert on public.programs for insert to authenticated
with check(organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and (private.has_role('koordinator') or private.has_role('sistem-yoneticisi')));
create policy programs_coordinator_update on public.programs for update to authenticated
using(organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and (private.has_role('koordinator') or private.has_role('sistem-yoneticisi')))
with check(organization_id=(select organization_id from public.profiles where id=(select auth.uid())) and (private.has_role('koordinator') or private.has_role('sistem-yoneticisi')));
commit;
