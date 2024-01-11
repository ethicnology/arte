-- public.cover definition

-- Drop table

-- DROP TABLE public.cover;

CREATE TABLE public.cover (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	created_at timestamptz NOT NULL DEFAULT now(),
	id_thing int8 NOT NULL,
	id_lang int2 NOT NULL,
	hash_file text NOT NULL,
	CONSTRAINT cover_pkey PRIMARY KEY (id),
	CONSTRAINT uniq_cover_by_thing_n_hash UNIQUE (id_thing, hash_file),
	CONSTRAINT cover_hash_file_fkey FOREIGN KEY (hash_file) REFERENCES public.file(hash),
	CONSTRAINT cover_id_lang_fkey FOREIGN KEY (id_lang) REFERENCES public."language"(id),
	CONSTRAINT cover_id_thing_fkey FOREIGN KEY (id_thing) REFERENCES public.thing(id)
);

-- Permissions

ALTER TABLE public.cover OWNER TO supabase_admin;
GRANT ALL ON TABLE public.cover TO postgres;
GRANT ALL ON TABLE public.cover TO supabase_admin;
GRANT ALL ON TABLE public.cover TO anon;
GRANT ALL ON TABLE public.cover TO authenticated;
GRANT ALL ON TABLE public.cover TO service_role;


-- Row level security

ALTER TABLE public.cover ENABLE ROW LEVEL SECURITY;
