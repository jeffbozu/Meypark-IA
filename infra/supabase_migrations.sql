-- MEYPARK IA - Migraciones para Supabase Cloud
-- Fase 1: Fundación Backend (Supabase)

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Enums
CREATE TYPE company_mode AS ENUM ('local', 'api_externa');
CREATE TYPE user_role AS ENUM ('admin', 'operator', 'inspector', 'device');
CREATE TYPE theme_scope AS ENUM ('initial_screen', 'default_ui');
CREATE TYPE ui_scope AS ENUM ('initial_screen', 'default_ui');
CREATE TYPE ticket_status AS ENUM ('active', 'expired', 'void');
CREATE TYPE payment_provider AS ENUM ('gpay', 'apple_demo', 'qr', 'emv', 'coins', 'panel_override', 'remote_link');
CREATE TYPE payment_status AS ENUM ('pending', 'succeeded', 'failed');
CREATE TYPE fine_status AS ENUM ('active', 'paid', 'cancelled');
CREATE TYPE command_action AS ENUM (
  'OPEN_PAYMENT_WITH_DURATION',
  'SET_A11Y_PROFILE',
  'SCREENSHOT',
  'PRINT_TEST',
  'REFRESH_TARIFFS',
  'RESTART_UI',
  'PING_EMV',
  'CHANGE_COMPANY',
  'PUSH_THEME'
);
CREATE TYPE command_status AS ENUM ('queued', 'in_progress', 'done', 'error');
CREATE TYPE log_level AS ENUM ('info', 'warn', 'error');
CREATE TYPE alert_type AS ENUM ('paper_low_20', 'paper_low_10', 'emv_off', 'rssi_low', 'temp_high', 'power_issue');
CREATE TYPE alert_status AS ENUM ('open', 'closed');
CREATE TYPE ota_status AS ENUM ('pending', 'downloading', 'installed', 'restarted', 'ok', 'rollback');

-- Core Tables

-- Companies
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  cif TEXT UNIQUE NOT NULL,
  address_json JSONB NOT NULL DEFAULT '{}',
  mode company_mode NOT NULL DEFAULT 'local',
  api_base_url TEXT,
  api_token TEXT, -- Server-side only
  api_endpoints_json JSONB DEFAULT '{}',
  payload_mappings_json JSONB DEFAULT '{}',
  features_json JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Profiles (shadow of auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL, -- null for admin
  role user_role NOT NULL,
  locale TEXT NOT NULL DEFAULT 'es',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Devices
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  alias TEXT NOT NULL,
  serial TEXT UNIQUE NOT NULL,
  timezone TEXT NOT NULL DEFAULT 'Europe/Madrid',
  app_version TEXT,
  last_seen TIMESTAMPTZ,
  flags_json JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Themes
CREATE TABLE themes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  scope theme_scope NOT NULL,
  colors_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(company_id, scope)
);

-- UI Overrides
CREATE TABLE ui_overrides (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  scope ui_scope NOT NULL,
  visibility_json JSONB NOT NULL DEFAULT '{}',
  text_overrides_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Feature Flags
CREATE TABLE feature_flags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  value_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(company_id, device_id, key)
);

-- Zones
CREATE TABLE zones (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  color TEXT NOT NULL DEFAULT '#E62144',
  schedule_json JSONB NOT NULL DEFAULT '{}',
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(company_id, code)
);

-- Tariffs
CREATE TABLE tariffs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  zone_id UUID NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  price_per_min_cents INTEGER NOT NULL,
  min_minutes INTEGER NOT NULL DEFAULT 5,
  max_minutes INTEGER NOT NULL DEFAULT 480,
  step_minutes INTEGER NOT NULL DEFAULT 5,
  presets_json JSONB NOT NULL DEFAULT '[15, 30, 60, 120]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Zone Calendars
CREATE TABLE zone_calendars (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  zone_id UUID NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  valid_from TIMESTAMPTZ NOT NULL,
  valid_to TIMESTAMPTZ NOT NULL,
  calendar_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- External Integrations
CREATE TABLE external_integrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  base_url TEXT NOT NULL,
  token TEXT, -- Server-side only
  endpoints_json JSONB NOT NULL DEFAULT '{}',
  mapping_json JSONB NOT NULL DEFAULT '{}',
  rate_limit_json JSONB NOT NULL DEFAULT '{}',
  enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- External Zone Cache
CREATE TABLE external_zone_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  origin_key TEXT NOT NULL,
  payload_json JSONB NOT NULL DEFAULT '{}',
  synced_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(company_id, origin_key)
);

-- Tickets
CREATE TABLE tickets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  zone_id UUID NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  plate TEXT NOT NULL,
  country TEXT NOT NULL DEFAULT 'ES',
  start_ts TIMESTAMPTZ NOT NULL,
  end_ts TIMESTAMPTZ NOT NULL,
  duration_min INTEGER NOT NULL,
  amount_cents INTEGER NOT NULL,
  pay_method payment_provider NOT NULL,
  status ticket_status NOT NULL DEFAULT 'active',
  invoice_token TEXT UNIQUE,
  invoice_qr_url TEXT,
  parent_ticket_id UUID REFERENCES tickets(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Payments
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  provider payment_provider NOT NULL,
  status payment_status NOT NULL DEFAULT 'pending',
  payload_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Invoices
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID UNIQUE NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  pdf_url TEXT,
  hash_demo TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Ticket Templates
CREATE TABLE ticket_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  fields_json JSONB NOT NULL DEFAULT '{}',
  footer_text TEXT,
  show_qr BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Fines
CREATE TABLE fines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  plate TEXT NOT NULL,
  country TEXT NOT NULL DEFAULT 'ES',
  status fine_status NOT NULL DEFAULT 'active',
  amount_cents INTEGER NOT NULL,
  photo_url TEXT,
  geo JSONB,
  inspector_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  paid_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  reason TEXT
);

-- Telemetry Current
CREATE TABLE telemetry_current (
  device_id UUID PRIMARY KEY REFERENCES devices(id) ON DELETE CASCADE,
  battery INTEGER,
  rssi INTEGER,
  temp_c DECIMAL(4,1),
  paper_pct INTEGER,
  printer_state TEXT,
  emv_state TEXT,
  coin_level INTEGER,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Telemetry History
CREATE TABLE telemetry_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  metric TEXT NOT NULL,
  value NUMERIC NOT NULL,
  ts TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Device Commands
CREATE TABLE device_commands (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  action command_action NOT NULL,
  payload_json JSONB NOT NULL DEFAULT '{}',
  requested_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status command_status NOT NULL DEFAULT 'queued'
);

-- Device Command Results
CREATE TABLE device_command_results (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  command_id UUID NOT NULL REFERENCES device_commands(id) ON DELETE CASCADE,
  result_json JSONB NOT NULL DEFAULT '{}',
  exit_code INTEGER,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Device Logs
CREATE TABLE device_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  level log_level NOT NULL,
  message TEXT NOT NULL,
  context_json JSONB NOT NULL DEFAULT '{}',
  ts TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- AI Settings
CREATE TABLE ai_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  master_on BOOLEAN NOT NULL DEFAULT true,
  presets_smart BOOLEAN NOT NULL DEFAULT true,
  pay_reco_last5 BOOLEAN NOT NULL DEFAULT true,
  a11y_remember_last5 BOOLEAN NOT NULL DEFAULT true,
  layout_adaptive_tts BOOLEAN NOT NULL DEFAULT true,
  queue_mode BOOLEAN NOT NULL DEFAULT true,
  pay_promotion BOOLEAN NOT NULL DEFAULT true,
  maintenance_predictive BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(company_id, device_id)
);

-- Accessibility Preferences
CREATE TABLE accessibility_prefs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  combo_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Usage Stats
CREATE TABLE usage_stats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  metric TEXT NOT NULL,
  value NUMERIC NOT NULL,
  ts TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Alerts
CREATE TABLE alerts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  type alert_type NOT NULL,
  status alert_status NOT NULL DEFAULT 'open',
  info_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  closed_at TIMESTAMPTZ,
  closed_by UUID REFERENCES profiles(id) ON DELETE SET NULL
);

-- OTA Releases
CREATE TABLE ota_releases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  version TEXT UNIQUE NOT NULL,
  notes TEXT,
  file_url TEXT,
  checksum TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- OTA Jobs
CREATE TABLE ota_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  release_id UUID NOT NULL REFERENCES ota_releases(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  scheduled_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- OTA Status
CREATE TABLE ota_status (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID NOT NULL REFERENCES ota_jobs(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  status ota_status NOT NULL DEFAULT 'pending',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Audit Logs
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  actor_role user_role NOT NULL,
  action TEXT NOT NULL,
  target_type TEXT NOT NULL,
  target_id UUID NOT NULL,
  diff_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- License Patterns
CREATE TABLE license_patterns (
  country TEXT PRIMARY KEY,
  regex TEXT NOT NULL,
  example TEXT NOT NULL
);

-- Indexes
CREATE INDEX idx_tickets_plate ON tickets USING gin (plate gin_trgm_ops);
CREATE INDEX idx_fines_plate ON fines USING gin (plate gin_trgm_ops);
CREATE INDEX idx_telemetry_history_device_ts ON telemetry_history (device_id, ts);
CREATE INDEX idx_device_commands_device_status ON device_commands (device_id, status);
CREATE INDEX idx_device_logs_device_ts ON device_logs (device_id, ts);
CREATE INDEX idx_audit_logs_actor ON audit_logs (actor_user_id);
CREATE INDEX idx_audit_logs_target ON audit_logs (target_type, target_id);

-- Triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_devices_updated_at BEFORE UPDATE ON devices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_themes_updated_at BEFORE UPDATE ON themes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ui_overrides_updated_at BEFORE UPDATE ON ui_overrides FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_feature_flags_updated_at BEFORE UPDATE ON feature_flags FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_zones_updated_at BEFORE UPDATE ON zones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tariffs_updated_at BEFORE UPDATE ON tariffs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_external_integrations_updated_at BEFORE UPDATE ON external_integrations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tickets_updated_at BEFORE UPDATE ON tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ticket_templates_updated_at BEFORE UPDATE ON ticket_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_settings_updated_at BEFORE UPDATE ON ai_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
