* [Oracle 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/Oracle/README.md)

* [MySQL 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/MySQL/README.md)

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
