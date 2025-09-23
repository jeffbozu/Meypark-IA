// MEYPARK IA - Edge Function: Commands
// Inserta comandos para dispositivos

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
    const { device_id, action, payload, requested_by } = body

    // Validate required fields
    if (!device_id || !action) {
      return new Response(
        JSON.stringify({ error: 'device_id and action are required' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validate action enum
    const validActions = [
      'OPEN_PAYMENT_WITH_DURATION',
      'SET_A11Y_PROFILE',
      'SCREENSHOT',
      'PRINT_TEST',
      'REFRESH_TARIFFS',
      'RESTART_UI',
      'PING_EMV',
      'CHANGE_COMPANY',
      'PUSH_THEME'
    ]

    if (!validActions.includes(action)) {
      return new Response(
        JSON.stringify({ error: 'Invalid action' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Insert device command
    const { data: command, error } = await supabaseClient
      .from('device_commands')
      .insert({
        device_id,
        action,
        payload_json: payload || {},
        requested_by: requested_by || null
      })
      .select()
      .single()

    if (error) {
      console.error('Error inserting device command:', error)
      return new Response(
        JSON.stringify({ error: 'Failed to create command' }),
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
        actor_user_id: requested_by || null,
        actor_role: 'admin',
        action: 'CREATE_DEVICE_COMMAND',
        target_type: 'device_command',
        target_id: command.id,
        diff_json: { action, device_id, payload }
      })

    return new Response(
      JSON.stringify({ 
        success: true, 
        command_id: command.id,
        status: command.status,
        message: 'Command queued successfully'
      }),
      { 
        status: 201, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('Error in commands function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
