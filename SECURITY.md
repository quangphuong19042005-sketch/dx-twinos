<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Chính sách An toàn & Bảo mật (Security Policy)

Dự án **DX-TwinOS** tuân thủ nghiêm ngặt **Tiêu chí PoF số 4 (An toàn và Bảo mật)** của Hội Tin học Việt Nam (VAIP) & Câu lạc bộ Phần mềm Tự do Nguồn mở Việt Nam (VFOSSA), cùng nguyên lý **Zero-Trust & DevSecOps** của Đề thi OLP 2026.

---

## 1. Các Phiên bản Được Hỗ trợ (Supported Versions)

| Phiên bản | Trạng thái Hỗ trợ Bản vá Bảo mật |
| :--- | :--- |
| `0.1.x` (OLP 2026 Stable) | ✅ Được hỗ trợ tích cực |

---

## 2. Kiến trúc Bảo mật Đa lớp trong DX-TwinOS

1. **Zero-Trust API Gateway (`Traefik v3.1`):**
   - Toàn bộ các dịch vụ Tầng 1 (`Keycloak`, `PostgreSQL`, `RustFS`, `Kestra`) nằm trong mạng nội bộ cô lập `dxos-internal`.
   - Chỉ duy nhất cổng `:8000` của `Traefik` được mở ra ngoài và bắt buộc kiểm tra chữ ký số `JWT` ở mọi gói tin.
2. **Định danh Hợp nhất cho cả Người & AI (`Keycloak OIDC/RBAC`):**
   - Tác tử AI (`ai_agent_service`) bị giới hạn quyền nghiêm ngặt: **chỉ có quyền đề xuất (`PROPOSE`)**, tuyệt đối không có quyền tự ý phê duyệt thanh toán hoặc sửa sổ cái nếu thiếu chữ ký `Human-in-the-loop` của `manager_approver`.
3. **Không Lưu trữ Thông tin Nhạy cảm trên Git (Secret Hygiene):**
   - File `.gitignore` chặn triệt để `.env`, khóa cá nhân (`*.pem`, `*.key`) và chứng chỉ bảo mật.
   - Repo chỉ cung cấp `.env.example` chứa cấu trúc biến mẫu.
4. **Sổ cái Phả hệ Dữ liệu Bất biến (`Immutable Data Lineage Ledger`):**
   - Mọi thao tác thêm/sửa dữ liệu trên Tầng 2 đều được ghi nhận vào bảng `data_lineage_ledger` kèm mã băm `SHA-256` chống chối bỏ.

---

## 3. Quy trình Báo cáo Lỗ hổng Bảo mật (Reporting a Vulnerability)

Nếu bạn phát hiện lỗ hổng bảo mật trong mã nguồn hoặc cấu hình IaC của `DX-TwinOS`:
1. **Không tạo Issue công khai** chứa mã khai thác (exploit).
2. Gửi báo cáo trực tiếp qua tab **Security Advisories** trên GitHub Repository: `https://github.com/quangphuong19042005-sketch/dx-twinos/security/advisories`.
3. Nhóm phát triển cam kết phản hồi xác nhận trong vòng **24 giờ** và phát hành bản vá trong vòng **72 giờ**.
