
# Hibernate对象状态

* Transient 临时

  用new创建的对象。这些对象还未与数据库发生任何关系，不对应数据库的任一笔数据。Persistent对象通过调用delete方法，会变成Transient对象。

* Persistent 持久

  对象与数据库中的数据有对应关系，并且与session实例关联，并且session实例尚未关闭，则对象处于Persistent状态。

* Detached 游离

  Detached状态的对象，与数据库中具体的数据对应，但脱离session实例的管理。

## 三状态之间转换

* Null——new——>Transient

* Null——get,load,createQuery——>Transient 

* Transient——save,saveOrUpdate,persist,merge——>Persistent

* Persistent——delete——>Transient 

* Persistent ——evict,close,clear——>Detached 

* Detached——delete——>Transient 

* Detached——update,saveOrUpdate,lock,merge,replicate——Persistent 

## get(),load()方法的区别

  当要查找的对象不存在时，get()方法返回null，load()方法抛出异常

## update(),lock()方法的区别

  Detached对象用update()与session重新关联变成Persistent状态时，关联前后对对象进行的修改，在commit时都会更新到数据库；而用lock()与session重新关联，在commit的时候，只会更新lock()修改的数据到数据库。

# Hibernate中5个核心接口

* Configuration 接口

  负责创建及启动hibernate，用于创建SessionFactory

* SessionFactory 接口

  一个SessionFactory对应一个数据源存储，即一个数据库对应一个SessionFactory。SessionFactory用于创建Session对象。SessionFactory是线程安全的，可以多个线程共享访问。

* Session 接口

  hibernate常用接口，用于操作数据库数据（增删改查）。Session不是线程安全的，不能多线程共享访问。

* Query 接口

  用于查询数据库数据。

* Transaction 接口

  hibernate事务接口，封装了底层的事务操作。


# Hibernate的5种锁模式

* LovkMode.NONE

  先在cache中查询，如果没有，再到db加载，无锁机制
  
* LockMode.READ

  不管cache有没有，都去db查询。hibernate读取db数据记录时，自动获取该锁。
  
* LockMode.UPGRADE

  不管cache有没有，都去db查询，并对查询的数据加锁，若数据的锁被其他事务持有，则当前事务一直等待到加上锁为止。利用数据库的for update加锁。
  
* LockMode.UPGRADE_NOWAIT

  不管cache有没有，都去db查询，并对查询的数据加锁，若数据的锁被其他事务持有，则当前事务立即返回。
  
* LockMode.WRITE

  hibernate做insert，update，delete时，会自动使用该模式（内部使用）。
  
