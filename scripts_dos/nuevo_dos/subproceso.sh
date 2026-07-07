#!/bin/bash

# ============================================
# Subproceso - Procesamiento de Datos
# ============================================
# Este script:
# 1. Usa variables del proceso principal
# 2. Procesa datos
# 3. Genera resultados

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}  ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}  ✅ $1${NC}"
}

# ============================================
# INICIO DEL SUBPROCESO
# ============================================

log_info "=========================================="
log_info "Iniciando Subproceso"
log_info "=========================================="
log_info "Fecha: $(date)"
log_info "Directorio: $(pwd)"
log_info "=========================================="
echo ""

# ============================================
# PASO 1: Validar Variables Heredadas
# ============================================

log_info "PASO 1: Validando variables heredadas..."

if [ -z "$PROJECT_ROOT" ]; then
    log_info "PROJECT_ROOT no definido, usando directorio actual"
    PROJECT_ROOT="$(pwd)/../.."
fi

if [ -z "$DB_USER" ]; then
    log_info "DB_USER no definido, usando valor por defecto"
    DB_USER="app_user"
fi

log_success "PROJECT_ROOT: $PROJECT_ROOT"
log_success "DB_USER: $DB_USER"
log_success "API_KEY: ${API_KEY:0:10}... (oculto)"
echo ""

# ============================================
# PASO 2: Leer Archivo de Entrada
# ============================================

log_info "PASO 2: Leyendo archivo de entrada..."

ARCHIVO_ENTRADA="$PROJECT_ROOT/data/entrada/datos.txt"

if [ ! -f "$ARCHIVO_ENTRADA" ]; then
    echo "❌ Archivo no encontrado: $ARCHIVO_ENTRADA"
    exit 1
fi

CONTENIDO_ENTRADA=$(cat "$ARCHIVO_ENTRADA")
LINEAS=$(wc -l < "$ARCHIVO_ENTRADA")
CARACTERES=$(wc -c < "$ARCHIVO_ENTRADA")
PALABRAS=$(wc -w < "$ARCHIVO_ENTRADA")

log_success "Archivo leído correctamente"
log_info "Líneas: $LINEAS"
log_info "Caracteres: $CARACTERES"
log_info "Palabras: $PALABRAS"
echo ""

# ============================================
# PASO 3: Procesar Datos
#
