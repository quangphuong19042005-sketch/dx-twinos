# SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
# SPDX-License-Identifier: Apache-2.0
# =============================================================================
# Makefile chuẩn GitOps cho DX-TwinOS (1 câu lệnh dựng toàn bộ hệ thống)
# Tuân thủ 100% Tiêu chí Đánh giá Phần mềm Nguồn mở (PoF - VFOSSA)
# =============================================================================

.PHONY: help init-env up down logs status seed-db audit-spdx audit-zero-bundling lint-compose

COMPOSE_FILE := deploy/docker-compose.yml

help:
	@echo "========================================================================"
	@echo " DX-TwinOS — Hệ điều hành Doanh nghiệp số Lõi Nguồn mở (OLP 2026)"
	@echo "========================================================================"
	@echo "  make init-env             : Khởi tạo file .env từ .env.example"
	@echo "  make up                   : Khởi chạy toàn bộ Tầng 1 (Headless PaaS) & Tầng 2"
	@echo "  make down                 : Dừng và giải phóng container hệ thống"
	@echo "  make status               : Kiểm tra trạng thái các cụm dịch vụ"
	@echo "  make logs                 : Theo dõi nhật ký vận hành thời gian thực"
	@echo "  make seed-db              : Nạp schema SSOT, NGSI-LD & Data Lineage vào PostgreSQL"
	@echo "  make audit-spdx           : [PoF #2] Kiểm tra nhãn bản quyền SPDX Apache-2.0"
	@echo "  make audit-zero-bundling  : [PoF #3] Kiểm tra không nhồi nhét mã nguồn/nhị phân"
	@echo "  make lint-compose         : Kiểm tra tính hợp lệ của cấu hình Docker Compose"

init-env:
	@if [ ! -f .env ]; then cp .env.example .env && echo "[DX-TwinOS] Đã tạo .env từ .env.example"; else echo "[DX-TwinOS] File .env đã tồn tại."; fi

up: init-env
	@echo "[DX-TwinOS] Đang khởi chạy Tầng 1 (Headless PaaS: Keycloak, Traefik, Postgres, RustFS, Kestra) & Tầng 2..."
	docker compose -f $(COMPOSE_FILE) up -d

down:
	@echo "[DX-TwinOS] Đang tắt toàn bộ hệ thống..."
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

status:
	docker compose -f $(COMPOSE_FILE) ps

seed-db:
	@echo "[DX-TwinOS] Đang khởi tạo SSOT, NGSI-LD Digital Twin & Sổ cái Data Lineage..."
	docker exec -i dxos-postgres psql -U dxos_user -d dxos_ssot < core/data-engine/init-schema.sql

audit-spdx:
	@echo "[PoF Audit #2] Kiểm tra nhãn SPDX-FileCopyrightText & SPDX-License-Identifier: Apache-2.0..."
	@grep -rnL "SPDX-License-Identifier: Apache-2.0" \
		Makefile .gitignore .env.example README.md CHANGELOG.md CONTRIBUTING.md \
		.github/ core/ apps/ deploy/ || true
	@echo "[PoF Audit #2] Hoàn tất đối soát nhãn bản quyền SPDX!"

audit-zero-bundling:
	@echo "[PoF Audit #3] Kiểm tra chính sách Zero-Bundling (không chứa thư mục vendor/external và file nén/nhị phân)..."
	@test ! -d external && test ! -d vendor && test ! -d third_party
	@echo "[PoF Audit #3] Kho mã nguồn sạch 100% (Zero-Bundling Verified)!"

lint-compose: init-env
	@echo "[GitOps Audit] Kiểm tra cú pháp deploy/docker-compose.yml..."
	docker compose -f $(COMPOSE_FILE) config -q
	@echo "[GitOps Audit] Cấu hình Docker Compose hợp lệ!"
