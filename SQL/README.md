# MySql 搜索引擎
# oracle 索引的引擎

* [oracle索引，索引的建立、修改、删除](https://www.cnblogs.com/djcsch2001/articles/1823459.html)

oracle 查询表名以及表的列名

oracle 查询表名以及表的列名的代码。

* 1.查询表名：  
    select table_name,tablespace_name,temporary from user_tables [where table_name=表名];   
    其中：  
    table_name:表名（varchar2(30)）;   
    tablespace_name:存储表名的表空间（varchar2（30））；   
    temporary:是否为临时表（varchar2（1））。 

* 2.查询表列名：  
    select column_name,data_type ,data_length,data_precision,data_scale from user_tab_columns [where table_name=表名];   
    其中：  
    column_name:列名（varchar2(30)）;   
    data_type:列的数据类型（varchar2(106)）;   
    data_length:列的长度（number); 

注：表名变量值必须大写。   
另外，也可以通过 all_tab_columns来获取相关表的数据。 


--查询所有被锁的表
SELECT object_name, machine, s.sid, s.serial#
  FROM gv$locked_object l, dba_objects o, gv$session s
 WHERE l.object_id　 = o.object_id
   AND l.session_id = s.sid;


-- 找到被锁定的表，解锁 
--alter system kill session 'sid, serial#';
--ALTER system kill session '1140, 53129';

--1.查出锁定object的session的信息以及被锁定的object名
SELECT l.session_id sid, s.serial#, l.locked_mode,l.oracle_username,
l.os_user_name,s.machine, s.terminal, o.object_name, s.logon_time
FROM v$locked_object l, all_objects o, v$session s
WHERE l.object_id = o.object_id
AND l.session_id = s.sid
ORDER BY sid, s.serial# ;

--2.查出锁定表的session的sid, serial#,os_user_name, machine name, terminal和执行的语句
SELECT l.session_id sid, s.serial#, l.locked_mode, l.oracle_username, s.user#,
l.os_user_name,s.machine, s.terminal,a.sql_text, a.action
FROM v$sqlarea a,v$session s, v$locked_object l
WHERE l.session_id = s.sid
AND s.prev_sql_addr = a.address
ORDER BY sid, s.serial#;

--3.查出锁定表的sid, serial#,os_user_name, machine_name, terminal，锁的type,mode
SELECT s.sid, s.serial#, s.username, s.schemaname, s.osuser, s.process, s.machine,
s.terminal, s.logon_time, l.type
FROM v$session s, v$lock l
WHERE s.sid = l.sid
AND s.username IS NOT NULL
ORDER BY sid;
