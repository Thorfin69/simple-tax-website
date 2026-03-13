# SympleTax Email & Backend Setup

This guide walks you through deploying the lead submission flow with email confirmations.

## 1. Resend (Email Service)

1. Sign up at [resend.com](https://resend.com) (free, 500 emails/month)
2. Verify your domain or use `onboarding@resend.dev` for testing
3. Create an API key in the Resend dashboard
4. Store it in Supabase: `supabase secrets set RESEND_API_KEY=re_xxxx`

## 2. Supabase Setup

### Database

Run the migration to create `leads` and `payments` tables:

```bash
supabase db push
```

Or run the SQL in `supabase/migrations/20240313000000_create_leads_tables.sql` manually in the Supabase SQL editor.

### Secrets

Set these secrets for your Edge Functions:

```bash
supabase secrets set RESEND_API_KEY=re_xxxx
supabase secrets set STRIPE_SECRET_KEY=sk_xxxx
supabase secrets set CLIENT_EMAIL=your-email@company.com
```

- `RESEND_API_KEY` — from Resend dashboard
- `STRIPE_SECRET_KEY` — your Stripe secret key (for create-payment-intent)
- `CLIENT_EMAIL` — where new lead notifications are sent

Optional: `RESEND_FROM_DOMAIN` — use your verified domain (e.g. `noreply@yourdomain.com`). Default is `onboarding@resend.dev`.

### Deploy Edge Functions

```bash
supabase functions deploy submit-lead
supabase functions deploy create-payment-intent
```

## 3. Frontend Configuration

In `SympleTax_Portal_v6 (1).html`, replace `YOUR_PROJECT_REF` with your Supabase project reference:

```javascript
const SUPABASE_FUNCTIONS_URL = 'https://YOUR_PROJECT_REF.supabase.co/functions/v1';
```

Find your project ref in the Supabase dashboard URL: `https://app.supabase.com/project/YOUR_PROJECT_REF`

## 4. Local Development

- **Localhost** uses the Express server (`node server.js`) — no emails, no Supabase
- **Production** (deployed site) uses Supabase Edge Functions — full flow with emails

To test the full flow locally, temporarily set `SUPABASE_FUNCTIONS_URL` as `API_BASE` and ensure your frontend is served over HTTPS or use a tunnel.

## 5. Email Flow

When a user completes payment:

1. Lead is saved to `leads` table
2. Payment is recorded in `payments` table
3. **User** receives a confirmation email with their case details
4. **Client** receives a notification email with the full lead data

Both emails use the same HTML template with SympleTax branding.
