drop table if exists "QRTZ_JOB_DETAILS" CASCADE;

create table "QRTZ_JOB_DETAILS" (
                                    "SCHED_NAME" varchar(120) not null,
                                    "JOB_NAME" varchar(200) not null,
                                    "JOB_GROUP" varchar(200) not null,
                                    "DESCRIPTION" varchar(250) default null,
                                    "JOB_CLASS_NAME" varchar(250) not null,
                                    "IS_DURABLE" varchar(1) not null,
                                    "IS_NONCONCURRENT" varchar(1) not null,
                                    "IS_UPDATE_DATA" varchar(1) not null,
                                    "REQUESTS_RECOVERY" varchar(1) not null,
                                    "JOB_DATA" bytea,
                                    primary key ("SCHED_NAME", "JOB_NAME", "JOB_GROUP")
);
create index "IDX_QRTZ_J_REQ_RECOVERY" on "QRTZ_JOB_DETAILS"("SCHED_NAME", "REQUESTS_RECOVERY");
create index "IDX_QRTZ_J_GRP" on "QRTZ_JOB_DETAILS"("SCHED_NAME", "JOB_GROUP");

drop table if exists "QRTZ_TRIGGERS" CASCADE ;

create table "QRTZ_TRIGGERS" (
                                 "SCHED_NAME" varchar(120) not null,
                                 "TRIGGER_NAME" varchar(200) not null,
                                 "TRIGGER_GROUP" varchar(200) not null,
                                 "JOB_NAME" varchar(200) not null,
                                 "JOB_GROUP" varchar(200) not null,
                                 "DESCRIPTION" varchar(250) default null,
                                 "NEXT_FIRE_TIME" bigint default null,
                                 "PREV_FIRE_TIME" bigint default null,
                                 "PRIORITY" int default null,
                                 "TRIGGER_STATE" varchar(16) not null,
                                 "TRIGGER_TYPE" varchar(8) not null,
                                 "START_TIME" bigint not null,
                                 "END_TIME" bigint default null,
                                 "CALENDAR_NAME" varchar(200) default null,
                                 "MISFIRE_INSTR" smallint default null,
                                 "JOB_DATA" bytea,
                                 primary key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP"),
                                 constraint "QRTZ_TRIGGERS_ibfk_1" foreign key ("SCHED_NAME", "JOB_NAME", "JOB_GROUP") references "QRTZ_JOB_DETAILS" ("SCHED_NAME", "JOB_NAME", "JOB_GROUP")
);
create index "IDX_QRTZ_T_J" on "QRTZ_TRIGGERS"("SCHED_NAME", "JOB_NAME", "JOB_GROUP");
create index "IDX_QRTZ_T_JG" on "QRTZ_TRIGGERS"("SCHED_NAME", "JOB_GROUP");
create index "IDX_QRTZ_T_C" on "QRTZ_TRIGGERS"("SCHED_NAME", "CALENDAR_NAME");
create index "IDX_QRTZ_T_G" on "QRTZ_TRIGGERS"("SCHED_NAME", "TRIGGER_GROUP");
create index "IDX_QRTZ_T_STATE" on "QRTZ_TRIGGERS"("SCHED_NAME", "TRIGGER_STATE");
create index "IDX_QRTZ_T_N_STATE" on "QRTZ_TRIGGERS"("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP", "TRIGGER_STATE");
create index "IDX_QRTZ_T_N_G_STATE" on "QRTZ_TRIGGERS"("SCHED_NAME", "TRIGGER_GROUP", "TRIGGER_STATE");
create index "IDX_QRTZ_T_NEXT_FIRE_TIME" on "QRTZ_TRIGGERS"("SCHED_NAME", "NEXT_FIRE_TIME");
create index "IDX_QRTZ_T_NFT_ST" on "QRTZ_TRIGGERS"("SCHED_NAME", "TRIGGER_STATE", "NEXT_FIRE_TIME");
create index "IDX_QRTZ_T_NFT_MISFIRE" on "QRTZ_TRIGGERS"("SCHED_NAME", "MISFIRE_INSTR", "NEXT_FIRE_TIME");
create index "IDX_QRTZ_T_NFT_ST_MISFIRE" on "QRTZ_TRIGGERS"("SCHED_NAME", "MISFIRE_INSTR", "NEXT_FIRE_TIME", "TRIGGER_STATE");
create index "IDX_QRTZ_T_NFT_ST_MISFIRE_GRP" on "QRTZ_TRIGGERS"(
                                                                "SCHED_NAME",
                                                                "MISFIRE_INSTR",
                                                                "NEXT_FIRE_TIME",
                                                                "TRIGGER_GROUP",
                                                                "TRIGGER_STATE"
    );

drop table if exists "QRTZ_BLOB_TRIGGERS";


create table "QRTZ_BLOB_TRIGGERS" (
                                      "SCHED_NAME" varchar(120) not null,
                                      "TRIGGER_NAME" varchar(200) not null,
                                      "TRIGGER_GROUP" varchar(200) not null,
                                      "BLOB_DATA" bytea,
                                      primary key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP"),
                                      constraint "QRTZ_BLOB_TRIGGERS_ibfk_1" foreign key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP") references "QRTZ_TRIGGERS" ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP")
);
create index "SCHED_NAME" on "QRTZ_BLOB_TRIGGERS"("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP");

drop table if exists "QRTZ_CALENDARS";
create table "QRTZ_CALENDARS" (
                                  "SCHED_NAME" varchar(120) not null,
                                  "CALENDAR_NAME" varchar(200) not null,
                                  "CALENDAR" bytea not null,
                                  primary key ("SCHED_NAME", "CALENDAR_NAME")
);
drop table if exists "QRTZ_CRON_TRIGGERS";
create table "QRTZ_CRON_TRIGGERS" (
                                      "SCHED_NAME" varchar(120) not null,
                                      "TRIGGER_NAME" varchar(200) not null,
                                      "TRIGGER_GROUP" varchar(200) not null,
                                      "CRON_EXPRESSION" varchar(120) not null,
                                      "TIME_ZONE_ID" varchar(80) default null,
                                      primary key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP"),
                                      constraint "QRTZ_CRON_TRIGGERS_ibfk_1" foreign key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP") references "QRTZ_TRIGGERS" ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP")
);
drop table if exists "QRTZ_FIRED_TRIGGERS";

create table "QRTZ_FIRED_TRIGGERS" (
                                       "SCHED_NAME" varchar(120) not null,
                                       "ENTRY_ID" varchar(200) not null,
                                       "TRIGGER_NAME" varchar(200) not null,
                                       "TRIGGER_GROUP" varchar(200) not null,
                                       "INSTANCE_NAME" varchar(200) not null,
                                       "FIRED_TIME" bigint not null,
                                       "SCHED_TIME" bigint not null,
                                       "PRIORITY" int not null,
                                       "STATE" varchar(16) not null,
                                       "JOB_NAME" varchar(200) default null,
                                       "JOB_GROUP" varchar(200) default null,
                                       "IS_NONCONCURRENT" varchar(1) default null,
                                       "REQUESTS_RECOVERY" varchar(1) default null,
                                       primary key ("SCHED_NAME", "ENTRY_ID")
);
create index "IDX_QRTZ_FT_TRIG_INST_NAME" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "INSTANCE_NAME");
create index "IDX_QRTZ_FT_INST_JOB_REQ_RCVRY" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "INSTANCE_NAME", "REQUESTS_RECOVERY");
create index "IDX_QRTZ_FT_J_G" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "JOB_NAME", "JOB_GROUP");
create index "IDX_QRTZ_FT_JG" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "JOB_GROUP");
create index "IDX_QRTZ_FT_T_G" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP");
create index "IDX_QRTZ_FT_TG" on "QRTZ_FIRED_TRIGGERS"("SCHED_NAME", "TRIGGER_GROUP");

drop table if exists "QRTZ_LOCKS";
create table "QRTZ_LOCKS" (
                              "SCHED_NAME" varchar(120) not null,
                              "LOCK_NAME" varchar(40) not null,
                              primary key ("SCHED_NAME", "LOCK_NAME")
);
drop table if exists "QRTZ_PAUSED_TRIGGER_GRPS";
create table "QRTZ_PAUSED_TRIGGER_GRPS" (
                                            "SCHED_NAME" varchar(120) not null,
                                            "TRIGGER_GROUP" varchar(200) not null,
                                            primary key ("SCHED_NAME", "TRIGGER_GROUP")
);
drop table if exists "QRTZ_SCHEDULER_STATE";
create table "QRTZ_SCHEDULER_STATE" (
                                        "SCHED_NAME" varchar(120) not null,
                                        "INSTANCE_NAME" varchar(200) not null,
                                        "LAST_CHECKIN_TIME" bigint not null,
                                        "CHECKIN_INTERVAL" bigint not null,
                                        primary key ("SCHED_NAME", "INSTANCE_NAME")
);
drop table if exists "QRTZ_SIMPLE_TRIGGERS";
create table "QRTZ_SIMPLE_TRIGGERS" (
                                        "SCHED_NAME" varchar(120) not null,
                                        "TRIGGER_NAME" varchar(200) not null,
                                        "TRIGGER_GROUP" varchar(200) not null,
                                        "REPEAT_COUNT" bigint not null,
                                        "REPEAT_INTERVAL" bigint not null,
                                        "TIMES_TRIGGERED" bigint not null,
                                        primary key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP"),
                                        constraint "QRTZ_SIMPLE_TRIGGERS_ibfk_1" foreign key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP") references "QRTZ_TRIGGERS" ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP")
);
drop table if exists "QRTZ_SIMPROP_TRIGGERS";
create table "QRTZ_SIMPROP_TRIGGERS" (
                                         "SCHED_NAME" varchar(120) not null,
                                         "TRIGGER_NAME" varchar(200) not null,
                                         "TRIGGER_GROUP" varchar(200) not null,
                                         "STR_PROP_1" varchar(512) default null,
                                         "STR_PROP_2" varchar(512) default null,
                                         "STR_PROP_3" varchar(512) default null,
                                         "INT_PROP_1" int default null,
                                         "INT_PROP_2" int default null,
                                         "LONG_PROP_1" bigint default null,
                                         "LONG_PROP_2" bigint default null,
                                         "DEC_PROP_1" decimal(13, 4) default null,
                                         "DEC_PROP_2" decimal(13, 4) default null,
                                         "BOOL_PROP_1" varchar(1) default null,
                                         "BOOL_PROP_2" varchar(1) default null,
                                         primary key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP"),
                                         constraint "QRTZ_SIMPROP_TRIGGERS_ibfk_1" foreign key ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP") references "QRTZ_TRIGGERS" ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP")
);

drop table if exists "dv_actual_values";

create table "dv_actual_values" (
                                    "id" bigint generated by default as identity not null,
                                    "job_execution_id" bigint default null,
                                    "metric_name" varchar(255) default null,
                                    "unique_code" varchar(255) default null,
                                    "actual_value" decimal(20, 4) default null,
                                    "data_time" timestamp default null,
                                    "create_time" timestamp not null default current_timestamp,
                                    "update_time" timestamp not null default current_timestamp,
                                    primary key ("id")
);
comment on table "dv_actual_values" is '规则运行结果实际值';
comment on column "dv_actual_values"."job_execution_id" is '规则作业运行实例ID';comment on column "dv_actual_values"."metric_name" is '规则名称';comment on column "dv_actual_values"."unique_code" is '规则唯一编码';comment on column "dv_actual_values"."actual_value" is '实际值';comment on column "dv_actual_values"."data_time" is '数据时间';comment on column "dv_actual_values"."create_time" is '创建时间';comment on column "dv_actual_values"."update_time" is '更新时间';

drop table if exists "dv_common_task_command";

create table "dv_common_task_command" (
                                          "id" bigint generated by default as identity not null,
                                          "task_id" bigint not null,
                                          "create_time" timestamp not null default current_timestamp,
                                          "update_time" timestamp not null default current_timestamp,
                                          primary key ("id")
);
comment on table "dv_common_task_command" is '元数据抓取任务命令';
comment on column "dv_common_task_command"."task_id" is '通用任务ID';comment on column "dv_common_task_command"."create_time" is '创建时间';comment on column "dv_common_task_command"."update_time" is '更新时间';

drop table if exists "dv_catalog_entity_definition";

create table "dv_catalog_entity_definition" (
                                                "id" bigint generated by default as identity not null,
                                                "uuid" varchar(64) not null,
                                                "name" varchar(255) not null,
                                                "description" varchar(255) default null,
                                                "properties" text,
                                                "super_uuid" varchar(64) not null default '-1',
                                                "create_by" bigint not null,
                                                "create_time" timestamp not null default current_timestamp,
                                                "updated_by" bigint not null,
                                                "update_time" timestamp not null default current_timestamp,
                                                primary key ("id"),
                                                constraint "dv_catalog_entity_definition_un" unique ("uuid")
);
comment on table "dv_catalog_entity_definition" is '实体定义';
comment on column "dv_catalog_entity_definition"."uuid" is '实体定义UUID';comment on column "dv_catalog_entity_definition"."name" is '实体定义的名字';comment on column "dv_catalog_entity_definition"."description" is '描述';comment on column "dv_catalog_entity_definition"."properties" is '实体参数，用List存储 例如 [{"name":"id","type":"string"}]';comment on column "dv_catalog_entity_definition"."super_uuid" is '父类ID';comment on column "dv_catalog_entity_definition"."create_by" is '创建用户ID';comment on column "dv_catalog_entity_definition"."create_time" is '创建时间';comment on column "dv_catalog_entity_definition"."updated_by" is '更新用户ID';comment on column "dv_catalog_entity_definition"."update_time" is '更新时间';

drop table if exists "dv_catalog_entity_instance";

create table "dv_catalog_entity_instance" (
                                              "id" bigint generated by default as identity not null,
                                              "uuid" varchar(64) not null,
                                              "type" varchar(127) not null,
                                              "datasource_id" bigint not null,
                                              "fully_qualified_name" varchar(255) not null,
                                              "display_name" varchar(255) not null,
                                              "description" varchar(1024) default null,
                                              "properties" text,
                                              "owner" varchar(255) default null,
                                              "version" varchar(64) not null default '1.0',
                                              "status" varchar(255) default 'active',
                                              "create_time" timestamp not null default current_timestamp,
                                              "update_time" timestamp not null default current_timestamp,
                                              "update_by" bigint not null,
                                              primary key ("id"),
                                              constraint "uuid_un" unique ("uuid"),
                                              constraint "datasource_fqn_status_un" unique ("datasource_id", "fully_qualified_name", "status")
);
comment on table "dv_catalog_entity_instance" is '实体实例';
comment on column "dv_catalog_entity_instance"."uuid" is '实体实例UUID';comment on column "dv_catalog_entity_instance"."type" is '实体类型';comment on column "dv_catalog_entity_instance"."datasource_id" is '数据源ID';comment on column "dv_catalog_entity_instance"."fully_qualified_name" is '全限定名';comment on column "dv_catalog_entity_instance"."display_name" is '展示名字';comment on column "dv_catalog_entity_instance"."description" is '描述';comment on column "dv_catalog_entity_instance"."properties" is '其他参数，用map存储';comment on column "dv_catalog_entity_instance"."owner" is '拥有者';comment on column "dv_catalog_entity_instance"."version" is '版本';comment on column "dv_catalog_entity_instance"."status" is '实体状态：启用:active, 删除:deleted开头的随机数';comment on column "dv_catalog_entity_instance"."create_time" is '创建时间';comment on column "dv_catalog_entity_instance"."update_time" is '更新时间';comment on column "dv_catalog_entity_instance"."update_by" is '更新用户ID';
create index "full_idx_display_name_description" on "dv_catalog_entity_instance"("display_name", "description");

drop table if exists "dv_catalog_entity_metric_job_rel";

create table "dv_catalog_entity_metric_job_rel" (
                                                    "id" bigint generated by default as identity not null,
                                                    "entity_uuid" varchar(64) not null,
                                                    "metric_job_id" bigint not null,
                                                    "metric_job_type" varchar(255) not null,
                                                    "create_by" bigint not null,
                                                    "create_time" timestamp not null default current_timestamp,
                                                    "update_by" bigint not null,
                                                    "update_time" timestamp not null default current_timestamp,
                                                    primary key ("id"),
                                                    constraint "dv_catalog_entity_metric_rel_un" unique ("entity_uuid", "metric_job_id", "metric_job_type")
);
comment on table "dv_catalog_entity_metric_job_rel" is '实体和规则作业关联关系';
comment on column "dv_catalog_entity_metric_job_rel"."entity_uuid" is '实体UUID';comment on column "dv_catalog_entity_metric_job_rel"."metric_job_id" is '规则作业ID';comment on column "dv_catalog_entity_metric_job_rel"."metric_job_type" is '规则作业类型';comment on column "dv_catalog_entity_metric_job_rel"."create_by" is '创建用户ID';comment on column "dv_catalog_entity_metric_job_rel"."create_time" is '创建时间';comment on column "dv_catalog_entity_metric_job_rel"."update_by" is '更新用户ID';comment on column "dv_catalog_entity_metric_job_rel"."update_time" is '更新时间';

drop table if exists "dv_catalog_entity_profile";

create table "dv_catalog_entity_profile" (
                                             "id" bigint generated by default as identity not null,
                                             "entity_uuid" varchar(64) not null,
                                             "metric_name" varchar(255) not null,
                                             "actual_value" text not null,
                                             "actual_value_type" varchar(255) default null,
                                             "data_date" varchar(255) default null,
                                             "update_time" timestamp not null default current_timestamp,
                                             primary key ("id"),
                                             constraint "dv_catalog_entity_profile_un" unique ("entity_uuid", "metric_name", "data_date")
);
comment on table "dv_catalog_entity_profile" is '实体概要信息';
comment on column "dv_catalog_entity_profile"."entity_uuid" is '实体UUID';comment on column "dv_catalog_entity_profile"."metric_name" is '规则名称';comment on column "dv_catalog_entity_profile"."actual_value" is '实际值';comment on column "dv_catalog_entity_profile"."actual_value_type" is '实际值类型';comment on column "dv_catalog_entity_profile"."data_date" is '数据日期';comment on column "dv_catalog_entity_profile"."update_time" is '更新时间';

drop table if exists "dv_catalog_entity_rel";

create table "dv_catalog_entity_rel" (
                                         "id" bigint generated by default as identity not null,
                                         "entity1_uuid" varchar(64) not null,
                                         "entity2_uuid" varchar(64) not null,
                                         "type" varchar(64) not null,
                                         "update_time" timestamp not null default current_timestamp,
                                         "update_by" bigint not null,
                                         primary key ("id"),
                                         constraint "dv_catalog_entity_rel_un" unique ("entity1_uuid", "entity2_uuid", "type")
);
comment on table "dv_catalog_entity_rel" is '实体关联关系';
comment on column "dv_catalog_entity_rel"."entity1_uuid" is '实体1UUID';comment on column "dv_catalog_entity_rel"."entity2_uuid" is '实体2UUID';comment on column "dv_catalog_entity_rel"."type" is '关系类型，upstream-2是1上游，downstream-2是1下游, child-2是1的子类，parent-2是1的父类';comment on column "dv_catalog_entity_rel"."update_time" is '更新时间';comment on column "dv_catalog_entity_rel"."update_by" is '更新用户ID';
create index "idx_dv_catalog_entity_rel_uuid" on "dv_catalog_entity_rel"("entity2_uuid");

drop table if exists "dv_catalog_entity_tag_rel";

create table "dv_catalog_entity_tag_rel" (
                                             "id" bigint generated by default as identity not null,
                                             "entity_uuid" varchar(64) not null,
                                             "tag_uuid" varchar(64) not null,
                                             "create_by" bigint not null,
                                             "create_time" timestamp not null default current_timestamp,
                                             "update_by" bigint not null,
                                             "update_time" timestamp not null default current_timestamp,
                                             primary key ("id"),
                                             constraint "dv_catalog_entity_tag_rel_un" unique ("entity_uuid", "tag_uuid")
);
comment on table "dv_catalog_entity_tag_rel" is '实体标签关联关系';
comment on column "dv_catalog_entity_tag_rel"."entity_uuid" is '实体UUID';comment on column "dv_catalog_entity_tag_rel"."tag_uuid" is '标签UUID';comment on column "dv_catalog_entity_tag_rel"."create_by" is '创建用户ID';comment on column "dv_catalog_entity_tag_rel"."create_time" is '创建时间';comment on column "dv_catalog_entity_tag_rel"."update_by" is '更新用户ID';comment on column "dv_catalog_entity_tag_rel"."update_time" is '更新时间';
create index "idx_dv_catalog_entity_tag_rel_uuid" on "dv_catalog_entity_tag_rel"("tag_uuid");

drop table if exists "dv_catalog_schema_change";

create table "dv_catalog_schema_change" (
                                            "id" bigint generated by default as identity not null,
                                            "parent_uuid" varchar(64) not null,
                                            "entity_uuid" varchar(64) not null,
                                            "change_type" varchar(64) not null,
                                            "database_name" varchar(255) default null,
                                            "table_name" varchar(255) default null,
                                            "column_name" varchar(255) default null,
                                            "change_before" text default null,
                                            "change_after" text default null,
                                            "update_by" bigint not null,
                                            "update_time" timestamp not null default current_timestamp,
                                            primary key ("id")
);
comment on table "dv_catalog_schema_change" is 'Schema变更记录表';
comment on column "dv_catalog_schema_change"."parent_uuid" is '父实体UUID';comment on column "dv_catalog_schema_change"."entity_uuid" is '实体UUID';comment on column "dv_catalog_schema_change"."change_type" is '变更类型';comment on column "dv_catalog_schema_change"."database_name" is '数据库';comment on column "dv_catalog_schema_change"."table_name" is '表';comment on column "dv_catalog_schema_change"."column_name" is '列';comment on column "dv_catalog_schema_change"."change_before" is '变更前';comment on column "dv_catalog_schema_change"."change_after" is '变更后';comment on column "dv_catalog_schema_change"."update_by" is '更新用户ID';comment on column "dv_catalog_schema_change"."update_time" is '更新时间';

drop table if exists "dv_catalog_tag";

create table "dv_catalog_tag" (
                                  "id" bigint generated by default as identity not null,
                                  "uuid" varchar(64) not null,
                                  "category_uuid" varchar(64) not null,
                                  "name" varchar(256) not null,
                                  "create_by" bigint not null,
                                  "create_time" timestamp not null default current_timestamp,
                                  "update_by" bigint not null,
                                  "update_time" timestamp not null default current_timestamp,
                                  primary key ("id"),
                                  constraint "cu_uuid_name_un" unique ("uuid", "category_uuid", "name")
);
comment on table "dv_catalog_tag" is '标签';
comment on column "dv_catalog_tag"."uuid" is '标签UUID';comment on column "dv_catalog_tag"."category_uuid" is '标签分类UUID';comment on column "dv_catalog_tag"."name" is '标签名称';comment on column "dv_catalog_tag"."create_by" is '创建用户ID';comment on column "dv_catalog_tag"."create_time" is '创建时间';comment on column "dv_catalog_tag"."update_by" is '更新用户ID';comment on column "dv_catalog_tag"."update_time" is '更新时间';

drop table if exists "dv_catalog_tag_category";

create table "dv_catalog_tag_category" (
                                           "id" bigint generated by default as identity not null,
                                           "uuid" varchar(64) not null,
                                           "name" varchar(256) not null,
                                           "workspace_id" bigint not null,
                                           "create_by" bigint not null,
                                           "create_time" timestamp not null default current_timestamp,
                                           "update_by" bigint not null,
                                           "update_time" timestamp not null default current_timestamp,
                                           primary key ("id"),
                                           constraint "uuid_name_un" unique ("uuid", "name")
);
comment on table "dv_catalog_tag_category" is '标签分类';
comment on column "dv_catalog_tag_category"."uuid" is '标签分类UUID';comment on column "dv_catalog_tag_category"."name" is '标签分类名称';comment on column "dv_catalog_tag_category"."workspace_id" is '工作空间ID';comment on column "dv_catalog_tag_category"."create_by" is '创建用户ID';comment on column "dv_catalog_tag_category"."create_time" is '创建时间';comment on column "dv_catalog_tag_category"."update_by" is '更新用户ID';comment on column "dv_catalog_tag_category"."update_time" is '更新时间';

drop table if exists "dv_common_task";

create table "dv_common_task" (
                                  "id" bigint generated by default as identity not null,
                                  "task_type" varchar(128) default null,
                                  "type" varchar(128) default null,
                                  "datasource_id" bigint not null default '-1',
                                  "database_name" varchar(128) default null,
                                  "table_name" varchar(128) default null,
                                  "status" int default null,
                                  "parameter" text,
                                  "execute_host" varchar(255) default null,
                                  "submit_time" timestamp default null,
                                  "schedule_time" timestamp default null,
                                  "start_time" timestamp default null,
                                  "end_time" timestamp default null,
                                  "create_time" timestamp not null default current_timestamp,
                                  "update_time" timestamp not null default current_timestamp,
                                  primary key ("id")
);
comment on table "dv_common_task" is '元数据抓取任务';
comment on column "dv_common_task"."task_type" is '任务类型';comment on column "dv_common_task"."type" is '粒度类型';comment on column "dv_common_task"."datasource_id" is '数据源ID';comment on column "dv_common_task"."database_name" is '数据库';comment on column "dv_common_task"."table_name" is '表';comment on column "dv_common_task"."status" is '任务状态';comment on column "dv_common_task"."parameter" is '任务参数';comment on column "dv_common_task"."execute_host" is '执行任务的主机';comment on column "dv_common_task"."submit_time" is '提交时间';comment on column "dv_common_task"."schedule_time" is '调度时间';comment on column "dv_common_task"."start_time" is '开始时间';comment on column "dv_common_task"."end_time" is '结束时间';comment on column "dv_common_task"."create_time" is '创建时间';comment on column "dv_common_task"."update_time" is '更新时间';

drop table if exists "dv_common_task_schedule";

create table "dv_common_task_schedule" (
                                           "id" bigint generated by default as identity not null,
                                           "task_type" varchar(128) default null,
                                           "type" varchar(255) not null,
                                           "param" text,
                                           "datasource_id" bigint not null,
                                           "cron_expression" varchar(255) default null,
                                           "status" smallint default null,
                                           "start_time" timestamp default null,
                                           "end_time" timestamp default null,
                                           "create_by" bigint not null,
                                           "create_time" timestamp not null default current_timestamp,
                                           "update_by" bigint not null,
                                           "update_time" timestamp not null default current_timestamp,
                                           primary key ("id")
);
comment on table "dv_common_task_schedule" is '元数据抓取任务调度';
comment on column "dv_common_task_schedule"."task_type" is '任务类型';comment on column "dv_common_task_schedule"."type" is '调度类型';comment on column "dv_common_task_schedule"."param" is '调度参数';comment on column "dv_common_task_schedule"."datasource_id" is '数据源ID';comment on column "dv_common_task_schedule"."cron_expression" is 'CRON表达式';comment on column "dv_common_task_schedule"."status" is '调度状态';comment on column "dv_common_task_schedule"."start_time" is '开始时间';comment on column "dv_common_task_schedule"."end_time" is '结束时间';comment on column "dv_common_task_schedule"."create_by" is '创建用户ID';comment on column "dv_common_task_schedule"."create_time" is '创建时间';comment on column "dv_common_task_schedule"."update_by" is '更新用户ID';comment on column "dv_common_task_schedule"."update_time" is '更新时间';

drop table if exists "dv_command";

create table "dv_command" (
                              "id" bigint generated by default as identity not null,
                              "type" smallint not null default '0',
                              "parameter" text,
                              "execute_host" varchar(255),
                              "job_execution_id" bigint not null,
                              "priority" int default null,
                              "create_time" timestamp not null default current_timestamp,
                              "update_time" timestamp not null default current_timestamp,
                              primary key ("id")
);
comment on table "dv_command" is '规则执行命令';
comment on column "dv_command"."type" is 'Command type: 0 start task, 1 stop task';comment on column "dv_command"."parameter" is 'json command parameters';comment on column "dv_command"."execute_host" is 'job execute host';comment on column "dv_command"."job_execution_id" is 'task id';comment on column "dv_command"."priority" is 'process instance priority: 0 Highest,1 High,2 Medium,3 Low,4 Lowest';comment on column "dv_command"."create_time" is 'create time';comment on column "dv_command"."update_time" is 'update time';

drop table if exists "dv_datasource";

create table "dv_datasource" (
                                 "id" bigint generated by default as identity not null,
                                 "uuid" varchar(64) not null,
                                 "name" varchar(255) not null,
                                 "type" varchar(255) not null,
                                 "param" text not null,
                                 "param_code" text null,
                                 "workspace_id" bigint not null,
                                 "create_by" bigint not null,
                                 "create_time" timestamp not null default current_timestamp,
                                 "update_by" bigint not null,
                                 "update_time" timestamp not null default current_timestamp,
                                 primary key ("id"),
                                 constraint "datasource_un" unique ("name")
);
comment on table "dv_datasource" is '数据源';
comment on column "dv_datasource"."uuid" is '数据源UUID';comment on column "dv_datasource"."name" is '数据源名称';comment on column "dv_datasource"."type" is '数据源类型';comment on column "dv_datasource"."param" is '数据源参数';comment on column "dv_datasource"."param_code" is '数据源参数MD5值';comment on column "dv_datasource"."workspace_id" is '工作空间ID';comment on column "dv_datasource"."create_by" is '创建用户ID';comment on column "dv_datasource"."create_time" is '创建时间';comment on column "dv_datasource"."update_by" is '更新用户ID';comment on column "dv_datasource"."update_time" is '更新时间';

drop table if exists "dv_env";

create table "dv_env" (
                          "id" bigint generated by default as identity not null,
                          "name" varchar(255) not null,
                          "env" text not null,
                          "workspace_id" bigint not null,
                          "create_by" bigint not null,
                          "create_time" timestamp not null default current_timestamp,
                          "update_by" bigint not null,
                          "update_time" timestamp not null default current_timestamp,
                          primary key ("id"),
                          constraint "env_name" unique ("name")
);
comment on table "dv_env" is '运行环境配置信息';
comment on column "dv_env"."name" is '服务器环境配置';comment on column "dv_env"."env" is '数据源UUID';comment on column "dv_env"."workspace_id" is '工作空间ID';comment on column "dv_env"."create_by" is '创建用户ID';comment on column "dv_env"."create_time" is '创建时间';comment on column "dv_env"."update_by" is '更新用户ID';comment on column "dv_env"."update_time" is '更新时间';

drop table if exists "dv_access_token";

create table "dv_access_token" (
                                   "id" bigint generated by default as identity not null,
                                   "workspace_id" bigint not null,
                                   "user_id" bigint not null,
                                   "token" varchar(1024) not null,
                                   "expire_time" timestamp not null,
                                   "create_by" bigint not null,
                                   "create_time" timestamp not null default current_timestamp,
                                   "update_by" bigint not null,
                                   "update_time" timestamp not null default current_timestamp,
                                   primary key ("id")
);
comment on table "dv_access_token" is 'token 管理';
comment on column "dv_access_token"."workspace_id" is '工作空间ID';comment on column "dv_access_token"."user_id" is '用户ID';comment on column "dv_access_token"."token" is 'token';comment on column "dv_access_token"."expire_time" is '过期时间';comment on column "dv_access_token"."create_by" is '创建用户ID';comment on column "dv_access_token"."create_time" is '创建时间';comment on column "dv_access_token"."update_by" is '更新用户ID';comment on column "dv_access_token"."update_time" is '更新时间';

drop table if exists "dv_error_data_storage";

create table "dv_error_data_storage" (
                                         "id" bigint generated by default as identity not null,
                                         "name" varchar(255) not null,
                                         "type" varchar(255) not null,
                                         "param" text not null,
                                         "workspace_id" bigint not null,
                                         "create_by" bigint not null,
                                         "create_time" timestamp not null default current_timestamp,
                                         "update_by" bigint not null,
                                         "update_time" timestamp not null default current_timestamp,
                                         primary key ("id"),
                                         constraint "name_wp_un" unique ("name", "workspace_id")
);
comment on table "dv_error_data_storage" is '错误数据存储';
comment on column "dv_error_data_storage"."name" is '存储名称';comment on column "dv_error_data_storage"."type" is '存储类型';comment on column "dv_error_data_storage"."param" is '存储参数';comment on column "dv_error_data_storage"."workspace_id" is '工作空间ID';comment on column "dv_error_data_storage"."create_by" is '创建用户ID';comment on column "dv_error_data_storage"."create_time" is '创建时间';comment on column "dv_error_data_storage"."update_by" is '更新用户ID';comment on column "dv_error_data_storage"."update_time" is '更新时间';

drop table if exists "dv_issue";

create table "dv_issue" (
                            "id" bigint generated by default as identity not null,
                            "title" varchar(1024) default null,
                            "content" text not null,
                            "status" varchar(255) not null,
                            "create_time" timestamp not null default current_timestamp,
                            "update_time" timestamp not null default current_timestamp,
                            primary key ("id")
);
comment on table "dv_issue" is '告警信息';
comment on column "dv_issue"."title" is '告警标题';comment on column "dv_issue"."content" is '告警内容';comment on column "dv_issue"."status" is 'good / bad alert';comment on column "dv_issue"."create_time" is '创建时间';comment on column "dv_issue"."update_time" is '更新时间';

drop table if exists "dv_job";

create table "dv_job" (
                          "id" bigint generated by default as identity not null,
                          "name" varchar(255) default null,
                          "type" int not null default '0',
                          "datasource_id" bigint not null,
                          "datasource_id_2" bigint default null,
                          "schema_name" varchar(128) default null,
                          "table_name" varchar(128) default null,
                          "column_name" varchar(128) default null,
                          "selected_column" text,
                          "metric_type" varchar(255) default null,
                          "execute_platform_type" varchar(128) default null,
                          "execute_platform_parameter" text,
                          "engine_type" varchar(128) default null,
                          "engine_parameter" text,
                          "error_data_storage_id" bigint default null,
                          "is_error_data_output_to_datasource" smallint default '0',
                          "error_data_output_to_datasource_database" varchar(255) default null,
                          "parameter" text,
                          "retry_times" int default null,
                          "retry_interval" int default null,
                          "timeout" int default null,
                          "timeout_strategy" int default null,
                          "pre_sql" text default null,
                          "post_sql" text default null,
                          "tenant_code" bigint default null,
                          "env" bigint default null,
                          "create_by" bigint not null,
                          "create_time" timestamp not null default current_timestamp,
                          "update_by" bigint not null,
                          "update_time" timestamp not null default current_timestamp,
                          primary key ("id"),
                          constraint "unique_name" unique (
                                                           "name",
                                                           "datasource_id",
                                                           "schema_name",
                                                           "table_name",
                                                           "column_name"
                              )
);
comment on table "dv_job" is '规则作业';
comment on column "dv_job"."name" is '作业名称';comment on column "dv_job"."type" is '作业类型';comment on column "dv_job"."datasource_id" is '数据源ID';comment on column "dv_job"."datasource_id_2" is '数据源2ID';comment on column "dv_job"."schema_name" is '数据库名';comment on column "dv_job"."table_name" is '表名';comment on column "dv_job"."column_name" is '列名';comment on column "dv_job"."selected_column" is 'DataProfile 选中的列';comment on column "dv_job"."metric_type" is '规则类型';comment on column "dv_job"."execute_platform_type" is '运行平台类型';comment on column "dv_job"."execute_platform_parameter" is '运行平台参数';comment on column "dv_job"."engine_type" is '运行引擎类型';comment on column "dv_job"."engine_parameter" is '运行引擎参数';comment on column "dv_job"."error_data_storage_id" is '错误数据存储ID';comment on column "dv_job"."is_error_data_output_to_datasource" is '错误数据是否输出至数据源';comment on column "dv_job"."error_data_output_to_datasource_database" is '错误数据存储数据库';comment on column "dv_job"."parameter" is '作业参数';comment on column "dv_job"."retry_times" is '重试次数';comment on column "dv_job"."retry_interval" is '重试间隔';comment on column "dv_job"."timeout" is '任务超时时间';comment on column "dv_job"."timeout_strategy" is '超时策略';comment on column "dv_job"."pre_sql" is '前置脚本';comment on column "dv_job"."post_sql" is '后置脚本';comment on column "dv_job"."tenant_code" is '代理用户';comment on column "dv_job"."env" is '环境配置';comment on column "dv_job"."create_by" is '创建用户ID';comment on column "dv_job"."create_time" is '创建时间';comment on column "dv_job"."update_by" is '更新用户ID';comment on column "dv_job"."update_time" is '更新时间';

drop table if exists "dv_job_execution";

create table "dv_job_execution" (
                                    "id" bigint generated by default as identity not null,
                                    "name" varchar(255) not null,
                                    "job_id" bigint not null default '-1',
                                    "job_type" int not null default '0',
                                    "schema_name" varchar(128) default null,
                                    "table_name" varchar(128) default null,
                                    "column_name" varchar(128) default null,
                                    "metric_type" varchar(255) default null,
                                    "datasource_id" bigint not null default '-1',
                                    "execute_platform_type" varchar(128) default null,
                                    "execute_platform_parameter" text,
                                    "engine_type" varchar(128) default null,
                                    "engine_parameter" text,
                                    "error_data_storage_type" varchar(128) default null,
                                    "error_data_storage_parameter" text,
                                    "error_data_file_name" varchar(255) default null,
                                    "parameter" text not null,
                                    "status" int default null,
                                    "retry_times" int default null,
                                    "retry_interval" int default null,
                                    "timeout" int default null,
                                    "timeout_strategy" int default null,
                                    "pre_sql" text default null,
                                    "post_sql" text default null,
                                    "tenant_code" varchar(255) default null,
                                    "execute_host" varchar(255) default null,
                                    "application_id" varchar(255) default null,
                                    "application_tag" varchar(255) default null,
                                    "process_id" int default null,
                                    "execute_file_path" varchar(255) default null,
                                    "log_path" varchar(255) default null,
                                    "env" text,
                                    "submit_time" timestamp default null,
                                    "schedule_time" timestamp default null,
                                    "start_time" timestamp default null,
                                    "end_time" timestamp default null,
                                    "create_time" timestamp not null default current_timestamp,
                                    "update_time" timestamp not null default current_timestamp,
                                    primary key ("id")
);
comment on table "dv_job_execution" is '规则作业运行实例';
comment on column "dv_job_execution"."name" is '作业运行实例名称';comment on column "dv_job_execution"."job_id" is '作业ID';comment on column "dv_job_execution"."job_type" is '作业类型';comment on column "dv_job_execution"."schema_name" is '数据库名';comment on column "dv_job_execution"."table_name" is '表名';comment on column "dv_job_execution"."column_name" is '列名';comment on column "dv_job_execution"."metric_type" is '规则类型';comment on column "dv_job_execution"."datasource_id" is '数据源ID';comment on column "dv_job_execution"."execute_platform_type" is '运行平台类型';comment on column "dv_job_execution"."execute_platform_parameter" is '运行平台参数';comment on column "dv_job_execution"."engine_type" is '运行引擎类型';comment on column "dv_job_execution"."engine_parameter" is '运行引擎参数';comment on column "dv_job_execution"."error_data_storage_type" is '错误数据存储类型';comment on column "dv_job_execution"."error_data_storage_parameter" is '错误数据存储参数';comment on column "dv_job_execution"."error_data_file_name" is '错误数据存储文件名';comment on column "dv_job_execution"."parameter" is '作业运行参数';comment on column "dv_job_execution"."status" is '作业运行状态';comment on column "dv_job_execution"."retry_times" is '重试次数';comment on column "dv_job_execution"."retry_interval" is '重试间隔';comment on column "dv_job_execution"."timeout" is '超时时间';comment on column "dv_job_execution"."timeout_strategy" is '超时处理策略';comment on column "dv_job_execution"."pre_sql" is '前置脚本';comment on column "dv_job_execution"."post_sql" is '后置脚本';comment on column "dv_job_execution"."tenant_code" is '代理用户';comment on column "dv_job_execution"."execute_host" is '执行任务的主机';comment on column "dv_job_execution"."application_id" is 'yarn application id';comment on column "dv_job_execution"."application_tag" is 'yarn application tags';comment on column "dv_job_execution"."process_id" is 'process id';comment on column "dv_job_execution"."execute_file_path" is 'execute file path';comment on column "dv_job_execution"."log_path" is 'log path';comment on column "dv_job_execution"."env" is '运行环境的配置信息';comment on column "dv_job_execution"."submit_time" is '提交时间';comment on column "dv_job_execution"."schedule_time" is '调度时间';comment on column "dv_job_execution"."start_time" is '开始时间';comment on column "dv_job_execution"."end_time" is '结束时间';comment on column "dv_job_execution"."create_time" is '创建时间';comment on column "dv_job_execution"."update_time" is '更新时间';

drop table if exists "dv_job_execution_result";

create table "dv_job_execution_result" (
                                           "id" bigint generated by default as identity not null,
                                           "job_execution_id" bigint default null,
                                           "metric_unique_key" varchar(255) default null,
                                           "metric_type" varchar(255) default null,
                                           "metric_dimension" varchar(255) default null,
                                           "metric_name" varchar(255) default null,
                                           "database_name" varchar(128) default null,
                                           "table_name" varchar(128) default null,
                                           "column_name" varchar(128) default null,
                                           "actual_value" decimal(20, 4) default null,
                                           "expected_value" decimal(20, 4) default null,
                                           "expected_type" varchar(255) default null,
                                           "result_formula" varchar(255) default null,
                                           "operator" varchar(255) default null,
                                           "threshold" decimal(20, 4) default null,
                                           "score" decimal(20, 4) default 0,
                                           "state" int not null default '0',
                                           "create_time" timestamp not null default current_timestamp,
                                           "update_time" timestamp not null default current_timestamp,
                                           primary key ("id"),
                                           constraint "execution_id_un" unique ("job_execution_id", "metric_unique_key")
);
comment on table "dv_job_execution_result" is '规则作业运行结果';
comment on column "dv_job_execution_result"."job_execution_id" is '任务执行实例ID';comment on column "dv_job_execution_result"."metric_unique_key" is '规则运行唯一标识';comment on column "dv_job_execution_result"."metric_type" is '规则类型';comment on column "dv_job_execution_result"."metric_dimension" is '规则维度';comment on column "dv_job_execution_result"."metric_name" is '规则名称';comment on column "dv_job_execution_result"."database_name" is '数据库名称';comment on column "dv_job_execution_result"."table_name" is '表名称';comment on column "dv_job_execution_result"."column_name" is '列名称';comment on column "dv_job_execution_result"."actual_value" is '实际值';comment on column "dv_job_execution_result"."expected_value" is '期望值';comment on column "dv_job_execution_result"."expected_type" is '期望值类型';comment on column "dv_job_execution_result"."result_formula" is '计算结果公式';comment on column "dv_job_execution_result"."operator" is '比较符';comment on column "dv_job_execution_result"."threshold" is '阈值';comment on column "dv_job_execution_result"."score" is '质量评分';comment on column "dv_job_execution_result"."state" is '结果 1:success/2:fail';comment on column "dv_job_execution_result"."create_time" is '创建时间';comment on column "dv_job_execution_result"."update_time" is '更新时间';

drop table if exists "dv_job_quality_report";

create table "dv_job_quality_report" (
                                         "id" bigint generated by default as identity not null,
                                         "datasource_id" bigint default null,
                                         "entity_level" varchar(128) default null,
                                         "database_name" varchar(128) default null,
                                         "table_name" varchar(128) default null,
                                         "column_name" varchar(128) default null,
                                         "score" decimal(20, 4) default null,
                                         "report_date" date default null,
                                         "create_time" timestamp not null default current_timestamp,
                                         "update_time" timestamp not null default current_timestamp,
                                         primary key ("id")
);
comment on table "dv_job_quality_report" is '数据质量报告';
comment on column "dv_job_quality_report"."datasource_id" is '数据源ID';comment on column "dv_job_quality_report"."entity_level" is '实体级别：DATASOURCE，DATABASE，TABLE，COLUMN';comment on column "dv_job_quality_report"."database_name" is '数据库名称';comment on column "dv_job_quality_report"."table_name" is '表名称';comment on column "dv_job_quality_report"."column_name" is '列名称';comment on column "dv_job_quality_report"."score" is '质量评分';comment on column "dv_job_quality_report"."report_date" is '报告日期';comment on column "dv_job_quality_report"."create_time" is '创建时间';comment on column "dv_job_quality_report"."update_time" is '更新时间';

drop table if exists "dv_job_execution_result_report_rel";

create table "dv_job_execution_result_report_rel" (
                                                      "id" bigint generated by default as identity not null,
                                                      "quality_report_id" bigint not null,
                                                      "job_execution_result_id" bigint not null,
                                                      "create_time" timestamp not null default current_timestamp,
                                                      "update_time" timestamp not null default current_timestamp,
                                                      primary key ("id"),
                                                      constraint "dv_execution_report_rel_un" unique ("job_execution_result_id", "quality_report_id")
);
comment on table "dv_job_execution_result_report_rel" is '质量报告和执行结果关联关系';
comment on column "dv_job_execution_result_report_rel"."quality_report_id" is '质量报告ID';comment on column "dv_job_execution_result_report_rel"."job_execution_result_id" is '作业执行结果ID';comment on column "dv_job_execution_result_report_rel"."create_time" is '创建时间';comment on column "dv_job_execution_result_report_rel"."update_time" is '更新时间';

drop table if exists "dv_job_issue_rel";

create table "dv_job_issue_rel" (
                                    "id" bigint generated by default as identity not null,
                                    "job_id" bigint not null,
                                    "issue_id" bigint not null,
                                    "create_time" timestamp not null default current_timestamp,
                                    "update_time" timestamp not null default current_timestamp,
                                    primary key ("id"),
                                    constraint "dv_job_issue_rel_un" unique ("job_id", "issue_id")
);
comment on table "dv_job_issue_rel" is '实体和告警信息关联关系';
comment on column "dv_job_issue_rel"."job_id" is '规则ID';comment on column "dv_job_issue_rel"."issue_id" is 'ISSUE ID';comment on column "dv_job_issue_rel"."create_time" is '创建时间';comment on column "dv_job_issue_rel"."update_time" is '更新时间';
create index "idx_dv_job_issue_rel_uuid" on "dv_job_issue_rel"("issue_id");

drop table if exists "dv_job_schedule";

create table "dv_job_schedule" (
                                   "id" bigint generated by default as identity not null,
                                   "type" varchar(255) not null,
                                   "param" text,
                                   "job_id" bigint not null,
                                   "cron_expression" varchar(255) default null,
                                   "status" smallint default null,
                                   "start_time" timestamp default null,
                                   "end_time" timestamp default null,
                                   "create_by" bigint not null,
                                   "create_time" timestamp not null default current_timestamp,
                                   "update_by" bigint not null,
                                   "update_time" timestamp not null default current_timestamp,
                                   primary key ("id")
);
comment on table "dv_job_schedule" is '规则作业调度';
comment on column "dv_job_schedule"."type" is '作业调度类型';comment on column "dv_job_schedule"."param" is '调度参数';comment on column "dv_job_schedule"."job_id" is '作业ID';comment on column "dv_job_schedule"."cron_expression" is 'CRON 表达式';comment on column "dv_job_schedule"."status" is '状态';comment on column "dv_job_schedule"."start_time" is '开始时间';comment on column "dv_job_schedule"."end_time" is '结束时间';comment on column "dv_job_schedule"."create_by" is '创建用户ID';comment on column "dv_job_schedule"."create_time" is '创建时间';comment on column "dv_job_schedule"."update_by" is '更新用户ID';comment on column "dv_job_schedule"."update_time" is '更新时间';

drop table if exists "dv_server";

create table "dv_server" (
                             "id" int generated by default as identity not null,
                             "host" varchar(255) not null,
                             "port" int not null,
                             "create_time" timestamp not null default current_timestamp,
                             "update_time" timestamp not null default current_timestamp,
                             primary key ("id"),
                             constraint "server_un" unique ("host", "port")
);
comment on table "dv_server" is '集群节点信息';
comment on column "dv_server"."host" is '机器IP地址';comment on column "dv_server"."port" is '端口';comment on column "dv_server"."create_time" is '创建时间';comment on column "dv_server"."update_time" is '更新时间';

drop table if exists "dv_registry_lock";

create table "dv_registry_lock" (
                                    "id" bigint generated by default as identity not null,
                                    "lock_key" varchar(256) not null,
                                    "lock_owner" varchar(256) not null,
                                    "create_time" timestamp not null default current_timestamp,
                                    "update_time" timestamp not null default current_timestamp,
                                    primary key ("id"),
                                    constraint "uniq_lock_key" unique ("lock_key")
);
comment on table "dv_registry_lock" is '注册锁';
comment on column "dv_registry_lock"."id" is 'primary key';comment on column "dv_registry_lock"."lock_key" is 'lock path';comment on column "dv_registry_lock"."lock_owner" is 'lock owner, ip:port';comment on column "dv_registry_lock"."create_time" is 'create time';comment on column "dv_registry_lock"."update_time" is 'update time';
create index "idx_upt" on "dv_registry_lock"("update_time");

drop table if exists "dv_sla";

create table "dv_sla" (
                          "id" bigint generated by default as identity not null,
                          "workspace_id" bigint not null,
                          "name" varchar(255) not null,
                          "description" varchar(255) not null,
                          "create_by" bigint not null,
                          "create_time" timestamp not null default current_timestamp,
                          "update_by" bigint not null,
                          "update_time" timestamp not null default current_timestamp,
                          primary key ("id")
);
comment on table "dv_sla" is '告警管理';
comment on column "dv_sla"."workspace_id" is '工作空间ID';comment on column "dv_sla"."name" is 'SLA 名字';comment on column "dv_sla"."description" is '描述';comment on column "dv_sla"."create_by" is '创建用户ID';comment on column "dv_sla"."create_time" is '创建时间';comment on column "dv_sla"."update_by" is '更新用户ID';comment on column "dv_sla"."update_time" is '更新时间';

drop table if exists "dv_sla_job";

create table "dv_sla_job" (
                              "id" bigint generated by default as identity not null,
                              "workspace_id" bigint not null,
                              "sla_id" bigint not null,
                              "job_id" bigint not null,
                              "create_by" bigint not null,
                              "create_time" timestamp not null default current_timestamp,
                              "update_by" bigint not null,
                              "update_time" timestamp not null default current_timestamp,
                              primary key ("id"),
                              constraint "unique" unique ("workspace_id", "sla_id", "job_id")
);
comment on table "dv_sla_job" is '告警和规则作业关联关系';
comment on column "dv_sla_job"."workspace_id" is '工作空间ID';comment on column "dv_sla_job"."sla_id" is 'SLA ID';comment on column "dv_sla_job"."job_id" is '规则作业ID';comment on column "dv_sla_job"."create_by" is '创建用户ID';comment on column "dv_sla_job"."create_time" is '创建时间';comment on column "dv_sla_job"."update_by" is '更新用户ID';comment on column "dv_sla_job"."update_time" is '更新时间';

drop table if exists "dv_sla_notification";

create table "dv_sla_notification" (
                                       "id" bigint generated by default as identity not null,
                                       "type" varchar(40) not null,
                                       "workspace_id" bigint not null,
                                       "sla_id" bigint not null,
                                       "sender_id" bigint not null,
                                       "config" text,
                                       "create_by" bigint not null,
                                       "create_time" timestamp not null default current_timestamp,
                                       "update_by" bigint not null,
                                       "update_time" timestamp not null default current_timestamp,
                                       primary key ("id")
);
comment on table "dv_sla_notification" is '告警管理中的通知组件';
comment on column "dv_sla_notification"."type" is '类型';comment on column "dv_sla_notification"."workspace_id" is '工作空间ID';comment on column "dv_sla_notification"."sla_id" is 'SLA ID';comment on column "dv_sla_notification"."sender_id" is '发送者ID';comment on column "dv_sla_notification"."config" is '工作空间ID';comment on column "dv_sla_notification"."create_by" is '创建用户ID';comment on column "dv_sla_notification"."create_time" is '创建时间';comment on column "dv_sla_notification"."update_by" is '更新用户ID';comment on column "dv_sla_notification"."update_time" is '更新时间';

drop table if exists "dv_sla_sender";

create table "dv_sla_sender" (
                                 "id" bigint generated by default as identity not null,
                                 "type" varchar(40) not null,
                                 "name" varchar(255) not null,
                                 "workspace_id" bigint not null,
                                 "config" text not null,
                                 "create_by" bigint not null,
                                 "create_time" timestamp not null default current_timestamp,
                                 "update_by" bigint not null,
                                 "update_time" timestamp not null default current_timestamp,
                                 primary key ("id")
);
comment on table "dv_sla_sender" is '告警管理中的发送者信息';
comment on column "dv_sla_sender"."type" is '类型';comment on column "dv_sla_sender"."name" is '名称';comment on column "dv_sla_sender"."workspace_id" is '工作空间ID';comment on column "dv_sla_sender"."config" is '配置信息';comment on column "dv_sla_sender"."create_by" is '创建用户ID';comment on column "dv_sla_sender"."create_time" is '创建时间';comment on column "dv_sla_sender"."update_by" is '更新用户ID';comment on column "dv_sla_sender"."update_time" is '更新时间';

drop table if exists "dv_tenant";

create table "dv_tenant" (
                             "id" bigint generated by default as identity not null,
                             "tenant" varchar(255) not null,
                             "workspace_id" bigint not null,
                             "create_by" bigint not null,
                             "create_time" timestamp not null default current_timestamp,
                             "update_by" bigint not null,
                             "update_time" timestamp not null default current_timestamp,
                             primary key ("id"),
                             constraint "tenant_name" unique ("tenant")
);
comment on table "dv_tenant" is '运行环境的租户';
comment on column "dv_tenant"."tenant" is '租户名';comment on column "dv_tenant"."workspace_id" is '工作空间ID';comment on column "dv_tenant"."create_by" is '创建用户ID';comment on column "dv_tenant"."create_time" is '创建时间';comment on column "dv_tenant"."update_by" is '更新用户ID';comment on column "dv_tenant"."update_time" is '更新时间';

drop table if exists "dv_user";

create table "dv_user" (
                           "id" bigint generated by default as identity not null,
                           "username" varchar(255) not null,
                           "password" varchar(255) not null,
                           "email" varchar(255) not null,
                           "phone" varchar(127) default null,
                           "admin" smallint not null default '0',
                           "create_time" timestamp not null default current_timestamp,
                           "update_time" timestamp not null default current_timestamp,
                           primary key ("id"),
                           constraint "user_un" unique ("username")
);
comment on table "dv_user" is '用户';
comment on column "dv_user"."username" is '用户名';comment on column "dv_user"."password" is '密码';comment on column "dv_user"."email" is '邮箱';comment on column "dv_user"."phone" is '手机号码';comment on column "dv_user"."admin" is '是否为管理员';comment on column "dv_user"."create_time" is '创建时间';comment on column "dv_user"."update_time" is '更新时间';

drop table if exists "dv_user_workspace";

create table "dv_user_workspace" (
                                     "id" bigint generated by default as identity not null,
                                     "user_id" bigint not null,
                                     "workspace_id" bigint not null,
                                     "role_id" bigint default null,
                                     "create_by" bigint not null,
                                     "create_time" timestamp not null default current_timestamp,
                                     "update_by" bigint not null,
                                     "update_time" timestamp not null default current_timestamp,
                                     primary key ("id")
);
comment on table "dv_user_workspace" is '用户和工作空间关联关系';
comment on column "dv_user_workspace"."user_id" is '用户ID';comment on column "dv_user_workspace"."workspace_id" is '工作空间ID';comment on column "dv_user_workspace"."role_id" is '角色ID';comment on column "dv_user_workspace"."create_by" is '创建用户ID';comment on column "dv_user_workspace"."create_time" is '创建时间';comment on column "dv_user_workspace"."update_by" is '更新用户ID';comment on column "dv_user_workspace"."update_time" is '更新时间';

drop table if exists "dv_workspace";

create table "dv_workspace" (
                                "id" bigint generated by default as identity not null,
                                "name" varchar(255) not null,
                                "create_by" bigint not null,
                                "create_time" timestamp not null default current_timestamp,
                                "update_by" bigint not null,
                                "update_time" timestamp not null default current_timestamp,
                                primary key ("id"),
                                constraint "workspace_un" unique ("name")
);
comment on table "dv_workspace" is '工作空间';
comment on column "dv_workspace"."name" is '工作空间名称';comment on column "dv_workspace"."create_by" is '创建用户ID';comment on column "dv_workspace"."create_time" is '创建时间';comment on column "dv_workspace"."update_by" is '更新用户ID';comment on column "dv_workspace"."update_time" is '更新时间';

drop table if exists "dv_config";

create table "dv_config" (
                             "id" bigint generated by default as identity not null,
                             "workspace_id" bigint not null,
                             "var_key" varchar(255) not null,
                             "var_value" text not null,
                             "is_default" smallint not null,
                             "create_by" bigint not null,
                             "create_time" timestamp not null default current_timestamp,
                             "update_by" bigint not null,
                             "update_time" timestamp not null default current_timestamp,
                             primary key ("id")
);
comment on table "dv_config" is '配置';
comment on column "dv_config"."workspace_id" is '工作空间ID';comment on column "dv_config"."var_key" is '参数名';comment on column "dv_config"."var_value" is '参数值';comment on column "dv_config"."is_default" is '是否为默认参数';comment on column "dv_config"."create_by" is '创建用户ID';comment on column "dv_config"."create_time" is '创建时间';comment on column "dv_config"."update_by" is '更新用户ID';comment on column "dv_config"."update_time" is '更新时间';

insert into "dv_config"
values (
           '1',
           '-1',
           'data.quality.jar.name',
           '/libs/datavines-engine-spark-core-1.0.0-SNAPSHOT.jar',
           '1',
           '1',
           '2023-09-02 16:52:56',
           '1',
           '2023-09-03 09:56:12'
       );
insert into "dv_config"
values (
           '2',
           '-1',
           'yarn.mode',
           'standalone',
           '1',
           '1',
           '2023-09-02 18:28:59',
           '1',
           '2023-09-03 12:46:24'
       );
insert into "dv_config"
values (
           '3',
           '-1',
           'yarn.application.status.address',
           'http://%s:%s/ws/v1/cluster/apps/%s',
           '1',
           '1',
           '2023-09-03 09:57:01',
           '1',
           '2023-09-03 09:57:01'
       );
insert into "dv_config"
values (
           '4',
           '-1',
           'yarn.resource.manager.http.address.port',
           '8088',
           '1',
           '1',
           '2023-09-03 09:57:34',
           '1',
           '2023-09-03 09:57:34'
       );
insert into "dv_config"
values (
           '5',
           '-1',
           'yarn.resource.manager.ha.ids',
           '192.168.0.x,192.168.0.x',
           '1',
           '1',
           '2023-09-03 09:58:17',
           '1',
           '2023-09-03 09:58:17'
       );
insert into "dv_config"
values (
           '7',
           '-1',
           'max.cpu.load.avg',
           '10',
           '1',
           '1',
           '2023-09-03 09:59:06',
           '1',
           '2023-09-03 09:59:06'
       );
insert into "dv_config"
values (
           '8',
           '-1',
           'reserved.memory',
           '0.3f',
           '1',
           '1',
           '2023-09-03 09:59:28',
           '1',
           '2023-09-03 09:59:28'
       );
insert into "dv_config"
values (
           '9',
           '-1',
           'file.max.length',
           '10000000',
           '1',
           '1',
           '2023-09-03 14:57:33',
           '1',
           '2023-09-03 14:57:33'
       );
insert into "dv_config"
values (
           '10',
           '-1',
           'error.data.dir',
           '/tmp/datavines/error-data',
           '1',
           '1',
           '2023-09-03 14:58:01',
           '1',
           '2023-09-03 14:58:01'
       );
insert into "dv_config"
values (
           '11',
           '-1',
           'validate.result.data.dir',
           '/tmp/datavines/validate-result-data',
           '1',
           '1',
           '2023-09-03 14:58:29',
           '1',
           '2023-09-03 14:58:29'
       );
insert into "dv_config"
values (
           '12',
           '-1',
           'local.execution.threshold',
           '1000',
           '1',
           '1',
           '2023-09-03 15:02:38',
           '1',
           '2023-09-03 15:02:38'
       );
insert into "dv_config"
values (
           '13',
           '-1',
           'spark.execution.threshold',
           '1000',
           '1',
           '1',
           '2023-09-03 15:02:38',
           '1',
           '2023-09-03 15:02:38'
       );
insert into "dv_config"
values (
           '14',
           '-1',
           'livy.uri',
           'http://localhost:8998/batches',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '15',
           '-1',
           'livy.task.appId.retry.count',
           '3',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '16',
           '-1',
           'livy.need.kerberos',
           'false',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '17',
           '-1',
           'livy.server.auth.kerberos.principal',
           'livy/kerberos.principal',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '18',
           '-1',
           'livy.server.auth.kerberos.keytab',
           '/path/to/livy/keytab/file',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '19',
           '-1',
           'livy.task.proxyUser',
           'root',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '20',
           '-1',
           'livy.task.jar.lib.path',
           'hdfs:///datavines/lib',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '21',
           '-1',
           'livy.execution.threshold',
           '1000',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
INSERT INTO "dv_config" VALUES ('22', '-1', 'livy.task.jars', CONCAT('datavines-common-1.0.0-SNAPSHOT.jar,datavines-spi-1.0.0-SNAPSHOT.jar,'
    'datavines-engine-spark-api-1.0.0-SNAPSHOT.jar,datavines-engine-spark-connector-jdbc-1.0.0-SNAPSHOT.jar,'
    'datavines-engine-core-1.0.0-SNAPSHOT.jar,datavines-engine-common-1.0.0-SNAPSHOT.jar,datavines-engine-spark-transform-sql-1.0.0-SNAPSHOT.jar,'
    'datavines-engine-api-1.0.0-SNAPSHOT.jar,mysql-connector-java-8.0.16.jar,httpclient-4.4.1.jar,'
    'httpcore-4.4.1.jar,postgresql-42.2.6.jar,presto-jdbc-0.283.jar,trino-jdbc-407.jar,clickhouse-jdbc-0.1.53.jar,'
    'mongo-java-driver-3.9.0.jar,mongo-spark-connector_2.11-2.4.0.jar,datavines-engine-spark-connector-mongodb-1.0.0-SNAPSHOT.jar'),
                                '1', '1', '2023-09-05 21:02:38', '1', '2023-09-05 21:02:38');
insert into "dv_config"
values (
           '23',
           '-1',
           'profile.execute.engine',
           'local',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '24',
           '-1',
           'spark.engine.parameter.deploy.mode',
           'cluster',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '25',
           '-1',
           'spark.engine.parameter.num.executors',
           '1',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '26',
           '-1',
           'spark.engine.parameter.driver.cores',
           '1',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '27',
           '-1',
           'spark.engine.parameter.driver.memory',
           '512M',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '28',
           '-1',
           'spark.engine.parameter.executor.cores',
           '1',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '29',
           '-1',
           'spark.engine.parameter.executor.memory',
           '512M',
           '1',
           '1',
           '2023-09-05 21:02:38',
           '1',
           '2023-09-05 21:02:38'
       );
insert into "dv_config"
values (
           '30',
           '-1',
           'datavines.fqdn',
           'http://127.0.0.1:5600',
           '1',
           '1',
           '2024-05-21 15:15:38',
           '1',
           '2024-05-21 15:15:38'
       );
insert into "dv_user" (
    "id",
    "username",
    "password",
    "email",
    "phone",
    "admin"
)
values (
           '1',
           'admin',
           '$2a$10$9ZcicUYFl/.knBi9SE53U.Nml8bfNeArxr35HQshxXzimbA6Ipgqq',
           'admin@gmail.com',
           null,
           '0'
       );
insert into "dv_workspace" ("id", "name", "create_by", "update_by")
values (
           '1',
           'admin''s default',
           '1',
           '1'
       );
insert into "dv_user_workspace" (
    "id",
    "user_id",
    "workspace_id",
    "role_id",
    "create_by",
    "update_by"
)
values (
           '1',
           '1',
           '1',
           '1',
           '1',
           '1'
       );

ALTER SEQUENCE "dv_config_id_seq" RESTART WITH 31;
ALTER SEQUENCE "dv_user_id_seq" RESTART WITH 2;
ALTER SEQUENCE "dv_workspace_id_seq" RESTART WITH 2;
ALTER SEQUENCE "dv_user_workspace_id_seq" RESTART WITH 2;