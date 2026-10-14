---
# SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
# SPDX-License-Identifier: Apache-2.0
name: "🐞 Báo cáo Lỗi (Bug Report)"
about: "Báo cáo lỗi hệ thống trên Tầng 1 (Headless PaaS) hoặc Tầng 2 (Không gian H-P-D-I)"
title: "[BUG] "
labels: ["bug", "triage"]
assignees: []
---

## 1. Phân tầng Kiến trúc bị ảnh hưởng (Affected Layer)
- [ ] **Tầng 1 — Hạ tầng Lõi (`core/` & `deploy/`):** Keycloak / Traefik / PostgreSQL / RustFS / Kestra
- [ ] **Tầng 2 — Không gian Năng lực H-P-D-I (`apps/`):** Giao diện Poka-yoke / Agentic Brain / DuckDB OLAP
- [ ] **CI/CD & Quản trị Nguồn mở (PoF Compliance):** Makefile / GitHub Actions / SPDX

## 2. Mô tả Lỗi (Bug Description)
Mô tả ngắn gọn và rõ ràng về sự cố đang xảy ra.

## 3. Các bước Tái hiện (Steps to Reproduce)
1. Khởi chạy hệ thống bằng lệnh `make up`...
2. Gửi request tới endpoint hoặc thực hiện thao tác...
3. Quan sát lỗi tại...

## 4. Hành vi Kỳ vọng (Expected Behavior)
Mô tả kết quả đúng lẽ ra phải diễn ra (ví dụ: Kestra dừng tại cổng `step_2_human_in_the_loop_gate` và ghi nhận `lineage_trace_id`).

## 5. Nhật ký Hệ thống & Truy vết (Logs & Lineage Trace ID)
Đính kèm kết quả từ `make logs` hoặc mã `trace_id` trong bảng `data_lineage_ledger`:
```text
Dán log lỗi tại đây...
```

## 6. Môi trường Thực thi (Environment)
- **Hệ điều hành (OS):** [ví dụ: Ubuntu 24.04 LTS / Windows 11 WSL2]
- **Phiên bản Docker & Compose:** [ví dụ: Docker 27.x, Compose v2.29]
- **Phiên bản DX-TwinOS:** `v0.1.0`
