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

 Date: 08/23/2013 14:49:38 PM
*/

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
--  Records of departments
-- ----------------------------
BEGIN;
INSERT INTO "public"."departments" VALUES ('0', 'ALL');
INSERT INTO "public"."departments" VALUES ('18', 'Other');
INSERT INTO "public"."departments" VALUES ('17', 'Against medical Advice');
INSERT INTO "public"."departments" VALUES ('16', 'Other Facility Discharge');
INSERT INTO "public"."departments" VALUES ('15', 'Home With Home Health Agency');
INSERT INTO "public"."departments" VALUES ('14', 'Inpatient Rehab Facility');
INSERT INTO "public"."departments" VALUES ('13', 'Long-term Care Hospital');
INSERT INTO "public"."departments" VALUES ('12', 'Hospice');
INSERT INTO "public"."departments" VALUES ('11', 'Skill Nursing Agency');
INSERT INTO "public"."departments" VALUES ('10', 'No Additional Care Post-Episode');
INSERT INTO "public"."departments" VALUES ('9', 'Outpatient Care');
INSERT INTO "public"."departments" VALUES ('8', 'Other Inpatient');
INSERT INTO "public"."departments" VALUES ('7', 'Intermediate Care Unit');
INSERT INTO "public"."departments" VALUES ('6', 'Critical Care Unit');
INSERT INTO "public"."departments" VALUES ('5', 'Intensive Care Unit');
INSERT INTO "public"."departments" VALUES ('4', 'No Additional Care Pre-Episode');
INSERT INTO "public"."departments" VALUES ('3', 'Outpatient Care Pre-Episode');
INSERT INTO "public"."departments" VALUES ('2', 'Hospital  Emergency Department');
INSERT INTO "public"."departments" VALUES ('1', 'Physician Office Visit');
COMMIT;

-- ----------------------------
--  Primary key structure for table departments
-- ----------------------------
ALTER TABLE "public"."departments" ADD CONSTRAINT "departments_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

