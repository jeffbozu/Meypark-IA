-- MEYPARK IA - RLS Policies para Supabase Cloud
-- Políticas de Row Level Security

-- Enable RLS on all tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ui_overrides ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE tariffs ENABLE ROW LEVEL SECURITY;
ALTER TABLE zone_calendars ENABLE ROW LEVEL SECURITY;
ALTER TABLE external_integrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE external_zone_cache ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE ticket_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE telemetry_current ENABLE ROW LEVEL SECURITY;
ALTER TABLE telemetry_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_commands ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_command_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE accessibility_prefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE ota_releases ENABLE ROW LEVEL SECURITY;
ALTER TABLE ota_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ota_status ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE license_patterns ENABLE ROW LEVEL SECURITY;

-- Helper function to get user role and company
CREATE OR REPLACE FUNCTION get_user_context()
RETURNS TABLE(role user_role, company_id UUID) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.role,
    p.company_id
  FROM profiles p
  WHERE p.id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Companies policies
CREATE POLICY "Admins can view all companies" ON companies
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Users can view their company" ON companies
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = companies.id
    )
  );

CREATE POLICY "Admins can manage all companies" ON companies
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Profiles policies
CREATE POLICY "Users can view profiles in their company" ON profiles
  FOR SELECT USING (
    company_id IS NULL OR -- Admin profiles
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = profiles.company_id
    )
  );

CREATE POLICY "Admins can manage all profiles" ON profiles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Devices policies
CREATE POLICY "Users can view devices in their company" ON devices
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = devices.company_id
    )
  );

CREATE POLICY "Admins can manage all devices" ON devices
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Devices can update themselves" ON devices
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = devices.company_id
    )
  );

-- Themes policies
CREATE POLICY "Users can view themes in their company" ON themes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = themes.company_id
    )
  );

CREATE POLICY "Admins can manage all themes" ON themes
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- UI Overrides policies
CREATE POLICY "Users can view UI overrides in their company" ON ui_overrides
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = ui_overrides.company_id
    )
  );

CREATE POLICY "Admins can manage all UI overrides" ON ui_overrides
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Feature Flags policies
CREATE POLICY "Users can view feature flags in their company" ON feature_flags
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = feature_flags.company_id
    )
  );

CREATE POLICY "Admins can manage all feature flags" ON feature_flags
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Zones policies
CREATE POLICY "Users can view zones in their company" ON zones
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = zones.company_id
    )
  );

CREATE POLICY "Admins can manage all zones" ON zones
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Tariffs policies
CREATE POLICY "Users can view tariffs for their company zones" ON tariffs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM zones WHERE id = tariffs.zone_id)
    )
  );

CREATE POLICY "Admins can manage all tariffs" ON tariffs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Zone Calendars policies
CREATE POLICY "Users can view zone calendars for their company zones" ON zone_calendars
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM zones WHERE id = zone_calendars.zone_id)
    )
  );

CREATE POLICY "Admins can manage all zone calendars" ON zone_calendars
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- External Integrations policies
CREATE POLICY "Users can view external integrations in their company" ON external_integrations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = external_integrations.company_id
    )
  );

CREATE POLICY "Admins can manage all external integrations" ON external_integrations
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- External Zone Cache policies
CREATE POLICY "Users can view external zone cache in their company" ON external_zone_cache
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = external_zone_cache.company_id
    )
  );

CREATE POLICY "Admins can manage all external zone cache" ON external_zone_cache
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Tickets policies
CREATE POLICY "Users can view tickets in their company" ON tickets
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = tickets.company_id
    )
  );

CREATE POLICY "Admins can manage all tickets" ON tickets
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Devices can create tickets for their company" ON tickets
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = tickets.company_id
    )
  );

-- Payments policies
CREATE POLICY "Users can view payments for their company tickets" ON payments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM tickets WHERE id = payments.ticket_id)
    )
  );

CREATE POLICY "Admins can manage all payments" ON payments
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Special policy for panel_override payments (only admins)
CREATE POLICY "Only admins can create panel_override payments" ON payments
  FOR INSERT WITH CHECK (
    provider != 'panel_override' OR
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Invoices policies
CREATE POLICY "Users can view invoices for their company tickets" ON invoices
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM tickets WHERE id = invoices.ticket_id)
    )
  );

CREATE POLICY "Admins can manage all invoices" ON invoices
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Ticket Templates policies
CREATE POLICY "Users can view ticket templates in their company" ON ticket_templates
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = ticket_templates.company_id
    )
  );

CREATE POLICY "Admins can manage all ticket templates" ON ticket_templates
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Fines policies
CREATE POLICY "Users can view fines in their company" ON fines
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = fines.company_id
    )
  );

CREATE POLICY "Admins can manage all fines" ON fines
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Inspectors can create fines for their company" ON fines
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'inspector' AND company_id = fines.company_id
    )
  );

-- Telemetry Current policies
CREATE POLICY "Users can view telemetry for their company devices" ON telemetry_current
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = telemetry_current.device_id)
    )
  );

CREATE POLICY "Devices can update their own telemetry" ON telemetry_current
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = telemetry_current.device_id)
    )
  );

-- Telemetry History policies
CREATE POLICY "Users can view telemetry history for their company devices" ON telemetry_history
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = telemetry_history.device_id)
    )
  );

CREATE POLICY "Devices can insert their own telemetry history" ON telemetry_history
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = telemetry_history.device_id)
    )
  );

-- Device Commands policies
CREATE POLICY "Users can view device commands for their company devices" ON device_commands
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = device_commands.device_id)
    )
  );

CREATE POLICY "Admins can create device commands" ON device_commands
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Devices can update their own commands" ON device_commands
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = device_commands.device_id)
    )
  );

-- Device Command Results policies
CREATE POLICY "Users can view device command results for their company devices" ON device_command_results
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = (SELECT device_id FROM device_commands WHERE id = device_command_results.command_id))
    )
  );

CREATE POLICY "Devices can insert their own command results" ON device_command_results
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = (SELECT device_id FROM device_commands WHERE id = device_command_results.command_id))
    )
  );

-- Device Logs policies
CREATE POLICY "Users can view device logs for their company devices" ON device_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = device_logs.device_id)
    )
  );

CREATE POLICY "Devices can insert their own logs" ON device_logs
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = device_logs.device_id)
    )
  );

-- AI Settings policies
CREATE POLICY "Users can view AI settings for their company" ON ai_settings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = ai_settings.company_id
    )
  );

CREATE POLICY "Admins can manage all AI settings" ON ai_settings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- Accessibility Preferences policies
CREATE POLICY "Users can view accessibility prefs for their company devices" ON accessibility_prefs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = accessibility_prefs.device_id)
    )
  );

CREATE POLICY "Devices can manage their own accessibility prefs" ON accessibility_prefs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = accessibility_prefs.device_id)
    )
  );

-- Usage Stats policies
CREATE POLICY "Users can view usage stats for their company devices" ON usage_stats
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = usage_stats.device_id)
    )
  );

CREATE POLICY "Devices can insert their own usage stats" ON usage_stats
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = usage_stats.device_id)
    )
  );

-- Alerts policies
CREATE POLICY "Users can view alerts for their company devices" ON alerts
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = alerts.device_id)
    )
  );

CREATE POLICY "Admins can manage all alerts" ON alerts
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- OTA Releases policies (public read, admin write)
CREATE POLICY "Everyone can view OTA releases" ON ota_releases
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage OTA releases" ON ota_releases
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- OTA Jobs policies
CREATE POLICY "Users can view OTA jobs for their company devices" ON ota_jobs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = ota_jobs.device_id)
    )
  );

CREATE POLICY "Admins can manage all OTA jobs" ON ota_jobs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

-- OTA Status policies
CREATE POLICY "Users can view OTA status for their company devices" ON ota_status
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM devices WHERE id = ota_status.device_id)
    )
  );

CREATE POLICY "Devices can update their own OTA status" ON ota_status
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'device' AND company_id = (SELECT company_id FROM devices WHERE id = ota_status.device_id)
    )
  );

-- Audit Logs policies
CREATE POLICY "Admins can view all audit logs" ON audit_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );

CREATE POLICY "Users can view audit logs for their company" ON audit_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE company_id = (SELECT company_id FROM profiles WHERE id = audit_logs.actor_user_id)
    )
  );

-- License Patterns policies (public read, admin write)
CREATE POLICY "Everyone can view license patterns" ON license_patterns
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage license patterns" ON license_patterns
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM get_user_context() 
      WHERE role = 'admin'
    )
  );
