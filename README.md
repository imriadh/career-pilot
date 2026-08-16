# CareerPilot - AI Job and Interview Assistant

CareerPilot is a university MVP web application that helps job seekers manage applications and use AI for job-match analysis and interview preparation.

This repository currently contains **Phase 1 and Phase 2 foundations**.

Progress tracking:

1. See `docs/phase-tracker.md` for what was added in each phase.

## Final Architecture (High-level)

CareerPilot uses a layered architecture so each concern stays separated and easy to explain:

1. **Frontend (React + React Router)**
   - Pages, reusable components, and controlled forms.
   - Handles UI state such as loading, success, and error messages.
2. **Frontend service layer (`src/services`)**
   - Central place for data/API calls.
   - Prevents query logic from being scattered inside UI components.
3. **Supabase platform**
   - Authentication, PostgreSQL database, and Row Level Security (RLS).
   - RLS enforces per-user data access at the database layer.
4. **Supabase Edge Functions**
   - Secure server-side integration point for NVIDIA NIM API.
   - Keeps AI secrets off the browser.

## Why these technologies

1. **React**: component-based UI that is easy to build and maintain.
2. **React Router**: multi-page navigation for login, dashboard, jobs, resume, and AI screens.
3. **Supabase**: managed backend with Auth + Postgres + RLS, ideal for a one-week MVP.
4. **Supabase Edge Functions (TypeScript/Deno)**: secure server logic for AI calls.
5. **NVIDIA NIM API**: AI analysis and interview feedback through structured prompts.

## Required software and accounts

Install/create these before moving beyond Phase 1:

1. **Node.js LTS** (v20+ recommended)
2. **npm** (comes with Node.js)
3. **Git**
4. **Supabase account**
5. **Supabase CLI** (for migrations/functions in later phases)
6. **NVIDIA API access** (for later AI phases)
7. **Vercel account** (deployment phase)

## Phase status

### Phase 1 - Project foundation (Complete)

Implemented in this phase:

1. Routing-ready React app shell.
2. Project folder structure for pages/components/hooks/services/lib/utils.
3. Supabase and Edge Function placeholder directories/files.
4. ESLint-based lint pipeline.
5. `.env.example` with safe public frontend variables only.

### Phase 2 - Supabase setup and database schema (Complete)

Implemented in this phase:

1. SQL schema for all required tables.
2. Constraints and indexes.
3. RLS enablement and owner-scoped CRUD policies.

Not implemented yet:

1. Authentication logic.
2. Job CRUD.
3. AI analysis/interview workflows.

## Folder structure

```text
src/
	components/
		ui/
		layout/
		jobs/
		interview/
	pages/
		Login.jsx
		Register.jsx
		Dashboard.jsx
		Jobs.jsx
		JobDetails.jsx
		Resume.jsx
		Analysis.jsx
		Interview.jsx
		Profile.jsx
	hooks/
		useAuth.js
		useJobs.js
	services/
		jobs.js
		resume.js
		ai.js
	lib/
		supabase.js
	utils/
		validation.js
	App.jsx
	main.jsx
	index.css

supabase/
	config.toml
	migrations/
		20260816123017_phase2_schema_rls.sql
		database.sql
	functions/
		ai-analysis/
			index.ts
```

## Environment variables

Copy `.env.example` to `.env` and set values:

```bash
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
```

Important:

1. Frontend can only use public-safe values.
2. Do not put NVIDIA API keys in frontend `.env`.
3. NVIDIA key must stay in Supabase Edge Function secrets in later phases.

## Exact Phase 1 commands

```bash
npm install
npm run dev
```

Quality checks:

```bash
npm run lint
npm run build
```

## Exact Phase 2 commands

```bash
npx supabase --version
npx supabase init
```

Apply schema on Supabase (choose one):

```bash
# Option A: Supabase dashboard SQL editor
# Paste and run supabase/migrations/database.sql

# Option B: CLI migration workflow (after linking your project)
npx supabase db push
```

Notes:

1. `supabase/migrations/database.sql` is the human-readable source file for this project.
2. `supabase/migrations/20260816123017_phase2_schema_rls.sql` is the CLI-friendly timestamped migration.

## Manual testing (Phase 1)

1. Start the app with `npm run dev`.
2. Open the shown local URL.
3. Confirm nav links render and routes change pages:
   - `/`, `/jobs`, `/jobs/:id`, `/resume`, `/analysis`, `/interview`, `/profile`, `/login`, `/register`
4. Run `npm run lint` and ensure no lint errors.
5. Run `npm run build` and ensure build succeeds.

## Manual testing (Phase 2)

1. Apply the SQL schema to your Supabase project.
2. Open Supabase Table Editor and verify tables exist:
3. `profiles`, `jobs`, `resumes`, `ai_analyses`, `interview_sessions`, `interview_questions`.
4. In Supabase SQL editor, verify RLS is enabled:

```sql
select tablename, rowsecurity
from pg_tables
where schemaname = 'public'
order by tablename;
```

5. Verify owner-only policy behavior in Phase 3/7 when auth flow is implemented.

## Common errors and fixes

1. **`Cannot find module './App.jsx'`**
   - Ensure `src/App.jsx` exists (added in Phase 1 scaffold).
2. **`'VITE_SUPABASE_URL' is undefined`**
   - Create `.env` from `.env.example`.
3. **Lint command fails with missing packages**
   - Run `npm install` again.
4. **Port already in use**
   - Stop old process or run `npm run dev -- --port 5174`.
5. **`supabase` command not found**
   - Use `npx supabase --version` and `npx supabase init`.
