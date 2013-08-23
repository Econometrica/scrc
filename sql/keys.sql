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

 Date: 08/23/2013 08:06:53 AM
*/

-- ----------------------------
--  Table structure for keys
-- ----------------------------
DROP TABLE IF EXISTS "public"."keys";
CREATE TABLE "public"."keys" (
	"id" int4 NOT NULL,
	"key" varchar NOT NULL COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."keys" OWNER TO "postgres";

-- ----------------------------
--  Records of keys
-- ----------------------------
BEGIN;
INSERT INTO "public"."keys" VALUES ('10', '508_10');
INSERT INTO "public"."keys" VALUES ('0', '508_0');
COMMIT;

-- ----------------------------
--  Primary key structure for table keys
-- ----------------------------
ALTER TABLE "public"."keys" ADD CONSTRAINT "keys_pkey" PRIMARY KEY ("key") NOT DEFERRABLE INITIALLY IMMEDIATE;

