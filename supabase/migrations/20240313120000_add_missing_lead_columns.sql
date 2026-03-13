-- Add any missing columns to leads table (safe to run multiple times)
-- Fixes: "Could not find the 'active_collections' column" and similar schema drift

alter table public.leads add column if not exists active_collections text;
alter table public.leads add column if not exists tax_type text;
alter table public.leads add column if not exists filing_status text;
alter table public.leads add column if not exists household_size text;
alter table public.leads add column if not exists vehicles_owned text;
alter table public.leads add column if not exists owns_real_estate text;
alter table public.leads add column if not exists home_value int default 0;
alter table public.leads add column if not exists home_mortgage int default 0;
alter table public.leads add column if not exists monthly_income int default 0;
alter table public.leads add column if not exists additional_income int default 0;
