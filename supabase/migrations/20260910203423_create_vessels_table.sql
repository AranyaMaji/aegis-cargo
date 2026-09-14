create table public.vessels (
  id bigint generated always as identity primary key,
  name text not null,
  lat double precision,
  lng double precision,
  status text not null default 'ACTIVE',
  route_geojson jsonb,
  updated_at timestamptz not null default now()
);

insert into public.vessels (name, lat, lng, status) values
  ('MV Ocean Vanguard', 12.6, 43.3, 'ACTIVE'),
  ('MV Star Providence', 14.8, 42.9, 'ACTIVE');
