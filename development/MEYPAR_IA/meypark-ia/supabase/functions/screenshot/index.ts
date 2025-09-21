// MEYPARK IA - Edge Function: Screenshot
// Captura de pantalla en tiempo real para monitoreo live

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
    const { device_id, image_data, image_format = 'png' } = body

    // Validate required fields
    if (!device_id || !image_data) {
      return new Response(
        JSON.stringify({ error: 'device_id and image_data are required' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Check if device exists
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

    // Generate unique filename
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
    const filename = `screenshots/${device_id}/${timestamp}.${image_format}`

    // Upload image to Supabase Storage
    const { data: uploadData, error: uploadError } = await supabaseClient.storage
      .from('device-screenshots')
      .upload(filename, image_data, {
        contentType: `image/${image_format}`,
        cacheControl: '3600',
        upsert: false
      })

    if (uploadError) {
      console.error('Error uploading screenshot:', uploadError)
      return new Response(
        JSON.stringify({ error: 'Failed to upload screenshot' }),
        { 
          status: 500, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Get public URL
    const { data: urlData } = supabaseClient.storage
      .from('device-screenshots')
      .getPublicUrl(filename)

    // Store screenshot metadata in database
    const { data: screenshotData, error: dbError } = await supabaseClient
      .from('device_screenshots')
      .insert({
        device_id,
        filename: uploadData.path,
        url: urlData.publicUrl,
        format: image_format,
        size_bytes: image_data.length,
        company_id: device.company_id
      })
      .select()
      .single()

    if (dbError) {
      console.error('Error storing screenshot metadata:', dbError)
      // Don't fail the request, just log the error
    }

    // Log audit
    await supabaseClient
      .from('audit_logs')
      .insert({
        actor_user_id: null,
        actor_role: 'device',
        action: 'SCREENSHOT_CAPTURED',
        target_type: 'device_screenshot',
        target_id: screenshotData?.id || device_id,
        diff_json: { device_id, filename: uploadData.path }
      })

    return new Response(
      JSON.stringify({ 
        success: true, 
        screenshot_id: screenshotData?.id,
        url: urlData.publicUrl,
        filename: uploadData.path,
        device_alias: device.alias,
        message: 'Screenshot captured and uploaded successfully'
      }),
      { 
        status: 201, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('Error in screenshot function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
