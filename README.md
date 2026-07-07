# POC - Script Principal + Subshells + Variables Seguras

Prueba de concepto avanzada: Script principal que invoca subshells con gestión segura de variables de entorno.

## Descripción

Este proyecto demuestra:
- ✅ Script principal que orquesta el proceso
- ✅ Subshells en directorios diferentes
- ✅ Gestión segura de variables de entorno
- ✅ Manejo de secretos con GitHub Actions
- ✅ Ejecución programada (cron)
- ✅ Validación y manejo de errores

## Estructura
prueba_dos_rutas_scripts/
├── .github/
│ └── workflows/
│ └── ejecutar-proceso.yml
├── scripts/
│ └── proceso_principal.sh
├── scripts_dos/
│ └── nuevo_dos/
│ └── subproceso.sh
├── config/
│ └── var_entorno.sh (NO en repo)
├── data/
│ ├── entrada/
│ │ └── datos.txt
│ └── salida/
├── logs/
├── .gitignore
└── README.md


## Flujo de Ejecución
GitHub Actions / Cron
↓
ejecutar-proceso.yml (Workflow)
↓
proceso_principal.sh (Script Principal)
├─ Carga var_entorno.sh
├─ Valida variables
├─ Valida directorios
└─ Invoca subproceso.sh
↓
subproceso.sh (Subshell)
├─ Usa variables heredadas
├─ Lee datos de entrada
├─ Procesa datos
└─ Genera resultados


## Cómo Funciona
### Variables de Entorno

El archivo `config/var_entorno.sh` contiene:
- Credenciales de base de datos
- API Keys
- Credenciales de servicio
- Configuración de aplicación

**Importante:** Este archivo NO está en el repositorio por seguridad.

### Script Principal

`scripts/proceso_principal.sh`:
1. Carga variables de entorno
2. Valida que todas las variables existen
3. Valida directorios
4. Invoca el subproceso
5. Genera reporte final

### Subproceso

`scripts_dos/nuevo_dos/subproceso.sh`:
1. Recibe variables del script principal
2. Lee archivo de entrada
3. Procesa datos
4. Genera archivo de salida

## Ejecución Manual

### Opción 1: Desde Codespaces

```bash
# Abrir Codespaces
# En la terminal:

chmod +x scripts/proceso_principal.sh
chmod +x scripts_dos/nuevo_dos/subproceso.sh

./scripts/proceso_principal.sh

