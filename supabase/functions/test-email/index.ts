// Test emails: simple ping or full form preview (user + client versions)
import { Resend } from 'https://esm.sh/resend@2.0.0'
import { buildLeadEmailHtml, type LeadEmailData } from '../submit-lead/email-template.ts'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const SAMPLE_LEAD: LeadEmailData = {
  case_number: 'ST-2026-4521',
  first_name: 'John',
  last_name: 'Smith',
  email: 'john.smith@example.com',
  phone: '(555) 123-4567',
  debt_type: 'IRS Back Taxes',
  tax_type: 'Income Tax',
  active_collections: 'Yes',
  irs_notice: 'CP14 - Balance Due',
  tax_situation: 'Filed but owe balance',
  federal_years: [2019, 2020, 2021],
  state_years: [2019, 2020],
  income: '$75,000 - $100,000',
  on_irs_plan: 'yes',
  irs_plan_monthly: 450,
  filing_status: 'Married Filing Jointly',
  bank_balance: 12500,
  investments: 8000,
  state: 'California',
  county: 'Los Angeles',
  household_size: '4',
  vehicles_owned: '2',
  exp_health_insurance: 850,
  exp_childcare: 1200,
  exp_other_tax: 0,
  exp_other_obligations: 450,
  payment_plan: 'full',
  pre_estimated_debt: 28500,
  pre_estimated_settlement: 14250,
  pre_estimated_savings: 14250,
  created_at: new Date().toLocaleString('en-US', { dateStyle: 'long', timeStyle: 'short' }),
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const resendApiKey = Deno.env.get('RESEND_API_KEY')
  const fromRaw = Deno.env.get('RESEND_FROM_DOMAIN') || 'onboarding@resend.dev'
  const fromEmail = fromRaw.includes('@') ? fromRaw : `noreply@${fromRaw}`

  if (!resendApiKey) {
    return new Response(
      JSON.stringify({ error: 'RESEND_API_KEY not set' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  const body = (await req.json().catch(() => ({}))) as { to?: string; full?: boolean }
  const to = body?.to || 'hi@kpatel.xyz'
  const sendFull = body?.full === true

  const resend = new Resend(resendApiKey)

  if (sendFull) {
    // Send both user and client versions to the same address
    const [userRes, clientRes] = await Promise.all([
      resend.emails.send({
        from: `SympleTax <${fromEmail}>`,
        to,
        subject: `[TEST] Your SympleTax Case Confirmation — ${SAMPLE_LEAD.case_number}`,
        html: buildLeadEmailHtml(SAMPLE_LEAD, 'user'),
      }),
      resend.emails.send({
        from: `SympleTax Portal <${fromEmail}>`,
        to,
        subject: `[TEST] New Lead: ${SAMPLE_LEAD.first_name} ${SAMPLE_LEAD.last_name} — ${SAMPLE_LEAD.case_number}`,
        html: buildLeadEmailHtml(SAMPLE_LEAD, 'client'),
      }),
    ])
    const userOk = !userRes.error
    const clientOk = !clientRes.error
    return new Response(
      JSON.stringify({
        success: userOk && clientOk,
        user_email: userOk ? 'sent' : userRes.error?.message,
        client_email: clientOk ? 'sent' : clientRes.error?.message,
        to,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  // Simple test email
  const { data, error } = await resend.emails.send({
    from: `SympleTax <${fromEmail}>`,
    to,
    subject: 'SympleTax — Test Email',
    html: `
      <div style="font-family:sans-serif;max-width:500px;margin:0 auto;padding:24px;">
        <h2 style="color:#00B4B0;">SympleTax</h2>
        <p>This is a test email. Your Resend setup is working.</p>
        <p style="color:#8895AE;font-size:12px;">Sent at ${new Date().toISOString()}</p>
      </div>
    `,
  })

  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  return new Response(
    JSON.stringify({ success: true, id: data?.id, to }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
})
