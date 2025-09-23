-- =====================================================
-- ZONAS ESPECÍFICAS: 2 MOWIX + 3 EYPSA
-- =====================================================

-- Limpiar zonas existentes
DELETE FROM tariffs WHERE zone_id IN (
  SELECT id FROM zones WHERE company_id IN (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', -- MOWIX
    'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22'  -- EYPSA
  )
);

DELETE FROM zones WHERE company_id IN (
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', -- MOWIX
  'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22'  -- EYPSA
);

-- Insertar empresas si no existen
INSERT INTO companies (id, name, code, is_active, created_at, updated_at)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'MOWIX Parking', 'MOWIX', true, NOW(), NOW()),
  ('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', 'EYPSA Estacionamientos', 'EYPSA', true, NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  code = EXCLUDED.code,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

-- =====================================================
-- ZONAS MOWIX (2 zonas)
-- =====================================================

-- Zona MOWIX Centro
INSERT INTO zones (id, company_id, code, name, color, schedule_json, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b01', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'MOWIX_CENTRO', 'MOWIX Centro', '#E62144', 
   '{"monday": {"start": "08:00", "end": "20:00"}, "tuesday": {"start": "08:00", "end": "20:00"}, "wednesday": {"start": "08:00", "end": "20:00"}, "thursday": {"start": "08:00", "end": "20:00"}, "friday": {"start": "08:00", "end": "20:00"}, "saturday": {"start": "09:00", "end": "14:00"}, "sunday": {"start": "10:00", "end": "14:00"}}', 
   true);

-- Zona MOWIX Comercial
INSERT INTO zones (id, company_id, code, name, color, schedule_json, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b02', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'MOWIX_COMERCIAL', 'MOWIX Comercial', '#4ECDC4', 
   '{"monday": {"start": "09:00", "end": "21:00"}, "tuesday": {"start": "09:00", "end": "21:00"}, "wednesday": {"start": "09:00", "end": "21:00"}, "thursday": {"start": "09:00", "end": "21:00"}, "friday": {"start": "09:00", "end": "21:00"}, "saturday": {"start": "10:00", "end": "22:00"}, "sunday": {"start": "10:00", "end": "20:00"}}', 
   true);

-- =====================================================
-- ZONAS EYPSA (3 zonas)
-- =====================================================

-- Zona EYPSA Residencial
INSERT INTO zones (id, company_id, code, name, color, schedule_json, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380c01', 'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', 'EYPSA_RESIDENCIAL', 'EYPSA Residencial', '#45B7D1', 
   '{"monday": {"start": "08:00", "end": "18:00"}, "tuesday": {"start": "08:00", "end": "18:00"}, "wednesday": {"start": "08:00", "end": "18:00"}, "thursday": {"start": "08:00", "end": "18:00"}, "friday": {"start": "08:00", "end": "18:00"}, "saturday": {"start": "09:00", "end": "15:00"}, "sunday": {"start": "10:00", "end": "14:00"}}', 
   true);

-- Zona EYPSA Turística
INSERT INTO zones (id, company_id, code, name, color, schedule_json, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380c02', 'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', 'EYPSA_TURISTICA', 'EYPSA Turística', '#96CEB4', 
   '{"monday": {"start": "07:00", "end": "23:00"}, "tuesday": {"start": "07:00", "end": "23:00"}, "wednesday": {"start": "07:00", "end": "23:00"}, "thursday": {"start": "07:00", "end": "23:00"}, "friday": {"start": "07:00", "end": "23:00"}, "saturday": {"start": "07:00", "end": "23:00"}, "sunday": {"start": "07:00", "end": "23:00"}}', 
   true);

-- Zona EYPSA Hospital
INSERT INTO zones (id, company_id, code, name, color, schedule_json, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380c03', 'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', 'EYPSA_HOSPITAL', 'EYPSA Hospital', '#FECA57', 
   '{"monday": {"start": "00:00", "end": "23:59"}, "tuesday": {"start": "00:00", "end": "23:59"}, "wednesday": {"start": "00:00", "end": "23:59"}, "thursday": {"start": "00:00", "end": "23:59"}, "friday": {"start": "00:00", "end": "23:59"}, "saturday": {"start": "00:00", "end": "23:59"}, "sunday": {"start": "00:00", "end": "23:59"}}', 
   true);

-- =====================================================
-- TARIFAS PARA MOWIX
-- =====================================================

-- Tarifa MOWIX Centro
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('mowix_tariff_001', 'mowix_001', 2, 15, 240, 5, '[15, 30, 60, 120, 180]', true);

-- Tarifa MOWIX Comercial
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('mowix_tariff_002', 'mowix_002', 3, 15, 240, 5, '[15, 30, 60, 120, 180]', true);

-- =====================================================
-- TARIFAS PARA EYPSA
-- =====================================================

-- Tarifa EYPSA Residencial
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('eypsa_tariff_001', 'eypsa_001', 1, 30, 480, 10, '[30, 60, 120, 240, 360]', true);

-- Tarifa EYPSA Turística
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('eypsa_tariff_002', 'eypsa_002', 4, 15, 180, 5, '[15, 30, 60, 90, 120]', true);

-- Tarifa EYPSA Hospital
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('eypsa_tariff_003', 'eypsa_003', 1, 15, 480, 5, '[15, 30, 60, 120, 240]', true);
