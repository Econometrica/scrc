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

 Date: 08/02/2013 10:55:13 AM
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
--  Records of users
-- ----------------------------
BEGIN;
INSERT INTO "users" VALUES ('site1', 'site1', '1');
INSERT INTO "users" VALUES ('site2', 'site2', '2');
INSERT INTO "users" VALUES ('site3', 'site3', '3');
INSERT INTO "users" VALUES ('site4', 'site4', '4');
INSERT INTO "users" VALUES ('cms', 'cms', '0');
COMMIT;

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
--  Records of ownerships
-- ----------------------------
BEGIN;
INSERT INTO "ownerships" VALUES ('1', 'Proprietary');
INSERT INTO "ownerships" VALUES ('3', 'Voluntary non-profit - Other');
INSERT INTO "ownerships" VALUES ('4', 'Voluntary non-profit - Private');
INSERT INTO "ownerships" VALUES ('2', 'Voluntary non-profit - Church');
COMMIT;

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
--  Records of sites
-- ----------------------------
BEGIN;
INSERT INTO "sites" VALUES ('10', 'St. Clare''s Hospital', '40.89', '-74.42', '2', 'http://media.nj.com/ledgerlocal/photo/9018596-large.jpg', 'http://www.saintclares.org/saint-clares-hospital-denville-new-jersey', '25 Pocono Road Denville, NJ  07834 ', 'NJ');
INSERT INTO "sites" VALUES ('11', 'Hunterdon Medical Center', '40.53', '-74.86', '4', 'http://www.hunterdonhealthcare.org/sites/default/files/u6/HMC%201-18-2012%20(2).jpg', 'http://www.hunterdonhealthcare.org/', '2100 Wescott Drive Flemington, NJ 08822', 'NJ');
INSERT INTO "sites" VALUES ('12', 'Overlook Medical Center', '40.71', '-74.35', '3', 'http://media.nj.com/independentpress_impact/photo/10696945-large.jpg', 'http://www.atlantichealth.org/overlook/', '99 Beauvoir Avenue Summit, NJ  07902 ', 'NJ');
INSERT INTO "sites" VALUES ('13', 'RiverView Medical Center', '40.35', '-74.06', '1', 'http://www.riverviewmedicalcenter.com/images/noFlash-RMC.jpg', 'http://www.riverviewmedicalcenter.com/RMC/index.cfm', '1 Riverview Plaza, Red Bank, NJ  07701', 'NJ');
INSERT INTO "sites" VALUES ('0', 'CMS', '0', '0', '0', null, null, null, null);
INSERT INTO "sites" VALUES ('1', 'CTRL GRP1', '0', '0', '0', null, null, null, null);
INSERT INTO "sites" VALUES ('2', 'CTRL GRP2', '0', '0', '0', null, null, null, null);
INSERT INTO "sites" VALUES ('3', 'CTRL GRP3', '0', '0', '0', null, null, null, null);
COMMIT;

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
--  Records of domains
-- ----------------------------
BEGIN;
INSERT INTO "domains" VALUES ('2', 'Quality Measures', 'f');
INSERT INTO "domains" VALUES ('3', 'Utilization Measures', 'f');
INSERT INTO "domains" VALUES ('4', 'Payments', 'f');
INSERT INTO "domains" VALUES ('5', 'Patient Case-Mix', 'f');
INSERT INTO "domains" VALUES ('6', 'Physiciam Inforamtion', 'f');
INSERT INTO "domains" VALUES ('7', 'Care Redesign Intervention', 't');
INSERT INTO "domains" VALUES ('8', 'Gainsharing Methodology', 't');
INSERT INTO "domains" VALUES ('9', 'Adherence', 'f');
INSERT INTO "domains" VALUES ('10', 'Negative Unintended Consequences', 't');
INSERT INTO "domains" VALUES ('1', 'Structural Measures', 't');
COMMIT;

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
--  Records of measures
-- ----------------------------
BEGIN;
INSERT INTO "measures" VALUES ('1', 'Heath Information Technology', '1', null);
INSERT INTO "measures" VALUES ('2', 'Leadership Oversight Support', '1', null);
INSERT INTO "measures" VALUES ('3', 'Staffing Changes', '1', null);
INSERT INTO "measures" VALUES ('5', 'Hospital Acquired Conditions', '2', null);
INSERT INTO "measures" VALUES ('6', 'Readmissions', '2', null);
INSERT INTO "measures" VALUES ('7', 'Prevention Quality Indicators (PQI) (ambulatory sensitive)', '2', null);
INSERT INTO "measures" VALUES ('8', 'Inpatient Quality Indicators (IQI)', '2', null);
INSERT INTO "measures" VALUES ('9', 'Patient Safety Indicators (PSI)', '2', null);
INSERT INTO "measures" VALUES ('10', 'Outpatient Imaging Efficiency Measures', '2', null);
INSERT INTO "measures" VALUES ('11', 'Patient Survey', '2', null);
INSERT INTO "measures" VALUES ('12', 'Emergency Department Efficiency', '2', null);
INSERT INTO "measures" VALUES ('13', 'Timely & Effective Care - Acute Myocardial Infarction', '2', null);
INSERT INTO "measures" VALUES ('14', 'Timely & Effective Care - Heart Failure', '2', null);
INSERT INTO "measures" VALUES ('15', 'Timely & Effective Care - Pnemonia', '2', null);
INSERT INTO "measures" VALUES ('16', 'Volume of Services', '3', null);
INSERT INTO "measures" VALUES ('17', 'Physician Referral to Post Acute Care Settings', '3', null);
INSERT INTO "measures" VALUES ('18', 'Admissions Patterns', '3', null);
INSERT INTO "measures" VALUES ('19', 'Readmissions', '3', null);
INSERT INTO "measures" VALUES ('20', 'Length of Stay', '3', null);
INSERT INTO "measures" VALUES ('21', 'Incentive Payments', '4', null);
INSERT INTO "measures" VALUES ('22', 'Medicare Payments', '4', null);
INSERT INTO "measures" VALUES ('4', 'Mortality', '2', 'rate per 10,000');
COMMIT;

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
--  Records of departments
-- ----------------------------
BEGIN;
INSERT INTO "departments" VALUES ('1', 'Hospital  Emergency Department');
INSERT INTO "departments" VALUES ('2', 'Observation Care');
INSERT INTO "departments" VALUES ('3', 'Outpatient Care');
INSERT INTO "departments" VALUES ('4', 'Intensive Care Unit');
INSERT INTO "departments" VALUES ('5', 'Critical Care Unit');
INSERT INTO "departments" VALUES ('6', 'Intermediate Care Unit');
INSERT INTO "departments" VALUES ('7', 'Other Inpatient');
INSERT INTO "departments" VALUES ('9', 'Hospice');
INSERT INTO "departments" VALUES ('10', 'Long-term Care Hospital');
INSERT INTO "departments" VALUES ('11', 'Inpatient Rehab Facility');
INSERT INTO "departments" VALUES ('12', 'Home With Home Health Agency');
INSERT INTO "departments" VALUES ('8', 'Skill Nursing Agency');
INSERT INTO "departments" VALUES ('13', 'Other Facility Discharge');
INSERT INTO "departments" VALUES ('14', 'Home Without Home Health Agency');
INSERT INTO "departments" VALUES ('15', 'Againt Medical Advice');
INSERT INTO "departments" VALUES ('16', 'Other');
INSERT INTO "departments" VALUES ('17', 'Death (absorbing state at any point of Transition)');
COMMIT;

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
--  Records of drg_statistics
-- ----------------------------
BEGIN;
INSERT INTO "drg_statistics" VALUES ('1', '4');
INSERT INTO "drg_statistics" VALUES ('2', '5');
INSERT INTO "drg_statistics" VALUES ('4', '6');
INSERT INTO "drg_statistics" VALUES ('5', '7');
COMMIT;

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
--  Records of patients
-- ----------------------------
BEGIN;
INSERT INTO "patients" VALUES ('1', 'All');
INSERT INTO "patients" VALUES ('2', 'Dual Eligible');
INSERT INTO "patients" VALUES ('3', 'PP1');
INSERT INTO "patients" VALUES ('4', 'PP2');
COMMIT;

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
--  Records of quick_statistics
-- ----------------------------
BEGIN;
INSERT INTO "quick_statistics" VALUES ('1', '4');
INSERT INTO "quick_statistics" VALUES ('2', '5');
INSERT INTO "quick_statistics" VALUES ('3', '6');
INSERT INTO "quick_statistics" VALUES ('4', '7');
COMMIT;

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
--  Records of drgs
-- ----------------------------
BEGIN;
INSERT INTO "drgs" VALUES ('1', 'Heart transplant or implant of heart assist system w MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('2', 'Heart transplant or implant of heart assist system w/o MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('3', 'ECMO or trach w MV 96+ hrs or PDX exc face, mouth & neck w maj O.R.', 'SURGICAL TRACHEOSTOM');
INSERT INTO "drgs" VALUES ('4', 'Trach w MV 96+ hrs or PDX exc face, mouth & neck w/o maj O.R.', 'SURGICAL TRACHEOSTOM');
INSERT INTO "drgs" VALUES ('5', 'Liver transplant w MCC or intestinal transplant', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('6', 'Liver transplant w/o MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('7', 'Lung transplant', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('8', 'Simultaneous pancreas/kidney transplant', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('9', 'Bone marrow transplant', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('10', 'Pancreas transplant', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('11', 'Tracheostomy for face,mouth & neck diagnoses w MCC', 'SURGICAL TRACHEOSTOM');
INSERT INTO "drgs" VALUES ('12', 'Tracheostomy for face,mouth & neck diagnoses w CC', 'SURGICAL TRACHEOSTOM');
INSERT INTO "drgs" VALUES ('13', 'Tracheostomy for face,mouth & neck diagnoses w/o CC/MCC', 'SURGICAL TRACHEOSTOM');
INSERT INTO "drgs" VALUES ('20', 'Intracranial vascular procedures w PDX hemorrhage w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('21', 'Intracranial vascular procedures w PDX hemorrhage w CC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('22', 'Intracranial vascular procedures w PDX hemorrhage w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('23', 'Cranio w major dev impl/acute complex CNS PDX w MCC or chemo implant', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('24', 'Cranio w major dev impl/acute complex CNS PDX w/o MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('25', 'Craniotomy & endovascular intracranial procedures w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('26', 'Craniotomy & endovascular intracranial procedures w CC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('27', 'Craniotomy & endovascular intracranial procedures w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('28', 'Spinal procedures w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('29', 'Spinal procedures w CC or spinal neurostimulators', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('30', 'Spinal procedures w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('31', 'Ventricular shunt procedures w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('32', 'Ventricular shunt procedures w CC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('33', 'Ventricular shunt procedures w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('34', 'Carotid artery stent procedure w MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('35', 'Carotid artery stent procedure w CC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('36', 'Carotid artery stent procedure w/o CC/MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('37', 'Extracranial procedures w MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('38', 'Extracranial procedures w CC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('39', 'Extracranial procedures w/o CC/MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('40', 'Periph & cranial nerve & other nerv syst proc w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('41', 'Periph/cranial nerve & other nerv syst proc w CC or periph neurostim', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('42', 'Periph & cranial nerve & other nerv syst proc w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('52', 'Spinal disorders & injuries w CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('53', 'Spinal disorders & injuries w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('54', 'Nervous system neoplasms w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('55', 'Nervous system neoplasms w/o MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('56', 'Degenerative nervous system disorders w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('57', 'Degenerative nervous system disorders w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('58', 'Multiple sclerosis & cerebellar ataxia w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('59', 'Multiple sclerosis & cerebellar ataxia w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('60', 'Multiple sclerosis & cerebellar ataxia w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('61', 'Acute ischemic stroke w use of thrombolytic agent w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('62', 'Acute ischemic stroke w use of thrombolytic agent w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('63', 'Acute ischemic stroke w use of thrombolytic agent w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('64', 'Intracranial hemorrhage or cerebral infarction w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('65', 'Intracranial hemorrhage or cerebral infarction w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('66', 'Intracranial hemorrhage or cerebral infarction w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('67', 'Nonspecific cva & precerebral occlusion w/o infarct w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('68', 'Nonspecific cva & precerebral occlusion w/o infarct w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('69', 'Transient ischemia', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('70', 'Nonspecific cerebrovascular disorders w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('71', 'Nonspecific cerebrovascular disorders w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('72', 'Nonspecific cerebrovascular disorders w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('73', 'Cranial & peripheral nerve disorders w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('74', 'Cranial & peripheral nerve disorders w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('75', 'Viral meningitis w CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('76', 'Viral meningitis w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('77', 'Hypertensive encephalopathy w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('78', 'Hypertensive encephalopathy w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('79', 'Hypertensive encephalopathy w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('80', 'Nontraumatic stupor & coma w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('81', 'Nontraumatic stupor & coma w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('82', 'Traumatic stupor & coma, coma >1 hr w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('83', 'Traumatic stupor & coma, coma >1 hr w CC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('84', 'Traumatic stupor & coma, coma >1 hr w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('85', 'Traumatic stupor & coma, coma <1 hr w MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('86', 'Traumatic stupor & coma, coma <1 hr w CC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('87', 'Traumatic stupor & coma, coma <1 hr w/o CC/MCC', 'NEUROSURGERY');
INSERT INTO "drgs" VALUES ('88', 'Concussion w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('89', 'Concussion w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('90', 'Concussion w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('91', 'Other disorders of nervous system w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('92', 'Other disorders of nervous system w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('93', 'Other disorders of nervous system w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('94', 'Bacterial & tuberculous infections of nervous system w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('95', 'Bacterial & tuberculous infections of nervous system w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('96', 'Bacterial & tuberculous infections of nervous system w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('97', 'Non-bacterial infect of nervous sys exc viral meningitis w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('98', 'Non-bacterial infect of nervous sys exc viral meningitis w CC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('99', 'Non-bacterial infect of nervous sys exc viral meningitis w/o CC/MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('100', 'Seizures w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('101', 'Seizures w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('102', 'Headaches w MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('103', 'Headaches w/o MCC', 'NEUROLOGY');
INSERT INTO "drgs" VALUES ('113', 'Orbital procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('114', 'Orbital procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('115', 'Extraocular procedures except orbit', 'OTHER');
INSERT INTO "drgs" VALUES ('116', 'Intraocular procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('117', 'Intraocular procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('121', 'Acute major eye infections w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('122', 'Acute major eye infections w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('123', 'Neurological eye disorders', 'OTHER');
INSERT INTO "drgs" VALUES ('124', 'Other disorders of the eye w  MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('125', 'Other disorders of the eye w/o  MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('129', 'Major head & neck procedures w CC/MCC or major device', 'OTHER');
INSERT INTO "drgs" VALUES ('130', 'Major head & neck procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('131', 'Cranial/facial procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('132', 'Cranial/facial procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('133', 'Other ear, nose, mouth & throat O.R. procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('134', 'Other ear, nose, mouth & throat O.R. procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('135', 'Sinus & mastoid procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('136', 'Sinus & mastoid procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('137', 'Mouth procedures w CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('138', 'Mouth procedures w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('139', 'Salivary gland procedures', 'OTHER');
INSERT INTO "drgs" VALUES ('146', 'Ear, nose, mouth & throat malignancy w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('147', 'Ear, nose, mouth & throat malignancy w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('148', 'Ear, nose, mouth & throat malignancy w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('149', 'Dysequilibrium', 'OTHER');
INSERT INTO "drgs" VALUES ('150', 'Epistaxis w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('151', 'Epistaxis w/o MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('152', 'Otitis media & URI w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('153', 'Otitis media & URI w/o MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('154', 'Nasal trauma & deformity w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('155', 'Nasal trauma & deformity w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('156', 'Nasal trauma & deformity w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('157', 'Dental & Oral Diseases w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('158', 'Dental & Oral Diseases w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('159', 'Dental & Oral Diseases w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('163', 'Major chest procedures w MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('164', 'Major chest procedures w CC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('165', 'Major chest procedures w/o CC/MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('166', 'Other resp system O.R. procedures w MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('167', 'Other resp system O.R. procedures w CC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('168', 'Other resp system O.R. procedures w/o CC/MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('175', 'Pulmonary embolism w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('176', 'Pulmonary embolism w/o MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('177', 'Respiratory infections & inflammations w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('178', 'Respiratory infections & inflammations w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('179', 'Respiratory infections & inflammations w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('180', 'Respiratory neoplasms w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('181', 'Respiratory neoplasms w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('182', 'Respiratory neoplasms w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('183', 'Major chest trauma w MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('184', 'Major chest trauma w CC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('185', 'Major chest trauma w/o CC/MCC', 'THORACIC SURGERY');
INSERT INTO "drgs" VALUES ('186', 'Pleural effusion w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('187', 'Pleural effusion w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('188', 'Pleural effusion w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('189', 'Pulmonary edema & respiratory failure', 'PULMONARY');
INSERT INTO "drgs" VALUES ('190', 'Chronic obstructive pulmonary disease w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('191', 'Chronic obstructive pulmonary disease w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('192', 'Chronic obstructive pulmonary disease w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('193', 'Simple pneumonia & pleurisy w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('194', 'Simple pneumonia & pleurisy w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('195', 'Simple pneumonia & pleurisy w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('196', 'Interstitial lung disease w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('197', 'Interstitial lung disease w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('198', 'Interstitial lung disease w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('199', 'Pneumothorax w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('200', 'Pneumothorax w CC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('201', 'Pneumothorax w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('202', 'Bronchitis & asthma w CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('203', 'Bronchitis & asthma w/o CC/MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('204', 'Respiratory signs & symptoms', 'PULMONARY');
INSERT INTO "drgs" VALUES ('205', 'Other respiratory system diagnoses w MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('206', 'Other respiratory system diagnoses w/o MCC', 'PULMONARY');
INSERT INTO "drgs" VALUES ('207', 'Respiratory system diagnosis w ventilator support 96+ hours', 'PULMONARY');
INSERT INTO "drgs" VALUES ('208', 'Respiratory system diagnosis w ventilator support <96 hours', 'PULMONARY');
INSERT INTO "drgs" VALUES ('215', 'Other heart assist system implant', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('216', 'Cardiac valve & oth maj cardiothoracic proc w card cath w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('217', 'Cardiac valve & oth maj cardiothoracic proc w card cath w CC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('218', 'Cardiac valve & oth maj cardiothoracic proc w card cath w/o CC/MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('219', 'Cardiac valve & oth maj cardiothoracic proc w/o card cath w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('220', 'Cardiac valve & oth maj cardiothoracic proc w/o card cath w CC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('221', 'Cardiac valve & oth maj cardiothoracic proc w/o card cath w/o CC/MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('222', 'Cardiac defib implant w cardiac cath w AMI/HF/shock w MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('223', 'Cardiac defib implant w cardiac cath w AMI/HF/shock w/o MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('224', 'Cardiac defib implant w cardiac cath w/o AMI/HF/shock w MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('225', 'Cardiac defib implant w cardiac cath w/o AMI/HF/shock w/o MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('226', 'Cardiac defibrillator implant w/o cardiac cath w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('227', 'Cardiac defibrillator implant w/o cardiac cath w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('228', 'Other cardiothoracic procedures w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('229', 'Other cardiothoracic procedures w CC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('230', 'Other cardiothoracic procedures w/o CC/MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('231', 'Coronary bypass w PTCA w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('232', 'Coronary bypass w PTCA w/o MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('233', 'Coronary bypass w cardiac cath w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('234', 'Coronary bypass w cardiac cath w/o MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('235', 'Coronary bypass w/o cardiac cath w MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('236', 'Coronary bypass w/o cardiac cath w/o MCC', 'OPEN HEART');
INSERT INTO "drgs" VALUES ('237', 'Major cardiovasc procedures w MCC or thoracic aortic anuerysm repair', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('238', 'Major cardiovascular procedures w/o MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('239', 'Amputation for circ sys disorders exc upper limb & toe w MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('240', 'Amputation for circ sys disorders exc upper limb & toe w CC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('241', 'Amputation for circ sys disorders exc upper limb & toe w/o CC/MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('242', 'Permanent cardiac pacemaker implant w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('243', 'Permanent cardiac pacemaker implant w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('244', 'Permanent cardiac pacemaker implant w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('245', 'AICD lead & generator procedures', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('246', 'Perc cardiovasc proc w drug-eluting stent w MCC or 4+ vessels/stents', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('247', 'Perc cardiovasc proc w drug-eluting stent w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('248', 'Perc cardiovasc proc w non-drug-eluting stent w MCC or 4+ ves/stents', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('249', 'Perc cardiovasc proc w non-drug-eluting stent w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('250', 'Perc cardiovasc proc w/o coronary artery stent or AMI w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('251', 'Perc cardiovasc proc w/o coronary artery stent or AMI w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('252', 'Other vascular procedures w MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('253', 'Other vascular procedures w CC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('254', 'Other vascular procedures w/o CC/MCC', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('255', 'Upper limb & toe amputation for circ system disorders w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('256', 'Upper limb & toe amputation for circ system disorders w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('257', 'Upper limb & toe amputation for circ system disorders w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('258', 'Cardiac pacemaker device replacement w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('259', 'Cardiac pacemaker device replacement w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('260', 'Cardiac pacemaker revision except device replacement w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('261', 'Cardiac pacemaker revision except device replacement w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('262', 'Cardiac pacemaker revision except device replacement w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('263', 'Vein ligation & stripping', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('264', 'Other circulatory system O.R. procedures', 'VASCULAR SURGERY');
INSERT INTO "drgs" VALUES ('280', 'Acute myocardial infarction, discharged alive w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('281', 'Acute myocardial infarction, discharged alive w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('282', 'Acute myocardial infarction, discharged alive w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('283', 'Acute myocardial infarction, expired w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('284', 'Acute myocardial infarction, expired w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('285', 'Acute myocardial infarction, expired w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('286', 'Circulatory disorders except AMI, w card cath w MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('287', 'Circulatory disorders except AMI, w card cath w/o MCC', 'CARDIAC CATHS');
INSERT INTO "drgs" VALUES ('288', 'Acute & subacute endocarditis w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('289', 'Acute & subacute endocarditis w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('290', 'Acute & subacute endocarditis w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('291', 'Heart failure & shock w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('292', 'Heart failure & shock w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('293', 'Heart failure & shock w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('294', 'Deep vein thrombophlebitis w CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('295', 'Deep vein thrombophlebitis w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('296', 'Cardiac arrest, unexplained w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('297', 'Cardiac arrest, unexplained w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('298', 'Cardiac arrest, unexplained w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('299', 'Peripheral vascular disorders w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('300', 'Peripheral vascular disorders w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('301', 'Peripheral vascular disorders w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('302', 'Atherosclerosis w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('303', 'Atherosclerosis w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('304', 'Hypertension w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('305', 'Hypertension w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('306', 'Cardiac congenital & valvular disorders w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('307', 'Cardiac congenital & valvular disorders w/o MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('308', 'Cardiac arrhythmia & conduction disorders w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('309', 'Cardiac arrhythmia & conduction disorders w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('310', 'Cardiac arrhythmia & conduction disorders w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('311', 'Angina pectoris', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('312', 'Syncope & collapse', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('313', 'Chest pain', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('314', 'Other circulatory system diagnoses w MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('315', 'Other circulatory system diagnoses w CC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('316', 'Other circulatory system diagnoses w/o CC/MCC', 'CARDIOLOGY');
INSERT INTO "drgs" VALUES ('326', 'Stomach, esophageal & duodenal proc w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('327', 'Stomach, esophageal & duodenal proc w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('328', 'Stomach, esophageal & duodenal proc w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('329', 'Major small & large bowel procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('330', 'Major small & large bowel procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('331', 'Major small & large bowel procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('332', 'Rectal resection w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('333', 'Rectal resection w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('334', 'Rectal resection w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('335', 'Peritoneal adhesiolysis w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('336', 'Peritoneal adhesiolysis w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('337', 'Peritoneal adhesiolysis w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('338', 'Appendectomy w complicated principal diag w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('339', 'Appendectomy w complicated principal diag w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('340', 'Appendectomy w complicated principal diag w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('341', 'Appendectomy w/o complicated principal diag w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('342', 'Appendectomy w/o complicated principal diag w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('343', 'Appendectomy w/o complicated principal diag w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('344', 'Minor small & large bowel procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('345', 'Minor small & large bowel procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('346', 'Minor small & large bowel procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('347', 'Anal & stomal procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('348', 'Anal & stomal procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('349', 'Anal & stomal procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('350', 'Inguinal & femoral hernia procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('351', 'Inguinal & femoral hernia procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('352', 'Inguinal & femoral hernia procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('353', 'Hernia procedures except inguinal & femoral w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('354', 'Hernia procedures except inguinal & femoral w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('355', 'Hernia procedures except inguinal & femoral w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('356', 'Other digestive system O.R. procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('357', 'Other digestive system O.R. procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('358', 'Other digestive system O.R. procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('368', 'Major esophageal disorders w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('369', 'Major esophageal disorders w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('370', 'Major esophageal disorders w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('371', 'Major gastrointestinal disorders & peritoneal infections w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('372', 'Major gastrointestinal disorders & peritoneal infections w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('373', 'Major gastrointestinal disorders & peritoneal infections w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('374', 'Digestive malignancy w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('375', 'Digestive malignancy w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('376', 'Digestive malignancy w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('377', 'G.I. hemorrhage w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('378', 'G.I. hemorrhage w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('379', 'G.I. hemorrhage w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('380', 'Complicated peptic ulcer w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('381', 'Complicated peptic ulcer w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('382', 'Complicated peptic ulcer w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('383', 'Uncomplicated peptic ulcer w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('384', 'Uncomplicated peptic ulcer w/o MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('385', 'Inflammatory bowel disease w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('386', 'Inflammatory bowel disease w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('387', 'Inflammatory bowel disease w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('388', 'G.I. obstruction w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('389', 'G.I. obstruction w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('390', 'G.I. obstruction w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('391', 'Esophagitis, gastroent & misc digest disorders w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('392', 'Esophagitis, gastroent & misc digest disorders w/o MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('393', 'Other digestive system diagnoses w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('394', 'Other digestive system diagnoses w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('395', 'Other digestive system diagnoses w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('405', 'Pancreas, liver & shunt procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('406', 'Pancreas, liver & shunt procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('407', 'Pancreas, liver & shunt procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('408', 'Biliary tract proc except only cholecyst w or w/o c.d.e. w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('409', 'Biliary tract proc except only cholecyst w or w/o c.d.e. w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('410', 'Biliary tract proc except only cholecyst w or w/o c.d.e. w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('411', 'Cholecystectomy w c.d.e. w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('412', 'Cholecystectomy w c.d.e. w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('413', 'Cholecystectomy w c.d.e. w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('414', 'Cholecystectomy except by laparoscope w/o c.d.e. w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('415', 'Cholecystectomy except by laparoscope w/o c.d.e. w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('416', 'Cholecystectomy except by laparoscope w/o c.d.e. w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('417', 'Laparoscopic cholecystectomy w/o c.d.e. w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('418', 'Laparoscopic cholecystectomy w/o c.d.e. w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('419', 'Laparoscopic cholecystectomy w/o c.d.e. w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('420', 'Hepatobiliary diagnostic procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('421', 'Hepatobiliary diagnostic procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('422', 'Hepatobiliary diagnostic procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('423', 'Other hepatobiliary or pancreas O.R. procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('424', 'Other hepatobiliary or pancreas O.R. procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('425', 'Other hepatobiliary or pancreas O.R. procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('432', 'Cirrhosis & alcoholic hepatitis w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('433', 'Cirrhosis & alcoholic hepatitis w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('434', 'Cirrhosis & alcoholic hepatitis w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('435', 'Malignancy of hepatobiliary system or pancreas w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('436', 'Malignancy of hepatobiliary system or pancreas w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('437', 'Malignancy of hepatobiliary system or pancreas w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('438', 'Disorders of pancreas except malignancy w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('439', 'Disorders of pancreas except malignancy w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('440', 'Disorders of pancreas except malignancy w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('441', 'Disorders of liver except malig,cirr,alc hepa w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('442', 'Disorders of liver except malig,cirr,alc hepa w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('443', 'Disorders of liver except malig,cirr,alc hepa w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('444', 'Disorders of the biliary tract w MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('445', 'Disorders of the biliary tract w CC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('446', 'Disorders of the biliary tract w/o CC/MCC', 'GASTROENTEROLOGY');
INSERT INTO "drgs" VALUES ('453', 'Combined anterior/posterior spinal fusion w MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('454', 'Combined anterior/posterior spinal fusion w CC', 'SPINE');
INSERT INTO "drgs" VALUES ('455', 'Combined anterior/posterior spinal fusion w/o CC/MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('456', 'Spinal fus exc cerv w spinal curv/malig/infec or 9+ fus w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('457', 'Spinal fus exc cerv w spinal curv/malig/infec or 9+ fus w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('458', 'Spinal fus exc cerv w spinal curv/malig/infec or 9+ fus w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('459', 'Spinal fusion except cervical w MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('460', 'Spinal fusion except cervical w/o MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('461', 'Bilateral or multiple major joint procs of lower extremity w MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('462', 'Bilateral or multiple major joint procs of lower extremity w/o MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('463', 'Wnd debrid & skn grft exc hand, for musculo-conn tiss dis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('464', 'Wnd debrid & skn grft exc hand, for musculo-conn tiss dis w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('465', 'Wnd debrid & skn grft exc hand, for musculo-conn tiss dis w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('466', 'Revision of hip or knee replacement w MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('467', 'Revision of hip or knee replacement w CC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('468', 'Revision of hip or knee replacement w/o CC/MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('469', 'Major joint replacement or reattachment of lower extremity w MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('470', 'Major joint replacement or reattachment of lower extremity w/o MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('471', 'Cervical spinal fusion w MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('472', 'Cervical spinal fusion w CC', 'SPINE');
INSERT INTO "drgs" VALUES ('473', 'Cervical spinal fusion w/o CC/MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('474', 'Amputation for musculoskeletal sys & conn tissue dis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('475', 'Amputation for musculoskeletal sys & conn tissue dis w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('476', 'Amputation for musculoskeletal sys & conn tissue dis w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('477', 'Biopsies of musculoskeletal system & connective tissue w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('478', 'Biopsies of musculoskeletal system & connective tissue w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('479', 'Biopsies of musculoskeletal system & connective tissue w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('480', 'Hip & femur procedures except major joint w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('481', 'Hip & femur procedures except major joint w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('482', 'Hip & femur procedures except major joint w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('483', 'Major joint & limb reattachment proc of upper extremity w CC/MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('484', 'Major joint & limb reattachment proc of upper extremity w/o CC/MCC', 'MAJOR JOINT PROCEDURE');
INSERT INTO "drgs" VALUES ('485', 'Knee procedures w pdx of infection w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('486', 'Knee procedures w pdx of infection w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('487', 'Knee procedures w pdx of infection w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('488', 'Knee procedures w/o pdx of infection w CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('489', 'Knee procedures w/o pdx of infection w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('490', 'Back & neck proc exc spinal fusion w CC/MCC or disc device/neurostim', 'SPINE');
INSERT INTO "drgs" VALUES ('491', 'Back & neck proc exc spinal fusion w/o CC/MCC', 'SPINE');
INSERT INTO "drgs" VALUES ('492', 'Lower extrem & humer proc except hip,foot,femur w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('493', 'Lower extrem & humer proc except hip,foot,femur w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('494', 'Lower extrem & humer proc except hip,foot,femur w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('495', 'Local excision & removal int fix devices exc hip & femur w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('496', 'Local excision & removal int fix devices exc hip & femur w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('497', 'Local excision & removal int fix devices exc hip & femur w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('498', 'Local excision & removal int fix devices of hip & femur w CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('499', 'Local excision & removal int fix devices of hip & femur w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('500', 'Soft tissue procedures w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('501', 'Soft tissue procedures w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('502', 'Soft tissue procedures w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('503', 'Foot procedures w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('504', 'Foot procedures w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('505', 'Foot procedures w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('506', 'Major thumb or joint procedures', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('507', 'Major shoulder or elbow joint procedures w CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('508', 'Major shoulder or elbow joint procedures w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('509', 'Arthroscopy', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('510', 'Shoulder,elbow or forearm proc,exc major joint proc w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('511', 'Shoulder,elbow or forearm proc,exc major joint proc w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('512', 'Shoulder,elbow or forearm proc,exc major joint proc w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('513', 'Hand or wrist proc, except major thumb or joint proc w CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('514', 'Hand or wrist proc, except major thumb or joint proc w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('515', 'Other musculoskelet sys & conn tiss O.R. proc w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('516', 'Other musculoskelet sys & conn tiss O.R. proc w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('517', 'Other musculoskelet sys & conn tiss O.R. proc w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('533', 'Fractures of femur w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('534', 'Fractures of femur w/o MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('535', 'Fractures of hip & pelvis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('536', 'Fractures of hip & pelvis w/o MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('537', 'Sprains, strains, & dislocations of hip, pelvis & thigh w CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('538', 'Sprains, strains, & dislocations of hip, pelvis & thigh w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('539', 'Osteomyelitis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('540', 'Osteomyelitis w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('541', 'Osteomyelitis w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('542', 'Pathological fractures & musculoskelet & conn tiss malig w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('543', 'Pathological fractures & musculoskelet & conn tiss malig w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('544', 'Pathological fractures & musculoskelet & conn tiss malig w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('545', 'Connective tissue disorders w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('546', 'Connective tissue disorders w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('547', 'Connective tissue disorders w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('548', 'Septic arthritis w MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('549', 'Septic arthritis w CC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('550', 'Septic arthritis w/o CC/MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('551', 'Medical back problems w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('552', 'Medical back problems w/o MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('553', 'Bone diseases & arthropathies w MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('554', 'Bone diseases & arthropathies w/o MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('555', 'Signs & symptoms of musculoskeletal system & conn tissue w MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('556', 'Signs & symptoms of musculoskeletal system & conn tissue w/o MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('557', 'Tendonitis, myositis & bursitis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('558', 'Tendonitis, myositis & bursitis w/o MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('559', 'Aftercare, musculoskeletal system & connective tissue w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('560', 'Aftercare, musculoskeletal system & connective tissue w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('561', 'Aftercare, musculoskeletal system & connective tissue w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('562', 'Fx, sprn, strn & disl except femur, hip, pelvis & thigh w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('563', 'Fx, sprn, strn & disl except femur, hip, pelvis & thigh w/o MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('564', 'Other musculoskeletal sys & connective tissue diagnoses w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('565', 'Other musculoskeletal sys & connective tissue diagnoses w CC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('566', 'Other musculoskeletal sys & connective tissue diagnoses w/o CC/MCC', 'RHEUMATOLOGY');
INSERT INTO "drgs" VALUES ('573', 'Skin graft &/or debrid for skn ulcer or cellulitis w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('574', 'Skin graft &/or debrid for skn ulcer or cellulitis w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('575', 'Skin graft &/or debrid for skn ulcer or cellulitis w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('576', 'Skin graft &/or debrid exc for skin ulcer or cellulitis w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('577', 'Skin graft &/or debrid exc for skin ulcer or cellulitis w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('578', 'Skin graft &/or debrid exc for skin ulcer or cellulitis w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('579', 'Other skin, subcut tiss & breast proc w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('580', 'Other skin, subcut tiss & breast proc w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('581', 'Other skin, subcut tiss & breast proc w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('582', 'Mastectomy for malignancy w CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('583', 'Mastectomy for malignancy w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('584', 'Breast biopsy, local excision & other breast procedures w CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('585', 'Breast biopsy, local excision & other breast procedures w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('592', 'Skin ulcers w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('593', 'Skin ulcers w CC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('594', 'Skin ulcers w/o CC/MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('595', 'Major skin disorders w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('596', 'Major skin disorders w/o MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('597', 'Malignant breast disorders w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('598', 'Malignant breast disorders w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('599', 'Malignant breast disorders w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('600', 'Non-malignant breast disorders w CC/MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('601', 'Non-malignant breast disorders w/o CC/MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('602', 'Cellulitis w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('603', 'Cellulitis w/o MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('604', 'Trauma to the skin, subcut tiss & breast w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('605', 'Trauma to the skin, subcut tiss & breast w/o MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('606', 'Minor skin disorders w MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('607', 'Minor skin disorders w/o MCC', 'DERMATOLOGY');
INSERT INTO "drgs" VALUES ('614', 'Adrenal & pituitary procedures w CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('615', 'Adrenal & pituitary procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('616', 'Amputat of lower limb for endocrine,nutrit,& metabol dis w MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('617', 'Amputat of lower limb for endocrine,nutrit,& metabol dis w CC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('618', 'Amputat of lower limb for endocrine,nutrit,& metabol dis w/o CC/MCC', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('619', 'O.R. procedures for obesity w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('620', 'O.R. procedures for obesity w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('621', 'O.R. procedures for obesity w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('622', 'Skin grafts & wound debrid for endoc, nutrit & metab dis w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('623', 'Skin grafts & wound debrid for endoc, nutrit & metab dis w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('624', 'Skin grafts & wound debrid for endoc, nutrit & metab dis w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('625', 'Thyroid, parathyroid & thyroglossal procedures w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('626', 'Thyroid, parathyroid & thyroglossal procedures w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('627', 'Thyroid, parathyroid & thyroglossal procedures w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('628', 'Other endocrine, nutrit & metab O.R. proc w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('629', 'Other endocrine, nutrit & metab O.R. proc w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('630', 'Other endocrine, nutrit & metab O.R. proc w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('637', 'Diabetes w MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('638', 'Diabetes w CC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('639', 'Diabetes w/o CC/MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('640', 'Nutritional & misc metabolic disorders w MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('641', 'Nutritional & misc metabolic disorders w/o MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('642', 'Inborn errors of metabolism', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('643', 'Endocrine disorders w MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('644', 'Endocrine disorders w CC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('645', 'Endocrine disorders w/o CC/MCC', 'ENDOCRINOLOGY');
INSERT INTO "drgs" VALUES ('652', 'Kidney transplant', 'UROLOGY');
INSERT INTO "drgs" VALUES ('653', 'Major bladder procedures w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('654', 'Major bladder procedures w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('655', 'Major bladder procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('656', 'Kidney & ureter procedures for neoplasm w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('657', 'Kidney & ureter procedures forneoplasm w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('658', 'Kidney & ureter procedures for neoplasm w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('659', 'Kidney & ureter procedures for non-neoplasm w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('660', 'Kidney & ureter procedures for non-neoplasm w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('661', 'Kidney & ureter procedures for non-neoplasm w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('662', 'Minor bladder procedures w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('663', 'Minor bladder procedures w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('664', 'Minor bladder procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('665', 'Prostatectomy w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('666', 'Prostatectomy w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('667', 'Prostatectomy w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('668', 'Transurethral procedures w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('669', 'Transurethral procedures w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('670', 'Transurethral procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('671', 'Urethral procedures w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('672', 'Urethral procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('673', 'Other kidney & urinary tract procedures w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('674', 'Other kidney & urinary tract procedures w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('675', 'Other kidney & urinary tract procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('682', 'Renal failure w MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('683', 'Renal failure w CC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('684', 'Renal failure w/o CC/MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('685', 'Admit for renal dialysis', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('686', 'Kidney & urinary tract neoplasms w MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('687', 'Kidney & urinary tract neoplasms w CC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('688', 'Kidney & urinary tract neoplasms w/o CC/MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('689', 'Kidney & urinary tract infections w MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('690', 'Kidney & urinary tract infections w/o MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('691', 'Urinary stones w esw lithotripsy w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('692', 'Urinary stones w esw lithotripsy w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('693', 'Urinary stones w/o esw lithotripsy w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('694', 'Urinary stones w/o esw lithotripsy w/o MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('695', 'Kidney & urinary tract signs & symptoms w MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('696', 'Kidney & urinary tract signs & symptoms w/o MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('697', 'Urethral stricture', 'UROLOGY');
INSERT INTO "drgs" VALUES ('698', 'Other kidney & urinary tract diagnoses w MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('699', 'Other kidney & urinary tract diagnoses w CC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('700', 'Other kidney & urinary tract diagnoses w/o CC/MCC', 'NEPHROLOGY');
INSERT INTO "drgs" VALUES ('707', 'Major male pelvic procedures w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('708', 'Major male pelvic procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('709', 'Penis procedures w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('710', 'Penis procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('711', 'Testes procedures w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('712', 'Testes procedures w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('713', 'Transurethral prostatectomy w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('714', 'Transurethral prostatectomy w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('715', 'Other male reproductive system O.R. proc for malignancy w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('716', 'Other male reproductive system O.R. proc for malignancy w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('717', 'Other male reproductive system O.R. proc exc malignancy w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('718', 'Other male reproductive system O.R. proc exc malignancy w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('722', 'Malignancy, male reproductive system w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('723', 'Malignancy, male reproductive system w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('724', 'Malignancy, male reproductive system w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('725', 'Benign prostatic hypertrophy w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('726', 'Benign prostatic hypertrophy w/o MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('727', 'Inflammation of the male reproductive system w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('728', 'Inflammation of the male reproductive system w/o MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('729', 'Other male reproductive system diagnoses w CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('730', 'Other male reproductive system diagnoses w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('734', 'Pelvic evisceration, rad hysterectomy & rad vulvectomy w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('735', 'Pelvic evisceration, rad hysterectomy & rad vulvectomy w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('736', 'Uterine & adnexa proc for ovarian or adnexal malignancy w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('737', 'Uterine & adnexa proc for ovarian or adnexal malignancy w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('738', 'Uterine & adnexa proc for ovarian or adnexal malignancy w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('739', 'Uterine,adnexa proc for non-ovarian/adnexal malig w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('740', 'Uterine,adnexa proc for non-ovarian/adnexal malig w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('741', 'Uterine,adnexa proc for non-ovarian/adnexal malig w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('742', 'Uterine & adnexa proc for non-malignancy w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('743', 'Uterine & adnexa proc for non-malignancy w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('744', 'D&C, conization, laparoscopy & tubal interruption w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('745', 'D&C, conization, laparoscopy & tubal interruption w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('746', 'Vagina, cervix & vulva procedures w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('747', 'Vagina, cervix & vulva procedures w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('748', 'Female reproductive system reconstructive procedures', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('749', 'Other female reproductive system O.R. procedures w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('750', 'Other female reproductive system O.R. procedures w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('754', 'Malignancy, female reproductive system w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('755', 'Malignancy, female reproductive system w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('756', 'Malignancy, female reproductive system w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('757', 'Infections, female reproductive system w MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('758', 'Infections, female reproductive system w CC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('759', 'Infections, female reproductive system w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('760', 'Menstrual & other female reproductive system disorders w CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('761', 'Menstrual & other female reproductive system disorders w/o CC/MCC', 'GYNECOLOGY');
INSERT INTO "drgs" VALUES ('765', 'Cesarean section w CC/MCC', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('766', 'Cesarean section w/o CC/MCC', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('767', 'Vaginal delivery w sterilization &/or D&C', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('768', 'Vaginal delivery w O.R. proc except steril &/or D&C', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('769', 'Postpartum & post abortion diagnoses w O.R. procedure', 'OTHER OB');
INSERT INTO "drgs" VALUES ('770', 'Abortion w D&C, aspiration curettage or hysterotomy', 'OTHER OB');
INSERT INTO "drgs" VALUES ('774', 'Vaginal delivery w complicating diagnoses', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('775', 'Vaginal delivery w/o complicating diagnoses', 'OBSTETRICS');
INSERT INTO "drgs" VALUES ('776', 'Postpartum & post abortion diagnoses w/o O.R. procedure', 'OTHER OB');
INSERT INTO "drgs" VALUES ('777', 'Ectopic pregnancy', 'OTHER OB');
INSERT INTO "drgs" VALUES ('778', 'Threatened abortion', 'OTHER OB');
INSERT INTO "drgs" VALUES ('779', 'Abortion w/o D&C', 'OTHER OB');
INSERT INTO "drgs" VALUES ('780', 'False labor', 'OTHER OB');
INSERT INTO "drgs" VALUES ('781', 'Other antepartum diagnoses w medical complications', 'OTHER OB');
INSERT INTO "drgs" VALUES ('782', 'Other antepartum diagnoses w/o medical complications', 'OTHER OB');
INSERT INTO "drgs" VALUES ('789', 'Neonates, died or transferred to another acute care facility', 'NEONATOLOGY');
INSERT INTO "drgs" VALUES ('790', 'Extreme immaturity or respiratory distress syndrome, neonate', 'NEONATOLOGY');
INSERT INTO "drgs" VALUES ('791', 'Prematurity w major problems', 'NEONATOLOGY');
INSERT INTO "drgs" VALUES ('792', 'Prematurity w/o major problems', 'NEONATOLOGY');
INSERT INTO "drgs" VALUES ('793', 'Full term neonate w major problems', 'NEONATOLOGY');
INSERT INTO "drgs" VALUES ('794', 'Neonate w other significant problems', 'NORMAL NEWBORN');
INSERT INTO "drgs" VALUES ('795', 'Normal newborn', 'NORMAL NEWBORN');
INSERT INTO "drgs" VALUES ('799', 'Splenectomy w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('800', 'Splenectomy w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('801', 'Splenectomy w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('802', 'Other O.R. proc of the blood & blood forming organs w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('803', 'Other O.R. proc of the blood & blood forming organs w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('804', 'Other O.R. proc of the blood & blood forming organs w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('808', 'Major hematol/immun diag exc sickle cell crisis & coagul w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('809', 'Major hematol/immun diag exc sickle cell crisis & coagul w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('810', 'Major hematol/immun diag exc sickle cell crisis & coagul w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('811', 'Red blood cell disorders w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('812', 'Red blood cell disorders w/o MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('813', 'Coagulation disorders', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('814', 'Reticuloendothelial & immunity disorders w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('815', 'Reticuloendothelial & immunity disorders w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('816', 'Reticuloendothelial & immunity disorders w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('820', 'Lymphoma & leukemia w major O.R. procedure w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('821', 'Lymphoma & leukemia w major O.R. procedure w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('822', 'Lymphoma & leukemia w major O.R. procedure w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('823', 'Lymphoma & non-acute leukemia w other O.R. proc w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('824', 'Lymphoma & non-acute leukemia w other O.R. proc w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('825', 'Lymphoma & non-acute leukemia w other O.R. proc w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('826', 'Myeloprolif disord or poorly diff neopl w maj O.R. proc w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('827', 'Myeloprolif disord or poorly diff neopl w maj O.R. proc w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('828', 'Myeloprolif disord or poorly diff neopl w maj O.R. proc w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('829', 'Myeloprolif disord or poorly diff neopl w other O.R. proc w CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('830', 'Myeloprolif disord or poorly diff neopl w other O.R. proc w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('834', 'Acute leukemia w/o major O.R. procedure w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('835', 'Acute leukemia w/o major O.R. procedure w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('836', 'Acute leukemia w/o major O.R. procedure w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('837', 'Chemo w acute leukemia as sdx or w high dose chemo agent w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('838', 'Chemo w acute leukemia as sdx w CC or high dose chemo agent', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('839', 'Chemo w acute leukemia as sdx w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('840', 'Lymphoma & non-acute leukemia w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('841', 'Lymphoma & non-acute leukemia w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('842', 'Lymphoma & non-acute leukemia w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('843', 'Other myeloprolif dis or poorly diff neopl diag w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('844', 'Other myeloprolif dis or poorly diff neopl diag w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('845', 'Other myeloprolif dis or poorly diff neopl diag w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('846', 'Chemotherapy w/o acute leukemia as secondary diagnosis w MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('847', 'Chemotherapy w/o acute leukemia as secondary diagnosis w CC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('848', 'Chemotherapy w/o acute leukemia as secondary diagnosis w/o CC/MCC', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('849', 'Radiotherapy', 'ONCOLOGY/HEMATOLOGY');
INSERT INTO "drgs" VALUES ('853', 'Infectious & parasitic diseases w O.R. procedure w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('854', 'Infectious & parasitic diseases w O.R. procedure w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('855', 'Infectious & parasitic diseases w O.R. procedure w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('856', 'Postoperative or post-traumatic infections w O.R. proc w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('857', 'Postoperative or post-traumatic infections w O.R. proc w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('858', 'Postoperative or post-traumatic infections w O.R. proc w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('862', 'Postoperative & post-traumatic infections w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('863', 'Postoperative & post-traumatic infections w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('864', 'Fever of unknown origin', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('865', 'Viral illness w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('866', 'Viral illness w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('867', 'Other infectious & parasitic diseases diagnoses w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('868', 'Other infectious & parasitic diseases diagnoses w CC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('869', 'Other infectious & parasitic diseases diagnoses w/o CC/MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('870', 'Septicemia w MV 96+ hours', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('871', 'Septicemia w/o MV 96+ hours w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('872', 'Septicemia w/o MV 96+ hours w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('876', 'O.R. procedure w principal diagnoses of mental illness', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('880', 'Acute adjustment reaction & psychosocial dysfunction', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('881', 'Depressive neuroses', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('882', 'Neuroses except depressive', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('883', 'Disorders of personality & impulse control', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('884', 'Organic disturbances & mental retardation', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('885', 'Psychoses', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('886', 'Behavioral & developmental disorders', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('887', 'Other mental disorder diagnoses', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('894', 'Alcohol/drug abuse or dependence, left ama', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('895', 'Alcohol/drug abuse or dependence w rehabilitation therapy', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('896', 'Alcohol/drug abuse or dependence w/o rehabilitation therapy w MCC', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('897', 'Alcohol/drug abuse or dependence w/o rehabilitation therapy w/o MCC', 'PSYCHIATRY');
INSERT INTO "drgs" VALUES ('901', 'Wound debridements for injuries w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('902', 'Wound debridements for injuries w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('903', 'Wound debridements for injuries w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('904', 'Skin grafts for injuries w CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('905', 'Skin grafts for injuries w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('906', 'Hand procedures for injuries', 'OTHER ORTHOPAEDICS');
INSERT INTO "drgs" VALUES ('907', 'Other O.R. procedures for injuries w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('908', 'Other O.R. procedures for injuries w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('909', 'Other O.R. procedures for injuries w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('913', 'Traumatic injury w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('914', 'Traumatic injury w/o MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('915', 'Allergic reactions w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('916', 'Allergic reactions w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('917', 'Poisoning & toxic effects of drugs w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('918', 'Poisoning & toxic effects of drugs w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('919', 'Complications of treatment w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('920', 'Complications of treatment w CC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('921', 'Complications of treatment w/o CC/MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('922', 'Other injury, poisoning & toxic effect diag w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('923', 'Other injury, poisoning & toxic effect diag w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('927', 'Extensive burns or full thickness burns w MV 96+ hrs w skin graft', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('928', 'Full thickness burn w skin graft or inhal inj w CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('929', 'Full thickness burn w skin graft or inhal inj w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('933', 'Extensive burns or full thickness burns w MV 96+ hrs w/o skin graft', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('934', 'Full thickness burn w/o skin grft or inhal inj', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('935', 'Non-extensive burns', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('939', 'O.R. proc w diagnoses of other contact w health services w MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('940', 'O.R. proc w diagnoses of other contact w health services w CC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('941', 'O.R. proc w diagnoses of other contact w health services w/o CC/MCC', 'GENERAL SURGERY');
INSERT INTO "drgs" VALUES ('945', 'Rehabilitation w CC/MCC', 'REHABILITATION');
INSERT INTO "drgs" VALUES ('946', 'Rehabilitation w/o CC/MCC', 'REHABILITATION');
INSERT INTO "drgs" VALUES ('947', 'Signs & symptoms w MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('948', 'Signs & symptoms w/o MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('949', 'Aftercare w CC/MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('950', 'Aftercare w/o CC/MCC', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('951', 'Other factors influencing health status', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('955', 'Craniotomy for multiple significant trauma', 'OTHER');
INSERT INTO "drgs" VALUES ('956', 'Limb reattachment, hip & femur proc for multiple significant trauma', 'OTHER');
INSERT INTO "drgs" VALUES ('957', 'Other O.R. procedures for multiple significant trauma w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('958', 'Other O.R. procedures for multiple significant trauma w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('959', 'Other O.R. procedures for multiple significant trauma w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('963', 'Other multiple significant trauma w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('964', 'Other multiple significant trauma w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('965', 'Other multiple significant trauma w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('969', 'HIV w extensive O.R. procedure w MCC', 'HIV');
INSERT INTO "drgs" VALUES ('970', 'HIV w extensive O.R. procedure w/o MCC', 'HIV');
INSERT INTO "drgs" VALUES ('974', 'HIV w major related condition w MCC', 'HIV');
INSERT INTO "drgs" VALUES ('975', 'HIV w major related condition w CC', 'HIV');
INSERT INTO "drgs" VALUES ('976', 'HIV w major related condition w/o CC/MCC', 'HIV');
INSERT INTO "drgs" VALUES ('977', 'HIV w or w/o other related condition', 'HIV');
INSERT INTO "drgs" VALUES ('981', 'Extensive O.R. procedure unrelated to principal diagnosis w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('982', 'Extensive O.R. procedure unrelated to principal diagnosis w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('983', 'Extensive O.R. procedure unrelated to principal diagnosis w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('984', 'Prostatic O.R. procedure unrelated to principal diagnosis w MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('985', 'Prostatic O.R. procedure unrelated to principal diagnosis w CC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('986', 'Prostatic O.R. procedure unrelated to principal diagnosis w/o CC/MCC', 'UROLOGY');
INSERT INTO "drgs" VALUES ('987', 'Non-extensive O.R. proc unrelated to principal diagnosis w MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('988', 'Non-extensive O.R. proc unrelated to principal diagnosis w CC', 'OTHER');
INSERT INTO "drgs" VALUES ('989', 'Non-extensive O.R. proc unrelated to principal diagnosis w/o CC/MCC', 'OTHER');
INSERT INTO "drgs" VALUES ('998', 'Principal diagnosis invalid as discharge diagnosis', 'GENERAL MEDICINE');
INSERT INTO "drgs" VALUES ('999', 'Ungroupable', 'GENERAL MEDICINE');
COMMIT;

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
--  Table structure for summaries
-- ----------------------------
DROP TABLE IF EXISTS "summaries";
CREATE TABLE "summaries" (
	"id" int4 NOT NULL,
	"summary" varchar
)
WITH (OIDS=FALSE);
ALTER TABLE "summaries" OWNER TO "postgres";

-- ----------------------------
--  Records of summaries
-- ----------------------------
BEGIN;
INSERT INTO "summaries" VALUES ('10', '<h4>Work In Progress</h4>');
INSERT INTO "summaries" VALUES ('11', '<h4>Work In Progress</h4>');
INSERT INTO "summaries" VALUES ('12', '<h4>Work In Progress</h4>');
INSERT INTO "summaries" VALUES ('13', '<h4>Work In Progress</h4>');
INSERT INTO "summaries" VALUES ('14', '<h4>Work In Progress</h4>');
INSERT INTO "summaries" VALUES ('0', '<h4>Work In Progress</h4><p>Welcome CMS to the new site!</p>');
COMMIT;

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

-- ----------------------------
--  Primary key structure for table summaries
-- ----------------------------
ALTER TABLE "summaries" ADD CONSTRAINT "summaries_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

