# Postgresql版本适配

## 建表脚本

放在了 `doc/db/tables_xxl_job_postgresql.sql` 目录下面。

## 修改数据库配置

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/xxl_job
spring.datasource.username=xxl_job
spring.datasource.password=xxl_job
spring.datasource.driver-class-name=org.postgresql.Driver
```

## 修改SQL

* 将 ` 修改为 "
* 修改 LIMIT #{offset}, #{pagesize} 为 LIMIT #{pagesize} OFFSET #{offset} 。
* 修改DATE_ADD(#{nowTime},INTERVAL - #{timeout} SECOND) 为 ((select NOW())-INTERVAL '${timeout} S') 。
* 修改 WHERE !( 为 WHERE not ( 

## 重新编译镜像

```shell
cd xxl-job-admin
docker build -t xuxueli/xxl-job-admin:2.4.1-postgresql .
```