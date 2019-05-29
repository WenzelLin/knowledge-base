# SQL 效率

v$sqltext：存储的是完整的SQL,SQL被分割

v$sqlarea：存储的SQL 和一些相关的信息，比如累计的执行次数，逻辑读，物理读等统计信息（统计）

v$sql：内存共享SQL区域中已经解析的SQL语句。（即时）

## SQL 优化
  
### 5. 选择最有效率的表名顺序

  * ORACLE的解析器按照从右到左的顺序处理FROM子句中的表名，因此FROM子句中写在最后的表(基础表 driving table)将被最先处理。
  
  * 当ORACLE处理多个表时，会运用排序及合并的方式连接它们。首先，扫描第一个表(FROM子句中最后的那个表)并对记录进行派序，然后扫描第二个表(FROM子句中最后第二个表)，最后将所有从第二个表中检索出的记录与第一个表中合适记录进行合并。
  
  * 只在基于规则的优化器中有效。

### 6.Where子句中的连接顺序

Oracle采用自下而上的顺序解析WHERE子句。 根据这个原理,表之间的连接必须写在其他WHERE条件之前，那些可以过滤掉最大数量记录的条件必须写在WHERE子句的末尾。

```sql,oracle
/*低效,执行时间156.3秒*/
SELECT … 
  FROM EMP E
WHERE  SAL > 50000
     AND  JOB = 'MANAGER'
     AND  25 < (SELECT COUNT(*) FROM EMP
                         WHERE MGR = E.EMPNO);


/*高效,执行时间10.6秒*/
SELECT … 
  FROM EMP E
WHERE 25 < (SELECT COUNT(*) FROM EMP
                        WHERE MGR=E.EMPNO)
     AND SAL > 50000
     AND JOB = 'MANAGER';
```

### 7. SELECT子句中避免使用“*”

  * Oracle在解析SQL语句的时候，对于“*”将通过查询数据库字典来将其转换成对应的列名。
  * 如果在Select子句中需要列出所有的Column时，建议列出所有的Column名称，而不是简单的用“*”来替代，这样可以减少多于的数据库查询开销。

### 10. 使用Truncate而非Delete

  * Delete表中记录的时候，Oracle会在Rollback段中保存删除信息以备恢复。Truncate删除表中记录的时候不保存删除信息，不能恢复。因此Truncate删除记录比   
  * Delete快，而且占用资源少。
  
  * 删除表中记录的时候，如果不需要恢复的情况之下应该尽量使用Truncate而不是Delete。
  
  * Truncate仅适用于删除全表的记录。

### 12. 计算记录条数

```sql,oracle
Select count(*) from tablename; 
Select count(1) from tablename; 
Select max(rownum) from tablename;
```

一般认为，在没有索引的情况之下，第一种方式最快。 如果有索引列，使用索引列当然最快。
 
### 14.减少对表的查询操作

在含有子查询的SQL语句中，要注意减少对表的查询操作。

```sql,oracle
--低效：
SELECT TAB_NAME  FROM TABLES
WHERE TAB_NAME =(SELECT TAB_NAME
                           FROM TAB_COLUMNS
                         WHERE VERSION = 604)
     AND DB_VER =(SELECT DB_VER
                           FROM TAB_COLUMNS
                         WHERE VERSION = 604);

--高效：
SELECT TAB_NAME  FROM TABLES
WHERE (TAB_NAME，DB_VER)=
             (SELECT TAB_NAME，DB_VER
                  FROM TAB_COLUMNS
                WHERE VERSION = 604);
```                

### 18. 用表连接替换EXISTS

通常来说 ，采用表连接的方式比EXISTS更有效率 。

```sql,oracle
--低效：
SELECT ENAME
   FROM EMP E
WHERE EXISTS (SELECT 'X' 
                  FROM DEPT
              WHERE DEPT_NO = E.DEPT_NO
                           AND DEPT_CAT = 'A');
--高效：
SELECT ENAME
   FROM DEPT D，EMP E
WHERE E.DEPT_NO = D.DEPT_NO
     AND DEPT_CAT = 'A';
```

### 19. 用EXISTS替换DISTINCT 

当提交一个包含对多表信息(比如部门表和雇员表)的查询时，避免在SELECT子句中使用DISTINCT。 一般可以考虑用EXIST替换。

EXISTS 使查询更为迅速，因为RDBMS核心模块将在子查询的条件一旦满足后，立刻返回结果。

```sql,oracle
--低效：
SELECT DISTINCT DEPT_NO，DEPT_NAME
       FROM DEPT D，EMP E
    WHERE D.DEPT_NO = E.DEPT_NO;

--高效：
SELECT DEPT_NO，DEPT_NAME
      FROM DEPT D
    WHERE EXISTS (SELECT ‘X’
                  FROM EMP E
                WHERE E.DEPT_NO = D.DEPT_NO);
```

### 20. 识别低效的SQL语句

下面的SQL工具可以找出低效SQL ：

```sql,oracle
SELECT EXECUTIONS, DISK_READS, BUFFER_GETS,
   ROUND ((BUFFER_GETS-DISK_READS)/BUFFER_GETS, 2) Hit_radio,
   ROUND (DISK_READS/EXECUTIONS, 2) Reads_per_run,
   SQL_TEXT
FROM   V$SQLAREA
WHERE  EXECUTIONS>0
AND     BUFFER_GETS > 0 
AND (BUFFER_GETS-DISK_READS)/BUFFER_GETS < 0.8 
ORDER BY 4 DESC
```
另外也可以使用SQL Trace工具来收集正在执行的SQL的性能状态数据，包括解析次数，执行次数，CPU使用时间等 。

### 23. 用索引提高效率

  * （1）特点

    优点： 提高效率 主键的唯一性验证

    代价： 需要空间存储 定期维护

    ```sql,oracle
    --重构索引： 
    ALTER INDEX <INDEXNAME> REBUILD <TABLESPACENAME>
    ```

  * （2）Oracle对索引有两种访问模式

    索引唯一扫描 (Index Unique Scan)
    
    索引范围扫描 (Index Range Scan)
  
  * （3）基础表的选择

    基础表(Driving Table)是指被最先访问的表(通常以全表扫描的方式被访问)。 根据优化器的不同，SQL语句中基础表的选择是不一样的。
    
    如果你使用的是CBO (COST BASED OPTIMIZER)，优化器会检查SQL语句中的每个表的物理大小，索引的状态，然后选用花费最低的执行路径。
    
    如果你用RBO (RULE BASED OPTIMIZER)， 并且所有的连接条件都有索引对应，在这种情况下，基础表就是FROM 子句中列在最后的那个表。

  * （4）多个平等的索引

    当SQL语句的执行路径可以使用分布在多个表上的多个索引时，ORACLE会同时使用多个索引并在运行时对它们的记录进行合并，检索出仅对全部索引有效的记录。

    在ORACLE选择执行路径时，唯一性索引的等级高于非唯一性索引。然而这个规则只有当WHERE子句中索引列和常量比较才有效。如果索引列和其他表的索引类相比较。这种子句在优化器中的等级是非常低的。
    
    如果不同表中两个相同等级的索引将被引用，FROM子句中表的顺序将决定哪个会被率先使用。 FROM子句中最后的表的索引将有最高的优先级。

    如果相同表中两个相同等级的索引将被引用，WHERE子句中最先被引用的索引将有最高的优先级。
  
  * （5）等式比较优先于范围比较

    DEPTNO上有一个非唯一性索引，EMP_CAT也有一个非唯一性索引。

    ```sql,oracle
    SELECT ENAME
         FROM EMP
         WHERE DEPTNO > 20
         AND EMP_CAT = ‘A’;
    ```

    这里只有EMP_CAT索引被用到,然后所有的记录将逐条与DEPTNO条件进行比较. 执行路径如下:

    TABLE ACCESS BY ROWID ON EMP

    INDEX RANGE SCAN ON CAT_IDX

    即使是唯一性索引，如果做范围比较，其优先级也低于非唯一性索引的等式比较。

  * （6）不明确的索引等级

    当ORACLE无法判断索引的等级高低差别，优化器将只使用一个索引,它就是在WHERE子句中被列在最前面的。

    DEPTNO上有一个非唯一性索引，EMP_CAT也有一个非唯一性索引。

    ```sql,oracle
    SELECT ENAME
         FROM EMP
         WHERE DEPTNO > 20
         AND EMP_CAT > ‘A’;
    ```

    这里, ORACLE只用到了DEPT_NO索引. 执行路径如下:

    TABLE ACCESS BY ROWID ON EMP

    INDEX RANGE SCAN ON DEPT_IDX

  * （7）强制索引失效

    如果两个或以上索引具有相同的等级，你可以强制命令ORACLE优化器使用其中的一个(通过它,检索出的记录数量少) 。

    ```sql,oracle
    SELECT ENAME
    FROM EMP
    WHERE EMPNO = 7935  
    AND DEPTNO + 0 = 10    /*DEPTNO上的索引将失效*/
    AND EMP_TYPE || ‘’ = ‘A’  /*EMP_TYPE上的索引将失效*/
    ```

  * （8）避免在索引列上使用计算

    WHERE子句中，如果索引列是函数的一部分。优化器将不使用索引而使用全表扫描。

    ```sql,oracle
    --低效：
    SELECT …
      FROM DEPT
    WHERE SAL * 12 > 25000;
    
    --高效：
    SELECT …
      FROM DEPT
    WHERE SAL  > 25000/12;
    ```

  * （9）自动选择索引

    如果表中有两个以上（包括两个）索引，其中有一个唯一性索引，而其他是非唯一性索引。在这种情况下，ORACLE将使用唯一性索引而完全忽略非唯一性索引。

    ```sql,oracle
    SELECT ENAME
      FROM EMP
    WHERE EMPNO = 2326  
         AND DEPTNO  = 20 ; 
    ```
    
    这里，只有EMPNO上的索引是唯一性的，所以EMPNO索引将用来检索记录。

    TABLE ACCESS BY ROWID ON EMP

    INDEX UNIQUE SCAN ON EMP_NO_IDX

  * （10）避免在索引列上使用NOT

    通常，我们要避免在索引列上使用NOT，NOT会产生在和在索引列上使用函数相同的影响。当ORACLE遇到NOT，它就会停止使用索引转而执行全表扫描。

    ```sql,oracle
    --低效: (这里，不使用索引)
       SELECT …
         FROM DEPT
       WHERE NOT DEPT_CODE = 0;
    --高效：(这里，使用了索引)
       SELECT …
         FROM DEPT
       WHERE DEPT_CODE > 0
    ```
    
### 33. 几种不能使用索引的WHERE子句 

  * （1）下面的例子中，'!=' 将不使用索引 ，索引只能告诉你什么存在于表中，而不能告诉你什么不存在于表中。

  ```sql,oracle
  --不使用索引：
  SELECT ACCOUNT_NAME
        FROM TRANSACTION
      WHERE AMOUNT !=0;

  --使用索引：
  SELECT ACCOUNT_NAME
        FROM TRANSACTION
      WHERE AMOUNT > 0;
  ```

  * （2）下面的例子中，'||'是字符连接函数。就象其他函数那样，停用了索引。

  ```sql,oracle
  --不使用索引：
  SELECT ACCOUNT_NAME，AMOUNT
    FROM TRANSACTION
  WHERE ACCOUNT_NAME||ACCOUNT_TYPE='AMEXA';

  --使用索引：
  SELECT ACCOUNT_NAME，AMOUNT
    FROM TRANSACTION
  WHERE ACCOUNT_NAME = 'AMEX'
       AND ACCOUNT_TYPE='A';
  ```

  * （3）下面的例子中，'+'是数学函数。就象其他数学函数那样，停用了索引。

  ```sql,oracle
  --不使用索引：
  SELECT ACCOUNT_NAME，AMOUNT
    FROM TRANSACTION
  WHERE AMOUNT + 3000 >5000;

  --使用索引：
  SELECT ACCOUNT_NAME，AMOUNT
  FROM TRANSACTION
  WHERE AMOUNT > 2000;
  ```

  * （4）下面的例子中，相同的索引列不能互相比较，这将会启用全表扫描。

  ```sql,oracle
  --不使用索引：
  SELECT ACCOUNT_NAME, AMOUNT
  FROM TRANSACTION
  WHERE ACCOUNT_NAME = NVL(:ACC_NAME, ACCOUNT_NAME);

  --使用索引：
  SELECT ACCOUNT_NAME，AMOUNT
  FROM TRANSACTION
  WHERE ACCOUNT_NAME LIKE NVL(:ACC_NAME, '%');
  ```

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

  * [oracle中查找执行效率低下的SQL](https://blog.csdn.net/haiross/article/details/43482991)
  
  * [Oracle SQL性能优化的40条军规](https://www.cnblogs.com/zjfjava/p/7092503.html)
