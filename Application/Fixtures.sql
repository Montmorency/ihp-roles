

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.admin DISABLE TRIGGER ALL;

INSERT INTO public.admin (id, email, password_hash, locked_at, failed_login_attempts, name) VALUES ('dfa04975-2644-419d-a066-1c518122dbfe', 'jerry@gd.com', 'sha256|17|ktNx4UIhKkpor2hN1f5wzA==|tAKTtdnffGim/vbNXNG6yAlXrPMr1aRYkVokkzQ1Mog=', NULL, 0, 'jerry');


ALTER TABLE public.admin ENABLE TRIGGER ALL;


ALTER TABLE public.users DISABLE TRIGGER ALL;

INSERT INTO public.users (id, email, password_hash, locked_at, failed_login_attempts, name) VALUES ('0aae0fcc-a68f-4712-9464-607f0430c20b', 'bob@gd.com', 'sha256|17|izJl7B4JKJFtOvRGBkULdg==|uak5CFGJ9M6vIe/JT17D/khn+phHKsXKhJ8DmSXWhPk=', NULL, 0, 'bob');


ALTER TABLE public.users ENABLE TRIGGER ALL;


