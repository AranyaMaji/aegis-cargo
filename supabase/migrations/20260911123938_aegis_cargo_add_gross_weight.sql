ALTER TABLE public.cargo_consignments ADD COLUMN IF NOT EXISTS gross_weight_kg numeric;
UPDATE public.cargo_consignments SET gross_weight_kg = 4200 WHERE container_id = 'MRKU7654321' AND gross_weight_kg IS NULL;
