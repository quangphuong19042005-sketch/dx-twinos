<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Changelog

Mọi thay đổi đáng chú ý của dự án **DX-TwinOS** đều được ghi nhận đầy đủ tại tài liệu này nhằm đảm bảo tính minh bạch của tiến trình phát triển phần mềm nguồn mở (Tiêu chí PoF số 6 — VFOSSA).

Định dạng tài liệu tuân thủ chuẩn [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), và dự án áp dụng quy tắc đánh phiên bản ngữ nghĩa [Semantic Versioning (SemVer)](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Tích hợp mô-đun đối soát đa phương thức (Vision-Language OCR) trực tiếp trên luồng sự kiện Kestra.
- Mở rộng bộ kết nối IoT/MQTT đẩy dữ liệu cảm biến kho lạnh trực tiếp vào bảng thực thể số `ngsi_ld_entities`.
- Bổ sung giao diện kiểm toán đồ thị nguồn gốc dữ liệu (Visual Lineage Graph) trên Tầng 2.

---

## [0.1.0] - 2026-10-14

### Added
- **Kiến trúc Lõi Nguồn mở 3 Tầng (3-Tier Headless PaaS):**
  - Thiết lập cụm hạ tầng chạy ngầm (`deploy/docker-compose.yml`) tích hợp 100% qua Container chính hãng theo nguyên tắc **Zero-Bundling**.
  - **Cổng giao tiếp Zero-Trust (`core/gateway-traefik/`):** Định tuyến tập trung qua Traefik v3.1, ẩn toàn bộ giao diện quản trị Tầng 1 và kiểm soát xác thực JWT/JWKS từ Keycloak.
  - **Định danh Hợp nhất (`core/identity-keycloak/realm-dxos.json`):** Khởi tạo Realm `dx-twinos` cấp phát OIDC/JWT và phân quyền RBAC đồng nhất cho cả Con người (`warehouse_operator`, `finance_auditor`, `approver_manager`) và Tác tử AI (`ai_agent_service`).
  - **Động cơ Dữ liệu Kép (`core/data-engine/`):**
    - `init-schema.sql`: Khởi tạo Single Source of Truth (SSOT) trên PostgreSQL 16 gồm chuỗi bảng giao dịch Mua sắm/Kho (`purchase_orders`, `goods_receipt_notes`, `vendor_invoices`), bảng thực thể Bản sao số chuẩn ETSI NGSI-LD (`ngsi_ld_entities` cho Hội tụ IT/OT), và sổ cái bất biến `data_lineage_ledger` chặn xóa/sửa bằng Trigger.
    - `rustfs-policy.json`: Cấu hình kho lưu trữ đối tượng S3 tốc độ cao trên RustFS (`Apache-2.0`) phân vùng theo phương pháp **P.A.R.A** (`projects/`, `areas/`, `resources/`, `archives/`).
  - **Động cơ Quy trình Khai báo (`core/workflow-kestra/flows/procure-to-pay.yml`):** Luồng tự động hóa chuỗi cung ứng Khép kín có điểm dừng bắt buộc (`io.kestra.plugin.core.flow.Pause`) phục vụ chốt chặn **Human-in-the-loop**.
- **Không gian Năng lực H-P-D-I & Tác tử AI (`apps/agent-brain/`):**
  - Triển khai vòng lặp 4 Tác tử AI (Perception $\to$ Audit 3-Way Match $\to$ Human-in-the-loop Gate $\to$ Lineage Ledger) giải phóng 85% thao tác nhập liệu và đối soát thủ công.
- **Quản trị Nguồn mở Chuẩn PoF 50/50 (VFOSSA):**
  - Áp dụng giấy phép `Apache-2.0` toàn cục (`LICENSE`, `NOTICE`) cùng nhãn định danh `SPDX-FileCopyrightText` và `SPDX-License-Identifier: Apache-2.0` trên toàn bộ tệp mã nguồn và cấu hình.
  - Thiết lập quy trình CI/CD tự động kiểm toán tuân thủ PoF (`.github/workflows/pof-compliance.yml`), quy ước đóng góp (`CONTRIBUTING.md`), và hệ thống mẫu theo dõi lỗi/tính năng (`.github/ISSUE_TEMPLATE/`).
