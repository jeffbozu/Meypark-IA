-- =====================================================
-- MIGRACIÓN: TABLAS DE DATOS DE NEGOCIO
-- =====================================================
-- Descripción: Tablas para datos de negocio que estaban hardcodeados
-- Fecha: 2025-01-22
-- Autor: MEYPARK IA Team

-- =====================================================
-- 1. TABLA DE ZONAS DE ESTACIONAMIENTO
-- =====================================================
CREATE TABLE IF NOT EXISTS parking_zones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    
    -- Identificación de la zona
    zone_code VARCHAR(50) NOT NULL, -- Ejemplo: 'zone_001', 'CENTRO_01'
    name VARCHAR(100) NOT NULL, -- Ejemplo: 'Zona Centro'
    description TEXT,
    
    -- Configuración visual
    color VARCHAR(7) NOT NULL DEFAULT '#FF6B6B', -- Color hex
    icon VARCHAR(50), -- Nombre del icono
    
    -- Configuración de horarios
    schedule_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    -- Ejemplo: {"monday": {"start": "08:00", "end": "20:00"}, ...}
    
    -- Configuración de precios
    price_per_hour_cents INTEGER NOT NULL DEFAULT 250, -- 2.50€ = 250 centavos
    price_per_minute_cents INTEGER DEFAULT 5, -- 0.05€ = 5 centavos
    
    -- Configuración de validación
    max_duration_hours INTEGER DEFAULT 8,
    min_duration_minutes INTEGER DEFAULT 15,
    
    -- Estado
    is_active BOOLEAN NOT NULL DEFAULT true,
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, zone_code)
);

-- =====================================================
-- 2. TABLA DE MÉTODOS DE PAGO
-- =====================================================
CREATE TABLE IF NOT EXISTS payment_methods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    
    -- Identificación del método
    method_code VARCHAR(50) NOT NULL, -- Ejemplo: 'card', 'contactless', 'mobile', 'cash'
    name VARCHAR(100) NOT NULL, -- Ejemplo: 'Tarjeta de Crédito/Débito'
    description TEXT,
    
    -- Configuración visual
    icon VARCHAR(50), -- Nombre del icono de Material Icons
    color VARCHAR(7) DEFAULT '#2196F3', -- Color hex
    
    -- Configuración técnica
    is_digital BOOLEAN NOT NULL DEFAULT true,
    requires_network BOOLEAN NOT NULL DEFAULT true,
    supports_refund BOOLEAN NOT NULL DEFAULT true,
    
    -- Configuración de comisiones
    commission_percentage DECIMAL(5,2) DEFAULT 0.00, -- Porcentaje de comisión
    fixed_fee_cents INTEGER DEFAULT 0, -- Comisión fija en centavos
    
    -- Estado
    is_active BOOLEAN NOT NULL DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, method_code)
);

-- =====================================================
-- 3. TABLA DE PAÍSES SOPORTADOS
-- =====================================================
CREATE TABLE IF NOT EXISTS supported_countries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    
    -- Identificación del país
    country_code VARCHAR(2) NOT NULL, -- ISO 3166-1 alpha-2
    name VARCHAR(100) NOT NULL, -- Ejemplo: 'España', 'Francia'
    
    -- Configuración de validación de matrículas
    plate_patterns JSONB DEFAULT '[]'::jsonb,
    -- Ejemplo: [{"pattern": "^[0-9]{4}[A-Z]{3}$", "description": "Formato español"}]
    
    -- Configuración de moneda
    currency_code VARCHAR(3) DEFAULT 'EUR', -- ISO 4217
    currency_symbol VARCHAR(5) DEFAULT '€',
    
    -- Estado
    is_active BOOLEAN NOT NULL DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, country_code)
);

-- =====================================================
-- 4. TABLA DE DENUNCIAS/MULTAS
-- =====================================================
CREATE TABLE IF NOT EXISTS fines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    zone_id UUID REFERENCES parking_zones(id) ON DELETE SET NULL,
    
    -- Identificación del vehículo
    plate_number VARCHAR(20) NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    
    -- Información de la denuncia
    fine_number VARCHAR(50) NOT NULL, -- Número de denuncia
    reason TEXT NOT NULL, -- Motivo de la denuncia
    amount_cents INTEGER NOT NULL, -- Importe en centavos
    
    -- Estado de la denuncia
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- 'active', 'paid', 'cancelled', 'disputed'
    
    -- Información de ubicación
    location_description TEXT,
    coordinates POINT, -- Coordenadas GPS si están disponibles
    
    -- Información temporal
    violation_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    paid_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    
    -- Información del inspector
    inspector_id UUID, -- Referencia a usuario inspector
    inspector_notes TEXT,
    
    -- Metadatos
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, fine_number)
);

-- =====================================================
-- 5. TABLA DE CONFIGURACIÓN DE TARIFAS
-- =====================================================
CREATE TABLE IF NOT EXISTS tariff_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    zone_id UUID REFERENCES parking_zones(id) ON DELETE CASCADE,
    
    -- Configuración de tarifas
    base_price_cents INTEGER NOT NULL, -- Precio base por hora
    price_increment_cents INTEGER DEFAULT 0, -- Incremento por hora adicional
    
    -- Configuración de descuentos
    discount_rules_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"after_2_hours": 0.1, "weekend": 0.2}
    
    -- Configuración de franjas horarias
    time_bands_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"peak_hours": {"start": "08:00", "end": "18:00", "multiplier": 1.5}}
    
    -- Configuración de días especiales
    special_days_json JSONB DEFAULT '{}'::jsonb,
    -- Ejemplo: {"holidays": {"multiplier": 0.5}, "sundays": {"multiplier": 0.8}}
    
    -- Estado
    is_active BOOLEAN NOT NULL DEFAULT true,
    valid_from TIMESTAMPTZ DEFAULT NOW(),
    valid_until TIMESTAMPTZ,
    
    -- Metadatos
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(company_id, zone_id, valid_from)
);

-- =====================================================
-- ÍNDICES PARA RENDIMIENTO
-- =====================================================

-- Índices para parking_zones
CREATE INDEX IF NOT EXISTS idx_parking_zones_company_active 
    ON parking_zones(company_id, is_active);

-- Índices para payment_methods
CREATE INDEX IF NOT EXISTS idx_payment_methods_company_active 
    ON payment_methods(company_id, is_active);

-- Índices para supported_countries
CREATE INDEX IF NOT EXISTS idx_supported_countries_company_active 
    ON supported_countries(company_id, is_active);

-- Índices para fines
CREATE INDEX IF NOT EXISTS idx_fines_company_plate 
    ON fines(company_id, plate_number, country_code);
CREATE INDEX IF NOT EXISTS idx_fines_status 
    ON fines(status);
CREATE INDEX IF NOT EXISTS idx_fines_violation_time 
    ON fines(violation_time);

-- Índices para tariff_configs
CREATE INDEX IF NOT EXISTS idx_tariff_configs_company_zone 
    ON tariff_configs(company_id, zone_id);
CREATE INDEX IF NOT EXISTS idx_tariff_configs_active 
    ON tariff_configs(is_active, valid_from, valid_until);

-- =====================================================
-- TRIGGERS PARA UPDATED_AT
-- =====================================================

-- Trigger para parking_zones
CREATE OR REPLACE FUNCTION update_parking_zones_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_parking_zones_updated_at
    BEFORE UPDATE ON parking_zones
    FOR EACH ROW
    EXECUTE FUNCTION update_parking_zones_updated_at();

-- Trigger para payment_methods
CREATE OR REPLACE FUNCTION update_payment_methods_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_payment_methods_updated_at
    BEFORE UPDATE ON payment_methods
    FOR EACH ROW
    EXECUTE FUNCTION update_payment_methods_updated_at();

-- Trigger para supported_countries
CREATE OR REPLACE FUNCTION update_supported_countries_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_supported_countries_updated_at
    BEFORE UPDATE ON supported_countries
    FOR EACH ROW
    EXECUTE FUNCTION update_supported_countries_updated_at();

-- Trigger para fines
CREATE OR REPLACE FUNCTION update_fines_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_fines_updated_at
    BEFORE UPDATE ON fines
    FOR EACH ROW
    EXECUTE FUNCTION update_fines_updated_at();

-- Trigger para tariff_configs
CREATE OR REPLACE FUNCTION update_tariff_configs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_tariff_configs_updated_at
    BEFORE UPDATE ON tariff_configs
    FOR EACH ROW
    EXECUTE FUNCTION update_tariff_configs_updated_at();

-- =====================================================
-- RLS POLICIES
-- =====================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE parking_zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE supported_countries ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE tariff_configs ENABLE ROW LEVEL SECURITY;

-- Políticas para parking_zones
CREATE POLICY "parking_zones_select_policy" ON parking_zones
    FOR SELECT USING (true); -- Todos pueden leer las zonas

CREATE POLICY "parking_zones_insert_policy" ON parking_zones
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "parking_zones_update_policy" ON parking_zones
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "parking_zones_delete_policy" ON parking_zones
    FOR DELETE USING (auth.role() = 'service_role');

-- Políticas para payment_methods
CREATE POLICY "payment_methods_select_policy" ON payment_methods
    FOR SELECT USING (true); -- Todos pueden leer los métodos de pago

CREATE POLICY "payment_methods_insert_policy" ON payment_methods
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "payment_methods_update_policy" ON payment_methods
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "payment_methods_delete_policy" ON payment_methods
    FOR DELETE USING (auth.role() = 'service_role');

-- Políticas para supported_countries
CREATE POLICY "supported_countries_select_policy" ON supported_countries
    FOR SELECT USING (true); -- Todos pueden leer los países

CREATE POLICY "supported_countries_insert_policy" ON supported_countries
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "supported_countries_update_policy" ON supported_countries
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "supported_countries_delete_policy" ON supported_countries
    FOR DELETE USING (auth.role() = 'service_role');

-- Políticas para fines
CREATE POLICY "fines_select_policy" ON fines
    FOR SELECT USING (true); -- Todos pueden leer las denuncias

CREATE POLICY "fines_insert_policy" ON fines
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "fines_update_policy" ON fines
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "fines_delete_policy" ON fines
    FOR DELETE USING (auth.role() = 'service_role');

-- Políticas para tariff_configs
CREATE POLICY "tariff_configs_select_policy" ON tariff_configs
    FOR SELECT USING (true); -- Todos pueden leer las tarifas

CREATE POLICY "tariff_configs_insert_policy" ON tariff_configs
    FOR INSERT WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "tariff_configs_update_policy" ON tariff_configs
    FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "tariff_configs_delete_policy" ON tariff_configs
    FOR DELETE USING (auth.role() = 'service_role');
