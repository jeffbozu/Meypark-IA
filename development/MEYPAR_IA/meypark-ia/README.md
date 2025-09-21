# MEYPARK IA - Sistema de Gestión de Estacionamiento

Sistema completo de gestión de estacionamiento con kioskos táctiles, panel de administración, facturación web y portal de inspectores.

## 🏗️ Arquitectura

- **Kiosko Flutter**: Aplicación táctil para pantallas de 10"
- **Panel Web**: Dashboard de administración (Next.js)
- **Facturación Web**: Página pública de facturas (Flutter Web)
- **Portal Inspector**: Web móvil para inspectores (Next.js)
- **Backend**: Supabase Cloud (Postgres + RLS + Realtime + Edge Functions)

## 🚀 Inicio Rápido

### Prerrequisitos
- Node.js 18+
- Flutter SDK 3.0+
- Supabase CLI
- Acceso al proyecto Supabase: `edkwlmauywdxbencaucj`

### Setup del Proyecto

1. **Clonar y configurar**
```bash
git clone <repo-url>
cd meypark-ia
```

2. **Configurar Supabase**
```bash
supabase login
supabase link --project-ref edkwlmauywdxbencaucj
```

3. **Aplicar migraciones**
```bash
supabase db push
```

4. **Generar tipos**
```bash
supabase gen types typescript --project-id edkwlmauywdxbencaucj > packages/shared_core/src/supabase.types.ts
supabase gen types dart --project-id edkwlmauywdxbencaucj > packages/shared_core/lib/supabase_types.dart
```

## 📁 Estructura del Proyecto

```
meypark-ia/
├─ apps/                    # Aplicaciones
│  ├─ kiosk_flutter/       # Kiosko táctil
│  ├─ dashboard_web/       # Panel de administración
│  ├─ billing_web/         # Facturación web
│  └─ inspector_web/       # Portal de inspectores
├─ packages/
│  └─ shared_core/         # Tipos y utilidades compartidas
└─ infra/                  # Configuración de infraestructura
```

## 🔧 Scripts Disponibles

- `supabase db push` - Aplicar migraciones a Supabase
- `supabase gen types` - Generar tipos TypeScript/Dart
- `supabase functions deploy` - Desplegar Edge Functions

## 📚 Documentación

- [Fase 1: Fundación Backend](prompts/FASE_01_FUNDACION.md)
- [Arquitectura del Sistema](prompts/prompt_modulos/01_arquitectura.md)
- [Diseño UI/UX](prompts/prompt_modulos/02_ui_ux.md)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
