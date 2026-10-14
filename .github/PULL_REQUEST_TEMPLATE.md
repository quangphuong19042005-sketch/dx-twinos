<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

## 📋 Mô tả Thay đổi (Description)

<!-- Mô tả ngắn gọn Pull Request này giải quyết bài toán gì và thuộc Tầng nào (Tầng 1 Headless PaaS hay Tầng 2 H-P-D-I) -->

- **Issue liên quan:** Closes #

## 🎯 Phân loại theo Trục Tiến hóa H-P-D-I

- [ ] **[Tầng 1 - Core]** Hạ tầng Lõi Nguồn mở (`Traefik`, `Keycloak`, `PostgreSQL`, `RustFS`, `Kestra`)
- [ ] **[H - Human]** Môi trường làm việc số, SSO/RBAC & Quản lý tài liệu P.A.R.A
- [ ] **[P - Process]** Chuẩn hóa quy trình & Rào chắn chống sai lỗi **Poka-yoke**
- [ ] **[D - Data]** Single Source of Truth (SSOT), chuẩn **ETSI NGSI-LD** & Sổ cái **Data Lineage**
- [ ] **[I - Intelligence]** Vòng lặp 4 Tác tử AI & Chốt chặn phê duyệt **Human-in-the-loop**

## ✅ Danh mục Kiểm tra Tuân thủ Nguồn mở Quốc gia (VFOSSA PoF Checklist)

- [ ] Mọi file mới tạo đều có 2 dòng tiêu đề `SPDX-FileCopyrightText` và `SPDX-License-Identifier: Apache-2.0`.
- [ ] Đã chạy `just audit-spdx` (hoặc `make audit-spdx`) thành công.
- [ ] **Zero-Bundling:** Không chép mã nguồn của thư viện bên thứ 3 hoặc file nhị phân (`.zip`, `.exe`, `.jar`) vào repo.
- [ ] Không chứa khóa bí mật hay file `.env` thực tế trong commit.
