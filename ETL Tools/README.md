# ETL （数据仓库技术）   
  ETL，是英文Extract-Transform-Load的缩写，用来描述将数据从来源端经过抽取（extract）、转换（transform）、加载（load）至目的端的过程。
  ETL一词较常用在数据仓库，但其对象并不限于数据仓库。
  
* ETL与ELT  
  ETL所描述的过程，一般常见的作法包含ETL或是ELT（Extract-Load-Transform），并且混合使用。
  通常愈大量的数据、复杂的转换逻辑、目的端为较强运算能力的数据库，愈偏向使用ELT，以便运用目的端数据库的平行处理能力。
  
## 工具列表  
* [Kettle](http://www.kettle.net.cn/)  
  Kettle是一款国外开源的ETL工具，纯java编写，可以在Window、Linux、Unix上运行，绿色无需安装，数据抽取高效稳定。
  Kettle这个ETL工具集，它允许你管理来自不同数据库的数据，通过提供一个图形化的用户环境来描述你想做什么，而不是你想怎么做。
  Kettle中有两种脚本文件，transformation和job，transformation完成针对数据的基础转换，job则完成整个工作流的控制。
  作为Pentaho的一个重要组成部分，现在在国内项目应用上逐渐增多。
  
