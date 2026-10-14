<!--
SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Mô hình Dữ liệu Chuẩn NGSI-LD & Sổ cái Phả hệ (Data Model & Entities)

Dự án **DX-TwinOS** kế thừa chuẩn dữ liệu mở liên kết **ETSI NGSI-LD** (tương tự chuẩn Smart City trên *UrbanReflex*, nhưng mở rộng sang bài toán **Bản sao số Doanh nghiệp — Enterprise Digital Twin** theo Đề thi OLP 2026).

---

## 1. Thực thể số Chuẩn Quốc tế ETSI NGSI-LD (`ngsi_ld_entities`)

Mỗi kho hàng (`WarehouseZone`), đơn mua hàng (`PurchaseOrder`) hoặc lô hàng (`ShipmentBatch`) đều được định danh bằng URI chuẩn `urn:ngsi-ld:...`:

```json
{
  "@context": [
    "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
  ],
  "id": "urn:ngsi-ld:PurchaseOrder:PO-2026-089",
  "type": "PurchaseOrder",
  "supplierTaxCode": {
    "type": "Property",
    "value": "0312345678"
  },
  "totalAmountVND": {
    "type": "Property",
    "value": 125000000,
    "unitCode": "VND"
  },
  "pokaYokeValidated": {
    "type": "Property",
    "value": true
  },
  "targetWarehouse": {
    "type": "Relationship",
    "object": "urn:ngsi-ld:WarehouseZone:WH-HCM-01"
  }
}
```

---

## 2. Sổ cái Phả hệ Dữ liệu Bất biến (`data_lineage_ledger`)

Đáp ứng yêu cầu **Minh bạch tuyệt đối (Transparency)** và **Human-in-the-loop**:

| Trường dữ liệu | Kiểu dữ liệu | Ý nghĩa Kiến trúc |
| :--- | :--- | :--- |
| `lineage_id` | `UUID` | Định danh duy nhất của sự kiện phả hệ |
| `entity_urn` | `VARCHAR(255)` | Mã định danh NGSI-LD của chứng từ/tài sản (`urn:ngsi-ld:...`) |
| `actor_id` | `VARCHAR(100)` | Định danh Keycloak của Nhân sự hoặc Tác tử AI (`ai_agent_service`) |
| `human_approver_id` | `VARCHAR(100)` | Định danh Quản lý bấm nút phê duyệt **Human-in-the-loop** |
| `kestra_execution_id` | `VARCHAR(120)` | Mã luồng thực thi trên `Kestra Workflow Engine` |
| `payload_sha256` | `CHAR(64)` | Mã băm SHA-256 chống chỉnh sửa trái phép |
| `created_at` | `TIMESTAMPTZ` | Thời điểm ghi nhận bất biến |
