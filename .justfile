# SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
# SPDX-License-Identifier: Apache-2.0
# ============================================================================
# DX-TwinOS — Enterprise Digital Transformation Operating System (OLP 2026)
# Task Runner (.justfile) - Windows PowerShell & Cross-Platform Compatible
# Inspired by HUTECH OLP Reference Standard (UrbanReflex)
# ============================================================================

set shell := ["powershell.exe", "-c"]

COMPOSE_FILE := "deploy/docker-compose.yml"
ENV_FILE     := ".env"

# Default recipe - show available commands
default:
    @just --list

# ============================================================================
# 1. ONE-COMMAND SETUP & ENVIRONMENT
# ============================================================================

# Initialize .env from .env.example (One-Command Setup)
setup-env:
    @if (!(Test-Path {{ENV_FILE}})) { Copy-Item .env.example {{ENV_FILE}}; Write-Host "[DX-TwinOS] Created .env from .env.example" -ForegroundColor Green } else { Write-Host "[DX-TwinOS] .env already exists" -ForegroundColor Cyan }

# Install Python dependencies for Tier-2 Agent Brain (via uv or pip)
install: setup-env
    @Write-Host "[DX-TwinOS] Installing Tier-2 Agent Brain dependencies..." -ForegroundColor Cyan
    pip install -r apps/agent-brain/requirements.txt

# ============================================================================
# 2. FULL SYSTEM ORCHESTRATION (TIER 1 HEADLESS PAAS + TIER 2 H-P-D-I)
# ============================================================================

# Start all Tier-1 Headless PaaS services (Traefik, Keycloak, Postgres, RustFS, Kestra)
dev: setup-env
    @Write-Host "Starting DX-TwinOS Tier-1 Headless PaaS with Docker Compose..." -ForegroundColor Green
    docker compose --env-file {{ENV_FILE}} -f {{COMPOSE_FILE}} up -d
    @Write-Host ""
    @Write-Host "Active Tier-1 Core Services (Headless PaaS):" -ForegroundColor Cyan
    @Write-Host "  - dxos-gateway   (Traefik API Gateway :8000)"
    @Write-Host "  - dxos-keycloak  (Unified OIDC/RBAC Identity)"
    @Write-Host "  - dxos-postgres  (PostgreSQL 16 SSOT + NGSI-LD + Lineage)"
    @Write-Host "  - dxos-rustfs    (RustFS S3 Object Storage - P.A.R.A)"
    @Write-Host "  - dxos-kestra    (Kestra Declarative Workflow Engine)"

# Alias for `just dev` (matches `make up`)
up: dev

# Stop all running containers
down:
    @Write-Host "Stopping DX-TwinOS services..." -ForegroundColor Yellow
    docker compose -f {{COMPOSE_FILE}} down

# Check container status
status:
    docker compose -f {{COMPOSE_FILE}} ps

# Stream real-time container logs
logs:
    docker compose -f {{COMPOSE_FILE}} logs -f

# ============================================================================
# 3. DATABASE & TIER-2 APPLICATION COMMANDS
# ============================================================================

# Seed SSOT, NGSI-LD Digital Twin & Data Lineage Ledger schema into PostgreSQL
seed-db:
    @Write-Host "Seeding SSOT, NGSI-LD & Data Lineage schema into dxos-postgres..." -ForegroundColor Cyan
    Get-Content core/data-engine/init-schema.sql | docker exec -i dxos-postgres psql -U dxos_user -d dxos_ssot

# Run Tier-2 Multi-Agent Brain API server locally (FastAPI port 8080)
agent-dev:
    uvicorn apps.agent-brain.main:app --reload --port 8080

# Open Tier-2 H-P-D-I Live Interactive Cockpit in browser
cockpit:
    Start-Process "apps/web-portal/index.html"

# ============================================================================
# 4. VFOSSA PoF COMPLIANCE & GITOPS AUDITS (50/50 POINTS)
# ============================================================================

# Validate Docker Compose syntax and environment interpolation
lint-compose: setup-env
    docker compose --env-file {{ENV_FILE}} -f {{COMPOSE_FILE}} config -q
    @Write-Host "[GitOps Audit] deploy/docker-compose.yml is 100% valid!" -ForegroundColor Green

# Audit SPDX Apache-2.0 license headers across all repository files
audit-spdx:
    @Write-Host "[PoF Criterion #2] Auditing SPDX-License-Identifier: Apache-2.0 headers..." -ForegroundColor Cyan
    @Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Name -notin @('LICENSE', 'NOTICE') } | ForEach-Object { if (!(Select-String -Path $_.FullName -Pattern "SPDX-License-Identifier: Apache-2.0" -Quiet)) { Write-Error "Missing SPDX header: $($_.FullName)"; exit 1 } }
    @Write-Host "[PoF Criterion #2] 100% files contain valid SPDX Apache-2.0 headers!" -ForegroundColor Green

# Verify Zero-Bundling policy (no vendor/external folders or binary artifacts)
audit-zero-bundling:
    @Write-Host "[PoF Criterion #5] Auditing Zero-Bundling policy..." -ForegroundColor Cyan
    @if ((Test-Path external) -or (Test-Path vendor) -or (Test-Path third_party)) { Write-Error "Zero-Bundling violation!"; exit 1 }
    @Write-Host "[PoF Criterion #5] Zero-Bundling verified!" -ForegroundColor Green
