-- MEYPARK IA - Live Monitoring Enhancements
-- Mejoras para monitoreo en tiempo real

-- Live Sessions View (enhanced)
CREATE OR REPLACE VIEW live_sessions_v AS
SELECT 
  t.company_id,
  t.device_id,
  t.zone_id,
  t.plate,
  t.country,
  t.start_ts,
  t.end_ts,
  EXTRACT(EPOCH FROM (t.end_ts - NOW())) / 60 as remaining_min,
  t.pay_method,
  t.amount_cents,
  t.status,
  t.invoice_token,
  t.invoice_qr_url,
  d.alias as device_alias,
  d.serial as device_serial,
  d.last_seen,
  z.name as zone_name,
  z.code as zone_code,
  tc.battery,
  tc.rssi,
  tc.temp_c,
  tc.paper_pct,
  tc.printer_state,
  tc.emv_state,
  tc.coin_level,
  tc.updated_at as telemetry_updated_at
FROM tickets t
JOIN devices d ON t.device_id = d.id
JOIN zones z ON t.zone_id = z.id
LEFT JOIN telemetry_current tc ON t.device_id = tc.device_id
WHERE t.status = 'active' 
  AND t.end_ts > NOW();

-- Grant permissions
GRANT SELECT ON live_sessions_v TO authenticated;

-- Device Status View
CREATE OR REPLACE VIEW device_status_v AS
SELECT 
  d.id,
  d.company_id,
  d.alias,
  d.serial,
  d.timezone,
  d.app_version,
  d.last_seen,
  d.flags_json,
  tc.battery,
  tc.rssi,
  tc.temp_c,
  tc.paper_pct,
  tc.printer_state,
  tc.emv_state,
  tc.coin_level,
  tc.updated_at as telemetry_updated_at,
  CASE 
    WHEN d.last_seen > NOW() - INTERVAL '5 minutes' THEN 'online'
    WHEN d.last_seen > NOW() - INTERVAL '1 hour' THEN 'idle'
    ELSE 'offline'
  END as connection_status,
  (SELECT COUNT(*) FROM tickets WHERE device_id = d.id AND status = 'active') as active_tickets,
  (SELECT COUNT(*) FROM device_commands WHERE device_id = d.id AND status = 'queued') as pending_commands,
  (SELECT COUNT(*) FROM alerts WHERE device_id = d.id AND status = 'open') as open_alerts
FROM devices d
LEFT JOIN telemetry_current tc ON d.id = tc.device_id;

-- Grant permissions
GRANT SELECT ON device_status_v TO authenticated;

-- Recent Screenshots View
CREATE OR REPLACE VIEW recent_screenshots_v AS
SELECT 
  ds.id,
  ds.device_id,
  ds.company_id,
  ds.filename,
  ds.url,
  ds.format,
  ds.size_bytes,
  ds.created_at,
  d.alias as device_alias,
  d.serial as device_serial
FROM device_screenshots ds
JOIN devices d ON ds.device_id = d.id
WHERE ds.created_at > NOW() - INTERVAL '24 hours'
ORDER BY ds.created_at DESC;

-- Grant permissions
GRANT SELECT ON recent_screenshots_v TO authenticated;

-- Note: Views cannot be added to realtime publications
-- Use device_screenshots table for realtime updates instead
