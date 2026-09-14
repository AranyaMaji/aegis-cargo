create table if not exists public.system_execution_logs (
  id uuid primary key default gen_random_uuid(),
  trace_id text not null,
  vessel_id uuid references public.vessels(id) on delete set null,
  event_source text not null check (event_source in ('HARDWARE_IOT', 'GDACS_POLL', 'RSS_NEWS', 'CONSOLE_INJECT')),
  stage text not null check (stage in ('INGRESS', 'SCHEMA_VALIDATION', 'MKT_OPTIMIZER', 'HITL_DISPATCH', 'MUTATION_COMMITTED')),
  log_level text not null check (log_level in ('INFO', 'WARN', 'ERROR', 'AUDIT')),
  latency_ms integer default 0,
  payload jsonb default '{}'::jsonb,
  error_details jsonb default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_system_execution_logs_trace_id 
  on public.system_execution_logs (trace_id);
create index if not exists idx_system_execution_logs_created_at_desc 
  on public.system_execution_logs (created_at desc);
create index if not exists idx_system_execution_logs_stage 
  on public.system_execution_logs (stage);

alter publication supabase_realtime add table public.system_execution_logs;

alter table public.system_execution_logs enable row level security;

create policy "anon_read_system_execution_logs"
  on public.system_execution_logs for select
  to anon using (true);

create policy "authenticated_read_system_execution_logs"
  on public.system_execution_logs for select
  to authenticated using (true);
