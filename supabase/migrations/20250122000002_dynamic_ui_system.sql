-- =====================================================
-- SISTEMA DINÁMICO DE UI PARA KIOSKO
-- =====================================================

-- Tabla de configuración de UI por empresa
CREATE TABLE IF NOT EXISTS ui_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  -- Colores principales
  primary_color TEXT NOT NULL DEFAULT '#E62144',
  secondary_color TEXT NOT NULL DEFAULT '#000000',
  accent_color TEXT NOT NULL DEFAULT '#7F7F7F',
  success_color TEXT NOT NULL DEFAULT '#4CAF50',
  warning_color TEXT NOT NULL DEFAULT '#FF9800',
  error_color TEXT NOT NULL DEFAULT '#F44336',
  
  -- AppBar
  appbar_background_color TEXT NOT NULL DEFAULT '#E62144',
  appbar_text_color TEXT NOT NULL DEFAULT '#FFFFFF',
  show_time BOOLEAN NOT NULL DEFAULT true,
  show_date BOOLEAN NOT NULL DEFAULT true,
  time_format_24h BOOLEAN NOT NULL DEFAULT true,
  
  -- Botones
  button_primary_color TEXT NOT NULL DEFAULT '#E62144',
  button_secondary_color TEXT NOT NULL DEFAULT '#FFFFFF',
  button_text_color TEXT NOT NULL DEFAULT '#FFFFFF',
  button_border_radius INTEGER NOT NULL DEFAULT 16,
  button_elevation INTEGER NOT NULL DEFAULT 8,
  
  -- Tipografía
  font_family TEXT NOT NULL DEFAULT 'Inter',
  title_font_size INTEGER NOT NULL DEFAULT 28,
  subtitle_font_size INTEGER NOT NULL DEFAULT 20,
  body_font_size INTEGER NOT NULL DEFAULT 16,
  button_font_size INTEGER NOT NULL DEFAULT 18,
  
  -- Layout
  screen_padding INTEGER NOT NULL DEFAULT 24,
  card_padding INTEGER NOT NULL DEFAULT 20,
  button_height INTEGER NOT NULL DEFAULT 60,
  icon_size INTEGER NOT NULL DEFAULT 32,
  
  -- Animaciones
  animation_duration INTEGER NOT NULL DEFAULT 300,
  enable_animations BOOLEAN NOT NULL DEFAULT true,
  enable_hover_effects BOOLEAN NOT NULL DEFAULT true,
  
  -- Configuración general
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id)
);

-- Tabla de textos dinámicos por idioma
CREATE TABLE IF NOT EXISTS ui_texts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  -- Identificador del texto
  text_key TEXT NOT NULL,
  text_category TEXT NOT NULL, -- 'button', 'title', 'message', 'error', 'success'
  
  -- Textos por idioma
  text_es TEXT NOT NULL,
  text_en TEXT,
  text_de TEXT,
  text_fr TEXT,
  text_it TEXT,
  text_ca TEXT, -- Catalán
  text_gl TEXT, -- Gallego
  text_eu TEXT, -- Euskera
  
  -- Configuración
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id, text_key)
);

-- Tabla de configuración de accesibilidad
CREATE TABLE IF NOT EXISTS accessibility_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  -- TTS (Text-to-Speech)
  tts_enabled BOOLEAN NOT NULL DEFAULT false,
  tts_speech_rate DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  tts_pitch DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  tts_volume DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  tts_language TEXT NOT NULL DEFAULT 'es-ES',
  
  -- Visual
  high_contrast_enabled BOOLEAN NOT NULL DEFAULT false,
  dark_mode_enabled BOOLEAN NOT NULL DEFAULT false,
  large_text_enabled BOOLEAN NOT NULL DEFAULT false,
  text_scale_factor DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  
  -- Simplificado
  simplified_mode_enabled BOOLEAN NOT NULL DEFAULT false,
  hide_advanced_options BOOLEAN NOT NULL DEFAULT false,
  
  -- Tiempo
  extended_time_enabled BOOLEAN NOT NULL DEFAULT false,
  time_multiplier DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  
  -- Navegación
  voice_navigation_enabled BOOLEAN NOT NULL DEFAULT false,
  gesture_navigation_enabled BOOLEAN NOT NULL DEFAULT false,
  
  -- Configuración
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id)
);

-- Tabla de idiomas disponibles
CREATE TABLE IF NOT EXISTS available_languages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  language_code TEXT NOT NULL, -- 'es', 'en', 'de', 'fr', 'it', 'ca', 'gl', 'eu'
  language_name TEXT NOT NULL, -- 'Español', 'English', 'Deutsch', etc.
  is_default BOOLEAN NOT NULL DEFAULT false,
  is_active BOOLEAN NOT NULL DEFAULT true,
  display_order INTEGER NOT NULL DEFAULT 0,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id, language_code)
);

-- Tabla de métodos de pago disponibles
CREATE TABLE IF NOT EXISTS payment_methods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  method_code TEXT NOT NULL, -- 'card', 'cash', 'mobile', 'qr'
  method_name TEXT NOT NULL, -- 'Tarjeta', 'Efectivo', 'Móvil', 'QR'
  method_icon TEXT NOT NULL, -- 'credit_card', 'money', 'phone', 'qr_code'
  is_enabled BOOLEAN NOT NULL DEFAULT true,
  display_order INTEGER NOT NULL DEFAULT 0,
  
  -- Configuración específica
  requires_contactless BOOLEAN NOT NULL DEFAULT false,
  requires_cash_drawer BOOLEAN NOT NULL DEFAULT false,
  requires_camera BOOLEAN NOT NULL DEFAULT false,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id, method_code)
);

-- Tabla de configuración de IA adaptativa
CREATE TABLE IF NOT EXISTS ai_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
  
  -- IA general
  ai_enabled BOOLEAN NOT NULL DEFAULT false,
  learning_enabled BOOLEAN NOT NULL DEFAULT false,
  
  -- Recomendaciones
  zone_recommendations_enabled BOOLEAN NOT NULL DEFAULT false,
  payment_recommendations_enabled BOOLEAN NOT NULL DEFAULT false,
  duration_recommendations_enabled BOOLEAN NOT NULL DEFAULT false,
  
  -- Configuración de aprendizaje
  history_days INTEGER NOT NULL DEFAULT 30,
  min_payments_for_recommendation INTEGER NOT NULL DEFAULT 3,
  
  -- Configuración
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(company_id, device_id)
);

-- =====================================================
-- RLS POLICIES
-- =====================================================

-- UI Configs RLS
ALTER TABLE ui_configs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ui_configs_policy" ON ui_configs
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );

-- UI Texts RLS
ALTER TABLE ui_texts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ui_texts_policy" ON ui_texts
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );

-- Accessibility Configs RLS
ALTER TABLE accessibility_configs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "accessibility_configs_policy" ON accessibility_configs
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );

-- Available Languages RLS
ALTER TABLE available_languages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "available_languages_policy" ON available_languages
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );

-- Payment Methods RLS
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
CREATE POLICY "payment_methods_policy" ON payment_methods
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );

-- AI Configs RLS
ALTER TABLE ai_configs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_configs_policy" ON ai_configs
  FOR ALL USING (
    company_id::text = (auth.jwt() ->> 'company_id')::text OR
    device_id::text = (auth.jwt() ->> 'device_id')::text
  );
