-- =====================================================
-- SEED DE COMPAÑÍAS PARA KIOSKO
-- =====================================================

-- Insertar compañías de ejemplo
INSERT INTO companies (id, name, cif, address_json, mode, is_active)
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'MOWIX Parking', 'A12345678', '{"street": "Calle Principal 123", "city": "Madrid", "postal_code": "28001", "country": "España"}', 'local', true),
  ('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', 'EYPSA Parking', 'B87654321', '{"street": "Avenida Secundaria 456", "city": "Barcelona", "postal_code": "08001", "country": "España"}', 'local', true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  cif = EXCLUDED.cif,
  address_json = EXCLUDED.address_json,
  mode = EXCLUDED.mode,
  is_active = EXCLUDED.is_active;
