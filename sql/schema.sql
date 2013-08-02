/*
 Navicat Premium Data Transfer

 Source Server         : Postgres 9.2 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 90001
 Source Host           : localhost
 Source Database       : scrc
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90001
 File Encoding         : utf-8

 Date: 08/01/2013 14:18:48 PM
*/

-- ----------------------------
--  Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" (
	"username" varchar NOT NULL,
	"password" varchar NOT NULL,
	"site_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "users" OWNER TO "postgres";

-- ----------------------------
--  Table structure for ownerships
-- ----------------------------
DROP TABLE IF EXISTS "ownerships";
CREATE TABLE "ownerships" (
	"id" int8 NOT NULL,
	"type" varchar NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "ownerships" OWNER TO "postgres";

-- ----------------------------
--  Table structure for sites
-- ----------------------------
DROP TABLE IF EXISTS "sites";
CREATE TABLE "sites" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL,
	"latitude" float4 NOT NULL,
	"longitude" float4 NOT NULL,
	"ownership_id" int4 NOT NULL,
	"image" varchar,
	"website" varchar,
	"address" varchar,
	"state" varchar
)
WITH (OIDS=FALSE);
ALTER TABLE "sites" OWNER TO "postgres";

-- ----------------------------
--  Table structure for domains
-- ----------------------------
DROP TABLE IF EXISTS "domains";
CREATE TABLE "domains" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL,
	"is_text_only" bool NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "domains" OWNER TO "postgres";

-- ----------------------------
--  Table structure for measures
-- ----------------------------
DROP TABLE IF EXISTS "measures";
CREATE TABLE "measures" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL,
	"domain_id" int4 NOT NULL,
	"units" varchar
)
WITH (OIDS=FALSE);
ALTER TABLE "measures" OWNER TO "postgres";

-- ----------------------------
--  Table structure for departments
-- ----------------------------
DROP TABLE IF EXISTS "departments";
CREATE TABLE "departments" (
	"id" int4 NOT NULL,
	"name" varchar NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "departments" OWNER TO "postgres";

-- ----------------------------
--  Table structure for drg_statistics
-- ----------------------------
DROP TABLE IF EXISTS "drg_statistics";
CREATE TABLE "drg_statistics" (
	"id" int4 NOT NULL,
	"measure_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "drg_statistics" OWNER TO "postgres";

-- ----------------------------
--  Table structure for patients
-- ----------------------------
DROP TABLE IF EXISTS "patients";
CREATE TABLE "patients" (
	"id" int4 NOT NULL,
	"name" varchar
)
WITH (OIDS=FALSE);
ALTER TABLE "patients" OWNER TO "postgres";

-- ----------------------------
--  Table structure for quick_statistics
-- ----------------------------
DROP TABLE IF EXISTS "quick_statistics";
CREATE TABLE "quick_statistics" (
	"id" int4 NOT NULL,
	"measure_id" int4 NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "quick_statistics" OWNER TO "postgres";

-- ----------------------------
--  Table structure for drgs
-- ----------------------------
DROP TABLE IF EXISTS "drgs";
CREATE TABLE "drgs" (
	"id" int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	"service" varchar(255) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "drgs" OWNER TO "postgres";

-- ----------------------------
--  Table structure for data
-- ----------------------------
DROP TABLE IF EXISTS "data";
CREATE TABLE "data" (
	"id" int8 NOT NULL,
	"site_id" int4 NOT NULL,
	"drg_id" int4 NOT NULL,
	"patient_id" int4 NOT NULL,
	"measure_id" int4 NOT NULL,
	"year" int4 NOT NULL DEFAULT 2013,
	"quarter" int4 NOT NULL DEFAULT 1,
	"value" float4 NOT NULL,
	"upper_bound" float4,
	"lower_bound" float4
)
WITH (OIDS=FALSE);
ALTER TABLE "data" OWNER TO "postgres";

COMMENT ON COLUMN "data"."year" IS 'Year Number';
COMMENT ON COLUMN "data"."quarter" IS 'Quarter number: 1,2,3,4';

-- ----------------------------
--  Primary key structure for table users
-- ----------------------------
ALTER TABLE "users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("username") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table ownerships
-- ----------------------------
ALTER TABLE "ownerships" ADD CONSTRAINT "ownerships_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table sites
-- ----------------------------
ALTER TABLE "sites" ADD CONSTRAINT "sites_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table domains
-- ----------------------------
ALTER TABLE "domains" ADD CONSTRAINT "domains_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table measures
-- ----------------------------
ALTER TABLE "measures" ADD CONSTRAINT "measures_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table departments
-- ----------------------------
ALTER TABLE "departments" ADD CONSTRAINT "departments_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table drg_statistics
-- ----------------------------
ALTER TABLE "drg_statistics" ADD CONSTRAINT "drg_statistics_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table patients
-- ----------------------------
ALTER TABLE "patients" ADD CONSTRAINT "patients_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table quick_statistics
-- ----------------------------
ALTER TABLE "quick_statistics" ADD CONSTRAINT "quick_statistics_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table drgs
-- ----------------------------
ALTER TABLE "drgs" ADD CONSTRAINT "drgs_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Primary key structure for table data
-- ----------------------------
ALTER TABLE "data" ADD CONSTRAINT "data_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

