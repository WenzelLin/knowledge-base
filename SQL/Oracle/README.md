# 索引

  * [oracle索引，索引的建立、修改、删除](https://www.cnblogs.com/djcsch2001/articles/1823459.html)

  ## oracle 索引的引擎
  
  * B-Tree 索引（平衡树索引）
    
  * BitMap 索引（位图索引）
    
  * 聚集索引
    
  * 非聚集索引

# 常见错误码

* ORA-01465: invalid hex number  
  
  可能是字段名带了非hex number，也可能是字段值带了hex number。
  
# 常用语句

* 表空间

 ```sql,oracle
 --表空间（sam_gdcz31）
 CREATE TABLESPACE sam_gdcz31 DATAFILE 
 'D:/app/Administrator/oradata/sct1/sam_gdcz31.DBF' SIZE 50M REUSE autoextend on MAXSIZE 30000M, 
 'D:/app/Administrator/oradata/sct1/sam_gdcz31_2.DBF' SIZE 50M REUSE autoextend on MAXSIZE 30000M, 
 'D:/app/Administrator/oradata/sct1/sam_gdcz31_3.DBF' SIZE 50M REUSE autoextend on MAXSIZE 30000M 
 EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
 ```
 
* 创建用户

 ```sql,oracle
 --创建用户
 create user sam_gdcz31 identified by sam_gdcz31 default tablespace sam_gdcz31 temporary tablespace temp;
 ```
 
* 用户授权

 ```sql,oracle
 --对用户sam_gdcz31授权
 grant connect,resource,dba to sam_gdcz31 with admin option;
 ```

* oracle 查询表名以及表的列名

  oracle 查询表名以及表的列名的代码。

  * 1.查询表名：  
    ```sql,oracle
    select table_name,tablespace_name,temporary from user_tables [where table_name=表名];  
    ```
    其中：  
    table_name:表名（varchar2(30)）;   
    tablespace_name:存储表名的表空间（varchar2（30））；   
    temporary:是否为临时表（varchar2（1））。 

  * 2.查询表列名：  
    ```sql,oracle
    select column_name,data_type ,data_length,data_precision,data_scale from user_tab_columns [where table_name=表名]; 
    ```  
    其中：  
    column_name:列名（varchar2(30)）;   
    data_type:列的数据类型（varchar2(106)）;   
    data_length:列的长度（number); 

  注：表名变量值必须大写。   
  另外，也可以通过 all_tab_columns来获取相关表的数据。 


* 检查锁表
  
  * 查询所有被锁的表
  ```sql,oracle
  --查询所有被锁的表
  SELECT object_name, machine, s.sid, s.serial#
    FROM gv$locked_object l, dba_objects o, gv$session s
   WHERE l.object_id　 = o.object_id
     AND l.session_id = s.sid;
  ```
  * 找到被锁定的表，解锁 
  ```sql,oracle
  -- 找到被锁定的表，解锁 
  --alter system kill session 'sid, serial#';
  --ALTER system kill session '1140, 53129';
  ```
  * 1.查出锁定object的session的信息以及被锁定的object名
  ```sql,oracle
  --1.查出锁定object的session的信息以及被锁定的object名
  SELECT l.session_id sid, s.serial#, l.locked_mode,l.oracle_username,
  l.os_user_name,s.machine, s.terminal, o.object_name, s.logon_time
  FROM v$locked_object l, all_objects o, v$session s
  WHERE l.object_id = o.object_id
  AND l.session_id = s.sid
  ORDER BY sid, s.serial# ;
  ```
  * 2.查出锁定表的session的sid, serial#,os_user_name, machine name, terminal和执行的语句
  ```sql,oracle
  --2.查出锁定表的session的sid, serial#,os_user_name, machine name, terminal和执行的语句
  SELECT l.session_id sid, s.serial#, l.locked_mode, l.oracle_username, s.user#,
  l.os_user_name,s.machine, s.terminal,a.sql_text, a.action
  FROM v$sqlarea a,v$session s, v$locked_object l
  WHERE l.session_id = s.sid
  AND s.prev_sql_addr = a.address
  ORDER BY sid, s.serial#;
  ```
  * 3.查出锁定表的sid, serial#,os_user_name, machine_name, terminal，锁的type,mode
  ```sql,oracle
  --3.查出锁定表的sid, serial#,os_user_name, machine_name, terminal，锁的type,mode
  SELECT s.sid, s.serial#, s.username, s.schemaname, s.osuser, s.process, s.machine,
  s.terminal, s.logon_time, l.type
  FROM v$session s, v$lock l
  WHERE s.sid = l.sid
  AND s.username IS NOT NULL
  ORDER BY sid;
  ```
