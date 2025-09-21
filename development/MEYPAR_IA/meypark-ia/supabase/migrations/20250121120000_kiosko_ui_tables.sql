-- =====================================================
-- MIGRACIÓN: TABLAS PARA UI DINÁMICA DEL KIOSKO
-- =====================================================
-- Descripción: Tablas adicionales para controlar la UI del kiosko desde Supabase
-- Fecha: 2025-01-21
-- Autor: MEYPARK IA Team

-- =====================================================
-- 1. TABLA DE CONFIGURACIÓN DE DISPOSITIVOS
-- =====================================================
CREATE TABLE IF NOT EXISTS device_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    
    -- Configuración de UI
    flags_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"show_time": true, "show_date": true, "time_format": "24h", "date_format": "dd/MM/yyyy"}
    
    -- Configuración de accesibilidad
    accessibility_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"dark_mode": false, "high_contrast": false, "text_size": 100, "tts_enabled": false}
    
    -- Configuración de IA
    ai_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"adaptive_enabled": true, "learning_rate": 0.1, "memory_days": 30}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(device_id)
);

-- =====================================================
-- 2. TABLA DE CONFIGURACIÓN DE IDIOMAS
-- =====================================================
CREATE TABLE IF NOT EXISTS i18n_overrides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de idioma
    locale VARCHAR(10) NOT NULL DEFAULT 'es-ES',
    -- Ejemplo: 'es-ES', 'en-US', 'ca-ES', 'gl-ES', 'eu-ES'
    
    -- Overrides de texto
    text_overrides_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"welcome_message": "Bienvenido", "pay_button": "Pagar", "cancel_button": "Anular"}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, device_id, locale)
);

-- =====================================================
-- 3. TABLA DE CONFIGURACIÓN DE PAGOS
-- =====================================================
CREATE TABLE IF NOT EXISTS payment_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de métodos de pago
    enabled_methods JSONB DEFAULT '["qr", "emv", "coins"]'::jsonb,
    -- Ejemplo: ["gpay", "apple_pay", "qr", "emv", "coins"]
    
    -- Configuración de precios
    price_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"currency": "EUR", "decimal_places": 2, "symbol": "€"}
    
    -- Configuración de validación
    validation_rules_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"min_amount": 50, "max_amount": 50000, "step_amount": 50}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, device_id)
);

-- =====================================================
-- 4. TABLA DE CONFIGURACIÓN DE NOTIFICACIONES
-- =====================================================
CREATE TABLE IF NOT EXISTS notification_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de notificaciones
    enabled_types JSONB DEFAULT '["success", "error", "warning"]'::jsonb,
    -- Ejemplo: ["success", "error", "warning", "info"]
    
    -- Configuración de TTS
    tts_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"enabled": true, "speed": 0.8, "pitch": 1.0, "volume": 0.9}
    
    -- Configuración de visual
    visual_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"duration": 3000, "position": "top", "color": "#4CAF50"}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, device_id)
);

-- =====================================================
-- 5. TABLA DE CONFIGURACIÓN DE HARDWARE
-- =====================================================
CREATE TABLE IF NOT EXISTS hardware_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de periféricos
    peripherals_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"printer": {"enabled": true, "model": "EPSON-TM20"}, "emv": {"enabled": true, "timeout": 30}}
    
    -- Configuración de red
    network_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"wifi_enabled": true, "ethernet_enabled": false, "timeout": 30}
    
    -- Configuración de energía
    power_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"battery_threshold": 20, "auto_shutdown": true, "sleep_timeout": 300}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(device_id)
);

-- =====================================================
-- 6. TABLA DE CONFIGURACIÓN DE SEGURIDAD
-- =====================================================
CREATE TABLE IF NOT EXISTS security_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de autenticación
    auth_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"hidden_login_enabled": true, "tech_mode_pin": "1234", "session_timeout": 3600}
    
    -- Configuración de permisos
    permissions_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"can_override_payments": true, "can_access_tech_mode": true, "can_modify_settings": false}
    
    -- Configuración de auditoría
    audit_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"log_all_actions": true, "retention_days": 90, "alert_on_errors": true}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, device_id)
);

-- =====================================================
-- 7. TABLA DE CONFIGURACIÓN DE MANTENIMIENTO
-- =====================================================
CREATE TABLE IF NOT EXISTS maintenance_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    
    -- Configuración de mantenimiento automático
    auto_maintenance_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"enabled": true, "check_interval": 3600, "auto_restart": true}
    
    -- Configuración de alertas
    alert_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"paper_low_threshold": 20, "battery_low_threshold": 15, "temp_high_threshold": 50}
    
    -- Configuración de actualizaciones
    update_config_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"auto_update": true, "update_channel": "stable", "rollback_on_error": true}
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(device_id)
);

-- =====================================================
-- 8. ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para device_configs
CREATE INDEX IF NOT EXISTS idx_device_configs_device_id ON device_configs(device_id);
CREATE INDEX IF NOT EXISTS idx_device_configs_company_id ON device_configs(company_id);

-- Índices para i18n_overrides
CREATE INDEX IF NOT EXISTS idx_i18n_overrides_company_id ON i18n_overrides(company_id);
CREATE INDEX IF NOT EXISTS idx_i18n_overrides_device_id ON i18n_overrides(device_id);
CREATE INDEX IF NOT EXISTS idx_i18n_overrides_locale ON i18n_overrides(locale);

-- Índices para payment_configs
CREATE INDEX IF NOT EXISTS idx_payment_configs_company_id ON payment_configs(company_id);
CREATE INDEX IF NOT EXISTS idx_payment_configs_device_id ON payment_configs(device_id);

-- Índices para notification_configs
CREATE INDEX IF NOT EXISTS idx_notification_configs_company_id ON notification_configs(company_id);
CREATE INDEX IF NOT EXISTS idx_notification_configs_device_id ON notification_configs(device_id);

-- Índices para hardware_configs
CREATE INDEX IF NOT EXISTS idx_hardware_configs_device_id ON hardware_configs(device_id);

-- Índices para security_configs
CREATE INDEX IF NOT EXISTS idx_security_configs_company_id ON security_configs(company_id);
CREATE INDEX IF NOT EXISTS idx_security_configs_device_id ON security_configs(device_id);

-- Índices para maintenance_configs
CREATE INDEX IF NOT EXISTS idx_maintenance_configs_device_id ON maintenance_configs(device_id);

-- =====================================================
-- 9. TRIGGERS PARA UPDATED_AT
-- =====================================================

-- Trigger para device_configs
CREATE OR REPLACE FUNCTION update_device_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_device_configs_updated_at
    BEFORE UPDATE ON device_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_device_configs_updated_at();

-- Trigger para i18n_overrides
CREATE OR REPLACE FUNCTION update_i18n_overrides_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_i18n_overrides_updated_at
    BEFORE UPDATE ON i18n_overrides
    FOR EACH ROW
    EXECUTE FUNCTION update_i18n_overrides_updated_at();

-- Trigger para payment_configs
CREATE OR REPLACE FUNCTION update_payment_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_payment_configs_updated_at
    BEFORE UPDATE ON payment_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_payment_configs_updated_at();

-- Trigger para notification_configs
CREATE OR REPLACE FUNCTION update_notification_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_notification_configs_updated_at
    BEFORE UPDATE ON notification_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_notification_configs_updated_at();

-- Trigger para hardware_configs
CREATE OR REPLACE FUNCTION update_hardware_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_hardware_configs_updated_at
    BEFORE UPDATE ON hardware_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_hardware_configs_updated_at();

-- Trigger para security_configs
CREATE OR REPLACE FUNCTION update_security_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_security_configs_updated_at
    BEFORE UPDATE ON security_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_security_configs_updated_at();

-- Trigger para maintenance_configs
CREATE OR REPLACE FUNCTION update_maintenance_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_maintenance_configs_updated_at
    BEFORE UPDATE ON maintenance_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_maintenance_configs_updated_at();

-- =====================================================
-- 10. RLS POLICIES
-- =====================================================

-- RLS para device_configs
ALTER TABLE device_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "device_configs_company_access" ON device_configs
    FOR ALL USING (
        company_id = (auth.jwt() ->> 'company_id')::uuid
    );

-- RLS para i18n_overrides
ALTER TABLE i18n_overrides ENABLE ROW LEVEL SECURITY;

CREATE POLICY "i18n_overrides_company_access" ON i18n_overrides
    FOR ALL USING (
        company_id = (auth.jwt() ->> 'company_id')::uuid
    );

-- RLS para payment_configs
ALTER TABLE payment_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "payment_configs_company_access" ON payment_configs
    FOR ALL USING (
        company_id = (auth.jwt() ->> 'company_id')::uuid
    );

-- RLS para notification_configs
ALTER TABLE notification_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notification_configs_company_access" ON notification_configs
    FOR ALL USING (
        company_id = (auth.jwt() ->> 'company_id')::uuid
    );

-- RLS para hardware_configs
ALTER TABLE hardware_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "hardware_configs_device_access" ON hardware_configs
    FOR ALL USING (
        device_id = (auth.jwt() ->> 'device_id')::uuid
    );

-- RLS para security_configs
ALTER TABLE security_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "security_configs_company_access" ON security_configs
    FOR ALL USING (
        company_id = (auth.jwt() ->> 'company_id')::uuid
    );

-- RLS para maintenance_configs
ALTER TABLE maintenance_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "maintenance_configs_device_access" ON maintenance_configs
    FOR ALL USING (
        device_id = (auth.jwt() ->> 'device_id')::uuid
    );

-- =====================================================
-- 11. SEEDS DE CONFIGURACIÓN DEMO
-- =====================================================

-- Insertar configuración demo para MOWIZ
INSERT INTO device_configs (device_id, company_id, flags_json, accessibility_json, ai_config_json)
SELECT 
    d.id,
    c.id,
    '{"show_time": true, "show_date": true, "time_format": "24h", "date_format": "dd/MM/yyyy"}'::jsonb,
    '{"dark_mode": false, "high_contrast": false, "text_size": 100, "tts_enabled": false}'::jsonb,
    '{"adaptive_enabled": true, "learning_rate": 0.1, "memory_days": 30}'::jsonb
FROM devices d
CROSS JOIN companies c
WHERE c.name = 'MOWIZ' AND d.alias = 'Kiosko Madrid Centro'
ON CONFLICT (device_id) DO NOTHING;

-- Insertar configuración demo para EYPSA
INSERT INTO device_configs (device_id, company_id, flags_json, accessibility_json, ai_config_json)
SELECT 
    d.id,
    c.id,
    '{"show_time": true, "show_date": true, "time_format": "12h", "date_format": "MM/dd/yyyy"}'::jsonb,
    '{"dark_mode": true, "high_contrast": true, "text_size": 125, "tts_enabled": true}'::jsonb,
    '{"adaptive_enabled": true, "learning_rate": 0.2, "memory_days": 60}'::jsonb
FROM devices d
CROSS JOIN companies c
WHERE c.name = 'EYPSA' AND d.alias = 'Kiosko Barcelona Eixample'
ON CONFLICT (device_id) DO NOTHING;

-- Insertar configuración de idiomas demo
INSERT INTO i18n_overrides (company_id, locale, text_overrides_json)
SELECT 
    c.id,
    'es-ES',
    '{"welcome_message": "Bienvenido a MEYPARK", "pay_button": "PAGAR ESTACIONAMIENTO", "cancel_button": "ANULAR DENUNCIA"}'::jsonb
FROM companies c
WHERE c.name = 'MOWIZ'
ON CONFLICT (company_id, device_id, locale) DO NOTHING;

INSERT INTO i18n_overrides (company_id, locale, text_overrides_json)
SELECT 
    c.id,
    'ca-ES',
    '{"welcome_message": "Benvingut a MEYPARK", "pay_button": "PAGAR APARCAMENT", "cancel_button": "ANUL·LAR DENÚNCIA"}'::jsonb
FROM companies c
WHERE c.name = 'EYPSA'
ON CONFLICT (company_id, device_id, locale) DO NOTHING;

-- Insertar configuración de pagos demo
INSERT INTO payment_configs (company_id, enabled_methods, price_config_json, validation_rules_json)
SELECT 
    c.id,
    '["gpay", "apple_pay", "qr", "emv", "coins"]'::jsonb,
    '{"currency": "EUR", "decimal_places": 2, "symbol": "€"}'::jsonb,
    '{"min_amount": 50, "max_amount": 50000, "step_amount": 50}'::jsonb
FROM companies c
WHERE c.name = 'MOWIZ'
ON CONFLICT (company_id, device_id) DO NOTHING;

-- Insertar configuración de notificaciones demo
INSERT INTO notification_configs (company_id, enabled_types, tts_config_json, visual_config_json)
SELECT 
    c.id,
    '["success", "error", "warning", "info"]'::jsonb,
    '{"enabled": true, "speed": 0.8, "pitch": 1.0, "volume": 0.9}'::jsonb,
    '{"duration": 3000, "position": "top", "color": "#4CAF50"}'::jsonb
FROM companies c
WHERE c.name = 'MOWIZ'
ON CONFLICT (company_id, device_id) DO NOTHING;

-- Insertar configuración de hardware demo
INSERT INTO hardware_configs (device_id, peripherals_json, network_config_json, power_config_json)
SELECT 
    d.id,
    '{"printer": {"enabled": true, "model": "EPSON-TM20"}, "emv": {"enabled": true, "timeout": 30}}'::jsonb,
    '{"wifi_enabled": true, "ethernet_enabled": false, "timeout": 30}'::jsonb,
    '{"battery_threshold": 20, "auto_shutdown": true, "sleep_timeout": 300}'::jsonb
FROM devices d
WHERE d.alias = 'Kiosko Madrid Centro'
ON CONFLICT (device_id) DO NOTHING;

-- Insertar configuración de seguridad demo
INSERT INTO security_configs (company_id, auth_config_json, permissions_json, audit_config_json)
SELECT 
    c.id,
    '{"hidden_login_enabled": true, "tech_mode_pin": "1234", "session_timeout": 3600}'::jsonb,
    '{"can_override_payments": true, "can_access_tech_mode": true, "can_modify_settings": true}'::jsonb,
    '{"log_all_actions": true, "retention_days": 90, "alert_on_errors": true}'::jsonb
FROM companies c
WHERE c.name = 'MOWIZ'
ON CONFLICT (company_id, device_id) DO NOTHING;

-- Insertar configuración de mantenimiento demo
INSERT INTO maintenance_configs (device_id, auto_maintenance_json, alert_config_json, update_config_json)
SELECT 
    d.id,
    '{"enabled": true, "check_interval": 3600, "auto_restart": true}'::jsonb,
    '{"paper_low_threshold": 20, "battery_low_threshold": 15, "temp_high_threshold": 50}'::jsonb,
    '{"auto_update": true, "update_channel": "stable", "rollback_on_error": true}'::jsonb
FROM devices d
WHERE d.alias = 'Kiosko Madrid Centro'
ON CONFLICT (device_id) DO NOTHING;

-- =====================================================
-- 12. COMENTARIOS DE DOCUMENTACIÓN
-- =====================================================

COMMENT ON TABLE device_configs IS 'Configuración específica de cada dispositivo kiosko';
COMMENT ON TABLE i18n_overrides IS 'Overrides de internacionalización por empresa/dispositivo';
COMMENT ON TABLE payment_configs IS 'Configuración de métodos de pago y validación';
COMMENT ON TABLE notification_configs IS 'Configuración de notificaciones y TTS';
COMMENT ON TABLE hardware_configs IS 'Configuración de hardware y periféricos';
COMMENT ON TABLE security_configs IS 'Configuración de seguridad y permisos';
COMMENT ON TABLE maintenance_configs IS 'Configuración de mantenimiento automático';

-- =====================================================
-- MIGRACIÓN COMPLETADA
-- =====================================================
