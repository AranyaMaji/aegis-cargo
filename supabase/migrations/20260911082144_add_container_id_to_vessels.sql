ALTER TABLE public.vessels ADD COLUMN container_id text;
UPDATE public.vessels SET container_id = 'MSKU7734521' WHERE id = 1;
UPDATE public.vessels SET container_id = 'TCLU4419087' WHERE id = 2;
