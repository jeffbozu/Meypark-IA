-- =====================================================
-- MIGRACIÓN: TABLA DE CONTRASEÑAS DEL SISTEMA
-- =====================================================
-- Descripción: Tabla para contraseñas de acceso a modos especiales
-- Fecha: 2025-01-22
-- Autor: MEYPARK IA Team

-- =====================================================
-- 1. TABLA DE CONTRASEÑAS DEL SISTEMA
-- =====================================================
CREATE TABLE IF NOT EXISTS system_passwords (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    
    -- Tipo de contraseña
    password_type VARCHAR(50) NOT NULL, -- 'login', 'tech_mode'
    
    -- Contraseña encriptada
    password_hash VARCHAR(255) NOT NULL,
    
    -- Configuración de acceso
    is_active BOOLEAN NOT NULL DEFAULT true,
    max_attempts INTEGER DEFAULT 3,
    lockout_duration_minutes INTEGER DEFAULT 15,
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_used_at TIMESTAMPTZ,
    
    -- Constraints
    UNIQUE(company_id, password_type)
);

-- =====================================================
-- 2. TABLA DE INTENTOS DE ACCESO
-- =====================================================
CREATE TABLE IF NOT EXISTS access_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE SET NULL,
    
    -- Información del intento
    password_type VARCHAR(50) NOT NULL,
    attempt_ip INET,
    success BOOLEAN NOT NULL DEFAULT false,
    
    -- Metadatos
    attempted_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    INDEX idx_access_attempts_company_type (company_id, password_type),
    INDEX idx_access_attempts_device (device_id),
    INDEX idx_access_attempts_time (attempted_at)
);

-- =====================================================
-- 3. ÍNDICES PARA RENDIMIENTO
-- =====================================================

-- Índices para system_passwords
CREATE INDEX IF NOT EXISTS idx_system_passwords_company_type 
    ON system_passwords(company_id, password_type, is_active);

-- Índices para access_attempts
CREATE INDEX IF NOT EXISTS idx_access_attempts_company_type 
    ON access_attempts(company_id, password_type);

CREATE INDEX IF NOT EXISTS idx_access_attempts_device 
    ON access_attempts(device_id);

CREATE INDEX IF NOT EXISTS idx_access_attempts_time 
    ON access_attempts(attempted_at);

-- =====================================================
-- 4. TRIGGERS PARA UPDATED_AT
-- =====================================================

-- Trigger para system_passwords
CREATE OR REPLACE FUNCTION update_system_passwords_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_system_passwords_updated_at
    BEFORE UPDATE ON system_passwords
    FOR EACH ROW
    EXECUTE FUNCTION update_system_passwords_updated_at();

-- =====================================================
-- 5. RLS POLICIES
-- =====================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE system_passwords ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_attempts ENABLE ROW LEVEL SECURITY;

-- Políticas para system_passwords
CREATE POLICY "system_passwords_select_policy" ON system_passwords
    FOR SELECT USING (true); -- Todos pueden leer las contraseñas (para validación)

CREATE POLICY "system_passwords_insert_policy" ON system_passwords
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "system_passwords_update_policy" ON system_passwords
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "system_passwords_delete_policy" ON system_passwords
    FOR DELETE USING (auth.role() = 'service_role');

-- Políticas para access_attempts
CREATE POLICY "access_attempts_select_policy" ON access_attempts
    FOR SELECT USING (true); -- Todos pueden leer los intentos

CREATE POLICY "access_attempts_insert_policy" ON access_attempts
    FOR INSERT WITH CHECK (true); -- Todos pueden insertar intentos

CREATE POLICY "access_attempts_update_policy" ON access_attempts
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "access_attempts_delete_policy" ON access_attempts
    FOR DELETE USING (auth.role() = 'service_role');

-- =====================================================
-- 6. FUNCIONES DE UTILIDAD
-- =====================================================

-- Función para verificar contraseña
CREATE OR REPLACE FUNCTION verify_system_password(
    p_company_id UUID,
    p_password_type VARCHAR(50),
    p_password VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    stored_hash VARCHAR(255);
    is_valid BOOLEAN := false;
BEGIN
    -- Obtener hash de la contraseña
    SELECT password_hash INTO stored_hash
    FROM system_passwords
    WHERE company_id = p_company_id
      AND password_type = p_password_type
      AND is_active = true;
    
    -- Verificar si existe
    IF stored_hash IS NULL THEN
        RETURN false;
    END IF;
    
    -- Verificar contraseña (usando crypt de pgcrypto)
    is_valid := (stored_hash = crypt(p_password, stored_hash));
    
    -- Actualizar último uso si es válida
    IF is_valid THEN
        UPDATE system_passwords
        SET last_used_at = NOW()
        WHERE company_id = p_company_id
          AND password_type = p_password_type;
    END IF;
    
    RETURN is_valid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para registrar intento de acceso
CREATE OR REPLACE FUNCTION log_access_attempt(
    p_company_id UUID,
    p_device_id UUID,
    p_password_type VARCHAR(50),
    p_attempt_ip INET,
    p_success BOOLEAN
) RETURNS VOID AS $$
BEGIN
    INSERT INTO access_attempts (
        company_id,
        device_id,
        password_type,
        attempt_ip,
        success
    ) VALUES (
        p_company_id,
        p_device_id,
        p_password_type,
        p_attempt_ip,
        p_success
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
