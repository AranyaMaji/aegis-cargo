-- =============================================================================
-- AEGIS-CARGO (ODIN-OPS) — Full Database Schema, RLS, Realtime & Seed
-- Tournament: 1st Place Champion, n8n University Hackathon Sydney 2026
-- Architecture: Palantir 4-Table Cargo-Owner Ontology + 21 CFR Part 11 Audit Log
-- =============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. DROP EXISTING OBJECTS (CLEAN SETUP)
DROP FUNCTION IF EXISTS public.reset_demo_state() CASCADE;
DROP TABLE IF EXISTS public.system_execution_logs CASCADE;
DROP TABLE IF EXISTS public.action_audits CASCADE;
DROP TABLE IF EXISTS public.tactical_incidents CASCADE;
DROP TABLE IF EXISTS public.cargo_consignments CASCADE;
DROP TABLE IF EXISTS public.vessels CASCADE;

-- 3. CORE ONTOLOGY TABLES

-- 3.1 Vessels / Air Freighters (Digital Twin Tracking)
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

-- 3.2 Cold-Chain Cargo Consignments (Biological Therapeutics)
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
    gross_weight_kg NUMERIC(10,2) DEFAULT 4200.0,
    market_value_usd NUMERIC(15,2) NOT NULL,
    insured_value_usd NUMERIC(15,2) NOT NULL,
    salvage_value_usd NUMERIC(15,2) DEFAULT 0,
    reefer_power_status VARCHAR(30) DEFAULT 'UNPOWERED_DRIFT',
    mkt_degradation_hours_left NUMERIC(6,2) DEFAULT 44.5,
    disposition VARCHAR(30) DEFAULT 'IN_TRANSIT',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.3 Geopolitical & Weather Tactical Incidents
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

-- 3.4 Palantir AIP Action Audits (Committed COA Decisions)
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

-- 3.5 21 CFR Part 11 System Execution & Telemetry Logs
CREATE TABLE public.system_execution_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trace_id TEXT NOT NULL,
    vessel_id UUID REFERENCES public.vessels(id) ON DELETE SET NULL,
    event_source TEXT NOT NULL CHECK (event_source IN ('HARDWARE_IOT', 'GDACS_POLL', 'RSS_NEWS', 'CONSOLE_INJECT')),
    stage TEXT NOT NULL CHECK (stage IN ('INGRESS', 'SCHEMA_VALIDATION', 'MKT_OPTIMIZER', 'HITL_DISPATCH', 'MUTATION_COMMITTED')),
    log_level TEXT NOT NULL CHECK (log_level IN ('INFO', 'WARN', 'ERROR', 'AUDIT')),
    latency_ms INTEGER DEFAULT 0,
    payload JSONB DEFAULT '{}'::jsonb,
    error_details JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_system_execution_logs_trace_id ON public.system_execution_logs (trace_id);
CREATE INDEX IF NOT EXISTS idx_system_execution_logs_created_at_desc ON public.system_execution_logs (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_system_execution_logs_stage ON public.system_execution_logs (stage);
CREATE UNIQUE INDEX IF NOT EXISTS vessels_imo_number_key ON public.vessels (imo_number);
CREATE UNIQUE INDEX IF NOT EXISTS cargo_consignments_container_id_key ON public.cargo_consignments (container_id);

-- 5. REALTIME REPLICATION BINDINGS
ALTER PUBLICATION supabase_realtime ADD TABLE public.vessels;
ALTER PUBLICATION supabase_realtime ADD TABLE public.cargo_consignments;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tactical_incidents;
ALTER PUBLICATION supabase_realtime ADD TABLE public.action_audits;
ALTER PUBLICATION supabase_realtime ADD TABLE public.system_execution_logs;

-- 6. ROW LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.vessels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cargo_consignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tactical_incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.action_audits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_execution_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_read_vessels" ON public.vessels FOR SELECT TO anon USING (true);
CREATE POLICY "anon_read_cargo" ON public.cargo_consignments FOR SELECT TO anon USING (true);
CREATE POLICY "anon_read_incidents" ON public.tactical_incidents FOR SELECT TO anon USING (true);
CREATE POLICY "anon_read_audits" ON public.action_audits FOR SELECT TO anon USING (true);
CREATE POLICY "anon_read_system_execution_logs" ON public.system_execution_logs FOR SELECT TO anon USING (true);

CREATE POLICY "authenticated_read_all" ON public.vessels FOR SELECT TO authenticated USING (true);
CREATE POLICY "authenticated_read_cargo" ON public.cargo_consignments FOR SELECT TO authenticated USING (true);
CREATE POLICY "authenticated_read_incidents" ON public.tactical_incidents FOR SELECT TO authenticated USING (true);
CREATE POLICY "authenticated_read_audits" ON public.action_audits FOR SELECT TO authenticated USING (true);
CREATE POLICY "authenticated_read_system_execution_logs" ON public.system_execution_logs FOR SELECT TO authenticated USING (true);

-- 7. REPRODUCIBLE FLEET SEED & RESET RPC
-- The RPC is the fleet seed as well as the reset: three vessels/aircraft + three consignments
-- upserted on imo_number / container_id with dynamically calculated fresh ETAs.
CREATE OR REPLACE FUNCTION public.reset_demo_state()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  t TIMESTAMPTZ := NOW();
BEGIN
  -- Clear incidents and audit logs
  DELETE FROM action_audits WHERE audit_id IS NOT NULL;
  DELETE FROM tactical_incidents WHERE id IS NOT NULL;
  DELETE FROM system_execution_logs WHERE id IS NOT NULL;

  -- 1. Seed Fleet of Three
  INSERT INTO vessels (imo_number, vessel_name, vessel_type, current_lat, current_lon,
                       heading_deg, speed_knots, status, active_sloc_corridor, itinerary, updated_at)
  VALUES
    -- Vessel 1: CMA CGM Tigris (Red Sea / Bab-el-Mandeb Transit)
    ('9834521', 'CMA CGM TIGRIS', 'CONTAINER_15000_TEU', 15.50, 58.50, 300, 18.5,
     'UNDERWAY_TRANSIT', 'RED_SEA_SUEZ',
     jsonb_build_array(
       jsonb_build_object('port_name','Salalah','locode','OMSLL','lat',17.02,'lon',54.09,
         'eta', to_char(t + interval '18 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','SLL','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Jeddah','locode','SAJED','lat',21.48,'lon',39.19,
         'eta', to_char(t + interval '3 days','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','JED','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Port Said','locode','EGPSD','lat',31.26,'lon',32.30,
         'eta', to_char(t + interval '5 days','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','CAI','has_reefer_cold_storage',false),
       jsonb_build_object('port_name','Rotterdam','locode','NLRTM','lat',51.95,'lon',4.14,
         'eta', to_char(t + interval '13 days','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','AMS','has_reefer_cold_storage',true)
     ), t),

    -- Vessel 2: Ever Given (South China Sea / Malacca Strait Transit)
    ('9811000', 'EVER GIVEN', 'CONTAINER_20000_TEU', 5.50, 106.50, 30, 17.2,
     'UNDERWAY_TRANSIT', 'SOUTH_CHINA_SEA',
     jsonb_build_array(
       jsonb_build_object('port_name','Singapore','locode','SGSIN','lat',1.26,'lon',103.83,
         'eta', to_char(t + interval '20 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','SIN','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Hong Kong','locode','HKHKG','lat',22.28,'lon',114.17,
         'eta', to_char(t + interval '3 days 6 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','HKG','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Shanghai','locode','CNSHA','lat',31.23,'lon',121.47,
         'eta', to_char(t + interval '5 days','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','PVG','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Busan','locode','KRPUS','lat',35.10,'lon',129.04,
         'eta', to_char(t + interval '7 days','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','PUS','has_reefer_cold_storage',true)
     ), t),

    -- Vessel 3: Maersk Mc-Kinney Air Asset (Transatlantic Air Cargo B777F)
    ('9619907', 'MAERSK MC-KINNEY', 'AIR_FREIGHTER_B777F', 52.80, 3.20, 245, 470,
     'AIRBORNE_TRANSIT', 'NORTH_ATLANTIC',
     jsonb_build_array(
       jsonb_build_object('port_name','Rotterdam','locode','NLRTM','lat',51.95,'lon',4.14,
         'eta', to_char(t + interval '4 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','AMS','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','Southampton','locode','GBSOU','lat',50.90,'lon',-1.40,
         'eta', to_char(t + interval '9 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','LHR','has_reefer_cold_storage',true),
       jsonb_build_object('port_name','New York','locode','USNYC','lat',40.68,'lon',-74.04,
         'eta', to_char(t + interval '20 hours','YYYY-MM-DD"T"HH24:MI:SS"Z"'),
         'customs_ok',true,'has_airport',true,'nearest_airport_iata','JFK','has_reefer_cold_storage',true)
     ), t)
  ON CONFLICT (imo_number) DO UPDATE SET
    vessel_name          = EXCLUDED.vessel_name,
    vessel_type          = EXCLUDED.vessel_type,
    current_lat          = EXCLUDED.current_lat,
    current_lon          = EXCLUDED.current_lon,
    heading_deg          = EXCLUDED.heading_deg,
    speed_knots          = EXCLUDED.speed_knots,
    status               = EXCLUDED.status,
    active_sloc_corridor = EXCLUDED.active_sloc_corridor,
    itinerary            = EXCLUDED.itinerary,
    updated_at           = EXCLUDED.updated_at;

  -- 2. Seed Cargo Consignments
  DELETE FROM cargo_consignments
   WHERE container_id NOT IN ('MED-7702', 'BIO-4419', 'CELL-9011');

  INSERT INTO cargo_consignments (vessel_id, container_id, stowage_slot, product_name,
    un_dg_code, temp_regime, set_point_c, ceiling_temp_c, current_core_temp_c,
    rise_rate_c_per_hr, market_value_usd, insured_value_usd, salvage_value_usd,
    reefer_power_status, mkt_degradation_hours_left, disposition, gross_weight_kg, updated_at)
  VALUES
    ((SELECT id FROM vessels WHERE imo_number = '9834521'), 'MED-7702', 'BAY07-R2',
     'Monoclonal Antibody (mAb) Oncology Biologic', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     2400000, 2040000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 4200, t),

    ((SELECT id FROM vessels WHERE imo_number = '9811000'), 'BIO-4419', 'BAY12-R1',
     'mRNA Vaccine Doses (multi-dose vials)', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     1800000, 1530000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 3100, t),

    ((SELECT id FROM vessels WHERE imo_number = '9619907'), 'CELL-9011', 'ULD-PMC-04',
     'Autologous Cell Therapy Biologic', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     3100000, 2635000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 2600, t)
  ON CONFLICT (container_id) DO UPDATE SET
    vessel_id                  = EXCLUDED.vessel_id,
    stowage_slot               = EXCLUDED.stowage_slot,
    product_name               = EXCLUDED.product_name,
    market_value_usd           = EXCLUDED.market_value_usd,
    insured_value_usd          = EXCLUDED.insured_value_usd,
    gross_weight_kg            = EXCLUDED.gross_weight_kg,
    current_core_temp_c        = 4.60,
    rise_rate_c_per_hr         = 0.00,
    reefer_power_status        = 'POWERED_ACTIVE',
    mkt_degradation_hours_left = 999,
    disposition                = 'IN_TRANSIT',
    updated_at                 = EXCLUDED.updated_at;
END;
$$;

-- Grant execution permission for reset RPC
GRANT EXECUTE ON FUNCTION public.reset_demo_state() TO anon, authenticated;
NOTIFY pgrst, 'reload schema';

-- Execute initial fleet seed
SELECT public.reset_demo_state();
