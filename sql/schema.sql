/*
 Navicat Premium Data Transfer

 Source Server         : local postgres
 Source Server Type    : PostgreSQL
 Source Server Version : 90204
 Source Host           : localhost
 Source Database       : scrc
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90204
 File Encoding         : utf-8

 Date: 08/06/2013 21:41:22 PM
*/

-- ----------------------------
--  Table structure for episodes
-- ----------------------------
DROP TABLE IF EXISTS "public"."episodes";
CREATE TABLE "public"."episodes" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."episodes" OWNER TO "postgres";

-- ----------------------------
--  Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
	"username" varchar NOT NULL COLLATE "default",
	"password" varchar NOT NULL COLLATE "default",
	"site_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."users" OWNER TO "postgres";

-- ----------------------------
--  Table structure for subpopulations
-- ----------------------------
DROP TABLE IF EXISTS "public"."subpopulations";
CREATE TABLE "public"."subpopulations" (
	"id" int4 NOT NULL,
	"name" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."subpopulations" OWNER TO "postgres";

-- ----------------------------
--  Table structure for sites
-- ----------------------------
DROP TABLE IF EXISTS "public"."sites";
CREATE TABLE "public"."sites" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL COLLATE "default",
	"latitude" float4 NOT NULL,
	"longitude" float4 NOT NULL,
	"image" varchar COLLATE "default",
	"website" varchar COLLATE "default",
	"address" varchar COLLATE "default",
	"state" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."sites" OWNER TO "postgres";

-- ----------------------------
--  Table structure for measures
-- ----------------------------
DROP TABLE IF EXISTS "public"."measures";
CREATE TABLE "public"."measures" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL COLLATE "default",
	"domain_id" int4 NOT NULL,
	"units" varchar COLLATE "default",
	"description" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."measures" OWNER TO "postgres";

-- ----------------------------
--  Table structure for domains
-- ----------------------------
DROP TABLE IF EXISTS "public"."domains";
CREATE TABLE "public"."domains" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL COLLATE "default",
	"is_text_only" bool NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."domains" OWNER TO "postgres";

-- ----------------------------
--  Table structure for departments
-- ----------------------------
DROP TABLE IF EXISTS "public"."departments";
CREATE TABLE "public"."departments" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."departments" OWNER TO "postgres";

-- ----------------------------
--  Table structure for drg_statistics
-- ----------------------------
DROP TABLE IF EXISTS "public"."drg_statistics";
CREATE TABLE "public"."drg_statistics" (
	"id" int4 NOT NULL,
	"measure_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."drg_statistics" OWNER TO "postgres";

-- ----------------------------
--  Table structure for drgs
-- ----------------------------
DROP TABLE IF EXISTS "public"."drgs";
CREATE TABLE "public"."drgs" (
	"id" int4 NOT NULL,
	"name" varchar(255) NOT NULL COLLATE "default",
	"service" varchar(255) NOT NULL COLLATE "default",
	"description" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."drgs" OWNER TO "postgres";

-- ----------------------------
--  Table structure for quick_statistics
-- ----------------------------
DROP TABLE IF EXISTS "public"."quick_statistics";
CREATE TABLE "public"."quick_statistics" (
	"id" int4 NOT NULL,
	"measure_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."quick_statistics" OWNER TO "postgres";

-- ----------------------------
--  Table structure for data
-- ----------------------------
DROP TABLE IF EXISTS "public"."data";
CREATE TABLE "public"."data" (
	"id" int4 NOT NULL,
	"site_id" int4 NOT NULL,
	"drg_id" int4 NOT NULL,
	"subpopulation_id" int4 NOT NULL,
	"measure_id" int4 NOT NULL,
	"year" int4 NOT NULL DEFAULT 2013,
	"quarter" int4 NOT NULL DEFAULT 1,
	"value" float4 NOT NULL,
	"upper_bound" float4 NOT NULL,
	"lower_bound" float4 NOT NULL,
	"episode_id" int4 NOT NULL,
	"department_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."data" OWNER TO "postgres";

COMMENT ON COLUMN "public"."data"."year" IS 'Year Number';
COMMENT ON COLUMN "public"."data"."quarter" IS 'Quarter number: 1,2,3,4';

-- ----------------------------
--  Table structure for summaries
-- ----------------------------
DROP TABLE IF EXISTS "public"."summaries";
CREATE TABLE "public"."summaries" (
	"id" int4 NOT NULL,
	"summary" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."summaries" OWNER TO "postgres";

-- ----------------------------
--  View structure for by_site_measure_year_quarter
-- ----------------------------
DROP VIEW IF EXISTS "public"."by_site_measure_year_quarter";
CREATE VIEW "public"."by_site_measure_year_quarter" AS SELECT data.site_id, data.measure_id, data.year, data.quarter, sum(data.value) AS total_value FROM data GROUP BY data.site_id, data.measure_id, data.year, data.quarter ORDER BY data.site_id, data.measure_id, data.year, data.quarter;

-- ----------------------------
--  View structure for by_drg_statistics
-- ----------------------------
DROP VIEW IF EXISTS "public"."by_drg_statistics";
CREATE VIEW "public"."by_drg_statistics" AS SELECT drg.id, drg.measure_id, m.name, m.domain_id, m.units, m.description, dm.name AS domain FROM ((drg_statistics drg JOIN measures m ON ((drg.measure_id = m.id))) JOIN domains dm ON ((dm.id = m.domain_id)));

-- ----------------------------
--  View structure for by_site_id_drg_id_subpopulation_year_quarter
-- ----------------------------
DROP VIEW IF EXISTS "public"."by_site_id_drg_id_subpopulation_year_quarter";
CREATE VIEW "public"."by_site_id_drg_id_subpopulation_year_quarter" AS SELECT data.site_id, data.drg_id, data.subpopulation_id, data.measure_id, data.year, data.quarter, sum(data.value) AS total_value FROM data GROUP BY data.site_id, data.drg_id, data.subpopulation_id, data.measure_id, data.year, data.quarter ORDER BY data.site_id, data.drg_id, data.subpopulation_id, data.measure_id, data.year, data.quarter;

-- ----------------------------
--  View structure for years
-- ----------------------------
DROP VIEW IF EXISTS "public"."years";
CREATE VIEW "public"."years" AS SELECT DISTINCT data.year FROM data ORDER BY data.year;

-- ----------------------------
--  View structure for tap_funky
-- ----------------------------
DROP VIEW IF EXISTS "public"."tap_funky";
CREATE VIEW "public"."tap_funky" AS SELECT p.oid, n.nspname AS schema, p.proname AS name, pg_get_userbyid(p.proowner) AS owner, array_to_string((p.proargtypes)::regtype[], ','::text) AS args, (CASE p.proretset WHEN true THEN 'setof '::text ELSE ''::text END || (p.prorettype)::regtype) AS returns, p.prolang AS langoid, p.proisstrict AS is_strict, p.proisagg AS is_agg, p.prosecdef AS is_definer, p.proretset AS returns_set, (p.provolatile)::character(1) AS volatility, pg_function_is_visible(p.oid) AS is_visible FROM (pg_proc p JOIN pg_namespace n ON ((p.pronamespace = n.oid)));

-- ----------------------------
--  View structure for joined_quick_statistics
-- ----------------------------
DROP VIEW IF EXISTS "public"."joined_quick_statistics";
CREATE VIEW "public"."joined_quick_statistics" AS SELECT m.id, m.name, m.domain_id, m.units, m.description, dm.name AS domain FROM ((quick_statistics q JOIN measures m ON ((q.measure_id = m.id))) JOIN domains dm ON ((dm.id = m.domain_id)));

-- ----------------------------
--  View structure for joined_drg_statistics
-- ----------------------------
DROP VIEW IF EXISTS "public"."joined_drg_statistics";
CREATE VIEW "public"."joined_drg_statistics" AS SELECT m.id, m.name, m.domain_id, m.units, m.description, dm.name AS domain FROM ((drg_statistics drg JOIN measures m ON ((drg.measure_id = m.id))) JOIN domains dm ON ((dm.id = m.domain_id)));

-- ----------------------------
--  View structure for transitional_care_data
-- ----------------------------
DROP VIEW IF EXISTS "public"."transitional_care_data";
CREATE VIEW "public"."transitional_care_data" AS SELECT data.id, data.site_id, data.department_id, data.measure_id, data.year, data.quarter, data.value FROM data WHERE (((((data.department_id <> 0) AND (data.drg_id = 0)) AND (data.episode_id = 0)) AND (data.subpopulation_id = 0)) AND ((((data.measure_id = 4) OR (data.measure_id = 5)) OR (data.measure_id = 6)) OR (data.measure_id = 7))) ORDER BY data.site_id, data.department_id, data.measure_id, data.year DESC, data.quarter DESC;

-- ----------------------------
--  View structure for measures_run_data
-- ----------------------------
DROP VIEW IF EXISTS "public"."measures_run_data";
CREATE VIEW "public"."measures_run_data" AS SELECT data.id, data.site_id, data.measure_id, data.year, data.quarter, data.value FROM data WHERE ((((data.department_id = 0) AND (data.drg_id = 0)) AND (data.episode_id = 0)) AND (data.subpopulation_id = 0)) ORDER BY data.site_id, data.measure_id, data.year DESC, data.quarter DESC;

-- ----------------------------
--  View structure for drgs_run_data
-- ----------------------------
DROP VIEW IF EXISTS "public"."drgs_run_data";
CREATE VIEW "public"."drgs_run_data" AS SELECT data.id, data.site_id, data.drg_id, data.measure_id, data.subpopulation_id, data.year, data.quarter, data.value FROM data WHERE ((((data.department_id = 0) AND (data.drg_id <> 0)) AND (data.episode_id = 0)) AND (data.subpopulation_id <> 0)) ORDER BY data.site_id, data.drg_id, data.measure_id, data.subpopulation_id, data.year, data.quarter;

-- ----------------------------
--  View structure for drgs_benchmark_data
-- ----------------------------
DROP VIEW IF EXISTS "public"."drgs_benchmark_data";
CREATE VIEW "public"."drgs_benchmark_data" AS SELECT data.id, data.site_id, data.drg_id, data.measure_id, data.subpopulation_id, data.year, data.quarter, data.episode_id, data.value FROM data WHERE ((((data.department_id = 0) AND (data.drg_id <> 0)) AND (data.subpopulation_id <> 0)) AND (data.episode_id <> 0)) ORDER BY data.site_id, data.drg_id, data.measure_id, data.subpopulation_id, data.year, data.quarter, data.episode_id;

-- ----------------------------
--  Function structure for public.has_relation(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_relation"(name);
CREATE FUNCTION "public"."has_relation"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_relation( $1, 'Relation ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_relation"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_relation(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_relation"(name, name, text);
CREATE FUNCTION "public"."hasnt_relation"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _relexists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_relation"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.create_test_session()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."create_test_session"();
CREATE FUNCTION "public"."create_test_session"() RETURNS "text" 
	AS $BODY$
	declare
		sessionid		text;
	begin
		select into sessionid new_session_id();
		perform web.set_session_data(sessionid, md5(random()::text),
			now() + interval '1 day');
		return sessionid;
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."create_test_session"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_schema()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_schema"();
CREATE FUNCTION "public"."test_web_schema"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next has_schema('web', 'There should be a web sessions schema.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_schema"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_table()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_table"();
CREATE FUNCTION "public"."test_web_session_table"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next has_table('web', 'session', 'There should be a session table.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_table"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_id_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_id_exists"();
CREATE FUNCTION "public"."test_web_session_id_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_column('web', 'session', 'sess_id', 'Needs to have a session id column.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_id_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_id_type()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_id_type"();
CREATE FUNCTION "public"."test_web_session_id_type"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next col_type_is('web', 'session', 'sess_id', 'text', 'Session id is a string.');
	end; 
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_id_type"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_id_is_pk()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_id_is_pk"();
CREATE FUNCTION "public"."test_web_session_id_is_pk"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next col_is_pk('web', 'session', 'sess_id', 'The session id is the primary key');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_id_is_pk"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_data_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_data_exists"();
CREATE FUNCTION "public"."test_web_session_data_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_column('web', 'session', 'sess_data', 'Needs to store the session data.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_data_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_data_type()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_data_type"();
CREATE FUNCTION "public"."test_web_session_data_type"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next col_type_is('web', 'session', 'sess_data', 'text', 'Session data is text.');
	end; 
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_data_type"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_expiration_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_expiration_exists"();
CREATE FUNCTION "public"."test_web_session_expiration_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_column('web', 'session', 'expiration', 'Needs a time limit on the session.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_expiration_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_expiration_type()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_expiration_type"();
CREATE FUNCTION "public"."test_web_session_expiration_type"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next col_type_is('web', 'session', 'expiration', 'timestamp with time zone', 'expiration needs to be a timestamp.');
	end; 
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_expiration_type"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_expiration_default()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_expiration_default"();
CREATE FUNCTION "public"."test_web_session_expiration_default"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next col_default_is('web', 'session', 'expiration', $a$(now() + '1 day'::interval)$a$, 'Default expiration is on day.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_expiration_default"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_session_expiration_has_index()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_session_expiration_has_index"();
CREATE FUNCTION "public"."test_web_session_expiration_has_index"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next has_index('web', 'session', 'expire_idx', array['expiration'], 'Needs an index for the expiration column.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_session_expiration_has_index"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_setsessiondata_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_setsessiondata_exists"();
CREATE FUNCTION "public"."test_web_function_setsessiondata_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'set_session_data', array['text', 'text', 'timestamp with time zone'], 'Needs a set session data function.');
		return next is_definer('web', 'set_session_data', array['text', 'text', 'timestamp with time zone'], 'Set session data should have definer security.');
		return next function_returns('web', 'set_session_data', array['text', 'text', 'timestamp with time zone'], 'void', 'Set session data should not return anything.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_setsessiondata_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_setsessiondata_save_data()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_setsessiondata_save_data"();
CREATE FUNCTION "public"."test_web_function_setsessiondata_save_data"() RETURNS SETOF "text" 
	AS $BODY$
	declare
		sessionid		text;
		sessiondata		text;
	begin
		select into sessionid new_session_id();
		select md5(random()::text) into sessiondata;
		perform web.set_session_data(sessionid, sessiondata, null);
		return next results_eq(
			$$select web.get_session_data('$$ || sessionid || $$')$$,
			$$values ('$$ || sessiondata || $$')$$,
			'The set_session_data should create a new session.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_setsessiondata_save_data"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_deleteexpired_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_deleteexpired_exists"();
CREATE FUNCTION "public"."test_web_function_deleteexpired_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'remove_expired', 'Needs a function to delete expired records.');
		return next is_definer('web', 'remove_expired', 'Delete expired should have definer security.');
		return next function_returns('web', 'remove_expired', 'trigger', 'Delete expired data should return a trigger.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_deleteexpired_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.pg_version()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_version"();
CREATE FUNCTION "public"."pg_version"() RETURNS "text" 
	AS $BODY$SELECT current_setting('server_version')$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."pg_version"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_destroysession_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_destroysession_exists"();
CREATE FUNCTION "public"."test_web_function_destroysession_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'destroy_session', array['text'], 'Needs to have a destroy function.');
		return next is_definer('web', 'destroy_session', array['text'], 'Session destroy should have definer security.');
		return next function_returns('web', 'destroy_session', array['text'], 'void', 'Session destroy should not return anything.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_destroysession_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_destroysession_removes_data()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_destroysession_removes_data"();
CREATE FUNCTION "public"."test_web_function_destroysession_removes_data"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
	begin
		select into sessionid create_test_session from create_test_session();
		perform web.destroy_session(sessionid);
		return next is_empty(
			$$select web.get_session_data('$$ || sessionid || $$')$$,
			'Session destroy should delete the session');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_destroysession_removes_data"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_getsessiondata_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_getsessiondata_exists"();
CREATE FUNCTION "public"."test_web_function_getsessiondata_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'get_session_data', array['text'], 'Needs a get_session_data function.');
		return next is_definer('web', 'get_session_data', array['text'], 'Get session data should have definer security.');
		return next function_returns('web', 'get_session_data', array['text'], 'setof text', 'Get session data should not return anything.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_getsessiondata_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_getsessiondata_data()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_getsessiondata_data"();
CREATE FUNCTION "public"."test_web_function_getsessiondata_data"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
		sessiondata			text:=md5(random()::text);
	begin
		select into sessionid create_test_session from create_test_session();
		perform web.set_session_data(sessionid, sessiondata, null);
		return next results_eq(
			$$select web.get_session_data('$$ || sessionid || $$')$$,
			$$values ('$$ || sessiondata || $$')$$,
			'Get session data should retrieve the data from the session.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_getsessiondata_data"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_getsessiondata_ignores_expired()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_getsessiondata_ignores_expired"();
CREATE FUNCTION "public"."test_web_function_getsessiondata_ignores_expired"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
		sessiondata			text:=md5(random()::text);
	begin
		select into sessionid create_test_session
			from create_test_session();
		perform web.set_session_data(sessionid, sessiondata, now() - interval '1 day');
		return next is_empty(
			$$select web.get_session_data('$$ || sessionid || $$')$$,
			'Get session data ignores expired sessions.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_getsessiondata_ignores_expired"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_clearsessions_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_clearsessions_exists"();
CREATE FUNCTION "public"."test_web_function_clearsessions_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'clear_sessions', 'Needs a clear function.');
		return next is_definer('web', 'clear_sessions', 'Clear sessions should have definer security.');
		return next function_returns('web', 'clear_sessions', 'void', 'Clear sessions data should not return anything.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_clearsessions_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_clearsessions_removes_data()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_clearsessions_removes_data"();
CREATE FUNCTION "public"."test_web_function_clearsessions_removes_data"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		perform create_test_session();
		perform create_test_session();
		perform web.clear_sessions();
		return next is_empty(
			$$select * from web.session$$,
			'Clear sessions should remove all sessions.');
	end;  
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_clearsessions_removes_data"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_countsessions_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_countsessions_exists"();
CREATE FUNCTION "public"."test_web_function_countsessions_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_function('web', 'count_sessions', 'Needs a count for the length function.'); 
		return next is_definer('web', 'count_sessions', 'Count sessions should have definer security.');
		return next function_returns('web', 'count_sessions', 'integer', 'Should return the number of active sessions.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_countsessions_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_countsessions_returns_count()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_countsessions_returns_count"();
CREATE FUNCTION "public"."test_web_function_countsessions_returns_count"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		perform create_test_session();
		perform create_test_session();
		perform create_test_session();
		perform create_test_session();
		return next results_eq(
			'select web.count_sessions()',
			'values (4)',
			'Count should return the number of sessions open.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_countsessions_returns_count"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_countsessions_counts_nulls()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_countsessions_counts_nulls"();
CREATE FUNCTION "public"."test_web_function_countsessions_counts_nulls"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
		sessiondata			text:=md5(random()::text);
	begin
		select into sessionid create_test_session
			from create_test_session();
		perform web.set_session_data(sessionid, sessiondata, null);
		perform create_test_session();
		perform create_test_session();
		perform create_test_session();
		return next results_eq(
			'select web.count_sessions()',
			'values (4)',
			'Count should include expire set to null.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_countsessions_counts_nulls"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_trigger_deleteexpired_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_trigger_deleteexpired_exists"();
CREATE FUNCTION "public"."test_web_trigger_deleteexpired_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next trigger_is(
			'web',
			'session',
			'delete_expired_trig',
			'web',
			'remove_expired',
			'Needs a delete expired trigger.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_trigger_deleteexpired_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_deleteexpired_after_insert()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_deleteexpired_after_insert"();
CREATE FUNCTION "public"."test_web_function_deleteexpired_after_insert"() RETURNS SETOF "text" 
	AS $BODY$
	declare
		sessionid		text;
		sessiondata		text;
	begin
		select into sessionid new_session_id();
		select md5(random()::text) into sessiondata;
		perform web.set_session_data(sessionid, sessiondata, now() - interval '1 day');
		return next is_empty(
			$$select * from web.session 
				where sess_id = '$$ || sessionid || $$'$$,
				'Expired sessions should be deleted after insert.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_deleteexpired_after_insert"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_deleteexpired_after_update()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_deleteexpired_after_update"();
CREATE FUNCTION "public"."test_web_function_deleteexpired_after_update"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
		sessiondata			text:=md5(random()::text);
	begin
		select into sessionid create_test_session
			from create_test_session();
		perform web.set_session_data(sessionid, sessiondata, now() - interval '1 day');
		return next is_empty(
			$$select * from web.session 
				where sess_id = '$$ || sessionid || $$'$$,
				'Expired sessions should be deleted after update.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_deleteexpired_after_update"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.pg_version_num()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_version_num"();
CREATE FUNCTION "public"."pg_version_num"() RETURNS "int4" 
	AS $BODY$
    SELECT s.a[1]::int * 10000
           + COALESCE(substring(s.a[2] FROM '[[:digit:]]+')::int, 0) * 100
           + COALESCE(substring(s.a[3] FROM '[[:digit:]]+')::int, 0)
      FROM (
          SELECT string_to_array(current_setting('server_version'), '.') AS a
      ) AS s;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."pg_version_num"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.os_name()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."os_name"();
CREATE FUNCTION "public"."os_name"() RETURNS "text" 
	AS $BODY$SELECT 'darwin'::text;$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."os_name"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.pgtap_version()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgtap_version"();
CREATE FUNCTION "public"."pgtap_version"() RETURNS "numeric" 
	AS $BODY$SELECT 0.94;$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."pgtap_version"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.plan(int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."plan"(int4);
CREATE FUNCTION "public"."plan"(IN int4) RETURNS "text" 
	AS $BODY$
DECLARE
    rcount INTEGER;
BEGIN
    BEGIN
        EXECUTE '
            CREATE TEMP SEQUENCE __tcache___id_seq;
            CREATE TEMP TABLE __tcache__ (
                id    INTEGER NOT NULL DEFAULT nextval(''__tcache___id_seq''),
                label TEXT    NOT NULL,
                value INTEGER NOT NULL,
                note  TEXT    NOT NULL DEFAULT ''''
            );
            CREATE UNIQUE INDEX __tcache___key ON __tcache__(id);
            GRANT ALL ON TABLE __tcache__ TO PUBLIC;
            GRANT ALL ON TABLE __tcache___id_seq TO PUBLIC;

            CREATE TEMP SEQUENCE __tresults___numb_seq;
            CREATE TEMP TABLE __tresults__ (
                numb   INTEGER NOT NULL DEFAULT nextval(''__tresults___numb_seq''),
                ok     BOOLEAN NOT NULL DEFAULT TRUE,
                aok    BOOLEAN NOT NULL DEFAULT TRUE,
                descr  TEXT    NOT NULL DEFAULT '''',
                type   TEXT    NOT NULL DEFAULT '''',
                reason TEXT    NOT NULL DEFAULT ''''
            );
            CREATE UNIQUE INDEX __tresults___key ON __tresults__(numb);
            GRANT ALL ON TABLE __tresults__ TO PUBLIC;
            GRANT ALL ON TABLE __tresults___numb_seq TO PUBLIC;
        ';

    EXCEPTION WHEN duplicate_table THEN
        -- Raise an exception if there's already a plan.
        EXECUTE 'SELECT TRUE FROM __tcache__ WHERE label = ''plan''';
      GET DIAGNOSTICS rcount = ROW_COUNT;
        IF rcount > 0 THEN
           RAISE EXCEPTION 'You tried to plan twice!';
        END IF;
    END;

    -- Save the plan and return.
    PERFORM _set('plan', $1 );
    RETURN '1..' || $1;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."plan"(IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.no_plan()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."no_plan"();
CREATE FUNCTION "public"."no_plan"() RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM plan(0);
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."no_plan"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get"(text);
CREATE FUNCTION "public"."_get"(IN text) RETURNS "int4" 
	AS $BODY$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT value FROM __tcache__ WHERE label = ' || quote_literal($1) || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_latest(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_latest"(text);
CREATE FUNCTION "public"."_get_latest"(IN text) RETURNS "_int4" 
	AS $BODY$
DECLARE
    ret integer[];
BEGIN
    EXECUTE 'SELECT ARRAY[ id, value] FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ' AND id = (SELECT MAX(id) FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ') LIMIT 1' INTO ret;
    RETURN ret;
EXCEPTION WHEN undefined_table THEN
   RAISE EXCEPTION 'You tried to run a test without a plan! Gotta have a plan';
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_latest"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_latest(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_latest"(text, int4);
CREATE FUNCTION "public"."_get_latest"(IN text, IN int4) RETURNS "int4" 
	AS $BODY$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT MAX(id) FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ' AND value = ' || $2 INTO ret;
    RETURN ret;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_latest"(IN text, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_note(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_note"(text);
CREATE FUNCTION "public"."_get_note"(IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    ret text;
BEGIN
    EXECUTE 'SELECT note FROM __tcache__ WHERE label = ' || quote_literal($1) || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_note"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_note(int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_note"(int4);
CREATE FUNCTION "public"."_get_note"(IN int4) RETURNS "text" 
	AS $BODY$
DECLARE
    ret text;
BEGIN
    EXECUTE 'SELECT note FROM __tcache__ WHERE id = ' || $1 || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_note"(IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._set(text, int4, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_set"(text, int4, text);
CREATE FUNCTION "public"."_set"(IN text, IN int4, IN text) RETURNS "int4" 
	AS $BODY$
DECLARE
    rcount integer;
BEGIN
    EXECUTE 'UPDATE __tcache__ SET value = ' || $2
        || CASE WHEN $3 IS NULL THEN '' ELSE ', note = ' || quote_literal($3) END
        || ' WHERE label = ' || quote_literal($1);
    GET DIAGNOSTICS rcount = ROW_COUNT;
    IF rcount = 0 THEN
       RETURN _add( $1, $2, $3 );
    END IF;
    RETURN $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_set"(IN text, IN int4, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._set(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_set"(text, int4);
CREATE FUNCTION "public"."_set"(IN text, IN int4) RETURNS "int4" 
	AS $BODY$
    SELECT _set($1, $2, '')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_set"(IN text, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_user_exists()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_user_exists"();
CREATE FUNCTION "public"."test_web_user_exists"() RETURNS SETOF "text" 
	AS $BODY$
	begin 
		return next has_user('nodepg', 'Needs to have the nodepg user.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_user_exists"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._set(int4, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_set"(int4, int4);
CREATE FUNCTION "public"."_set"(IN int4, IN int4) RETURNS "int4" 
	AS $BODY$
BEGIN
    EXECUTE 'UPDATE __tcache__ SET value = ' || $2
        || ' WHERE id = ' || $1;
    RETURN $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_set"(IN int4, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._add(text, int4, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_add"(text, int4, text);
CREATE FUNCTION "public"."_add"(IN text, IN int4, IN text) RETURNS "int4" 
	AS $BODY$
BEGIN
    EXECUTE 'INSERT INTO __tcache__ (label, value, note) values (' ||
    quote_literal($1) || ', ' || $2 || ', ' || quote_literal(COALESCE($3, '')) || ')';
    RETURN $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_add"(IN text, IN int4, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._add(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_add"(text, int4);
CREATE FUNCTION "public"."_add"(IN text, IN int4) RETURNS "int4" 
	AS $BODY$
    SELECT _add($1, $2, '')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_add"(IN text, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.add_result(bool, bool, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."add_result"(bool, bool, text, text, text);
CREATE FUNCTION "public"."add_result"(IN bool, IN bool, IN text, IN text, IN text) RETURNS "int4" 
	AS $BODY$
BEGIN
    EXECUTE 'INSERT INTO __tresults__ ( ok, aok, descr, type, reason )
    VALUES( ' || $1 || ', '
              || $2 || ', '
              || quote_literal(COALESCE($3, '')) || ', '
              || quote_literal($4) || ', '
              || quote_literal($5) || ' )';
    RETURN currval('__tresults___numb_seq');
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."add_result"(IN bool, IN bool, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.num_failed()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."num_failed"();
CREATE FUNCTION "public"."num_failed"() RETURNS "int4" 
	AS $BODY$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT COUNT(*)::INTEGER FROM __tresults__ WHERE ok = FALSE' INTO ret;
    RETURN ret;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."num_failed"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._unalike(bool, anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_unalike"(bool, anyelement, text, text);
CREATE FUNCTION "public"."_unalike"(IN bool, IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    result ALIAS FOR $1;
    got    ALIAS FOR $2;
    rx     ALIAS FOR $3;
    descr  ALIAS FOR $4;
    output TEXT;
BEGIN
    output := ok( result, descr );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '                  ' || COALESCE( quote_literal(got), 'NULL' ) ||
        E'\n         matches: ' || COALESCE( quote_literal(rx), 'NULL' )
    ) END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_unalike"(IN bool, IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.doesnt_match(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."doesnt_match"(anyelement, text, text);
CREATE FUNCTION "public"."doesnt_match"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~ $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."doesnt_match"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._finish(int4, int4, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_finish"(int4, int4, int4);
CREATE FUNCTION "public"."_finish"(IN int4, IN int4, IN int4) RETURNS SETOF "text" 
	AS $BODY$
DECLARE
    curr_test ALIAS FOR $1;
    exp_tests INTEGER := $2;
    num_faild ALIAS FOR $3;
    plural    CHAR;
BEGIN
    plural    := CASE exp_tests WHEN 1 THEN '' ELSE 's' END;

    IF curr_test IS NULL THEN
        RAISE EXCEPTION '# No tests run!';
    END IF;

    IF exp_tests = 0 OR exp_tests IS NULL THEN
         -- No plan. Output one now.
        exp_tests = curr_test;
        RETURN NEXT '1..' || exp_tests;
    END IF;

    IF curr_test <> exp_tests THEN
        RETURN NEXT diag(
            'Looks like you planned ' || exp_tests || ' test' ||
            plural || ' but ran ' || curr_test
        );
    ELSIF num_faild > 0 THEN
        RETURN NEXT diag(
            'Looks like you failed ' || num_faild || ' test' ||
            CASE num_faild WHEN 1 THEN '' ELSE 's' END
            || ' of ' || exp_tests
        );
    ELSE

    END IF;
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_finish"(IN int4, IN int4, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.finish()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."finish"();
CREATE FUNCTION "public"."finish"() RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _finish(
        _get('curr_test'),
        _get('plan'),
        num_failed()
    );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."finish"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.diag(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."diag"(text);
CREATE FUNCTION "public"."diag"(IN msg text) RETURNS "text" 
	AS $BODY$
    SELECT '# ' || replace(
       replace(
            replace( $1, E'\r\n', E'\n# ' ),
            E'\n',
            E'\n# '
        ),
        E'\r',
        E'\n# '
    );
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."diag"(IN msg text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.diag(anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."diag"(anyelement);
CREATE FUNCTION "public"."diag"(IN msg anyelement) RETURNS "text" 
	AS $BODY$
    SELECT diag($1::text);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."diag"(IN msg anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.ok(bool, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ok"(bool, text);
CREATE FUNCTION "public"."ok"(IN bool, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
   aok      ALIAS FOR $1;
   descr    text := $2;
   test_num INTEGER;
   todo_why TEXT;
   ok       BOOL;
BEGIN
   todo_why := _todo();
   ok       := CASE
       WHEN aok = TRUE THEN aok
       WHEN todo_why IS NULL THEN COALESCE(aok, false)
       ELSE TRUE
    END;
    IF _get('plan') IS NULL THEN
        RAISE EXCEPTION 'You tried to run a test without a plan! Gotta have a plan';
    END IF;

    test_num := add_result(
        ok,
        COALESCE(aok, false),
        descr,
        CASE WHEN todo_why IS NULL THEN '' ELSE 'todo' END,
        COALESCE(todo_why, '')
    );

    RETURN (CASE aok WHEN TRUE THEN '' ELSE 'not ' END)
           || 'ok ' || _set( 'curr_test', test_num )
           || CASE descr WHEN '' THEN '' ELSE COALESCE( ' - ' || substr(diag( descr ), 3), '' ) END
           || COALESCE( ' ' || diag( 'TODO ' || todo_why ), '')
           || CASE aok WHEN TRUE THEN '' ELSE E'\n' ||
                diag('Failed ' ||
                CASE WHEN todo_why IS NULL THEN '' ELSE '(TODO) ' END ||
                'test ' || test_num ||
                CASE descr WHEN '' THEN '' ELSE COALESCE(': "' || descr || '"', '') END ) ||
                CASE WHEN aok IS NULL THEN E'\n' || diag('    (test result was NULL)') ELSE '' END
           END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."ok"(IN bool, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.ok(bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ok"(bool);
CREATE FUNCTION "public"."ok"(IN bool) RETURNS "text" 
	AS $BODY$
    SELECT ok( $1, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."ok"(IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is(anyelement, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is"(anyelement, anyelement, text);
CREATE FUNCTION "public"."is"(IN anyelement, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    result BOOLEAN;
    output TEXT;
BEGIN
    -- Would prefer $1 IS NOT DISTINCT FROM, but that's not supported by 8.1.
    result := NOT $1 IS DISTINCT FROM $2;
    output := ok( result, $3 );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '        have: ' || CASE WHEN $1 IS NULL THEN 'NULL' ELSE $1::text END ||
        E'\n        want: ' || CASE WHEN $2 IS NULL THEN 'NULL' ELSE $2::text END
    ) END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is"(IN anyelement, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is(anyelement, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is"(anyelement, anyelement);
CREATE FUNCTION "public"."is"(IN anyelement, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT is( $1, $2, NULL);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is"(IN anyelement, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt(anyelement, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt"(anyelement, anyelement, text);
CREATE FUNCTION "public"."isnt"(IN anyelement, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    result BOOLEAN;
    output TEXT;
BEGIN
    result := $1 IS DISTINCT FROM $2;
    output := ok( result, $3 );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '        have: ' || COALESCE( $1::text, 'NULL' ) ||
        E'\n        want: anything else'
    ) END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt"(IN anyelement, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt(anyelement, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt"(anyelement, anyelement);
CREATE FUNCTION "public"."isnt"(IN anyelement, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT isnt( $1, $2, NULL);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt"(IN anyelement, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo_end()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo_end"();
CREATE FUNCTION "public"."todo_end"() RETURNS SETOF "bool" 
	AS $BODY$
DECLARE
    id integer;
BEGIN
    id := _get_latest( 'todo', -1 );
    IF id IS NULL THEN
        RAISE EXCEPTION 'todo_end() called without todo_start()';
    END IF;
    EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || id;
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo_end"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._alike(bool, anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_alike"(bool, anyelement, text, text);
CREATE FUNCTION "public"."_alike"(IN bool, IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    result ALIAS FOR $1;
    got    ALIAS FOR $2;
    rx     ALIAS FOR $3;
    descr  ALIAS FOR $4;
    output TEXT;
BEGIN
    output := ok( result, descr );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '                  ' || COALESCE( quote_literal(got), 'NULL' ) ||
       E'\n   doesn''t match: ' || COALESCE( quote_literal(rx), 'NULL' )
    ) END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_alike"(IN bool, IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.matches(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."matches"(anyelement, text, text);
CREATE FUNCTION "public"."matches"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~ $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."matches"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.matches(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."matches"(anyelement, text);
CREATE FUNCTION "public"."matches"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~ $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."matches"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.imatches(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."imatches"(anyelement, text, text);
CREATE FUNCTION "public"."imatches"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~* $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."imatches"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.imatches(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."imatches"(anyelement, text);
CREATE FUNCTION "public"."imatches"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~* $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."imatches"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.alike(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."alike"(anyelement, text, text);
CREATE FUNCTION "public"."alike"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~~ $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."alike"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.alike(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."alike"(anyelement, text);
CREATE FUNCTION "public"."alike"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~~ $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."alike"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.ialike(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ialike"(anyelement, text, text);
CREATE FUNCTION "public"."ialike"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~~* $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."ialike"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.ialike(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."ialike"(anyelement, text);
CREATE FUNCTION "public"."ialike"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _alike( $1 ~~* $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."ialike"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.doesnt_match(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."doesnt_match"(anyelement, text);
CREATE FUNCTION "public"."doesnt_match"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~ $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."doesnt_match"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.doesnt_imatch(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."doesnt_imatch"(anyelement, text, text);
CREATE FUNCTION "public"."doesnt_imatch"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~* $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."doesnt_imatch"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.doesnt_imatch(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."doesnt_imatch"(anyelement, text);
CREATE FUNCTION "public"."doesnt_imatch"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~* $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."doesnt_imatch"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.unalike(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."unalike"(anyelement, text, text);
CREATE FUNCTION "public"."unalike"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~~ $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."unalike"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.unalike(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."unalike"(anyelement, text);
CREATE FUNCTION "public"."unalike"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~~ $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."unalike"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.unialike(anyelement, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."unialike"(anyelement, text, text);
CREATE FUNCTION "public"."unialike"(IN anyelement, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~~* $2, $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."unialike"(IN anyelement, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.unialike(anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."unialike"(anyelement, text);
CREATE FUNCTION "public"."unialike"(IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _unalike( $1 !~~* $2, $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."unialike"(IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.cmp_ok(anyelement, text, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cmp_ok"(anyelement, text, anyelement, text);
CREATE FUNCTION "public"."cmp_ok"(IN anyelement, IN text, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have   ALIAS FOR $1;
    op     ALIAS FOR $2;
    want   ALIAS FOR $3;
    descr  ALIAS FOR $4;
    result BOOLEAN;
    output TEXT;
BEGIN
    EXECUTE 'SELECT ' ||
            COALESCE(quote_literal( have ), 'NULL') || '::' || pg_typeof(have) || ' '
            || op || ' ' ||
            COALESCE(quote_literal( want ), 'NULL') || '::' || pg_typeof(want)
       INTO result;
    output := ok( COALESCE(result, FALSE), descr );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '    ' || COALESCE( quote_literal(have), 'NULL' ) ||
           E'\n        ' || op ||
           E'\n    ' || COALESCE( quote_literal(want), 'NULL' )
    ) END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."cmp_ok"(IN anyelement, IN text, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.cmp_ok(anyelement, text, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cmp_ok"(anyelement, text, anyelement);
CREATE FUNCTION "public"."cmp_ok"(IN anyelement, IN text, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT cmp_ok( $1, $2, $3, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."cmp_ok"(IN anyelement, IN text, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.pass(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pass"(text);
CREATE FUNCTION "public"."pass"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( TRUE, $1 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."pass"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.pass()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pass"();
CREATE FUNCTION "public"."pass"() RETURNS "text" 
	AS $BODY$
    SELECT ok( TRUE, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."pass"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fail(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fail"(text);
CREATE FUNCTION "public"."fail"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( FALSE, $1 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fail"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fail()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fail"();
CREATE FUNCTION "public"."fail"() RETURNS "text" 
	AS $BODY$
    SELECT ok( FALSE, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fail"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo"(text, int4);
CREATE FUNCTION "public"."todo"(IN why text, IN how_many int4) RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), COALESCE(why, ''));
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo"(IN why text, IN how_many int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo(int4, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo"(int4, text);
CREATE FUNCTION "public"."todo"(IN how_many int4, IN why text) RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), COALESCE(why, ''));
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo"(IN how_many int4, IN why text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo"(text);
CREATE FUNCTION "public"."todo"(IN why text) RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', 1, COALESCE(why, ''));
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo"(IN why text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo(int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo"(int4);
CREATE FUNCTION "public"."todo"(IN how_many int4) RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), '');
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo"(IN how_many int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo_start(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo_start"(text);
CREATE FUNCTION "public"."todo_start"(IN text) RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', -1, COALESCE($1, ''));
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo_start"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.todo_start()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."todo_start"();
CREATE FUNCTION "public"."todo_start"() RETURNS SETOF "bool" 
	AS $BODY$
BEGIN
    PERFORM _add('todo', -1, '');
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."todo_start"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.in_todo()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."in_todo"();
CREATE FUNCTION "public"."in_todo"() RETURNS "bool" 
	AS $BODY$
DECLARE
    todos integer;
BEGIN
    todos := _get('todo');
    RETURN CASE WHEN todos IS NULL THEN FALSE ELSE TRUE END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."in_todo"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_relation(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_relation"(name, text);
CREATE FUNCTION "public"."has_relation"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _relexists( $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_relation"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._todo()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_todo"();
CREATE FUNCTION "public"."_todo"() RETURNS "text" 
	AS $BODY$
DECLARE
    todos INT[];
    note text;
BEGIN
    -- Get the latest id and value, because todo() might have been called
    -- again before the todos ran out for the first call to todo(). This
    -- allows them to nest.
    todos := _get_latest('todo');
    IF todos IS NULL THEN
        -- No todos.
        RETURN NULL;
    END IF;
    IF todos[2] = 0 THEN
        -- Todos depleted. Clean up.
        EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || todos[1];
        RETURN NULL;
    END IF;
    -- Decrement the count of counted todos and return the reason.
    IF todos[2] <> -1 THEN
        PERFORM _set(todos[1], todos[2] - 1);
    END IF;
    note := _get_note(todos[1]);

    IF todos[2] = 1 THEN
        -- This was the last todo, so delete the record.
        EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || todos[1];
    END IF;

    RETURN note;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_todo"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.skip(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."skip"(text, int4);
CREATE FUNCTION "public"."skip"(IN why text, IN how_many int4) RETURNS "text" 
	AS $BODY$
DECLARE
    output TEXT[];
BEGIN
    output := '{}';
    FOR i IN 1..how_many LOOP
        output = array_append(output, ok( TRUE, 'SKIP: ' || COALESCE( why, '') ) );
    END LOOP;
    RETURN array_to_string(output, E'\n');
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."skip"(IN why text, IN how_many int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.skip(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."skip"(text);
CREATE FUNCTION "public"."skip"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( TRUE, 'SKIP: ' || $1 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."skip"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.skip(int4, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."skip"(int4, text);
CREATE FUNCTION "public"."skip"(IN int4, IN text) RETURNS "text" 
	AS $BODY$SELECT skip($2, $1)$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."skip"(IN int4, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.skip(int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."skip"(int4);
CREATE FUNCTION "public"."skip"(IN int4) RETURNS "text" 
	AS $BODY$SELECT skip(NULL, $1)$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."skip"(IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._query(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_query"(text);
CREATE FUNCTION "public"."_query"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE
        WHEN $1 LIKE '"%' OR $1 !~ '[[:space:]]' THEN 'EXECUTE ' || $1
        ELSE $1
    END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_query"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, bpchar, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, bpchar, text, text);
CREATE FUNCTION "public"."throws_ok"(IN text, IN bpchar, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    query     TEXT := _query($1);
    errcode   ALIAS FOR $2;
    errmsg    ALIAS FOR $3;
    desctext  ALIAS FOR $4;
    descr     TEXT;
BEGIN
    descr := COALESCE(
          desctext,
          'threw ' || errcode || ': ' || errmsg,
          'threw ' || errcode,
          'threw ' || errmsg,
          'threw an exception'
    );
    EXECUTE query;
    RETURN ok( FALSE, descr ) || E'\n' || diag(
           '      caught: no exception' ||
        E'\n      wanted: ' || COALESCE( errcode, 'an exception' )
    );
EXCEPTION WHEN OTHERS THEN
    IF (errcode IS NULL OR SQLSTATE = errcode)
        AND ( errmsg IS NULL OR SQLERRM = errmsg)
    THEN
        -- The expected errcode and/or message was thrown.
        RETURN ok( TRUE, descr );
    ELSE
        -- This was not the expected errcode or errmsg.
        RETURN ok( FALSE, descr ) || E'\n' || diag(
               '      caught: ' || SQLSTATE || ': ' || SQLERRM ||
            E'\n      wanted: ' || COALESCE( errcode, 'an exception' ) ||
            COALESCE( ': ' || errmsg, '')
        );
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN bpchar, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, text, text);
CREATE FUNCTION "public"."throws_ok"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF octet_length($2) = 5 THEN
        RETURN throws_ok( $1, $2::char(5), $3, NULL );
    ELSE
        RETURN throws_ok( $1, NULL, $2, $3 );
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, text);
CREATE FUNCTION "public"."throws_ok"(IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF octet_length($2) = 5 THEN
        RETURN throws_ok( $1, $2::char(5), NULL, NULL );
    ELSE
        RETURN throws_ok( $1, NULL, $2, NULL );
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text);
CREATE FUNCTION "public"."throws_ok"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_ok( $1, NULL, NULL, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, int4, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, int4, text, text);
CREATE FUNCTION "public"."throws_ok"(IN text, IN int4, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_ok( $1, $2::char(5), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN int4, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, int4, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, int4, text);
CREATE FUNCTION "public"."throws_ok"(IN text, IN int4, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_ok( $1, $2::char(5), $3, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN int4, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ok(text, int4)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ok"(text, int4);
CREATE FUNCTION "public"."throws_ok"(IN text, IN int4) RETURNS "text" 
	AS $BODY$
    SELECT throws_ok( $1, $2::char(5), NULL, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ok"(IN text, IN int4) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.lives_ok(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."lives_ok"(text, text);
CREATE FUNCTION "public"."lives_ok"(IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    code  TEXT := _query($1);
    descr ALIAS FOR $2;
BEGIN
    EXECUTE code;
    RETURN ok( TRUE, descr );
EXCEPTION WHEN OTHERS THEN
    -- There should have been no exception.
    RETURN ok( FALSE, descr ) || E'\n' || diag(
           '        died: ' || SQLSTATE || ': ' || SQLERRM
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."lives_ok"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.lives_ok(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."lives_ok"(text);
CREATE FUNCTION "public"."lives_ok"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT lives_ok( $1, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."lives_ok"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.performs_ok(text, numeric, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."performs_ok"(text, numeric, text);
CREATE FUNCTION "public"."performs_ok"(IN text, IN numeric, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    query     TEXT := _query($1);
    max_time  ALIAS FOR $2;
    descr     ALIAS FOR $3;
    starts_at TEXT;
    act_time  NUMERIC;
BEGIN
    starts_at := timeofday();
    EXECUTE query;
    act_time := extract( millisecond from timeofday()::timestamptz - starts_at::timestamptz);
    IF act_time < max_time THEN RETURN ok(TRUE, descr); END IF;
    RETURN ok( FALSE, descr ) || E'\n' || diag(
           '      runtime: ' || act_time || ' ms' ||
        E'\n      exceeds: ' || max_time || ' ms'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."performs_ok"(IN text, IN numeric, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.performs_ok(text, numeric)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."performs_ok"(text, numeric);
CREATE FUNCTION "public"."performs_ok"(IN text, IN numeric) RETURNS "text" 
	AS $BODY$
    SELECT performs_ok(
        $1, $2, 'Should run in less than ' || $2 || ' ms'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."performs_ok"(IN text, IN numeric) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relexists(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relexists"(name, name);
CREATE FUNCTION "public"."_relexists"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE n.nspname = $1
           AND c.relname = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relexists"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relexists(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relexists"(name);
CREATE FUNCTION "public"."_relexists"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_class c
         WHERE pg_catalog.pg_table_is_visible(c.oid)
           AND c.relname = $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relexists"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_relation(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_relation"(name, name, text);
CREATE FUNCTION "public"."has_relation"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _relexists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_relation"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_relation(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_relation"(name, text);
CREATE FUNCTION "public"."hasnt_relation"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _relexists( $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_relation"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_relation(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_relation"(name);
CREATE FUNCTION "public"."hasnt_relation"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_relation( $1, 'Relation ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_relation"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._rexists(bpchar, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_rexists"(bpchar, name, name);
CREATE FUNCTION "public"."_rexists"(IN bpchar, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE c.relkind = $1
           AND n.nspname = $2
           AND c.relname = $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_rexists"(IN bpchar, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._rexists(bpchar, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_rexists"(bpchar, name);
CREATE FUNCTION "public"."_rexists"(IN bpchar, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_class c
         WHERE c.relkind = $1
           AND pg_catalog.pg_table_is_visible(c.oid)
           AND c.relname = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_rexists"(IN bpchar, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_table(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_table"(name, name, text);
CREATE FUNCTION "public"."has_table"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'r', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_table"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_table(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_table"(name, text);
CREATE FUNCTION "public"."has_table"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'r', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_table"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_table(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_table"(name);
CREATE FUNCTION "public"."has_table"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_table( $1, 'Table ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_table"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_table(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_table"(name, name, text);
CREATE FUNCTION "public"."hasnt_table"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'r', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_table"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_table(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_table"(name, text);
CREATE FUNCTION "public"."hasnt_table"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'r', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_table"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_table(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_table"(name);
CREATE FUNCTION "public"."hasnt_table"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_table( $1, 'Table ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_table"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_view(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_view"(name, name, text);
CREATE FUNCTION "public"."has_view"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'v', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_view"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_view(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_view"(name, text);
CREATE FUNCTION "public"."has_view"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'v', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_view"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_view(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_view"(name);
CREATE FUNCTION "public"."has_view"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_view( $1, 'View ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_view"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_view(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_view"(name, name, text);
CREATE FUNCTION "public"."hasnt_view"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'v', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_view"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_view(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_view"(name, text);
CREATE FUNCTION "public"."hasnt_view"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'v', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_view"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_view(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_view"(name);
CREATE FUNCTION "public"."hasnt_view"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_view( $1, 'View ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_view"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_sequence(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_sequence"(name, name, text);
CREATE FUNCTION "public"."has_sequence"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'S', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_sequence"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_sequence(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_sequence"(name, text);
CREATE FUNCTION "public"."has_sequence"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'S', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_sequence"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_sequence(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_sequence"(name);
CREATE FUNCTION "public"."has_sequence"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_sequence( $1, 'Sequence ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_sequence"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_sequence(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_sequence"(name, name, text);
CREATE FUNCTION "public"."hasnt_sequence"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'S', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_sequence"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_sequence(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_sequence"(name, text);
CREATE FUNCTION "public"."hasnt_sequence"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'S', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_sequence"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_sequence(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_sequence"(name);
CREATE FUNCTION "public"."hasnt_sequence"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_sequence( $1, 'Sequence ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_sequence"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_foreign_table(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_foreign_table"(name, name, text);
CREATE FUNCTION "public"."has_foreign_table"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'f', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_foreign_table"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_foreign_table(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_foreign_table"(name, text);
CREATE FUNCTION "public"."has_foreign_table"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'f', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_foreign_table"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_foreign_table(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_foreign_table"(name);
CREATE FUNCTION "public"."has_foreign_table"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_foreign_table( $1, 'Foreign table ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_foreign_table"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_foreign_table(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_foreign_table"(name, name, text);
CREATE FUNCTION "public"."hasnt_foreign_table"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'f', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_foreign_table"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_foreign_table(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_foreign_table"(name, text);
CREATE FUNCTION "public"."hasnt_foreign_table"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'f', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_foreign_table"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_foreign_table(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_foreign_table"(name);
CREATE FUNCTION "public"."hasnt_foreign_table"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_foreign_table( $1, 'Foreign table ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_foreign_table"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_composite(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_composite"(name, name, text);
CREATE FUNCTION "public"."has_composite"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'c', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_composite"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_composite(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_composite"(name, text);
CREATE FUNCTION "public"."has_composite"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _rexists( 'c', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_composite"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_composite(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_composite"(name);
CREATE FUNCTION "public"."has_composite"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_composite( $1, 'Composite type ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_composite"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_composite(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_composite"(name, name, text);
CREATE FUNCTION "public"."hasnt_composite"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'c', $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_composite"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_composite(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_composite"(name, text);
CREATE FUNCTION "public"."hasnt_composite"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _rexists( 'c', $1 ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_composite"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_composite(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_composite"(name);
CREATE FUNCTION "public"."hasnt_composite"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_composite( $1, 'Composite type ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_composite"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cexists(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cexists"(name, name, name);
CREATE FUNCTION "public"."_cexists"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
          JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
         WHERE n.nspname = $1
           AND c.relname = $2
           AND a.attnum > 0
           AND NOT a.attisdropped
           AND a.attname = $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cexists"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cexists(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cexists"(name, name);
CREATE FUNCTION "public"."_cexists"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_class c
          JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
         WHERE c.relname = $1
           AND pg_catalog.pg_table_is_visible(c.oid)
           AND a.attnum > 0
           AND NOT a.attisdropped
           AND a.attname = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cexists"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_column(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_column"(name, name, name, text);
CREATE FUNCTION "public"."has_column"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _cexists( $1, $2, $3 ), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_column"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_column(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_column"(name, name, text);
CREATE FUNCTION "public"."has_column"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _cexists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_column"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_column(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_column"(name, name);
CREATE FUNCTION "public"."has_column"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_column( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_column"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_column(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_column"(name, name, name, text);
CREATE FUNCTION "public"."hasnt_column"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _cexists( $1, $2, $3 ), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_column"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_column(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_column"(name, name, text);
CREATE FUNCTION "public"."hasnt_column"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _cexists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_column"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_column(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_column"(name, name);
CREATE FUNCTION "public"."hasnt_column"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_column( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_column"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._col_is_null(name, name, name, text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_col_is_null"(name, name, name, text, bool);
CREATE FUNCTION "public"."_col_is_null"(IN name, IN name, IN name, IN text, IN bool) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE n.nspname = $1
               AND c.relname = $2
               AND a.attnum  > 0
               AND NOT a.attisdropped
               AND a.attname    = $3
               AND a.attnotnull = $5
        ), $4
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_col_is_null"(IN name, IN name, IN name, IN text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._col_is_null(name, name, text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_col_is_null"(name, name, text, bool);
CREATE FUNCTION "public"."_col_is_null"(IN name, IN name, IN text, IN bool) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE pg_catalog.pg_table_is_visible(c.oid)
               AND c.relname = $1
               AND a.attnum > 0
               AND NOT a.attisdropped
               AND a.attname    = $2
               AND a.attnotnull = $4
        ), $3
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_col_is_null"(IN name, IN name, IN text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_not_null(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_not_null"(name, name, name, text);
CREATE FUNCTION "public"."col_not_null"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, $3, $4, true );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_not_null"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_not_null(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_not_null"(name, name, text);
CREATE FUNCTION "public"."col_not_null"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, $3, true );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_not_null"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_not_null(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_not_null"(name, name);
CREATE FUNCTION "public"."col_not_null"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should be NOT NULL', true );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_not_null"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_null(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_null"(name, name, name, text);
CREATE FUNCTION "public"."col_is_null"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, $3, $4, false );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_null"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_null(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_null"(name, name, name);
CREATE FUNCTION "public"."col_is_null"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, $3, false );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_null"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_null(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_null"(name, name);
CREATE FUNCTION "public"."col_is_null"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT _col_is_null( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should allow NULL', false );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_null"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_col_type(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_col_type"(name, name, name);
CREATE FUNCTION "public"."_get_col_type"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT pg_catalog.format_type(a.atttypid, a.atttypmod)
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c     ON n.oid = c.relnamespace
      JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
     WHERE n.nspname = $1
       AND c.relname = $2
       AND a.attname = $3
       AND attnum    > 0
       AND NOT a.attisdropped
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_col_type"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_col_type(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_col_type"(name, name);
CREATE FUNCTION "public"."_get_col_type"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT pg_catalog.format_type(a.atttypid, a.atttypmod)
      FROM pg_catalog.pg_attribute a
      JOIN pg_catalog.pg_class c ON  a.attrelid = c.oid
     WHERE pg_catalog.pg_table_is_visible(c.oid)
       AND c.relname = $1
       AND a.attname = $2
       AND attnum    > 0
       AND NOT a.attisdropped
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_col_type"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._def_is(text, text, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_def_is"(text, text, anyelement, text);
CREATE FUNCTION "public"."_def_is"(IN text, IN text, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    thing text;
BEGIN
    IF $1 ~ '^[^'']+[(]' THEN
        -- It's a functional default.
        RETURN is( $1, $3, $4 );
    END IF;

    EXECUTE 'SELECT is('
             || COALESCE($1, 'NULL' || '::' || $2) || '::' || $2 || ', '
             || COALESCE(quote_literal($3), 'NULL') || '::' || $2 || ', '
             || COALESCE(quote_literal($4), 'NULL')
    || ')' INTO thing;
    RETURN thing;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_def_is"(IN text, IN text, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_col_ns_type(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_col_ns_type"(name, name, name);
CREATE FUNCTION "public"."_get_col_ns_type"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    -- Always include the namespace.
    SELECT CASE WHEN pg_catalog.pg_type_is_visible(t.oid)
                THEN quote_ident(tn.nspname) || '.'
                ELSE ''
           END || pg_catalog.format_type(a.atttypid, a.atttypmod)
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c      ON n.oid = c.relnamespace
      JOIN pg_catalog.pg_attribute a  ON c.oid = a.attrelid
      JOIN pg_catalog.pg_type t       ON a.atttypid = t.oid
      JOIN pg_catalog.pg_namespace tn ON t.typnamespace = tn.oid
     WHERE n.nspname = $1
       AND c.relname = $2
       AND a.attname = $3
       AND attnum    > 0
       AND NOT a.attisdropped
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_col_ns_type"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._quote_ident_like(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_quote_ident_like"(text, text);
CREATE FUNCTION "public"."_quote_ident_like"(IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have    TEXT;
    pcision TEXT;
BEGIN
    -- Just return it if rhs isn't quoted.
    IF $2 !~ '"' THEN RETURN $1; END IF;

    -- If it's quoted ident without precision, return it quoted.
    IF $2 ~ '"$' THEN RETURN quote_ident($1); END IF;

    pcision := substring($1 FROM '[(][^")]+[)]$');

    -- Just quote it if thre is no precision.
    if pcision IS NULL THEN RETURN quote_ident($1); END IF;

    -- Quote the non-precision part and concatenate with precision.
    RETURN quote_ident(substring($1 FOR char_length($1) - char_length(pcision)))
        || pcision;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_quote_ident_like"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, name, name, text, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have_type TEXT := _get_col_ns_type($1, $2, $3);
    want_type TEXT;
BEGIN
    IF have_type IS NULL THEN
        RETURN fail( $6 ) || E'\n' || diag (
            '   Column ' || COALESCE(quote_ident($1) || '.', '')
            || quote_ident($2) || '.' || quote_ident($3) || ' does not exist'
        );
    END IF;

    want_type := quote_ident($4) || '.' || _quote_ident_like($5, have_type);
    IF have_type = want_type THEN
        -- We're good to go.
        RETURN ok( true, $6 );
    END IF;

    -- Wrong data type. tell 'em what we really got.
    RETURN ok( false, $6 ) || E'\n' || diag(
           '        have: ' || have_type ||
        E'\n        want: ' || want_type
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, name, name, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT col_type_is( $1, $2, $3, $4, $5, 'Column ' || quote_ident($1) || '.' || quote_ident($2)
        || '.' || quote_ident($3) || ' should be type ' || quote_ident($4) || '.' || $5);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, name, text, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have_type TEXT;
    want_type TEXT;
BEGIN
    -- Get the data type.
    IF $1 IS NULL THEN
        have_type := _get_col_type($2, $3);
    ELSE
        have_type := _get_col_type($1, $2, $3);
    END IF;

    IF have_type IS NULL THEN
        RETURN fail( $5 ) || E'\n' || diag (
            '   Column ' || COALESCE(quote_ident($1) || '.', '')
            || quote_ident($2) || '.' || quote_ident($3) || ' does not exist'
        );
    END IF;

    want_type := _quote_ident_like($4, have_type);
    IF have_type = want_type THEN
        -- We're good to go.
        RETURN ok( true, $5 );
    END IF;

    -- Wrong data type. tell 'em what we really got.
    RETURN ok( false, $5 ) || E'\n' || diag(
           '        have: ' || have_type ||
        E'\n        want: ' || want_type
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, name, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT col_type_is( $1, $2, $3, $4, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' should be type ' || $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, text, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT col_type_is( NULL, $1, $2, $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_type_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_type_is"(name, name, text);
CREATE FUNCTION "public"."col_type_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT col_type_is( $1, $2, $3, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should be type ' || $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_type_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_def(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_def"(name, name, name);
CREATE FUNCTION "public"."_has_def"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT a.atthasdef
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
      JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
     WHERE n.nspname = $1
       AND c.relname = $2
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $3
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_def"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_def(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_def"(name, name);
CREATE FUNCTION "public"."_has_def"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT a.atthasdef
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
     WHERE c.relname = $1
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $2
       AND pg_catalog.pg_table_is_visible(c.oid)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_def"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_default(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_default"(name, name, name, text);
CREATE FUNCTION "public"."col_has_default"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok( _has_def( $1, $2, $3 ), $4 );
END
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_default"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_default(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_default"(name, name, text);
CREATE FUNCTION "public"."col_has_default"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok( _has_def( $1, $2 ), $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_default"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_default(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_default"(name, name);
CREATE FUNCTION "public"."col_has_default"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT col_has_default( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should have a default' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_default"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_hasnt_default(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_hasnt_default"(name, name, name, text);
CREATE FUNCTION "public"."col_hasnt_default"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok( NOT _has_def( $1, $2, $3 ), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_hasnt_default"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_hasnt_default(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_hasnt_default"(name, name, text);
CREATE FUNCTION "public"."col_hasnt_default"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok( NOT _has_def( $1, $2 ), $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_hasnt_default"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_hasnt_default(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_hasnt_default"(name, name);
CREATE FUNCTION "public"."col_hasnt_default"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT col_hasnt_default( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should not have a default' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_hasnt_default"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cdi(name, name, name, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cdi"(name, name, name, anyelement, text);
CREATE FUNCTION "public"."_cdi"(IN name, IN name, IN name, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $5 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;

    IF NOT _has_def( $1, $2, $3 ) THEN
        RETURN fail( $5 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' has no default' );
    END IF;

    RETURN _def_is(
        pg_catalog.pg_get_expr(d.adbin, d.adrelid),
        pg_catalog.format_type(a.atttypid, a.atttypmod),
        $4, $5
    )
      FROM pg_catalog.pg_namespace n, pg_catalog.pg_class c, pg_catalog.pg_attribute a,
           pg_catalog.pg_attrdef d
     WHERE n.oid = c.relnamespace
       AND c.oid = a.attrelid
       AND a.atthasdef
       AND a.attrelid = d.adrelid
       AND a.attnum = d.adnum
       AND n.nspname = $1
       AND c.relname = $2
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $3;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cdi"(IN name, IN name, IN name, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cdi(name, name, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cdi"(name, name, anyelement, text);
CREATE FUNCTION "public"."_cdi"(IN name, IN name, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;

    IF NOT _has_def( $1, $2 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' has no default' );
    END IF;

    RETURN _def_is(
        pg_catalog.pg_get_expr(d.adbin, d.adrelid),
        pg_catalog.format_type(a.atttypid, a.atttypmod),
        $3, $4
    )
      FROM pg_catalog.pg_class c, pg_catalog.pg_attribute a, pg_catalog.pg_attrdef d
     WHERE c.oid = a.attrelid
       AND pg_table_is_visible(c.oid)
       AND a.atthasdef
       AND a.attrelid = d.adrelid
       AND a.attnum = d.adnum
       AND c.relname = $1
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cdi"(IN name, IN name, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cdi(name, name, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cdi"(name, name, anyelement);
CREATE FUNCTION "public"."_cdi"(IN name, IN name, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT col_default_is(
        $1, $2, $3,
        'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should default to '
        || COALESCE( quote_literal($3), 'NULL')
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cdi"(IN name, IN name, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, name, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, name, anyelement, text);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN name, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3, $4, $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN name, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, name, text, text);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3, $4, $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, anyelement, text);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, text, text);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, anyelement);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_default_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_default_is"(name, name, text);
CREATE FUNCTION "public"."col_default_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _cdi( $1, $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_default_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._hasc(name, name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_hasc"(name, name, bpchar);
CREATE FUNCTION "public"."_hasc"(IN name, IN name, IN bpchar) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c      ON c.relnamespace = n.oid
              JOIN pg_catalog.pg_constraint x ON c.oid = x.conrelid
             WHERE c.relhaspkey = true
               AND n.nspname = $1
               AND c.relname = $2
               AND x.contype = $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_hasc"(IN name, IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._hasc(name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_hasc"(name, bpchar);
CREATE FUNCTION "public"."_hasc"(IN name, IN bpchar) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
            SELECT true
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_constraint x ON c.oid = x.conrelid
             WHERE c.relhaspkey = true
               AND pg_table_is_visible(c.oid)
               AND c.relname = $1
               AND x.contype = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_hasc"(IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_pk(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_pk"(name, name, text);
CREATE FUNCTION "public"."has_pk"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, $2, 'p' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_pk"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_pk(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_pk"(name, text);
CREATE FUNCTION "public"."has_pk"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, 'p' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_pk"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_pk(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_pk"(name);
CREATE FUNCTION "public"."has_pk"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_pk( $1, 'Table ' || quote_ident($1) || ' should have a primary key' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_pk"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_pk(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_pk"(name, name, text);
CREATE FUNCTION "public"."hasnt_pk"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _hasc( $1, $2, 'p' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_pk"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_pk(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_pk"(name, text);
CREATE FUNCTION "public"."hasnt_pk"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _hasc( $1, 'p' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_pk"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_pk(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_pk"(name);
CREATE FUNCTION "public"."hasnt_pk"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_pk( $1, 'Table ' || quote_ident($1) || ' should not have a primary key' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_pk"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._ident_array_to_string(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_ident_array_to_string"(_name, text);
CREATE FUNCTION "public"."_ident_array_to_string"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT array_to_string(ARRAY(
        SELECT quote_ident($1[i])
          FROM generate_series(1, array_upper($1, 1)) s(i)
         ORDER BY i
    ), $2);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_ident_array_to_string"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._pg_sv_column_array(oid, _int2)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_pg_sv_column_array"(oid, _int2);
CREATE FUNCTION "public"."_pg_sv_column_array"(IN oid, IN _int2) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT a.attname
          FROM pg_catalog.pg_attribute a
          JOIN generate_series(1, array_upper($2, 1)) s(i) ON a.attnum = $2[i]
         WHERE attrelid = $1
         ORDER BY i
    )
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	STABLE;
ALTER FUNCTION "public"."_pg_sv_column_array"(IN oid, IN _int2) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._pg_sv_table_accessible(oid, oid)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_pg_sv_table_accessible"(oid, oid);
CREATE FUNCTION "public"."_pg_sv_table_accessible"(IN oid, IN oid) RETURNS "bool" 
	AS $BODY$
    SELECT CASE WHEN has_schema_privilege($1, 'USAGE') THEN (
                  has_table_privilege($2, 'SELECT')
               OR has_table_privilege($2, 'INSERT')
               or has_table_privilege($2, 'UPDATE')
               OR has_table_privilege($2, 'DELETE')
               OR has_table_privilege($2, 'RULE')
               OR has_table_privilege($2, 'REFERENCES')
               OR has_table_privilege($2, 'TRIGGER')
           ) ELSE FALSE
    END;
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_pg_sv_table_accessible"(IN oid, IN oid) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._keys(name, name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_keys"(name, name, bpchar);
CREATE FUNCTION "public"."_keys"(IN name, IN name, IN bpchar) RETURNS SETOF "_name" 
	AS $BODY$
    SELECT _pg_sv_column_array(x.conrelid,x.conkey)
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c       ON n.oid = c.relnamespace
      JOIN pg_catalog.pg_constraint x  ON c.oid = x.conrelid
     WHERE n.nspname = $1
       AND c.relname = $2
       AND x.contype = $3
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_keys"(IN name, IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._keys(name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_keys"(name, bpchar);
CREATE FUNCTION "public"."_keys"(IN name, IN bpchar) RETURNS SETOF "_name" 
	AS $BODY$
    SELECT _pg_sv_column_array(x.conrelid,x.conkey)
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_constraint x  ON c.oid = x.conrelid
       AND c.relname = $1
       AND x.contype = $2
     WHERE pg_catalog.pg_table_is_visible(c.oid)
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_keys"(IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._ckeys(name, name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_ckeys"(name, name, bpchar);
CREATE FUNCTION "public"."_ckeys"(IN name, IN name, IN bpchar) RETURNS "_name" 
	AS $BODY$
    SELECT * FROM _keys($1, $2, $3) LIMIT 1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_ckeys"(IN name, IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._ckeys(name, bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_ckeys"(name, bpchar);
CREATE FUNCTION "public"."_ckeys"(IN name, IN bpchar) RETURNS "_name" 
	AS $BODY$
    SELECT * FROM _keys($1, $2) LIMIT 1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_ckeys"(IN name, IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_isnt_pk(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_isnt_pk"(name, name, _name, text);
CREATE FUNCTION "public"."col_isnt_pk"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT isnt( _ckeys( $1, $2, 'p' ), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_isnt_pk"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_isnt_pk(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_isnt_pk"(name, _name, text);
CREATE FUNCTION "public"."col_isnt_pk"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT isnt( _ckeys( $1, 'p' ), $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_isnt_pk"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_isnt_pk(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_isnt_pk"(name, _name);
CREATE FUNCTION "public"."col_isnt_pk"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT col_isnt_pk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should not be a primary key' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_isnt_pk"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_fk(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_fk"(name, name, text);
CREATE FUNCTION "public"."has_fk"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, $2, 'f' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_fk"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_fk(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_fk"(name, text);
CREATE FUNCTION "public"."has_fk"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, 'f' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_fk"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_fk(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_fk"(name);
CREATE FUNCTION "public"."has_fk"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_fk( $1, 'Table ' || quote_ident($1) || ' should have a foreign key constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_fk"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_fk(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_fk"(name, name, text);
CREATE FUNCTION "public"."hasnt_fk"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _hasc( $1, $2, 'f' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_fk"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_fk(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_fk"(name, text);
CREATE FUNCTION "public"."hasnt_fk"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _hasc( $1, 'f' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_fk"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_fk(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_fk"(name);
CREATE FUNCTION "public"."hasnt_fk"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_fk( $1, 'Table ' || quote_ident($1) || ' should not have a foreign key constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_fk"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_fk(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_fk"(name, name, _name, text);
CREATE FUNCTION "public"."col_is_fk"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    names text[];
BEGIN
    IF _fkexists($1, $2, $3) THEN
        RETURN pass( $4 );
    END IF;

    -- Try to show the columns.
    SELECT ARRAY(
        SELECT _ident_array_to_string(fk_columns, ', ')
          FROM pg_all_foreign_keys
         WHERE fk_schema_name = $1
           AND fk_table_name  = $2
         ORDER BY fk_columns
    ) INTO names;

    IF names[1] IS NOT NULL THEN
        RETURN fail($4) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || E' has foreign key constraints on these columns:\n        '
            ||  array_to_string( names, E'\n        ' )
        );
    END IF;

    -- No FKs in this table.
    RETURN fail($4) || E'\n' || diag(
        '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' has no foreign key columns'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_fk"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_check(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_check"(name, name, _name, text);
CREATE FUNCTION "public"."col_has_check"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _constraint( $1, $2, 'c', $3, $4, 'check' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_check"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_check(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_check"(name, _name, text);
CREATE FUNCTION "public"."col_has_check"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _constraint( $1, 'c', $2, $3, 'check' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_check"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_fk(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_fk"(name, _name, text);
CREATE FUNCTION "public"."col_is_fk"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    names text[];
BEGIN
    IF _fkexists($1, $2) THEN
        RETURN pass( $3 );
    END IF;

    -- Try to show the columns.
    SELECT ARRAY(
        SELECT _ident_array_to_string(fk_columns, ', ')
          FROM pg_all_foreign_keys
         WHERE fk_table_name  = $1
         ORDER BY fk_columns
    ) INTO names;

    IF NAMES[1] IS NOT NULL THEN
        RETURN fail($3) || E'\n' || diag(
            '    Table ' || quote_ident($1) || E' has foreign key constraints on these columns:\n        '
            || array_to_string( names, E'\n        ' )
        );
    END IF;

    -- No FKs in this table.
    RETURN fail($3) || E'\n' || diag(
        '    Table ' || quote_ident($1) || ' has no foreign key columns'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_fk"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_fk(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_fk"(name, _name);
CREATE FUNCTION "public"."col_is_fk"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT col_is_fk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should be a foreign key' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_fk"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_unique(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_unique"(text, text, text);
CREATE FUNCTION "public"."has_unique"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, $2, 'u' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_unique"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_unique(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_unique"(text, text);
CREATE FUNCTION "public"."has_unique"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, 'u' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_unique"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_unique(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_unique"(text);
CREATE FUNCTION "public"."has_unique"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT has_unique( $1, 'Table ' || quote_ident($1) || ' should have a unique constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_unique"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._constraint(name, name, bpchar, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_constraint"(name, name, bpchar, _name, text, text);
CREATE FUNCTION "public"."_constraint"(IN name, IN name, IN bpchar, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    akey NAME[];
    keys TEXT[] := '{}';
    have TEXT;
BEGIN
    FOR akey IN SELECT * FROM _keys($1, $2, $3) LOOP
        IF akey = $4 THEN RETURN pass($5); END IF;
        keys = keys || akey::text;
    END LOOP;
    IF array_upper(keys, 0) = 1 THEN
        have := 'No ' || $6 || ' constraints';
    ELSE
        have := array_to_string(keys, E'\n              ');
    END IF;

    RETURN fail($5) || E'\n' || diag(
             '        have: ' || have
       || E'\n        want: ' || CASE WHEN $4 IS NULL THEN 'NULL' ELSE $4::text END
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_constraint"(IN name, IN name, IN bpchar, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._constraint(name, bpchar, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_constraint"(name, bpchar, _name, text, text);
CREATE FUNCTION "public"."_constraint"(IN name, IN bpchar, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    akey NAME[];
    keys TEXT[] := '{}';
    have TEXT;
BEGIN
    FOR akey IN SELECT * FROM _keys($1, $2) LOOP
        IF akey = $3 THEN RETURN pass($4); END IF;
        keys = keys || akey::text;
    END LOOP;
    IF array_upper(keys, 0) = 1 THEN
        have := 'No ' || $5 || ' constraints';
    ELSE
        have := array_to_string(keys, E'\n              ');
    END IF;

    RETURN fail($4) || E'\n' || diag(
             '        have: ' || have
       || E'\n        want: ' || CASE WHEN $3 IS NULL THEN 'NULL' ELSE $3::text END
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_constraint"(IN name, IN bpchar, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_unique(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_unique"(name, name, _name, text);
CREATE FUNCTION "public"."col_is_unique"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _constraint( $1, $2, 'u', $3, $4, 'unique' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_unique"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_unique(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_unique"(name, _name, text);
CREATE FUNCTION "public"."col_is_unique"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _constraint( $1, 'u', $2, $3, 'unique' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_unique"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_is_unique(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_is_unique"(name, _name);
CREATE FUNCTION "public"."col_is_unique"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT col_is_unique( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should have a unique constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_is_unique"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_check(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_check"(name, name, text);
CREATE FUNCTION "public"."has_check"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, $2, 'c' ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_check"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_check(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_check"(name, text);
CREATE FUNCTION "public"."has_check"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _hasc( $1, 'c' ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_check"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_check(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_check"(name);
CREATE FUNCTION "public"."has_check"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_check( $1, 'Table ' || quote_ident($1) || ' should have a check constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_check"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.col_has_check(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."col_has_check"(name, _name);
CREATE FUNCTION "public"."col_has_check"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT col_has_check( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should have a check constraint' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."col_has_check"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fk_ok(name, name, _name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fk_ok"(name, name, _name, name, name, _name, text);
CREATE FUNCTION "public"."fk_ok"(IN name, IN name, IN _name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    sch  name;
    tab  name;
    cols name[];
BEGIN
    SELECT pk_schema_name, pk_table_name, pk_columns
      FROM pg_all_foreign_keys
      WHERE fk_schema_name = $1
        AND fk_table_name  = $2
        AND fk_columns     = $3
      INTO sch, tab, cols;

    RETURN is(
        -- have
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') REFERENCES ' || COALESCE ( sch || '.' || tab || '(' || _ident_array_to_string( cols, ', ' ) || ')', 'NOTHING' ),
        -- want
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') REFERENCES ' ||
        $4 || '.' || $5 || '(' || _ident_array_to_string( $6, ', ' ) || ')',
        $7
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fk_ok"(IN name, IN name, IN _name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fk_ok(name, _name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fk_ok"(name, _name, name, _name, text);
CREATE FUNCTION "public"."fk_ok"(IN name, IN _name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    tab  name;
    cols name[];
BEGIN
    SELECT pk_table_name, pk_columns
      FROM pg_all_foreign_keys
     WHERE fk_table_name = $1
       AND fk_columns    = $2
       AND pg_catalog.pg_table_is_visible(fk_table_oid)
      INTO tab, cols;

    RETURN is(
        -- have
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') REFERENCES ' || COALESCE( tab || '(' || _ident_array_to_string( cols, ', ' ) || ')', 'NOTHING'),
        -- want
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') REFERENCES ' ||
        $3 || '(' || _ident_array_to_string( $4, ', ' ) || ')',
        $5
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fk_ok"(IN name, IN _name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fk_ok(name, name, _name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fk_ok"(name, name, _name, name, name, _name);
CREATE FUNCTION "public"."fk_ok"(IN name, IN name, IN _name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT fk_ok( $1, $2, $3, $4, $5, $6,
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') should reference ' ||
        $4 || '.' || $5 || '(' || _ident_array_to_string( $6, ', ' ) || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fk_ok"(IN name, IN name, IN _name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fk_ok(name, _name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fk_ok"(name, _name, name, _name);
CREATE FUNCTION "public"."fk_ok"(IN name, IN _name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT fk_ok( $1, $2, $3, $4,
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') should reference ' ||
        $3 || '(' || _ident_array_to_string( $4, ', ' ) || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fk_ok"(IN name, IN _name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._got_func(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_got_func"(name, name, _name);
CREATE FUNCTION "public"."_got_func"(IN name, IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT TRUE
          FROM tap_funky
         WHERE schema = $1
           AND name   = $2
           AND args   = array_to_string($3, ',')
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_got_func"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._got_func(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_got_func"(name, name);
CREATE FUNCTION "public"."_got_func"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS( SELECT TRUE FROM tap_funky WHERE schema = $1 AND name = $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_got_func"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._got_func(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_got_func"(name, _name);
CREATE FUNCTION "public"."_got_func"(IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT TRUE
          FROM tap_funky
         WHERE name = $1
           AND args = array_to_string($2, ',')
           AND is_visible
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_got_func"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._got_func(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_got_func"(name);
CREATE FUNCTION "public"."_got_func"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS( SELECT TRUE FROM tap_funky WHERE name = $1 AND is_visible);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_got_func"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, name, _name, text);
CREATE FUNCTION "public"."has_function"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _got_func($1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, name, _name);
CREATE FUNCTION "public"."has_function"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _got_func($1, $2, $3),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, name, text);
CREATE FUNCTION "public"."has_function"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _got_func($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, name);
CREATE FUNCTION "public"."has_function"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _got_func($1, $2),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, _name, text);
CREATE FUNCTION "public"."has_function"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _got_func($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, _name);
CREATE FUNCTION "public"."has_function"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _got_func($1, $2),
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name, text);
CREATE FUNCTION "public"."has_function"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _got_func($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_function(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_function"(name);
CREATE FUNCTION "public"."has_function"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _got_func($1), 'Function ' || quote_ident($1) || '() should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_function"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, name, _name, text);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _got_func($1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, name, _name);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _got_func($1, $2, $3),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, name, text);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _got_func($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, name);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _got_func($1, $2),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, _name, text);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _got_func($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, _name);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _got_func($1, $2),
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name, text);
CREATE FUNCTION "public"."hasnt_function"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _got_func($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_function(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_function"(name);
CREATE FUNCTION "public"."hasnt_function"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _got_func($1), 'Function ' || quote_ident($1) || '() should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_function"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._pg_sv_type_array(_oid)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_pg_sv_type_array"(_oid);
CREATE FUNCTION "public"."_pg_sv_type_array"(IN _oid) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT t.typname
          FROM pg_catalog.pg_type t
          JOIN generate_series(1, array_upper($1, 1)) s(i) ON t.oid = $1[i]
         ORDER BY i
    )
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	STABLE;
ALTER FUNCTION "public"."_pg_sv_type_array"(IN _oid) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.can(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."can"(name, _name, text);
CREATE FUNCTION "public"."can"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    missing text[];
BEGIN
    SELECT ARRAY(
        SELECT quote_ident($2[i])
          FROM generate_series(1, array_upper($2, 1)) s(i)
          LEFT JOIN tap_funky ON name = $2[i] AND schema = $1
         WHERE oid IS NULL
         GROUP BY $2[i], s.i
         ORDER BY MIN(s.i)
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $3 );
    END IF;
    RETURN ok( false, $3 ) || E'\n' || diag(
        '    ' || quote_ident($1) || '.' ||
        array_to_string( missing, E'() missing\n    ' || quote_ident($1) || '.') ||
        '() missing'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."can"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.can(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."can"(name, _name);
CREATE FUNCTION "public"."can"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT can( $1, $2, 'Schema ' || quote_ident($1) || ' can' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."can"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.can(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."can"(_name, text);
CREATE FUNCTION "public"."can"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    missing text[];
BEGIN
    SELECT ARRAY(
        SELECT quote_ident($1[i])
          FROM generate_series(1, array_upper($1, 1)) s(i)
          LEFT JOIN pg_catalog.pg_proc p
            ON $1[i] = p.proname
           AND pg_catalog.pg_function_is_visible(p.oid)
         WHERE p.oid IS NULL
         ORDER BY s.i
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $2 );
    END IF;
    RETURN ok( false, $2 ) || E'\n' || diag(
        '    ' ||
        array_to_string( missing, E'() missing\n    ') ||
        '() missing'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."can"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.can(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."can"(_name);
CREATE FUNCTION "public"."can"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT can( $1, 'Schema ' || _ident_array_to_string(current_schemas(true), ' or ') || ' can' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."can"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._ikeys(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_ikeys"(name, name, name);
CREATE FUNCTION "public"."_ikeys"(IN name, IN name, IN name) RETURNS "_text" 
	AS $BODY$
    SELECT ARRAY(
        SELECT pg_catalog.pg_get_indexdef( ci.oid, s.i + 1, false)
          FROM pg_catalog.pg_index x
          JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
          JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
          JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
          JOIN generate_series(0, current_setting('max_index_keys')::int - 1) s(i)
            ON x.indkey[s.i] IS NOT NULL
         WHERE ct.relname = $2
           AND ci.relname = $3
           AND n.nspname  = $1
         ORDER BY s.i
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_ikeys"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._ikeys(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_ikeys"(name, name);
CREATE FUNCTION "public"."_ikeys"(IN name, IN name) RETURNS "_text" 
	AS $BODY$
    SELECT ARRAY(
        SELECT pg_catalog.pg_get_indexdef( ci.oid, s.i + 1, false)
          FROM pg_catalog.pg_index x
          JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
          JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
          JOIN generate_series(0, current_setting('max_index_keys')::int - 1) s(i)
            ON x.indkey[s.i] IS NOT NULL
         WHERE ct.relname = $1
           AND ci.relname = $2
           AND pg_catalog.pg_table_is_visible(ct.oid)
         ORDER BY s.i
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_ikeys"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._have_index(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_have_index"(name, name, name);
CREATE FUNCTION "public"."_have_index"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
    SELECT TRUE
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
     WHERE n.nspname  = $1
       AND ct.relname = $2
       AND ci.relname = $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_have_index"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._have_index(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_have_index"(name, name);
CREATE FUNCTION "public"."_have_index"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
    SELECT TRUE
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_have_index"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_primary(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_primary"(name, name, name, text);
CREATE FUNCTION "public"."index_is_primary"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_primary"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, name, _name, text);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
     index_cols name[];
BEGIN
    index_cols := _ikeys($1, $2, $3 );

    IF index_cols IS NULL OR index_cols = '{}'::name[] THEN
        RETURN ok( false, $5 ) || E'\n'
            || diag( 'Index ' || quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || ' not found');
    END IF;

    RETURN is(
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || array_to_string( index_cols, ', ' ) || ')',
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || array_to_string( $4, ', ' ) || ')',
        $5
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, name, _name);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
   SELECT has_index( $1, $2, $3, $4, 'Index ' || quote_ident($3) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, _name, text);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
     index_cols name[];
BEGIN
    index_cols := _ikeys($1, $2 );

    IF index_cols IS NULL OR index_cols = '{}'::name[] THEN
        RETURN ok( false, $4 ) || E'\n'
            || diag( 'Index ' || quote_ident($2) || ' ON ' || quote_ident($1) || ' not found');
    END IF;

    RETURN is(
        quote_ident($2) || ' ON ' || quote_ident($1) || '(' || array_to_string( index_cols, ', ' ) || ')',
        quote_ident($2) || ' ON ' || quote_ident($1) || '(' || array_to_string( $3, ', ' ) || ')',
        $4
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, _name);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
   SELECT has_index( $1, $2, $3, 'Index ' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_schema(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_schema"(name);
CREATE FUNCTION "public"."_is_schema"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace
          WHERE nspname = $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_is_schema"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, name);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
BEGIN
   IF _is_schema($1) THEN
       -- ( schema, table, index )
       RETURN ok( _have_index( $1, $2, $3 ), 'Index ' || quote_ident($3) || ' should exist' );
   ELSE
       -- ( table, index, column/expression )
       RETURN has_index( $1, $2, $3, 'Index ' || quote_ident($2) || ' should exist' );
   END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name, text);
CREATE FUNCTION "public"."has_index"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $3 LIKE '%(%'
           THEN has_index( $1, $2, $3::name )
           ELSE ok( _have_index( $1, $2 ), $3 )
           END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_index(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_index"(name, name);
CREATE FUNCTION "public"."has_index"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _have_index( $1, $2 ), 'Index ' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_index"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_index(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_index"(name, name, name, text);
CREATE FUNCTION "public"."hasnt_index"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    RETURN ok( NOT _have_index( $1, $2, $3 ), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_index"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_index(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_index"(name, name, name);
CREATE FUNCTION "public"."hasnt_index"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _have_index( $1, $2, $3 ),
        'Index ' || quote_ident($3) || ' should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_index"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_index(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_index"(name, name, text);
CREATE FUNCTION "public"."hasnt_index"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _have_index( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_index"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_index(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_index"(name, name);
CREATE FUNCTION "public"."hasnt_index"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _have_index( $1, $2 ),
        'Index ' || quote_ident($2) || ' should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_index"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_unique(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_unique"(name, name, name, text);
CREATE FUNCTION "public"."index_is_unique"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_unique"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_unique(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_unique"(name, name, name);
CREATE FUNCTION "public"."index_is_unique"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT index_is_unique(
        $1, $2, $3,
        'Index ' || quote_ident($3) || ' should be unique'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_unique"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_unique(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_unique"(name, name);
CREATE FUNCTION "public"."index_is_unique"(IN name, IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($2) || ' should be unique'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_unique"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_unique(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_unique"(name);
CREATE FUNCTION "public"."index_is_unique"(IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
     WHERE ci.relname = $1
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($1) || ' should be unique'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_unique"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_primary(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_primary"(name, name, name);
CREATE FUNCTION "public"."index_is_primary"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT index_is_primary(
        $1, $2, $3,
        'Index ' || quote_ident($3) || ' should be on a primary key'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_primary"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_primary(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_primary"(name, name);
CREATE FUNCTION "public"."index_is_primary"(IN name, IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
     INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($2) || ' should be on a primary key'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_primary"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_primary(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_primary"(name);
CREATE FUNCTION "public"."index_is_primary"(IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
     WHERE ci.relname = $1
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($1) || ' should be on a primary key'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_primary"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_clustered(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_clustered"(name, name, name, text);
CREATE FUNCTION "public"."is_clustered"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_clustered"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_clustered(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_clustered"(name, name, name);
CREATE FUNCTION "public"."is_clustered"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT is_clustered(
        $1, $2, $3,
        'Table ' || quote_ident($1) || '.' || quote_ident($2) ||
        ' should be clustered on index ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_clustered"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_clustered(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_clustered"(name, name);
CREATE FUNCTION "public"."is_clustered"(IN name, IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
     WHERE ct.relname = $1
       AND ci.relname = $2
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Table ' || quote_ident($1) || ' should be clustered on index ' || quote_ident($2)
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_clustered"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_clustered(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_clustered"(name);
CREATE FUNCTION "public"."is_clustered"(IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
     WHERE ci.relname = $1
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Table should be clustered on index ' || quote_ident($1)
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_clustered"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_type(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_type"(name, name, name, name, text);
CREATE FUNCTION "public"."index_is_type"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
      JOIN pg_catalog.pg_am am       ON ci.relam = am.oid
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO aname;

      return is( aname, $4, $5 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_type"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_type(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_type"(name, name, name, name);
CREATE FUNCTION "public"."index_is_type"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT index_is_type(
        $1, $2, $3, $4,
        'Index ' || quote_ident($3) || ' should be a ' || quote_ident($4) || ' index'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_type"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_type(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_type"(name, name, name);
CREATE FUNCTION "public"."index_is_type"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_am am    ON ci.relam = am.oid
     WHERE ct.relname = $1
       AND ci.relname = $2
      INTO aname;

      return is(
          aname, $3,
          'Index ' || quote_ident($2) || ' should be a ' || quote_ident($3) || ' index'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_type"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_is_type(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_is_type"(name, name);
CREATE FUNCTION "public"."index_is_type"(IN name, IN name) RETURNS "text" 
	AS $BODY$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_am am    ON ci.relam = am.oid
     WHERE ci.relname = $1
      INTO aname;

      return is(
          aname, $2,
          'Index ' || quote_ident($1) || ' should be a ' || quote_ident($2) || ' index'
      );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_is_type"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._trig(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_trig"(name, name, name);
CREATE FUNCTION "public"."_trig"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_trigger t
          JOIN pg_catalog.pg_class c     ON c.oid = t.tgrelid
          JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
         WHERE n.nspname = $1
           AND c.relname = $2
           AND t.tgname  = $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_trig"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._trig(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_trig"(name, name);
CREATE FUNCTION "public"."_trig"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_trigger t
          JOIN pg_catalog.pg_class c     ON c.oid = t.tgrelid
         WHERE c.relname = $1
           AND t.tgname  = $2
           AND pg_catalog.pg_table_is_visible(c.oid)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_trig"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_trigger(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_trigger"(name, name, name, text);
CREATE FUNCTION "public"."has_trigger"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _trig($1, $2, $3), $4);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_trigger"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_trigger(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_trigger"(name, name, name);
CREATE FUNCTION "public"."has_trigger"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_trigger(
        $1, $2, $3,
        'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should have trigger ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_trigger"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_trigger(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_trigger"(name, name, text);
CREATE FUNCTION "public"."has_trigger"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _trig($1, $2), $3);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_trigger"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_trigger(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_trigger"(name, name);
CREATE FUNCTION "public"."has_trigger"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _trig($1, $2), 'Table ' || quote_ident($1) || ' should have trigger ' || quote_ident($2));
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_trigger"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_trigger(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_trigger"(name, name, name, text);
CREATE FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _trig($1, $2, $3), $4);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_trigger(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_trigger"(name, name, name);
CREATE FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _trig($1, $2, $3),
        'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should not have trigger ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_trigger(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_trigger"(name, name, text);
CREATE FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _trig($1, $2), $3);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_trigger"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_trigger(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_trigger"(name, name);
CREATE FUNCTION "public"."hasnt_trigger"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _trig($1, $2), 'Table ' || quote_ident($1) || ' should not have trigger ' || quote_ident($2));
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_trigger"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.trigger_is(name, name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."trigger_is"(name, name, name, name, name, text);
CREATE FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    pname text;
BEGIN
    SELECT quote_ident(ni.nspname) || '.' || quote_ident(p.proname)
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class ct     ON ct.oid = t.tgrelid
      JOIN pg_catalog.pg_namespace nt ON nt.oid = ct.relnamespace
      JOIN pg_catalog.pg_proc p       ON p.oid = t.tgfoid
      JOIN pg_catalog.pg_namespace ni ON ni.oid = p.pronamespace
     WHERE nt.nspname = $1
       AND ct.relname = $2
       AND t.tgname   = $3
      INTO pname;

    RETURN is( pname, quote_ident($4) || '.' || quote_ident($5), $6 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.trigger_is(name, name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."trigger_is"(name, name, name, name, name);
CREATE FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT trigger_is(
        $1, $2, $3, $4, $5,
        'Trigger ' || quote_ident($3) || ' should call ' || quote_ident($4) || '.' || quote_ident($5) || '()'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.trigger_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."trigger_is"(name, name, name, text);
CREATE FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    pname text;
BEGIN
    SELECT p.proname
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class ct ON ct.oid = t.tgrelid
      JOIN pg_catalog.pg_proc p   ON p.oid = t.tgfoid
     WHERE ct.relname = $1
       AND t.tgname   = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO pname;

    RETURN is( pname, $3::text, $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."trigger_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.trigger_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."trigger_is"(name, name, name);
CREATE FUNCTION "public"."trigger_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT trigger_is(
        $1, $2, $3,
        'Trigger ' || quote_ident($2) || ' should call ' || quote_ident($3) || '()'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."trigger_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_schema(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_schema"(name, text);
CREATE FUNCTION "public"."has_schema"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace
             WHERE nspname = $1
        ), $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_schema"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_schema(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_schema"(name);
CREATE FUNCTION "public"."has_schema"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_schema( $1, 'Schema ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_schema"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_schema(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_schema"(name, text);
CREATE FUNCTION "public"."hasnt_schema"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace
             WHERE nspname = $1
        ), $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_schema"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_schema(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_schema"(name);
CREATE FUNCTION "public"."hasnt_schema"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_schema( $1, 'Schema ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_schema"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_tablespace(name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_tablespace"(name, text, text);
CREATE FUNCTION "public"."has_tablespace"(IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    IF pg_version_num() >= 90200 THEN
        RETURN ok(
            EXISTS(
                SELECT true
                  FROM pg_catalog.pg_tablespace
                 WHERE spcname = $1
                   AND pg_tablespace_location(oid) = $2
            ), $3
        );
    ELSE
        RETURN ok(
            EXISTS(
                SELECT true
                  FROM pg_catalog.pg_tablespace
                 WHERE spcname = $1
                   AND spclocation = $2
            ), $3
        );
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_tablespace"(IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_tablespace(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_tablespace"(name, text);
CREATE FUNCTION "public"."has_tablespace"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_tablespace
             WHERE spcname = $1
        ), $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_tablespace"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_tablespace(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_tablespace"(name);
CREATE FUNCTION "public"."has_tablespace"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_tablespace( $1, 'Tablespace ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_tablespace"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_tablespace(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_tablespace"(name, text);
CREATE FUNCTION "public"."hasnt_tablespace"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT EXISTS(
            SELECT true
              FROM pg_catalog.pg_tablespace
             WHERE spcname = $1
        ), $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_tablespace"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_tablespace(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_tablespace"(name);
CREATE FUNCTION "public"."hasnt_tablespace"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_tablespace( $1, 'Tablespace ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_tablespace"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_type(name, name, _bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_type"(name, name, _bpchar);
CREATE FUNCTION "public"."_has_type"(IN name, IN name, IN _bpchar) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_type t
          JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
         WHERE t.typisdefined
           AND n.nspname = $1
           AND t.typname = $2
           AND t.typtype = ANY( COALESCE($3, ARRAY['b', 'c', 'd', 'p', 'e']) )
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_type"(IN name, IN name, IN _bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_type(name, _bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_type"(name, _bpchar);
CREATE FUNCTION "public"."_has_type"(IN name, IN _bpchar) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_type t
         WHERE t.typisdefined
           AND pg_catalog.pg_type_is_visible(t.oid)
           AND t.typname = $1
           AND t.typtype = ANY( COALESCE($2, ARRAY['b', 'c', 'd', 'p', 'e']) )
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_type"(IN name, IN _bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_type(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_type"(name, name, text);
CREATE FUNCTION "public"."has_type"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, $2, NULL ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_type"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_type(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_type"(name, name);
CREATE FUNCTION "public"."has_type"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_type( $1, $2, 'Type ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_type"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_type(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_type"(name, text);
CREATE FUNCTION "public"."has_type"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, NULL ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_type"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_type(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_type"(name);
CREATE FUNCTION "public"."has_type"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, NULL ), ('Type ' || quote_ident($1) || ' should exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_type"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_type(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_type"(name, name, text);
CREATE FUNCTION "public"."hasnt_type"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, $2, NULL ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_type"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_type(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_type"(name, name);
CREATE FUNCTION "public"."hasnt_type"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_type( $1, $2, 'Type ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_type"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_type(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_type"(name, text);
CREATE FUNCTION "public"."hasnt_type"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, NULL ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_type"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_type(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_type"(name);
CREATE FUNCTION "public"."hasnt_type"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, NULL ), ('Type ' || quote_ident($1) || ' should not exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_type"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_domain(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_domain"(name, name, text);
CREATE FUNCTION "public"."has_domain"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, $2, ARRAY['d'] ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_domain"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_domain(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_domain"(name, name);
CREATE FUNCTION "public"."has_domain"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_domain( $1, $2, 'Domain ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_domain"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_domain(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_domain"(name, text);
CREATE FUNCTION "public"."has_domain"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, ARRAY['d'] ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_domain"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_domain(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_domain"(name);
CREATE FUNCTION "public"."has_domain"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, ARRAY['d'] ), ('Domain ' || quote_ident($1) || ' should exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_domain"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_domain(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_domain"(name, name, text);
CREATE FUNCTION "public"."hasnt_domain"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, $2, ARRAY['d'] ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_domain"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_domain(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_domain"(name, name);
CREATE FUNCTION "public"."hasnt_domain"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_domain( $1, $2, 'Domain ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_domain"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_domain(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_domain"(name, text);
CREATE FUNCTION "public"."hasnt_domain"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, ARRAY['d'] ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_domain"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_domain(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_domain"(name);
CREATE FUNCTION "public"."hasnt_domain"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, ARRAY['d'] ), ('Domain ' || quote_ident($1) || ' should not exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_domain"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_enum(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_enum"(name, name, text);
CREATE FUNCTION "public"."has_enum"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, $2, ARRAY['e'] ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_enum"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_enum(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_enum"(name, name);
CREATE FUNCTION "public"."has_enum"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT has_enum( $1, $2, 'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_enum"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_enum(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_enum"(name, text);
CREATE FUNCTION "public"."has_enum"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, ARRAY['e'] ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_enum"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_enum(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_enum"(name);
CREATE FUNCTION "public"."has_enum"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_type( $1, ARRAY['e'] ), ('Enum ' || quote_ident($1) || ' should exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_enum"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_enum(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_enum"(name, name, text);
CREATE FUNCTION "public"."hasnt_enum"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, $2, ARRAY['e'] ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_enum"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_enum(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_enum"(name, name);
CREATE FUNCTION "public"."hasnt_enum"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT hasnt_enum( $1, $2, 'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_enum"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_enum(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_enum"(name, text);
CREATE FUNCTION "public"."hasnt_enum"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, ARRAY['e'] ), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_enum"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_enum(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_enum"(name);
CREATE FUNCTION "public"."hasnt_enum"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_type( $1, ARRAY['e'] ), ('Enum ' || quote_ident($1) || ' should not exist')::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_enum"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enum_has_labels(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enum_has_labels"(name, name, _name, text);
CREATE FUNCTION "public"."enum_has_labels"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT is(
        ARRAY(
            SELECT e.enumlabel
              FROM pg_catalog.pg_type t
              JOIN pg_catalog.pg_enum e      ON t.oid = e.enumtypid
              JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
              WHERE t.typisdefined
               AND n.nspname = $1
               AND t.typname = $2
               AND t.typtype = 'e'
             ORDER BY e.oid
        ),
        $3,
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enum_has_labels"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enum_has_labels(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enum_has_labels"(name, name, _name);
CREATE FUNCTION "public"."enum_has_labels"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT enum_has_labels(
        $1, $2, $3,
        'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should have labels (' || array_to_string( $3, ', ' ) || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enum_has_labels"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enum_has_labels(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enum_has_labels"(name, _name, text);
CREATE FUNCTION "public"."enum_has_labels"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT is(
        ARRAY(
            SELECT e.enumlabel
              FROM pg_catalog.pg_type t
              JOIN pg_catalog.pg_enum e ON t.oid = e.enumtypid
              WHERE t.typisdefined
               AND pg_catalog.pg_type_is_visible(t.oid)
               AND t.typname = $1
               AND t.typtype = 'e'
             ORDER BY e.oid
        ),
        $2,
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enum_has_labels"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enum_has_labels(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enum_has_labels"(name, _name);
CREATE FUNCTION "public"."enum_has_labels"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT enum_has_labels(
        $1, $2,
        'Enum ' || quote_ident($1) || ' should have labels (' || array_to_string( $2, ', ' ) || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enum_has_labels"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_role(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_role"(name);
CREATE FUNCTION "public"."_has_role"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_roles
         WHERE rolname = $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_role"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_role(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_role"(name, text);
CREATE FUNCTION "public"."has_role"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_role($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_role"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_role(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_role"(name);
CREATE FUNCTION "public"."has_role"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_role($1), 'Role ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_role"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_role(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_role"(name, text);
CREATE FUNCTION "public"."hasnt_role"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_role($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_role"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_role(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_role"(name);
CREATE FUNCTION "public"."hasnt_role"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_role($1), 'Role ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_role"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_user(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_user"(name);
CREATE FUNCTION "public"."_has_user"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS( SELECT true FROM pg_catalog.pg_user WHERE usename = $1);
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_user"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_user(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_user"(name, text);
CREATE FUNCTION "public"."has_user"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_user($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_user"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_user(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_user"(name);
CREATE FUNCTION "public"."has_user"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_user( $1 ), 'User ' || quote_ident($1) || ' should exist');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_user"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_user(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_user"(name, text);
CREATE FUNCTION "public"."hasnt_user"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_user($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_user"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_user(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_user"(name);
CREATE FUNCTION "public"."hasnt_user"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_user( $1 ), 'User ' || quote_ident($1) || ' should not exist');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_user"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_super(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_super"(name);
CREATE FUNCTION "public"."_is_super"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT rolsuper
      FROM pg_catalog.pg_roles
     WHERE rolname = $1
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_is_super"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_superuser(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_superuser"(name, text);
CREATE FUNCTION "public"."is_superuser"(IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    is_super boolean := _is_super($1);
BEGIN
    IF is_super IS NULL THEN
        RETURN fail( $2 ) || E'\n' || diag( '    User ' || quote_ident($1) || ' does not exist') ;
    END IF;
    RETURN ok( is_super, $2 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_superuser"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_superuser(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_superuser"(name);
CREATE FUNCTION "public"."is_superuser"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT is_superuser( $1, 'User ' || quote_ident($1) || ' should be a super user' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_superuser"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt_superuser(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt_superuser"(name, text);
CREATE FUNCTION "public"."isnt_superuser"(IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    is_super boolean := _is_super($1);
BEGIN
    IF is_super IS NULL THEN
        RETURN fail( $2 ) || E'\n' || diag( '    User ' || quote_ident($1) || ' does not exist') ;
    END IF;
    RETURN ok( NOT is_super, $2 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt_superuser"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt_superuser(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt_superuser"(name);
CREATE FUNCTION "public"."isnt_superuser"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT isnt_superuser( $1, 'User ' || quote_ident($1) || ' should not be a super user' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt_superuser"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._has_group(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_has_group"(name);
CREATE FUNCTION "public"."_has_group"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_group
         WHERE groname = $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	STRICT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_has_group"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_group(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_group"(name, text);
CREATE FUNCTION "public"."has_group"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_group($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_group"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_group(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_group"(name);
CREATE FUNCTION "public"."has_group"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _has_group($1), 'Group ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_group"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_group(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_group"(name, text);
CREATE FUNCTION "public"."hasnt_group"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_group($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_group"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_group(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_group"(name);
CREATE FUNCTION "public"."hasnt_group"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _has_group($1), 'Group ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_group"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._grolist(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_grolist"(name);
CREATE FUNCTION "public"."_grolist"(IN name) RETURNS "_oid" 
	AS $BODY$
    SELECT ARRAY(
        SELECT member
          FROM pg_catalog.pg_auth_members m
          JOIN pg_catalog.pg_roles r ON m.roleid = r.oid
         WHERE r.rolname =  $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_grolist"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_member_of(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_member_of"(name, _name, text);
CREATE FUNCTION "public"."is_member_of"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    missing text[];
BEGIN
    IF NOT _has_role($1) THEN
        RETURN fail( $3 ) || E'\n' || diag (
            '    Role ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    SELECT ARRAY(
        SELECT quote_ident($2[i])
          FROM generate_series(1, array_upper($2, 1)) s(i)
          LEFT JOIN pg_catalog.pg_user ON usename = $2[i]
         WHERE usesysid IS NULL
            OR NOT usesysid = ANY ( _grolist($1) )
         ORDER BY s.i
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $3 );
    END IF;
    RETURN ok( false, $3 ) || E'\n' || diag(
        '    Users missing from the ' || quote_ident($1) || E' group:\n        ' ||
        array_to_string( missing, E'\n        ')
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_member_of"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_member_of(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_member_of"(name, _name);
CREATE FUNCTION "public"."is_member_of"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT is_member_of( $1, $2, 'Should have members of group ' || quote_ident($1) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_member_of"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cmp_types(oid, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cmp_types"(oid, name);
CREATE FUNCTION "public"."_cmp_types"(IN oid, IN name) RETURNS "bool" 
	AS $BODY$
DECLARE
    dtype TEXT := pg_catalog.format_type($1, NULL);
BEGIN
    RETURN dtype = _quote_ident_like($2, dtype);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cmp_types"(IN oid, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cast_exists(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cast_exists"(name, name, name, name);
CREATE FUNCTION "public"."_cast_exists"(IN name, IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_cast c
         JOIN pg_catalog.pg_proc p ON c.castfunc = p.oid
         JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
        WHERE _cmp_types(castsource, $1)
          AND _cmp_types(casttarget, $2)
          AND n.nspname   = $3
          AND p.proname   = $4
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cast_exists"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cast_exists(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cast_exists"(name, name, name);
CREATE FUNCTION "public"."_cast_exists"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_cast c
         JOIN pg_catalog.pg_proc p ON c.castfunc = p.oid
        WHERE _cmp_types(castsource, $1)
          AND _cmp_types(casttarget, $2)
          AND p.proname   = $3
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cast_exists"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cast_exists(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cast_exists"(name, name);
CREATE FUNCTION "public"."_cast_exists"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_cast c
        WHERE _cmp_types(castsource, $1)
          AND _cmp_types(casttarget, $2)
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cast_exists"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name, name, name, text);
CREATE FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
   SELECT ok( _cast_exists( $1, $2, $3, $4 ), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name, name, name);
CREATE FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
   SELECT ok(
       _cast_exists( $1, $2, $3, $4 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') WITH FUNCTION ' || quote_ident($3)
        || '.' || quote_ident($4) || '() should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name, name, text);
CREATE FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
   SELECT ok( _cast_exists( $1, $2, $3 ), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name, name);
CREATE FUNCTION "public"."has_cast"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
   SELECT ok(
        _cast_exists( $1, $2, $3 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') WITH FUNCTION ' || quote_ident($3) || '() should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name, text);
CREATE FUNCTION "public"."has_cast"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _cast_exists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_cast(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_cast"(name, name);
CREATE FUNCTION "public"."has_cast"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _cast_exists( $1, $2 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_cast"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name, name, name, text);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
   SELECT ok( NOT _cast_exists( $1, $2, $3, $4 ), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name, name, name);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
   SELECT ok(
       NOT _cast_exists( $1, $2, $3, $4 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') WITH FUNCTION ' || quote_ident($3)
        || '.' || quote_ident($4) || '() should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name, name, text);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
   SELECT ok( NOT _cast_exists( $1, $2, $3 ), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name, name);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
   SELECT ok(
        NOT _cast_exists( $1, $2, $3 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') WITH FUNCTION ' || quote_ident($3) || '() should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name, text);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _cast_exists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_cast(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_cast"(name, name);
CREATE FUNCTION "public"."hasnt_cast"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        NOT _cast_exists( $1, $2 ),
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') should not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_cast"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._expand_context(bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_expand_context"(bpchar);
CREATE FUNCTION "public"."_expand_context"(IN bpchar) RETURNS "text" 
	AS $BODY$
   SELECT CASE $1
          WHEN 'i' THEN 'implicit'
          WHEN 'a' THEN 'assignment'
          WHEN 'e' THEN 'explicit'
          ELSE          'unknown' END
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_expand_context"(IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_context(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_context"(name, name);
CREATE FUNCTION "public"."_get_context"(IN name, IN name) RETURNS "char" 
	AS $BODY$
   SELECT c.castcontext
     FROM pg_catalog.pg_cast c
    WHERE _cmp_types(castsource, $1)
      AND _cmp_types(casttarget, $2)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_context"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.cast_context_is(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cast_context_is"(name, name, text, text);
CREATE FUNCTION "public"."cast_context_is"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want char = substring(LOWER($3) FROM 1 FOR 1);
    have char := _get_context($1, $2);
BEGIN
    IF have IS NOT NULL THEN
        RETURN is( _expand_context(have), _expand_context(want), $4 );
    END IF;

    RETURN ok( false, $4 ) || E'\n' || diag(
       '    Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
      || ') does not exist'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."cast_context_is"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.cast_context_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cast_context_is"(name, name, text);
CREATE FUNCTION "public"."cast_context_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT cast_context_is(
        $1, $2, $3,
        'Cast (' || quote_ident($1) || ' AS ' || quote_ident($2)
        || ') context should be ' || _expand_context(substring(LOWER($3) FROM 1 FOR 1))
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."cast_context_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._op_exists(name, name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_op_exists"(name, name, name, name, name);
CREATE FUNCTION "public"."_op_exists"(IN name, IN name, IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_operator o
         JOIN pg_catalog.pg_namespace n ON o.oprnamespace = n.oid
        WHERE n.nspname = $2
          AND o.oprname = $3
          AND CASE o.oprkind WHEN 'l' THEN $1 IS NULL
              ELSE _cmp_types(o.oprleft, $1) END
          AND CASE o.oprkind WHEN 'r' THEN $4 IS NULL
              ELSE _cmp_types(o.oprright, $4) END
          AND _cmp_types(o.oprresult, $5)
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_op_exists"(IN name, IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._op_exists(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_op_exists"(name, name, name, name);
CREATE FUNCTION "public"."_op_exists"(IN name, IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_operator o
        WHERE pg_catalog.pg_operator_is_visible(o.oid)
          AND o.oprname = $2
          AND CASE o.oprkind WHEN 'l' THEN $1 IS NULL
              ELSE _cmp_types(o.oprleft, $1) END
          AND CASE o.oprkind WHEN 'r' THEN $3 IS NULL
              ELSE _cmp_types(o.oprright, $3) END
          AND _cmp_types(o.oprresult, $4)
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_op_exists"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._op_exists(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_op_exists"(name, name, name);
CREATE FUNCTION "public"."_op_exists"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
       SELECT TRUE
         FROM pg_catalog.pg_operator o
        WHERE pg_catalog.pg_operator_is_visible(o.oid)
          AND o.oprname = $2
          AND CASE o.oprkind WHEN 'l' THEN $1 IS NULL
              ELSE _cmp_types(o.oprleft, $1) END
          AND CASE o.oprkind WHEN 'r' THEN $3 IS NULL
              ELSE _cmp_types(o.oprright, $3) END
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_op_exists"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name, name, name, text);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists($1, $2, $3, $4, $5 ), $6 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name, name, name);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, $3, $4, $5 ),
        'Operator ' || quote_ident($2) || '.' || $3 || '(' || $1 || ',' || $4
        || ') RETURNS ' || $5 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name, name, text);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists($1, $2, $3, $4 ), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name, name);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, $3, $4 ),
        'Operator ' ||  $2 || '(' || $1 || ',' || $3
        || ') RETURNS ' || $4 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name, text);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists($1, $2, $3 ), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_operator(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_operator"(name, name, name);
CREATE FUNCTION "public"."has_operator"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, $3 ),
        'Operator ' ||  $2 || '(' || $1 || ',' || $3
        || ') should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_operator"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name, name, name, text);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists(NULL, $1, $2, $3, $4), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name, name, name);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists(NULL, $1, $2, $3, $4 ),
        'Left operator ' || quote_ident($1) || '.' || $2 || '(NONE,'
        || $3 || ') RETURNS ' || $4 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name, name, text);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists(NULL, $1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name, name);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists(NULL, $1, $2, $3 ),
        'Left operator ' || $1 || '(NONE,' || $2 || ') RETURNS ' || $3 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name, text);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists(NULL, $1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_leftop(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_leftop"(name, name);
CREATE FUNCTION "public"."has_leftop"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists(NULL, $1, $2 ),
        'Left operator ' || $1 || '(NONE,' || $2 || ') should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_leftop"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name, name, name, text);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists( $1, $2, $3, NULL, $4), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name, name, name);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, $3, NULL, $4 ),
        'Right operator ' || quote_ident($2) || '.' || $3 || '('
        || $1 || ',NONE) RETURNS ' || $4 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name, name, text);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists( $1, $2, NULL, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name, name);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, NULL, $3 ),
        'Right operator ' || $2 || '('
        || $1 || ',NONE) RETURNS ' || $3 || ' should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name, text);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _op_exists( $1, $2, NULL), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rightop(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rightop"(name, name);
CREATE FUNCTION "public"."has_rightop"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
         _op_exists($1, $2, NULL ),
        'Right operator ' || $2 || '(' || $1 || ',NONE) should exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rightop"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._are(text, _name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_are"(text, _name, _name, text);
CREATE FUNCTION "public"."_are"(IN text, IN _name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    what    ALIAS FOR $1;
    extras  ALIAS FOR $2;
    missing ALIAS FOR $3;
    descr   ALIAS FOR $4;
    msg     TEXT    := '';
    res     BOOLEAN := TRUE;
BEGIN
    IF extras[1] IS NOT NULL THEN
        res = FALSE;
        msg := E'\n' || diag(
            '    Extra ' || what || E':\n        '
            ||  _ident_array_to_string( extras, E'\n        ' )
        );
    END IF;
    IF missing[1] IS NOT NULL THEN
        res = FALSE;
        msg := msg || E'\n' || diag(
            '    Missing ' || what || E':\n        '
            ||  _ident_array_to_string( missing, E'\n        ' )
        );
    END IF;

    RETURN ok(res, descr) || msg;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_are"(IN text, IN _name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespaces_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespaces_are"(_name, text);
CREATE FUNCTION "public"."tablespaces_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'tablespaces',
        ARRAY(
            SELECT spcname
              FROM pg_catalog.pg_tablespace
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
               FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT spcname
              FROM pg_catalog.pg_tablespace
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespaces_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespaces_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespaces_are"(_name);
CREATE FUNCTION "public"."tablespaces_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT tablespaces_are( $1, 'There should be the correct tablespaces' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespaces_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schemas_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schemas_are"(_name, text);
CREATE FUNCTION "public"."schemas_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'schemas',
        ARRAY(
            SELECT nspname
              FROM pg_catalog.pg_namespace
             WHERE nspname NOT LIKE 'pg_%'
               AND nspname <> 'information_schema'
             EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT nspname
              FROM pg_catalog.pg_namespace
             WHERE nspname NOT LIKE 'pg_%'
               AND nspname <> 'information_schema'
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schemas_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schemas_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schemas_are"(_name);
CREATE FUNCTION "public"."schemas_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT schemas_are( $1, 'There should be the correct schemas' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schemas_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._extras(bpchar, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_extras"(bpchar, name, _name);
CREATE FUNCTION "public"."_extras"(IN bpchar, IN name, IN _name) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT c.relname
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE c.relkind = $1
           AND n.nspname = $2
           AND c.relname NOT IN('pg_all_foreign_keys', 'tap_funky', '__tresults___numb_seq', '__tcache___id_seq')
        EXCEPT
        SELECT $3[i]
          FROM generate_series(1, array_upper($3, 1)) s(i)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_extras"(IN bpchar, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._extras(bpchar, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_extras"(bpchar, _name);
CREATE FUNCTION "public"."_extras"(IN bpchar, IN _name) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT c.relname
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE pg_catalog.pg_table_is_visible(c.oid)
           AND n.nspname <> 'pg_catalog'
           AND c.relkind = $1
           AND c.relname NOT IN ('__tcache__', '__tresults__', 'pg_all_foreign_keys', 'tap_funky', '__tresults___numb_seq', '__tcache___id_seq')
        EXCEPT
        SELECT $2[i]
          FROM generate_series(1, array_upper($2, 1)) s(i)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_extras"(IN bpchar, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._missing(bpchar, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_missing"(bpchar, name, _name);
CREATE FUNCTION "public"."_missing"(IN bpchar, IN name, IN _name) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT $3[i]
          FROM generate_series(1, array_upper($3, 1)) s(i)
        EXCEPT
        SELECT c.relname
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE c.relkind = $1
           AND n.nspname = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_missing"(IN bpchar, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._missing(bpchar, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_missing"(bpchar, _name);
CREATE FUNCTION "public"."_missing"(IN bpchar, IN _name) RETURNS "_name" 
	AS $BODY$
    SELECT ARRAY(
        SELECT $2[i]
          FROM generate_series(1, array_upper($2, 1)) s(i)
        EXCEPT
        SELECT c.relname
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE pg_catalog.pg_table_is_visible(c.oid)
           AND n.nspname NOT IN ('pg_catalog', 'information_schema')
           AND c.relkind = $1
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_missing"(IN bpchar, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tables_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tables_are"(name, _name, text);
CREATE FUNCTION "public"."tables_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are( 'tables', _extras('r', $1, $2), _missing('r', $1, $2), $3);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tables_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tables_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tables_are"(_name, text);
CREATE FUNCTION "public"."tables_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are( 'tables', _extras('r', $1), _missing('r', $1), $2);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tables_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tables_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tables_are"(name, _name);
CREATE FUNCTION "public"."tables_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'tables', _extras('r', $1, $2), _missing('r', $1, $2),
        'Schema ' || quote_ident($1) || ' should have the correct tables'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tables_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tables_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tables_are"(_name);
CREATE FUNCTION "public"."tables_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'tables', _extras('r', $1), _missing('r', $1),
        'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct tables'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tables_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_eq(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_eq"(text, anyarray, text);
CREATE FUNCTION "public"."bag_eq"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_eq"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.views_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."views_are"(name, _name);
CREATE FUNCTION "public"."views_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'views', _extras('v', $1, $2), _missing('v', $1, $2),
        'Schema ' || quote_ident($1) || ' should have the correct views'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."views_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.views_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."views_are"(_name);
CREATE FUNCTION "public"."views_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'views', _extras('v', $1), _missing('v', $1),
        'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct views'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."views_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequences_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequences_are"(name, _name, text);
CREATE FUNCTION "public"."sequences_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are( 'sequences', _extras('S', $1, $2), _missing('S', $1, $2), $3);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequences_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequences_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequences_are"(_name, text);
CREATE FUNCTION "public"."sequences_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are( 'sequences', _extras('S', $1), _missing('S', $1), $2);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequences_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequences_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequences_are"(name, _name);
CREATE FUNCTION "public"."sequences_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'sequences', _extras('S', $1, $2), _missing('S', $1, $2),
        'Schema ' || quote_ident($1) || ' should have the correct sequences'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequences_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequences_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequences_are"(_name);
CREATE FUNCTION "public"."sequences_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'sequences', _extras('S', $1), _missing('S', $1),
        'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct sequences'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequences_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.functions_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."functions_are"(name, _name, text);
CREATE FUNCTION "public"."functions_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'functions',
        ARRAY(
            SELECT name FROM tap_funky WHERE schema = $1
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
               FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT name FROM tap_funky WHERE schema = $1
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."functions_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.functions_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."functions_are"(name, _name);
CREATE FUNCTION "public"."functions_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT functions_are( $1, $2, 'Schema ' || quote_ident($1) || ' should have the correct functions' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."functions_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.functions_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."functions_are"(_name, text);
CREATE FUNCTION "public"."functions_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'functions',
        ARRAY(
            SELECT name FROM tap_funky WHERE is_visible
            AND schema NOT IN ('pg_catalog', 'information_schema')
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
               FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT name FROM tap_funky WHERE is_visible
            AND schema NOT IN ('pg_catalog', 'information_schema')
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."functions_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.functions_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."functions_are"(_name);
CREATE FUNCTION "public"."functions_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT functions_are( $1, 'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct functions' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."functions_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._opc_exists(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_opc_exists"(name, name);
CREATE FUNCTION "public"."_opc_exists"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
        SELECT TRUE
          FROM pg_catalog.pg_opclass oc
          JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
         WHERE n.nspname  = $1
           AND oc.opcname = $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_opc_exists"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._opc_exists(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_opc_exists"(name);
CREATE FUNCTION "public"."_opc_exists"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT EXISTS (
        SELECT TRUE
          FROM pg_catalog.pg_opclass oc
         WHERE oc.opcname = $1
           AND pg_opclass_is_visible(oid)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_opc_exists"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_opclass(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_opclass"(name, name, text);
CREATE FUNCTION "public"."has_opclass"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _opc_exists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_opclass"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.indexes_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."indexes_are"(name, name, _name, text);
CREATE FUNCTION "public"."indexes_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'indexes',
        ARRAY(
            SELECT ci.relname
              FROM pg_catalog.pg_index x
              JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
              JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
             WHERE ct.relname = $2
               AND n.nspname  = $1
            EXCEPT
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
        ),
        ARRAY(
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
            EXCEPT
            SELECT ci.relname
              FROM pg_catalog.pg_index x
              JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
              JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
             WHERE ct.relname = $2
               AND n.nspname  = $1
        ),
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."indexes_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.indexes_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."indexes_are"(name, name, _name);
CREATE FUNCTION "public"."indexes_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT indexes_are( $1, $2, $3, 'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should have the correct indexes' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."indexes_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.indexes_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."indexes_are"(name, _name, text);
CREATE FUNCTION "public"."indexes_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'indexes',
        ARRAY(
            SELECT ci.relname
              FROM pg_catalog.pg_index x
              JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
              JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
             WHERE ct.relname = $1
               AND pg_catalog.pg_table_is_visible(ct.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT ci.relname
              FROM pg_catalog.pg_index x
              JOIN pg_catalog.pg_class ct ON ct.oid = x.indrelid
              JOIN pg_catalog.pg_class ci ON ci.oid = x.indexrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
             WHERE ct.relname = $1
               AND pg_catalog.pg_table_is_visible(ct.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."indexes_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.indexes_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."indexes_are"(name, _name);
CREATE FUNCTION "public"."indexes_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT indexes_are( $1, $2, 'Table ' || quote_ident($1) || ' should have the correct indexes' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."indexes_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.users_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."users_are"(_name, text);
CREATE FUNCTION "public"."users_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'users',
        ARRAY(
            SELECT usename
              FROM pg_catalog.pg_user
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT usename
              FROM pg_catalog.pg_user
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."users_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.users_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."users_are"(_name);
CREATE FUNCTION "public"."users_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT users_are( $1, 'There should be the correct users' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."users_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_eq(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_eq"(text, anyarray);
CREATE FUNCTION "public"."bag_eq"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::text, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_eq"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.groups_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."groups_are"(_name, text);
CREATE FUNCTION "public"."groups_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'groups',
        ARRAY(
            SELECT groname
              FROM pg_catalog.pg_group
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT groname
              FROM pg_catalog.pg_group
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."groups_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.groups_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."groups_are"(_name);
CREATE FUNCTION "public"."groups_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT groups_are( $1, 'There should be the correct groups' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."groups_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.languages_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."languages_are"(_name, text);
CREATE FUNCTION "public"."languages_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'languages',
        ARRAY(
            SELECT lanname
              FROM pg_catalog.pg_language
             WHERE lanispl
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT lanname
              FROM pg_catalog.pg_language
             WHERE lanispl
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."languages_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.languages_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."languages_are"(_name);
CREATE FUNCTION "public"."languages_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT languages_are( $1, 'There should be the correct procedural languages' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."languages_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_trusted(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_trusted"(name);
CREATE FUNCTION "public"."_is_trusted"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT lanpltrusted FROM pg_catalog.pg_language WHERE lanname = $1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_is_trusted"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_language(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_language"(name, text);
CREATE FUNCTION "public"."has_language"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_trusted($1) IS NOT NULL, $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_language"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_language(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_language"(name);
CREATE FUNCTION "public"."has_language"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_trusted($1) IS NOT NULL, 'Procedural language ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_language"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_language(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_language"(name, text);
CREATE FUNCTION "public"."hasnt_language"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_trusted($1) IS NULL, $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_language"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_language(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_language"(name);
CREATE FUNCTION "public"."hasnt_language"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_trusted($1) IS NULL, 'Procedural language ' || quote_ident($1) || ' should not exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_language"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_is_trusted(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_is_trusted"(name, text);
CREATE FUNCTION "public"."language_is_trusted"(IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    is_trusted boolean := _is_trusted($1);
BEGIN
    IF is_trusted IS NULL THEN
        RETURN fail( $2 ) || E'\n' || diag( '    Procedural language ' || quote_ident($1) || ' does not exist') ;
    END IF;
    RETURN ok( is_trusted, $2 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_is_trusted"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_is_trusted(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_is_trusted"(name);
CREATE FUNCTION "public"."language_is_trusted"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT language_is_trusted($1, 'Procedural language ' || quote_ident($1) || ' should be trusted' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_is_trusted"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_opclass(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_opclass"(name, name);
CREATE FUNCTION "public"."has_opclass"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _opc_exists( $1, $2 ), 'Operator class ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_opclass"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_opclass(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_opclass"(name, text);
CREATE FUNCTION "public"."has_opclass"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _opc_exists( $1 ), $2)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_opclass"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_opclass(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_opclass"(name);
CREATE FUNCTION "public"."has_opclass"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _opc_exists( $1 ), 'Operator class ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_opclass"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_opclass(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_opclass"(name, name, text);
CREATE FUNCTION "public"."hasnt_opclass"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _opc_exists( $1, $2 ), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_opclass"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_opclass(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_opclass"(name, name);
CREATE FUNCTION "public"."hasnt_opclass"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _opc_exists( $1, $2 ), 'Operator class ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_opclass"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_opclass(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_opclass"(name, text);
CREATE FUNCTION "public"."hasnt_opclass"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _opc_exists( $1 ), $2)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_opclass"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_opclass(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_opclass"(name);
CREATE FUNCTION "public"."hasnt_opclass"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( NOT _opc_exists( $1 ), 'Operator class ' || quote_ident($1) || ' should exist' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_opclass"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclasses_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclasses_are"(name, _name, text);
CREATE FUNCTION "public"."opclasses_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'operator classes',
        ARRAY(
            SELECT oc.opcname
              FROM pg_catalog.pg_opclass oc
              JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
             WHERE n.nspname  = $1
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
               FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT oc.opcname
              FROM pg_catalog.pg_opclass oc
              JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
             WHERE n.nspname  = $1
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclasses_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclasses_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclasses_are"(name, _name);
CREATE FUNCTION "public"."opclasses_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT opclasses_are( $1, $2, 'Schema ' || quote_ident($1) || ' should have the correct operator classes' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclasses_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_instead(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_instead"(name, name, text);
CREATE FUNCTION "public"."rule_is_instead"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    is_it boolean := _is_instead($1, $2);
BEGIN
    IF is_it IS NOT NULL THEN RETURN ok( is_it, $3 ); END IF;
    RETURN ok( FALSE, $3 ) || E'\n' || diag(
        '    Rule ' || quote_ident($2) || ' does not exist'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_instead"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclasses_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclasses_are"(_name, text);
CREATE FUNCTION "public"."opclasses_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'operator classes',
        ARRAY(
            SELECT oc.opcname
              FROM pg_catalog.pg_opclass oc
              JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_opclass_is_visible(oc.oid)
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
               FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT oc.opcname
              FROM pg_catalog.pg_opclass oc
              JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_opclass_is_visible(oc.oid)
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclasses_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclasses_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclasses_are"(_name);
CREATE FUNCTION "public"."opclasses_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT opclasses_are( $1, 'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct operator classes' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclasses_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rules_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rules_are"(name, name, _name, text);
CREATE FUNCTION "public"."rules_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'rules',
        ARRAY(
            SELECT r.rulename
              FROM pg_catalog.pg_rewrite r
              JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
              JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
             WHERE c.relname = $2
               AND n.nspname = $1
            EXCEPT
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
        ),
        ARRAY(
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
            EXCEPT
            SELECT r.rulename
              FROM pg_catalog.pg_rewrite r
              JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
              JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
             WHERE c.relname = $2
               AND n.nspname = $1
        ),
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rules_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rules_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rules_are"(name, name, _name);
CREATE FUNCTION "public"."rules_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT rules_are( $1, $2, $3, 'Relation ' || quote_ident($1) || '.' || quote_ident($2) || ' should have the correct rules' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rules_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rules_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rules_are"(name, _name, text);
CREATE FUNCTION "public"."rules_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'rules',
        ARRAY(
            SELECT r.rulename
              FROM pg_catalog.pg_rewrite r
              JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
              JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
             WHERE c.relname = $1
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_table_is_visible(c.oid)
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT r.rulename
              FROM pg_catalog.pg_rewrite r
              JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
              JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
               AND c.relname = $1
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_table_is_visible(c.oid)
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rules_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rules_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rules_are"(name, _name);
CREATE FUNCTION "public"."rules_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT rules_are( $1, $2, 'Relation ' || quote_ident($1) || ' should have the correct rules' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rules_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._func_compare(name, name, _name, anyelement, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_func_compare"(name, name, _name, anyelement, anyelement, text);
CREATE FUNCTION "public"."_func_compare"(IN name, IN name, IN _name, IN anyelement, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $4 IS NULL
      THEN ok( FALSE, $6 ) || _nosuch($1, $2, $3)
      ELSE is( $4, $5, $6 )
      END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_func_compare"(IN name, IN name, IN _name, IN anyelement, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_instead(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_instead"(name, name, name);
CREATE FUNCTION "public"."_is_instead"(IN name, IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT r.is_instead
      FROM pg_catalog.pg_rewrite r
      JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
      JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
     WHERE r.rulename = $3
       AND c.relname  = $2
       AND n.nspname  = $1
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_is_instead"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_instead(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_instead"(name, name);
CREATE FUNCTION "public"."_is_instead"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT r.is_instead
      FROM pg_catalog.pg_rewrite r
      JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
     WHERE r.rulename = $2
       AND c.relname  = $1
       AND pg_catalog.pg_table_is_visible(c.oid)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_is_instead"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rule(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rule"(name, name, name, text);
CREATE FUNCTION "public"."has_rule"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2, $3) IS NOT NULL, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rule"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rule(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rule"(name, name, name);
CREATE FUNCTION "public"."has_rule"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2, $3) IS NOT NULL, 'Relation ' || quote_ident($1) || '.' || quote_ident($2) || ' should have rule ' || quote_ident($3) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rule"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rule(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rule"(name, name, text);
CREATE FUNCTION "public"."has_rule"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2) IS NOT NULL, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rule"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.has_rule(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."has_rule"(name, name);
CREATE FUNCTION "public"."has_rule"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2) IS NOT NULL, 'Relation ' || quote_ident($1) || ' should have rule ' || quote_ident($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."has_rule"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_rule(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_rule"(name, name, name, text);
CREATE FUNCTION "public"."hasnt_rule"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2, $3) IS NULL, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_rule"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_rule(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_rule"(name, name, name);
CREATE FUNCTION "public"."hasnt_rule"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2, $3) IS NULL, 'Relation ' || quote_ident($1) || '.' || quote_ident($2) || ' should not have rule ' || quote_ident($3) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_rule"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_rule(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_rule"(name, name, text);
CREATE FUNCTION "public"."hasnt_rule"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2) IS NULL, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_rule"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.hasnt_rule(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hasnt_rule"(name, name);
CREATE FUNCTION "public"."hasnt_rule"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _is_instead($1, $2) IS NULL, 'Relation ' || quote_ident($1) || ' should not have rule ' || quote_ident($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."hasnt_rule"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_instead(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_instead"(name, name, name, text);
CREATE FUNCTION "public"."rule_is_instead"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    is_it boolean := _is_instead($1, $2, $3);
BEGIN
    IF is_it IS NOT NULL THEN RETURN ok( is_it, $4 ); END IF;
    RETURN ok( FALSE, $4 ) || E'\n' || diag(
        '    Rule ' || quote_ident($3) || ' does not exist'
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_instead"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_instead(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_instead"(name, name, name);
CREATE FUNCTION "public"."rule_is_instead"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT rule_is_instead( $1, $2, $3, 'Rule ' || quote_ident($3) || ' on relation ' || quote_ident($1) || '.' || quote_ident($2) || ' should be an INSTEAD rule' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_instead"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_instead(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_instead"(name, name);
CREATE FUNCTION "public"."rule_is_instead"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT rule_is_instead($1, $2, 'Rule ' || quote_ident($2) || ' on relation ' || quote_ident($1) || ' should be an INSTEAD rule' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_instead"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._expand_on(bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_expand_on"(bpchar);
CREATE FUNCTION "public"."_expand_on"(IN bpchar) RETURNS "text" 
	AS $BODY$
   SELECT CASE $1
          WHEN '1' THEN 'SELECT'
          WHEN '2' THEN 'UPDATE'
          WHEN '3' THEN 'INSERT'
          WHEN '4' THEN 'DELETE'
          ELSE          'UNKNOWN' END
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_expand_on"(IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._contract_on(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_contract_on"(text);
CREATE FUNCTION "public"."_contract_on"(IN text) RETURNS "char" 
	AS $BODY$
   SELECT CASE substring(LOWER($1) FROM 1 FOR 1)
          WHEN 's' THEN '1'::"char"
          WHEN 'u' THEN '2'::"char"
          WHEN 'i' THEN '3'::"char"
          WHEN 'd' THEN '4'::"char"
          ELSE          '0'::"char" END
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_contract_on"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._rule_on(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_rule_on"(name, name, name);
CREATE FUNCTION "public"."_rule_on"(IN name, IN name, IN name) RETURNS "char" 
	AS $BODY$
    SELECT r.ev_type
      FROM pg_catalog.pg_rewrite r
      JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
      JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
     WHERE r.rulename = $3
       AND c.relname  = $2
       AND n.nspname  = $1
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_rule_on"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._rule_on(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_rule_on"(name, name);
CREATE FUNCTION "public"."_rule_on"(IN name, IN name) RETURNS "char" 
	AS $BODY$
    SELECT r.ev_type
      FROM pg_catalog.pg_rewrite r
      JOIN pg_catalog.pg_class c     ON c.oid = r.ev_class
     WHERE r.rulename = $2
       AND c.relname  = $1
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_rule_on"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_on(name, name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_on"(name, name, name, text, text);
CREATE FUNCTION "public"."rule_is_on"(IN name, IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want char := _contract_on($4);
    have char := _rule_on($1, $2, $3);
BEGIN
    IF have IS NOT NULL THEN
        RETURN is( _expand_on(have), _expand_on(want), $5 );
    END IF;

    RETURN ok( false, $5 ) || E'\n' || diag(
        '    Rule ' || quote_ident($3) || ' does not exist on '
        || quote_ident($1) || '.' || quote_ident($2)
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_on"(IN name, IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_on(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_on"(name, name, name, text);
CREATE FUNCTION "public"."rule_is_on"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT rule_is_on(
        $1, $2, $3, $4,
        'Rule ' || quote_ident($3) || ' should be on ' || _expand_on(_contract_on($4)::char)
        || ' to ' || quote_ident($1) || '.' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_on"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_on(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_on"(name, name, text, text);
CREATE FUNCTION "public"."rule_is_on"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want char := _contract_on($3);
    have char := _rule_on($1, $2);
BEGIN
    IF have IS NOT NULL THEN
        RETURN is( _expand_on(have), _expand_on(want), $4 );
    END IF;

    RETURN ok( false, $4 ) || E'\n' || diag(
        '    Rule ' || quote_ident($2) || ' does not exist on '
        || quote_ident($1)
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_on"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.rule_is_on(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."rule_is_on"(name, name, text);
CREATE FUNCTION "public"."rule_is_on"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT rule_is_on(
        $1, $2, $3,
        'Rule ' || quote_ident($2) || ' should be on '
        || _expand_on(_contract_on($3)::char) || ' to ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."rule_is_on"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._nosuch(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_nosuch"(name, name, _name);
CREATE FUNCTION "public"."_nosuch"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT E'\n' || diag(
        '    Function '
          || CASE WHEN $1 IS NOT NULL THEN quote_ident($1) || '.' ELSE '' END
          || quote_ident($2) || '('
          || array_to_string($3, ', ') || ') does not exist'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_nosuch"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._func_compare(name, name, _name, bool, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_func_compare"(name, name, _name, bool, text);
CREATE FUNCTION "public"."_func_compare"(IN name, IN name, IN _name, IN bool, IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $4 IS NULL
      THEN ok( FALSE, $5 ) || _nosuch($1, $2, $3)
      ELSE ok( $4, $5 )
      END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_func_compare"(IN name, IN name, IN _name, IN bool, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._func_compare(name, name, anyelement, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_func_compare"(name, name, anyelement, anyelement, text);
CREATE FUNCTION "public"."_func_compare"(IN name, IN name, IN anyelement, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $3 IS NULL
      THEN ok( FALSE, $5 ) || _nosuch($1, $2, '{}')
      ELSE is( $3, $4, $5 )
      END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_func_compare"(IN name, IN name, IN anyelement, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._func_compare(name, name, bool, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_func_compare"(name, name, bool, text);
CREATE FUNCTION "public"."_func_compare"(IN name, IN name, IN bool, IN text) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $3 IS NULL
      THEN ok( FALSE, $4 ) || _nosuch($1, $2, '{}')
      ELSE ok( $3, $4 )
      END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_func_compare"(IN name, IN name, IN bool, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._lang(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_lang"(name, name, _name);
CREATE FUNCTION "public"."_lang"(IN name, IN name, IN _name) RETURNS "name" 
	AS $BODY$
    SELECT l.lanname
      FROM tap_funky f
      JOIN pg_catalog.pg_language l ON f.langoid = l.oid
     WHERE f.schema = $1
       and f.name   = $2
       AND f.args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_lang"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._lang(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_lang"(name, name);
CREATE FUNCTION "public"."_lang"(IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT l.lanname
      FROM tap_funky f
      JOIN pg_catalog.pg_language l ON f.langoid = l.oid
     WHERE f.schema = $1
       and f.name   = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_lang"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._lang(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_lang"(name, _name);
CREATE FUNCTION "public"."_lang"(IN name, IN _name) RETURNS "name" 
	AS $BODY$
    SELECT l.lanname
      FROM tap_funky f
      JOIN pg_catalog.pg_language l ON f.langoid = l.oid
     WHERE f.name = $1
       AND f.args = array_to_string($2, ',')
       AND f.is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_lang"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._lang(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_lang"(name);
CREATE FUNCTION "public"."_lang"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT l.lanname
      FROM tap_funky f
      JOIN pg_catalog.pg_language l ON f.langoid = l.oid
     WHERE f.name = $1
       AND f.is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_lang"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name, _name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name, _name, name, text);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name, IN _name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _lang($1, $2, $3), $4, $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name, IN _name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name, _name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name, _name, name);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name, IN _name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_lang_is(
        $1, $2, $3, $4,
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be written in ' || quote_ident($4)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name, IN _name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name, name, text);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _lang($1, $2), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name, name);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_lang_is(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '.' || quote_ident($2)
        || '() should be written in ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, _name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, _name, name, text);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN _name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _lang($1, $2), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN _name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, _name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, _name, name);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN _name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_lang_is(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be written in ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN _name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name, text);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _lang($1), $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_lang_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_lang_is"(name, name);
CREATE FUNCTION "public"."function_lang_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_lang_is(
        $1, $2,
        'Function ' || quote_ident($1)
        || '() should be written in ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_lang_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._returns(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_returns"(name, name, _name);
CREATE FUNCTION "public"."_returns"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT returns
      FROM tap_funky
     WHERE schema = $1
       AND name   = $2
       AND args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_returns"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._returns(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_returns"(name, name);
CREATE FUNCTION "public"."_returns"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT returns FROM tap_funky WHERE schema = $1 AND name = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_returns"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._returns(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_returns"(name, _name);
CREATE FUNCTION "public"."_returns"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT returns
      FROM tap_funky
     WHERE name = $1
       AND args = array_to_string($2, ',')
       AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_returns"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._returns(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_returns"(name);
CREATE FUNCTION "public"."_returns"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT returns FROM tap_funky WHERE name = $1 AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_returns"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, name, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, name, _name, text, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN name, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _returns($1, $2, $3), $4, $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN name, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, name, _name, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT function_returns(
        $1, $2, $3, $4,
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should return ' || $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, name, text, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _returns($1, $2), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, name, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT function_returns(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '.' || quote_ident($2)
        || '() should return ' || $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, _name, text, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _returns($1, $2), $3, $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, _name, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT function_returns(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should return ' || $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, text, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _returns($1), $2, $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_returns(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_returns"(name, text);
CREATE FUNCTION "public"."function_returns"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT function_returns(
        $1, $2,
        'Function ' || quote_ident($1) || '() should return ' || $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_returns"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._definer(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_definer"(name, name, _name);
CREATE FUNCTION "public"."_definer"(IN name, IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_definer
      FROM tap_funky
     WHERE schema = $1
       AND name   = $2
       AND args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_definer"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._definer(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_definer"(name, name);
CREATE FUNCTION "public"."_definer"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_definer FROM tap_funky WHERE schema = $1 AND name = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_definer"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._definer(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_definer"(name, _name);
CREATE FUNCTION "public"."_definer"(IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_definer
      FROM tap_funky
     WHERE name = $1
       AND args = array_to_string($2, ',')
       AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_definer"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._definer(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_definer"(name);
CREATE FUNCTION "public"."_definer"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_definer FROM tap_funky WHERE name = $1 AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_definer"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, name, _name, text);
CREATE FUNCTION "public"."is_definer"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _definer($1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, name, _name);
CREATE FUNCTION "public"."is_definer"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _definer($1, $2, $3),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be security definer'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, name, text);
CREATE FUNCTION "public"."is_definer"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _definer($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, name);
CREATE FUNCTION "public"."is_definer"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _definer($1, $2),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should be security definer'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, _name, text);
CREATE FUNCTION "public"."is_definer"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _definer($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, _name);
CREATE FUNCTION "public"."is_definer"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _definer($1, $2),
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be security definer'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name, text);
CREATE FUNCTION "public"."is_definer"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _definer($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_definer(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_definer"(name);
CREATE FUNCTION "public"."is_definer"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _definer($1), 'Function ' || quote_ident($1) || '() should be security definer' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_definer"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._agg(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_agg"(name, name, _name);
CREATE FUNCTION "public"."_agg"(IN name, IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_agg
      FROM tap_funky
     WHERE schema = $1
       AND name   = $2
       AND args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_agg"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._agg(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_agg"(name, name);
CREATE FUNCTION "public"."_agg"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_agg FROM tap_funky WHERE schema = $1 AND name = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_agg"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._agg(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_agg"(name, _name);
CREATE FUNCTION "public"."_agg"(IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_agg
      FROM tap_funky
     WHERE name = $1
       AND args = array_to_string($2, ',')
       AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_agg"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._agg(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_agg"(name);
CREATE FUNCTION "public"."_agg"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_agg FROM tap_funky WHERE name = $1 AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_agg"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, name, _name, text);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _agg($1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, name, _name);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _agg($1, $2, $3),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be an aggregate function'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, name, text);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _agg($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, name);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _agg($1, $2),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should be an aggregate function'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, _name, text);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _agg($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, _name);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _agg($1, $2),
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be an aggregate function'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name, text);
CREATE FUNCTION "public"."is_aggregate"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _agg($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_aggregate(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_aggregate"(name);
CREATE FUNCTION "public"."is_aggregate"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _agg($1), 'Function ' || quote_ident($1) || '() should be an aggregate function' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_aggregate"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._strict(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_strict"(name, name, _name);
CREATE FUNCTION "public"."_strict"(IN name, IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_strict
      FROM tap_funky
     WHERE schema = $1
       AND name   = $2
       AND args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_strict"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._strict(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_strict"(name, name);
CREATE FUNCTION "public"."_strict"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_strict FROM tap_funky WHERE schema = $1 AND name = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_strict"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._strict(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_strict"(name, _name);
CREATE FUNCTION "public"."_strict"(IN name, IN _name) RETURNS "bool" 
	AS $BODY$
    SELECT is_strict
      FROM tap_funky
     WHERE name = $1
       AND args = array_to_string($2, ',')
       AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_strict"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._strict(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_strict"(name);
CREATE FUNCTION "public"."_strict"(IN name) RETURNS "bool" 
	AS $BODY$
    SELECT is_strict FROM tap_funky WHERE name = $1 AND is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_strict"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, name, _name, text);
CREATE FUNCTION "public"."is_strict"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _strict($1, $2, $3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, name, _name);
CREATE FUNCTION "public"."is_strict"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _strict($1, $2, $3),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be strict'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, name, text);
CREATE FUNCTION "public"."is_strict"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _strict($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, name);
CREATE FUNCTION "public"."is_strict"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _strict($1, $2),
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should be strict'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, _name, text);
CREATE FUNCTION "public"."is_strict"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _strict($1, $2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, _name);
CREATE FUNCTION "public"."is_strict"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT ok(
        _strict($1, $2),
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be strict'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name, text);
CREATE FUNCTION "public"."is_strict"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _strict($1), $2 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_strict(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_strict"(name);
CREATE FUNCTION "public"."is_strict"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT ok( _strict($1), 'Function ' || quote_ident($1) || '() should be strict' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_strict"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._expand_vol(bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_expand_vol"(bpchar);
CREATE FUNCTION "public"."_expand_vol"(IN bpchar) RETURNS "text" 
	AS $BODY$
   SELECT CASE $1
          WHEN 'i' THEN 'IMMUTABLE'
          WHEN 's' THEN 'STABLE'
          WHEN 'v' THEN 'VOLATILE'
          ELSE          'UNKNOWN' END
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_expand_vol"(IN bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._refine_vol(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_refine_vol"(text);
CREATE FUNCTION "public"."_refine_vol"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT _expand_vol(substring(LOWER($1) FROM 1 FOR 1)::char);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	IMMUTABLE;
ALTER FUNCTION "public"."_refine_vol"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._vol(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_vol"(name, name, _name);
CREATE FUNCTION "public"."_vol"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _expand_vol(volatility)
      FROM tap_funky f
     WHERE f.schema = $1
       and f.name   = $2
       AND f.args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_vol"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._vol(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_vol"(name, name);
CREATE FUNCTION "public"."_vol"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT _expand_vol(volatility) FROM tap_funky f
     WHERE f.schema = $1 and f.name = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_vol"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._vol(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_vol"(name, _name);
CREATE FUNCTION "public"."_vol"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _expand_vol(volatility)
      FROM tap_funky f
     WHERE f.name = $1
       AND f.args = array_to_string($2, ',')
       AND f.is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_vol"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._vol(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_vol"(name);
CREATE FUNCTION "public"."_vol"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT _expand_vol(volatility) FROM tap_funky f
     WHERE f.name = $1 AND f.is_visible;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_vol"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, name, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, name, _name, text, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN name, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, $3, _vol($1, $2, $3), _refine_vol($4), $5 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN name, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, name, _name, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT volatility_is(
        $1, $2, $3, $4,
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be ' || _refine_vol($4)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, name, text, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare($1, $2, _vol($1, $2), _refine_vol($3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, name, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT volatility_is(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '.' || quote_ident($2)
        || '() should be ' || _refine_vol($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, _name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, _name, text, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN _name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, $2, _vol($1, $2), _refine_vol($3), $4 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN _name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, _name, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT volatility_is(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be ' || _refine_vol($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, text, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _func_compare(NULL, $1, _vol($1), _refine_vol($2), $3 );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.volatility_is(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."volatility_is"(name, text);
CREATE FUNCTION "public"."volatility_is"(IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT volatility_is(
        $1, $2,
        'Function ' || quote_ident($1) || '() should be ' || _refine_vol($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."volatility_is"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.runtests()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."runtests"();
CREATE FUNCTION "public"."runtests"() RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM runtests( '^test' );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."runtests"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._temptable(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_temptable"(text, text);
CREATE FUNCTION "public"."_temptable"(IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    EXECUTE 'CREATE TEMP TABLE ' || $2 || ' AS ' || _query($1);
    return $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_temptable"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._temptable(anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_temptable"(anyarray, text);
CREATE FUNCTION "public"."_temptable"(IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    CREATE TEMP TABLE _____coltmp___ AS
    SELECT $1[i]
    FROM generate_series(array_lower($1, 1), array_upper($1, 1)) s(i);
    EXECUTE 'ALTER TABLE _____coltmp___ RENAME TO ' || $2;
    return $2;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_temptable"(IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.check_test(text, bool, text, text, text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_test"(text, bool, text, text, text, bool);
CREATE FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text, IN text, IN bool) RETURNS SETOF "text" 
	AS $BODY$
DECLARE
    tnumb   INTEGER;
    aok     BOOLEAN;
    adescr  TEXT;
    res     BOOLEAN;
    descr   TEXT;
    adiag   TEXT;
    have    ALIAS FOR $1;
    eok     ALIAS FOR $2;
    name    ALIAS FOR $3;
    edescr  ALIAS FOR $4;
    ediag   ALIAS FOR $5;
    matchit ALIAS FOR $6;
BEGIN
    -- What test was it that just ran?
    tnumb := currval('__tresults___numb_seq');

    -- Fetch the results.
    EXECUTE 'SELECT aok, descr FROM __tresults__ WHERE numb = ' || tnumb
       INTO aok, adescr;

    -- Now delete those results.
    EXECUTE 'DELETE FROM __tresults__ WHERE numb = ' || tnumb;
    EXECUTE 'ALTER SEQUENCE __tresults___numb_seq RESTART WITH ' || tnumb;

    -- Set up the description.
    descr := coalesce( name || ' ', 'Test ' ) || 'should ';

    -- So, did the test pass?
    RETURN NEXT is(
        aok,
        eok,
        descr || CASE eok WHEN true then 'pass' ELSE 'fail' END
    );

    -- Was the description as expected?
    IF edescr IS NOT NULL THEN
        RETURN NEXT is(
            adescr,
            edescr,
            descr || 'have the proper description'
        );
    END IF;

    -- Were the diagnostics as expected?
    IF ediag IS NOT NULL THEN
        -- Remove ok and the test number.
        adiag := substring(
            have
            FROM CASE WHEN aok THEN 4 ELSE 9 END + char_length(tnumb::text)
        );

        -- Remove the description, if there is one.
        IF adescr <> '' THEN
            adiag := substring( adiag FROM 3 + char_length( diag( adescr ) ) );
        END IF;

        -- Remove failure message from ok().
        IF NOT aok THEN
           adiag := substring(
               adiag
               FROM 14 + char_length(tnumb::text)
                       + CASE adescr WHEN '' THEN 3 ELSE 3 + char_length( diag( adescr ) ) END
           );
        END IF;

        -- Remove the #s.
        adiag := replace( substring(adiag from 3), E'\n# ', E'\n' );

        -- Now compare the diagnostics.
        IF matchit THEN
            RETURN NEXT matches(
                adiag,
                ediag,
                descr || 'have the proper diagnostics'
            );
        ELSE
            RETURN NEXT is(
                adiag,
                ediag,
                descr || 'have the proper diagnostics'
            );
        END IF;
    END IF;

    -- And we're done
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text, IN text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.check_test(text, bool, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_test"(text, bool, text, text, text);
CREATE FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text, IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM check_test( $1, $2, $3, $4, $5, FALSE );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.check_test(text, bool, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_test"(text, bool, text, text);
CREATE FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM check_test( $1, $2, $3, $4, NULL, FALSE );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."check_test"(IN text, IN bool, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.check_test(text, bool, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_test"(text, bool, text);
CREATE FUNCTION "public"."check_test"(IN text, IN bool, IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM check_test( $1, $2, $3, NULL, NULL, FALSE );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."check_test"(IN text, IN bool, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.check_test(text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_test"(text, bool);
CREATE FUNCTION "public"."check_test"(IN text, IN bool) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM check_test( $1, $2, NULL, NULL, NULL, FALSE );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."check_test"(IN text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.findfuncs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."findfuncs"(name, text);
CREATE FUNCTION "public"."findfuncs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
    SELECT ARRAY(
        SELECT DISTINCT quote_ident(n.nspname) || '.' || quote_ident(p.proname) AS pname
          FROM pg_catalog.pg_proc p
          JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
         WHERE n.nspname = $1
           AND p.proname ~ $2
         ORDER BY pname
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."findfuncs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.findfuncs(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."findfuncs"(text);
CREATE FUNCTION "public"."findfuncs"(IN text) RETURNS "_text" 
	AS $BODY$
    SELECT ARRAY(
        SELECT DISTINCT quote_ident(n.nspname) || '.' || quote_ident(p.proname) AS pname
          FROM pg_catalog.pg_proc p
          JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
         WHERE pg_catalog.pg_function_is_visible(p.oid)
           AND p.proname ~ $1
         ORDER BY pname
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."findfuncs"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._runem(_text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_runem"(_text, bool);
CREATE FUNCTION "public"."_runem"(IN _text, IN bool) RETURNS SETOF "text" 
	AS $BODY$
DECLARE
    tap    text;
    lbound int := array_lower($1, 1);
BEGIN
    IF lbound IS NULL THEN RETURN; END IF;
    FOR i IN lbound..array_upper($1, 1) LOOP
        -- Send the name of the function to diag if warranted.
        IF $2 THEN RETURN NEXT diag( $1[i] || '()' ); END IF;
        -- Execute the tap function and return its results.
        FOR tap IN EXECUTE 'SELECT * FROM ' || $1[i] || '()' LOOP
            RETURN NEXT tap;
        END LOOP;
    END LOOP;
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_runem"(IN _text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._is_verbose()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_is_verbose"();
CREATE FUNCTION "public"."_is_verbose"() RETURNS "bool" 
	AS $BODY$
    SELECT current_setting('client_min_messages') NOT IN (
        'warning', 'error', 'fatal', 'panic'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	STABLE;
ALTER FUNCTION "public"."_is_verbose"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.do_tap(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."do_tap"(name, text);
CREATE FUNCTION "public"."do_tap"(IN name, IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runem( findfuncs($1, $2), _is_verbose() );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."do_tap"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.do_tap(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."do_tap"(name);
CREATE FUNCTION "public"."do_tap"(IN name) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runem( findfuncs($1, '^test'), _is_verbose() );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."do_tap"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.do_tap(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."do_tap"(text);
CREATE FUNCTION "public"."do_tap"(IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runem( findfuncs($1), _is_verbose() );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."do_tap"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.do_tap()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."do_tap"();
CREATE FUNCTION "public"."do_tap"() RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runem( findfuncs('^test'), _is_verbose());
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."do_tap"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._currtest()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_currtest"();
CREATE FUNCTION "public"."_currtest"() RETURNS "int4" 
	AS $BODY$
BEGIN
    RETURN currval('__tresults___numb_seq');
EXCEPTION
    WHEN object_not_in_prerequisite_state THEN RETURN 0;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_currtest"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._cleanup()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_cleanup"();
CREATE FUNCTION "public"."_cleanup"() RETURNS "bool" 
	AS $BODY$
    DROP TABLE __tresults__;
    DROP SEQUENCE __tresults___numb_seq;
    DROP TABLE __tcache__;
    DROP SEQUENCE __tcache___id_seq;
    SELECT TRUE;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_cleanup"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.diag_test_name(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."diag_test_name"(text);
CREATE FUNCTION "public"."diag_test_name"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT diag($1 || '()');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."diag_test_name"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._runner(_text, _text, _text, _text, _text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_runner"(_text, _text, _text, _text, _text);
CREATE FUNCTION "public"."_runner"(IN _text, IN _text, IN _text, IN _text, IN _text) RETURNS SETOF "text" 
	AS $BODY$
DECLARE
    startup  ALIAS FOR $1;
    shutdown ALIAS FOR $2;
    setup    ALIAS FOR $3;
    teardown ALIAS FOR $4;
    tests    ALIAS FOR $5;
    tap      text;
    verbos   boolean := _is_verbose(); -- verbose is a reserved word in 8.5.
    num_faild INTEGER := 0;
BEGIN
    BEGIN
        -- No plan support.
        PERFORM * FROM no_plan();
        FOR tap IN SELECT * FROM _runem(startup, false) LOOP RETURN NEXT tap; END LOOP;
    EXCEPTION
        -- Catch all exceptions and simply rethrow custom exceptions. This
        -- will roll back everything in the above block.
        WHEN raise_exception THEN
            RAISE EXCEPTION '%', SQLERRM;
    END;

    BEGIN
        FOR i IN 1..array_upper(tests, 1) LOOP
            BEGIN
                -- What test are we running?
                IF verbos THEN RETURN NEXT diag_test_name(tests[i]); END IF;

                -- Run the setup functions.
                FOR tap IN SELECT * FROM _runem(setup, false) LOOP RETURN NEXT tap; END LOOP;

                -- Run the actual test function.
                FOR tap IN EXECUTE 'SELECT * FROM ' || tests[i] || '()' LOOP
                    RETURN NEXT tap;
                END LOOP;

                -- Run the teardown functions.
                FOR tap IN SELECT * FROM _runem(teardown, false) LOOP RETURN NEXT tap; END LOOP;

                -- Remember how many failed and then roll back.
                num_faild := num_faild + num_failed();
                RAISE EXCEPTION '__TAP_ROLLBACK__';

            EXCEPTION WHEN raise_exception THEN
                IF SQLERRM <> '__TAP_ROLLBACK__' THEN
                    -- We didn't raise it, so propagate it.
                    RAISE EXCEPTION '%', SQLERRM;
                END IF;
            END;
        END LOOP;

        -- Run the shutdown functions.
        FOR tap IN SELECT * FROM _runem(shutdown, false) LOOP RETURN NEXT tap; END LOOP;

        -- Raise an exception to rollback any changes.
        RAISE EXCEPTION '__TAP_ROLLBACK__';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM <> '__TAP_ROLLBACK__' THEN
            -- We didn't raise it, so propagate it.
            RAISE EXCEPTION '%', SQLERRM;
        END IF;
    END;
    -- Finish up.
    FOR tap IN SELECT * FROM _finish( currval('__tresults___numb_seq')::integer, 0, num_faild ) LOOP
        RETURN NEXT tap;
    END LOOP;

    -- Clean up and return.
    PERFORM _cleanup();
    RETURN;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_runner"(IN _text, IN _text, IN _text, IN _text, IN _text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.runtests(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."runtests"(name, text);
CREATE FUNCTION "public"."runtests"(IN name, IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runner(
        findfuncs( $1, '^startup' ),
        findfuncs( $1, '^shutdown' ),
        findfuncs( $1, '^setup' ),
        findfuncs( $1, '^teardown' ),
        findfuncs( $1, $2 )
    );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."runtests"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.runtests(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."runtests"(name);
CREATE FUNCTION "public"."runtests"(IN name) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM runtests( $1, '^test' );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."runtests"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.runtests(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."runtests"(text);
CREATE FUNCTION "public"."runtests"(IN text) RETURNS SETOF "text" 
	AS $BODY$
    SELECT * FROM _runner(
        findfuncs( '^startup' ),
        findfuncs( '^shutdown' ),
        findfuncs( '^setup' ),
        findfuncs( '^teardown' ),
        findfuncs( $1 )
    );
$BODY$
	LANGUAGE sql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."runtests"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._temptypes(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_temptypes"(text);
CREATE FUNCTION "public"."_temptypes"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT array_to_string(ARRAY(
        SELECT pg_catalog.format_type(a.atttypid, a.atttypmod)
          FROM pg_catalog.pg_attribute a
          JOIN pg_catalog.pg_class c ON a.attrelid = c.oid
         WHERE c.oid = ('pg_temp.' || $1)::pg_catalog.regclass
           AND attnum > 0
           AND NOT attisdropped
         ORDER BY attnum
    ), ',');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_temptypes"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._docomp(text, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_docomp"(text, text, text, text);
CREATE FUNCTION "public"."_docomp"(IN text, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have    ALIAS FOR $1;
    want    ALIAS FOR $2;
    extras  TEXT[]  := '{}';
    missing TEXT[]  := '{}';
    res     BOOLEAN := TRUE;
    msg     TEXT    := '';
    rec     RECORD;
BEGIN
    BEGIN
        -- Find extra records.
        FOR rec in EXECUTE 'SELECT * FROM ' || have || ' EXCEPT ' || $4
                        || 'SELECT * FROM ' || want LOOP
            extras := extras || rec::text;
        END LOOP;

        -- Find missing records.
        FOR rec in EXECUTE 'SELECT * FROM ' || want || ' EXCEPT ' || $4
                        || 'SELECT * FROM ' || have LOOP
            missing := missing || rec::text;
        END LOOP;

        -- Drop the temporary tables.
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
    EXCEPTION WHEN syntax_error OR datatype_mismatch THEN
        msg := E'\n' || diag(
            E'    Columns differ between queries:\n'
            || '        have: (' || _temptypes(have) || E')\n'
            || '        want: (' || _temptypes(want) || ')'
        );
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
        RETURN ok(FALSE, $3) || msg;
    END;

    -- What extra records do we have?
    IF extras[1] IS NOT NULL THEN
        res := FALSE;
        msg := E'\n' || diag(
            E'    Extra records:\n        '
            ||  array_to_string( extras, E'\n        ' )
        );
    END IF;

    -- What missing records do we have?
    IF missing[1] IS NOT NULL THEN
        res := FALSE;
        msg := msg || E'\n' || diag(
            E'    Missing records:\n        '
            ||  array_to_string( missing, E'\n        ' )
        );
    END IF;

    RETURN ok(res, $3) || msg;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_docomp"(IN text, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relcomp(text, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relcomp"(text, text, text, text);
CREATE FUNCTION "public"."_relcomp"(IN text, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _docomp(
        _temptable( $1, '__taphave__' ),
        _temptable( $2, '__tapwant__' ),
        $3, $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relcomp"(IN text, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relcomp(text, anyarray, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relcomp"(text, anyarray, text, text);
CREATE FUNCTION "public"."_relcomp"(IN text, IN anyarray, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _docomp(
        _temptable( $1, '__taphave__' ),
        _temptable( $2, '__tapwant__' ),
        $3, $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relcomp"(IN text, IN anyarray, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_eq(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_eq"(text, text, text);
CREATE FUNCTION "public"."set_eq"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_eq"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_eq(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_eq"(text, text);
CREATE FUNCTION "public"."set_eq"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::text, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_eq"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_eq(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_eq"(text, anyarray, text);
CREATE FUNCTION "public"."set_eq"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_eq"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_eq(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_eq"(text, anyarray);
CREATE FUNCTION "public"."set_eq"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::text, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_eq"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_eq(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_eq"(text, text, text);
CREATE FUNCTION "public"."bag_eq"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_eq"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._do_ne(text, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_do_ne"(text, text, text, text);
CREATE FUNCTION "public"."_do_ne"(IN text, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have    ALIAS FOR $1;
    want    ALIAS FOR $2;
    extras  TEXT[]  := '{}';
    missing TEXT[]  := '{}';
    res     BOOLEAN := TRUE;
    msg     TEXT    := '';
BEGIN
    BEGIN
        -- Find extra records.
        EXECUTE 'SELECT EXISTS ( '
             || '( SELECT * FROM ' || have || ' EXCEPT ' || $4
             || '  SELECT * FROM ' || want
             || ' ) UNION ( '
             || '  SELECT * FROM ' || want || ' EXCEPT ' || $4
             || '  SELECT * FROM ' || have
             || ' ) LIMIT 1 )' INTO res;

        -- Drop the temporary tables.
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
    EXCEPTION WHEN syntax_error OR datatype_mismatch THEN
        msg := E'\n' || diag(
            E'    Columns differ between queries:\n'
            || '        have: (' || _temptypes(have) || E')\n'
            || '        want: (' || _temptypes(want) || ')'
        );
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
        RETURN ok(FALSE, $3) || msg;
    END;

    -- Return the value from the query.
    RETURN ok(res, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_do_ne"(IN text, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relne(text, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relne"(text, text, text, text);
CREATE FUNCTION "public"."_relne"(IN text, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _do_ne(
        _temptable( $1, '__taphave__' ),
        _temptable( $2, '__tapwant__' ),
        $3, $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relne"(IN text, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relne(text, anyarray, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relne"(text, anyarray, text, text);
CREATE FUNCTION "public"."_relne"(IN text, IN anyarray, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _do_ne(
        _temptable( $1, '__taphave__' ),
        _temptable( $2, '__tapwant__' ),
        $3, $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relne"(IN text, IN anyarray, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_ne(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_ne"(text, text, text);
CREATE FUNCTION "public"."set_ne"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, $3, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_ne"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_ne(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_ne"(text, text);
CREATE FUNCTION "public"."set_ne"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, NULL::text, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_ne"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_ne(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_ne"(text, anyarray, text);
CREATE FUNCTION "public"."set_ne"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, $3, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_ne"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_ne(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_ne"(text, anyarray);
CREATE FUNCTION "public"."set_ne"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, NULL::text, '' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_ne"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_ne(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_ne"(text, text, text);
CREATE FUNCTION "public"."bag_ne"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, $3, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_ne"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_ne(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_ne"(text, text);
CREATE FUNCTION "public"."bag_ne"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, NULL::text, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_ne"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_ne(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_ne"(text, anyarray, text);
CREATE FUNCTION "public"."bag_ne"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, $3, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_ne"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_ne(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_ne"(text, anyarray);
CREATE FUNCTION "public"."bag_ne"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT _relne( $1, $2, NULL::text, 'ALL ' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_ne"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._relcomp(text, text, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_relcomp"(text, text, text, text, text);
CREATE FUNCTION "public"."_relcomp"(IN text, IN text, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have    TEXT    := _temptable( $1, '__taphave__' );
    want    TEXT    := _temptable( $2, '__tapwant__' );
    results TEXT[]  := '{}';
    res     BOOLEAN := TRUE;
    msg     TEXT    := '';
    rec     RECORD;
BEGIN
    BEGIN
        -- Find relevant records.
        FOR rec in EXECUTE 'SELECT * FROM ' || want || ' ' || $4
                       || ' SELECT * FROM ' || have LOOP
            results := results || rec::text;
        END LOOP;

        -- Drop the temporary tables.
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
    EXCEPTION WHEN syntax_error OR datatype_mismatch THEN
        msg := E'\n' || diag(
            E'    Columns differ between queries:\n'
            || '        have: (' || _temptypes(have) || E')\n'
            || '        want: (' || _temptypes(want) || ')'
        );
        EXECUTE 'DROP TABLE ' || have;
        EXECUTE 'DROP TABLE ' || want;
        RETURN ok(FALSE, $3) || msg;
    END;

    -- What records do we have?
    IF results[1] IS NOT NULL THEN
        res := FALSE;
        msg := msg || E'\n' || diag(
            '    ' || $5 || E' records:\n        '
            ||  array_to_string( results, E'\n        ' )
        );
    END IF;

    RETURN ok(res, $3) || msg;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_relcomp"(IN text, IN text, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_has(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_has"(text, text, text);
CREATE FUNCTION "public"."set_has"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'EXCEPT', 'Missing' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_has"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_has(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_has"(text, text);
CREATE FUNCTION "public"."set_has"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::TEXT, 'EXCEPT', 'Missing' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_has"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_has(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_has"(text, text, text);
CREATE FUNCTION "public"."bag_has"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'EXCEPT ALL', 'Missing' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_has"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_has(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_has"(text, text);
CREATE FUNCTION "public"."bag_has"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::TEXT, 'EXCEPT ALL', 'Missing' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_has"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_hasnt(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_hasnt"(text, text, text);
CREATE FUNCTION "public"."set_hasnt"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'INTERSECT', 'Extra' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_hasnt"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.set_hasnt(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_hasnt"(text, text);
CREATE FUNCTION "public"."set_hasnt"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::TEXT, 'INTERSECT', 'Extra' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."set_hasnt"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_hasnt(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_hasnt"(text, text, text);
CREATE FUNCTION "public"."bag_hasnt"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, $3, 'INTERSECT ALL', 'Extra' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_hasnt"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.bag_hasnt(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."bag_hasnt"(text, text);
CREATE FUNCTION "public"."bag_hasnt"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _relcomp( $1, $2, NULL::TEXT, 'INTERSECT ALL', 'Extra' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."bag_hasnt"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, text, text);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN want FOR EXECUTE _query($2);
    res := results_ne($1, want, $3);
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, text);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
    SELECT results_ne( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, refcursor, text);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have       ALIAS FOR $1;
    want       ALIAS FOR $2;
    have_rec   RECORD;
    want_rec   RECORD;
    have_found BOOLEAN;
    want_found BOOLEAN;
    rownum     INTEGER := 1;
BEGIN
    FETCH have INTO have_rec;
    have_found := FOUND;
    FETCH want INTO want_rec;
    want_found := FOUND;
    WHILE have_found OR want_found LOOP
        IF have_rec IS DISTINCT FROM want_rec OR have_found <> want_found THEN
            RETURN ok( false, $3 ) || E'\n' || diag(
                '    Results differ beginning at row ' || rownum || E':\n' ||
                '        have: ' || CASE WHEN have_found THEN have_rec::text ELSE 'NULL' END || E'\n' ||
                '        want: ' || CASE WHEN want_found THEN want_rec::text ELSE 'NULL' END
            );
        END IF;
        rownum = rownum + 1;
        FETCH have INTO have_rec;
        have_found := FOUND;
        FETCH want INTO want_rec;
        want_found := FOUND;
    END LOOP;

    RETURN ok( true, $3 );
EXCEPTION
    WHEN datatype_mismatch THEN
        RETURN ok( false, $3 ) || E'\n' || diag(
            E'    Number of columns or their types differ between the queries' ||
            CASE WHEN have_rec::TEXT = want_rec::text THEN '' ELSE E':\n' ||
                '        have: ' || CASE WHEN have_found THEN have_rec::text ELSE 'NULL' END || E'\n' ||
                '        want: ' || CASE WHEN want_found THEN want_rec::text ELSE 'NULL' END
            END
        );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, refcursor)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, refcursor);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN refcursor) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN refcursor) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, text, text);
CREATE FUNCTION "public"."results_eq"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    OPEN want FOR EXECUTE _query($2);
    res := results_eq(have, want, $3);
    CLOSE have;
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, text);
CREATE FUNCTION "public"."results_eq"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, anyarray, text);
CREATE FUNCTION "public"."results_eq"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    OPEN want FOR SELECT $2[i]
    FROM generate_series(array_lower($2, 1), array_upper($2, 1)) s(i);
    res := results_eq(have, want, $3);
    CLOSE have;
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, anyarray);
CREATE FUNCTION "public"."results_eq"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, refcursor, text);
CREATE FUNCTION "public"."results_eq"(IN text, IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    res := results_eq(have, $2, $3);
    CLOSE have;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(text, refcursor)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(text, refcursor);
CREATE FUNCTION "public"."results_eq"(IN text, IN refcursor) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN text, IN refcursor) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, text, text);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN want FOR EXECUTE _query($2);
    res := results_eq($1, want, $3);
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, text);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, anyarray, text);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN want FOR SELECT $2[i]
    FROM generate_series(array_lower($2, 1), array_upper($2, 1)) s(i);
    res := results_eq($1, want, $3);
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_eq(refcursor, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_eq"(refcursor, anyarray);
CREATE FUNCTION "public"."results_eq"(IN refcursor, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT results_eq( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_eq"(IN refcursor, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, refcursor, text);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have       ALIAS FOR $1;
    want       ALIAS FOR $2;
    have_rec   RECORD;
    want_rec   RECORD;
    have_found BOOLEAN;
    want_found BOOLEAN;
BEGIN
    FETCH have INTO have_rec;
    have_found := FOUND;
    FETCH want INTO want_rec;
    want_found := FOUND;
    WHILE have_found OR want_found LOOP
        IF have_rec IS DISTINCT FROM want_rec OR have_found <> want_found THEN
            RETURN ok( true, $3 );
        ELSE
            FETCH have INTO have_rec;
            have_found := FOUND;
            FETCH want INTO want_rec;
            want_found := FOUND;
        END IF;
    END LOOP;
    RETURN ok( false, $3 );
EXCEPTION
    WHEN datatype_mismatch THEN
        RETURN ok( false, $3 ) || E'\n' || diag(
            E'    Columns differ between queries:\n' ||
            '        have: ' || CASE WHEN have_found THEN have_rec::text ELSE 'NULL' END || E'\n' ||
            '        want: ' || CASE WHEN want_found THEN want_rec::text ELSE 'NULL' END
        );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, refcursor)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, refcursor);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN refcursor) RETURNS "text" 
	AS $BODY$
    SELECT results_ne( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN refcursor) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(text, text, text);
CREATE FUNCTION "public"."results_ne"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    OPEN want FOR EXECUTE _query($2);
    res := results_ne(have, want, $3);
    CLOSE have;
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(text, text);
CREATE FUNCTION "public"."results_ne"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT results_ne( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(text, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(text, anyarray, text);
CREATE FUNCTION "public"."results_ne"(IN text, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    OPEN want FOR SELECT $2[i]
    FROM generate_series(array_lower($2, 1), array_upper($2, 1)) s(i);
    res := results_ne(have, want, $3);
    CLOSE have;
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN text, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(text, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(text, anyarray);
CREATE FUNCTION "public"."results_ne"(IN text, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT results_ne( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN text, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(text, refcursor, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(text, refcursor, text);
CREATE FUNCTION "public"."results_ne"(IN text, IN refcursor, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    have REFCURSOR;
    res  TEXT;
BEGIN
    OPEN have FOR EXECUTE _query($1);
    res := results_ne(have, $2, $3);
    CLOSE have;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN text, IN refcursor, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, anyarray, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, anyarray, text);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN anyarray, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    want REFCURSOR;
    res  TEXT;
BEGIN
    OPEN want FOR SELECT $2[i]
    FROM generate_series(array_lower($2, 1), array_upper($2, 1)) s(i);
    res := results_ne($1, want, $3);
    CLOSE want;
    RETURN res;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN anyarray, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.results_ne(refcursor, anyarray)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."results_ne"(refcursor, anyarray);
CREATE FUNCTION "public"."results_ne"(IN refcursor, IN anyarray) RETURNS "text" 
	AS $BODY$
    SELECT results_ne( $1, $2, NULL::text );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."results_ne"(IN refcursor, IN anyarray) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isa_ok(anyelement, regtype, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isa_ok"(anyelement, regtype, text);
CREATE FUNCTION "public"."isa_ok"(IN anyelement, IN regtype, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    typeof regtype := pg_typeof($1);
BEGIN
    IF typeof = $2 THEN RETURN ok(true, $3 || ' isa ' || $2 ); END IF;
    RETURN ok(false, $3 || ' isa ' || $2 ) || E'\n' ||
        diag('    ' || $3 || ' isn''t a "' || $2 || '" it''s a "' || typeof || '"');
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isa_ok"(IN anyelement, IN regtype, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isa_ok(anyelement, regtype)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isa_ok"(anyelement, regtype);
CREATE FUNCTION "public"."isa_ok"(IN anyelement, IN regtype) RETURNS "text" 
	AS $BODY$
    SELECT isa_ok($1, $2, 'the value');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isa_ok"(IN anyelement, IN regtype) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_empty(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_empty"(text, text);
CREATE FUNCTION "public"."is_empty"(IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    extras  TEXT[]  := '{}';
    res     BOOLEAN := TRUE;
    msg     TEXT    := '';
    rec     RECORD;
BEGIN
    -- Find extra records.
    FOR rec in EXECUTE _query($1) LOOP
        extras := extras || rec::text;
    END LOOP;

    -- What extra records do we have?
    IF extras[1] IS NOT NULL THEN
        res := FALSE;
        msg := E'\n' || diag(
            E'    Unexpected records:\n        '
            ||  array_to_string( extras, E'\n        ' )
        );
    END IF;

    RETURN ok(res, $2) || msg;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_empty"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.is_empty(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."is_empty"(text);
CREATE FUNCTION "public"."is_empty"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT is_empty( $1, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."is_empty"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt_empty(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt_empty"(text, text);
CREATE FUNCTION "public"."isnt_empty"(IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    res  BOOLEAN := FALSE;
    rec  RECORD;
BEGIN
    -- Find extra records.
    FOR rec in EXECUTE _query($1) LOOP
        res := TRUE;
        EXIT;
    END LOOP;

    RETURN ok(res, $2);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt_empty"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.isnt_empty(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."isnt_empty"(text);
CREATE FUNCTION "public"."isnt_empty"(IN text) RETURNS "text" 
	AS $BODY$
    SELECT isnt_empty( $1, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."isnt_empty"(IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.collect_tap(_varchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."collect_tap"(_varchar);
CREATE FUNCTION "public"."collect_tap"(IN _varchar) RETURNS "text" 
	AS $BODY$
    SELECT array_to_string($1, E'\n');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."collect_tap"(IN _varchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._tlike(bool, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_tlike"(bool, text, text, text);
CREATE FUNCTION "public"."_tlike"(IN bool, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT ok( $1, $4 ) || CASE WHEN $1 THEN '' ELSE E'\n' || diag(
           '   error message: ' || COALESCE( quote_literal($2), 'NULL' ) ||
       E'\n   doesn''t match: ' || COALESCE( quote_literal($3), 'NULL' )
    ) END;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_tlike"(IN bool, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.operators_are(name, _text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."operators_are"(name, _text);
CREATE FUNCTION "public"."operators_are"(IN name, IN _text) RETURNS "text" 
	AS $BODY$
    SELECT operators_are($1, $2, 'Schema ' || quote_ident($1) || ' should have the correct operators' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."operators_are"(IN name, IN _text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_like(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_like"(text, text, text);
CREATE FUNCTION "public"."throws_like"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    EXECUTE _query($1);
    RETURN ok( FALSE, $3 ) || E'\n' || diag( '    no exception thrown' );
EXCEPTION WHEN OTHERS THEN
    return _tlike( SQLERRM ~~ $2, SQLERRM, $2, $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_like"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_like(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_like"(text, text);
CREATE FUNCTION "public"."throws_like"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_like($1, $2, 'Should throw exception like ' || quote_literal($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_like"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ilike(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ilike"(text, text, text);
CREATE FUNCTION "public"."throws_ilike"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    EXECUTE _query($1);
    RETURN ok( FALSE, $3 ) || E'\n' || diag( '    no exception thrown' );
EXCEPTION WHEN OTHERS THEN
    return _tlike( SQLERRM ~~* $2, SQLERRM, $2, $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ilike"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_ilike(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_ilike"(text, text);
CREATE FUNCTION "public"."throws_ilike"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_ilike($1, $2, 'Should throw exception like ' || quote_literal($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_ilike"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_matching(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_matching"(text, text, text);
CREATE FUNCTION "public"."throws_matching"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    EXECUTE _query($1);
    RETURN ok( FALSE, $3 ) || E'\n' || diag( '    no exception thrown' );
EXCEPTION WHEN OTHERS THEN
    return _tlike( SQLERRM ~ $2, SQLERRM, $2, $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_matching"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_matching(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_matching"(text, text);
CREATE FUNCTION "public"."throws_matching"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_matching($1, $2, 'Should throw exception matching ' || quote_literal($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_matching"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_imatching(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_imatching"(text, text, text);
CREATE FUNCTION "public"."throws_imatching"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
BEGIN
    EXECUTE _query($1);
    RETURN ok( FALSE, $3 ) || E'\n' || diag( '    no exception thrown' );
EXCEPTION WHEN OTHERS THEN
    return _tlike( SQLERRM ~* $2, SQLERRM, $2, $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_imatching"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.throws_imatching(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."throws_imatching"(text, text);
CREATE FUNCTION "public"."throws_imatching"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT throws_imatching($1, $2, 'Should throw exception matching ' || quote_literal($2) );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."throws_imatching"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.roles_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."roles_are"(_name, text);
CREATE FUNCTION "public"."roles_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'roles',
        ARRAY(
            SELECT rolname
              FROM pg_catalog.pg_roles
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT rolname
              FROM pg_catalog.pg_roles
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."roles_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.roles_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."roles_are"(_name);
CREATE FUNCTION "public"."roles_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT roles_are( $1, 'There should be the correct roles' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."roles_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_dtype(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_dtype"(name);
CREATE FUNCTION "public"."_get_dtype"(IN name) RETURNS "text" 
	AS $BODY$
    SELECT pg_catalog.format_type(t.oid, t.typtypmod)
      FROM pg_catalog.pg_type d
      JOIN pg_catalog.pg_type t  ON d.typbasetype  = t.oid
     WHERE d.typisdefined
       AND pg_catalog.pg_type_is_visible(d.oid)
       AND d.typname = LOWER($1)
       AND d.typtype = 'd'
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_dtype"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(name, text, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(name, text, name, text, text);
CREATE FUNCTION "public"."domain_type_is"(IN name, IN text, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1, $2, true);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $5 ) || E'\n' || diag (
            '   Domain ' || quote_ident($1) || '.' || $2
            || ' does not exist'
        );
    END IF;

    RETURN is( actual_type, quote_ident($3) || '.' || _quote_ident_like($4, actual_type), $5 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN name, IN text, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._types_are(name, _name, text, _bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_types_are"(name, _name, text, _bpchar);
CREATE FUNCTION "public"."_types_are"(IN name, IN _name, IN text, IN _bpchar) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'types',
        ARRAY(
            SELECT t.typname
              FROM pg_catalog.pg_type t
              LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
             WHERE (
                     t.typrelid = 0
                 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)
             )
               AND NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
               AND n.nspname = $1
               AND t.typtype = ANY( COALESCE($4, ARRAY['b', 'c', 'd', 'p', 'e']) )
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
               FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT t.typname
              FROM pg_catalog.pg_type t
              LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
             WHERE (
                     t.typrelid = 0
                 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)
             )
               AND NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
               AND n.nspname = $1
               AND t.typtype = ANY( COALESCE($4, ARRAY['b', 'c', 'd', 'p', 'e']) )
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_types_are"(IN name, IN _name, IN text, IN _bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.types_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."types_are"(name, _name, text);
CREATE FUNCTION "public"."types_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, $3, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."types_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.types_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."types_are"(name, _name);
CREATE FUNCTION "public"."types_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, 'Schema ' || quote_ident($1) || ' should have the correct types', NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."types_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(name, text, name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(name, text, name, text, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1, $2, true);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $5 ) || E'\n' || diag (
            '   Domain ' || quote_ident($1) || '.' || $2
            || ' does not exist'
        );
    END IF;

    RETURN isnt( actual_type, quote_ident($3) || '.' || _quote_ident_like($4, actual_type), $5 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(name, text, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(name, text, name, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_isnt(
        $1, $2, $3, $4,
        'Domain ' || quote_ident($1) || '.' || $2
        || ' should not extend type ' || quote_ident($3) || '.' || $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(name, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(name, text, text, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1, $2, false);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $4 ) || E'\n' || diag (
            '   Domain ' || quote_ident($1) || '.' || $2
            || ' does not exist'
        );
    END IF;

    RETURN isnt( actual_type, _quote_ident_like($3, actual_type), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._types_are(_name, text, _bpchar)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_types_are"(_name, text, _bpchar);
CREATE FUNCTION "public"."_types_are"(IN _name, IN text, IN _bpchar) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'types',
        ARRAY(
            SELECT t.typname
              FROM pg_catalog.pg_type t
              LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
             WHERE (
                     t.typrelid = 0
                 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)
             )
               AND NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_type_is_visible(t.oid)
               AND t.typtype = ANY( COALESCE($3, ARRAY['b', 'c', 'd', 'p', 'e']) )
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
               FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT t.typname
              FROM pg_catalog.pg_type t
              LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
             WHERE (
                     t.typrelid = 0
                 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)
             )
               AND NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_type_is_visible(t.oid)
               AND t.typtype = ANY( COALESCE($3, ARRAY['b', 'c', 'd', 'p', 'e']) )
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_types_are"(IN _name, IN text, IN _bpchar) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.types_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."types_are"(_name, text);
CREATE FUNCTION "public"."types_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."types_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.types_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."types_are"(_name);
CREATE FUNCTION "public"."types_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, 'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct types', NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."types_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domains_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domains_are"(name, _name, text);
CREATE FUNCTION "public"."domains_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, $3, ARRAY['d'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domains_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domains_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domains_are"(name, _name);
CREATE FUNCTION "public"."domains_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, 'Schema ' || quote_ident($1) || ' should have the correct domains', ARRAY['d'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domains_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domains_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domains_are"(_name, text);
CREATE FUNCTION "public"."domains_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, ARRAY['d'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domains_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domains_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domains_are"(_name);
CREATE FUNCTION "public"."domains_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, 'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct domains', ARRAY['d'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domains_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enums_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enums_are"(name, _name, text);
CREATE FUNCTION "public"."enums_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, $3, ARRAY['e'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enums_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enums_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enums_are"(name, _name);
CREATE FUNCTION "public"."enums_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, 'Schema ' || quote_ident($1) || ' should have the correct enums', ARRAY['e'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enums_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enums_are(_name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enums_are"(_name, text);
CREATE FUNCTION "public"."enums_are"(IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, $2, ARRAY['e'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enums_are"(IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.enums_are(_name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."enums_are"(_name);
CREATE FUNCTION "public"."enums_are"(IN _name) RETURNS "text" 
	AS $BODY$
    SELECT _types_are( $1, 'Search path ' || pg_catalog.current_setting('search_path') || ' should have the correct enums', ARRAY['e'] );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."enums_are"(IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._dexists(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_dexists"(name, name);
CREATE FUNCTION "public"."_dexists"(IN name, IN name) RETURNS "bool" 
	AS $BODY$
   SELECT EXISTS(
       SELECT true
         FROM pg_catalog.pg_namespace n
         JOIN pg_catalog.pg_type t on n.oid = t.typnamespace
        WHERE n.nspname = $1
          AND t.typname = $2
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_dexists"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._dexists(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_dexists"(name);
CREATE FUNCTION "public"."_dexists"(IN name) RETURNS "bool" 
	AS $BODY$
   SELECT EXISTS(
       SELECT true
         FROM pg_catalog.pg_type t
        WHERE t.typname = $1
          AND pg_catalog.pg_type_is_visible(t.oid)
   );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_dexists"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_dtype(name, text, bool)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_dtype"(name, text, bool);
CREATE FUNCTION "public"."_get_dtype"(IN name, IN text, IN bool) RETURNS "text" 
	AS $BODY$
    SELECT CASE WHEN $3 AND pg_catalog.pg_type_is_visible(t.oid)
                THEN quote_ident(tn.nspname) || '.'
                ELSE ''
            END || pg_catalog.format_type(t.oid, t.typtypmod)
      FROM pg_catalog.pg_type d
      JOIN pg_catalog.pg_namespace dn ON d.typnamespace = dn.oid
      JOIN pg_catalog.pg_type t       ON d.typbasetype  = t.oid
      JOIN pg_catalog.pg_namespace tn ON t.typnamespace = tn.oid
     WHERE d.typisdefined
       AND dn.nspname = $1
       AND d.typname  = LOWER($2)
       AND d.typtype  = 'd'
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_dtype"(IN name, IN text, IN bool) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(name, text, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(name, text, name, text);
CREATE FUNCTION "public"."domain_type_is"(IN name, IN text, IN name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_is(
        $1, $2, $3, $4,
        'Domain ' || quote_ident($1) || '.' || $2
        || ' should extend type ' || quote_ident($3) || '.' || $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN name, IN text, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(name, text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(name, text, text, text);
CREATE FUNCTION "public"."domain_type_is"(IN name, IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1, $2, false);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $4 ) || E'\n' || diag (
            '   Domain ' || quote_ident($1) || '.' || $2
            || ' does not exist'
        );
    END IF;

    RETURN is( actual_type, _quote_ident_like($3, actual_type), $4 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN name, IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(name, text, text);
CREATE FUNCTION "public"."domain_type_is"(IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_is(
        $1, $2, $3,
        'Domain ' || quote_ident($1) || '.' || $2
        || ' should extend type ' || $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(text, text, text);
CREATE FUNCTION "public"."domain_type_is"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $3 ) || E'\n' || diag (
            '   Domain ' ||  $1 || ' does not exist'
        );
    END IF;

    RETURN is( actual_type, _quote_ident_like($2, actual_type), $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_is(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_is"(text, text);
CREATE FUNCTION "public"."domain_type_is"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_is(
        $1, $2,
        'Domain ' || $1 || ' should extend type ' || $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_is"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(name, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(name, text, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_isnt(
        $1, $2, $3,
        'Domain ' || quote_ident($1) || '.' || $2
        || ' should not extend type ' || $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN name, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(text, text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(text, text, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN text, IN text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    actual_type TEXT := _get_dtype($1);
BEGIN
    IF actual_type IS NULL THEN
        RETURN fail( $3 ) || E'\n' || diag (
            '   Domain ' ||  $1 || ' does not exist'
        );
    END IF;

    RETURN isnt( actual_type, _quote_ident_like($2, actual_type), $3 );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN text, IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.domain_type_isnt(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."domain_type_isnt"(text, text);
CREATE FUNCTION "public"."domain_type_isnt"(IN text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT domain_type_isnt(
        $1, $2,
        'Domain ' || $1 || ' should not extend type ' || $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."domain_type_isnt"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.row_eq(text, anyelement, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."row_eq"(text, anyelement, text);
CREATE FUNCTION "public"."row_eq"(IN text, IN anyelement, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    rec    RECORD;
BEGIN
    EXECUTE _query($1) INTO rec;
    IF NOT rec IS DISTINCT FROM $2 THEN RETURN ok(true, $3); END IF;
    RETURN ok(false, $3 ) || E'\n' || diag(
           '        have: ' || CASE WHEN rec IS NULL THEN 'NULL' ELSE rec::text END ||
        E'\n        want: ' || CASE WHEN $2  IS NULL THEN 'NULL' ELSE $2::text  END
    );
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."row_eq"(IN text, IN anyelement, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.row_eq(text, anyelement)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."row_eq"(text, anyelement);
CREATE FUNCTION "public"."row_eq"(IN text, IN anyelement) RETURNS "text" 
	AS $BODY$
    SELECT row_eq($1, $2, NULL );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."row_eq"(IN text, IN anyelement) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.triggers_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."triggers_are"(name, name, _name, text);
CREATE FUNCTION "public"."triggers_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'triggers',
        ARRAY(
            SELECT t.tgname
              FROM pg_catalog.pg_trigger t
              JOIN pg_catalog.pg_class c     ON c.oid = t.tgrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
             WHERE n.nspname = $1
               AND c.relname = $2
               AND NOT t.tgisinternal
            EXCEPT
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
        ),
        ARRAY(
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
            EXCEPT
            SELECT t.tgname
              FROM pg_catalog.pg_trigger t
              JOIN pg_catalog.pg_class c     ON c.oid = t.tgrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
             WHERE n.nspname = $1
               AND c.relname = $2
               AND NOT t.tgisinternal
        ),
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."triggers_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.triggers_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."triggers_are"(name, name, _name);
CREATE FUNCTION "public"."triggers_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT triggers_are( $1, $2, $3, 'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should have the correct triggers' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."triggers_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.triggers_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."triggers_are"(name, _name, text);
CREATE FUNCTION "public"."triggers_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'triggers',
        ARRAY(
            SELECT t.tgname
              FROM pg_catalog.pg_trigger t
              JOIN pg_catalog.pg_class c ON c.oid = t.tgrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
             WHERE c.relname = $1
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND NOT t.tgisinternal
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT t.tgname
              FROM pg_catalog.pg_trigger t
              JOIN pg_catalog.pg_class c ON c.oid = t.tgrelid
              JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND NOT t.tgisinternal
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."triggers_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.triggers_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."triggers_are"(name, _name);
CREATE FUNCTION "public"."triggers_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT triggers_are( $1, $2, 'Table ' || quote_ident($1) || ' should have the correct triggers' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."triggers_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._areni(text, _text, _text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_areni"(text, _text, _text, text);
CREATE FUNCTION "public"."_areni"(IN text, IN _text, IN _text, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    what    ALIAS FOR $1;
    extras  ALIAS FOR $2;
    missing ALIAS FOR $3;
    descr   ALIAS FOR $4;
    msg     TEXT    := '';
    res     BOOLEAN := TRUE;
BEGIN
    IF extras[1] IS NOT NULL THEN
        res = FALSE;
        msg := E'\n' || diag(
            '    Extra ' || what || E':\n        '
            ||  array_to_string( extras, E'\n        ' )
        );
    END IF;
    IF missing[1] IS NOT NULL THEN
        res = FALSE;
        msg := msg || E'\n' || diag(
            '    Missing ' || what || E':\n        '
            ||  array_to_string( missing, E'\n        ' )
        );
    END IF;

    RETURN ok(res, descr) || msg;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_areni"(IN text, IN _text, IN _text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.casts_are(_text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."casts_are"(_text, text);
CREATE FUNCTION "public"."casts_are"(IN _text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _areni(
        'casts',
        ARRAY(
            SELECT pg_catalog.format_type(castsource, NULL)
                   || ' AS ' || pg_catalog.format_type(casttarget, NULL)
              FROM pg_catalog.pg_cast c
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT pg_catalog.format_type(castsource, NULL)
                   || ' AS ' || pg_catalog.format_type(casttarget, NULL)
              FROM pg_catalog.pg_cast c
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."casts_are"(IN _text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.casts_are(_text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."casts_are"(_text);
CREATE FUNCTION "public"."casts_are"(IN _text) RETURNS "text" 
	AS $BODY$
    SELECT casts_are( $1, 'There should be the correct casts');
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."casts_are"(IN _text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.display_oper(name, oid)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."display_oper"(name, oid);
CREATE FUNCTION "public"."display_oper"(IN name, IN oid) RETURNS "text" 
	AS $BODY$
    SELECT $1 || substring($2::regoperator::text, '[(][^)]+[)]$')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."display_oper"(IN name, IN oid) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.operators_are(name, _text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."operators_are"(name, _text, text);
CREATE FUNCTION "public"."operators_are"(IN name, IN _text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _areni(
        'operators',
        ARRAY(
            SELECT display_oper(o.oprname, o.oid) || ' RETURNS ' || o.oprresult::regtype
              FROM pg_catalog.pg_operator o
              JOIN pg_catalog.pg_namespace n ON o.oprnamespace = n.oid
             WHERE n.nspname = $1
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT display_oper(o.oprname, o.oid) || ' RETURNS ' || o.oprresult::regtype
              FROM pg_catalog.pg_operator o
              JOIN pg_catalog.pg_namespace n ON o.oprnamespace = n.oid
             WHERE n.nspname = $1
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."operators_are"(IN name, IN _text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.operators_are(_text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."operators_are"(_text, text);
CREATE FUNCTION "public"."operators_are"(IN _text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _areni(
        'operators',
        ARRAY(
            SELECT display_oper(o.oprname, o.oid) || ' RETURNS ' || o.oprresult::regtype
              FROM pg_catalog.pg_operator o
              JOIN pg_catalog.pg_namespace n ON o.oprnamespace = n.oid
             WHERE pg_catalog.pg_operator_is_visible(o.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
            EXCEPT
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
        ),
        ARRAY(
            SELECT $1[i]
              FROM generate_series(1, array_upper($1, 1)) s(i)
            EXCEPT
            SELECT display_oper(o.oprname, o.oid) || ' RETURNS ' || o.oprresult::regtype
              FROM pg_catalog.pg_operator o
              JOIN pg_catalog.pg_namespace n ON o.oprnamespace = n.oid
             WHERE pg_catalog.pg_operator_is_visible(o.oid)
               AND n.nspname NOT IN ('pg_catalog', 'information_schema')
        ),
        $2
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."operators_are"(IN _text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.operators_are(_text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."operators_are"(_text);
CREATE FUNCTION "public"."operators_are"(IN _text) RETURNS "text" 
	AS $BODY$
    SELECT operators_are($1, 'There should be the correct operators')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."operators_are"(IN _text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.columns_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."columns_are"(name, name, _name, text);
CREATE FUNCTION "public"."columns_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'columns',
        ARRAY(
            SELECT a.attname
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE n.nspname = $1
               AND c.relname = $2
               AND a.attnum > 0
               AND NOT a.attisdropped
            EXCEPT
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
        ),
        ARRAY(
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
            EXCEPT
            SELECT a.attname
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE n.nspname = $1
               AND c.relname = $2
               AND a.attnum > 0
               AND NOT a.attisdropped
        ),
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."columns_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.columns_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."columns_are"(name, name, _name);
CREATE FUNCTION "public"."columns_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT columns_are( $1, $2, $3, 'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should have the correct columns' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."columns_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.columns_are(name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."columns_are"(name, _name, text);
CREATE FUNCTION "public"."columns_are"(IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _are(
        'columns',
        ARRAY(
            SELECT a.attname
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_table_is_visible(c.oid)
               AND c.relname = $1
               AND a.attnum > 0
               AND NOT a.attisdropped
            EXCEPT
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
        ),
        ARRAY(
            SELECT $2[i]
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT a.attname
              FROM pg_catalog.pg_namespace n
              JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
              JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
             WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
               AND pg_catalog.pg_table_is_visible(c.oid)
               AND c.relname = $1
               AND a.attnum > 0
               AND NOT a.attisdropped
        ),
        $3
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."columns_are"(IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.columns_are(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."columns_are"(name, _name);
CREATE FUNCTION "public"."columns_are"(IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT columns_are( $1, $2, 'Table ' || quote_ident($1) || ' should have the correct columns' );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."columns_are"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_db_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_db_owner"(name);
CREATE FUNCTION "public"."_get_db_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(datdba)
      FROM pg_catalog.pg_database
     WHERE datname = $1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_db_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.db_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."db_owner_is"(name, name, text);
CREATE FUNCTION "public"."db_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    dbowner NAME := _get_db_owner($1);
BEGIN
    -- Make sure the database exists.
    IF dbowner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Database ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(dbowner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."db_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.db_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."db_owner_is"(name, name);
CREATE FUNCTION "public"."db_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT db_owner_is(
        $1, $2,
        'Database ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."db_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_schema_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_schema_owner"(name);
CREATE FUNCTION "public"."_get_schema_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(nspowner)
      FROM pg_catalog.pg_namespace
     WHERE nspname = $1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_schema_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schema_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schema_owner_is"(name, name, text);
CREATE FUNCTION "public"."schema_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_schema_owner($1);
BEGIN
    -- Make sure the schema exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Schema ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schema_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schema_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schema_owner_is"(name, name);
CREATE FUNCTION "public"."schema_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT schema_owner_is(
        $1, $2,
        'Schema ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schema_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_rel_owner(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_rel_owner"(name, name);
CREATE FUNCTION "public"."_get_rel_owner"(IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(c.relowner)
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE n.nspname = $1
       AND c.relname = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_rel_owner"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_rel_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_rel_owner"(name);
CREATE FUNCTION "public"."_get_rel_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(c.relowner)
      FROM pg_catalog.pg_class c
     WHERE c.relname = $1
       AND pg_catalog.pg_table_is_visible(c.oid)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_rel_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.relation_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."relation_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."relation_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner($1, $2);
BEGIN
    -- Make sure the relation exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Relation ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."relation_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.relation_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."relation_owner_is"(name, name, name);
CREATE FUNCTION "public"."relation_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT relation_owner_is(
        $1, $2, $3,
        'Relation ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."relation_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.relation_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."relation_owner_is"(name, name, text);
CREATE FUNCTION "public"."relation_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner($1);
BEGIN
    -- Make sure the relation exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Relation ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."relation_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.relation_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."relation_owner_is"(name, name);
CREATE FUNCTION "public"."relation_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT relation_owner_is(
        $1, $2,
        'Relation ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."relation_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_rel_owner(bpchar, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_rel_owner"(bpchar, name, name);
CREATE FUNCTION "public"."_get_rel_owner"(IN bpchar, IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(c.relowner)
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE c.relkind = $1
       AND n.nspname = $2
       AND c.relname = $3
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_rel_owner"(IN bpchar, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_rel_owner(bpchar, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_rel_owner"(bpchar, name);
CREATE FUNCTION "public"."_get_rel_owner"(IN bpchar, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(c.relowner)
      FROM pg_catalog.pg_class c
     WHERE c.relkind = $1
       AND c.relname = $2
       AND pg_catalog.pg_table_is_visible(c.oid)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_rel_owner"(IN bpchar, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."table_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('r'::char, $1, $2);
BEGIN
    -- Make sure the table exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_owner_is"(name, name, name);
CREATE FUNCTION "public"."table_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT table_owner_is(
        $1, $2, $3,
        'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_owner_is"(name, name, text);
CREATE FUNCTION "public"."table_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('r'::char, $1);
BEGIN
    -- Make sure the table exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Table ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_owner_is"(name, name);
CREATE FUNCTION "public"."table_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT table_owner_is(
        $1, $2,
        'Table ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.view_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."view_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."view_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('v'::char, $1, $2);
BEGIN
    -- Make sure the view exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    View ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."view_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.view_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."view_owner_is"(name, name, name);
CREATE FUNCTION "public"."view_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT view_owner_is(
        $1, $2, $3,
        'View ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."view_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.view_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."view_owner_is"(name, name, text);
CREATE FUNCTION "public"."view_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('v'::char, $1);
BEGIN
    -- Make sure the view exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    View ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."view_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.view_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."view_owner_is"(name, name);
CREATE FUNCTION "public"."view_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT view_owner_is(
        $1, $2,
        'View ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."view_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('S'::char, $1, $2);
BEGIN
    -- Make sure the sequence exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Sequence ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_owner_is"(name, name, name);
CREATE FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT sequence_owner_is(
        $1, $2, $3,
        'Sequence ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_owner_is"(name, name, text);
CREATE FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('S'::char, $1);
BEGIN
    -- Make sure the sequence exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Sequence ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_owner_is"(name, name);
CREATE FUNCTION "public"."sequence_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT sequence_owner_is(
        $1, $2,
        'Sequence ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.composite_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."composite_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."composite_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('c'::char, $1, $2);
BEGIN
    -- Make sure the composite exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Composite type ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."composite_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.composite_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."composite_owner_is"(name, name, name);
CREATE FUNCTION "public"."composite_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT composite_owner_is(
        $1, $2, $3,
        'Composite type ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."composite_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.composite_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."composite_owner_is"(name, name, text);
CREATE FUNCTION "public"."composite_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('c'::char, $1);
BEGIN
    -- Make sure the composite exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Composite type ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."composite_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.composite_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."composite_owner_is"(name, name);
CREATE FUNCTION "public"."composite_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT composite_owner_is(
        $1, $2,
        'Composite type ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."composite_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.foreign_table_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."foreign_table_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('f'::char, $1, $2);
BEGIN
    -- Make sure the table exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Foreign table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.foreign_table_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."foreign_table_owner_is"(name, name, name);
CREATE FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT foreign_table_owner_is(
        $1, $2, $3,
        'Foreign table ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.foreign_table_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."foreign_table_owner_is"(name, name, text);
CREATE FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_rel_owner('f'::char, $1);
BEGIN
    -- Make sure the table exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Foreign table ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."foreign_table_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.foreign_table_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."foreign_table_owner_is"(name, name);
CREATE FUNCTION "public"."foreign_table_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT foreign_table_owner_is(
        $1, $2,
        'Foreign table ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."foreign_table_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_func_owner(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_func_owner"(name, name, _name);
CREATE FUNCTION "public"."_get_func_owner"(IN name, IN name, IN _name) RETURNS "name" 
	AS $BODY$
    SELECT owner
      FROM tap_funky
     WHERE schema = $1
       AND name   = $2
       AND args   = array_to_string($3, ',')
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_func_owner"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_func_owner(name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_func_owner"(name, _name);
CREATE FUNCTION "public"."_get_func_owner"(IN name, IN _name) RETURNS "name" 
	AS $BODY$
    SELECT owner
      FROM tap_funky
     WHERE name = $1
       AND args = array_to_string($2, ',')
       AND is_visible
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_func_owner"(IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_owner_is(name, name, _name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_owner_is"(name, name, _name, name, text);
CREATE FUNCTION "public"."function_owner_is"(IN name, IN name, IN _name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_func_owner($1, $2, $3);
BEGIN
    -- Make sure the function exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            E'    Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
                    array_to_string($3, ', ') || ') does not exist'
        );
    END IF;

    RETURN is(owner, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_owner_is"(IN name, IN name, IN _name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_owner_is(name, name, _name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_owner_is"(name, name, _name, name);
CREATE FUNCTION "public"."function_owner_is"(IN name, IN name, IN _name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_owner_is(
        $1, $2, $3, $4,
        'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
        array_to_string($3, ', ') || ') should be owned by ' || quote_ident($4)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_owner_is"(IN name, IN name, IN _name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_owner_is(name, _name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_owner_is"(name, _name, name, text);
CREATE FUNCTION "public"."function_owner_is"(IN name, IN _name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_func_owner($1, $2);
BEGIN
    -- Make sure the function exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Function ' || quote_ident($1) || '(' ||
                    array_to_string($2, ', ') || ') does not exist'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_owner_is"(IN name, IN _name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_owner_is(name, _name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_owner_is"(name, _name, name);
CREATE FUNCTION "public"."function_owner_is"(IN name, IN _name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT function_owner_is(
        $1, $2, $3,
        'Function ' || quote_ident($1) || '(' ||
        array_to_string($2, ', ') || ') should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_owner_is"(IN name, IN _name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_tablespace_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_tablespace_owner"(name);
CREATE FUNCTION "public"."_get_tablespace_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(spcowner)
      FROM pg_catalog.pg_tablespace
     WHERE spcname = $1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_tablespace_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespace_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespace_owner_is"(name, name, text);
CREATE FUNCTION "public"."tablespace_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_tablespace_owner($1);
BEGIN
    -- Make sure the tablespace exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Tablespace ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespace_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespace_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespace_owner_is"(name, name);
CREATE FUNCTION "public"."tablespace_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT tablespace_owner_is(
        $1, $2,
        'Tablespace ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespace_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_index_owner(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_index_owner"(name, name, name);
CREATE FUNCTION "public"."_get_index_owner"(IN name, IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(ci.relowner)
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
      JOIN pg_catalog.pg_namespace n ON n.oid = ct.relnamespace
     WHERE n.nspname  = $1
       AND ct.relname = $2
       AND ci.relname = $3;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_index_owner"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_index_owner(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_index_owner"(name, name);
CREATE FUNCTION "public"."_get_index_owner"(IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(ci.relowner)
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct    ON ct.oid = x.indrelid
      JOIN pg_catalog.pg_class ci    ON ci.oid = x.indexrelid
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_index_owner"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_owner_is(name, name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_owner_is"(name, name, name, name, text);
CREATE FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_index_owner($1, $2, $3);
BEGIN
    -- Make sure the index exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            E'    Index ' || quote_ident($3) || ' ON '
            || quote_ident($1) || '.' || quote_ident($2) || ' not found'
        );
    END IF;

    RETURN is(owner, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_owner_is(name, name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_owner_is"(name, name, name, name);
CREATE FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT index_owner_is(
        $1, $2, $3, $4,
        'Index ' || quote_ident($3) || ' ON '
        || quote_ident($1) || '.' || quote_ident($2)
        || ' should be owned by ' || quote_ident($4)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_index_owner($1, $2);
BEGIN
    -- Make sure the index exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Index ' || quote_ident($2) || ' ON ' || quote_ident($1) || ' not found'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.index_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."index_owner_is"(name, name, name);
CREATE FUNCTION "public"."index_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT index_owner_is(
        $1, $2, $3,
        'Index ' || quote_ident($2) || ' ON '
        || quote_ident($1) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."index_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_language_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_language_owner"(name);
CREATE FUNCTION "public"."_get_language_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(lanowner)
      FROM pg_catalog.pg_language
     WHERE lanname = $1;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_language_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_owner_is"(name, name, text);
CREATE FUNCTION "public"."language_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_language_owner($1);
BEGIN
    -- Make sure the language exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Language ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_owner_is"(name, name);
CREATE FUNCTION "public"."language_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT language_owner_is(
        $1, $2,
        'Language ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_opclass_owner(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_opclass_owner"(name, name);
CREATE FUNCTION "public"."_get_opclass_owner"(IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(opcowner)
      FROM pg_catalog.pg_opclass oc
      JOIN pg_catalog.pg_namespace n ON oc.opcnamespace = n.oid
     WHERE n.nspname = $1
       AND opcname   = $2;
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_opclass_owner"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_opclass_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_opclass_owner"(name);
CREATE FUNCTION "public"."_get_opclass_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(opcowner)
      FROM pg_catalog.pg_opclass
     WHERE opcname = $1
       AND pg_catalog.pg_opclass_is_visible(oid);
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_opclass_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclass_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclass_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_opclass_owner($1, $2);
BEGIN
    -- Make sure the opclass exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Operator class ' || quote_ident($1) || '.' || quote_ident($2)
            || ' not found'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclass_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclass_owner_is"(name, name, name);
CREATE FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT opclass_owner_is(
        $1, $2, $3,
        'Operator class ' || quote_ident($1) || '.' || quote_ident($2) ||
        ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclass_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclass_owner_is"(name, name, text);
CREATE FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_opclass_owner($1);
BEGIN
    -- Make sure the opclass exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Operator class ' || quote_ident($1) || ' not found'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclass_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.opclass_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."opclass_owner_is"(name, name);
CREATE FUNCTION "public"."opclass_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT opclass_owner_is(
        $1, $2,
        'Operator class ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."opclass_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_type_owner(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_type_owner"(name, name);
CREATE FUNCTION "public"."_get_type_owner"(IN name, IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(t.typowner)
      FROM pg_catalog.pg_type t
      JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
     WHERE n.nspname = $1
       AND t.typname = $2
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_type_owner"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_type_owner(name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_type_owner"(name);
CREATE FUNCTION "public"."_get_type_owner"(IN name) RETURNS "name" 
	AS $BODY$
    SELECT pg_catalog.pg_get_userbyid(typowner)
      FROM pg_catalog.pg_type
     WHERE typname = $1
       AND pg_catalog.pg_type_is_visible(oid)
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_type_owner"(IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.type_owner_is(name, name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."type_owner_is"(name, name, name, text);
CREATE FUNCTION "public"."type_owner_is"(IN name, IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_type_owner($1, $2);
BEGIN
    -- Make sure the type exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            E'    Type ' || quote_ident($1) || '.' || quote_ident($2) || ' not found'
        );
    END IF;

    RETURN is(owner, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."type_owner_is"(IN name, IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.type_owner_is(name, name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."type_owner_is"(name, name, name);
CREATE FUNCTION "public"."type_owner_is"(IN name, IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT type_owner_is(
        $1, $2, $3,
        'Type ' || quote_ident($1) || '.' || quote_ident($2) || ' should be owned by ' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."type_owner_is"(IN name, IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.type_owner_is(name, name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."type_owner_is"(name, name, text);
CREATE FUNCTION "public"."type_owner_is"(IN name, IN name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    owner NAME := _get_type_owner($1);
BEGIN
    -- Make sure the type exists.
    IF owner IS NULL THEN
        RETURN ok(FALSE, $3) || E'\n' || diag(
            E'    Type ' || quote_ident($1) || ' not found'
        );
    END IF;

    RETURN is(owner, $2, $3);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."type_owner_is"(IN name, IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.type_owner_is(name, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."type_owner_is"(name, name);
CREATE FUNCTION "public"."type_owner_is"(IN name, IN name) RETURNS "text" 
	AS $BODY$
    SELECT type_owner_is(
        $1, $2,
        'Type ' || quote_ident($1) || ' should be owned by ' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."type_owner_is"(IN name, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._assets_are(text, _text, _text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_assets_are"(text, _text, _text, text);
CREATE FUNCTION "public"."_assets_are"(IN text, IN _text, IN _text, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _areni(
        $1,
        ARRAY(
            SELECT UPPER($2[i]) AS thing
              FROM generate_series(1, array_upper($2, 1)) s(i)
            EXCEPT
            SELECT $3[i]
              FROM generate_series(1, array_upper($3, 1)) s(i)
             ORDER BY thing
        ),
        ARRAY(
            SELECT $3[i] AS thing
              FROM generate_series(1, array_upper($3, 1)) s(i)
            EXCEPT
            SELECT UPPER($2[i])
              FROM generate_series(1, array_upper($2, 1)) s(i)
             ORDER BY thing
        ),
        $4
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_assets_are"(IN text, IN _text, IN _text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_table_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_table_privs"(name, text);
CREATE FUNCTION "public"."_get_table_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := _table_privs();
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        BEGIN
            IF pg_catalog.has_table_privilege($1, $2, privs[i]) THEN
                grants := grants || privs[i];
            END IF;
        EXCEPTION WHEN undefined_table THEN
            -- Not a valid table name.
            RETURN '{undefined_table}';
        WHEN undefined_object THEN
            -- Not a valid role.
            RETURN '{undefined_role}';
        WHEN invalid_parameter_value THEN
            -- Not a valid permission on this version of PostgreSQL; ignore;
        END;
    END LOOP;
    RETURN grants;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_table_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._table_privs()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_table_privs"();
CREATE FUNCTION "public"."_table_privs"() RETURNS "_name" 
	AS $BODY$
DECLARE
    pgversion INTEGER := pg_version_num();
BEGIN
    IF pgversion < 80200 THEN RETURN ARRAY[
        'DELETE', 'INSERT', 'REFERENCES', 'RULE', 'SELECT', 'TRIGGER', 'UPDATE'
    ];
    ELSIF pgversion < 80400 THEN RETURN ARRAY[
        'DELETE', 'INSERT', 'REFERENCES', 'SELECT', 'TRIGGER', 'UPDATE'
    ];
    ELSE RETURN ARRAY[
        'DELETE', 'INSERT', 'REFERENCES', 'SELECT', 'TRIGGER', 'TRUNCATE', 'UPDATE'
    ];
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_table_privs"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_privs_are(name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_privs_are"(name, name, name, _name, text);
CREATE FUNCTION "public"."table_privs_are"(IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_table_privs( $3, quote_ident($1) || '.' || quote_ident($2) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Role ' || quote_ident($3) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_privs_are"(IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_privs_are(name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_privs_are"(name, name, name, _name);
CREATE FUNCTION "public"."table_privs_are"(IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT table_privs_are(
        $1, $2, $3, $4,
        'Role ' || quote_ident($3) || ' should be granted '
            || CASE WHEN $4[1] IS NULL THEN 'no privileges' ELSE array_to_string($4, ', ') END
            || ' on table ' || quote_ident($1) || '.' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_privs_are"(IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."table_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_table_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.table_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."table_privs_are"(name, name, _name);
CREATE FUNCTION "public"."table_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT table_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on table ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."table_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._db_privs()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_db_privs"();
CREATE FUNCTION "public"."_db_privs"() RETURNS "_name" 
	AS $BODY$
DECLARE
    pgversion INTEGER := pg_version_num();
BEGIN
    IF pgversion < 80200 THEN
        RETURN ARRAY['CREATE', 'TEMPORARY'];
    ELSE
        RETURN ARRAY['CREATE', 'CONNECT', 'TEMPORARY'];
    END IF;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_db_privs"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_db_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_db_privs"(name, text);
CREATE FUNCTION "public"."_get_db_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := _db_privs();
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        BEGIN
            IF pg_catalog.has_database_privilege($1, $2, privs[i]) THEN
                grants := grants || privs[i];
            END IF;
        EXCEPTION WHEN invalid_catalog_name THEN
            -- Not a valid db name.
            RETURN '{invalid_catalog_name}';
        WHEN undefined_object THEN
            -- Not a valid role.
            RETURN '{undefined_role}';
        WHEN invalid_parameter_value THEN
            -- Not a valid permission on this version of PostgreSQL; ignore;
        END;
    END LOOP;
    RETURN grants;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_db_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.database_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."database_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."database_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_db_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'invalid_catalog_name' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Database ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."database_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.database_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."database_privs_are"(name, name, _name);
CREATE FUNCTION "public"."database_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT database_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on database ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."database_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_func_privs(text, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_func_privs"(text, text);
CREATE FUNCTION "public"."_get_func_privs"(IN text, IN text) RETURNS "_text" 
	AS $BODY$
BEGIN
    IF pg_catalog.has_function_privilege($1, $2, 'EXECUTE') THEN
        RETURN '{EXECUTE}';
    ELSE
        RETURN '{}';
    END IF;
EXCEPTION
    -- Not a valid func name.
    WHEN undefined_function THEN RETURN '{undefined_function}';
    -- Not a valid role.
    WHEN undefined_object   THEN RETURN '{undefined_role}';
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_func_privs"(IN text, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._fprivs_are(text, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_fprivs_are"(text, name, _name, text);
CREATE FUNCTION "public"."_fprivs_are"(IN text, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_func_privs($2, $1);
BEGIN
    IF grants[1] = 'undefined_function' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Function ' || $1 || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_fprivs_are"(IN text, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_privs_are(name, name, _name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_privs_are"(name, name, _name, name, _name, text);
CREATE FUNCTION "public"."function_privs_are"(IN name, IN name, IN _name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _fprivs_are(
        quote_ident($1) || '.' || quote_ident($2) || '(' || array_to_string($3, ', ') || ')',
        $4, $5, $6
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_privs_are"(IN name, IN name, IN _name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_privs_are(name, name, _name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_privs_are"(name, name, _name, name, _name);
CREATE FUNCTION "public"."function_privs_are"(IN name, IN name, IN _name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT function_privs_are(
        $1, $2, $3, $4, $5,
        'Role ' || quote_ident($4) || ' should be granted '
            || CASE WHEN $5[1] IS NULL THEN 'no privileges' ELSE array_to_string($5, ', ') END
            || ' on function ' || quote_ident($1) || '.' || quote_ident($2)
            || '(' || array_to_string($3, ', ') || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_privs_are"(IN name, IN name, IN _name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_privs_are(name, _name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_privs_are"(name, _name, name, _name, text);
CREATE FUNCTION "public"."function_privs_are"(IN name, IN _name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
    SELECT _fprivs_are(
        quote_ident($1) || '(' || array_to_string($2, ', ') || ')',
        $3, $4, $5
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_privs_are"(IN name, IN _name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.function_privs_are(name, _name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."function_privs_are"(name, _name, name, _name);
CREATE FUNCTION "public"."function_privs_are"(IN name, IN _name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT function_privs_are(
        $1, $2, $3, $4,
        'Role ' || quote_ident($3) || ' should be granted '
            || CASE WHEN $4[1] IS NULL THEN 'no privileges' ELSE array_to_string($4, ', ') END
            || ' on function ' || quote_ident($1) || '(' || array_to_string($2, ', ') || ')'
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."function_privs_are"(IN name, IN _name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_lang_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_lang_privs"(name, text);
CREATE FUNCTION "public"."_get_lang_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
BEGIN
    IF pg_catalog.has_language_privilege($1, $2, 'USAGE') THEN
        RETURN '{USAGE}';
    ELSE
        RETURN '{}';
    END IF;
EXCEPTION WHEN undefined_object THEN
    -- Same error code for unknown user or language. So figure out which.
    RETURN CASE WHEN SQLERRM LIKE '%' || $1 || '%' THEN
        '{undefined_role}'
    ELSE
        '{undefined_language}'
    END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_lang_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."language_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_lang_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_language' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Language ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.language_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."language_privs_are"(name, name, _name);
CREATE FUNCTION "public"."language_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT language_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on language ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."language_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schema_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schema_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."schema_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_schema_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'invalid_schema_name' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Schema ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schema_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.schema_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."schema_privs_are"(name, name, _name);
CREATE FUNCTION "public"."schema_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT schema_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on schema ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."schema_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_tablespaceprivs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_tablespaceprivs"(name, text);
CREATE FUNCTION "public"."_get_tablespaceprivs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
BEGIN
    IF pg_catalog.has_tablespace_privilege($1, $2, 'CREATE') THEN
        RETURN '{CREATE}';
    ELSE
        RETURN '{}';
    END IF;
EXCEPTION WHEN undefined_object THEN
    -- Same error code for unknown user or tablespace. So figure out which.
    RETURN CASE WHEN SQLERRM LIKE '%' || $1 || '%' THEN
        '{undefined_role}'
    ELSE
        '{undefined_tablespace}'
    END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_tablespaceprivs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespace_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespace_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."tablespace_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_tablespaceprivs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_tablespace' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Tablespace ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespace_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.tablespace_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."tablespace_privs_are"(name, name, _name);
CREATE FUNCTION "public"."tablespace_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT tablespace_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on tablespace ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."tablespace_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_sequence_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_sequence_privs"(name, text);
CREATE FUNCTION "public"."_get_sequence_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := ARRAY['SELECT', 'UPDATE', 'USAGE'];
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        BEGIN
            IF pg_catalog.has_sequence_privilege($1, $2, privs[i]) THEN
                grants := grants || privs[i];
            END IF;
        EXCEPTION WHEN undefined_table THEN
            -- Not a valid sequence name.
            RETURN '{undefined_table}';
        WHEN undefined_object THEN
            -- Not a valid role.
            RETURN '{undefined_role}';
        WHEN invalid_parameter_value THEN
            -- Not a valid permission on this version of PostgreSQL; ignore;
        END;
    END LOOP;
    RETURN grants;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_sequence_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_privs_are(name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_privs_are"(name, name, name, _name, text);
CREATE FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_sequence_privs( $3, quote_ident($1) || '.' || quote_ident($2) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Sequence ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Role ' || quote_ident($3) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_privs_are(name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_privs_are"(name, name, name, _name);
CREATE FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT sequence_privs_are(
        $1, $2, $3, $4,
        'Role ' || quote_ident($3) || ' should be granted '
            || CASE WHEN $4[1] IS NULL THEN 'no privileges' ELSE array_to_string($4, ', ') END
            || ' on sequence '|| quote_ident($1) || '.' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_sequence_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Sequence ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.sequence_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."sequence_privs_are"(name, name, _name);
CREATE FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT sequence_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on sequence ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."sequence_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_ac_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_ac_privs"(name, text);
CREATE FUNCTION "public"."_get_ac_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := ARRAY['INSERT', 'REFERENCES', 'SELECT', 'UPDATE'];
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        BEGIN
            IF pg_catalog.has_any_column_privilege($1, $2, privs[i]) THEN
                grants := grants || privs[i];
            END IF;
        EXCEPTION WHEN undefined_table THEN
            -- Not a valid table name.
            RETURN '{undefined_table}';
        WHEN undefined_object THEN
            -- Not a valid role.
            RETURN '{undefined_role}';
        WHEN invalid_parameter_value THEN
            -- Not a valid permission on this version of PostgreSQL; ignore;
        END;
    END LOOP;
    RETURN grants;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_ac_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.any_column_privs_are(name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."any_column_privs_are"(name, name, name, _name, text);
CREATE FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_ac_privs( $3, quote_ident($1) || '.' || quote_ident($2) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Role ' || quote_ident($3) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.any_column_privs_are(name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."any_column_privs_are"(name, name, name, _name);
CREATE FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT any_column_privs_are(
        $1, $2, $3, $4,
        'Role ' || quote_ident($3) || ' should be granted '
            || CASE WHEN $4[1] IS NULL THEN 'no privileges' ELSE array_to_string($4, ', ') END
            || ' on any column in '|| quote_ident($1) || '.' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.any_column_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."any_column_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_ac_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.any_column_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."any_column_privs_are"(name, name, _name);
CREATE FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT any_column_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on any column in ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."any_column_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_col_privs(name, text, name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_col_privs"(name, text, name);
CREATE FUNCTION "public"."_get_col_privs"(IN name, IN text, IN name) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := ARRAY['INSERT', 'REFERENCES', 'SELECT', 'UPDATE'];
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        IF pg_catalog.has_column_privilege($1, $2, $3, privs[i]) THEN
            grants := grants || privs[i];
        END IF;
    END LOOP;
    RETURN grants;
EXCEPTION
    -- Not a valid column name.
    WHEN undefined_column THEN RETURN '{undefined_column}';
    -- Not a valid table name.
    WHEN undefined_table THEN RETURN '{undefined_table}';
    -- Not a valid role.
    WHEN undefined_object THEN RETURN '{undefined_role}';
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_col_privs"(IN name, IN text, IN name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.column_privs_are(name, name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."column_privs_are"(name, name, name, name, _name, text);
CREATE FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_col_privs( $4, quote_ident($1) || '.' || quote_ident($2), $3 );
BEGIN
    IF grants[1] = 'undefined_column' THEN
        RETURN ok(FALSE, $6) || E'\n' || diag(
            '    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3)
            || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $6) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $6) || E'\n' || diag(
            '    Role ' || quote_ident($4) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $5, $6);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.column_privs_are(name, name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."column_privs_are"(name, name, name, name, _name);
CREATE FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT column_privs_are(
        $1, $2, $3, $4, $5,
        'Role ' || quote_ident($4) || ' should be granted '
            || CASE WHEN $5[1] IS NULL THEN 'no privileges' ELSE array_to_string($5, ', ') END
            || ' on column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.column_privs_are(name, name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."column_privs_are"(name, name, name, _name, text);
CREATE FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_col_privs( $3, quote_ident($1), $2 );
BEGIN
    IF grants[1] = 'undefined_column' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_table' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Table ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $5) || E'\n' || diag(
            '    Role ' || quote_ident($3) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $4, $5);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.column_privs_are(name, name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."column_privs_are"(name, name, name, _name);
CREATE FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT column_privs_are(
        $1, $2, $3, $4,
        'Role ' || quote_ident($3) || ' should be granted '
            || CASE WHEN $4[1] IS NULL THEN 'no privileges' ELSE array_to_string($4, ', ') END
            || ' on column ' || quote_ident($1) || '.' || quote_ident($2)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."column_privs_are"(IN name, IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_fdw_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_fdw_privs"(name, text);
CREATE FUNCTION "public"."_get_fdw_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
BEGIN
    IF pg_catalog.has_foreign_data_wrapper_privilege($1, $2, 'USAGE') THEN
        RETURN '{USAGE}';
    ELSE
        RETURN '{}';
    END IF;
EXCEPTION WHEN undefined_object THEN
    -- Same error code for unknown user or fdw. So figure out which.
    RETURN CASE WHEN SQLERRM LIKE '%' || $1 || '%' THEN
        '{undefined_role}'
    ELSE
        '{undefined_fdw}'
    END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_fdw_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fdw_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fdw_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."fdw_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_fdw_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_fdw' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    FDW ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fdw_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.fdw_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."fdw_privs_are"(name, name, _name);
CREATE FUNCTION "public"."fdw_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT fdw_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on FDW ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."fdw_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_schema_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_schema_privs"(name, text);
CREATE FUNCTION "public"."_get_schema_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
DECLARE
    privs  TEXT[] := ARRAY['CREATE', 'USAGE'];
    grants TEXT[] := '{}';
BEGIN
    FOR i IN 1..array_upper(privs, 1) LOOP
        IF pg_catalog.has_schema_privilege($1, $2, privs[i]) THEN
            grants := grants || privs[i];
        END IF;
    END LOOP;
    RETURN grants;
EXCEPTION
    -- Not a valid schema name.
    WHEN invalid_schema_name THEN RETURN '{invalid_schema_name}';
    -- Not a valid role.
    WHEN undefined_object   THEN RETURN '{undefined_role}';
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_schema_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public._get_server_privs(name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."_get_server_privs"(name, text);
CREATE FUNCTION "public"."_get_server_privs"(IN name, IN text) RETURNS "_text" 
	AS $BODY$
BEGIN
    IF pg_catalog.has_server_privilege($1, $2, 'USAGE') THEN
        RETURN '{USAGE}';
    ELSE
        RETURN '{}';
    END IF;
EXCEPTION WHEN undefined_object THEN
    -- Same error code for unknown user or server. So figure out which.
    RETURN CASE WHEN SQLERRM LIKE '%' || $1 || '%' THEN
        '{undefined_role}'
    ELSE
        '{undefined_server}'
    END;
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."_get_server_privs"(IN name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.server_privs_are(name, name, _name, text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."server_privs_are"(name, name, _name, text);
CREATE FUNCTION "public"."server_privs_are"(IN name, IN name, IN _name, IN text) RETURNS "text" 
	AS $BODY$
DECLARE
    grants TEXT[] := _get_server_privs( $2, quote_ident($1) );
BEGIN
    IF grants[1] = 'undefined_server' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Server ' || quote_ident($1) || ' does not exist'
        );
    ELSIF grants[1] = 'undefined_role' THEN
        RETURN ok(FALSE, $4) || E'\n' || diag(
            '    Role ' || quote_ident($2) || ' does not exist'
        );
    END IF;
    RETURN _assets_are('privileges', grants, $3, $4);
END;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."server_privs_are"(IN name, IN name, IN _name, IN text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.server_privs_are(name, name, _name)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."server_privs_are"(name, name, _name);
CREATE FUNCTION "public"."server_privs_are"(IN name, IN name, IN _name) RETURNS "text" 
	AS $BODY$
    SELECT server_privs_are(
        $1, $2, $3,
        'Role ' || quote_ident($2) || ' should be granted '
            || CASE WHEN $3[1] IS NULL THEN 'no privileges' ELSE array_to_string($3, ', ') END
            || ' on server ' || quote_ident($1)
    );
$BODY$
	LANGUAGE sql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."server_privs_are"(IN name, IN name, IN _name) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.setup_10_web()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."setup_10_web"();
CREATE FUNCTION "public"."setup_10_web"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		perform web.clear_sessions();
	exception
		when invalid_schema_name then
			return;
		when undefined_function then 
			return;
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."setup_10_web"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.new_session_id()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."new_session_id"();
CREATE FUNCTION "public"."new_session_id"() RETURNS "text" 
	AS $BODY$
	declare
		sessionid		text;
		holder			text;
	begin
		loop
			select md5(random()::text) into sessionid;
			select sess_id into holder from web.session
				where sess_id = sessionid;
			if found then
				continue;
			else
				return sessionid;
			end if;
		end loop;
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."new_session_id"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_setsessiondata_update_data()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_setsessiondata_update_data"();
CREATE FUNCTION "public"."test_web_function_setsessiondata_update_data"() RETURNS SETOF "text" 
	AS $BODY$
	declare
		sessionid			text;
	begin
		select create_test_session into sessionid from create_test_session();
		perform web.set_session_data(sessionid, 'new-data', now() + interval '1 day');
		return next results_eq(
			$$select web.get_session_data('$$ || sessionid || $$')$$,
			$$values ('new-data')$$,
			'The set_session_data should update a session.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_setsessiondata_update_data"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_countsessions_ignores_expired()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_countsessions_ignores_expired"();
CREATE FUNCTION "public"."test_web_function_countsessions_ignores_expired"() RETURNS SETOF "text" 
	AS $BODY$
	declare 
		sessionid			text;
		sessiondata			text:=md5(random()::text);
	begin
		select into sessionid create_test_session
			from create_test_session();
		perform web.set_session_data(sessionid, sessiondata, now() - interval '1 day');
		perform create_test_session();
		perform create_test_session();
		perform create_test_session();
		return next results_eq(
			'select web.count_sessions()',
			'values (3)',
			'Count should ignore expired sessions.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_countsessions_ignores_expired"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.test_web_function_allids_is_removed()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."test_web_function_allids_is_removed"();
CREATE FUNCTION "public"."test_web_function_allids_is_removed"() RETURNS SETOF "text" 
	AS $BODY$
	begin
		return next hasnt_function('web', 'all_session_ids', 'All ids is removed for security reasons.');
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."test_web_function_allids_is_removed"() OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.failed_test(text)
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."failed_test"(text);
CREATE FUNCTION "public"."failed_test"(IN thetest text) RETURNS "bool" 
	AS $BODY$
	declare 
		error_holder		text;
	begin
		select 
			runtests into error_holder
		from
			runtests(thetest)
		where
			runtests ~* '^not ok';
		return found;
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."failed_test"(IN thetest text) OWNER TO "postgres";

-- ----------------------------
--  Function structure for public.correct_web()
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."correct_web"();
CREATE FUNCTION "public"."correct_web"() RETURNS SETOF "text" 
	AS $BODY$
	declare
		error_holder		text;
	begin
		if failed_test('test_web_schema') then
			create schema web;
			return next 'Created a schema';
		end if;
		if failed_test('test_web_session_table') then
			create table web.session();
			return next 'Created the session table.';
		end if;
		if failed_test('test_web_session_id_exists') then
			alter table web.session 
				add column sess_id text;
			return next 'Added sess_id column.';
		end if;
		if failed_test('test_web_session_id_type') then 
			alter table web.session
				alter column sess_id type text;
			return next 'Changed sess_id to type text.';
		end if;
		if failed_test('test_web_session_id_is_pk') then 
			alter table web.session
				add primary key (sess_id);
			return next 'Made sess_id the primary key.';
		end if;
		if failed_test('test_web_session_data_exists') then
			alter table web.session 
				add column sess_data text;
			return next 'Added sess_data column.';
		end if;
		if failed_test('test_web_session_data_type') then 
			alter table web.session
				alter column sess_data type text;
			return next 'Changed sess_data to type text.';
		end if;
		if failed_test('test_web_session_expiration_exists') then
			alter table web.session 
				add column expiration timestamp with time zone;
			return next 'Added expiration column.';
		end if;
		if failed_test('test_web_session_data_type') then 
			alter table web.session
				alter column expiration type timestamp with time zone;
			return next 'Changed expiration to type timestamp.';
		end if;
		if failed_test('test_web_session_expiration_default') then
			alter table web.session
				alter column expiration set default now() + interval '1 day';
			return next 'Added expiration default.';
		end if;
		if failed_test('test_web_session_expiration_has_index') then
			create index expire_idx on web.session (expiration);
			return next 'Created expiration index.';
		end if;
		
		if failed_test('test_web_function_allids_is_removed') then
			drop function web.all_session_ids();
			return next 'Removed all ids for security reasons.';
		end if;
		
		create or replace function web.valid_sessions()
		returns setof web.session as $$
			begin
				return query select * from web.session
					where expiration > now() 
						or expiration is null;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		
		create or replace function web.set_session_data(
			sessid text, 
			sessdata text, 
			expire timestamp with time zone) 
		returns void as $$
			begin
				loop
					update web.session 
						set sess_data = sessdata, 
							expiration = expire 
						where sess_id = sessid;
					if found then
						return;
					end if;
					begin
						insert into web.session (sess_id, sess_data, expiration) 
							values (sessid, sessdata, expire);
						return;
					exception
						when unique_violation then
							-- do nothing.
					end;
				end loop;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		return next 'Created function web.set_session_data';
		
		create or replace function web.destroy_session(sessid text)
		returns void as $$
			begin
				delete from web.session where sess_id = sessid;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		return next 'Created function web.destroy_session.';
		
		create or replace function web.get_session_data(sessid text)
		returns setof text as $$
			begin
				return query select sess_data 
					from web.valid_sessions()
					where sess_id = sessid;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		return next 'Created function web.get_session.';
		
		create or replace function web.clear_sessions()
		returns void as $$
			begin 
				delete from web.session;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;		
		return next 'Created function web.clear_sessions.';

		create or replace function web.count_sessions()
		returns int as $$
			declare
				thecount int := 0;
			begin
				select count(*) into thecount
					from web.valid_sessions();
				return thecount;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		return next 'Created function web.count_sessions.';

		drop trigger if exists delete_expired_trig on web.session;

		create or replace function web.remove_expired()
		returns trigger as $$
			begin
				delete from web.session where expiration < now();
				return null;
			end;
		$$ language plpgsql security definer
		set search_path = web, pg_temp;
		return next 'Created trigger function web.delete_expired.';
		
		create trigger delete_expired_trig
			after insert or update
			on web.session
			execute procedure web.remove_expired();
		return next 'Created trigger delete_expired on web.session.';
		
		if failed_test('test_web_user_exists') then 
			create user nodepg with password 'password';
			return next 'Created user nodepg';
		end if;
		
		revoke all on function 
			web.valid_sessions(),
			web.set_session_data(
				sessid text, 
				sessdata text, 
				expire timestamp with time zone),
			web.destroy_session(sessid text),
			web.get_session_data(sessid text),
			web.clear_sessions(),
			web.count_sessions(),
			web.remove_expired()
		from public;
		
		grant execute on function 
			web.set_session_data(
				sessid text, 
				sessdata text, 
				expire timestamp with time zone),
			web.destroy_session(sessid text),
			web.get_session_data(sessid text),
			web.clear_sessions(),
			web.count_sessions()
		to nodepg;
		
		grant usage on schema web to nodepg;
		
		return next 'Permissions set.';
	end;
$BODY$
	LANGUAGE plpgsql
	COST 100
	ROWS 1000
	CALLED ON NULL INPUT
	SECURITY INVOKER
	VOLATILE;
ALTER FUNCTION "public"."correct_web"() OWNER TO "postgres";

-- ----------------------------
--  Primary key structure for table episodes
-- ----------------------------
ALTER TABLE "public"."episodes" ADD CONSTRAINT "episodes_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("username") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table subpopulations
-- ----------------------------
ALTER TABLE "public"."subpopulations" ADD CONSTRAINT "patients_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table sites
-- ----------------------------
ALTER TABLE "public"."sites" ADD CONSTRAINT "sites_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table measures
-- ----------------------------
ALTER TABLE "public"."measures" ADD CONSTRAINT "measures_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table domains
-- ----------------------------
ALTER TABLE "public"."domains" ADD CONSTRAINT "domains_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table departments
-- ----------------------------
ALTER TABLE "public"."departments" ADD CONSTRAINT "departments_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table drg_statistics
-- ----------------------------
ALTER TABLE "public"."drg_statistics" ADD CONSTRAINT "drg_statistics_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table drgs
-- ----------------------------
ALTER TABLE "public"."drgs" ADD CONSTRAINT "drgs_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table quick_statistics
-- ----------------------------
ALTER TABLE "public"."quick_statistics" ADD CONSTRAINT "quick_statistics_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table data
-- ----------------------------
ALTER TABLE "public"."data" ADD CONSTRAINT "data_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table summaries
-- ----------------------------
ALTER TABLE "public"."summaries" ADD CONSTRAINT "summaries_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

