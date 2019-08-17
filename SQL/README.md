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
