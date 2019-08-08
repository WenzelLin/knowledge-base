## dos命令 batch文件

* call 
  
  从一个bat文件里调用另一个bat时，如果不用call命令，则另一个bat执行完后，不会返回。

* sc
  
  配置服务启动方式的命令行格式：
  
  sc config 服务名称 start= auto（设置服务为自动启动） 
  
  sc config 服务名称 start= demand（设置服务为手动启动） 
  
  sc config 服务名称 start= disabled（设置服务为禁用）
  
  查看帮助：sc help config
  
  停止/启动服务的命令行格式:
  
  sc stop/start 服务名称 

* 比较运算符

  QUE(==) NQE(!=) LSS(<) LEQ(<=) GTR(>) GEQ(>=)

* if
  
  if expression (do something) else if expression (do something) else (do something)

* 获取输入

  获取用户输入并赋值给变量a
  
  set /p a=请输入：
  
  取消变量定义
  
  set somevalue=
  
* for

* net
  
  * net user
  
  * net share
  
  * net use
  
    登录时需要输入密码，查看帮助：net help use
    
    - [net use错误原因解决(精辟)（转）](https://www.cnblogs.com/zhuimengle/p/6030414.html)

* cacls

* netsh 

  * netsh firewall
    
    - window能远程，但不能ping通，需要防火墙要打开`文件和打印机共享`(`fileandprint`) netsh firewall set service fileandprint enable
    
    - [netsh配置Windows防火墙（advfirewall）](https://www.cnblogs.com/zhen656/p/4275270.html)
    
    - [netsh打开firewall的几个小命令](https://blog.csdn.net/wonitazansa1/article/details/6183495)

  * netsh interface
  
    - [dos命令行-禁用和启用本地连接](https://blog.csdn.net/Q672405097/article/details/85321162)

* schtasks
  
  - [bat设置windows计划任务](https://www.cnblogs.com/dongzhiquan/p/3231498.html)

* copy

* xcopy

* pause

* exit

## 常用变量

  * %SystemDrive% 系统盘符
  
  * %windir% 系统路径
  
  * %date% 当前日期，格式为`yyyy/MM/dd`
  
    * %date:~0,4% 当前年份
    
    * %date:~5,2% 当前月份
    
    * %date:~8,2% 当前日期

  * %~d0 当前盘符

  * %cd% 当前路径

  * %0 当前执行命令行

  * %~dp0 当前bat文件路径

  * %~sdp0 当前bat文件短路径
  
  * %0 %1 ... %9 批处理文件中可引用的参数
    
    - 批处理文件中可引用的参数为%0~%9，%0是指批处理文件的本身，也可以说是一个外部命令；%1~%9是批处理参数，也称形参
    
    - [.bat批处理（二）：%0 %1——给批处理脚本传递参数](https://blog.csdn.net/albertsh/article/details/52788106)
    
 # 参考
 
  * [DOS/BAT批处理if exist else 语句的几种用法](https://www.cnblogs.com/yang-hao/p/6003149.html)
  
  * [使用批处理设置、启动和停止服务](https://blog.csdn.net/pashine/article/details/1845036)
