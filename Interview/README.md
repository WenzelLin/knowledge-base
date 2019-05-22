# 一

## 第一题：谈谈final,finally,finalize的区别？

final 可以用来修饰类、方法、变量，分别有不同的意义，final 修饰的 class 代表不可以继承扩展，final 的变量是不可以修改的，而 final 的方法也是不可以重写的（override）。

finally 则是 Java 保证重点代码一定要被执行的一种机制。我们可以使用 try-finally 或者 try-catch-finally 来进行类似关闭 JDBC 连接、保证 unlock 锁等动作。

finalize是基础类 java.lang.Object 的一个方法，它的设计目的是保证对象在被垃圾收集前完成特定资源的回收。finalize 机制现在已经不推荐使用，并且在 JDK 9 开始被标记为 deprecated。

## 第二题：java8的新特性你熟悉吗？

新特性有： Lambda 表达式，函数式接口，方法与构造函数引用，Filter 过滤。在这里小编就简单列举几个例子，有兴趣的小伙伴可以下来就java8的新特性多多了解一下，这个题目被问到的概率很高哟！

## 第三题：hashmap和hashtable的区别？

map在编码的时候，使用频率非常高，所以问到的概率也很高。

1.hashmap可以看做是hashtable的替代 者,HashMap的Value和Key都可为NULL,而HashTable不可。

2.HashTable是线程同步的,而HashMap不是.

3.HashTable用Iterator遍历,HashMap用Enumeration遍历.

4.HashTable 中hash数组默认大小是11，增加的方式是 old*2+1。

5.HashMap中hash数组的默认大小是16，而且一定是2的指数。计算index的方 法不同,HashTable直接利用hashcode()得出,HashMap对hashcode重新计算得出.

## 第四题：collection和collections的区别？

这个比较简单，大家应该都知道；collection是结合类的上级接口,子接口有List和Set等,Collections是java.util下的一个工具类,提供一些列静态方法对集合搜索排序线程同步化等。

## 第五题：gc是什么?gc的算法有哪些？为什么要有gc？

GC 即 garbage collection(垃圾收集),是JAVA用于回收内存的一种方式。主要的实现方法有引用计数,标记回收,复制清除。GC可以避免内存泄露和堆栈溢出,有效提高内存的利用效率,同时将程序员从繁琐的内存管理中释放出来.

## 第六题：overload和override的区别？

方法重载是指同一个类中的多个方法具有相同的名字,但这些方法具有不同的参数列表,即参数的数量或参数类型不能完全相同

方法重写是存在子父类之间的,子类定义的方法与父类中的方法具有相同的方法名字,相同的参数表和相同的返回类型注:(1)子类中不能重写父类中的final方法(2)子类中必须重写父类中的abstract方法

## 第七题：list,set,map是否继承自collection接口?

list和ste都继承自​collection.不包括map，map和collection属于一个级别。

## 第八题：sleep()和wait()有什么区别?

这个是弄线程的最爱，好多人多少知道一些，但是面试的时候，不能够很好的回答，让技术面试瞬间对你的印象降低一大截。

1,sleep()是java.lang.Thread中的静态方法,wait()是java.lang.Object中的方法

2,sleep()用作当前线程阻塞自己,并在制定时间后恢复,wait()用于当前线程决定其他线程阻塞,是线程通信的表现.

3,sleep()不释放资源,wait()释放资源.

4，sleep()必须捕获异常,而wait()不需要.

## 第九题:谈谈你对spring中ioc和aop的理解？

回答思路：1.何为IOC和AOP->2.实现原理->3.项目中如何使用。

IOC：控制反转；spring对这些程序中相互依赖对象的创建和协调工作都交由Spring容器来实现，当某个对象需要其他协作对象时，由Spring动态的通过依赖注入(DI, Dependency Injection)的方式来提供协作对象，其只需要关注业务本身的逻辑即可。

AOP：面向切面编程；AOP把系统分为两部分：核心关注点和横切关注点。业务的核心处理流程为核心关注点，与之相对的诸如上面提到的权限认证、日志、事务等则为横切关注点。AOP思想的作用在于分离系统中的各种关注点，进一步解耦模块间的相互依赖，提高模块的重用性。

## 第十题：谈谈你对SpringBoot和SpringCloud的理解?

SpringCloud是Spring为微服务架构思想做的一个一站式实现。微服务其实就是一个概念、一个项目开发的架构思想。SpringCloud是微服务架构的一种java实现。

SpringCloud是基于SpringBoot的一套实现微服务的框架。它提供了微服务开发所需的配置管理、服务发现、断路器、智能路由、微代理、控制总线、全局锁、决策竞选、分布式会话和集群状态管理等组件。最重要的是，跟SpringBoot框架一起使用的话，会让你开发微服务架构的云服务非常方便。

SpringCloud五大核心组件：

服务注册发现-Netflix Eureka

配置中心 - spring cloud config

负载均衡-Netflix Ribbon

断路器 - Netflix Hystrix

路由(网关) - Netflix Zuul

# 二

## 问题：Java支持哪种参数传递类型?

答案：Java参数都是进行传值。对于对象而言，传递的值是对象的引用，也就是说原始引用和参数引用的那个拷贝，都是指向同一个对象。

## 问题：对象封装的原则是什么?

答案：封装是将数据及操作数据的代码绑定到一个独立的单元。这样保障了数据的安全，防止外部代码的错误使用。对象允许程序和数据进行封装，以减少潜在的干涉。对封装的另一个理解是作为数据及代码的保护层，防止保护层外代码的随意访问。

## 问题：你怎么理解变量?

答案：变量是一块命名的内存区域，以便程序进行访问。变量用来存储数据，随着程序的执行，存储的数据也可能跟着改变。

## 问题：数值提升是什么?

答案：数值提升是指数据从一个较小的数据类型转换成为一个更大的数据类型，以便进行整型或者浮点型运算。在数值提升的过程中，byte,char,short值会被转化成int类型。需要的时候int类型也可能被提升成long。long和float则有可能会被转换成double类型。

## 问题：Java的类型转化是什么?

答案：从一个数据类型转换成另一个数据类型叫做类型转换。Java有两种类型转换的方式，一个是显式的类型转换，一个是隐式的。

## 问题：main方法的参数里面，字符串数组的第一个参数是什么?

答案：数组是空的，没有任何元素。不像C或者C++，第一个元素默认是程序名。如果命令行没有提供任何参数的话，main方法中的String数组为空,但不是null。

## 问题：怎么判断数组是null还是为空?

答案：输出array.length的值，如果是0,说明数组为空。如果是null的话，会抛出空指针异常。

## 问题：程序中可以允许多个类同时拥有都有main方法吗?

答案：可以。当程序运行的时候，我们会指定运行的类名。JVM只会在你指定的类中查找main方法。因此多个类拥有main方法并不存在命名冲突的问题。

## 问题：静态变量在什么时候加载?编译期还是运行期?静态代码块加载的时机呢?

答案：当类加载器将类加载到JVM中的时候就会创建静态变量，这跟对象是否创建无关。静态变量加载的时候就会分配内存空间。静态代码块的代码只会在类第一次初始化的时候执行一次。一个类可以有多个静态代码块，它并不是类的成员，也没有返回值，并且不能直接调用。静态代码块不能包含this或者super,它们通常被用初始化静态变量。

# 三

## J2SE基础：

  1. 九种基本数据类型的大小，以及他们的封装类。

  2. Switch能否用string做参数？

  3. equals与==的区别。

  4. Object有哪些公用方法？

  5. Java的四种引用，强弱软虚，用到的场景。

  6. Hashcode的作用。

  7. ArrayList、LinkedList、Vector的区别。

  8. String、StringBuffer与StringBuilder的区别。

  9. Map、Set、List、Queue、Stack的特点与用法。

  10. HashMap和HashTable的区别。

  11. HashMap和ConcurrentHashMap的区别，HashMap的底层源码。

  12. TreeMap、HashMap、LindedHashMap的区别。

  13. Collection包结构，与Collections的区别。

  14. try catch finally，try里有return，finally还执行么？

  15. Excption与Error包结构。OOM你遇到过哪些情况，SOF你遇到过哪些情况。

  16. Java面向对象的三个特征与含义。

  17. Override和Overload的含义去区别。

  18. Interface与abstract类的区别。

  19. Static class 与non static class的区别。

  20. java多态的实现原理。

  21. 实现多线程的两种方法：Thread与Runable。

  22. 线程同步的方法：sychronized、lock、reentrantLock等。

  23. 锁的等级：方法锁、对象锁、类锁。

  24. 写出生产者消费者模式。

  25. ThreadLocal的设计理念与作用。

  26. ThreadPool用法与优势。

  27. Concurrent包里的其他东西：ArrayBlockingQueue、CountDownLatch等等。

  28. wait()和sleep()的区别。

  29. foreach与正常for循环效率对比。

  30. Java IO与NIO。

  31. 反射的作用于原理。

  32. 泛型常用特点，List<String>能否转为List<Object>。

  33. 解析XML的几种方式的原理与特点：DOM、SAX、PULL。

  34. Java与C++对比。

  35. Java1.7与1.8新特性。

  36. 设计模式：单例、工厂、适配器、责任链、观察者等等。

  37. JNI的使用。

## JVM：

  1. 内存模型以及分区，需要详细到每个区放什么。

  2. 堆里面的分区：Eden，survival from to，老年代，各自的特点。

  3. 对象创建方法，对象的内存分配，对象的访问定位。

  4. GC的两种判定方法：引用计数与引用链。

  5. GC的三种收集方法：标记清除、标记整理、复制算法的原理与特点，分别用在什么地方，如果让你优化收集方法，有什么思路？

  6. GC收集器有哪些？CMS收集器与G1收集器的特点。

  7. Minor GC与Full GC分别在什么时候发生？

  8. 几种常用的内存调试工具：jmap、jstack、jconsole。

  9. 类加载的五个过程：加载、验证、准备、解析、初始化。

  10. 双亲委派模型：Bootstrap ClassLoader、Extension ClassLoader、ApplicationClassLoader。

  11. 分派：静态分派与动态分派。

  >（来源：面试心得与总结---BAT、网易、蘑菇街）

## 总体来说java考察内容包括以下这些：

  1，面向对象的一些基本概念：继承，多态之类的

  2， 抽象类和接口

  3， 静态类，内部类

  4， Java集合类，同步和非同步

  5， Java类加载机制

  6， Java内存模型和垃圾回收算法

  7， 线程同步机制（voliate,synchronized,重入锁，threadlocal），线程间通信（wait,notify）

  8， 异常处理

  9， 多线程同步问题，生产者消费者，读者写者，哲学家就餐，用java实现

  10， 了解java中设计模式的思想，用了哪些设计模式，有什么好处

如果可以对于上边的问题，逐一搜资料进行专题突破，不仅对面试有效，也能帮助java基础不够扎实的同学扎实基础。

# 四

## 1.HashMap和Hashtable的区别。

都属于Map接口的类，实现了将惟一键映射到特定的值上。

HashMap类没有分类或者排序。它允许一个 null 键和多个 null 值。

Hashtable 类似于 HashMap，但是不允许 null 键和 null 值。它也比 HashMap 慢，因为它是同步的。

## 2.&和&&的区别。

&是位运算符。&&是布尔逻辑运算符。

## 3.Collection和 Collections的区别。

Collection是个java.util下的接口，它是各种集合结构的父接口。

Collections是个java.util下的类，它包含有各种有关集合操作的静态方法。

## 4.什么时候用assert。

断言是一个包含布尔表达式的语句，在执行这个语句时假定该表达式为 true。

如果表达式计算为 false，那么系统会报告一个 Assertionerror。它用于调试目的：

assert(a > 0); // throws an Assertionerror if a <= 0

断言可以有两种形式：

assert Expression1 ;

assert Expression1 : Expression2 ;

Expression1 应该总是产生一个布尔值。

Expression2 可以是得出一个值的任意表达式。这个值用于生成显示更多调试

信息的 String 消息。

断言在默认情况下是禁用的。要在编译时启用断言，需要使用 source 1.4 标记：

javac -source 1.4 Test.java

要在运行时启用断言，可使用 -enableassertions 或者 -ea 标记。

要在运行时选择禁用断言，可使用 -da 或者 -disableassertions 标记。

要系统类中启用断言，可使用 -esa 或者 -dsa 标记。还可以在包的基础上启用或者禁用断言。

可以在预计正常情况下不会到达的任何位置上放置断言。断言可以用于验证传递给私有方法的参数。不过，断言不应该用于验证传递给公有方法的参数，因为不管是否启用了断言，公有方法都必须检查其参数。不过，既可以在公有方法中，也可以在非公有方法中利用断言测试后置条件。另外，断言不应该以任何方式改变程序的状态。

## 5.GC是什么? 为什么要有GC? (基础)。

GC是垃圾收集器。Java 程序员不用担心内存管理，因为垃圾收集器会自动进行管理。要请求垃圾收集，可以调用下面的方法之一：

System.gc()

Runtime.getRuntime().gc()

## 6.String s = new String("xyz");创建了几个String Object?

两个对象，一个是“xyz”,一个是指向“xyz”的引用对象s。

## 7.Math.round(11.5)等於多少? Math.round(-11.5)等於多少?

Math.round(11.5)返回（long）12，Math.round(-11.5)返回（long）-11;

## 8.short s1 = 1; s1 = s1 + 1;有什么错? short s1 = 1; s1 += 1;有什么错?

short s1 = 1; s1 = s1 + 1;有错，

s1是short型，s1+1是int型,不能显式转化为short型。

可修改为s1 =(short)(s1 + 1) 。short s1 = 1; s1 += 1正确。

## 9.sleep()和 wait() 有什么区别?

sleep()方法是使线程停止一段时间的方法。在sleep 时间间隔期满后，线程不一定立即恢复执行。这是因为在那个时刻，其它线程可能正在运行而且没有被调度为放弃执行，除非(a)“醒来”的线程具有更高的优先级 (b)正在运行的线程因为其它原因而阻塞。

wait()是线程交互时，如果线程对一个同步对象x 发出一个wait()调用，该线程会暂停执行，被调对象进入等待状态，直到被唤醒或等待时间到。

## 10.Java有没有goto?

Goto—java中的保留字，现在没有在java中使用。

# 五

* [2019年java面试官最喜欢问的问题](https://mparticle.uc.cn/article.html?app=smds-iflow&uc_param_str=frdnsnpfvecpntnwprdssskt&zzd_from=smds-iflow&&dl_type=2&cid=0&activity=1&activity2=1&enuid=AAOmWUw97AI%2Bn3k96Io2MMZ7&from_sm=ucframe#!wm_aid=01a2d9a2e7c24ee3bc45c52644cc0bd6!!wm_id=18311593dec74123a9084e509f1c9d49!!recoid=800c6a9d6a9fb3d46997254709d70a04)

* [java面试问题有哪些](https://mparticle.uc.cn/article.html?app=smds_iflow&uc_param_str=frdnsnpfvecpntnwprdssskt&zzd_from=smds_iflow&&dl_type=2&from_sm=ucframe#!wm_aid=57af5838889643b4b6be932ae3b40342!!wm_id=8b726e77bfe844f28240c916acf1cb6a!!recoid=800c6a9d6a9fb3d46997254709d70a04)

* [100+经典Java面试题及答案解析](www.codeceo.com/article/100-java-interview-question.html)

* [最近面试 Java 后端开发的感受|知乎](https://zhuanlan.zhihu.com/p/63897241)
