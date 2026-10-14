<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

<h1 align="center">DX-TwinOS — Enterprise DX-OS Open-Core</h1>

<p align="center">
	Hệ điều hành Chuyển đổi số Doanh nghiệp bằng Công nghệ Lõi Nguồn mở (DX-OS Open-Core) — Xóa bỏ các "Ốc đảo dữ liệu", bảo vệ Chủ quyền số 100% theo chuẩn <strong>ETSI NGSI-LD</strong> và tự động hóa vận hành bằng vòng lặp <strong>4 Tác tử AI (Human-in-the-loop)</strong> trên trục tiến hóa <strong>H &rarr; P &rarr; D &rarr; I</strong>.
</p>

<p align="center">
	<a href="./apps/web-portal/index.html"><strong>🚀 Mở Buồng lái H-P-D-I (Live Cockpit) »</strong></a>
	<br/>
	<br/>
	<a href="https://github.com/quangphuong19042005-sketch/dx-twinos/issues/new?template=bug_report.md">🐛 Báo lỗi (Report Bug)</a>
	|
	<a href="https://github.com/quangphuong19042005-sketch/dx-twinos/issues/new?template=feature_request.md">✨ Đề xuất Tính năng (Request Feature)</a>
	|
	<a href="./docs/ARCHITECTURE.md">📚 Tài liệu Kiến trúc (Docs)</a>
	|
	<a href="./SECURITY.md">🛡️ Chính sách Bảo mật (Security)</a>
</p>

<p align="center">
	<a href="https://github.com/quangphuong19042005-sketch/dx-twinos/releases">
		<img loading="lazy" src="https://img.shields.io/badge/version-0.1.0-blue.svg" alt="DX-TwinOS version"/>
	</a>
	<a href="https://opensource.org/licenses/Apache-2.0">
		<img loading="lazy" src="https://img.shields.io/badge/License-Apache_2.0-brightgreen.svg" alt="Apache-2.0 License"/>
	</a>
	<a href="https://opensource.org/licenses">
		<img loading="lazy" src="https://img.shields.io/badge/OSI-100%25_Approved-success.svg" alt="OSI Approved"/>
	</a>
	<a href="./.github/workflows/pof-compliance.yml">
		<img loading="lazy" src="https://img.shields.io/badge/VFOSSA_PoF-50%2F50_Compliant-00A3E0.svg" alt="VFOSSA PoF 50/50"/>
	</a>
	<a href="https://fastapi.tiangolo.com/">
		<img loading="lazy" src="https://img.shields.io/badge/FastAPI-0.115-009688?logo=fastapi&logoColor=white" alt="FastAPI"/>
	</a>
	<a href="https://kestra.io/">
		<img loading="lazy" src="https://img.shields.io/badge/Kestra-Apache_2.0-7C3AED" alt="Kestra Workflow"/>
	</a>
	<a href="https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.08.01_60/gs_CIM009v010801p.pdf">
		<img loading="lazy" src="https://img.shields.io/badge/NGSI--LD-Compliant-0284C7" alt="NGSI-LD"/>
	</a>
</p>

---

## ✨ Điểm nhấn Kiến trúc (Key Highlights)

- 🏛️ **Kiến trúc Tháp 3 Tầng (3-Tier DX-OS)**: Tầng 1 chạy ngầm 100% (**Headless PaaS — Zero UI**) cung cấp Định danh, Cổng API, Lưu trữ kép và Động cơ Quy trình; người dùng cuối chỉ thao tác duy nhất trên Tầng 2 (**H-P-D-I**).
- ⚖️ **100% Giấy phép Nguồn mở Chuẩn OSI (`Apache-2.0`)**: Chủ động loại bỏ các công cụ vướng bẫy bản quyền thương mại/Copyleft (`n8n` *Sustainable Use License*, `MinIO` *AGPLv3*, `MongoDB/Redis` *SSPL*) để thay bằng **`Kestra`**, **`RustFS`** và **`PostgreSQL 16`**.
- 🛡️ **Rào chắn Chống sai lỗi (`Poka-yoke Guardrail`)**: Chặn triệt để rác đầu vào (nhập số tiền âm, sai mã số thuế, trùng hóa đơn) ngay tại biểu mẫu **[P]** trước khi ghi vào **Single Source of Truth [D]**.
- 🤖 **Vòng lặp 4 Tác tử AI & Chốt chặn `Human-in-the-loop` [I]**: 4 Tác tử AI (`Perception OCR` &rarr; `Audit 3-Way Match` &rarr; `HITL Gatekeeper` &rarr; `Action & Lineage`) giải phóng **85% thao tác thủ công**, con người giữ quyền bấm nút phê duyệt 1 chạm cuối cùng.
- 🔗 **Hội tụ IT/OT (`ETSI NGSI-LD`) & Sổ cái Phả hệ Bất biến (`Data Lineage`)**: Chuẩn hóa thực thể số liên kết và lưu vết mã băm `SHA-256` chống chối bỏ.
- ⚡ **Khởi chạy 1 Câu lệnh (`One-Command GitOps`)**: Hỗ trợ song song cả **`Just` task runner** (`.justfile` cho Windows PowerShell) và **`GNU Make`** (`Makefile` cho Linux/macOS/CI).

---

## 📋 Mục lục (Table of Contents)

<details>
<summary>Bấm để mở rộng mục lục</summary>

- [1. Khởi chạy Nhanh (Quick Start — 1 Câu lệnh)](#-1-khởi-chạy-nhanh-quick-start--1-câu-lệnh)
- [2. Danh mục Công nghệ Lõi Nguồn mở (Technology Stack)](#️-2-danh-mục-công-nghệ-lõi-nguồn-mở-technology-stack)
- [3. Cấu trúc Cây Thư mục Chuẩn PoF & GitOps](#-3-cấu-trúc-cây-thư-mục-chuẩn-pof--gitops)
- [4. Bảng Tham chiếu Lệnh Tự động hóa (`just` & `make`)](#-4-bảng-tham-chiếu-lệnh-tự-động-hóa-just--make)
- [5. Tuân thủ Bộ Tiêu chí Nguồn mở Quốc gia (PoF 50/50)](#-5-tuân-thủ-bộ-tiêu-chí-nguồn-mở-quốc-gia-pof-5050)
- [6. Hệ thống Tài liệu Kỹ thuật (Documentation)](#-6-hệ-thống-tài-liệu-kỹ-thuật-documentation)
- [7. Đóng góp & Cộng đồng (Contributing)](#-7-đóng-góp--cộng-đồng-contributing)
- [8. Đơn vị Tổ chức & Thống kê Dự án](#-8-đơn-vị-tổ-chức--thống-kê-dự-án)

</details>

---

## 🚀 1. Khởi chạy Nhanh (Quick Start — 1 Câu lệnh)

### Yêu cầu Môi trường (Prerequisites)

```bash
✅ Docker Desktop      # https://www.docker.com/
✅ Just task runner    # (Khuyên dùng cho Windows PowerShell) hoặc GNU Make (Linux/macOS)
✅ 8GB RAM minimum
```

### Cài đặt & Khởi chạy (Chọn `just` hoặc `make`)

```bash
# 1. Clone kho mã nguồn
git clone https://github.com/quangphuong19042005-sketch/dx-twinos.git
cd dx-twinos

# 2. Khởi tạo môi trường và dựng toàn bộ Tầng 1 (Headless PaaS) chỉ với 1 câu lệnh:
just dev          # Trên Windows PowerShell (tương tự chuẩn UrbanReflex)
# HOẶC:
make up           # Trên Linux / macOS / Git Bash / WSL

# 3. Kiểm toán tự động 50/50 điểm Bản quyền Nguồn mở (PoF VFOSSA):
just audit-spdx
just audit-zero-bundling
```

---

## 🛠️ 2. Danh mục Công nghệ Lõi Nguồn mở (Technology Stack)

### Tầng 1 — Hạ tầng Lõi Nguồn mở (`Headless PaaS — Zero UI`)

| Lớp Kiến trúc | Công nghệ Lựa chọn | Giấy phép (OSI) | Lý do Kiến trúc & Pháp lý (So với bảng tham chiếu) |
| :--- | :--- | :--- | :--- |
| **1. Định danh & SSO** | **Keycloak 26** | `Apache-2.0` | Quản lý OIDC/JWT & phân quyền RBAC cho cả Con người và Tác tử AI. |
| **2. Cổng giao tiếp API** | **Traefik Proxy v3.1** | `MIT` | Chốt chặn Zero-Trust duy nhất tại cổng `:8000`, ẩn toàn bộ Tầng 1. |
| **3A. Dữ liệu Có cấu trúc** | **PostgreSQL 16 + DuckDB** | `PostgreSQL / MIT` | Đảm bảo SSOT (ACID), thực thể số `NGSI-LD` & sổ cái `data_lineage_ledger`. |
| **3B. Lưu trữ Đối tượng S3** | **RustFS** | `Apache-2.0` | Viết bằng Rust siêu nhẹ, thay thế `MinIO` (vốn dính giấy phép `AGPLv3` Copyleft). |
| **4. Động cơ Quy trình** | **Kestra** | `Apache-2.0` | Quy trình khai báo bằng YAML, thay thế `n8n` (vốn dính `Sustainable Use License`). |

### Tầng 2 — Không gian Năng lực `H-P-D-I` & Vòng lặp 4 Tác tử AI

| Trục Năng lực | Công nghệ Thực thi | Vai trò trong Chuỗi Tiến hóa `H -> P -> D -> I` |
| :--- | :--- | :--- |
| **[H] Con người** | **HTML5 / Tailwind CSS / OIDC** | Đăng nhập 1 cửa (SSO) & Quản trị tri thức 4 thư mục **P.A.R.A**. |
| **[P] Quy trình** | **Pydantic V2 + JSON Schema** | Rào chắn chống sai lỗi **Poka-yoke** chặn số âm/sai mã số thuế ngay tại nguồn. |
| **[D] Dữ liệu** | **ETSI NGSI-LD + SHA-256 Ledger** | Liên kết dữ liệu IT/OT và ghi vết phả hệ dữ liệu bất biến. |
| **[I] Trí tuệ** | **FastAPI + Ollama Local LLM** | Vòng lặp 4 Tác tử AI (`OCR` &rarr; `Audit` &rarr; `HITL Gate` &rarr; `Action & Lineage`). |

---

## 📂 3. Cấu trúc Cây Thư mục Chuẩn PoF & GitOps

```text
dx-twinos/
├── .github/
│   ├── ISSUE_TEMPLATE/              # Mẫu Bug Report & Feature Request (Tiêu chí PoF #6)
│   ├── PULL_REQUEST_TEMPLATE.md     # Checklist kiểm tra PoF & H-P-D-I cho mọi PR
│   └── workflows/
│       └── pof-compliance.yml       # CI tự động kiểm toán SPDX, Zero-Bundling & Docker Compose
├── core/                            # [TẦNG 1] Cấu hình Hạ tầng Lõi Nguồn mở (Headless PaaS)
│   ├── gateway-traefik/             # Định tuyến API Gateway & Middleware xác thực JWT Keycloak
│   ├── identity-keycloak/           # Cấu hình Realm, OIDC Clients & 4 Roles (Human + AI Agent)
│   ├── data-engine/                 # Schema SSOT, thực thể số NGSI-LD, Lineage & RustFS P.A.R.A
│   └── workflow-kestra/             # Luồng tự động hóa chuỗi cung ứng có cổng Pause (HITL)
├── apps/                            # [TẦNG 2] Không gian Năng lực H-P-D-I & Tác tử AI
│   ├── agent-brain/                 # Dịch vụ FastAPI điều phối 4 Tác tử AI & Kiểm toán 3 chiều
│   └── web-portal/                  # Buồng lái H-P-D-I tương tác trực tiếp (Poka-yoke & HITL)
├── docs/                            # Tài liệu Kiến trúc 3 Tầng & Mô hình Thực thể NGSI-LD
├── schemas/                         # JSON Schema kiểm duyệt dữ liệu đầu vào (Poka-yoke)
├── examples/                        # Mẫu dữ liệu chuẩn quốc tế ETSI NGSI-LD
├── deploy/
│   └── docker-compose.yml           # Kịch bản điều phối toàn bộ hệ thống qua Container chính hãng
├── .justfile                        # Task runner hiện đại cho Windows PowerShell & Cross-platform
├── Makefile                         # Task runner chuẩn GitOps cho Linux/macOS/CI
├── CODE_OF_CONDUCT.md               # Quy tắc ứng xử cộng đồng nguồn mở (Contributor Covenant)
├── CONTRIBUTING.md                  # Hướng dẫn đóng góp, nhánh Git, nhãn SPDX & Zero-Bundling
├── SECURITY.md                      # Chính sách an toàn bảo mật Zero-Trust (Tiêu chí PoF #4)
├── CHANGELOG.md                     # Nhật ký phiên bản chuẩn Keep a Changelog (v0.1.0)
├── LICENSE                          # Toàn văn giấy phép Apache License 2.0 (202 dòng chuẩn OSI)
└── NOTICE                           # Hồ sơ ghi nhận bản quyền các thành phần nguồn mở tích hợp
```

---

## ⚡ 4. Bảng Tham chiếu Lệnh Tự động hóa (`just` & `make`)

```bash
# Khởi tạo & Vận hành Hệ thống
just setup-env        # (hoặc: make init-env) Tạo file .env từ .env.example
just dev              # (hoặc: make up)       Khởi chạy toàn bộ Tầng 1 & tự động nạp Schema DB
just down             # (hoặc: make down)     Dừng toàn bộ cụm dịch vụ Container
just status           # (hoặc: make status)   Kiểm tra trạng thái các Container
just cockpit          # Mở Buồng lái tương tác 4 góc H-P-D-I trên trình duyệt

# Kiểm toán Tuân thủ Nguồn mở Quốc gia (PoF VFOSSA 50/50)
just audit-spdx            # (hoặc: make audit-spdx)          Quét nhãn SPDX Apache-2.0 trên 100% file
just audit-zero-bundling   # (hoặc: make audit-zero-bundling) Kiểm tra chính sách không nhúng code bên thứ 3
just lint-compose          # (hoặc: make lint-compose)        Kiểm tra cú pháp deploy/docker-compose.yml
```

---

## 🏆 5. Tuân thủ Bộ Tiêu chí Nguồn mở Quốc gia (PoF 50/50)

| Tiêu chí PoF (VFOSSA) | Giải pháp Thực thi trong `DX-TwinOS` | Minh chứng trong Repo |
| :--- | :--- | :--- |
| **1. Giấy phép chuẩn OSI** | Phát hành dưới giấy phép **Apache License 2.0** (toàn văn 202 dòng) | [`LICENSE`](./LICENSE) |
| **2. Quản lý Bản quyền & SPDX** | 100% file mã nguồn/cấu hình gắn nhãn `SPDX-License-Identifier: Apache-2.0` | [`NOTICE`](./NOTICE), `just audit-spdx` |
| **3. Công khai Mã nguồn & Tài liệu** | Đầy đủ kịch bản IaC (`.justfile`, `Makefile`), Schema NGSI-LD & tài liệu `docs/` | [`docs/`](./docs/), [`schemas/`](./schemas/) |
| **4. An toàn & Bảo mật (DevSecOps)** | Chính sách bảo mật `SECURITY.md`, Zero-Trust Gateway, RBAC cho AI Agent | [`SECURITY.md`](./SECURITY.md), [`dynamic.yml`](./core/gateway-traefik/dynamic.yml) |
| **5. Tương thích & Zero-Bundling** | Không nhúng mã nguồn bên thứ 3; loại bỏ MinIO (`AGPLv3`) & n8n (`Sustainable Use`) | [`deploy/docker-compose.yml`](./deploy/docker-compose.yml), [`.gitignore`](./.gitignore) |
| **6. Quy trình Phát triển Mở** | Quản lý phiên bản SemVer, `CODE_OF_CONDUCT.md`, Issue/PR Templates & CI tự động | [`CHANGELOG.md`](./CHANGELOG.md), [`CONTRIBUTING.md`](./CONTRIBUTING.md), [`.github/`](./.github/) |

---

## 📖 6. Hệ thống Tài liệu Kỹ thuật (Documentation)

| Tài liệu | Nội dung Chi tiết |
| :--- | :--- |
| [**Kiến trúc Hệ thống 3 Tầng**](./docs/ARCHITECTURE.md) | Giải phẫu Tầng 1 (Headless PaaS), Tầng 2 (H-P-D-I) và 4 Nguyên lý Thiết kế. |
| [**Mô hình Dữ liệu NGSI-LD & Lineage**](./docs/DATA_MODEL_AND_ENTITIES.md) | Cấu trúc thực thể số chuẩn quốc tế ETSI NGSI-LD và sổ cái bất biến `SHA-256`. |
| [**JSON Schema Poka-yoke**](./schemas/PurchaseInvoice_schema.json) | Rào chắn kiểm duyệt dữ liệu đầu vào chống nhập số tiền âm và sai mã số thuế. |
| [**Mẫu Thực thể NGSI-LD**](./examples/example_purchase_order_ngsi_ld.json) | Ví dụ JSON-LD của chứng từ mua sắm đã qua kiểm toán AI và phê duyệt 1 chạm. |
| [**Chính sách An toàn & Bảo mật**](./SECURITY.md) | Quy trình bảo mật Zero-Trust, phân quyền AI Agent và báo cáo lỗ hổng. |

---

## 🤝 7. Đóng góp & Cộng đồng (Contributing)

Chúng tôi hoan nghênh mọi đóng góp từ cộng đồng Phần mềm Tự do Nguồn mở! Vui lòng đọc kỹ [**Hướng dẫn Đóng góp (CONTRIBUTING.md)**](./CONTRIBUTING.md) và [**Quy tắc Ứng xử (CODE_OF_CONDUCT.md)**](./CODE_OF_CONDUCT.md) trước khi tạo Pull Request.

---

## 🏛️ 8. Đơn vị Tổ chức & Thống kê Dự án

<p align="center">
	<a href="https://hutech.edu.vn/" target="_blank">
		<img loading="lazy" src="https://file1.hutech.edu.vn/file/editor/homepage/stories/hinh34/logo%20CMYK-01.png" height="80px" alt="HUTECH University">
	</a>
	&nbsp;&nbsp;&nbsp;
	<a href="https://vfossa.vn/" target="_blank">
		<img loading="lazy" src="https://vfossa.vn/uploads/about/logo-6b-new.png" height="80px" alt="VFOSSA">
	</a>
	&nbsp;&nbsp;&nbsp;
	<a href="https://www.olp.vn/" target="_blank">
		<img loading="lazy" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRePWbAslFDMVxeJCgHI6f_LSIuNOrlrEsEhA&s" height="80px" alt="Vietnam OLP">
	</a>
</p>

<div align="center">

| Chỉ số (Metric) | Huy hiệu (Badge) |
| :--- | :--- |
| 🌟 **Stars** | ![GitHub stars](https://img.shields.io/github/stars/quangphuong19042005-sketch/dx-twinos?style=social) |
| 🍴 **Forks** | ![GitHub forks](https://img.shields.io/github/forks/quangphuong19042005-sketch/dx-twinos?style=social) |
| 🐛 **Issues** | ![GitHub issues](https://img.shields.io/github/issues/quangphuong19042005-sketch/dx-twinos) |
| 📅 **Last Commit** | ![GitHub last commit](https://img.shields.io/github/last-commit/quangphuong19042005-sketch/dx-twinos) |
| 📜 **License** | ![GitHub license](https://img.shields.io/github/license/quangphuong19042005-sketch/dx-twinos) |

</div>

---

<div align="center">

**DX-TwinOS v0.1.0** — Hệ điều hành Doanh nghiệp số Lõi Nguồn mở (OLP 2026)

[🏠 Trang chủ Repo](https://github.com/quangphuong19042005-sketch/dx-twinos) • [📚 Tài liệu Kiến trúc](./docs/ARCHITECTURE.md) • [🐛 Báo lỗi](https://github.com/quangphuong19042005-sketch/dx-twinos/issues) • [🛡️ Bảo mật](./SECURITY.md)

</div>
