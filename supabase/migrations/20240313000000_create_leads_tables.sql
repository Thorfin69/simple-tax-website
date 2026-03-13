-- Leads table for SympleTax portal submissions
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

-- Payments table (links to leads)
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references public.leads(id) on delete cascade,
  amount int not null,
  plan text default 'full',
  stripe_payment_id text,
  created_at timestamptz default now()
);

-- RLS: Edge Functions use service_role key which bypasses RLS
alter table public.leads enable row level security;
alter table public.payments enable row level security;
