# Postgresql�汾����

## ����ű�

������ `doc/db/tables_xxl_job_postgresql.sql` Ŀ¼���档

## �޸����ݿ�����

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/xxl_job
spring.datasource.username=xxl_job
spring.datasource.password=xxl_job
spring.datasource.driver-class-name=org.postgresql.Driver
```

## �޸�SQL

* �� ` �޸�Ϊ "
* �޸� LIMIT #{offset}, #{pagesize} Ϊ LIMIT #{pagesize} OFFSET #{offset} ��
* �޸�DATE_ADD(#{nowTime},INTERVAL - #{timeout} SECOND) Ϊ ((select NOW())-INTERVAL '${timeout} S') ��
* �޸� WHERE !( Ϊ WHERE not ( 