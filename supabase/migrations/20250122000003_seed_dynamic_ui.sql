-- =====================================================
-- SEED DATOS INICIALES DEL SISTEMA DINÁMICO
-- =====================================================

-- =====================================================
-- CONFIGURACIÓN UI PARA MOWIX
-- =====================================================

INSERT INTO ui_configs (
  company_id, device_id,
  primary_color, secondary_color, accent_color, success_color, warning_color, error_color,
  appbar_background_color, appbar_text_color, show_time, show_date, time_format_24h,
  button_primary_color, button_secondary_color, button_text_color, button_border_radius, button_elevation,
  font_family, title_font_size, subtitle_font_size, body_font_size, button_font_size,
  screen_padding, card_padding, button_height, icon_size,
  animation_duration, enable_animations, enable_hover_effects
) VALUES (
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', -- MOWIX
  NULL, -- Para todos los dispositivos
  '#E62144', '#000000', '#7F7F7F', '#4CAF50', '#FF9800', '#F44336',
  '#E62144', '#FFFFFF', true, true, true,
  '#E62144', '#FFFFFF', '#FFFFFF', 16, 8,
  'Inter', 28, 20, 16, 18,
  24, 20, 60, 32,
  300, true, true
);

-- =====================================================
-- CONFIGURACIÓN UI PARA EYPSA
-- =====================================================

INSERT INTO ui_configs (
  company_id, device_id,
  primary_color, secondary_color, accent_color, success_color, warning_color, error_color,
  appbar_background_color, appbar_text_color, show_time, show_date, time_format_24h,
  button_primary_color, button_secondary_color, button_text_color, button_border_radius, button_elevation,
  font_family, title_font_size, subtitle_font_size, body_font_size, button_font_size,
  screen_padding, card_padding, button_height, icon_size,
  animation_duration, enable_animations, enable_hover_effects
) VALUES (
  'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', -- EYPSA
  NULL, -- Para todos los dispositivos
  '#2E7D32', '#000000', '#4CAF50', '#4CAF50', '#FF9800', '#F44336',
  '#2E7D32', '#FFFFFF', true, true, true,
  '#2E7D32', '#FFFFFF', '#FFFFFF', 16, 8,
  'Inter', 28, 20, 16, 18,
  24, 20, 60, 32,
  300, true, true
);

-- =====================================================
-- TEXTOS DINÁMICOS PARA MOWIX
-- =====================================================

INSERT INTO ui_texts (company_id, device_id, text_key, text_category, text_es, text_en, text_de, text_fr, text_it) VALUES
-- Botones principales
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_pay_parking', 'button', 'PAGAR ESTACIONAMIENTO', 'PAY PARKING', 'PARKEN BEZAHLEN', 'PAYER LE STATIONNEMENT', 'PAGA PARCHEGGIO'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_cancel_fine', 'button', 'ANULAR DENUNCIA', 'CANCEL FINE', 'STRAFE STORNIEREN', 'ANNULER L''AMENDE', 'ANNULLA MULTA'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_accessibility', 'button', 'ACCESIBILIDAD', 'ACCESSIBILITY', 'BARRIEREFREIHEIT', 'ACCESSIBILITÉ', 'ACCESSIBILITÀ'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_languages', 'button', 'IDIOMAS', 'LANGUAGES', 'SPRACHEN', 'LANGUES', 'LINGUE'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_continue', 'button', 'CONTINUAR', 'CONTINUE', 'WEITER', 'CONTINUER', 'CONTINUA'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_back', 'button', 'VOLVER', 'BACK', 'ZURÜCK', 'RETOUR', 'INDIETRO'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_pay', 'button', 'PAGAR', 'PAY', 'BEZAHLEN', 'PAYER', 'PAGA'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'btn_new_payment', 'button', 'NUEVO PAGO', 'NEW PAYMENT', 'NEUE ZAHLUNG', 'NOUVEAU PAIEMENT', 'NUOVO PAGAMENTO'),

-- Títulos
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'title_welcome', 'title', 'Bienvenido a MOWIX', 'Welcome to MOWIX', 'Willkommen bei MOWIX', 'Bienvenue chez MOWIX', 'Benvenuto a MOWIX'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'title_select_zone', 'title', 'Selecciona tu Zona', 'Select your Zone', 'Wählen Sie Ihre Zone', 'Sélectionnez votre Zone', 'Seleziona la tua Zona'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'title_enter_plate', 'title', 'Introduce tu Matrícula', 'Enter your License Plate', 'Geben Sie Ihr Kennzeichen ein', 'Entrez votre Plaque', 'Inserisci la tua Targa'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'title_select_duration', 'title', 'Selecciona Duración', 'Select Duration', 'Dauer wählen', 'Sélectionner la Durée', 'Seleziona Durata'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'title_payment_method', 'title', 'Método de Pago', 'Payment Method', 'Zahlungsmethode', 'Méthode de Paiement', 'Metodo di Pagamento'),

-- Mensajes
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'msg_payment_success', 'message', '¡Pago Exitoso!', 'Payment Successful!', 'Zahlung erfolgreich!', 'Paiement réussi!', 'Pagamento riuscito!'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'msg_payment_error', 'error', 'Error en el Pago', 'Payment Error', 'Zahlungsfehler', 'Erreur de Paiement', 'Errore di Pagamento'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'msg_zone_loading', 'message', 'Cargando zonas...', 'Loading zones...', 'Zonen werden geladen...', 'Chargement des zones...', 'Caricamento zone...'),

-- Accesibilidad
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'acc_voice_guide', 'accessibility', 'Guía por Voz', 'Voice Guide', 'Sprachführung', 'Guide Vocal', 'Guida Vocale'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'acc_high_contrast', 'accessibility', 'Contraste Alto', 'High Contrast', 'Hoher Kontrast', 'Contraste Élevé', 'Alto Contrasto'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'acc_large_text', 'accessibility', 'Texto Grande', 'Large Text', 'Großer Text', 'Texte Large', 'Testo Grande'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'acc_dark_mode', 'accessibility', 'Modo Oscuro', 'Dark Mode', 'Dunkler Modus', 'Mode Sombre', 'Modalità Scura'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'acc_simplified_mode', 'accessibility', 'Modo Simplificado', 'Simplified Mode', 'Vereinfachter Modus', 'Mode Simplifié', 'Modalità Semplificata');

-- =====================================================
-- TEXTOS DINÁMICOS PARA EYPSA
-- =====================================================

INSERT INTO ui_texts (company_id, device_id, text_key, text_category, text_es, text_en, text_de, text_fr, text_it) VALUES
-- Botones principales
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_pay_parking', 'button', 'PAGAR ESTACIONAMIENTO', 'PAY PARKING', 'PARKEN BEZAHLEN', 'PAYER LE STATIONNEMENT', 'PAGA PARCHEGGIO'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_cancel_fine', 'button', 'ANULAR DENUNCIA', 'CANCEL FINE', 'STRAFE STORNIEREN', 'ANNULER L''AMENDE', 'ANNULLA MULTA'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_accessibility', 'button', 'ACCESIBILIDAD', 'ACCESSIBILITY', 'BARRIEREFREIHEIT', 'ACCESSIBILITÉ', 'ACCESSIBILITÀ'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_languages', 'button', 'IDIOMAS', 'LANGUAGES', 'SPRACHEN', 'LANGUES', 'LINGUE'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_continue', 'button', 'CONTINUAR', 'CONTINUE', 'WEITER', 'CONTINUER', 'CONTINUA'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_back', 'button', 'VOLVER', 'BACK', 'ZURÜCK', 'RETOUR', 'INDIETRO'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_pay', 'button', 'PAGAR', 'PAY', 'BEZAHLEN', 'PAYER', 'PAGA'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'btn_new_payment', 'button', 'NUEVO PAGO', 'NEW PAYMENT', 'NEUE ZAHLUNG', 'NOUVEAU PAIEMENT', 'NUOVO PAGAMENTO'),

-- Títulos
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'title_welcome', 'title', 'Bienvenido a EYPSA', 'Welcome to EYPSA', 'Willkommen bei EYPSA', 'Bienvenue chez EYPSA', 'Benvenuto a EYPSA'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'title_select_zone', 'title', 'Selecciona tu Zona', 'Select your Zone', 'Wählen Sie Ihre Zone', 'Sélectionnez votre Zone', 'Seleziona la tua Zona'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'title_enter_plate', 'title', 'Introduce tu Matrícula', 'Enter your License Plate', 'Geben Sie Ihr Kennzeichen ein', 'Entrez votre Plaque', 'Inserisci la tua Targa'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'title_select_duration', 'title', 'Selecciona Duración', 'Select Duration', 'Dauer wählen', 'Sélectionner la Durée', 'Seleziona Durata'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'title_payment_method', 'title', 'Método de Pago', 'Payment Method', 'Zahlungsmethode', 'Méthode de Paiement', 'Metodo di Pagamento'),

-- Mensajes
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'msg_payment_success', 'message', '¡Pago Exitoso!', 'Payment Successful!', 'Zahlung erfolgreich!', 'Paiement réussi!', 'Pagamento riuscito!'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'msg_payment_error', 'error', 'Error en el Pago', 'Payment Error', 'Zahlungsfehler', 'Erreur de Paiement', 'Errore di Pagamento'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'msg_zone_loading', 'message', 'Cargando zonas...', 'Loading zones...', 'Zonen werden geladen...', 'Chargement des zones...', 'Caricamento zone...'),

-- Accesibilidad
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'acc_voice_guide', 'accessibility', 'Guía por Voz', 'Voice Guide', 'Sprachführung', 'Guide Vocal', 'Guida Vocale'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'acc_high_contrast', 'accessibility', 'Contraste Alto', 'High Contrast', 'Hoher Kontrast', 'Contraste Élevé', 'Alto Contrasto'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'acc_large_text', 'accessibility', 'Texto Grande', 'Large Text', 'Großer Text', 'Texte Large', 'Testo Grande'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'acc_dark_mode', 'accessibility', 'Modo Oscuro', 'Dark Mode', 'Dunkler Modus', 'Mode Sombre', 'Modalità Scura'),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'acc_simplified_mode', 'accessibility', 'Modo Simplificado', 'Simplified Mode', 'Vereinfachter Modus', 'Mode Simplifié', 'Modalità Semplificata');

-- =====================================================
-- IDIOMAS DISPONIBLES
-- =====================================================

-- Idiomas para MOWIX
INSERT INTO available_languages (company_id, device_id, language_code, language_name, is_default, is_active, display_order) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'es', 'Español', true, true, 1),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'en', 'English', false, true, 2),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'de', 'Deutsch', false, true, 3),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'fr', 'Français', false, true, 4),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'it', 'Italiano', false, true, 5);

-- Idiomas para EYPSA
INSERT INTO available_languages (company_id, device_id, language_code, language_name, is_default, is_active, display_order) VALUES
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'es', 'Español', true, true, 1),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'en', 'English', false, true, 2),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'ca', 'Català', false, true, 3),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'gl', 'Galego', false, true, 4),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'eu', 'Euskera', false, true, 5);

-- =====================================================
-- MÉTODOS DE PAGO
-- =====================================================

-- Métodos de pago para MOWIX
INSERT INTO payment_methods (company_id, device_id, method_code, method_name, method_icon, is_enabled, display_order, requires_contactless, requires_cash_drawer, requires_camera) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'card', 'Tarjeta', 'credit_card', true, 1, true, false, false),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'mobile', 'Móvil', 'phone', true, 2, false, false, true),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'qr', 'QR', 'qr_code', true, 3, false, false, true);

-- Métodos de pago para EYPSA
INSERT INTO payment_methods (company_id, device_id, method_code, method_name, method_icon, is_enabled, display_order, requires_contactless, requires_cash_drawer, requires_camera) VALUES
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'card', 'Tarjeta', 'credit_card', true, 1, true, false, false),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'cash', 'Efectivo', 'money', true, 2, false, true, false),
('b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL, 'mobile', 'Móvil', 'phone', true, 3, false, false, true);

-- =====================================================
-- CONFIGURACIÓN DE ACCESIBILIDAD
-- =====================================================

-- Accesibilidad para MOWIX
INSERT INTO accessibility_configs (
  company_id, device_id,
  tts_enabled, tts_speech_rate, tts_pitch, tts_volume, tts_language,
  high_contrast_enabled, dark_mode_enabled, large_text_enabled, text_scale_factor,
  simplified_mode_enabled, hide_advanced_options,
  extended_time_enabled, time_multiplier,
  voice_navigation_enabled, gesture_navigation_enabled
) VALUES (
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL,
  false, 1.0, 1.0, 1.0, 'es-ES',
  false, false, false, 1.0,
  false, false,
  false, 1.0,
  false, false
);

-- Accesibilidad para EYPSA
INSERT INTO accessibility_configs (
  company_id, device_id,
  tts_enabled, tts_speech_rate, tts_pitch, tts_volume, tts_language,
  high_contrast_enabled, dark_mode_enabled, large_text_enabled, text_scale_factor,
  simplified_mode_enabled, hide_advanced_options,
  extended_time_enabled, time_multiplier,
  voice_navigation_enabled, gesture_navigation_enabled
) VALUES (
  'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL,
  false, 1.0, 1.0, 1.0, 'es-ES',
  false, false, false, 1.0,
  false, false,
  false, 1.0,
  false, false
);

-- =====================================================
-- CONFIGURACIÓN DE IA
-- =====================================================

-- IA para MOWIX
INSERT INTO ai_configs (
  company_id, device_id,
  ai_enabled, learning_enabled,
  zone_recommendations_enabled, payment_recommendations_enabled, duration_recommendations_enabled,
  history_days, min_payments_for_recommendation
) VALUES (
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL,
  true, true,
  true, true, true,
  30, 3
);

-- IA para EYPSA
INSERT INTO ai_configs (
  company_id, device_id,
  ai_enabled, learning_enabled,
  zone_recommendations_enabled, payment_recommendations_enabled, duration_recommendations_enabled,
  history_days, min_payments_for_recommendation
) VALUES (
  'b1ffcd00-0d1c-5fg9-cc7e-7cc0ce381b22', NULL,
  true, true,
  true, true, true,
  30, 3
);
