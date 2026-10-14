<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# DX-TwinOS — Hệ điều hành Doanh nghiệp số Lõi Nguồn mở (OLP 2026)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![OSI Approved](https://img.shields.io/badge/OSI-100%25_Approved-success.svg)](https://opensource.org/licenses)
[![PoF Compliance](https://img.shields.io/badge/VFOSSA_PoF-50%2F50_Compliant-brightgreen.svg)](./.github/workflows/pof-compliance.yml)
[![Architecture](https://img.shields.io/badge/DX--OS-3--Tier_Headless_PaaS-purple.svg)](#1-kiến-trúc-tháp-3-tầng-3-tier-dx-os)

> **Tuyên ngôn Kiến trúc:** Không ghép nối rời rạc (**Zero Silos**) — Không nhồi nhét mã nguồn bên thứ 3 (**Zero Bundling**) — 100% Giấy phép Nguồn mở chuẩn OSI (**Apache-2.0**).

---

## 1. Kiến trúc Tháp 3 Tầng (3-Tier DX-OS)

* **Tầng 1 — Hạ tầng Lõi Nguồn mở (`core/` & `deploy/`):** Chạy ngầm 100% (**Headless PaaS**), tuyệt đối không mở giao diện quản trị rời rạc cho người dùng cuối:
  1. **Định danh & SSO (`core/identity-keycloak/`):** `Keycloak 26` (`Apache-2.0`) — Cấp phát JWT & RBAC hợp nhất cho cả Con người và Tác tử AI (`ai_agent_service`).
  2. **Cổng giao tiếp API (`core/gateway-traefik/`):** `Traefik Proxy v3.1` (`MIT`) — Chốt chặn Zero-Trust duy nhất tại cổng `:8000`, tự động xác thực JWT qua middleware.
  3. **Lưu trữ Kép (`core/data-engine/`):**
     - `PostgreSQL 16` (`PostgreSQL License`): Lưu trữ giao dịch **Single Source of Truth (SSOT)**, thực thể số chuẩn quốc tế **ETSI NGSI-LD** (Hội tụ IT/OT), và sổ cái bất biến **`data_lineage_ledger`**.
     - `RustFS` (`Apache-2.0`): Kho lưu trữ đối tượng S3 tốc độ cao bằng Rust (thay thế MinIO `AGPLv3`), phân vùng theo cấu trúc tri thức **P.A.R.A** (`projects/`, `areas/`, `resources/`, `archives/`).
  4. **Động cơ Quy trình (`core/workflow-kestra/`):** `Kestra` (`Apache-2.0`) — Điều phối quy trình khai báo bằng YAML (thay thế n8n *Sustainable Use License*), tích hợp sẵn điểm dừng **Human-in-the-loop**.
* **Tầng 2 — Không gian Năng lực H-P-D-I (`apps/`):** Giao diện hợp nhất duy nhất của người dùng cuối (Con người **[H]** $\to$ Quy trình **[P]** $\to$ Dữ liệu **[D]** $\to$ Trí tuệ **[I]** với chốt chặn *Human-in-the-loop* và giải phóng 85% thao tác thủ công).

---

## 2. Cấu trúc Cây Thư mục Chuẩn PoF & GitOps

```text
dx-twinos/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md            # Mẫu báo cáo lỗi (Tiêu chí PoF số 6)
│   │   └── feature_request.md       # Mẫu đề xuất tính năng theo trục H-P-D-I
│   └── workflows/
│       └── pof-compliance.yml       # CI tự động kiểm toán SPDX, Zero-Bundling & Docker Compose
├── core/                            # [TẦNG 1] Cấu hình Hạ tầng Lõi Nguồn mở (Headless PaaS)
│   ├── gateway-traefik/
│   │   └── dynamic.yml              # Định tuyến API Gateway & Middleware xác thực JWT Keycloak
│   ├── identity-keycloak/
│   │   └── realm-dxos.json          # Cấu hình Realm, OIDC Clients & 4 Roles (Human + AI Agent)
│   ├── data-engine/
│   │   ├── init-schema.sql          # Schema SSOT, thực thể số NGSI-LD & sổ cái data_lineage_ledger
│   │   └── rustfs-policy.json       # Chính sách phân quyền S3 Bucket theo chuẩn P.A.R.A
│   └── workflow-kestra/
│       └── flows/
│           └── procure-to-pay.yml   # Luồng tự động hóa chuỗi cung ứng có cổng Pause (Human-in-the-loop)
├── apps/                            # [TẦNG 2] Không gian Năng lực H-P-D-I & Tác tử AI
│   ├── agent-brain/                 # Dịch vụ FastAPI điều phối 4 Tác tử AI & Kiểm toán 3 chiều
│   └── web-portal/                  # Giao diện Không gian Làm việc Hợp nhất (Poka-yoke & Approval Gate)
├── deploy/
│   └── docker-compose.yml           # Kịch bản điều phối toàn bộ hệ thống qua Container chính hãng
├── .env.example                     # Biến môi trường mẫu (Keycloak, Traefik, Postgres, RustFS, Kestra, Ollama)
├── .gitignore                       # Chặn .env, vendor/external và các file nén/nhị phân cấm trong PoF
├── CHANGELOG.md                     # Nhật ký phiên bản chuẩn Keep a Changelog & SemVer (v0.1.0)
├── CONTRIBUTING.md                  # Quy tắc đóng góp, nhánh Git, nhãn SPDX & chính sách Zero-Bundling
├── LICENSE                          # Toàn văn giấy phép Apache License 2.0 (OSI-Approved)
├── Makefile                         # Tự động hóa khởi chạy 1 câu lệnh & kiểm toán tuân thủ PoF
├── NOTICE                           # Hồ sơ ghi nhận bản quyền các thành phần nguồn mở tích hợp
└── README.md                        # Tài liệu tổng quan kiến trúc và hướng dẫn vận hành
```

---

## 3. Khởi chạy Nhanh (1 Câu lệnh GitOps)

```bash
# 1. Khởi tạo môi trường và dựng toàn bộ cụm dịch vụ Lõi + Không gian H-P-D-I
make up

# 2. Nạp cấu trúc bảng SSOT, NGSI-LD Digital Twin & Sổ cái Data Lineage
make seed-db

# 3. Kiểm tra tuân thủ bản quyền nguồn mở SPDX Apache-2.0 & Zero-Bundling
make audit-spdx
make audit-zero-bundling
```

---

## 4. Tuân thủ Bộ Tiêu chí Phần mềm Nguồn mở Quốc gia (PoF — 50/50 Điểm)

| Tiêu chí PoF (VFOSSA) | Giải pháp Thực thi trong `dx-twinos` | Minh chứng trong Repo |
| :--- | :--- | :--- |
| **1. Giấy phép chuẩn OSI** | Phát hành dưới giấy phép **Apache License 2.0** | [`LICENSE`](./LICENSE) |
| **2. Quản lý Bản quyền & SPDX** | 100% file mã nguồn/cấu hình gắn nhãn `SPDX-License-Identifier: Apache-2.0` | [`NOTICE`](./NOTICE), `make audit-spdx` |
| **3. Tương thích & Zero-Bundling** | Không nhúng mã nguồn bên thứ 3; loại bỏ MinIO (`AGPLv3`) & n8n (`Sustainable Use`) | [`deploy/docker-compose.yml`](./deploy/docker-compose.yml), [`.gitignore`](./.gitignore) |
| **4. Công khai Mã nguồn & Tài liệu** | Đầy đủ kịch bản IaC, Schema SQL, Policy S3 và hướng dẫn 1 lệnh chạy | [`README.md`](./README.md), [`Makefile`](./Makefile) |
| **5. An toàn & Bảo mật (DevSecOps)** | Zero-Trust Gateway, RBAC cho AI Agent, chặn rò rỉ `.env`, Sổ cái bất biến | [`dynamic.yml`](./core/gateway-traefik/dynamic.yml), [`init-schema.sql`](./core/data-engine/init-schema.sql) |
| **6. Quy trình Phát triển Mở** | Quản lý phiên bản SemVer, hướng dẫn đóng góp, Issue Templates & CI tự động | [`CHANGELOG.md`](./CHANGELOG.md), [`CONTRIBUTING.md`](./CONTRIBUTING.md), [`.github/`](./.github/) |
