# java 知识

* [Java数字格式化](https://blog.csdn.net/zhengbo0/article/details/6967601)

* [Schedule 定时器](https://github.com/WenzelLin/knowledge-base/blob/master/Java/Schedule(%E5%AE%9A%E6%97%B6%E5%99%A8).md)  

* [Appelt](https://github.com/WenzelLin/knowledge-base/blob/master/Java/Applet.md)

* [JMS](https://github.com/WenzelLin/knowledge-base/blob/master/Java/JMS.md)

* [Thread-Pool](https://github.com/WenzelLin/knowledge-base/blob/master/Java/Thread-Pool.md)

* [NewWork Request 网络请求](https://github.com/WenzelLin/knowledge-base/blob/master/Java/Network/REAMDME.md)

* [Java中对数组或集合进行排序的方法](https://github.com/WenzelLin/knowledge-base/blob/master/Java/Sort.md)

* 原子操作的实现原理 CAS 总线锁 缓存锁

* HashTable的数据结构

* 解决并发问题的几种方案 synchronized volatile final lock()

* CXF调用

  CXF多次调用时，需要先清除上下文，否则会报错：
  ```
  com.sun.istack.internal.SAXException2: xxx.xxx.xxx is not known to this context
   javax.xml.bind.JAXBException: xxx.xxx.xxx is not known to this context
  ```
  解决方法，CXF调用之前，先清除上下文：
  ```
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        // 调用之前清除一下上下文
        Thread.currentThread().setContextClassLoader(cl);
        // 第一次调用
        JaxWsDynamicClientFactory.newInstance().createClient("填写wsdl路径").invoke("方法名", "方法参数1", "方法参数2");
        // 调用之前清除一下上下文
        Thread.currentThread().setContextClassLoader(cl);
        // 第二次调用
        JaxWsDynamicClientFactory.newInstance().createClient("填写wsdl路径").invoke("方法名", "方法参数1", "方法参数2");
        
  ```
