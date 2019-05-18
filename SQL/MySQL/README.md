# MySQL 的各种引擎

可以使用`SHOW ENGINES`语句查看系统所支持的引擎类型。

`Support`列的值表示某种引擎是否能使用，`YES`表示可以使用，`NO`表示不能使用，`DEFAULT`表示该引擎为当前默认的存储引擎。

![SHOW ENGINES](http://c.biancheng.net/uploads/allimg/190222/4-1Z2221K006125.gif)

![MySQL插件式存储引擎体系结构](https://github.com/WenzelLin/knowledge-base/new/master/SQL/MySQL/MySQL插件式存储引擎体系结构.jpg?raw=true)
  
![MySQL提供的存储引擎](https://github.com/WenzelLin/knowledge-base/new/master/SQL/MySQL/MySQL提供的存储引擎.jpg?raw=true)

* Innodb引擎
  该存储引擎为MySQL表提供了ACID事务支持、系统崩溃修复能力和多版本并发控制（即MVCC Multi-Version Concurrency Control）的行级锁;该引擎支持自增长列（auto_increment）,自增长列的值不能为空，如果在使用的时候为空则自动从现有值开始增值，如果有但是比现在的还大，则直接保存这个值; 该引擎存储引擎支持外键（foreign key） ,外键所在的表称为子表而所依赖的表称为父表。该引擎在5.5后的MySQL数据库中为默认存储引擎。

  Innodb引擎提供了对数据库ACID事务的支持，并且还提供了行级锁和外键的约束。它的设计的目标就是处理大数据容量的数据库系统。
  
  当需要使用数据库的事务时，该引擎就是首选。由于锁的粒度小，写操作是不会锁定全表的。所以在并发度较高的场景下使用会提升效率的。
  
  大容量的数据集时趋向于选择Innodb。因为它支持事务处理和故障的恢复。Innodb可以利用数据日志来进行数据的恢复。主键的查询在Innodb也是比较快的。
  
  Innodb引擎的索引的数据结构是B+树，其数据结构中存储的都是实际的数据，这种索引被称为聚集索引。
    
* MyIASM引擎
  
  MyIASM引擎是MySql的默认引擎，但不提供事务的支持，也不支持行级锁和外键。
  
  当执行Insert插入和Update更新语句时，即执行写操作的时候需要锁定这个表。
  
  如果表的读操作远远多于写操作时，并且不需要事务的支持的，可以将MyIASM作为数据库引擎的首先。
  
  大批量的插入语句时（这里是INSERT语句）在MyIASM引擎中执行的比较的快，但是UPDATE语句在Innodb下执行的会比较的快，尤其是在并发量大的时候。

  MyIASM引擎索引的数据结构是B+树，其数据结构中存储的内容实际上是实际数据的地址值。也就是说它的索引和实际数据是分开的，只不过使用索引指向了实际数据。这种索引的模式被称为非聚集索引。
  
  MyISAM类型的表支持三种不同的存储结构：静态型、动态型、压缩型。
  
  * 静态型
  
    指定义的表列的大小是固定（即不含有：xblob、xtext、varchar等长度可变的数据类型），这样MySQL就会自动使用静态MyISAM格式。使用静态格式的表的性能比较高，因为在维护和访问以预定格式存储数据时需要的开销很低；但这种高性能是以空间为代价换来的，因为在定义的时候是固定的，所以不管列中的值有多大，都会以最大值为准，占据了整个空间。
  
  * 动态型
    
    如果列（即使只有一列）定义为动态的（xblob, xtext, varchar等数据类型），这时MyISAM就自动使用动态型，虽然动态型的表占用了比静态型表较少的空间，但带来了性能的降低，因为如果某个字段的内容发生改变则其位置很可能需要移动，这样就会导致碎片的产生，随着数据变化的增多，碎片也随之增加，数据访问性能会随之降低。
    
    对于因碎片增加而降低数据访问性这个问题，有两种解决办法：
    
    > a、尽可能使用静态数据类型；  
    > b、经常使用optimize table table_name语句整理表的碎片，恢复由于表数据的更新和删除导致的空间丢失。如果存储引擎不支持 optimize table table_name则可以转储并重新加载数据，这样也可以减少碎片；
  
  * 压缩型
  
    如果在数据库中创建在整个生命周期内只读的表，则应该使用MyISAM的压缩型表来减少空间的占用。
        
* ISAM

* HEAP（也称为MEMORY）

* CSV（Comma-Separated Values逗号分隔值）

* BLACKHOLE（黑洞引擎）

* ARCHIVE

* PERFORMANCE_SCHEMA
  
* Berkeley（BDB）

* Merge

* Federated

* Cluster/NDB

# 如何选择 MySQL 存储引擎

不同的存储引擎都有各自的特点，以适应不同的需求，如表所示。为了做出选择，首先要考虑每一个存储引擎提供了哪些不同的功能。

功能|MylSAM|MEMORY|InnoDB|Archive
:--|:--:|:--:|:--:|:--:
存储限制|256TB|RAM|64TB|None
支持事务|No|No|Yes|No
支持全文索引|Yes|No|No|No
支持树索引|Yes|Yes|Yes|No
支持哈希索引|No|Yes|No|No
支持数据缓存|No|N/A|Yes|No
支持外键|No|No|Yes|No

可以根据以下的原则来选择 MySQL 存储引擎：
* 如果要提供提交、回滚和恢复的事务安全（ACID 兼容）能力，并要求实现并发控制，InnoDB 是一个很好的选择。
* 如果数据表主要用来插入和查询记录，则 MyISAM 引擎提供较高的处理效率。
* 如果只是临时存放数据，数据量不大，并且不需要较高的数据安全性，可以选择将数据保存在内存的 MEMORY 引擎中，MySQL 中使用该引擎作为临时表，存放查询的中间结果。
* 如果只有 INSERT 和 SELECT 操作，可以选择Archive 引擎，Archive 存储引擎支持高并发的插入操作，但是本身并不是事务安全的。Archive 存储引擎非常适合存储归档数据，如记录日志信息可以使用 Archive 引擎。

# 参考

  * [mysql的常用引擎](https://www.cnblogs.com/xiaohaillong/p/6079551.html)
  
  * [MySQL中的各种引擎](https://blog.csdn.net/gaohuanjie/article/details/50944782)
  
  * [MySQL存储引擎精讲（附带各种存储引擎的对比）](http://c.biancheng.net/view/2418.html)
  
  * [mysql的存储引擎介绍与适用场景|简书](https://www.jianshu.com/p/ba1fbe96257b)
  
  * [MySql数据引擎简介与选择方法|脚本之家](https://www.jb51.net/article/31892.htm)
