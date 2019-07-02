## dos命令 batch文件

* for

* net
  
  * net user
  
  * net share
  
  * net use

* cacls

* netsh 

  * netsh firewall

  * netsh interface

* schtasks

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
