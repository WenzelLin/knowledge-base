## dos命令 batch文件

* for

* net
  
  * net user
  
  * net share
  
  * net use
  
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
