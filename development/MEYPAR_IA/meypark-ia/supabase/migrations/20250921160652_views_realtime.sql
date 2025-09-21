-- MEYPARK IA - Views y Realtime para Supabase Cloud
-- Vistas y configuraciones de Realtime

-- Vista de sesiones activas
CREATE OR REPLACE VIEW active_sessions_v AS
SELECT 
  t.company_id,
  t.device_id,
  t.zone_id,
  t.plate,
  t.country,
  t.start_ts,
  MAX(t.end_ts) as paid_until_ts,
  EXTRACT(EPOCH FROM (MAX(t.end_ts) - NOW())) / 60 as remaining_min,
  t.pay_method as method_last,
  SUM(t.amount_cents) as amount_total_cents,
  t.status,
  t.invoice_token,
  t.invoice_qr_url
FROM tickets t
WHERE t.status = 'active' 
  AND t.end_ts > NOW()
GROUP BY 
  t.company_id,
  t.device_id,
  t.zone_id,
  t.plate,
  t.country,
  t.start_ts,
  t.pay_method,
  t.status,
  t.invoice_token,
  t.invoice_qr_url;

-- Grant permissions for the view
GRANT SELECT ON active_sessions_v TO authenticated;

-- Realtime publications
ALTER PUBLICATION supabase_realtime ADD TABLE tickets;
ALTER PUBLICATION supabase_realtime ADD TABLE payments;
ALTER PUBLICATION supabase_realtime ADD TABLE telemetry_current;
ALTER PUBLICATION supabase_realtime ADD TABLE device_commands;
ALTER PUBLICATION supabase_realtime ADD TABLE device_command_results;
ALTER PUBLICATION supabase_realtime ADD TABLE alerts;

-- Enable realtime for specific columns (sensitive data excluded)
ALTER TABLE tickets REPLICA IDENTITY FULL;
ALTER TABLE payments REPLICA IDENTITY FULL;
ALTER TABLE telemetry_current REPLICA IDENTITY FULL;
ALTER TABLE device_commands REPLICA IDENTITY FULL;
ALTER TABLE device_command_results REPLICA IDENTITY FULL;
ALTER TABLE alerts REPLICA IDENTITY FULL;
