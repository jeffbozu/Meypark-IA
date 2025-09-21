// MEYPARK IA - Edge Function: Invoice Get
// Obtiene información de factura por token

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Get invoice token from URL
    const url = new URL(req.url)
    const pathParts = url.pathname.split('/')
    const invoiceToken = pathParts[pathParts.length - 1]

    if (!invoiceToken) {
      return new Response(
        JSON.stringify({ error: 'Invoice token is required' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Get ticket with invoice information
    const { data: ticket, error } = await supabaseClient
      .from('tickets')
      .select(`
        id,
        plate,
        country,
        start_ts,
        end_ts,
        duration_min,
        amount_cents,
        pay_method,
        status,
        invoice_token,
        invoice_qr_url,
        zones!inner(
          name,
          code
        ),
        devices!inner(
          alias,
          serial
        )
      `)
      .eq('invoice_token', invoiceToken)
      .single()

    if (error || !ticket) {
      return new Response(
        JSON.stringify({ error: 'Invoice not found' }),
        { 
          status: 404, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Get invoice PDF if exists
    const { data: invoice } = await supabaseClient
      .from('invoices')
      .select('pdf_url, hash_demo')
      .eq('ticket_id', ticket.id)
      .single()

    // Format response
    const response = {
      ticket: {
        id: ticket.id,
        plate: ticket.plate,
        country: ticket.country,
        start_ts: ticket.start_ts,
        end_ts: ticket.end_ts,
        duration_min: ticket.duration_min,
        amount_cents: ticket.amount_cents,
        amount_euros: (ticket.amount_cents / 100).toFixed(2),
        pay_method: ticket.pay_method,
        status: ticket.status,
        zone: {
          name: ticket.zones.name,
          code: ticket.zones.code
        },
        device: {
          alias: ticket.devices.alias,
          serial: ticket.devices.serial
        }
      },
      invoice: {
        token: ticket.invoice_token,
        qr_url: ticket.invoice_qr_url,
        pdf_url: invoice?.pdf_url || null,
        hash_demo: invoice?.hash_demo || null
      }
    }

    return new Response(
      JSON.stringify(response),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('Error in invoice-get function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
