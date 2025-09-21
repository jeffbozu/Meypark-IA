# 🔗 MEYPARK IA - Guía de Integración MCP

## 📋 **ÍNDICE**
1. [¿Qué es MCP?](#qué-es-mcp)
2. [Configuración Inicial](#configuración-inicial)
3. [Integración con Cursor](#integración-con-cursor)
4. [Uso del Servidor MCP](#uso-del-servidor-mcp)
5. [Comandos Disponibles](#comandos-disponibles)
6. [Troubleshooting](#troubleshooting)
7. [Mejores Prácticas](#mejores-prácticas)

---

## 🤔 **¿QUÉ ES MCP?**

### **Model Context Protocol (MCP)**
MCP es un protocolo que permite a los clientes de IA (como Cursor) conectarse directamente con bases de datos y servicios externos, proporcionando acceso en tiempo real a datos y funcionalidades.

### **Beneficios para MEYPARK IA**
- ✅ **Acceso directo** a la base de datos Supabase
- ✅ **Consultas en tiempo real** sin necesidad de APIs intermedias
- ✅ **Automatización** de tareas de desarrollo
- ✅ **Integración nativa** con Cursor
- ✅ **Productividad mejorada** en desarrollo

### **Arquitectura MCP**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Cursor      │◄──►│  MCP Server     │◄──►│   Supabase      │
│   (Cliente)     │    │  (Supabase)     │    │   (Backend)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## ⚙️ **CONFIGURACIÓN INICIAL**

### **1. Prerrequisitos**

#### **Software Requerido**
```bash
# Python 3.12+
python3 --version

# pipx (recomendado)
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Supabase CLI
npm install -g supabase
```

#### **Verificación de Instalación**
```bash
# Verificar Python
python3 --version  # Debe ser 3.12+

# Verificar pipx
pipx --version

# Verificar Supabase CLI
supabase --version
```

### **2. Instalación Automática**

#### **Script de Configuración**
```bash
# Ejecutar script de configuración
./infra/scripts/setup_mcp.sh
```

#### **Configuración Manual**
```bash
# Instalar servidor MCP
pipx install supabase-mcp-server

# Configurar variables de entorno
export SUPABASE_PROJECT_REF=edkwlmauywdxbencaucj
export SUPABASE_ACCESS_TOKEN=sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb
export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### **3. Verificación de Instalación**

#### **Comprobar Servidor MCP**
```bash
# Verificar que el servidor está instalado
which supabase-mcp-server

# Verificar versión
supabase-mcp-server --version
```

#### **Comprobar Conexión**
```bash
# Verificar conexión a Supabase
supabase status

# Verificar proyecto vinculado
supabase projects list
```

---

## 🖥️ **INTEGRACIÓN CON CURSOR**

### **1. Configuración de Cursor**

#### **Archivo de Configuración**
```json
// ~/.cursor/mcp_servers.json
{
  "mcpServers": {
    "supabase": {
      "command": "supabase-mcp-server",
      "args": [],
      "env": {
        "SUPABASE_PROJECT_REF": "edkwlmauywdxbencaucj",
        "SUPABASE_ACCESS_TOKEN": "sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb",
        "SUPABASE_SERVICE_ROLE_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      }
    }
  }
}
```

#### **Configuración en Cursor**
1. Abrir Cursor
2. Ir a `Settings` → `Features` → `MCP Servers`
3. Agregar servidor con la configuración anterior
4. Reiniciar Cursor

### **2. Verificación de Integración**

#### **Indicadores de Éxito**
- ✅ **Punto verde** junto al servidor MCP
- ✅ **Número de herramientas** visible
- ✅ **Conexión activa** en la interfaz

#### **Comandos de Verificación**
```bash
# Verificar estado
./infra/scripts/check_mcp.sh

# Iniciar servidor manualmente
./infra/scripts/start_mcp.sh
```

---

## 🚀 **USO DEL SERVIDOR MCP**

### **1. Iniciar Servidor**

#### **Inicio Automático**
```bash
# El servidor se inicia automáticamente con Cursor
# No es necesario iniciarlo manualmente
```

#### **Inicio Manual (Debug)**
```bash
# Iniciar servidor en modo debug
supabase-mcp-server --debug

# Ver logs detallados
supabase-mcp-server --verbose
```

### **2. Comandos Disponibles**

#### **Lista de Herramientas**
El servidor MCP proporciona las siguientes herramientas:

1. **`query_database`** - Ejecutar consultas SQL
2. **`get_table_schema`** - Obtener esquema de tablas
3. **`list_tables`** - Listar todas las tablas
4. **`get_table_data`** - Obtener datos de tablas
5. **`insert_data`** - Insertar datos
6. **`update_data`** - Actualizar datos
7. **`delete_data`** - Eliminar datos
8. **`execute_function`** - Ejecutar funciones Edge
9. **`get_realtime_data`** - Obtener datos en tiempo real
10. **`manage_subscriptions`** - Gestionar suscripciones

### **3. Ejemplos de Uso**

#### **Consultar Base de Datos**
```typescript
// En Cursor, puedes usar:
// "Consulta todos los dispositivos activos"
const devices = await query_database(`
  SELECT d.*, tc.battery, tc.rssi, tc.temp_c
  FROM devices d
  LEFT JOIN telemetry_current tc ON d.id = tc.device_id
  WHERE d.last_seen > NOW() - INTERVAL '1 hour'
  ORDER BY d.last_seen DESC
`);
```

#### **Obtener Esquema de Tabla**
```typescript
// "Obtén el esquema de la tabla tickets"
const schema = await get_table_schema('tickets');
console.log(schema);
```

#### **Insertar Datos**
```typescript
// "Inserta un nuevo dispositivo"
const newDevice = await insert_data('devices', {
  company_id: 'uuid-empresa',
  alias: 'Kiosko Madrid Centro',
  serial: 'KIO-001-MAD',
  timezone: 'Europe/Madrid'
});
```

#### **Ejecutar Edge Function**
```typescript
// "Envía un comando a un dispositivo"
const result = await execute_function('commands', {
  device_id: 'device-uuid',
  action: 'SCREENSHOT',
  payload: { format: 'png' }
});
```

---

## 📋 **COMANDOS DISPONIBLES**

### **1. Gestión de Base de Datos**

#### **`query_database(sql: string)`**
```typescript
// Ejecutar consulta SQL personalizada
const result = await query_database(`
  SELECT 
    c.name as company_name,
    COUNT(d.id) as device_count,
    COUNT(t.id) as active_tickets
  FROM companies c
  LEFT JOIN devices d ON c.id = d.company_id
  LEFT JOIN tickets t ON d.id = t.device_id AND t.status = 'active'
  GROUP BY c.id, c.name
  ORDER BY device_count DESC
`);
```

#### **`get_table_schema(table_name: string)`**
```typescript
// Obtener esquema completo de una tabla
const schema = await get_table_schema('tickets');
// Retorna: columnas, tipos, constraints, índices, etc.
```

#### **`list_tables()`**
```typescript
// Listar todas las tablas de la base de datos
const tables = await list_tables();
// Retorna: array de nombres de tablas
```

### **2. Operaciones CRUD**

#### **`get_table_data(table_name: string, filters?: object)`**
```typescript
// Obtener datos de una tabla con filtros opcionales
const tickets = await get_table_data('tickets', {
  status: 'active',
  company_id: 'uuid-empresa'
});
```

#### **`insert_data(table_name: string, data: object)`**
```typescript
// Insertar datos en una tabla
const newTicket = await insert_data('tickets', {
  company_id: 'uuid-empresa',
  device_id: 'uuid-dispositivo',
  zone_id: 'uuid-zona',
  plate: '1234ABC',
  country: 'ES',
  start_ts: new Date().toISOString(),
  amount_cents: 200
});
```

#### **`update_data(table_name: string, data: object, filters: object)`**
```typescript
// Actualizar datos con filtros
const updated = await update_data('tickets', 
  { status: 'expired' },
  { id: 'uuid-ticket' }
);
```

#### **`delete_data(table_name: string, filters: object)`**
```typescript
// Eliminar datos con filtros
const deleted = await delete_data('tickets', {
  status: 'void',
  created_at: { $lt: '2024-01-01' }
});
```

### **3. Edge Functions**

#### **`execute_function(function_name: string, payload: object)`**
```typescript
// Ejecutar Edge Function
const result = await execute_function('screenshot', {
  device_id: 'uuid-dispositivo',
  format: 'png',
  quality: 80
});
```

### **4. Realtime**

#### **`get_realtime_data(table_name: string)`**
```typescript
// Obtener datos en tiempo real de una tabla
const subscription = await get_realtime_data('telemetry_current');
// Retorna: stream de datos en tiempo real
```

#### **`manage_subscriptions(action: string, table_name: string)`**
```typescript
// Gestionar suscripciones Realtime
await manage_subscriptions('subscribe', 'tickets');
await manage_subscriptions('unsubscribe', 'tickets');
```

---

## 🔧 **TROUBLESHOOTING**

### **1. Problemas Comunes**

#### **Error: "No tools found"**
```bash
# Verificar instalación del servidor
which supabase-mcp-server

# Verificar variables de entorno
echo $SUPABASE_PROJECT_REF
echo $SUPABASE_ACCESS_TOKEN

# Reinstalar servidor
pipx uninstall supabase-mcp-server
pipx install supabase-mcp-server
```

#### **Error: "Connection failed"**
```bash
# Verificar conexión a Supabase
supabase status

# Verificar proyecto vinculado
supabase projects list

# Re-vincular proyecto
supabase link --project-ref edkwlmauywdxbencaucj
```

#### **Error: "Permission denied"**
```bash
# Verificar permisos del archivo de configuración
chmod 600 ~/.cursor/mcp_servers.json

# Verificar variables de entorno
export SUPABASE_SERVICE_ROLE_KEY="tu-service-role-key"
```

### **2. Logs y Debugging**

#### **Ver Logs del Servidor**
```bash
# Logs en Windows
Get-Content "$env:USERPROFILE\.local\share\supabase-mcp\mcp_server.log"

# Logs en Linux/Mac
tail -f ~/.local/share/supabase-mcp/mcp_server.log
```

#### **Modo Debug**
```bash
# Iniciar servidor en modo debug
supabase-mcp-server --debug --verbose

# Ver todas las herramientas disponibles
supabase-mcp-server --list-tools
```

### **3. Solución de Problemas de Cursor**

#### **Reiniciar Cursor**
```bash
# Cerrar Cursor completamente
# Eliminar archivo de configuración temporal
rm ~/.cursor/mcp_servers.json

# Recrear configuración
./infra/scripts/setup_mcp.sh

# Reiniciar Cursor
```

#### **Verificar Configuración**
```bash
# Verificar archivo de configuración
cat ~/.cursor/mcp_servers.json

# Verificar que el servidor está en PATH
which supabase-mcp-server
```

---

## 🎯 **MEJORES PRÁCTICAS**

### **1. Uso Eficiente**

#### **Consultas Optimizadas**
```typescript
// ✅ Bueno: Consulta específica con filtros
const activeTickets = await query_database(`
  SELECT t.*, d.alias, z.name as zone_name
  FROM tickets t
  JOIN devices d ON t.device_id = d.id
  JOIN zones z ON t.zone_id = z.id
  WHERE t.status = 'active'
  AND t.company_id = $1
`, [companyId]);

// ❌ Malo: Consulta sin filtros
const allTickets = await query_database('SELECT * FROM tickets');
```

#### **Manejo de Errores**
```typescript
// ✅ Bueno: Manejo de errores
try {
  const result = await query_database(sql);
  return { success: true, data: result };
} catch (error) {
  console.error('Error en consulta:', error);
  return { success: false, error: error.message };
}

// ❌ Malo: Sin manejo de errores
const result = await query_database(sql);
```

### **2. Seguridad**

#### **Validación de Entradas**
```typescript
// ✅ Bueno: Validar entradas
function validateDeviceId(deviceId: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(deviceId);
}

if (!validateDeviceId(deviceId)) {
  throw new Error('ID de dispositivo inválido');
}

// ❌ Malo: Sin validación
const result = await query_database(`SELECT * FROM devices WHERE id = '${deviceId}'`);
```

#### **Uso de Parámetros**
```typescript
// ✅ Bueno: Usar parámetros preparados
const result = await query_database(
  'SELECT * FROM tickets WHERE company_id = $1 AND status = $2',
  [companyId, status]
);

// ❌ Malo: Concatenación de strings
const result = await query_database(
  `SELECT * FROM tickets WHERE company_id = '${companyId}' AND status = '${status}'`
);
```

### **3. Performance**

#### **Límites de Consultas**
```typescript
// ✅ Bueno: Limitar resultados
const recentTickets = await query_database(`
  SELECT * FROM tickets 
  WHERE created_at > NOW() - INTERVAL '24 hours'
  ORDER BY created_at DESC
  LIMIT 100
`);

// ❌ Malo: Sin límites
const allTickets = await query_database('SELECT * FROM tickets');
```

#### **Índices Apropiados**
```sql
-- ✅ Bueno: Usar índices existentes
SELECT * FROM tickets 
WHERE company_id = 'uuid' AND status = 'active'
ORDER BY created_at DESC;

-- ❌ Malo: Consulta sin índices
SELECT * FROM tickets 
WHERE plate LIKE '%ABC%'
ORDER BY amount_cents;
```

---

## 📚 **RECURSOS ADICIONALES**

### **Documentación Oficial**
- [Supabase MCP Server](https://github.com/LucasBurriel/supabase-mcp-installation-guide)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Supabase CLI](https://supabase.com/docs/reference/cli)

### **Comunidad**
- [Supabase Discord](https://discord.supabase.com)
- [Cursor Community](https://cursor.sh/community)
- [MCP Community](https://github.com/modelcontextprotocol)

### **Herramientas Relacionadas**
- [Supabase Dashboard](https://supabase.com/dashboard)
- [Cursor IDE](https://cursor.sh/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

---

## 🎉 **CONCLUSIÓN**

### **✅ Beneficios Obtenidos**

1. **🔗 Integración Directa**: Acceso nativo a Supabase desde Cursor
2. **⚡ Productividad**: Consultas y operaciones automatizadas
3. **🛠️ Desarrollo Eficiente**: Herramientas integradas en el IDE
4. **📊 Monitoreo**: Acceso en tiempo real a datos
5. **🔒 Seguridad**: Autenticación y autorización integradas

### **🚀 Próximos Pasos**

1. **Explorar Herramientas**: Probar todos los comandos disponibles
2. **Automatizar Tareas**: Crear scripts para operaciones comunes
3. **Integrar en Workflow**: Incorporar MCP en el flujo de desarrollo
4. **Monitorear Performance**: Optimizar consultas y operaciones

---

**🎯 ¡MCP configurado y listo para usar en MEYPARK IA!**

*Última actualización: 21 de Septiembre de 2025*
