
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
  
# getHibernateTemplate()

spring 中获得由spring所配置的hibernate的操作对象,然后利用此对象进行，保存，修改和删除等操作，此方法是在配置了spring以后，hibernate由spring接管，不直接使用hibernate的session了 

HibernateTemplate提供非常多的常用方法来完成基本的操作，比如通常的增加、删除、修改、查询等操作，Spring 2.0更增加对命名SQL查询的支持，也增加对分页的支持。大部分情况下，使用Hibernate的常规用法，就可完成大多数DAO对象的CRUD操作。

下面是HibernateTemplate的常用方法简介：
*      void delete(Object entity)：删除指定持久化实例
*      deleteAll(Collection entities)：删除集合内全部持久化类实例
*      find(String queryString)：根据HQL查询字符串来返回实例集合
*      findByNamedQuery(String queryName)：根据命名查询返回实例集合
*      get(Class entityClass, Serializable id)：根据主键加载特定持久化类的实例
*      save(Object entity)：保存新的实例
*      saveOrUpdate(Object entity)：根据实例状态，选择保存或者更新
*      update(Object entity)：更新实例的状态，要求entity是持久状态
*      setMaxResults(int maxResults)：设置分页的大小

getHibernateTemplate已经封装好了一些基本的方法，可以直接去用，也就是template嘛， 

而getSession只是获取一个数据工厂的session，然后大部分方法都需要自己写，加hql语句，然后用query方法执行 

# 参考
 * [Hibernate 的getHibernateTemplate()方法使用](https://blog.csdn.net/wallwind/article/details/6269094)
