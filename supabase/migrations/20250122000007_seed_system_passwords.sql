-- =====================================================
-- SEED: CONTRASEÑAS DEL SISTEMA
-- =====================================================
-- Descripción: Insertar contraseñas por defecto para acceso a modos especiales
-- Fecha: 2025-01-22
-- Autor: MEYPARK IA Team

-- =====================================================
-- 1. INSERTAR CONTRASEÑAS DEL SISTEMA
-- =====================================================
INSERT INTO system_passwords (company_id, password_type, password_hash, is_active, max_attempts, lockout_duration_minutes)
SELECT 
    c.id as company_id,
    password_data.password_type,
    password_data.password_hash,
    password_data.is_active,
    password_data.max_attempts,
    password_data.lockout_duration_minutes
FROM companies c
CROSS JOIN (
    VALUES 
        ('login', crypt('meypark2025', gen_salt('bf')), true, 3, 15),
        ('tech_mode', crypt('admin123', gen_salt('bf')), true, 5, 30)
) AS password_data(password_type, password_hash, is_active, max_attempts, lockout_duration_minutes)
WHERE c.name = 'MEYPARK IA'
ON CONFLICT (company_id, password_type) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    is_active = EXCLUDED.is_active,
    max_attempts = EXCLUDED.max_attempts,
    lockout_duration_minutes = EXCLUDED.lockout_duration_minutes,
    updated_at = NOW();

-- =====================================================
-- 2. COMENTARIOS SOBRE LAS CONTRASEÑAS
-- =====================================================
-- CONTRASEÑAS POR DEFECTO:
-- - Login: meypark2025
-- - Modo Técnico: admin123
-- 
-- IMPORTANTE: Cambiar estas contraseñas en producción
-- Las contraseñas se almacenan con hash bcrypt para seguridad
-- 
-- Para cambiar una contraseña:
-- UPDATE system_passwords 
-- SET password_hash = crypt('nueva_contraseña', gen_salt('bf'))
-- WHERE company_id = (SELECT id FROM companies WHERE name = 'MEYPARK IA')
--   AND password_type = 'login'; -- o 'tech_mode'
