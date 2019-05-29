# Inner Left Right Full join

# In 和 Exists

# Not In 和 Not Exists

  如果NOT IN关键字后的子查询包含空值，则整体查询都会返回空，所以这类查询务必要加非NULL判断条件。

# UNION与UNION ALL的区别

  UNION会自动去除多个结果集合中的重复结果，而UNION ALL则将所有的结果全部显示出来，不管是不是重复。
  
  UNION会对结果集进行默认规则的排序，而UNION ALL则不会进行任何排序。
  
  所以效率方面很明显UNION ALL要高于UNION，因为它少去了排序和去重的工作。当然还有一点需要注意，UNION和UNION ALL也可以用来合并不同的两张表的结果集，但是字段类型和个数需要匹配


# Deferred Segment Creation

在Oracle中，“表空间（Tablespace）、段（Segment）、分区（Extent）和块（Block）”是逻辑存储结构的四个层次。对数据表而言，通常是由一个或者多个段对象（分区表）Segment组成。也就是说，在数据表创建的时刻，Oracle会创建一个数据段Segment对象与之对应。

当Segment创建之后，Oracle空间管理机制会根据需要分配至少一个extent作为初始化。每个extent的大小需要根据不同tablespace进行配置。但是在11g之前，数据表的创建同时，就发生了空间Segment分配的过程。但是在Oracle 11g中，引入了Deferred Segment Creation特性。
  
这就是在Oracle 11g中引入的延迟段生成。一个数据表，如果刚刚创建出来的时候没有数据加入。Oracle是不会为这个对象创建相应的段结构，也就不会分配对应的空间。

使用DDL语句可以获取到创建数据表的所有语句参数，包括默认参数。其中，我们发现了一个在过去版本中没有参数“SEGMENT CREATION DEFERRED”，该参数就表示在数据表创建中使用延迟段生成。

Oracle推出Deferred Segment Creation的出发点很单纯，就是出于对象空间节省的目的。如果一个空表从来就没有使用过，创建segment对象，分配空间是“不合算”的，所以提出推迟段创建的时间点。

如果deferred_segment_creation为true，那么数据库中空表就不会立即分配extent，即不占数据空间，当我们使用exp导出数据库的时候，这些空表也会无法导出。如果想把空表也一起导出，我们可以参考[Oracle 11g导出空表、少表的解决办法](http://www.cnblogs.com/ningvsban/p/3603678.html)这篇文章。

```sql,oracle
--设置deferred_segment_creation参数
alter system set deferred_segment_creation=false;

--查看参数信息
show parameter deferred_segment_creation;
```

# TNS

监听器是Oracle基于服务器端的一种网络服务，主要用于监听客户端向数据库服务器端提出的连接请求。既然是基于服务器端的服务，那么它也只存在于数据库服务器端，进行监听器的设置也是在数据库服务器端完成的。
 
* 使用Net Manager工具配置监听服务

  我们登录oracle数据的时候可能会经常遇到:TNS 无监听程序，或者安装好Plsql等工具后发现，database选项为空白。

  究其原因，一般都是因为监听程序未配置的问题。

  Net Manager这个工具是oracle客户端程序自带的，只要你安装oracle客户端一般都有。
 
* 直接修改tnsnames.oRA文件

  Oracle客户端中一般有两个tnsnames.oRA文件，配置监听要修改的是Oracle客户端家目下的network/admin/tnsnames.oRA。

  例如：

  D:\app\shaiya\product\11.2.0\client_1\network\admin\tnsnames.oRA

  如果实在找不到的话，可以直接到Oracle客户端安装磁盘，进行文件搜索“*.ora”或者“tnsnames.ora”。

  新安装的客户端如果没有配置过监听，admin目录下可能没有tnsnames.oRA这个文件，但是admin\sample\tnsnames.oRA有，我们可以把sample目下的文件复制一份到admin目录下。

  然后，以记事本的方式打开admin目录下的tnsnames.oRA，删除全部内容，并安装下面的格式想里面写入网络服务名、传输协议、IP地址、端口和数据库名。

  ------------------------------线下为配置文件内容-----------------------------ORCL_192.168.8.250 =         
  ```txt
        (DESCRIPTION =

            (ADDRESS_LIST =

                (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.8.250)(PORT = 1521))    

            )

            (CONNECT_DATA =

                  (SERVICE_NAME = orcl)    

             )

         )
  ```
  ------------------------------线上为配置文件内容-----------------------------

  #ORCL_192.168.8.250为网络服务名也叫数据库别名。

  #TCP为连接协议、192.168.8.250为服务器IP、1521为服务端口。

  #orcl为库名。

  注意事项：

  我们直接选择保存文件可能保存不了，可以先保存到别的位置，然后再复制过来替换掉历史的tnsnames.oRA。
       
 
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
* 增加最大连接数
 ```sql,oracle
 --增加最大连接数(这句可能要重启生效)
 alter system set processes = 500 scope = spfile;
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
  
# 参考

  * [Oracle 11g的Deferred Segment Creation](https://www.cnblogs.com/ningvsban/p/3603897.html)
  
  * [Oracle 11gR2 deferred segment creation 与 exp/imp 说明](https://www.cndba.cn/dave/article/1387)
  
  * [Oracle 查询技巧与优化（二） 多表查询](https://blog.csdn.net/wlwlwlwl015/article/details/52096120)
