-- =====================================================
-- SEED: DATOS DE NEGOCIO DESDE HARDCODEADOS
-- =====================================================
-- Descripción: Poblar las tablas de negocio con datos que estaban hardcodeados
-- Fecha: 2025-01-22
-- Autor: MEYPARK IA Team

-- =====================================================
-- 1. INSERTAR ZONAS DE ESTACIONAMIENTO
-- =====================================================
INSERT INTO parking_zones (company_id, zone_code, name, description, color, icon, schedule_json, price_per_hour_cents, price_per_minute_cents, max_duration_hours, min_duration_minutes, is_active)
SELECT 
    c.id as company_id,
    zone_data.zone_code,
    zone_data.name,
    zone_data.description,
    zone_data.color,
    zone_data.icon,
    zone_data.schedule_json,
    zone_data.price_per_hour_cents,
    zone_data.price_per_minute_cents,
    zone_data.max_duration_hours,
    zone_data.min_duration_minutes,
    zone_data.is_active
FROM companies c
CROSS JOIN (
    VALUES 
        ('zone_001', 'Zona Centro', 'Zona céntrica de la ciudad', '#FF6B6B', 'location_city', 
         '{"monday": {"start": "08:00", "end": "20:00"}, "tuesday": {"start": "08:00", "end": "20:00"}, "wednesday": {"start": "08:00", "end": "20:00"}, "thursday": {"start": "08:00", "end": "20:00"}, "friday": {"start": "08:00", "end": "20:00"}, "saturday": {"start": "09:00", "end": "14:00"}, "sunday": {"start": "10:00", "end": "14:00"}}'::jsonb,
         250, 5, 8, 15, true),
        ('zone_002', 'Zona Comercial', 'Área comercial principal', '#4ECDC4', 'shopping_cart',
         '{"monday": {"start": "09:00", "end": "21:00"}, "tuesday": {"start": "09:00", "end": "21:00"}, "wednesday": {"start": "09:00", "end": "21:00"}, "thursday": {"start": "09:00", "end": "21:00"}, "friday": {"start": "09:00", "end": "21:00"}, "saturday": {"start": "10:00", "end": "22:00"}, "sunday": {"start": "10:00", "end": "20:00"}}'::jsonb,
         300, 6, 8, 15, true),
        ('zone_003', 'Zona Residencial', 'Zona residencial', '#45B7D1', 'home',
         '{"monday": {"start": "08:00", "end": "18:00"}, "tuesday": {"start": "08:00", "end": "18:00"}, "wednesday": {"start": "08:00", "end": "18:00"}, "thursday": {"start": "08:00", "end": "18:00"}, "friday": {"start": "08:00", "end": "18:00"}, "saturday": {"start": "09:00", "end": "15:00"}, "sunday": {"start": "10:00", "end": "14:00"}}'::jsonb,
         150, 3, 8, 15, true),
        ('zone_004', 'Zona Turística', 'Área turística', '#96CEB4', 'tour',
         '{"monday": {"start": "07:00", "end": "23:00"}, "tuesday": {"start": "07:00", "end": "23:00"}, "wednesday": {"start": "07:00", "end": "23:00"}, "thursday": {"start": "07:00", "end": "23:00"}, "friday": {"start": "07:00", "end": "23:00"}, "saturday": {"start": "07:00", "end": "23:00"}, "sunday": {"start": "07:00", "end": "23:00"}}'::jsonb,
         400, 8, 8, 15, true),
        ('zone_005', 'Zona Hospital', 'Zona hospitalaria', '#FECA57', 'local_hospital',
         '{"monday": {"start": "00:00", "end": "23:59"}, "tuesday": {"start": "00:00", "end": "23:59"}, "wednesday": {"start": "00:00", "end": "23:59"}, "thursday": {"start": "00:00", "end": "23:59"}, "friday": {"start": "00:00", "end": "23:59"}, "saturday": {"start": "00:00", "end": "23:59"}, "sunday": {"start": "00:00", "end": "23:59"}}'::jsonb,
         200, 4, 8, 15, true),
        ('zone_006', 'Zona Universidad', 'Zona universitaria', '#FF9FF3', 'school',
         '{"monday": {"start": "07:00", "end": "19:00"}, "tuesday": {"start": "07:00", "end": "19:00"}, "wednesday": {"start": "07:00", "end": "19:00"}, "thursday": {"start": "07:00", "end": "19:00"}, "friday": {"start": "07:00", "end": "19:00"}, "saturday": {"start": "08:00", "end": "14:00"}, "sunday": {"start": "09:00", "end": "13:00"}}'::jsonb,
         180, 4, 8, 15, true)
) AS zone_data(zone_code, name, description, color, icon, schedule_json, price_per_hour_cents, price_per_minute_cents, max_duration_hours, min_duration_minutes, is_active)
WHERE c.name = 'MEYPARK IA' -- Asumiendo que existe esta empresa
ON CONFLICT (company_id, zone_code) DO NOTHING;

-- =====================================================
-- 2. INSERTAR MÉTODOS DE PAGO
-- =====================================================
INSERT INTO payment_methods (company_id, method_code, name, description, icon, color, is_digital, requires_network, supports_refund, commission_percentage, fixed_fee_cents, is_active, sort_order)
SELECT 
    c.id as company_id,
    method_data.method_code,
    method_data.name,
    method_data.description,
    method_data.icon,
    method_data.color,
    method_data.is_digital,
    method_data.requires_network,
    method_data.supports_refund,
    method_data.commission_percentage,
    method_data.fixed_fee_cents,
    method_data.is_active,
    method_data.sort_order
FROM companies c
CROSS JOIN (
    VALUES 
        ('card', 'Tarjeta de Crédito/Débito', 'Pago con tarjeta de crédito o débito', 'credit_card', '#2196F3', true, true, true, 2.50, 0, true, 1),
        ('contactless', 'Pago Sin Contacto', 'Pago sin contacto con tarjeta o móvil', 'nfc', '#4CAF50', true, true, true, 1.80, 0, true, 2),
        ('mobile', 'Pago Móvil', 'Pago con aplicación móvil', 'phone_android', '#9C27B0', true, true, true, 1.50, 0, true, 3),
        ('cash', 'Efectivo', 'Pago en efectivo', 'money', '#FF9800', false, false, false, 0.00, 0, true, 4),
        ('qr', 'Código QR', 'Pago mediante código QR', 'qr_code', '#607D8B', true, true, true, 1.20, 0, true, 5)
) AS method_data(method_code, name, description, icon, color, is_digital, requires_network, supports_refund, commission_percentage, fixed_fee_cents, is_active, sort_order)
WHERE c.name = 'MEYPARK IA'
ON CONFLICT (company_id, method_code) DO NOTHING;

-- =====================================================
-- 3. INSERTAR PAÍSES SOPORTADOS
-- =====================================================
INSERT INTO supported_countries (company_id, country_code, name, plate_patterns, currency_code, currency_symbol, is_active, sort_order)
SELECT 
    c.id as company_id,
    country_data.country_code,
    country_data.name,
    country_data.plate_patterns,
    country_data.currency_code,
    country_data.currency_symbol,
    country_data.is_active,
    country_data.sort_order
FROM companies c
CROSS JOIN (
    VALUES 
        ('ES', 'España', 
         '[{"pattern": "^[0-9]{4}[A-Z]{3}$", "description": "Formato español: 4 números + 3 letras"}, {"pattern": "^[A-Z]{1,2}[0-9]{4}[A-Z]{1,2}$", "description": "Formato antiguo español"}]'::jsonb,
         'EUR', '€', true, 1),
        ('FR', 'Francia', 
         '[{"pattern": "^[A-Z]{2}[0-9]{3}[A-Z]{2}$", "description": "Formato francés: 2 letras + 3 números + 2 letras"}]'::jsonb,
         'EUR', '€', true, 2),
        ('DE', 'Alemania', 
         '[{"pattern": "^[A-Z]{1,3}[A-Z]{1,2}[0-9]{1,4}[A-Z]{1,2}$", "description": "Formato alemán"}]'::jsonb,
         'EUR', '€', true, 3),
        ('IT', 'Italia', 
         '[{"pattern": "^[A-Z]{2}[0-9]{3}[A-Z]{2}$", "description": "Formato italiano: 2 letras + 3 números + 2 letras"}]'::jsonb,
         'EUR', '€', true, 4),
        ('PT', 'Portugal', 
         '[{"pattern": "^[0-9]{2}[A-Z]{2}[0-9]{2}$", "description": "Formato portugués: 2 números + 2 letras + 2 números"}]'::jsonb,
         'EUR', '€', true, 5),
        ('GB', 'Reino Unido', 
         '[{"pattern": "^[A-Z]{2}[0-9]{2}[A-Z]{3}$", "description": "Formato británico: 2 letras + 2 números + 3 letras"}]'::jsonb,
         'GBP', '£', true, 6)
) AS country_data(country_code, name, plate_patterns, currency_code, currency_symbol, is_active, sort_order)
WHERE c.name = 'MEYPARK IA'
ON CONFLICT (company_id, country_code) DO NOTHING;

-- =====================================================
-- 4. INSERTAR CONFIGURACIONES DE TARIFAS
-- =====================================================
INSERT INTO tariff_configs (company_id, zone_id, base_price_cents, price_increment_cents, discount_rules_json, time_bands_json, special_days_json, is_active, valid_from)
SELECT 
    c.id as company_id,
    pz.id as zone_id,
    tariff_data.base_price_cents,
    tariff_data.price_increment_cents,
    tariff_data.discount_rules_json,
    tariff_data.time_bands_json,
    tariff_data.special_days_json,
    tariff_data.is_active,
    tariff_data.valid_from
FROM companies c
JOIN parking_zones pz ON pz.company_id = c.id
CROSS JOIN (
    VALUES 
        ('zone_001', 250, 0, 
         '{"after_2_hours": 0.1, "after_4_hours": 0.15}'::jsonb,
         '{"peak_hours": {"start": "08:00", "end": "18:00", "multiplier": 1.2}}'::jsonb,
         '{"sundays": {"multiplier": 0.8}, "holidays": {"multiplier": 0.5}}'::jsonb,
         true, NOW()),
        ('zone_002', 300, 0,
         '{"after_2_hours": 0.1, "after_4_hours": 0.15}'::jsonb,
         '{"peak_hours": {"start": "10:00", "end": "20:00", "multiplier": 1.3}}'::jsonb,
         '{"sundays": {"multiplier": 0.9}, "holidays": {"multiplier": 0.7}}'::jsonb,
         true, NOW()),
        ('zone_003', 150, 0,
         '{"after_2_hours": 0.05, "after_4_hours": 0.1}'::jsonb,
         '{"peak_hours": {"start": "08:00", "end": "17:00", "multiplier": 1.1}}'::jsonb,
         '{"sundays": {"multiplier": 0.7}, "holidays": {"multiplier": 0.5}}'::jsonb,
         true, NOW()),
        ('zone_004', 400, 0,
         '{"after_2_hours": 0.1, "after_4_hours": 0.2}'::jsonb,
         '{"peak_hours": {"start": "09:00", "end": "21:00", "multiplier": 1.5}}'::jsonb,
         '{"sundays": {"multiplier": 1.0}, "holidays": {"multiplier": 1.2}}'::jsonb,
         true, NOW()),
        ('zone_005', 200, 0,
         '{"after_1_hour": 0.05, "after_2_hours": 0.1}'::jsonb,
         '{"peak_hours": {"start": "07:00", "end": "19:00", "multiplier": 1.1}}'::jsonb,
         '{"sundays": {"multiplier": 0.8}, "holidays": {"multiplier": 0.6}}'::jsonb,
         true, NOW()),
        ('zone_006', 180, 0,
         '{"after_2_hours": 0.05, "after_4_hours": 0.1}'::jsonb,
         '{"peak_hours": {"start": "08:00", "end": "18:00", "multiplier": 1.2}}'::jsonb,
         '{"sundays": {"multiplier": 0.6}, "holidays": {"multiplier": 0.4}}'::jsonb,
         true, NOW())
) AS tariff_data(zone_code, base_price_cents, price_increment_cents, discount_rules_json, time_bands_json, special_days_json, is_active, valid_from)
WHERE c.name = 'MEYPARK IA'
  AND pz.zone_code = tariff_data.zone_code
ON CONFLICT (company_id, zone_id, valid_from) DO NOTHING;

-- =====================================================
-- 5. INSERTAR ALGUNAS DENUNCIAS DE EJEMPLO
-- =====================================================
INSERT INTO fines (company_id, zone_id, plate_number, country_code, fine_number, reason, amount_cents, status, location_description, violation_time, created_at)
SELECT 
    c.id as company_id,
    pz.id as zone_id,
    fine_data.plate_number,
    fine_data.country_code,
    fine_data.fine_number,
    fine_data.reason,
    fine_data.amount_cents,
    fine_data.status,
    fine_data.location_description,
    fine_data.violation_time,
    fine_data.created_at
FROM companies c
JOIN parking_zones pz ON pz.company_id = c.id
CROSS JOIN (
    VALUES 
        ('zone_001', '1234ABC', 'ES', 'FINE-001', 'Estacionamiento en zona prohibida', 5000, 'active', 'Calle Mayor, 123', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
        ('zone_002', '5678DEF', 'ES', 'FINE-002', 'Tiempo de estacionamiento excedido', 3000, 'active', 'Plaza del Comercio, 45', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
        ('zone_003', '9012GHI', 'ES', 'FINE-003', 'Estacionamiento sin pagar', 2500, 'paid', 'Avenida de la Paz, 78', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
        ('zone_001', '3456JKL', 'ES', 'FINE-004', 'Estacionamiento en zona de carga y descarga', 7500, 'cancelled', 'Calle del Mercado, 12', NOW() - INTERVAL '4 hours', NOW() - INTERVAL '4 hours')
) AS fine_data(zone_code, plate_number, country_code, fine_number, reason, amount_cents, status, location_description, violation_time, created_at)
WHERE c.name = 'MEYPARK IA'
  AND pz.zone_code = fine_data.zone_code
ON CONFLICT (company_id, fine_number) DO NOTHING;

-- =====================================================
-- COMENTARIOS FINALES
-- =====================================================
-- Los datos han sido migrados desde el código hardcodeado a Supabase
-- Ahora la aplicación debe usar estos datos desde la base de datos
-- en lugar de los datos estáticos que estaban en el código
