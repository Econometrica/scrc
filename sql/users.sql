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

 Date: 08/18/2013 08:48:50 AM
*/

-- ----------------------------
--  Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
	"id" int4 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
	"username" varchar NOT NULL COLLATE "default",
	"password" varchar NOT NULL COLLATE "default",
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
INSERT INTO "public"."users" VALUES ('0', 'admin', 'admin', '0', 'pat@me.com', null);
INSERT INTO "public"."users" VALUES ('1', 'cms', 'cms', '0', 'pat@cappelaere.com', '7a141135be059d091c78740f108d8770');
INSERT INTO "public"."users" VALUES ('2', 'site1', 'site1', '10', 'patrice@vightel.com', 'c7e6442e93e68a5624c004f4cdd08b38');
INSERT INTO "public"."users" VALUES ('3', 'site2', 'site2', '12', 'pat@geobliki.com', null);
INSERT INTO "public"."users" VALUES ('4', 'site3', 'site3', '13', 'cappelaere@gamil.com', null);
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
CREATE UNIQUE INDEX  "email_index" ON "public"."users" USING btree(username COLLATE "default" ASC NULLS LAST, "id" ASC NULLS LAST, email COLLATE "default" ASC NULLS LAST);

