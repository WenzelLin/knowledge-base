* 空判断问题
 
 * sqlserver
   
   某字段其值有可能为空，在使用该字段时，必须要结合空或非空判断来使用。
   
   ```SQL
    -- 判断值为空或小于2020-01-01
    select 1 from table where column = '' or column is null or column < '2020-01-01'; 
    -- 判断值为非空且大于等于2020-01-01
    select 1 from table where column <> '' and column is not null and column >= '2020-01-01'; 
   ```
 * oracle
 
  某字段其值有可能为空，在使用该字段时，必须要结合空或非空判断来使用。
  
  ```SQL
    -- 判断值为空或小于2020-01-01
    select 1 from table where column = '' or column is null or column < '2020-01-01'; 
    -- 判断值为非空且大于等于2020-01-01
    select 1 from table where column is not null and column >= '2020-01-01'; 
   ```

* 精度问题
 
 * sqlserver

   ```SQL
   -- 自动转型，导致精度丢失
   select case when column = 0 then 0 else column end from table; 
   -- 还有一种是减法的， 1.4-isnull(column, 0) 或 1.4-isnull(column, 0.00)
   ```

* 查看约束

 * oracle
 
   ```SQL
   SELECT USER_CONS_COLUMNS.CONSTRAINT_NAME AS 约束名,
         USER_CONS_COLUMNS.TABLE_NAME      AS 表名,
         USER_CONS_COLUMNS.COLUMN_NAME     AS 列名,
         USER_CONS_COLUMNS.POSITION        AS 位置,
         USER_CONSTRAINTS.search_condition AS 条件
    FROM USER_CONSTRAINTS
    JOIN USER_CONS_COLUMNS
      ON (USER_CONSTRAINTS.CONSTRAINT_NAME =
         USER_CONS_COLUMNS.CONSTRAINT_NAME)
   WHERE USER_CONSTRAINTS.CONSTRAINT_TYPE = 'C';
   /*
    注: 最后那里的 WHERE 填写的条件的注意：
    C (check constraint on a table) C 表示 CHECK 约束。
    P (primary key) P 表示主键
    U (unique key) U 表示唯一
    R (referential integrity) P 表示引用(外键)
    V (with check option, on a view)
    O (with read only, on a view)
    */
    
   select 
         b.constraint_name 外键名称, 
         b.table_name 约束表,  
         b.column_name 约束列,
         c.table_name as 参照表,
         c.column_name 参照列,
         a.delete_rule 删除级联
    from user_constraints a
    left  join user_cons_columns b on a.constraint_name = b.constraint_name
    left  join user_cons_columns c on a.r_constraint_name = c.constraint_name
   where a.constraint_type = 'R' ;
   ```

* Cast

  * oracle
  
    语法：CAST(expr AS type_name)

    例如：select cast(1 as varchar2(50)) from daul;

* 数据库表名、列名的长度限制
  
  |数据库|表名|列名| 
  |:--:|:--:|:--:|
  |mysql|64|64|
  |oracle|30|30|
  |db2|128|128|
  |access|64|64|
  |mssql|128|128|

* update多列数据
  
  * oracle
  
    语法格式：
    ```SQL
    update table1 
      set (column1,column2) = 
        (select table2.column1, table2.cloumn2 from table2 where table1.id = table2.id) 
     where exists(select 1 from table2 where table1.id = table2.id);
    ```
  * sqlserver
  
    语法格式：
    ```SQL
    update table1 
      set table1.column1 = table2.column1, table1.column2 = table2.column2 
     from table2 
    where table1.id = table2.id;
    ```
    ```SQL
    /* Creating First table */
    CREATE TABLE [dbo].[MyTecBits_Table_1](
    [Sl_no] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NULL,
    [Description] [varchar](500) NULL
    ) ON [PRIMARY]
    GO

    insert into MyTecBits_Table_1 values ('Name One','Description One')
    insert into MyTecBits_Table_1 values ('Name Two','Description Two')
    insert into MyTecBits_Table_1 values ('Name Three','Description Three')
    insert into MyTecBits_Table_1 values ('Name Four','Description Four')

    /* Creating Second table */
    CREATE TABLE [dbo].[MyTecBits_Table_2](
    [Sl_no] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NULL,
    [Description] [varchar](500) NULL
    ) ON [PRIMARY]
    GO

    insert into MyTecBits_Table_2 values ('1st Name','1st Description')
    insert into MyTecBits_Table_2 values ('2nd Name','2nd Description')
    insert into MyTecBits_Table_2 values ('3rd Name','3rd Description')
    insert into MyTecBits_Table_2 values ('4th Name','3rd Description')


    Select * from MyTecBits_Table_1;
    Select * from MyTecBits_Table_2;
    
    
    Update MyTecBits_Table_1 
    Set Name = b.Name, Description = b.Description
    From MyTecBits_Table_2 as b
    where MyTecBits_Table_1.Sl_no = b.Sl_no;
    

    Select * from MyTecBits_Table_1;
    Select * from MyTecBits_Table_2;
    
    ```

* Sql Server 与 Oracle 的字段类型对应
  
  * Sql Server 2000 转换为Oracle 10g
  
    |列名|SqlServer数据类型|SqlServer长度|Oracle数据类型|
    |:--|:--|--:|:--|
    |column1|bigint|8|NUMBER(19)|
    |column2|binary|50|RAW(50)|
    |column3|bit|1|NUMBER(2)|
    |column4|char|10|CHAR(10)|
    |column5|datetime|8|DATE|
    |column6|decimal|9|NUMBER(18)|
    |column7|float|8|BINARY_DOUBLE|
    |column8|image|16|BLOB|
    |column9|int|4|NUMBER(10)|
    |column10|money|8|NUMBER(19,4)|
    |column11|nchar|10|NCHAR(10)|
    |column12|ntext|16|NCLOB|
    |column13|numeric|9|NUMBER(18)|
    |column14|nvarchar|50|NVARCHAR2(50)|
    |column15|real|4|BINARY_FLOAT|
    |column16|smalldatetime|4|DATE|
    |column17|smallint|2|NUMBER(5)|
    |column18|smallmoney|4|NUMBER(10,4)|
    |column19|sql_variant||BLOB|
    |column20|text|16|CLOB|
    |column21|timestamp|8|RAW(8)|
    |column22|tinyint|1|NUMBER(3)|
    |column23|uniqueidentifier|16|BLOB|
    |column24|varbinary|50|RAW(50)|
    |column25|varchar|50|VARCHAR2(50)|
  
  * Oracle 10g 转换为 Sql Server 2000
  
    |Oracle列名|Oracle数据类型|SqlServer列名|SqlServer数据类型|SqlServer数据长度|
    |:--|:--|:--|:--|--:|
    |COLUMN1|BINARY_DOUBLE|COLUMN1|float|8|
    |COLUMN2|BINARY_FLOAT|COLUMN2|real|4|
    |COLUMN3|BLOB|COLUMN3|image|16|
    |COLUMN4|CLOB|COLUMN4|ntext|16|
    |COLUMN5|CHAR(10)|COLUMN5|nchar|10|
    |COLUMN6|DATE|COLUMN6|datetime|8|
    |COLUMN7|INTERVAL DAY(2) TO SECOND(6)|COLUMN7|nvarchar|30|
    |COLUMN8|INTERVAL YEAR(2) TO MONTH|COLUMN8|nvarchar|14|
    |COLUMN9|LONG|COLUMN9|ntext|16|
    |COLUMN10|LONG RAW|COLUMN10|image|16|
    |COLUMN11|NCLOB|COLUMN11|ntext|16|
    |COLUMN12|NUMBER|COLUMN12|numeric|13|
    |COLUMN13|NVARCHAR2(10)|COLUMN13|nvarchar|10|
    |COLUMN14|RAW(10)|COLUMN14|varbinary|10|
    |COLUMN15|TIMESTAMP(6)|COLUMN15|datetime|8|
    |COLUMN16|TIMESTAMP(6) WITH LOCAL TIME ZONE|COLUMN16|datetime|8|
    |COLUMN17|TIMESTAMP(6) WITH TIME ZONE|COLUMN17|datetime|8|
    |COLUMN18|VARCHAR2(10)|COLUMN18|nvarchar|10|

* 游标
  - SQL Server游标语句使用方法
  ```
    --声明一个游标 
    DECLARE MyCursor CURSOR 
    FOR SELECT TOP 5 FBookName,FBookCoding FROM TBookInfo//定义一个叫MyCursor的游标，存放for select 后的数据 

    --打开一个游标 
    OPEN MyCursor//即打开这个数据集 

    --循环一个游标 
    DECLARE @BookName nvarchar(2000),@BookCoding nvarchar(2000) 
    FETCH NEXT FROM MyCursor INTO @BookName,@BookCoding//移动游标指向到第一条数据，提取第一条数据存放在变量中 
    WHILE @@FETCH_STATUS =0//如果上一次操作成功则继续循环 
    BEGIN 
    print 'name'+@BookName 
    FETCH NEXT FROM MyCursor INTO @BookName,@BookCoding//继续提下一行 
    END 

    --关闭游标 
    CLOSE MyCursor 
    --释放资源 
    DEALLOCATE MyCursor 
  ```

  - oracle 快速游标
  ```
    BEGIN 
      FOR cr in (查询语句) LOOP -- 循环
        --逻辑语句 根据查询出来的结果集合
      END LOOP;
    END;
    
    例子：
    --快速游标
    begin 
      for cr in (select tAssetwriteoffdetail.Awdpk, tAssetwriteoffdetail.Awdassetpk, (select Tassetregist.Assetregbarcode from Tassetregist where tAssetwriteoffdetail.Awdassetpk = Tassetregist.Assetregpk) AwdassetBarCode,tAssetwriteoffdetail.AWDNewAssetPK from tAssetwriteoffdetail where tAssetwriteoffdetail.AWDIsAccepted = 1) loop
        update Tassetregist set AssetRegRemark = '资产原卡片编号为：' ||case when cr.awdassetbarcode is null or cr.awdassetbarcode = '' then cr.awdassetpk else cr.awdassetbarcode end || '，' || AssetRegRemark where Tassetregist.Assetregpk = cr.awdnewassetpk and AssetRegRemark like '%资产原属单位为%在系统接收生成！%';
      end loop;
    end; 
  ```
  
* 字符集
  oracle：select * from nls_database_parameters

* 取模

  sqlserver：%
  
  oracle: mod(x, y)

* oracle 目录

  all_directories
  
* [Oracle 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/Oracle/README.md)

* [MySQL 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/MySQL/README.md)

# oracle数据库误删的表以及表中记录的恢复

* 1、先从flashback_transaction_query视图里查询，视图提供了供查询用的表名称、事务提交时间、UNDO_SQL等字段。
```sql
select * from flashback_transaction_query where table_name=upper('timsprojectmanage');
```
* 2、执行表记录恢复
```sql
alter table timsprojectmanage enable row movement;
flashback table timsprojectmanage to timestamp to_timestamp('2019-06-26 16:47:30','yyyy-mm-dd hh24:mi:ss');
```
* 3、关闭行移动功能 ( 千万别忘记 )
```sql
alter table timsprojectmanage disable row movement;
```

# 复制表结构及数据

* sqlserver
```
select * into new_table_name from table_name_old;
```

* oracle
```
create table table_name_new as select * from table_name_old;
```

# Check 约束
  ```sql
  {constant | column_name | function | (subquery)}
  [{operator | AND | OR | NOT}
  {constant | column_name | function | (subquery)}...]
   ```
  ```sql
  ALTER TABLE Persons
  ADD CONSTRAINT chk_Person CHECK (Id_P>0 AND City='Sandnes')
  ```
  * [SQL Server Check 约束用法详解](https://blog.csdn.net/amandalm/article/details/44218841)

  * [SQL CHECK 约束|W3c School](http://www.w3school.com.cn/sql/sql_check.asp)


# 参考

* [SQL复制数据表及表结构](https://www.cnblogs.com/wuhenke/archive/2010/07/28/1786954.html)

* [如何在Oracle中复制表结构和表数据 【转载】](https://www.cnblogs.com/haibin168/archive/2011/02/26/1966053.html)

* [oracle数据库误删的表以及表中记录的恢复](https://blog.csdn.net/jiyang_1/article/details/52179359)

* [oracle误删除数据的恢复方法](https://www.cnblogs.com/hqbhonker/p/3977200.html)

* [oracle恢复删除的数据](https://www.cnblogs.com/kangxuebin/archive/2013/05/29/3106183.html)

* [Oracle字符集的查看查询和Oracle字符集的设置修改](https://www.cnblogs.com/perilla/p/3873653.html)

* [sql server 与oracle 中字段类型的对应](https://blog.csdn.net/yali1990515/article/details/50467259)

* [SQL Server: Update From Select Statement](https://www.mytecbits.com/microsoft/sql-server/update-from-select)

* [oracle的表名、字段名、constraint名的长度限制分别是多少？](https://blog.csdn.net/haiross/article/details/38379615)
