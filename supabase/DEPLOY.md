# Deploy Supabase Edge Functions

Run these commands from the project root (or from the `supabase` directory).

## 1. Link to your Supabase project (if not already)

```bash
supabase link --project-ref YOUR_PROJECT_REF
```

## 2. Run database migration

```bash
supabase db push
```

Or run the SQL in `migrations/20240313000000_create_leads_tables.sql` in the Supabase SQL Editor.

## 3. Set secrets

```bash
supabase secrets set RESEND_API_KEY=re_xxxxxxxxxxxx
supabase secrets set STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxx
supabase secrets set CLIENT_EMAIL=your-email@company.com
```

## 4. Deploy functions

```bash
supabase functions deploy submit-lead
supabase functions deploy create-payment-intent
```

## 5. Update frontend

In `SympleTax_Portal_v6 (1).html`, replace `YOUR_PROJECT_REF` in:

```javascript
const SUPABASE_FUNCTIONS_URL = 'https://YOUR_PROJECT_REF.supabase.co/functions/v1';
```

## 6. Test

1. Open your deployed portal
2. Complete the form and payment (use Stripe test card 4242 4242 4242 4242)
3. Check that the user and client both receive confirmation emails

## Troubleshooting: "Could not find the 'active_collections' column"

If you get a 400 error about missing columns:

1. Open **Supabase Dashboard** → **SQL Editor**
2. Copy the entire contents of `supabase/SCHEMA_FIX.sql`
3. Paste and click **Run**

This creates the full schema and adds any missing columns. Safe to run multiple times.

Or use CLI: `supabase db push`
