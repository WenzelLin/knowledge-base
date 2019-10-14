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
