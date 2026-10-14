<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Kiến trúc Hệ thống DX-TwinOS (3-Tier DX-OS Architecture)

Tài liệu này mô tả chi tiết kiến trúc Tháp 3 Tầng và 4 Nguyên lý Thiết kế Hệ thống của **DX-TwinOS** theo đúng chuẩn **Đề thi Phần mềm Nguồn mở OLP 2026** và **Quick-guide-to-DXOS**.

---

## 1. Mô hình Kiến trúc Tháp 3 Tầng (3-Tier DX-OS)

```text
+-----------------------------------------------------------------------------------+
| TẦNG 3: KẾT QUẢ KINH DOANH & CHỦ QUYỀN SỐ (BUSINESS OUTCOMES)                     |
| - 0đ phí bản quyền | 100% Chủ quyền dữ liệu | Báo cáo tức thời (Real-time BI)     |
+-----------------------------------------------------------------------------------+
                                         ▲
                                         │ (Chỉ tương tác qua Tầng 2)
+-----------------------------------------------------------------------------------+
| TẦNG 2: KHÔNG GIAN NĂNG LỰC H-P-D-I (apps/web-portal & apps/agent-brain)          |
| [H] Human Workspace  --> [P] Process & Poka-yoke --> [D] Data SSOT --> [I] AI     |
| - SSO 1 cửa + P.A.R.A    - Chặn rác ngay tại form    - NGSI-LD/Lineage - 4 Agents |
+-----------------------------------------------------------------------------------+
                                         ▲
                                         │ (REST API / OIDC JWT qua cổng :8000)
+-----------------------------------------------------------------------------------+
| TẦNG 1: HẠ TẦNG LÕI NGUỒN MỞ — HEADLESS PaaS (core/ & deploy/docker-compose.yml)  |
| [Traefik v3.1] + [Keycloak 26] + [PostgreSQL 16] + [RustFS S3] + [Kestra Engine]  |
| * Chạy ngầm 100% — Tuyệt đối không mở giao diện quản trị rời rạc cho End-user!    |
+-----------------------------------------------------------------------------------+
```

---

## 2. Bốn Nguyên lý Thiết kế Hệ thống Cốt lõi

1. **Phân tách Vòng đời & Tốc độ Dữ liệu (Hot vs. Cold Storage):**
   - **Dữ liệu Nóng (Hot Transactional Data):** Lưu trên `PostgreSQL 16` (`dxos_ssot`) để đảm bảo tính toàn vẹn ACID cho đơn hàng, tồn kho và ngân sách.
   - **Dữ liệu Lạnh & Phi cấu trúc (Cold/Unstructured Data):** Hóa đơn PDF, ảnh chụp biên bản giao hàng lưu trên `RustFS S3` theo cấu trúc 4 thư mục **P.A.R.A** (`projects/`, `areas/`, `resources/`, `archives/`).
   - **Phân tích Đa chiều (OLAP):** Truy vấn trực tiếp bằng `DuckDB` mà không làm nghẽn luồng giao dịch chính.
2. **Hội tụ IT/OT & Bản sao số (`ETSI NGSI-LD Digital Twin`):**
   - Mọi kho hàng, lô hàng và thiết bị cảm biến đều được chuẩn hóa thành Thực thể số (**Digital Entities**) theo chuẩn quốc tế **ETSI NGSI-LD** (`@context`, `id`, `type`, `Property`, `Relationship`).
3. **Quản trị Phả hệ Dữ liệu Thế hệ mới (`Data Lineage & Governance`):**
   - Bảng sổ cái bất biến `data_lineage_ledger` lưu vết toàn bộ lịch sử: *Ai (hoặc Tác tử AI nào) đã tạo dữ liệu, đi qua bước Kestra nào, ai bấm nút phê duyệt Human-in-the-loop, kèm mã băm SHA-256*.
4. **Bảo mật Zero-Trust & Tự động hóa chuẩn GitOps:**
   - Toàn bộ hạ tầng đóng gói thành mã (`deploy/docker-compose.yml`, `.justfile`, `Makefile`), dựng lại 100% chỉ bằng 1 câu lệnh (`just dev` hoặc `make up`).
