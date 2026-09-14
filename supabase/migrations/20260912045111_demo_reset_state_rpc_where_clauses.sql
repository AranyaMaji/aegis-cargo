create or replace function public.reset_demo_state()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  -- pg-safeupdate is on for API roles: every statement needs an explicit predicate.
  delete from action_audits where audit_id is not null;
  delete from tactical_incidents where id is not null;

  update vessels set
    current_lat = 14.52,
    current_lon = 42.55,
    speed_knots = 18.5,
    heading_deg = 335,
    status      = 'UNDERWAY_TRANSIT',
    updated_at  = now()
  where id is not null;

  update cargo_consignments set
    current_core_temp_c        = 4.60,
    rise_rate_c_per_hr         = 0.00,
    reefer_power_status        = 'POWERED_ACTIVE',
    mkt_degradation_hours_left = 999,
    disposition                = 'IN_TRANSIT',
    updated_at                 = now()
  where id is not null;
end;
$$;
