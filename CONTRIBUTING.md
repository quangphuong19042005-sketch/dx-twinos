<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Hướng dẫn Đóng góp Mã nguồn Mở (Contributing to DX-TwinOS)

Cảm ơn bạn đã quan tâm và đóng góp cho **DX-TwinOS — Hệ điều hành Doanh nghiệp số Lõi Nguồn mở**. Dự án được xây dựng và vận hành tuân thủ nghiêm ngặt bộ **Tiêu chí Đánh giá Phần mềm Nguồn mở (PoF)** của VFOSSA.

Để mọi đóng góp (Pull Request, Issue, Architecture Proposal) được hợp nhất nhanh chóng và an toàn pháp lý, vui lòng tuân thủ các quy tắc dưới đây.

---

## 1. Nguyên tắc Cốt lõi: Zero-Bundling & Clean IP

1. **Tuyệt đối Không nhồi nhét mã nguồn bên thứ 3 (Zero-Bundling):**
   - Không bao giờ sao chép (copy-paste) mã nguồn của các dự án lớn (như Keycloak, Traefik, Kestra, RustFS, PostgreSQL, Odoo, ERPNext...) vào thư mục dự án hoặc các thư mục như `external/`, `vendor/`, `third_party/`.
   - Mọi thành phần Hạ tầng Lõi (Tầng 1) bắt buộc phải được gọi động thông qua Docker Image chính thức trong `deploy/docker-compose.yml` hoặc khai báo phụ thuộc qua trình quản lý gói chuẩn (`pyproject.toml`, `package.json`).
2. **Không đưa tệp nhị phân hoặc tệp nén vào Git:**
   - Các định dạng `*.zip`, `*.rar`, `*.exe`, `*.dll`, `*.jar`, `*.so` bị chặn hoàn toàn bởi `.gitignore` và hệ thống kiểm toán tự động GitHub Actions (`pof-compliance.yml`).
3. **Tính tương thích Giấy phép (OSI-Approved License Compatibility):**
   - Dự án phát hành theo giấy phép **Apache License 2.0**.
   - Không tích hợp thư viện hoặc thành phần mang giấy phép không thuộc danh mục OSI-Approved (ví dụ: SSPL, Sustainable Use License của n8n, BusL) hoặc copyleft xung đột trực tiếp với mã nguồn `Apache-2.0`.

---

## 2. Quy tắc Gắn nhãn Bản quyền SPDX (Bắt buộc 100%)

Mọi tệp mã nguồn và tệp cấu hình mới tạo ra trong kho lưu trữ **bắt buộc** phải có đủ 2 dòng định danh chuẩn [SPDX](https://spdx.dev/) ở phần đầu tệp:

- **Đối với Python, Shell, YAML, Makefile, Dockerfile, `.env.example`:**
  ```yaml
  # SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
  # SPDX-License-Identifier: Apache-2.0
  ```
- **Đối với SQL (`*.sql`):**
  ```sql
  -- SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
  -- SPDX-License-Identifier: Apache-2.0
  ```
- **Đối với TypeScript/JavaScript (`*.ts`, `*.tsx`, `*.js`):**
  ```ts
  // SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
  // SPDX-License-Identifier: Apache-2.0
  ```
- **Đối với Tài liệu Markdown (`*.md`):**
  ```markdown
  <!--
  SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
  SPDX-License-Identifier: Apache-2.0
  -->
  ```

> **Kiểm tra trước khi gửi PR:** Chạy lệnh `make audit-spdx` để xác nhận toàn bộ tệp của bạn đã đạt chuẩn SPDX.

---

## 3. Quy trình Nhánh Git & Conventional Commits

### 3.1. Mô hình Nhánh (Git Branching)
- `main`: Nhánh ổn định phục vụ phát hành chính thức (luôn vượt qua 100% bài kiểm tra CI `pof-compliance.yml`).
- `feat/<ten-tinh-nang>`: Phát triển tính năng mới trên Tầng 1 (`core/`) hoặc Tầng 2 (`apps/`).
- `fix/<ten-loi>`: Sửa lỗi logic, lỗi cấu hình hoặc vá lỗ hổng bảo mật.
- `docs/<noi-dung>`: Cập nhật tài liệu kiến trúc, hướng dẫn triển khai, hoặc nhật ký thay đổi.

### 3.2. Chuẩn Thông điệp Commit (Conventional Commits)
Mọi commit phải tuân theo định dạng chuẩn để hỗ trợ trích xuất tự động vào `CHANGELOG.md`:
- `feat(core): bổ sung policy phân vùng P.A.R.A cho RustFS`
- `feat(agent-brain): tích hợp kiểm toán đối soát 3 chiều PO-GRN-Invoice`
- `fix(gateway): cập nhật đường dẫn JWKS xác thực token Keycloak`
- `chore(pof): bổ sung header SPDX Apache-2.0 cho kịch bản khởi tạo SQL`

---

## 4. Quy trình Gửi Pull Request (PR Checklist)

1. Fork kho lưu trữ và tạo nhánh mới từ `main`.
2. Sao chép `.env.example` sang `.env` và kiểm thử cục bộ bằng lệnh `make up`.
3. Chạy `make audit-spdx` và đảm bảo không có cảnh báo vi phạm PoF.
4. Cập nhật mục `[Unreleased]` trong `CHANGELOG.md` mô tả rõ thay đổi của bạn.
5. Mở Pull Request kèm mô tả rõ kiến trúc tác động (thuộc trụ cột **[H]**, **[P]**, **[D]** hay **[I]**).
