# 🚫 Cómo Deshabilitar Zonas en Supabase

## 📋 **Método 1: Desde el Dashboard de Supabase**

### 1. **Acceder al Dashboard**
- Ve a: https://supabase.com/dashboard
- Selecciona tu proyecto: `meypark-ia`

### 2. **Navegar a la Tabla**
- Ve a **Table Editor** en el menú lateral
- Busca la tabla: `parking_zones`

### 3. **Deshabilitar Zonas**
- Haz clic en la fila de la zona que quieres deshabilitar
- Cambia el campo `is_active` de `true` a `false`
- Haz clic en **Save** para guardar

## 🗄️ **Método 2: Usando SQL Directamente**

### 1. **Acceder al SQL Editor**
- Ve a **SQL Editor** en el dashboard
- Crea una nueva consulta

### 2. **Comandos SQL para Deshabilitar**

```sql
-- Deshabilitar una zona específica por ID
UPDATE parking_zones 
SET is_active = false 
WHERE id = 'uuid-de-la-zona';

-- Deshabilitar una zona por código
UPDATE parking_zones 
SET is_active = false 
WHERE zone_code = 'zone_001';

-- Deshabilitar múltiples zonas
UPDATE parking_zones 
SET is_active = false 
WHERE zone_code IN ('zone_002', 'zone_003', 'zone_004');

-- Deshabilitar todas las zonas de un tipo específico
UPDATE parking_zones 
SET is_active = false 
WHERE name LIKE '%Turística%';
```

### 3. **Verificar Cambios**
```sql
-- Ver todas las zonas activas
SELECT zone_code, name, is_active 
FROM parking_zones 
WHERE is_active = true;

-- Ver todas las zonas deshabilitadas
SELECT zone_code, name, is_active 
FROM parking_zones 
WHERE is_active = false;
```

## 🔄 **Método 3: Usando la Aplicación Flutter**

### 1. **Acceder al Modo Técnico**
- Mantén presionado el logo por 3 segundos
- Introduce la contraseña: `admin123`

### 2. **Gestionar Zonas**
- Ve a la sección de **Gestión de Zonas**
- Selecciona las zonas que quieres deshabilitar
- Cambia el estado a **Inactivo**

## 📊 **Zonas Actuales en el Sistema**

| Código | Nombre | Estado | Descripción |
|--------|--------|--------|-------------|
| zone_001 | Zona Centro | ✅ Activa | Centro de la ciudad |
| zone_002 | Zona Comercial | ✅ Activa | Áreas comerciales |
| zone_003 | Zona Residencial | ✅ Activa | Para residentes |
| zone_004 | Zona Turística | ✅ Activa | Para turistas |
| zone_005 | Zona Hospital | ✅ Activa | Hospitales y clínicas |
| zone_006 | Zona Universidad | ✅ Activa | Campus universitarios |

## ⚠️ **Consideraciones Importantes**

### **Antes de Deshabilitar:**
1. **Verificar transacciones activas** - No deshabilitar zonas con pagos en curso
2. **Notificar a usuarios** - Avisar sobre cambios en disponibilidad
3. **Backup de datos** - Hacer respaldo antes de cambios masivos

### **Después de Deshabilitar:**
1. **Verificar en la app** - Comprobar que las zonas no aparecen
2. **Actualizar documentación** - Registrar cambios realizados
3. **Monitorear sistema** - Verificar que no hay errores

## 🔧 **Reactivar Zonas**

```sql
-- Reactivar una zona específica
UPDATE parking_zones 
SET is_active = true 
WHERE zone_code = 'zone_001';

-- Reactivar todas las zonas
UPDATE parking_zones 
SET is_active = true;
```

## 📱 **Verificación en la App**

### **Pantalla de Zonas:**
- Las zonas deshabilitadas (`is_active = false`) **NO aparecerán** en la lista
- Solo se mostrarán las zonas activas
- El filtro se aplica automáticamente en el provider

### **Código del Provider:**
```dart
// En supabase_providers.dart
.eq('is_active', true)  // Solo zonas activas
```

## 🚨 **Solución de Problemas**

### **Si una zona sigue apareciendo:**
1. Verificar que `is_active = false` en la base de datos
2. Reiniciar la aplicación Flutter
3. Verificar la conexión a Supabase

### **Si hay errores de conexión:**
1. Verificar las credenciales de Supabase
2. Comprobar la URL y clave en `env.dart`
3. Revisar los logs de la aplicación

## 📞 **Soporte**

Si necesitas ayuda adicional:
- **Documentación**: Ver archivos en `/docs/`
- **Logs**: Revisar `flutter logs`
- **Base de datos**: Verificar en Supabase Dashboard
