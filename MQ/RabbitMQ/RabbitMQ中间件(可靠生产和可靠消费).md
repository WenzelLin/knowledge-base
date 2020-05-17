## 课程目标

目标1: SpringBoot整合RabbitMQ

目标2: RabbitMQ的常见开发模式

目标3: 如何保证消息的可靠生产和可靠投递

目标4: 什么是死信队列



## 01、MQ使用场景及相关产品

#### 1.1 MQ使用场景

消息中间件是分布式系统中重要的组件，主要解决应用**解耦，异步消息，流量削锋**等问题，实现高性能，高可用，可伸缩性的系统架构。

**行业潜规则: 读多写少用缓存（Redis）, 写多读少用队列（MQ）**

- **解耦**: 系统A在代码中直接调用系统B和系统C的代码，如果将来D系统接入，系统A还需要修改代码，过于麻烦。
- **异步**: 将消息写入消息队列，非必要的业务逻辑以异步的方式运行，加快响应速度。
- **削峰**: 并发量大的时候，所有的请求直接怼到数据库，造成数据库连接异常。



##### 1.1.1 同步异步问题

+ **串行方式(同步)**：将订单信息写入数据库成功后，发送注册邮件，再发送注册短信。以上三个任务全部完成后，返回给客户端

  ![1559265837234](./assets/1559265837234.png) 

  ```java
  public void makeOrder(){
      // 1 :保存订单 
      orderService.saveOrder();
      
      // 2： 发送短信服务
      messageService.sendSMS("order"); //1-2s
      // 3： 发送email服务
      emailService.sendEmail("order"); //1-2s
      // 4： 发送短信服务
      appServicd.sendApp("order");     //1-2s  
  }
  ```

+ **并行方式(异步)**：将订单信息写入数据库成功后，发送注册邮件的同时，发送注册短信。以上三个任务完成后，返回给客户端。与串行的差别是，并行的方式可以提高处理的时间 

  ![1559266101385](./assets/1559266101385.png) 

  ```java
  public void makeOrder(){
   	// 1 :保存订单
      orderService.saveOrder();
      
      theadpool.submit(new Callable<Object>{
           public Object call(){
               // 2： 发送短信服务  
      		 messageService.sendSMS("order");
           }
      });
    
      theadpool.submit(new Callable<Object>{
           public Object call(){
               // 3： 发送email服务
      		emailService.sendEmail("order");
           }
      });
      
      theadpool.submit(new Callable<Object>{
           public Object call(){
               // 4： 发送短信服务
      		appService.sendApp("order");
           }
      });
  }
  ```

  ![1559266188838](./assets/1559266188838.png) 

  按照以上约定，用户的响应时间相当于是订单信息写入数据库的时间，也就是50毫秒。注册邮件，发送短信写入消息队列后，直接返回，因此写入消息队列的速度很快，基本可以忽略，因此用户的响应时间可能是50毫秒。因此架构改变后，系统的吞吐量提高到每秒20 QPS。比串行提高了3倍，比并行提高了两倍。

  ```java
  public void makeOrder(){
      // 1 :保存订单 
      orderService.saveOrder();
      
      rabbitTemplate.convertSend("ex","2","消息内容");
  }
  ```



##### 1.1.2 高内聚低耦合(解耦)

![1559266729157](./assets/1559266729157.png) 

##### 1.1.3 流量削峰(限流)

![1559266764973](./assets/1559266764973.png) 

![1559270864850](./assets/1559270864850.png) 

#### 1.2 MQ相关产品

MQ产品还是相当多，目前市场上比较热门的消息中间件产品:

+ RabbitMQ(最好的)
+ ActiveMQ
+ RocketMQ
+ Kafka
+ ZeroMQ
+ MetaMQ



## 02、RabbitMQ：简单概述

> 目标: 了解什么是RabbitMQ 

#### 2.1 简介

RabbitMQ是一个开源的消息队列服务器 ，用来通过普通协议在完全不同的应用之间共享数据，Rabbitmq是使用Erlang（交换机）语言（数据传递）来编写的，并且Rabbitmq是基于AMQP协议是一种规范和约束)的。开源做到跨平台机制。 

- 开源，性能优秀，稳定性好
- 提供可靠的消息投递模式（confirm）,返回模式（return）
- 与Spring的AMQP完美整合，API丰富 
- 集群模式丰富(mirror rabbitmq)，表达式配置，HA模式，镜像队列模型 
- 保证数据不丢失的前提做到高可用性。

 使用的企业: 滴滴，美团，头条，去哪儿等。

#### 2.2 AMQP

AMQP全称：Advanced Message Queuing Protocol(高级消息队列协议)。

协议是标准是规范：

- 约束
- 告诉这些必须有那些角色，每个角色有什么样子功能。

是具有现代特性的二进制协议，是一个提供统一消息服务的应用层标准高级消息队列协议，是应用协议的一个开发标准，为面向消息的中间件设计。

![image-20191121221007541](./assets/image-20191121221007541.png)

**核心概念：**

**Server**：又称Broker,接受客户端的连接，实现AMQP实体服务。(安装rabbitmq-server)

**Connection**：连接，应用程序与Broker的网络连接(TCP/IP 三次握手和四次挥手)

**Channel**：网络信道，几乎所有的操作都在Channel中进行，Channel是进行消息读写的通道，客户端可以建立对各Channel，每个Channel代表一个会话任务。

**Message**: 消息, 服务与应用程序之间传送的数据，由Properties和body组成，Properties可是对消息进行修饰，比如消息的优先级，延迟等高级特性，Body则就是消息体的内容。

**Virtual Host**: 虚拟地址，用于进行逻辑隔离，最上层的消息路由，一个虚拟主机理由可以有若干个Exhange和Queue，同一个虚拟主机里面不能有相同名字的Exchange 

**Exchange**：交换机，接受消息，根据路由键发送消息到绑定的队列。(不具备消息存储的能力)

**Bindings**：Exchange和Queue之间的虚拟连接，binding中可以保护多个routing key.

**Routing key**：是一个路由规则，虚拟机可以用它来确定如何路由一个特定消息。

**Queue**：队列：也成为Message Queue,消息队列，保存消息并将它们转发给消费者。



**RabbitMQ整体架构是什么样子的？**

![image-20191121221937567](./assets/image-20191121221937567.png)

消息流转图：

![image-20191121222015754](./assets/image-20191121222015754.png)



## 03、Docker：安装RabbitMQ

> 目标: 使用docker安装RabbitMQ

#### 3.1 安装Docker

环境要求: Linux环境中的Centos7.x以上版本 + 联网

安装命令:

```shell
（1）yum 包更新到最新
> yum update

（2）安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
> yum install -y yum-utils device-mapper-persistent-data lvm2

（3）设置yum源为阿里云
> yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

（4）安装docker
> yum install docker-ce -y

（5）安装后查看docker版本
> docker -v
```

![1586315034361](assets/1586315034361.png)  

#### 3.2 设置ustc镜像源

ustc是老牌的linux镜像服务提供者了，还在遥远的ubuntu 5.04版本的时候就在用。ustc的docker镜像加速器速度很快。ustc docker mirror的优势之一就是不需要注册，是真正的公共服务。

镜像加速器: <https://lug.ustc.edu.cn/wiki/mirrors/help/docker>

```shell
# 编辑该文件：
mkdir -p /etc/docker
vi /etc/docker/daemon.json  

# 在该文件中输入如下内容：
{
"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}

# 配置多个如下：
{
"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
"registry-mirrors": ["https://0wrdwnn6.mirror.aliyuncs.com"]
}
```

**注意: 需要重启docker服务:** systemctl restart docker

#### 3.2 安装RabbitMQ

+ 拉取rabbitmq镜像

  ```shell
  docker pull rabbitmq:management
  ```

+ 创建并运行容器

  ```shell
  docker run -di --name myrabbit -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 15672:15672 -p 5672:5672 -p 25672:25672 -p 61613:61613 -p 1883:1883 rabbitmq:management
  ```

+ 其它容器命令

  ```shell
  docker start myrabbit 启动
  docker stop myrabbit 暂停
  docker restart myrabbit 重启
  docker logs -f myrabbit 查看启动日志
  ```

+ 访问RabbitMQ管理控制台: http://192.168.12.132:15672

  ![1586315331658](assets/1586315331658.png)  

+ 相关错误

  **提示：Docker报错 WARNING: IPv4 forwarding is disabled. Networking will not work.**

  解决办法:

  ```txt
  vim  /usr/lib/sysctl.d/00-system.conf
  # 添加下面配置
  net.ipv4.ip_forward=1
  
  # 重启network服务
  systemctl restart network
  ```

  关闭防火墙(如果访问不了RabbitMQ管理控制台):

  ```shell
  systemctl stop firewalld
  systemctl disable firewalld
  ```



## 04、RabbitMQ：简单模式

> 目标: 了解RabbitMQ工作原理

![1586323683818](assets/1586323683818.png) 

#### 4.1 导入模块

+ 在IntelliJ IDA中导入: **rabbitmq-simple** 模块

  ![1586321840777](assets/1586321840777.png) 

  ![1586338782167](assets/1586338782167.png)  

#### 4.2 RabbitMQ工作原理

+ Debug运行消息生产者(Producer)，通过RabbitMQ管理控制台查看效果

  ![1586322192930](assets/1586322192930.png) 

  ![1586322209468](assets/1586322209468.png) 

  ![1586322478166](assets/1586322478166.png) 

  第一步：创建连接

  第二步：创建通道

  第三步：创建交换机，如果简单模式(用它自带的默认交换机)

  第四步：创建队列，完成交换机绑定队列

  **注意:**

  - **消息通过channel发布到交换机绑定的队列，队列存储消息。**

  - **Exchange通过routing key绑定Queue, 绑定关系由Bindings记录。**

**小结**

+ 简单消息有交换机与路由key吗?是什么?

  ```txt
  
  ```

  

## 05、SpringBoot：搭建RabbitMQ父工程

> 目标: 掌握SpringBoot搭建RabbitMQ父工程

**操作步骤**

+ 创建父工程(springboot-rabbitmq)

  ![1586324737941](assets/1586324737941.png) 

  ![1586324770852](assets/1586324770852.png) 

+ 配置依赖(pom.xml)

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <project xmlns="http://maven.apache.org/POM/4.0.0"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
           http://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
      <groupId>cn.itcast</groupId>
      <artifactId>springboot-rabbitmq</artifactId>
      <version>1.0-SNAPSHOT</version>
      <packaging>pom</packaging>
      <!-- 配置父级 -->
      <parent>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-parent</artifactId>
          <version>2.1.6.RELEASE</version>
      </parent>
  
      <dependencies>
          <!-- 配置web启动器 -->
          <dependency>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-starter-web</artifactId>
          </dependency>
          <!-- 配置amqp启动器 -->
          <dependency>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-starter-amqp</artifactId>
          </dependency>
          <!-- 配置test启动器 -->
          <dependency>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-starter-test</artifactId>
              <scope>test</scope>
          </dependency>
      </dependencies>
  </project>
  ```

**小结**

+ SpringBoot整合RabbitMQ需要添加哪个启动器

  ```txt
  spring-boot-starter-amqp
  ```

  

## 06、SpringBoot：工作队列模式

> 目标: 掌握SpringBoot整合RabbitMQ的工作队列模式-Work

![1586346550845](assets/1586346550845.png)  

生产消息到一个队列,多个消费者只有一个消费者能接收到消息(**竞争的消费者模式**): 用默认交换机

#### 6.1 消息生产者

+ 创建消息生产者模块: rabbitmq-producer

  ![1586392046379](assets/1586392046379.png) 

  ![1586392074982](assets/1586392074982.png)

+ 提供application.yml

  ```yaml
  # 配置tomcat端口号
  server:
    port: 9001
  
  # 配置rabbitmq
  spring:
    rabbitmq:
      host: 192.168.12.132
      port: 5672
      virtual-host: /
      username: admin
      password: admin
  ```

+ 提供消息生产者类: WorkProducer.java

  ```java
  package cn.itcast.producer;
  
  import org.springframework.amqp.rabbit.core.RabbitTemplate;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.stereotype.Component;
  
  /**
   * 工作队列模式生产者类
   */
  @Component
  public class WorkProducer {
  
      @Autowired
      private RabbitTemplate rabbitTemplate;
  //    @Autowired
  //    private AmqpTemplate amqpTemplate;
  
      public void sendMessage(){
          /**
           * String exchange: 交换机名称
           * String routingKey: 路由key(队列名称)
           * final Object object: 消息内容
           */
          rabbitTemplate.convertAndSend("", "work-queue", "工作队列模式的消息！");
      }
  }
  ```

+ 提供启动类: ProducerApplication.java

  ```java
  package cn.itcast;
  
  import org.springframework.boot.SpringApplication;
  import org.springframework.boot.autoconfigure.SpringBootApplication;
  
  /**
   * 启动类
   */
  @SpringBootApplication
  public class ProducerApplication {
  
      public static void main(String[] args){
          SpringApplication.run(ProducerApplication.class, args);
      }
  }
  ```

+ 提供测试类: ProducerTest.java

  ```java
  package cn.itcast;
  
  import cn.itcast.producer.WorkProducer;
  import org.junit.Test;
  import org.junit.runner.RunWith;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.boot.test.context.SpringBootTest;
  import org.springframework.test.context.junit4.SpringRunner;
  
  /**
   * 消息生产者测试类
   */
  @RunWith(SpringRunner.class)
  @SpringBootTest
  public class ProducerTest {
  
      @Autowired
      private WorkProducer workProducer;
  
      /** 工作队列模式 */
      @Test
      public void test1(){
          workProducer.sendMessage();
      }
  }
  ```

#### 6.2 消息消费者

+ 创建消息消费者模块: rabbitmq-consumer

  ![1586393253824](assets/1586393253824.png)  

  ![1586393284869](assets/1586393284869.png)  

+ 提供application.yml

  ```yaml
  # 配置tomcat端口号
  server:
    port: 9002
  
  # 配置rabbitmq
  spring:
    rabbitmq:
      host: 192.168.12.132
      port: 5672
      virtual-host: /
      username: admin
      password: admin
  ```

+ 提供消费者1: cn.itcast.work.Consumer1.java

  ```java
  package cn.itcast.work;
  
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  /**
   * 工作队列模式: 消费者1
   */
  @Component
  public class Consumer1 {
  
      /**
       * 消息监听方法
       * queuesToDeclare: 声明队列
       */
      @RabbitListener(queuesToDeclare = @Queue(name = "work-queue"))
      public void handlerMessage(String msg){
          System.out.println("==消费者1: " + msg);
      }
  }
  ```

+ 提供消费者2: cn.itcast.work.Consumer2.java

  ```java
  package cn.itcast.work;
  
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  /**
   * 工作队列模式: 消费者2
   */
  @Component
  public class Consumer2 {
  
      /**
       * 消息监听方法
       * queuesToDeclare: 声明队列
       */
      @RabbitListener(queuesToDeclare = @Queue(name = "work-queue"))
      public void handlerMessage(String msg){
          System.out.println("==消费者2: " + msg);
      }
  }
  ```

+ 提供启动类: ConsumerApplication.java

  ```java
  package cn.itcast;
  
  import org.springframework.boot.SpringApplication;
  import org.springframework.boot.autoconfigure.SpringBootApplication;
  
  @SpringBootApplication
  public class ConsumerApplication {
  
      public static void main(String[] args){
          SpringApplication.run(ConsumerApplication.class, args);
      }
  }
  ```

#### 6.3 启动测试

+ 运行消息消费者启动类: ConsumerApplication.java

+ 运行消息生产者测试类: ProducerTest.java

  + 通道(Channels)

    ![1586395496304](assets/1586395496304.png) 

  + 队列(Queues)

    ![1586395598112](assets/1586395598112.png) 

+ 测试效果

  ![1586395654474](assets/1586395654474.png) 

  **竞争的消费者模式: 多个消费者之间采用轮询。**



## 07、SpringBoot：发布订阅模式(Fanout)

> 目标: 掌握SpringBoot整合RabbitMQ的消费模式-Fanout

![1586401061639](assets/1586401061639.png)   

生产者通过交换机,同时向多个消费者发送消息: 交换机模式采用(type=fanout)

+ 两个消费者(短信消费者、微信消费者),两个队列 绑定到 交换机

  ![1559291550929](assets/1559291550929.png)

#### 7.1 消息生产者

+ 修改application.yml

  ```yaml
  # 配置交换机名称
  order:
    fanout: order.fanout
  ```

+ 提供消息生产者类: FanoutProducer.java

  ```java
  package cn.itcast.producer;
  
  import org.springframework.amqp.rabbit.core.RabbitTemplate;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.beans.factory.annotation.Value;
  import org.springframework.stereotype.Component;
  
  import java.util.UUID;
  
  /**
   * 发布订阅模式消息生产者类
   */
  @Component
  public class FanoutProducer {
  
      @Autowired
      private RabbitTemplate rabbitTemplate;
  
      // 定义交换机名称
      @Value("${order.fanout}")
      private String exchange;
  
      /** 保存订单 */
      public void saveOrder(Long userId, Long goodsId, Integer buyNum){
          // 定义消息
          String msg = "用户: " + userId + ", 购买了商品: " + goodsId +
                  ", 订单编号: " + UUID.randomUUID().toString();
          /**
           * String exchange: 交换机名称
           * String routingKey: 路由key
           * final Object object: 消息内容
           */
          rabbitTemplate.convertAndSend(exchange, "", msg);
      }
  }
  ```

+ 修改ProducerTest.java测试类:

  ```java
  @RunWith(SpringRunner.class)
  @SpringBootTest
  public class ProducerTest {
      @Autowired
      private WorkProducer workProducer;
      @Autowired
      private FanoutProducer fanoutProducer;
  
      /** 工作队列模式 */
      @Test
      public void test1(){
          workProducer.sendMessage();
      }
      /** 发布订阅模式 */
      @Test
      public void test2(){
          fanoutProducer.saveOrder(1L, 1000L, 2);
      }
  }
  ```



#### 7.2 消息消费者 

+ 修改application.yml

  ```yaml
  # 配置交换机名称
  order:
    fanout: order.fanout
  
  # 配置队列名称
  fanout:
    sms:
      queue: fanout-sms-queue
    weixin:
      queue: fanout-weixin-queue
  ```

+ 提供短信消费者: SmsConsumer.java

  ```java
  package cn.itcast.fanout;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  /**
   * 短信消费者
   */
  @Component
  public class SmsConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列绑定到交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${fanout.sms.queue}"),
              exchange = @Exchange(name = "${order.fanout}",
                      type = ExchangeTypes.FANOUT)
      ))
      public void handlerMessage(String msg){
          System.out.println("fanout Sms接收到的消息是: " + msg);
      }
  }
  ```

+ 提供微信消费者: WeixinConsumer.java

  ```java
  package cn.itcast.fanout;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  /**
   * 微信消费者
   */
  @Component
  public class WeixinConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列绑定到交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${fanout.weixin.queue}"),
              exchange = @Exchange(name = "${order.fanout}",
                      type = ExchangeTypes.FANOUT)
      ))
      public void handlerMessage(String msg){
          System.out.println("fanout Weixin接收到的消息是: " + msg);
      }
  }
  ```


#### 7.3 启动测试

+ 运行消费者启动类: ConsumerApplication.java

+ 运行生产者测试类: ProducerTest.java

  - 交换机(Exchanges)

    ![1586398956039](assets/1586398956039.png) 

    ![1586399128199](assets/1586399128199.png) 

  - 队列(Queues)

    ![1586421646584](assets/1586421646584.png)   

+ 测试效果

  ![1586399230988](assets/1586399230988.png)  

**小结**

+ Fanout发布与订阅模式的特点?

  ```txt
  Fanout发布与订阅模式，一个生产都对应多个消费者(不能选择某个消费者)，它是没有路由key。
  ```

  

## 08、SpringBoot：路由模式(Direct)

> 目标: 掌握SpringBoot整合RabbitMQ的消息模式(direct)

路由模式它是带路由key的发布订阅模式: 路由模式 = 发布订阅模式 + 路由key 

![1586400750602](assets/1586400750602.png) 

生产者通过交换机,有选择性的向消费者发送消息: 交换机模式采用(type=direct)

- 两个消费者(info消费者、error消费者),两个队列 通过routingKey绑定到 交换机

  ![1559285777953](assets/1559285777953.png)  

#### 8.1 消息生产者

- 修改application.yml

  ```yaml
  # 配置交换机名称
  log:
    direct: log.direct
  ```

- 提供消息生产者类: DirectProducer.java

  ```java
  package cn.itcast.producer;
  
  import org.springframework.amqp.rabbit.core.RabbitTemplate;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.beans.factory.annotation.Value;
  import org.springframework.stereotype.Component;
  
  import java.util.Date;
  
  /**
   * 路由模式,消息生产者
   */
  @Component
  public class DirectProducer {
  
      @Autowired
      private RabbitTemplate rabbitTemplate;
      // 交换机名称
      @Value("${log.direct}")
      private String exchange;
  
      public void logMessage(String routingKey){
          String msg = "路由模式,时间：" + new Date();
          rabbitTemplate.convertAndSend(exchange, routingKey, msg);
      }
  }
  ```

- 修改ProducerTest.java测试类

  ```java
  @RunWith(SpringRunner.class)
  @SpringBootTest
  public class ProducerTest {
  
      @Autowired
      private WorkProducer workProducer;
      @Autowired
      private FanoutProducer fanoutProducer;
      @Autowired
      private DirectProducer directProducer;
  
      /** 工作队列模式 */
      @Test
      public void test1(){
          workProducer.sendMessage();
      }
      /** 发布订阅模式 */
      @Test
      public void test2(){
          fanoutProducer.saveOrder(1L, 1000L, 2);
      }
      /** 路由模式 */
      @Test
      public void test3(){
          directProducer.logMessage("info");
      }
  }
  ```

  

#### 8.2 消息消费者

- 修改application.yml

  ```yaml
  # 配置交换机名称
  log:
    direct: log.direct
  # 配置队列名称
  direct:
    info:
      queue: direct-info-queue
    error:
      queue: direct-error-queue
  ```

- 提供info消费者: InfoConsumer.java

  ```java
  package cn.itcast.direct;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class InfoConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${direct.info.queue}"), // 队列
              key = {"info"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("info--->接受到的消息是：" + msg);
      }
  }
  ```

- 提供error消费者: ErrorConsumer.java

  ```java
  package cn.itcast.direct;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${direct.error.queue}"), // 队列
              key = {"info","error"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("error--->接受到的消息是：" + msg);
      }
  }
  ```

#### 8.3 启动测试

- 运行消费者启动类: ConsumerApplication.java

- 运行生产者测试类: ProducerTest.java

  + 交换机(Exchanges)

    ![1586404078571](assets/1586404078571.png) 

    ![1586404124312](assets/1586404124312.png) 

  + 队列(Queues)

    ![1586421834694](assets/1586421834694.png)  

- 测试效果

  ![1586404206061](assets/1586404206061.png) 

  direct路由模式: 其实就有路由key的fanout模式。这样做的好处可以按需选择我们的消费者(灵活)。

**小结**

+ 路由direct模式,可以实现发布订阅模式fanout的效果吗?

  ```txt
  可以的，路由一样就可以。
  ```

  

## 09、SpringBoot：主题模式(Topic)

> 目标: 掌握SpringBoot整合RabbitMQ的消息模式(topic)

**主题模式**实际上与**路由模式**差不多,不同之处主题模式的routingKey可用通匹符。

![1586407158381](assets/1586407158381.png) 

生产者通过交换机,匹配路由key有选择性的向消费者发送消息: 交换机模式采用(type=topic)

+ 通匹符有两种:

  ```txt
  *: 代表匹配0-1个
  #: 代表匹配0-N个 
  ```

+ 三个消费者(info消费者、error消费者、full消费者),三个队列 通过routingKey绑定到 交换机

  ![1559289488693](assets/1559289488693.png) 

#### 9.1 消息生产者

- 修改application.yml

  ```yaml
  # 配置交换机名称
  mqlog:
    topic: mqlog.topic
  ```

- 提供消息生产者类: TopicProducer.java

  ```java
  package cn.itcast.producer;
  
  import org.springframework.amqp.rabbit.core.RabbitTemplate;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.beans.factory.annotation.Value;
  import org.springframework.stereotype.Component;
  
  import java.util.Date;
  
  /**
   * 主题匹配模式,消息生产者
   */
  @Component
  public class TopicProducer {
  
      @Autowired
      private RabbitTemplate rabbitTemplate;
      // 交换机名称
      @Value("${mqlog.topic}")
      private String exchange;
  
      public void logMessage(String routingKey){
          String msg = "主题匹配模式,时间：" + new Date();
          rabbitTemplate.convertAndSend(exchange, routingKey, msg);
      }
  }
  ```

- 修改ProducerTest.java测试类

  ```java
  @Autowired
  private TopicProducer topicProducer;
  
  /** 主题匹配模式 */
  @Test
  public void test4(){
      topicProducer.logMessage("pay.log.error");
  }
  ```

#### 9.2 消息消费者

- 修改application.yml

  ```yaml
  # 配置交换机名称
  mqlog:
    topic: mqlog.topic
  # 配置队列名称
  topic:
    info:
      queue: topic-info-queue
    error:
      queue: topic-error-queue
    full:
      queue: topic-full-queue
  ```

- 提供Info消费者: InfoLogConsumer.java

  ```java
  package cn.itcast.topic;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class InfoLogConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${topic.info.queue}"), // 队列
              key = {"*.log.info"}, // 路由key
              exchange = @Exchange(name = "${mqlog.topic}",
                                   type = ExchangeTypes.TOPIC))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("log.info--->接受到的消息是：" + msg);
      }
  }
  ```

- 提供Error消费者: ErrorLogConsumer.java

  ```java
  package cn.itcast.topic;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorLogConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${topic.error.queue}"), // 队列
              key = {"*.log.error"}, // 路由key
              exchange = @Exchange(name = "${mqlog.topic}",
                                   type = ExchangeTypes.TOPIC))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("log.error--->接受到的消息是：" + msg);
      }
  }
  ```

- 提供Full消费者: FullLogConsumer.java

  ```java
  package cn.itcast.topic;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  @Component
  public class FullLogConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${topic.full.queue}"), // 队列
              key = {"#.log.#"}, // 路由key
              exchange = @Exchange(name = "${mqlog.topic}",
                                   type = ExchangeTypes.TOPIC))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("log.full--->接受到的消息是：" + msg);
      }
  }
  ```

#### 9.3 启动测试

- 运行消费者启动类: ConsumerApplication.java

- 运行生产者测试类: ProducerTest.java

  - 交换机(Exchanges)

    ![1586409589862](assets/1586409589862.png) 

    ![1586409617545](assets/1586409617545.png) 

  - 队列(Queues)

    ![1586422082698](assets/1586422082698.png)  

- 测试效果

  ![1586409714226](assets/1586409714226.png) 

  topic主题模式: 其实就是路由key可以写通匹符的direct模式。这样做的好处可以匹配多个消费者。

**小结**

- topic主题模式,可以实现路由direct模式的效果吗?

  ```txt
  当然可以，不添加通匹符就是。
  ```



## 10、RabbitMQ：持久化问题

> 目标: 解决开发中关于消息丢失和持久化的问题。

修改durable属性: 是否持久化, true是持久化队列(默认), false不是持久化队列。

![1586422637301](assets/1586422637301.png) 

消息丢了怎么办？一般我们进行持久化。(以工作模式为例)

#### 10.1 非持久化队列

+ 删除原来的队列(work-queue)

+ 修改消费者durable属性为false

+ 启动消费者启动类

  ![1586424020523](assets/1586424020523.png) 

+ 关停消费者，运行生产者测试类

  ![1586424154930](assets/1586424154930.png) 

+ 重新启动RabbitMQ服务

  ![1586424240836](assets/1586424240836.png) 

+ 查看RabbitMQ管理控制台

  ![1586424345897](assets/1586424345897.png) 



#### 10.2 持久化队列

+ 修改消费者durable属性为true

+ 启动消费者启动类

  ![1586424471619](assets/1586424471619.png) 

+ 关停消费者，运行生产者测试类

  ![1586424541069](assets/1586424541069.png) 

+ 重新启动RabbitMQ服务

  ![1586424240836](assets/1586424240836.png) 

+ 查看RabbitMQ管理控制台

  ![1586424622407](assets/1586424622407.png) 



## 11、RabbitMQ：如何保障消息可靠生产

> 目标: 掌握RabbitMQ如何保障消息100%投递成功?

消息落库，对消息状态进行打标。做法就是把消息发送MQ一份，同时存储到数据库一份。然后进行消息的状态控制，发送成功1，发送失败0。必须结合应答ACK来完成。对于那些如果没有发送成功的消息，可以采用定时器进行轮询发送。

![image-20191122090725793](./assets/image-20191122090725793.png) 

#### 消息生产者

+ 修改application.yml

  ```yaml
  # 开启消息发送确认机制
  spring:
  	rabbitmq:
  		publisher-confirms: true
  ```

+ 修改路由模式的消息生产者: DirectProducer.java

  ```java
  package cn.itcast.producer;
  
  import org.springframework.amqp.rabbit.connection.CorrelationData;
  import org.springframework.amqp.rabbit.core.RabbitTemplate;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.beans.factory.annotation.Value;
  import org.springframework.stereotype.Component;
  
  import java.util.Date;
  
  /**
   * 路由模式,消息生产者
   */
  @Component
  public class DirectProducer {
      @Autowired
      private RabbitTemplate rabbitTemplate;
      // 交换机名称
      @Value("${log.direct}")
      private String exchange;
  
      // 定义回调确认对象
      private RabbitTemplate.ConfirmCallback confirmCallback =
                  new RabbitTemplate.ConfirmCallback() {
          // 消息发送完毕后，回调此确认方法
          @Override
          public void confirm(CorrelationData correlationData, boolean ack,
                              String cause) {
              // CorrelationData: 相关数据
              // ack: 是否确认收到(true已确认收到，false未确认收到)
              // case: 失败原因
              System.out.println("ack: " + ack);
              System.out.println("cause = " + cause);
              // 如果ack为true,代表MQ已经收到消息。
              if (ack){
                  System.out.println("消息已投递成功！");
              }else{
                  System.out.println("消息已投递失败: " + correlationData.getId());
                  // 失败的消息业务处理代码
                  // ...
              }
          }
      };
  
      public void logMessage(String routingKey){
          // 设置回调确认对象
          rabbitTemplate.setConfirmCallback(confirmCallback);
          // 消息内容
          String msg = "路由模式,时间：" + new Date();
          // 相关数据
          CorrelationData correlationData = new CorrelationData();
          correlationData.setId("1001");
          // 发送消息
          rabbitTemplate.convertAndSend(exchange, routingKey, msg, correlationData);
      }
  }
  ```

+ 运行生产者测试类

  ![1586435778109](assets/1586435778109.png) 

+ 删除log.direct交换机，再次运行生产者测试类

  ![1586436014288](assets/1586436014288.png) 

  **注意: 重新创建了交换机，以前的消息还是可以正常消费的！**

  

## 12、RabbitMQ：消费者异常死循环问题

> 目标: 了解RabbitMQ消费都异常死循环问题?

当消费者接收到消息后，肯定是要处理相关业务，如果在处理业务的过程中，由于消息数据的不正确，引发了了异常，消费者就不能正常处理这一条消息，这时会出现什么问题? 不断重发(死循环)。

**操作步骤**

+ 修改消息生产者: ProducerTest.java

  ```java
  /** 路由模式 */
  @Test
  public void test3(){
      directProducer.logMessage("error");
  }
  ```

+ 修改消息消费者: ErrorConsumer.java(制造异常)

  ```java
  package cn.itcast.direct;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${direct.error.queue}"), // 队列
              key = {"info","error"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg){
          System.out.println("================");
          // 制造异常
          int i = 10 / 0;
          System.out.println("error--->接受到的消息是：" + msg);
      }
  }
  ```

+ 测试效果:

  ![1586439879545](assets/1586439879545.png) 

  ![1586439923545](assets/1586439923545.png)  

  当消费消息出现异常时，RabbitMQ就会把这条消息重新放入到队列中继续消费，造成死循环。

  如果这个时候又生产一条消息:

  ![1586440006876](assets/1586440006876.png) 

  **注意: RabbitMQ到时积压的消息就会越来越多，RabbitMQ服务就会挂掉。**

+ 配置消费者开启重试，修改重试次数

  ```yaml
  # 配置rabbitmq
  spring:
    rabbitmq:
      listener:
        simple:
          retry:
            enabled: true # 解决消息死循环问题-启用重试
            max-attempts: 3 # 最大重试3次(默认)
  ```

+ 再次启动测试效果: 

  ![1586449916748](assets/1586449916748.png) 

  ![1586450041653](assets/1586450041653.png) 

  **说明: 消费者开启重试，设置重试次数，是解决了消费者死循环问题，但最终消息丢失了。**

   

## 13、RabbitMQ：如何保障消息可靠消费

+ 手动消息确认ACK:

  如果在处理消息的过程中，消费者在消费消息的时候服务器、网络、出现故障挂掉了，那可能这条正在处理的消息就没有完成，数据就会丢失。为了确保消息不会丢失，RabbitMQ支持消息确认ACK。

**操作步骤**

+ 修改applicaiton.yml

  ```yaml
  # 配置rabbitmq
  spring:
    rabbitmq:
      listener:
        simple:
          retry:
            enabled: true # 启用重试(解决消息死循环问题)
            max-attempts: 3 # 最大重试3次(默认)
          acknowledge-mode: manual # 开启手动ack消息确认
  ```

+ 消费者手动确认: ErrorConsumer.java

  ```java
  package cn.itcast.direct;
  
  import com.rabbitmq.client.Channel;
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.core.Message;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${direct.error.queue}"), // 队列
              key = {"info","error"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg, Channel channel,
                                 Message message){
          try {
              System.out.println("================");
              // 制造异常
              int i = 10 / 0;
              System.out.println("error--->接受到的消息是：" + msg);
              // 手动ack确认
              //参数1：deliveryTag:消息唯一传输ID
              //参数2：multiple：true: 手动批量处理，false: 手动单条处理
              channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
          }catch (Exception ex){
          }
      }
  }
  ```

+ 启动测试:

  ![1586451811274](assets/1586451811274.png) 

  ![1586451914457](assets/1586451914457.png) 

  **注意: 手动消息确认(ACK)，比启用重试次数的方式要安全，至少消息不会丢失！但会造成消息积压!**



## 14、RabbitMQ：消息重投和拒绝确认

接着上面的问题,如果这个时候消费者确实失败了(消息又不能积压)，怎么处理？

- 第1步: 采用消息重投 + 拒绝确认
- 第2步: 死信队列 + 消费预警 + 记录到redis数据库



**采用消息重投 + 拒绝确认**

+ 修改消费者代码: ErrorConsumer.java

  ```java
  package cn.itcast.direct;
  
  import com.rabbitmq.client.Channel;
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.core.Message;
  import org.springframework.amqp.rabbit.annotation.Exchange;
  import org.springframework.amqp.rabbit.annotation.Queue;
  import org.springframework.amqp.rabbit.annotation.QueueBinding;
  import org.springframework.amqp.rabbit.annotation.RabbitListener;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "${direct.error.queue}"), // 队列
              key = {"info","error"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg, Channel channel,
                                 Message message){
          try {
              System.out.println("================");
              // 制造异常
              int i = 10 / 0;
              System.out.println("error--->接受到的消息是：" + msg);
              // 手动ack确认
              // 参数1：deliveryTag:消息唯一传输ID
              // 参数2：multiple：true: 手动批量处理，false: 手动单条处理
              channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
          }catch (Exception ex){
              // 如果真得出现了异常，我们采用消息重投
              // 获取redelivered，判断是否为重投: false没有重投，true重投
              Boolean redelivered = message.getMessageProperties().getRedelivered();
              System.out.println("redelivered = " + redelivered);
              try {
                  // 判断是否为重新消费
                  if (redelivered) { // 重新消费
                      /**
                       * 拒绝确认，从队列中删除该消息，防止队列阻塞(消息堆积)
                       * boolean requeue: false不重新入队列(丢弃消息)
                       */
                      channel.basicReject(message.getMessageProperties()
                                          .getDeliveryTag(), false);
                      System.out.println("消息已丢弃了。。。");
                  } else { // 第一次消费
                      /**
                       * 消息重投，重新把消息放回队列中
                       * boolean multiple: 单条或批量
                       * boolean requeue: true重回队列
                       */
                      channel.basicNack(message.getMessageProperties()
                              .getDeliveryTag(), false, true);
                  }
              }catch (Exception e){
                  e.printStackTrace();
              }
          }
      }
  }
  ```

+ 启动测试:

  ![1586482487784](assets/1586482487784.png) 

  ![1586482547189](assets/1586482547189.png) 

  **说明: 它是解决了消息死循环消费、消息积压、但是最终消息还是丢失了！**

**小结**

+ 消息重投

  ```java
  /**
   * 消息重投，重新把消息放回队列中
   * boolean multiple: 单条或批量
   * boolean requeue: true重回队列
   */
  channel.basicNack(message.getMessageProperties()
                    .getDeliveryTag(), false, true);
  ```

+ 拒绝确认

  ```java
  /**
   * 拒绝确认，从队列中删除该消息，防止队列阻塞(消息堆积)
   * boolean requeue: false不重新入队列(丢弃消息)
   */
  channel.basicReject(message.getMessageProperties()
                      .getDeliveryTag(), false);
  ```

  

## 15、RabbitMQ：死信队列和消费预警

> 目标: 了解RabbitMQ死信队列与消费预警

#### 15.1 死信队列介绍

  当我们的业务队列处理消息失败(业务异常重试次数达到上限、消息被拒绝、消息过期、队列已满)，就会将这些消息重新投递到一个新的队列，该队列存储的都是处理失败的消息，该队列就叫死信队列DLQ(Dead Letter Queue)。

- 消息被拒绝 (basic.reject or basic.nack)

- 消息过期 TTL(Time To Live)

- 队列已满 Limit

  ![1586496737224](assets/1586496737224.png) 

#### 15.2 消息被拒绝

**操作步骤**

+ 修改application.yml

  ```yaml
  # 配置rabbitmq
  spring:
    rabbitmq:
      listener:
        simple:
          default-requeue-rejected: false # 设置为false，会重发消息到死信队列
  ```

+ 定义死信队列消费者: DeadLetterConsumer.java

  ```java
  package cn.itcast.dlq;
  
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class DeadLetterConsumer {
  
      /** 消息监听 */
      @RabbitListener(bindings = @QueueBinding(
              value = @Queue(name = "dlx-queue"),
              exchange = @Exchange(value = "dlx.exchange",
                          type = ExchangeTypes.TOPIC),
              key = "#")
      )
      public void handlerMessage(String message){
          System.out.println("死信队列接收到的消息：" + message);
      }
  }
  ```

+ 修改ErrorConsumer.java, 实现死信队列的绑定:

  ```java
  package cn.itcast.direct;
  
  import com.rabbitmq.client.Channel;
  import org.springframework.amqp.core.ExchangeTypes;
  import org.springframework.amqp.core.Message;
  import org.springframework.amqp.rabbit.annotation.*;
  import org.springframework.stereotype.Component;
  
  @Component
  public class ErrorConsumer {
  
      /**
       * 消息监听方法
       * bindings: 配置队列 通过路由key绑定到 交换机
       */
      @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "${direct.error.queue}", arguments = {
                    @Argument(name="x-dead-letter-exchange", value = "dlx.exchange"),
                    @Argument(name="x-dead-letter-routing-key", value = "xxx")}), // 队列
              key = {"info","error"}, // 路由key
              exchange = @Exchange(name = "${log.direct}",
                                   type = ExchangeTypes.DIRECT))) // 交换机
      public void handlerMessage(String msg, Channel channel,
                                 Message message){
          try {
              System.out.println("================");
              // 制造异常
              int i = 10 / 0;
              System.out.println("error--->接受到的消息是：" + msg);
              // 手动ack确认
              // 参数1：deliveryTag:消息唯一传输ID
              // 参数2：multiple：true: 手动批量处理，false: 手动单条处理
              channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
          }catch (Exception ex){
              // 如果真得出现了异常，我们采用消息重投
              // 获取redelivered，判断是否为重投: false没有重投，true重投
              Boolean redelivered = message.getMessageProperties().getRedelivered();
              System.out.println("redelivered = " + redelivered);
              try {
                  // 判断是否为重新消费
                  if (redelivered) { // 重新消费
                      /**
                       * 拒绝确认，从队列中删除该消息，防止队列阻塞(消息堆积)
                       * boolean requeue: false不重新入队列(丢弃消息)
                       */
                      channel.basicReject(message.getMessageProperties()
                                          .getDeliveryTag(), false);
                      System.out.println("消息已重新存入死信队列了。。。");
                  } else { // 第一次消费
  
                      /**
                       * 消息重投，重新把消息放回队列中
                       * boolean multiple: 单条或批量
                       * boolean requeue: true重回队列
                       */
                      channel.basicNack(message.getMessageProperties()
                              .getDeliveryTag(), false, true);
  
                  }
              }catch (Exception e){
                  e.printStackTrace();
              }
          }
      }
  }
  ```

+ 启动消息消费者测试:

  ![1586496037199](assets/1586496037199.png) 

  ![1586496146433](assets/1586496146433.png) 

+ 运行消息生产者测试类:

  ![1586496266291](assets/1586496266291.png) 

  ![1586496327938](assets/1586496327938.png) 

  说明: 消息已进入死信队列，死信队列消费者也可以消费消息，如果死信队列还不能正常消费消息，只能预警了，发短信通知相关开发人员，或 存储到Redis数据库。

#### 15.3 消息过期TTL

**操作步骤**

+ 修改ErrorConsumer.java,设置队列消息存活时长(x-message-ttl),单位:毫秒。

  ![1586496830907](assets/1586496830907.png) 

+ 删除direct-error-queue队列

  ![1586497078443](assets/1586497078443.png) 

+ 启动消费者，创建队列

+ 关闭消费者，运行消息生产者测试类

  ![1586497214111](assets/1586497214111.png) 

  等待5秒之后:

  ![1586497308058](assets/1586497308058.png) 

  **注意: 这个对于消息堆积过多，是很有效果的。**

  

#### 15.4 队列存储界限

**操作步骤**

+ 修改ErrorConsumer.java,设置队列中存储消息的最大数量(x-max-length)

  ![1586498208835](assets/1586498208835.png)  

+ 删除direct-error-queue队列

  ![1586497078443](./assets/1586497078443.png) 

+ 启动消费者，创建队列

+ 关闭消费者，运行消息生产者测试类(3次) 

  ![1586498393082](assets/1586498393082.png) 

  再运行消息生产者测试类1次:

  ![1586498494428](assets/1586498494428.png)  

  **注意: 这个对于消息堆积过多，是很有效果的。**



## 16、RabbitMQ：常见面试题总结

+ 问题1: 除了RabbitMQ有没有了解过其它的消息队列或者使用过其它消息队列？

  ```txt
  我毕竟工作二年时间，大部分情况在之前公司做业务比较多，消息队列是我们公司去年在做电商产品的加入进来。大部分的情况我使用的比较多，如果给我一点时间我去搭建的话也没什么问题，有没有了解其消息队列，有了解过kafka（入门，并且区别和定位）一点，但是还使用过，但是我自己个人觉得这些消息都差不多都要存储消息解决项目性能的。给你一点时间我去学习一下应该是没什么问题，贵公司在也在使用这技术？
  ```

+ 问题2: RabbitMQ为什么需要通道，为什么不是TCP直接通信?

  ```txt
  1、TCP的创建和销毁，开销大，创建要3次握手，销毁要4次挥手。
  
  2、如果不用信道，那应用程序就会TCP连接到Rabbit服务器，高峰时每秒成千上万连接就会造成资源的巨大浪费，而且==操作系统每秒处理tcp连接数也是有限制的，==必定造成性能瓶颈。
  
  3、信道的原理是一条线程一条信道，多条线程多条信道同用一条TCP连接，一条TCP连接可以容纳无限的信道，即使每秒成千上万的请求也不会成为性能瓶颈。
  ```

+ 问题3: RabbitMQ通过channel发送消息到队列一定要有交换机吗?

  ```txt
  对的，一定需要通过交换机才能把消息发送到队列中存储。
  如果没有指定交换机就会用默认的交换机。
  ```

+ 问题4: RabbitMQ默认采用的消息模式是什么(SpringBoot)?

  ```txt
  direct: 路由模式
  ```

+ 问题5: RabbitMQ常用的消息模式有哪些?它们有什么区别?

  ```txt
  1. 简单模块(simple)  没有交换机(1-1)
  2. 工作队列模式(work) 没有交换机(1-N, 消费者竞争关系)
  
  3. 发布订阅模式(fanout) 有交换机，没有路由key (1-N,多个消费者同时接收消息)
  4. 路由模式(direct) 有交换机，有路由key (1-N,多个消费者，根据路由key有选择性接收消息)
  5. 主题模式(topic) 有交换机，有路由key，路由key可以用通匹符 *或#
  ```

+ 问题6: RabbitMQ持久化是什么?

  ```txt
  RabbitMQ队列中的数据可以存储到磁盘。durable=true
  ```

+ 问题7: RabbitMQ如何保障消息可靠生产?

  ```txt
  1. 把消息存储到Redis数据库。(消息落库)
  
  2. 生产者在发送消息之前，设置confirmCallback回调确认对象，当消息发送成功，RabbitMQ服务会回调confirm()方法让生产者进行确认，如果ack是true就代表消息生产成功，否则生成失败。
     // 设置回调确认对象
     rabbitTemplate.setConfirmCallback(confirmCallback);
   
  3. 如果生产成功，生产者从Redis数据库删除该消息。
  
  4. 需要用到定时器，定时从Redis数据库查询消息，再次发送。
  key:kill_order  value:hash Map<String,message>
  ```

+ 问题8: RabbitMQ如何解决消费者出现异常死循环问题?

  ```txt
  1. 设置重试次数。
  2. 手动ACK消息确认。
  ```

+ 问题9: RabbitMQ如何解决消息积压问题?

  ```txt
  1. 设置消息存活时间(TTL) Time To Live
  2. 设置队列中存储消息的界限(Lim) limit
  3. 重试多次失败的消息，路由到死信队列，避免队列阻塞。
  ```

+ 问题10: RabbitMQ死信队列是什么?

  ```txt
  死信队列(DLQ): 它实际上也是一个普通的队列，只是该队列存储的消息为：过期的消息、被拒的消息、超出队列界队的消息、重试消费失败的消息。
  ```

+ 问题11: RabbitMQ如何设置消息存活时间与队列存储界限?

  ```txt
  1. 设置消息存活时间(TTL): 在创建队列时指定属性 x-message-ttl
  2. 设置队列存储界限(Lim): 在创建队列时指定属性 x-max-length
  ```

+ 问题12: RabbitMQ如何保证消息不丢失?

  ```txt
  1. 消费者开启,手动消息ACK确认机制。
  2. 消息重投。
  3. 拒绝确认的消息，在丢弃之后，需要存入死信队列。
  4. 死信队列中的消息还消费失败的话，就需要人为干预。(可以发短信进行预警)
  ```

  
