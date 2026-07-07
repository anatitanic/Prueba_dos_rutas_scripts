#!/bin/bash

# ============================================
# Variables de Entorno - CONFIDENCIAL
# ============================================
# ⚠️ IMPORTANTE: Este archivo NO debe estar en el repositorio
# Agregar a .gitignore

# Base de Datos
export DB_HOST="localhost"
export DB_PORT="3306"
export DB_NAME="miapp_db"
export DB_USER="app_user"
export DB_PASSWORD="SecurePass123!@#"

# API Keys
export API_KEY="sk-prod-1234567890abcdefghijklmnop"
export API_SECRET="secret-key-xyz789"

# Credenciales de Servicio
export SERVICE_USER="service_account"
export SERVICE_PASSWORD="ServicePass456!@#"

# Configuración de Aplicación
export APP_ENVIRONMENT="produccion"
export APP_DEBUG="false"
export LOG_LEVEL="INFO"

# Rutas
export SCRIPTS_DIR="/scripts"
export SCRIPTS_DOS_DIR="/scripts_dos/nuevo_dos"
export DATA_INPUT="/data/entrada"
export DATA_OUTPUT="/data/salida"
export LOG_DIR="/logs"

# Validar que todas las variables están configuradas
echo "✅ Variables de entorno cargadas"


