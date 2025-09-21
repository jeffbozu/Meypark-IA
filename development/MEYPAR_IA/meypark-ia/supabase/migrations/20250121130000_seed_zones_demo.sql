-- =====================================================
-- SEED DE ZONAS DE DEMO PARA KIOSKO
-- =====================================================

-- Insertar zonas de ejemplo
INSERT INTO zones (id, company_id, name, color, schedule_json, is_active, is_external, discounts_json, resident_discount_json)
VALUES 
  ('zone_001', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Centro', '#FF6B6B', '{"monday": {"start": "08:00", "end": "20:00"}, "tuesday": {"start": "08:00", "end": "20:00"}, "wednesday": {"start": "08:00", "end": "20:00"}, "thursday": {"start": "08:00", "end": "20:00"}, "friday": {"start": "08:00", "end": "20:00"}, "saturday": {"start": "09:00", "end": "14:00"}, "sunday": {"start": "10:00", "end": "14:00"}}', true, false, '{"resident": 0.5, "disabled": 0.0}', '{"enabled": true, "discount_percent": 50}'),
  ('zone_002', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Comercial', '#4ECDC4', '{"monday": {"start": "09:00", "end": "21:00"}, "tuesday": {"start": "09:00", "end": "21:00"}, "wednesday": {"start": "09:00", "end": "21:00"}, "thursday": {"start": "09:00", "end": "21:00"}, "friday": {"start": "09:00", "end": "21:00"}, "saturday": {"start": "10:00", "end": "22:00"}, "sunday": {"start": "10:00", "end": "20:00"}}', true, false, '{"resident": 0.3, "disabled": 0.0}', '{"enabled": true, "discount_percent": 30}'),
  ('zone_003', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Residencial', '#45B7D1', '{"monday": {"start": "08:00", "end": "18:00"}, "tuesday": {"start": "08:00", "end": "18:00"}, "wednesday": {"start": "08:00", "end": "18:00"}, "thursday": {"start": "08:00", "end": "18:00"}, "friday": {"start": "08:00", "end": "18:00"}, "saturday": {"start": "09:00", "end": "15:00"}, "sunday": {"start": "10:00", "end": "14:00"}}', true, false, '{"resident": 0.0, "disabled": 0.0}', '{"enabled": true, "discount_percent": 0}'),
  ('zone_004', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Turística', '#96CEB4', '{"monday": {"start": "07:00", "end": "23:00"}, "tuesday": {"start": "07:00", "end": "23:00"}, "wednesday": {"start": "07:00", "end": "23:00"}, "thursday": {"start": "07:00", "end": "23:00"}, "friday": {"start": "07:00", "end": "23:00"}, "saturday": {"start": "07:00", "end": "23:00"}, "sunday": {"start": "07:00", "end": "23:00"}}', true, false, '{"resident": 0.2, "disabled": 0.0}', '{"enabled": true, "discount_percent": 20}'),
  ('zone_005', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Hospital', '#FECA57', '{"monday": {"start": "00:00", "end": "23:59"}, "tuesday": {"start": "00:00", "end": "23:59"}, "wednesday": {"start": "00:00", "end": "23:59"}, "thursday": {"start": "00:00", "end": "23:59"}, "friday": {"start": "00:00", "end": "23:59"}, "saturday": {"start": "00:00", "end": "23:59"}, "sunday": {"start": "00:00", "end": "23:59"}}', true, false, '{"resident": 0.0, "disabled": 0.0}', '{"enabled": true, "discount_percent": 0}'),
  ('zone_006', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Zona Universidad', '#FF9FF3', '{"monday": {"start": "07:00", "end": "19:00"}, "tuesday": {"start": "07:00", "end": "19:00"}, "wednesday": {"start": "07:00", "end": "19:00"}, "thursday": {"start": "07:00", "end": "19:00"}, "friday": {"start": "07:00", "end": "19:00"}, "saturday": {"start": "08:00", "end": "14:00"}, "sunday": {"start": "09:00", "end": "13:00"}}', true, false, '{"resident": 0.4, "disabled": 0.0}', '{"enabled": true, "discount_percent": 40}')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  color = EXCLUDED.color,
  schedule_json = EXCLUDED.schedule_json,
  is_active = EXCLUDED.is_active,
  is_external = EXCLUDED.is_external,
  discounts_json = EXCLUDED.discounts_json,
  resident_discount_json = EXCLUDED.resident_discount_json;

-- Insertar tarifas para las zonas
INSERT INTO tariffs (id, zone_id, price_per_min_cents, min_minutes, max_minutes, step_minutes, presets_json, is_active)
VALUES 
  ('tariff_001', 'zone_001', 2, 15, 240, 5, '[15, 30, 60, 120, 180]', true),
  ('tariff_002', 'zone_002', 3, 15, 240, 5, '[15, 30, 60, 120, 180]', true),
  ('tariff_003', 'zone_003', 1, 30, 480, 10, '[30, 60, 120, 240, 360]', true),
  ('tariff_004', 'zone_004', 4, 15, 180, 5, '[15, 30, 60, 90, 120]', true),
  ('tariff_005', 'zone_005', 1, 15, 480, 5, '[15, 30, 60, 120, 240]', true),
  ('tariff_006', 'zone_006', 2, 15, 240, 5, '[15, 30, 60, 120, 180]', true)
ON CONFLICT (id) DO UPDATE SET
  price_per_min_cents = EXCLUDED.price_per_min_cents,
  min_minutes = EXCLUDED.min_minutes,
  max_minutes = EXCLUDED.max_minutes,
  step_minutes = EXCLUDED.step_minutes,
  presets_json = EXCLUDED.presets_json,
  is_active = EXCLUDED.is_active;

