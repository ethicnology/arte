-- public.file definition

-- Drop table

-- DROP TABLE public.file;

CREATE TABLE public.file (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	created_at timestamptz NOT NULL DEFAULT now(),
	hash text NOT NULL,
	"data" text NOT NULL,
	CONSTRAINT file_hash_check CHECK ((length(hash) = 64)),
	CONSTRAINT file_hash_key UNIQUE (hash),
	CONSTRAINT file_pkey PRIMARY KEY (id)
);


-- Comments

COMMENT ON COLUMN public.file.hash IS 'sha256';
COMMENT ON COLUMN public.file.data IS 'base64 encoded';


-- Permissions

ALTER TABLE public.file OWNER TO supabase_admin;
GRANT ALL ON TABLE public.file TO postgres;
GRANT ALL ON TABLE public.file TO supabase_admin;
GRANT ALL ON TABLE public.file TO anon;
GRANT ALL ON TABLE public.file TO authenticated;
GRANT ALL ON TABLE public.file TO service_role;
