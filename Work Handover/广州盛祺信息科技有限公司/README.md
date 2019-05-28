# 工作交接

## 后续需要完成的任务

### 项目库的数据分析，用到大数据的相关表的话，要加上标识之类的字段。
 
  不然就相互影响了，现在大数据的没有影响到项目库的，是因为大数据里面的数据 就没有数据而已。

  ![项目库-大数据](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E9%A1%B9%E7%9B%AE%E5%BA%93-%E5%A4%A7%E6%95%B0%E6%8D%AE.png?raw=true)

  [(Y001 大数据主页模块表数据.sql)tHomePageDashBoardModule.sql](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/(Y001%20%E5%A4%A7%E6%95%B0%E6%8D%AE%E4%B8%BB%E9%A1%B5%E6%A8%A1%E5%9D%97%E8%A1%A8%E6%95%B0%E6%8D%AE)tHomePageDashBoardModule.sql)


### 新会计制度
 [新会计制度开发要点 3.0.docx](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E6%96%B0%E4%BC%9A%E8%AE%A1%E5%88%B6%E5%BA%A6%E5%BC%80%E5%8F%91%E8%A6%81%E7%82%B9%203.0.docx)

### 项目库
 [6.0项目库管理功能设计V1.0.0(1).doc](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/6.0%E9%A1%B9%E7%9B%AE%E5%BA%93%E7%AE%A1%E7%90%86%E5%8A%9F%E8%83%BD%E8%AE%BE%E8%AE%A1V1.0.0(1).doc)

### 内控-致远OA
1，在致远上架起组织结构--单位信息、部门信息、人员信息、岗位信息等等
2，使用致远的OA功能：有哪些功能？哪些功能是我们需要的？
3，使用致远开发自己的功能：一些简单快速配置的功能，内控系统的一些功能迁移。
4，内控系统有哪些功能需要迁移到致远OA，迁移之后的功能与内控系统需要交互哪些数据？
5，致远OA无法解决的问题，优先采用外部程序解决


组织架构同步
1，获取OA的组织架构信息
2，转换为内控需要的格式
	1.列出OA中组织架构相关的表的字段的含义
	2.列出内控中组织架构相关的表的字段的含义
	3.整理两边系统各字段的对应关系，确认哪些需要同步，哪些需要做转换
	4.按照整理出来的关系进行数据转换
3，传递给内控系统

解决组织架构同步问题：
1，内控本身的组织架构不需要与OA一致
2，所有涉及到OA组织架构的数据存储的到时从OA获取到的数据
3，当OA组织架构有变动，及时更新与OA组织架构有关的数据

1，项目重新建-以陈坚的19-04-19的为准
2，阶段重新建-从19-01-01开始建
3，工时重新登-从19-01-01开始登记
4，进销存重新建-从19-01-01开始建
5，发票、回款重新录-从备份库2018-06开始
6，费用重新录-陈坚每月都有Excel数据


 [OA和内控系统近期工作.docx](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/OA%E5%92%8C%E5%86%85%E6%8E%A7%E7%B3%BB%E7%BB%9F%E8%BF%91%E6%9C%9F%E5%B7%A5%E4%BD%9C.docx)

## 已完成的工作

### 教育分类代码对比（2018与2015对比）

  [新旧表对比.xlsx](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E6%96%B0%E6%97%A7%E8%A1%A8%E5%AF%B9%E6%AF%94.xlsx) 是2018的教育分类代码和我们系统的教育分类代码（2015年左右）的映射关系。
  
  其中：
  
  A列为映射说明；
  
  B-D列为2018教育分类代码；
  
  F-K列为对应的旧教育分类代码（M-R、T-V...为可选的旧教育分类代码）

  因为发现有些映射关系存在问题，需要产品确认一下，比如：新教育分类代码按不同的规则对应了多个旧教育分类代码，新教育分类代码无法确认是否是新增的（可能改编码改名了），旧教育分类代码没有被对应（可能合并了）等等

  
  [财政部与教育部固定资产分类代码对照（大类）.xlsx](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E8%B4%A2%E6%94%BF%E9%83%A8%E4%B8%8E%E6%95%99%E8%82%B2%E9%83%A8%E5%9B%BA%E5%AE%9A%E8%B5%84%E4%BA%A7%E5%88%86%E7%B1%BB%E4%BB%A3%E7%A0%81%E5%AF%B9%E7%85%A7%EF%BC%88%E5%A4%A7%E7%B1%BB%EF%BC%89.xlsx)、
  [2018版教育部固定资产分类代码表及财政分类对应关系.pdf](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/2018%E7%89%88%E6%95%99%E8%82%B2%E9%83%A8%E5%9B%BA%E5%AE%9A%E8%B5%84%E4%BA%A7%E5%88%86%E7%B1%BB%E4%BB%A3%E7%A0%81%E8%A1%A8%E5%8F%8A%E8%B4%A2%E6%94%BF%E5%88%86%E7%B1%BB%E5%AF%B9%E5%BA%94%E5%85%B3%E7%B3%BB.pdf)、
  [中华人民共和国教育行业标准（固定资产）.docx](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E4%B8%AD%E5%8D%8E%E4%BA%BA%E6%B0%91%E5%85%B1%E5%92%8C%E5%9B%BD%E6%95%99%E8%82%B2%E8%A1%8C%E4%B8%9A%E6%A0%87%E5%87%86%EF%BC%88%E5%9B%BA%E5%AE%9A%E8%B5%84%E4%BA%A7%EF%BC%89.docx) 为2018教育分类代码内容，word与pdf为同样内容。

### 资产数据治理

### 资产类别调整

“资产类别调整”功能，在资产做类别调整时，会在“资产调整历史表tAssetRegistAdjustHistory”中存储当前资产，以便完成调整后可以找回调整前的资产数据；
因此，当“资产表tAssetRegist”的表结构有变化时，需要同时维护
“资产调整历史表tAssetRegistAdjustHistory”（结构脚本、历史数据处理脚本，一般不需要索引信息）
、framework.modules.assetregist.domain.AssetRegistAdjustHistory.java
及framework/modules/assetregist/domain/AssetRegistAdjustHistory.hbm.xml。

### 行政学院对接
[行政学院-接口对接3.0.zip](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E8%A1%8C%E6%94%BF%E5%AD%A6%E9%99%A2-%E6%8E%A5%E5%8F%A3%E5%AF%B9%E6%8E%A53.0.zip)
[资产管理系统对接行政学院CRP系统.doc](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/%E8%B5%84%E4%BA%A7%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F%E5%AF%B9%E6%8E%A5%E8%A1%8C%E6%94%BF%E5%AD%A6%E9%99%A2CRP%E7%B3%BB%E7%BB%9F.doc)

### 花都报表

### 卡片模板代码调整

  [禅道|4071 获取卡片模板中需要校验的代码的修改](http://192.168.200.90:8999/zentao/bug-view-4071.html)

### 数据同步

  [禅道|2983 4.3系统到6.0系统的同步功能](http://192.168.200.90:8999/zentao/bug-view-2983.html)
  
  [禅道|3988 6.0的数据同步要处理部门编号](http://192.168.200.90:8999/zentao/bug-view-3988.html)

### 报表离线数据下载接收 17-18年

### 资产Excel导入
  页面提供两个按钮，一个用于下载服务器上现成的xls文件，一个用于下载根据配置文件[AssetXlsSetting.xml](https://github.com/WenzelLin/knowledge-base/blob/master/Work%20Handover/%E5%B9%BF%E5%B7%9E%E7%9B%9B%E7%A5%BA%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/AssetXlsSetting.xml)动态生成的xls文件。`AssetXlsSetting.xml`文件的说明见文件内的注释。

### 系统表维护

  [禅道|3974 系统表维护的修改](http://192.168.200.90:8999/zentao/bug-view-3974.html)

  [禅道|3867 卡片字段管理中字段所属资产大类的显示问题](http://192.168.200.90:8999/zentao/bug-view-3867.html)
  
  [禅道|3448 系统表维护的表中的列不参与同步相关的检查](http://192.168.200.90:8999/zentao/bug-view-3448.html)
  
  [禅道|2991 [重要]数据同步导入时，部门表的需要作为非业务表进行特殊处理](http://192.168.200.90:8999/zentao/bug-view-2991.html)

### 资产处置接收
  资产处置接收时，资产数据的校验是直接调用资产入库表的，也就是说页面的错误提示与资产的校验息息相关。
