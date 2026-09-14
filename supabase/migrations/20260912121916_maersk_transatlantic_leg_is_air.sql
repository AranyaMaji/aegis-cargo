-- The trans-Atlantic New York run is flown, not sailed. The console picks its 3D asset
-- from vessel_type, so the `AIR_` prefix is the switch: anything AIR_* renders as a
-- freighter aircraft. Kept in reset_demo_state() so a reset does not put the ship back.
create or replace function public.reset_demo_state()
 returns void
 language plpgsql
 security definer
 set search_path to 'public'
as $function$
declare
  t timestamptz := now();
begin
  -- pg-safeupdate is on for API roles: every statement needs an explicit predicate.
  delete from action_audits where audit_id is not null;
  delete from tactical_incidents where id is not null;

  -- Reset IS the seed. One source of truth for the fleet, so a reset between pitch runs
  -- restores the same three vessels with fresh ETAs rather than stale absolute dates.
  -- Routes are deliberately in three different oceans so their arcs never cross on the
  -- globe and the operator can always tell which vessel they are looking at.
  insert into vessels (imo_number, vessel_name, vessel_type, current_lat, current_lon,
                       heading_deg, speed_knots, status, active_sloc_corridor, itinerary, updated_at)
  values
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
  on conflict (imo_number) do update set
    vessel_name          = excluded.vessel_name,
    vessel_type          = excluded.vessel_type,
    current_lat          = excluded.current_lat,
    current_lon          = excluded.current_lon,
    heading_deg          = excluded.heading_deg,
    speed_knots          = excluded.speed_knots,
    status               = excluded.status,
    active_sloc_corridor = excluded.active_sloc_corridor,
    itinerary            = excluded.itinerary,
    updated_at           = excluded.updated_at;

  -- One consignment per vessel; the console's fleet switcher picks which one is live.
  delete from cargo_consignments
   where container_id not in ('MED-7702', 'BIO-4419', 'CELL-9011');

  insert into cargo_consignments (vessel_id, container_id, stowage_slot, product_name,
    un_dg_code, temp_regime, set_point_c, ceiling_temp_c, current_core_temp_c,
    rise_rate_c_per_hr, market_value_usd, insured_value_usd, salvage_value_usd,
    reefer_power_status, mkt_degradation_hours_left, disposition, gross_weight_kg, updated_at)
  values
    ((select id from vessels where imo_number = '9834521'), 'MED-7702', 'BAY07-R2',
     'Monoclonal Antibody (mAb) Oncology Biologic', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     2400000, 2040000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 4200, t),
    ((select id from vessels where imo_number = '9811000'), 'BIO-4419', 'BAY12-R1',
     'mRNA Vaccine Doses (multi-dose vials)', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     1800000, 1530000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 3100, t),
    ((select id from vessels where imo_number = '9619907'), 'CELL-9011', 'ULD-PMC-04',
     'Autologous Cell Therapy Biologic', 'UN3373', '2-8C', 4.0, 8.0, 4.60, 0.00,
     3100000, 2635000, 0, 'POWERED_ACTIVE', 999, 'IN_TRANSIT', 2600, t)
  on conflict (container_id) do update set
    vessel_id                  = excluded.vessel_id,
    stowage_slot               = excluded.stowage_slot,
    product_name               = excluded.product_name,
    market_value_usd           = excluded.market_value_usd,
    insured_value_usd          = excluded.insured_value_usd,
    gross_weight_kg            = excluded.gross_weight_kg,
    current_core_temp_c        = 4.60,
    rise_rate_c_per_hr         = 0.00,
    reefer_power_status        = 'POWERED_ACTIVE',
    mkt_degradation_hours_left = 999,
    disposition                = 'IN_TRANSIT',
    updated_at                 = excluded.updated_at;
end;
$function$;

select public.reset_demo_state();
