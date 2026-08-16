-- CareerPilot Phase 2: Supabase schema + Row Level Security

create extension if not exists pgcrypto;

-- Keep timestamps fresh on row updates.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
	new.updated_at = now();
	return new;
end;
$$;

create table if not exists public.profiles (
	id uuid primary key references auth.users(id) on delete cascade,
	full_name text,
	email text,
	created_at timestamptz not null default now()
);

create table if not exists public.jobs (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id) on delete cascade,
	company_name text not null,
	job_title text not null,
	location text,
	job_description text not null,
	status text not null default 'Saved' check (status in ('Saved', 'Applied', 'Interview', 'Offer', 'Rejected')),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table if not exists public.resumes (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null unique references auth.users(id) on delete cascade,
	resume_text text not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table if not exists public.ai_analyses (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id) on delete cascade,
	job_id uuid not null references public.jobs(id) on delete cascade,
	match_score int not null check (match_score between 0 and 100),
	matching_skills text[] not null default '{}',
	missing_skills text[] not null default '{}',
	recommendations text[] not null default '{}',
	created_at timestamptz not null default now()
);

create table if not exists public.interview_sessions (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id) on delete cascade,
	job_id uuid not null references public.jobs(id) on delete cascade,
	created_at timestamptz not null default now()
);

create table if not exists public.interview_questions (
	id uuid primary key default gen_random_uuid(),
	session_id uuid not null references public.interview_sessions(id) on delete cascade,
	question text not null,
	category text,
	difficulty text check (difficulty in ('Easy', 'Medium', 'Hard')),
	answer text,
	score numeric(3,1) check (score between 0 and 10),
	strengths text[] not null default '{}',
	weaknesses text[] not null default '{}',
	suggestions text[] not null default '{}',
	feedback text,
	created_at timestamptz not null default now()
);

create index if not exists idx_jobs_user_id on public.jobs(user_id);
create index if not exists idx_jobs_status on public.jobs(status);
create index if not exists idx_jobs_created_at on public.jobs(created_at desc);

create index if not exists idx_resumes_user_id on public.resumes(user_id);

create index if not exists idx_ai_analyses_user_id on public.ai_analyses(user_id);
create index if not exists idx_ai_analyses_job_id on public.ai_analyses(job_id);
create index if not exists idx_ai_analyses_created_at on public.ai_analyses(created_at desc);

create index if not exists idx_interview_sessions_user_id on public.interview_sessions(user_id);
create index if not exists idx_interview_sessions_job_id on public.interview_sessions(job_id);

create index if not exists idx_interview_questions_session_id on public.interview_questions(session_id);

drop trigger if exists trg_jobs_set_updated_at on public.jobs;
create trigger trg_jobs_set_updated_at
before update on public.jobs
for each row
execute function public.set_updated_at();

drop trigger if exists trg_resumes_set_updated_at on public.resumes;
create trigger trg_resumes_set_updated_at
before update on public.resumes
for each row
execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.jobs enable row level security;
alter table public.resumes enable row level security;
alter table public.ai_analyses enable row level security;
alter table public.interview_sessions enable row level security;
alter table public.interview_questions enable row level security;

-- Profiles: user can only access their own profile row.
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_delete_own"
on public.profiles
for delete
using (auth.uid() = id);

-- Jobs: user can only read/write their own jobs.
drop policy if exists "jobs_select_own" on public.jobs;
create policy "jobs_select_own"
on public.jobs
for select
using (auth.uid() = user_id);

drop policy if exists "jobs_insert_own" on public.jobs;
create policy "jobs_insert_own"
on public.jobs
for insert
with check (auth.uid() = user_id);

drop policy if exists "jobs_update_own" on public.jobs;
create policy "jobs_update_own"
on public.jobs
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "jobs_delete_own" on public.jobs;
create policy "jobs_delete_own"
on public.jobs
for delete
using (auth.uid() = user_id);

-- Resumes: user can only read/write their own resume.
drop policy if exists "resumes_select_own" on public.resumes;
create policy "resumes_select_own"
on public.resumes
for select
using (auth.uid() = user_id);

drop policy if exists "resumes_insert_own" on public.resumes;
create policy "resumes_insert_own"
on public.resumes
for insert
with check (auth.uid() = user_id);

drop policy if exists "resumes_update_own" on public.resumes;
create policy "resumes_update_own"
on public.resumes
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "resumes_delete_own" on public.resumes;
create policy "resumes_delete_own"
on public.resumes
for delete
using (auth.uid() = user_id);

-- AI analyses: user can only read/write their own analyses.
drop policy if exists "ai_analyses_select_own" on public.ai_analyses;
create policy "ai_analyses_select_own"
on public.ai_analyses
for select
using (auth.uid() = user_id);

drop policy if exists "ai_analyses_insert_own" on public.ai_analyses;
create policy "ai_analyses_insert_own"
on public.ai_analyses
for insert
with check (auth.uid() = user_id);

drop policy if exists "ai_analyses_update_own" on public.ai_analyses;
create policy "ai_analyses_update_own"
on public.ai_analyses
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "ai_analyses_delete_own" on public.ai_analyses;
create policy "ai_analyses_delete_own"
on public.ai_analyses
for delete
using (auth.uid() = user_id);

-- Interview sessions: user can only read/write their own sessions.
drop policy if exists "interview_sessions_select_own" on public.interview_sessions;
create policy "interview_sessions_select_own"
on public.interview_sessions
for select
using (auth.uid() = user_id);

drop policy if exists "interview_sessions_insert_own" on public.interview_sessions;
create policy "interview_sessions_insert_own"
on public.interview_sessions
for insert
with check (auth.uid() = user_id);

drop policy if exists "interview_sessions_update_own" on public.interview_sessions;
create policy "interview_sessions_update_own"
on public.interview_sessions
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "interview_sessions_delete_own" on public.interview_sessions;
create policy "interview_sessions_delete_own"
on public.interview_sessions
for delete
using (auth.uid() = user_id);

-- Interview questions are owned through their parent interview session.
drop policy if exists "interview_questions_select_own" on public.interview_questions;
create policy "interview_questions_select_own"
on public.interview_questions
for select
using (
	exists (
		select 1
		from public.interview_sessions s
		where s.id = session_id and s.user_id = auth.uid()
	)
);

drop policy if exists "interview_questions_insert_own" on public.interview_questions;
create policy "interview_questions_insert_own"
on public.interview_questions
for insert
with check (
	exists (
		select 1
		from public.interview_sessions s
		where s.id = session_id and s.user_id = auth.uid()
	)
);

drop policy if exists "interview_questions_update_own" on public.interview_questions;
create policy "interview_questions_update_own"
on public.interview_questions
for update
using (
	exists (
		select 1
		from public.interview_sessions s
		where s.id = session_id and s.user_id = auth.uid()
	)
)
with check (
	exists (
		select 1
		from public.interview_sessions s
		where s.id = session_id and s.user_id = auth.uid()
	)
);

drop policy if exists "interview_questions_delete_own" on public.interview_questions;
create policy "interview_questions_delete_own"
on public.interview_questions
for delete
using (
	exists (
		select 1
		from public.interview_sessions s
		where s.id = session_id and s.user_id = auth.uid()
	)
);
