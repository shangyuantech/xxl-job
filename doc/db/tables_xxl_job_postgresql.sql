--
-- XXL-JOB v2.4.1
-- Copyright (c) 2015-present, xuxueli.
-- Edited by Shangyuan Tech For Postgresql

CREATE DATABASE "xxl_job" ENCODING 'UTF8';

create table if not exists "xxl_job_group"
(
    "id"           INT4             not null,
    "app_name"     VARCHAR(64)      not null,
    "title"        VARCHAR(12)      not null,
    "address_type" INT2 default '0' not null,
    "address_list" TEXT,
    "update_time"  TIMESTAMP,
    primary key ("id")
);
comment on column "xxl_job_group"."app_name" is '执行器AppName';
comment on column "xxl_job_group"."address_type" is '执行器地址类型：0=自动注册、1=手动录入';
comment on column "xxl_job_group"."address_list" is '执行器地址列表，多地址逗号分隔';
comment on column "xxl_job_group"."title" is '执行器名称';

create table if not exists "xxl_job_info"
(
    "id"                        INT4                             not null,
    "job_group"                 INT4                             not null,
    "job_desc"                  VARCHAR(255)                     not null,
    "add_time"                  TIMESTAMP,
    "update_time"               TIMESTAMP,
    "author"                    VARCHAR(64),
    "alarm_email"               VARCHAR(255),
    "schedule_type"             VARCHAR(50) default 'NONE'       not null,
    "schedule_conf"             VARCHAR(128),
    "misfire_strategy"          VARCHAR(50) default 'DO_NOTHING' not null,
    "executor_route_strategy"   VARCHAR(50),
    "executor_handler"          VARCHAR(255),
    "executor_param"            VARCHAR(512),
    "executor_block_strategy"   VARCHAR(50),
    "executor_timeout"          INT4        default '0'          not null,
    "executor_fail_retry_count" INT4        default '0'          not null,
    "glue_type"                 VARCHAR(50)                      not null,
    "glue_source"               TEXT,
    "glue_remark"               VARCHAR(128),
    "glue_updatetime"           TIMESTAMP,
    "child_jobid"               VARCHAR(255),
    "trigger_status"            INT2        default '0'          not null,
    "trigger_last_time"         INT8        default '0'          not null,
    "trigger_next_time"         INT8        default '0'          not null,
    primary key ("id")
);
comment on column "xxl_job_info"."trigger_last_time" is '上次调度时间';
comment on column "xxl_job_info"."executor_timeout" is '任务执行超时时间，单位秒';
comment on column "xxl_job_info"."executor_param" is '执行器任务参数';
comment on column "xxl_job_info"."schedule_type" is '调度类型';
comment on column "xxl_job_info"."job_group" is '执行器主键ID';
comment on column "xxl_job_info"."author" is '作者';
comment on column "xxl_job_info"."executor_fail_retry_count" is '失败重试次数';
comment on column "xxl_job_info"."trigger_next_time" is '下次调度时间';
comment on column "xxl_job_info"."executor_handler" is '执行器任务handler';
comment on column "xxl_job_info"."executor_block_strategy" is '阻塞处理策略';
comment on column "xxl_job_info"."glue_type" is 'GLUE类型';
comment on column "xxl_job_info"."trigger_status" is '调度状态：0-停止，1-运行';
comment on column "xxl_job_info"."executor_route_strategy" is '执行器路由策略';
comment on column "xxl_job_info"."alarm_email" is '报警邮件';
comment on column "xxl_job_info"."schedule_conf" is '调度配置，值含义取决于调度类型';
comment on column "xxl_job_info"."misfire_strategy" is '调度过期策略';
comment on column "xxl_job_info"."glue_source" is 'GLUE源代码';
comment on column "xxl_job_info"."child_jobid" is '子任务ID，多个逗号分隔';
comment on column "xxl_job_info"."glue_updatetime" is 'GLUE更新时间';
comment on column "xxl_job_info"."glue_remark" is 'GLUE备注';

create table if not exists "xxl_job_lock"
(
    "lock_name" VARCHAR(50) not null,
    primary key ("lock_name")
);
comment on column "xxl_job_lock"."lock_name" is '锁名称';

create table if not exists "xxl_job_log"
(
    "id"                        INT8             not null,
    "job_group"                 INT4             not null,
    "job_id"                    INT4             not null,
    "executor_address"          VARCHAR(255),
    "executor_handler"          VARCHAR(255),
    "executor_param"            VARCHAR(512),
    "executor_sharding_param"   VARCHAR(20),
    "executor_fail_retry_count" INT4 default '0' not null,
    "trigger_time"              TIMESTAMP,
    "trigger_code"              INT4             not null,
    "trigger_msg"               TEXT,
    "handle_time"               TIMESTAMP,
    "handle_code"               INT4             not null,
    "handle_msg"                TEXT,
    "alarm_status"              INT2 default '0' not null,
    primary key ("id")
);
comment on column "xxl_job_log"."handle_time" is '执行-时间';
comment on column "xxl_job_log"."executor_param" is '执行器任务参数';
comment on column "xxl_job_log"."job_group" is '执行器主键ID';
comment on column "xxl_job_log"."executor_fail_retry_count" is '失败重试次数';
comment on column "xxl_job_log"."trigger_code" is '调度-结果';
comment on column "xxl_job_log"."executor_handler" is '执行器任务handler';
comment on column "xxl_job_log"."executor_sharding_param" is '执行器任务分片参数，格式如 1/2';
comment on column "xxl_job_log"."handle_msg" is '执行-日志';
comment on column "xxl_job_log"."trigger_time" is '调度-时间';
comment on column "xxl_job_log"."executor_address" is '执行器地址，本次执行的地址';
comment on column "xxl_job_log"."trigger_msg" is '调度-日志';
comment on column "xxl_job_log"."job_id" is '任务，主键ID';
comment on column "xxl_job_log"."alarm_status" is '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';
comment on column "xxl_job_log"."handle_code" is '执行-状态';
create index if not exists "I_handle_code" on "xxl_job_log" ("handle_code");
create index if not exists "I_trigger_time" on "xxl_job_log" ("trigger_time");

create table if not exists "xxl_job_log_report"
(
    "id"            INT4             not null,
    "trigger_day"   TIMESTAMP,
    "running_count" INT4 default '0' not null,
    "suc_count"     INT4 default '0' not null,
    "fail_count"    INT4 default '0' not null,
    "update_time"   TIMESTAMP,
    primary key ("id")
);
comment on column "xxl_job_log_report"."suc_count" is '执行成功-日志数量';
comment on column "xxl_job_log_report"."running_count" is '运行中-日志数量';
comment on column "xxl_job_log_report"."trigger_day" is '调度-时间';
comment on column "xxl_job_log_report"."fail_count" is '执行失败-日志数量';
create unique index if not exists "xxl_job_log_report_i_trigger_day" on "xxl_job_log_report" ("trigger_day");

create table if not exists "xxl_job_logglue"
(
    "id"          INT4         not null,
    "job_id"      INT4         not null,
    "glue_type"   VARCHAR(50),
    "glue_source" TEXT,
    "glue_remark" VARCHAR(128) not null,
    "add_time"    TIMESTAMP,
    "update_time" TIMESTAMP,
    primary key ("id")
);
comment on column "xxl_job_logglue"."job_id" is '任务，主键ID';
comment on column "xxl_job_logglue"."glue_source" is 'GLUE源代码';
comment on column "xxl_job_logglue"."glue_remark" is 'GLUE备注';
comment on column "xxl_job_logglue"."glue_type" is 'GLUE类型';

create table if not exists "xxl_job_registry"
(
    "id"             INT4         not null,
    "registry_group" VARCHAR(50)  not null,
    "registry_key"   VARCHAR(255) not null,
    "registry_value" VARCHAR(255) not null,
    "update_time"    TIMESTAMP,
    primary key ("id")
);
create index "i_g_k_v" on "xxl_job_registry" ("registry_group", "registry_key", "registry_value");

create table if not exists "xxl_job_user"
(
    "id"         INT4        not null,
    "username"   VARCHAR(50) not null,
    "password"   VARCHAR(50) not null,
    "role"       INT2        not null,
    "permission" VARCHAR(255),
    primary key ("id")
);
comment on column "xxl_job_user"."password" is '密码';
comment on column "xxl_job_user"."role" is '角色：0-普通用户、1-管理员';
comment on column "xxl_job_user"."permission" is '权限：执行器ID列表，多个逗号分割';
comment on column "xxl_job_user"."username" is '账号';
create unique index if not exists "xxl_job_user_i_username" on "xxl_job_user" ("username");

CREATE SEQUENCE xxl_job_user_id_seq START 1;
CREATE SEQUENCE xxl_job_info_id_seq START 1;
CREATE SEQUENCE xxl_job_log_id_seq START 1;
CREATE SEQUENCE xxl_job_log_report_id_seq START 1;
CREATE SEQUENCE xxl_job_logglue_id_seq START 1;
CREATE SEQUENCE xxl_job_registry_id_seq START 1;
CREATE SEQUENCE xxl_job_group_id_seq START 1;

ALTER TABLE "xxl_job_user"
    alter column "id" set default nextval('xxl_job_user_id_seq'::regclass);
ALTER TABLE "xxl_job_info"
    alter column "id" set default nextval('xxl_job_info_id_seq'::regclass);
ALTER TABLE "xxl_job_log"
    alter column "id" set default nextval('xxl_job_log_id_seq'::regclass);
ALTER TABLE "xxl_job_log_report"
    alter column "id" set default nextval('xxl_job_log_report_id_seq'::regclass);
ALTER TABLE "xxl_job_logglue"
    alter column "id" set default nextval('xxl_job_logglue_id_seq'::regclass);
ALTER TABLE "xxl_job_registry"
    alter column "id" set default nextval('xxl_job_registry_id_seq'::regclass);
ALTER TABLE "xxl_job_group"
    alter column "id" set default nextval('xxl_job_group_id_seq'::regclass);

INSERT INTO "xxl_job_group"("id", "app_name", "title", "address_type", "address_list", "update_time")
VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31');
INSERT INTO "xxl_job_info"("id", "job_group", "job_desc", "add_time", "update_time", "author", "alarm_email",
                           "schedule_type", "schedule_conf", "misfire_strategy", "executor_route_strategy",
                           "executor_handler", "executor_param", "executor_block_strategy", "executor_timeout",
                           "executor_fail_retry_count", "glue_type", "glue_source", "glue_remark", "glue_updatetime",
                           "child_jobid")
VALUES (1, 1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *',
        'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化',
        '2018-11-03 22:21:31', '');
INSERT INTO "xxl_job_user"("id", "username", "password", "role", "permission")
VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO "xxl_job_lock" ("lock_name")
VALUES ('schedule_lock');

commit;

