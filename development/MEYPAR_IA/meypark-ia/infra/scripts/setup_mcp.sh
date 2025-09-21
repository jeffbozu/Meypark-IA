#!/bin/bash

# 🚀 MEYPARK IA - Setup MCP (Model Context Protocol)
# Configuración automática del servidor MCP de Supabase

set -e

echo "🚀 Configurando MCP (Model Context Protocol) para MEYPARK IA..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar prerrequisitos
check_prerequisites() {
    print_status "Verificando prerrequisitos..."
    
    # Verificar Python 3.12+
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
        if [ "$(echo "$PYTHON_VERSION >= 3.12" | bc -l)" -eq 1 ]; then
            print_success "Python $PYTHON_VERSION encontrado"
        else
            print_error "Python 3.12+ requerido. Versión actual: $PYTHON_VERSION"
            exit 1
        fi
    else
        print_error "Python 3 no encontrado. Instalando..."
        sudo apt update
        sudo apt install -y python3.12 python3.12-venv python3.12-pip
    fi
    
    # Verificar pipx
    if command -v pipx >/dev/null 2>&1; then
        print_success "pipx encontrado"
    else
        print_status "Instalando pipx..."
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Verificar Supabase CLI
    if command -v supabase >/dev/null 2>&1; then
        print_success "Supabase CLI encontrado"
    else
        print_error "Supabase CLI no encontrado. Instalando..."
        npm install -g supabase
    fi
}

# Instalar servidor MCP de Supabase
install_mcp_server() {
    print_status "Instalando servidor MCP de Supabase..."
    
    # Instalar usando pipx
    pipx install supabase-mcp-server
    
    print_success "Servidor MCP instalado correctamente"
}

# Configurar variables de entorno
setup_environment() {
    print_status "Configurando variables de entorno..."
    
    # Crear directorio de configuración
    MCP_CONFIG_DIR="$HOME/.config/supabase-mcp"
    mkdir -p "$MCP_CONFIG_DIR"
    
    # Crear archivo .env si no existe
    ENV_FILE="$MCP_CONFIG_DIR/.env"
    if [ ! -f "$ENV_FILE" ]; then
        cat > "$ENV_FILE" << EOF
# MEYPARK IA - MCP Configuration
SUPABASE_PROJECT_REF=edkwlmauywdxbencaucj
SUPABASE_DB_PASSWORD=your_db_password_here
SUPABASE_REGION=us-east-1
SUPABASE_ACCESS_TOKEN=sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVka3dsbWF1eXdkeGJlbmNhdWNqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODQwMzc4MCwiZXhwIjoyMDczOTc5NzgwfQ.VNYYc3FIZ5_cMbwwJWiDN5U4B5b7lYf5BtCss_Zt7BM
EOF
        print_warning "Archivo .env creado en $ENV_FILE"
        print_warning "Por favor, actualiza SUPABASE_DB_PASSWORD con tu contraseña real"
    else
        print_success "Archivo .env ya existe"
    fi
    
    # Exportar variables para la sesión actual
    export SUPABASE_PROJECT_REF=edkwlmauywdxbencaucj
    export SUPABASE_ACCESS_TOKEN=sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb
    export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVka3dsbWF1eXdkeGJlbmNhdWNqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODQwMzc4MCwiZXhwIjoyMDczOTc5NzgwfQ.VNYYc3FIZ5_cMbwwJWiDN5U4B5b7lYf5BtCss_Zt7BM
}

# Configurar Cursor
setup_cursor() {
    print_status "Configurando integración con Cursor..."
    
    # Crear archivo de configuración para Cursor
    CURSOR_CONFIG_DIR="$HOME/.cursor"
    mkdir -p "$CURSOR_CONFIG_DIR"
    
    # Crear archivo de configuración MCP
    MCP_CONFIG_FILE="$CURSOR_CONFIG_DIR/mcp_servers.json"
    cat > "$MCP_CONFIG_FILE" << EOF
{
  "mcpServers": {
    "supabase": {
      "command": "supabase-mcp-server",
      "args": [],
      "env": {
        "SUPABASE_PROJECT_REF": "edkwlmauywdxbencaucj",
        "SUPABASE_ACCESS_TOKEN": "sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb",
        "SUPABASE_SERVICE_ROLE_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVka3dsbWF1eXdkeGJlbmNhdWNqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODQwMzc4MCwiZXhwIjoyMDczOTc5NzgwfQ.VNYYc3FIZ5_cMbwwJWiDN5U4B5b7lYf5BtCss_Zt7BM"
      }
    }
  }
}
EOF
    
    print_success "Configuración de Cursor creada en $MCP_CONFIG_FILE"
    print_warning "Reinicia Cursor para aplicar la configuración"
}

# Verificar instalación
verify_installation() {
    print_status "Verificando instalación..."
    
    # Verificar servidor MCP
    if command -v supabase-mcp-server >/dev/null 2>&1; then
        print_success "Servidor MCP disponible"
    else
        print_error "Servidor MCP no encontrado"
        exit 1
    fi
    
    # Verificar conexión a Supabase
    if supabase status >/dev/null 2>&1; then
        print_success "Conexión a Supabase verificada"
    else
        print_warning "No se pudo verificar conexión a Supabase"
        print_warning "Ejecuta 'supabase login' y 'supabase link --project-ref edkwlmauywdxbencaucj'"
    fi
}

# Crear scripts de utilidad
create_utility_scripts() {
    print_status "Creando scripts de utilidad..."
    
    # Script para iniciar servidor MCP
    cat > "infra/scripts/start_mcp.sh" << 'EOF'
#!/bin/bash
# Iniciar servidor MCP de Supabase

export SUPABASE_PROJECT_REF=edkwlmauywdxbencaucj
export SUPABASE_ACCESS_TOKEN=sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb
export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVka3dsbWF1eXdkeGJlbmNhdWNqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODQwMzc4MCwiZXhwIjoyMDczOTc5NzgwfQ.VNYYc3FIZ5_cMbwwJWiDN5U4B5b7lYf5BtCss_Zt7BM

echo "🚀 Iniciando servidor MCP de Supabase..."
supabase-mcp-server
EOF
    
    chmod +x "infra/scripts/start_mcp.sh"
    
    # Script para verificar estado
    cat > "infra/scripts/check_mcp.sh" << 'EOF'
#!/bin/bash
# Verificar estado del servidor MCP

echo "🔍 Verificando estado del servidor MCP..."

# Verificar si el servidor está instalado
if command -v supabase-mcp-server >/dev/null 2>&1; then
    echo "✅ Servidor MCP instalado"
else
    echo "❌ Servidor MCP no instalado"
    exit 1
fi

# Verificar variables de entorno
if [ -n "$SUPABASE_PROJECT_REF" ]; then
    echo "✅ SUPABASE_PROJECT_REF configurado"
else
    echo "❌ SUPABASE_PROJECT_REF no configurado"
fi

if [ -n "$SUPABASE_ACCESS_TOKEN" ]; then
    echo "✅ SUPABASE_ACCESS_TOKEN configurado"
else
    echo "❌ SUPABASE_ACCESS_TOKEN no configurado"
fi

# Verificar conexión a Supabase
if supabase status >/dev/null 2>&1; then
    echo "✅ Conexión a Supabase verificada"
else
    echo "❌ No se pudo conectar a Supabase"
fi

echo "🎉 Verificación completada"
EOF
    
    chmod +x "infra/scripts/check_mcp.sh"
    
    print_success "Scripts de utilidad creados"
}

# Mostrar instrucciones de uso
show_usage_instructions() {
    print_success "¡Configuración MCP completada!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Reinicia Cursor para aplicar la configuración MCP"
    echo "2. Verifica la conexión: ./infra/scripts/check_mcp.sh"
    echo "3. Inicia el servidor: ./infra/scripts/start_mcp.sh"
    echo ""
    echo "🔧 Configuración:"
    echo "- Archivo de configuración: ~/.config/supabase-mcp/.env"
    echo "- Configuración de Cursor: ~/.cursor/mcp_servers.json"
    echo ""
    echo "📚 Documentación:"
    echo "- Guía MCP: docs/MCP_INTEGRATION_GUIDE.md"
    echo "- Troubleshooting: docs/TROUBLESHOOTING.md"
    echo ""
    echo "🎉 ¡MCP configurado correctamente para MEYPARK IA!"
}

# Función principal
main() {
    echo "🏗️ MEYPARK IA - Setup MCP (Model Context Protocol)"
    echo "=================================================="
    echo ""
    
    check_prerequisites
    install_mcp_server
    setup_environment
    setup_cursor
    verify_installation
    create_utility_scripts
    show_usage_instructions
}

# Ejecutar función principal
main "$@"
