# CareerPilot Phase Tracker

This file tracks what has already been added and what is added in each phase.

## Phase 1 - Project initialization and dependencies

Status: Complete

Added:

1. React + Vite app scaffold alignment for CareerPilot.
2. Route structure and placeholder pages.
3. Folder structure for components/pages/hooks/services/lib/utils.
4. ESLint setup and scripts.
5. Frontend env template (`.env.example`).
6. Supabase placeholder files and directories.

Key files:

- `src/App.jsx`
- `src/components/layout/AppLayout.jsx`
- `src/pages/*`
- `src/hooks/*`
- `src/services/*`
- `src/lib/supabase.js`
- `src/utils/validation.js`
- `eslint.config.js`
- `.env.example`

## Phase 2 - Supabase setup and database schema

Status: Complete

Added in this phase:

1. Full SQL schema for all required tables.
2. Primary/foreign keys and field constraints.
3. Indexes for common access patterns.
4. `updated_at` trigger function for mutable tables.
5. Row Level Security enabled on all user-owned tables.
6. CRUD policies that restrict data access to the authenticated owner.

Key files:

- `supabase/migrations/database.sql`
- `supabase/migrations/20260816123017_phase2_schema_rls.sql`
- `supabase/config.toml`
- `supabase/.gitignore`

## Next phase

Phase 3 - Authentication with Supabase Auth.
