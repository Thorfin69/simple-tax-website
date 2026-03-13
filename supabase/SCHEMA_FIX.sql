-- ═══════════════════════════════════════════════════════════════
-- SympleTax: Complete schema fix for leads table
-- Run this in Supabase Dashboard → SQL Editor if you get column errors
-- Safe to run multiple times
-- ═══════════════════════════════════════════════════════════════

-- 1. Create leads table if it doesn't exist
create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  case_number text not null,
  first_name text,
  last_name text,
  email text not null,
  phone text,
  debt_type text,
  tax_type text,
  active_collections text,
  irs_notice text,
  tax_situation text,
  federal_years int[] default '{}',
  state_years int[] default '{}',
  income text,
  on_irs_plan text,
  irs_plan_monthly int,
  filing_status text,
  bank_balance int default 0,
  investments int default 0,
  owns_real_estate text,
  home_value int default 0,
  home_mortgage int default 0,
  monthly_income int default 0,
  additional_income int default 0,
  state text,
  county text,
  household_size text,
  vehicles_owned text,
  exp_health_insurance int default 0,
  exp_childcare int default 0,
  exp_other_tax int default 0,
  exp_other_obligations int default 0,
  payment_plan text default 'full',
  pre_estimated_debt int default 0,
  pre_estimated_settlement int default 0,
  pre_estimated_savings int default 0,
  source text default 'portal',
  status text default 'full',
  created_at timestamptz default now()
);

-- 2. Add any missing columns (no-op if they exist)
alter table public.leads add column if not exists active_collections text;
alter table public.leads add column if not exists tax_type text;
alter table public.leads add column if not exists debt_type text;
alter table public.leads add column if not exists irs_notice text;
alter table public.leads add column if not exists tax_situation text;
alter table public.leads add column if not exists federal_years int[] default '{}';
alter table public.leads add column if not exists state_years int[] default '{}';
alter table public.leads add column if not exists income text;
alter table public.leads add column if not exists on_irs_plan text;
alter table public.leads add column if not exists irs_plan_monthly int;
alter table public.leads add column if not exists filing_status text;
alter table public.leads add column if not exists bank_balance int default 0;
alter table public.leads add column if not exists investments int default 0;
alter table public.leads add column if not exists owns_real_estate text;
alter table public.leads add column if not exists home_value int default 0;
alter table public.leads add column if not exists home_mortgage int default 0;
alter table public.leads add column if not exists monthly_income int default 0;
alter table public.leads add column if not exists additional_income int default 0;
alter table public.leads add column if not exists state text;
alter table public.leads add column if not exists county text;
alter table public.leads add column if not exists household_size text;
alter table public.leads add column if not exists vehicles_owned text;
alter table public.leads add column if not exists exp_health_insurance int default 0;
alter table public.leads add column if not exists exp_childcare int default 0;
alter table public.leads add column if not exists exp_other_tax int default 0;
alter table public.leads add column if not exists exp_other_obligations int default 0;
alter table public.leads add column if not exists payment_plan text default 'full';
alter table public.leads add column if not exists pre_estimated_debt int default 0;
alter table public.leads add column if not exists pre_estimated_settlement int default 0;
alter table public.leads add column if not exists pre_estimated_savings int default 0;
alter table public.leads add column if not exists source text default 'portal';
alter table public.leads add column if not exists status text default 'full';

-- 3. Create payments table if needed
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references public.leads(id) on delete cascade,
  amount int not null,
  plan text default 'full',
  stripe_payment_id text,
  created_at timestamptz default now()
);

-- 4. Enable RLS (required for Supabase)
alter table public.leads enable row level security;
alter table public.payments enable row level security;
