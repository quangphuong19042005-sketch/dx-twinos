-- SPDX-FileCopyrightText: 2026 DX-TwinOS Contributors
-- SPDX-License-Identifier: Apache-2.0
-- =============================================================================
-- DX-TwinOS Tier-1 Structured Data Engine Schema (PostgreSQL 16)
-- Thiết lập 3 trụ cột dữ liệu cốt lõi:
--   1. Single Source of Truth (SSOT): Giao dịch Mua sắm - Kho - Tài chính (3-Way Match)
--   2. Hội tụ IT/OT (Digital Twin): Bảng thực thể số chuẩn quốc tế ETSI NGSI-LD
--   3. Sổ cái Truy vết Dữ liệu (Data Lineage): Bảng bất biến `data_lineage_ledger`
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- PHẦN 1: SINGLE SOURCE OF TRUTH (SSOT) — MUA SẮM, KHO & ĐỐI SOÁT 3 CHIỀU
-- Giải quyết triệt để căn bệnh "Đứt gãy Silo dữ liệu" giữa Mua hàng - Kho - Kế toán
-- =============================================================================

-- 1.1. Đơn đặt hàng (Purchase Orders - PO)
CREATE TABLE IF NOT EXISTS purchase_orders (
    po_id VARCHAR(64) PRIMARY KEY,
    vendor_code VARCHAR(64) NOT NULL,
    vendor_name VARCHAR(255) NOT NULL,
    ordered_quantity NUMERIC(12, 2) NOT NULL CHECK (ordered_quantity > 0),
    unit_price NUMERIC(18, 2) NOT NULL CHECK (unit_price >= 0),
    total_amount NUMERIC(18, 2) GENERATED ALWAYS AS (ordered_quantity * unit_price) STORED,
    currency VARCHAR(8) NOT NULL DEFAULT 'VND',
    status VARCHAR(32) NOT NULL DEFAULT 'ISSUED'
        CHECK (status IN ('DRAFT', 'ISSUED', 'PARTIALLY_RECEIVED', 'MATCHED', 'CLOSED', 'CANCELLED')),
    created_by_sub VARCHAR(128) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 1.2. Phiếu nhập kho thực tế (Goods Receipt Notes - GRN / Poka-yoke Input)
CREATE TABLE IF NOT EXISTS goods_receipt_notes (
    grn_id VARCHAR(64) PRIMARY KEY,
    po_id VARCHAR(64) NOT NULL REFERENCES purchase_orders(po_id) ON RESTRICT,
    warehouse_zone VARCHAR(64) NOT NULL,
    received_quantity NUMERIC(12, 2) NOT NULL CHECK (received_quantity >= 0),
    damaged_quantity NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (damaged_quantity >= 0),
    iot_weighbridge_kg NUMERIC(12, 3),
    s3_delivery_note_uri TEXT NOT NULL, -- Đường dẫn chuẩn P.A.R.A trên RustFS
    inspected_by_sub VARCHAR(128) NOT NULL,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 1.3. Hóa đơn Nhà cung cấp & Kết quả Kiểm toán AI (Vendor Invoices & 3-Way Match)
CREATE TABLE IF NOT EXISTS vendor_invoices (
    invoice_id VARCHAR(64) PRIMARY KEY,
    po_id VARCHAR(64) NOT NULL REFERENCES purchase_orders(po_id) ON RESTRICT,
    grn_id VARCHAR(64) REFERENCES goods_receipt_notes(grn_id) ON RESTRICT,
    vendor_tax_code VARCHAR(32) NOT NULL,
    billed_quantity NUMERIC(12, 2) NOT NULL CHECK (billed_quantity > 0),
    billed_total_amount NUMERIC(18, 2) NOT NULL CHECK (billed_total_amount >= 0),
    s3_invoice_pdf_uri TEXT NOT NULL,   -- Hồ sơ gốc lưu tại RustFS (s3://dxos-para-vault/projects/...)
    ai_confidence_score NUMERIC(4, 3) CHECK (ai_confidence_score >= 0.0 AND ai_confidence_score <= 1.0),
    three_way_match_passed BOOLEAN NOT NULL DEFAULT FALSE,
    approval_status VARCHAR(32) NOT NULL DEFAULT 'PENDING_HUMAN_APPROVAL'
        CHECK (approval_status IN ('AI_AUDITING', 'PENDING_HUMAN_APPROVAL', 'APPROVED', 'REJECTED', 'POSTED_TO_LEDGER')),
    approved_by_sub VARCHAR(128),       -- Bắt buộc có chữ ký JWT của Quản lý (Human-in-the-loop)
    approved_at TIMESTAMPTZ,
    lineage_trace_id VARCHAR(128) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_invoices_po_id ON vendor_invoices(po_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON vendor_invoices(approval_status);

-- =============================================================================
-- PHẦN 2: HỘI TỤ IT/OT (DIGITAL TWIN) — THỰC THỂ SỐ CHUẨN QUỐC TẾ ETSI NGSI-LD
-- Hợp nhất dữ liệu giao dịch ERP (IT) và cảm biến nhà máy/kho vận (OT)
-- =============================================================================

CREATE TABLE IF NOT EXISTS ngsi_ld_entities (
    entity_id VARCHAR(255) PRIMARY KEY, -- Ví dụ: urn:ngsi-ld:WarehouseZone:ColdStorage-A1
    entity_type VARCHAR(128) NOT NULL,  -- Ví dụ: WarehouseZone, SmartForklift, InventoryBatch
    ld_context JSONB NOT NULL DEFAULT '["https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"]'::jsonb,
    properties JSONB NOT NULL DEFAULT '{}'::jsonb,    -- Thuộc tính động (temperature, humidity, stockLevel...)
    relationships JSONB NOT NULL DEFAULT '{}'::jsonb, -- Liên kết đồ thị (refPurchaseOrder, locatedIn...)
    observed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by_actor VARCHAR(128) NOT NULL,
    lineage_trace_id VARCHAR(128) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_ngsi_ld_type ON ngsi_ld_entities(entity_type);
CREATE INDEX IF NOT EXISTS idx_ngsi_ld_properties_gin ON ngsi_ld_entities USING GIN (properties);
CREATE INDEX IF NOT EXISTS idx_ngsi_ld_relationships_gin ON ngsi_ld_entities USING GIN (relationships);

-- =============================================================================
-- PHẦN 3: SỔ CÁI TRUY VẾT DỮ LIỆU BẤT BIẾN (IMMUTABLE DATA LINEAGE LEDGER)
-- Ghi vết 100% thao tác: Ai (Human/AI) - Làm gì - Khi nào - Vì sao - Dữ liệu gốc ở đâu
-- =============================================================================

CREATE TABLE IF NOT EXISTS data_lineage_ledger (
    ledger_seq BIGSERIAL PRIMARY KEY,
    trace_id VARCHAR(128) NOT NULL UNIQUE,
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    actor_type VARCHAR(32) NOT NULL CHECK (actor_type IN ('HUMAN_OPERATOR', 'AI_AGENT', 'HUMAN_APPROVER', 'WORKFLOW_ENGINE')),
    actor_jwt_sub VARCHAR(128) NOT NULL,
    actor_role VARCHAR(64) NOT NULL,
    pillar_stage VARCHAR(16) NOT NULL CHECK (pillar_stage IN ('H_HUMAN', 'P_PROCESS', 'D_DATA', 'I_INTELLIGENCE')),
    action_name VARCHAR(128) NOT NULL,
    target_entity_table VARCHAR(64) NOT NULL,
    target_record_id VARCHAR(128) NOT NULL,
    source_s3_uri TEXT,
    kestra_execution_id VARCHAR(128),
    ai_reasoning_rationale TEXT,        -- Giải trình lý do vì sao AI đề xuất hoặc Cảnh báo lệch số liệu
    payload_sha256 CHAR(64) NOT NULL,   -- Mã băm chống giả mạo nội dung bản ghi
    prev_record_hash CHAR(64)           -- Liên kết chuỗi băm (Hash-Chain) phục vụ kiểm toán độc lập
);

CREATE INDEX IF NOT EXISTS idx_lineage_target ON data_lineage_ledger(target_entity_table, target_record_id);
CREATE INDEX IF NOT EXISTS idx_lineage_actor ON data_lineage_ledger(actor_jwt_sub, event_timestamp DESC);

-- Trigger bảo vệ tính bất biến (Append-Only): Cấm tuyệt đối UPDATE hoặc DELETE trên sổ cái Lineage
CREATE OR REPLACE FUNCTION enforce_immutable_lineage_ledger()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION '[DX-TwinOS Security Violation] Bảng data_lineage_ledger là sổ cái bất biến (Append-Only). Mọi thao tác % đều bị từ chối!', TG_OP;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_protect_lineage_ledger ON data_lineage_ledger;
CREATE TRIGGER trg_protect_lineage_ledger
BEFORE UPDATE OR DELETE ON data_lineage_ledger
FOR EACH ROW EXECUTE FUNCTION enforce_immutable_lineage_ledger();

-- =============================================================================
-- PHẦN 4: DỮ LIỆU MẪU KHỞI TẠO (SEED DATA PHỤC VỤ DEMO ĐỐI SOÁT 3 CHIỀU)
-- =============================================================================

INSERT INTO purchase_orders (po_id, vendor_code, vendor_name, ordered_quantity, unit_price, currency, status, created_by_sub)
VALUES (
    'PO-2026-0089',
    'VN-SEMI-01',
    'Công ty TNHH Linh kiện Bán dẫn Việt Nam',
    1000.00,
    145000.00,
    'VND',
    'PARTIALLY_RECEIVED',
    'usr-procurement-lead-01'
) ON CONFLICT (po_id) DO NOTHING;

INSERT INTO ngsi_ld_entities (entity_id, entity_type, properties, relationships, updated_by_actor, lineage_trace_id)
VALUES (
    'urn:ngsi-ld:WarehouseZone:Semiconductor-CleanRoom-01',
    'WarehouseZone',
    '{"temperature": {"type": "Property", "value": 21.5, "unitCode": "CEL"}, "humidity": {"type": "Property", "value": 42.0, "unitCode": "P1"}, "currentCapacityPct": {"type": "Property", "value": 68.5}}'::jsonb,
    '{"activePurchaseOrder": {"type": "Relationship", "object": "urn:ngsi-ld:PurchaseOrder:PO-2026-0089"}}'::jsonb,
    'svc-iot-ingestor-01',
    'lin-init-seed-20261014'
) ON CONFLICT (entity_id) DO NOTHING;

INSERT INTO data_lineage_ledger (
    trace_id, actor_type, actor_jwt_sub, actor_role, pillar_stage,
    action_name, target_entity_table, target_record_id, source_s3_uri,
    ai_reasoning_rationale, payload_sha256, prev_record_hash
) VALUES (
    'lin-init-seed-20261014',
    'WORKFLOW_ENGINE',
    'system-bootstrap',
    'ai_agent_service',
    'D_DATA',
    'INITIALIZE_SSOT_AND_NGSI_LD_TWIN',
    'purchase_orders',
    'PO-2026-0089',
    's3://dxos-para-vault/projects/procure-to-pay-2026/PO-2026-0089.pdf',
    'Khởi tạo bản ghi SSOT gốc và thực thể số kho bán dẫn chuẩn ETSI NGSI-LD.',
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    '0000000000000000000000000000000000000000000000000000000000000000'
) ON CONFLICT (trace_id) DO NOTHING;
