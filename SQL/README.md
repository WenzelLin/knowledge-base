* [Oracle 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/Oracle/README.md)

* [MySQL 知识](https://github.com/WenzelLin/knowledge-base/blob/master/SQL/MySQL/README.md)

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
