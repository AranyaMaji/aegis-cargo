-- Batch 0: AEGIS-CARGO 4-table ontology (cargo-owner model)
DROP TABLE IF EXISTS public.action_audits CASCADE;
DROP TABLE IF EXISTS public.tactical_incidents CASCADE;
DROP TABLE IF EXISTS public.cargo_consignments CASCADE;
DROP TABLE IF EXISTS public.vessels CASCADE;

CREATE TABLE public.vessels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    imo_number VARCHAR(10) UNIQUE NOT NULL,
    vessel_name VARCHAR(100) NOT NULL,
    vessel_type VARCHAR(50) DEFAULT 'CONTAINER_15000_TEU',
    current_lat DOUBLE PRECISION NOT NULL,
    current_lon DOUBLE PRECISION NOT NULL,
    heading_deg DOUBLE PRECISION DEFAULT 315.0,
    speed_knots DOUBLE PRECISION DEFAULT 18.5,
    status VARCHAR(50) DEFAULT 'UNDERWAY_TRANSIT',
    active_sloc_corridor VARCHAR(50) DEFAULT 'RED_SEA_SUEZ',
    itinerary JSONB DEFAULT '[]'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.cargo_consignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vessel_id UUID REFERENCES public.vessels(id) ON DELETE CASCADE,
    container_id VARCHAR(20) UNIQUE NOT NULL,
    stowage_slot VARCHAR(10) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    un_dg_code VARCHAR(10) DEFAULT 'UN2814',
    temp_regime VARCHAR(20) DEFAULT '2-8C',
    set_point_c NUMERIC(4,2) DEFAULT 4.0,
    ceiling_temp_c NUMERIC(4,2) DEFAULT 8.0,
    current_core_temp_c NUMERIC(4,2) DEFAULT 4.6,
    rise_rate_c_per_hr NUMERIC(4,2) DEFAULT 0.85,
    market_value_usd NUMERIC(15,2) NOT NULL,
    insured_value_usd NUMERIC(15,2) NOT NULL,
    salvage_value_usd NUMERIC(15,2) DEFAULT 0,
    reefer_power_status VARCHAR(30) DEFAULT 'UNPOWERED_DRIFT',
    mkt_degradation_hours_left NUMERIC(6,2) DEFAULT 44.5,
    disposition VARCHAR(30) DEFAULT 'IN_TRANSIT',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.tactical_incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_agency VARCHAR(50) DEFAULT 'UKMTO',
    incident_ref VARCHAR(50) NOT NULL,
    threat_category VARCHAR(50) NOT NULL,
    center_lat DOUBLE PRECISION NOT NULL,
    center_lon DOUBLE PRECISION NOT NULL,
    exclusion_radius_nm DOUBLE PRECISION DEFAULT 65.0,
    severity VARCHAR(30) DEFAULT 'CRITICAL_EXCLUSION',
    chokepoint_key VARCHAR(50) DEFAULT 'BAB_EL_MANDEB',
    active_until TIMESTAMPTZ DEFAULT NOW() + INTERVAL '72 hours',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.action_audits (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vessel_id UUID REFERENCES public.vessels(id),
    container_id VARCHAR(20),
    executed_coa VARCHAR(50) NOT NULL,
    discharge_port_locode VARCHAR(10),
    onward_mode VARCHAR(30),
    authorized_by VARCHAR(100) NOT NULL,
    pre_state_hash CHAR(64) NOT NULL,
    post_state_hash CHAR(64) NOT NULL,
    legal_basis VARCHAR(150) DEFAULT 'GDP Annex 15 cold-chain integrity',
    value_recovered_usd NUMERIC(15,2),
    dispatch_payload JSONB NOT NULL,
    committed_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER PUBLICATION supabase_realtime ADD TABLE public.vessels;
ALTER PUBLICATION supabase_realtime ADD TABLE public.cargo_consignments;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tactical_incidents;
ALTER PUBLICATION supabase_realtime ADD TABLE public.action_audits;

ALTER TABLE public.vessels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cargo_consignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tactical_incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.action_audits ENABLE ROW LEVEL SECURITY;
CREATE POLICY anon_read ON public.vessels FOR SELECT TO anon USING (true);
CREATE POLICY anon_read ON public.cargo_consignments FOR SELECT TO anon USING (true);
CREATE POLICY anon_read ON public.tactical_incidents FOR SELECT TO anon USING (true);
CREATE POLICY anon_read ON public.action_audits FOR SELECT TO anon USING (true);
