// MEYPARK IA - Edge Function: Alerts
// Crea alertas para dispositivos

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

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ error: 'Method not allowed' }),
      { 
        status: 405, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }

  try {
    // Create Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Parse request body
    const body = await req.json()
    const { device_id, type, info, created_by } = body

    // Validate required fields
    if (!device_id || !type) {
      return new Response(
        JSON.stringify({ error: 'device_id and type are required' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validate alert type enum
    const validTypes = [
      'paper_low_20',
      'paper_low_10',
      'emv_off',
      'rssi_low',
      'temp_high',
      'power_issue'
    ]

    if (!validTypes.includes(type)) {
      return new Response(
        JSON.stringify({ error: 'Invalid alert type' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Check if device exists and get company info
    const { data: device, error: deviceError } = await supabaseClient
      .from('devices')
      .select('id, company_id, alias')
      .eq('id', device_id)
      .single()

    if (deviceError || !device) {
      return new Response(
        JSON.stringify({ error: 'Device not found' }),
        { 
          status: 404, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Check for existing open alert of same type
    const { data: existingAlert } = await supabaseClient
      .from('alerts')
      .select('id')
      .eq('device_id', device_id)
      .eq('type', type)
      .eq('status', 'open')
      .single()

    if (existingAlert) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          alert_id: existingAlert.id,
          message: 'Alert already exists for this device and type'
        }),
        { 
          status: 200, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Insert alert
    const { data: alert, error } = await supabaseClient
      .from('alerts')
      .insert({
        device_id,
        type,
        info_json: info || {},
        status: 'open'
      })
      .select()
      .single()

    if (error) {
      console.error('Error inserting alert:', error)
      return new Response(
        JSON.stringify({ error: 'Failed to create alert' }),
        { 
          status: 500, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Log audit
    await supabaseClient
      .from('audit_logs')
      .insert({
        actor_user_id: created_by || null,
        actor_role: 'device',
        action: 'CREATE_ALERT',
        target_type: 'alert',
        target_id: alert.id,
        diff_json: { type, device_id, info }
      })

    // TODO: In future phases, add email/SMS notifications here
    console.log(`Alert created for device ${device.alias}: ${type}`)

    return new Response(
      JSON.stringify({ 
        success: true, 
        alert_id: alert.id,
        device_alias: device.alias,
        message: 'Alert created successfully'
      }),
      { 
        status: 201, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('Error in alerts function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
