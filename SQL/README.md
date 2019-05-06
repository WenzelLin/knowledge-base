# oracle 查询表名以及表的列名
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
