

#!/bin/bash

# ============================================
# Script Principal - Orquestador
# ============================================
# Este script:
# 1. Carga variables de entorno
# 2. Valida el entorno
# 3. Invoca subprocesos
# 4. Maneja errores

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# FUNCIONES
# ============================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================
# INICIO DEL SCRIPT
# ============================================

log_info "=========================================="
log_info "Iniciando Proceso Principal"
log_info "=========================================="
log_info "Fecha: $(date)"
log_info "Usuario: $(whoami)"
log_info "Hostname: $(hostname)"
log_info "=========================================="
echo ""

# ============================================
# PASO 1: Cargar Variables de Entorno
# ============================================

log_info "PASO 1: Cargando variables de entorno..."

# Buscar var_entorno.sh en múltiples ubicaciones
VAR_ENTORNO_PATHS=(
    "./config/var_entorno.sh"
    "../config/var_entorno.sh"
    "/config/var_entorno.sh"
    "$HOME/config/var_entorno.sh"
)

VAR_ENTORNO_FOUND=false

for path in "${VAR_ENTORNO_PATHS[@]}"; do
    if [ -f "$path" ]; then
        log_success "Archivo encontrado: $path"
        source "$path"
        VAR_ENTORNO_FOUND=true
        break
    fi
done

if [ "$VAR_ENTORNO_FOUND" = false ]; then
    log_warning "Archivo var_entorno.sh no encontrado"
    log_info "Usando variables por defecto..."
    
    # Variables por defecto (para desarrollo)
    export DB_HOST="localhost"
    export DB_PORT="3306"
    export DB_NAME="miapp_db"
    export DB_USER="app_user"
    export DB_PASSWORD="DefaultPass123"
    export API_KEY="sk-test-default"
    export SERVICE_USER="service_test"
    export SERVICE_PASSWORD="ServicePass123"
    export APP_ENVIRONMENT="desarrollo"
    export APP_DEBUG="true"
    export LOG_LEVEL="DEBUG"
fi

echo ""

# ============================================
# PASO 2: Validar Variables Requeridas
# ============================================

log_info "PASO 2: Validando variables requeridas..."

VARIABLES_REQUERIDAS=(
    "DB_HOST"
    "DB_USER"
    "DB_PASSWORD"
    "API_KEY"
    "SERVICE_USER"
    "SERVICE_PASSWORD"
)

VALIDACION_OK=true

for var in "${VARIABLES_REQUERIDAS[@]}"; do
    if [ -z "${!var}" ]; then
        log_error "Variable no definida: $var"
        VALIDACION_OK=false
    else
        # Mostrar variable (ocultando valores sensibles)
        if [[ "$var" == *"PASSWORD"* ]] || [[ "$var" == *"KEY"* ]] || [[ "$var" == *"SECRET"* ]]; then
            log_success "$var: ******* (oculto por seguridad)"
        else
            log_success "$var: ${!var}"
        fi
    fi
done

if [ "$VALIDACION_OK" = false ]; then
    log_error "Validación fallida"
    exit 1
fi

log_success "Todas las variables están configuradas"
echo ""

# ============================================
# PASO 3: Validar Directorios
# ============================================

log_info "PASO 3: Validando directorios..."

# Obtener directorio actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

log_success "Directorio del script: $SCRIPT_DIR"
log_success "Raíz del proyecto: $PROJECT_ROOT"

# Validar que existen los directorios necesarios
DIRS_REQUERIDOS=(
    "$PROJECT_ROOT/scripts_dos/nuevo_dos"
    "$PROJECT_ROOT/data/entrada"
    "$PROJECT_ROOT/data/salida"
)

for dir in "${DIRS_REQUERIDOS[@]}"; do
    if [ ! -d "$dir" ]; then
        log_warning "Creando directorio: $dir"
        mkdir -p "$dir"
    else
        log_success "Directorio existe: $dir"
    fi
done

echo ""

# ============================================
# PASO 4: Validar Archivo de Entrada
# ============================================

log_info "PASO 4: Validando archivo de entrada..."

ARCHIVO_ENTRADA="$PROJECT_ROOT/data/entrada/datos.txt"

if [ ! -f "$ARCHIVO_ENTRADA" ]; then
    log_error "Archivo de entrada no encontrado: $ARCHIVO_ENTRADA"
    exit 1
fi

log_success "Archivo de entrada encontrado"
log_info "Contenido:"
cat "$ARCHIVO_ENTRADA" | sed 's/^/  /'
echo ""

# ============================================
# PASO 5: Validar Subproceso
# ============================================

log_info "PASO 5: Validando subproceso..."

SUBPROCESO="$PROJECT_ROOT/scripts_dos/nuevo_dos/subproceso.sh"

if [ ! -f "$SUBPROCESO" ]; then
    log_error "Subproceso no encontrado: $SUBPROCESO"
    exit 1
fi

if [ ! -x "$SUBPROCESO" ]; then
    log_warning "Dando permisos de ejecución a: $SUBPROCESO"
    chmod +x "$SUBPROCESO"
fi

log_success "Subproceso encontrado y ejecutable"
echo ""

# ============================================
# PASO 6: Ejecutar Subproceso
# ============================================

log_info "PASO 6: Ejecutando subproceso..."
log_info "=========================================="
echo ""

# Exportar variables para que el subproceso las use
export PROJECT_ROOT
export SCRIPT_DIR

# Ejecutar subproceso
if bash "$SUBPROCESO"; then
    log_success "Subproceso completado exitosamente"
else
    log_error "Subproceso falló"
    exit 1
fi

echo ""

# ============================================
# PASO 7: Generar Reporte Final
# ============================================

log_info "PASO 7: Generando reporte final..."

FECHA=$(date +%Y%m%d_%H%M%S)
REPORTE="$PROJECT_ROOT/data/salida/reporte_principal_$FECHA.txt"

cat > "$REPORTE" <<EOF
REPORTE DEL PROCESO PRINCIPAL
==============================
Fecha: $(date)
Usuario: $(whoami)
Hostname: $(hostname)

CONFIGURACIÓN:
- Ambiente: $APP_ENVIRONMENT
- Base de Datos: $DB_HOST:$DB_PORT/$DB_NAME
- Usuario BD: $DB_USER
- API Key: ${API_KEY:0:10}...
- Nivel de Log: $LOG_LEVEL

DIRECTORIOS:
- Script Principal: $SCRIPT_DIR
- Subproceso: $SUBPROCESO
- Entrada: $ARCHIVO_ENTRADA
- Salida: $PROJECT_ROOT/data/salida/

EJECUCIÓN:
- Subproceso: ✅ Completado
- Reporte: ✅ Generado

ESTADO: ✅ ÉXITO
EOF

log_success "Reporte generado: $REPORTE"
echo ""

# ============================================
# FIN DEL SCRIPT
# ============================================

log_info "=========================================="
log_success "Proceso Principal Completado"
log_info "=========================================="
log_info "Archivos generados en: $PROJECT_ROOT/data/salida/"
log_info "=========================================="
