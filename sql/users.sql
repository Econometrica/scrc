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

 Date: 08/23/2013 16:46:33 PM
*/

-- ----------------------------
--  Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
	"id" int4 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
	"username" varchar NOT NULL COLLATE "default",
	"site_id" int4 NOT NULL,
	"email" varchar NOT NULL COLLATE "default",
	"md5" varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."users" OWNER TO "postgres";

-- ----------------------------
--  Records of users
-- ----------------------------
BEGIN;
INSERT INTO "public"."users" VALUES ('1', 'cms', '0', 'pat@cappelaere.com', 'adfd30c303816f8a403b53c405b9a4f5');
INSERT INTO "public"."users" VALUES ('0', 'admin', '0', 'pat@me.com', '69d53e07abdece8b72e07f1f77ae961c');
INSERT INTO "public"."users" VALUES ('2', 'site10', '10', 'patrice@vightel.com', '99ab116a9acd7b1f57fc913839aec664');
INSERT INTO "public"."users" VALUES ('3', 'site12', '12', 'pat@geobliki.com', 'a7df3b9cecd11b0fd48f99ab23c50278');
INSERT INTO "public"."users" VALUES ('4', 'site13', '13', 'cappelaere@gmail.com', '3cd06afc777b93a65d1326a08c5e7bfc');
COMMIT;

-- ----------------------------
--  Primary key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Uniques structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "email" UNIQUE ("username","id","email") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- ----------------------------
--  Indexes structure for table users
-- ----------------------------
CREATE UNIQUE INDEX  "email" ON "public"."users" USING btree(username COLLATE "default" ASC NULLS LAST, "id" ASC NULLS LAST, email COLLATE "default" ASC NULLS LAST);

