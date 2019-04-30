# 基本概念
* 什么是Web Service？  
Web Service也叫XML Web Service，是一种可以从Internet中接收请求的轻量级的独立的通信技术。
Web Service使用SOAP在Web上提供服务，利用WSDL文件对服务进行说明，通过UDDI描述服务、注册服务、动态查找并使用服务。
* 什么是XML？  
XML全称Extensible Markup Language，即拓展型标记语言，是一种置标语言。
XML是一种简单的数据存储语言，使用一系列简单的标记描述数据，而这些标记可以用方便的方式建立。
它与HTML一样，都是SGML(标准通用标记语言)。XML是Internet环境中跨平台的，依赖于内容的技术，是当前处理结构化文档信息的有力工具。
* 什么是SOAP？  
SOAP全称Simple Object Access Protocol，即简单对象访问协议，是一种简单的轻量的基于XML的数据交换协议。
它可以在Web上交互结构化信息，可以与现有的许多Internet协议结合使用，包括HTTP超文本传输协议，SMTP简单邮件传输协议，MIME多用途网际邮件扩充协议。
它还支持从消息系统到远程过程调用（RPC）等大量应用程序。
* 什么是WSDL？  
WSDL全称Web Services Description Language，即网络服务描述语言，是一种用来描述Web服务和说明如何与Web服务通信的XML语言。
WSDL用于提供详细的接口说明书，使得用户能够快速的正确的调用web服务。
WSDL文档分为两部分，顶部由抽象定义组成，而底部则由具体描述组成。
* 什么是UDDI？  
UDDI全称Universal Description,Discovery and Integration，即统一描述发现和集成，是一个用来创建在线企业和服务注册的规范。
UDDI主要包含三个部分，数据模型，API和注册服务。
数据模型-一个用于描述商业组织和Web Service的XML Schema。
API-基于SOAP的一组用于查找或发布UDDI数据模型的方法。
服务注册-一种注册服务的基础设施。  
# 调用原理
* 发布服务  
Web服务提供者设计实现Web服务，并将调试正确后的Web服务通过Web服务中介者发布，并在UDDI注册中心注册
* 发现服务  
Web服务请求者向Web服务中介者请求特定的服务，中介者根据请求查询UDDI注册中心，为请求者寻找满足请求的服务
Web服务中介者向Web服务请求者返回满足条件的Web服务描述信息，该描述信息用WSDL写成，各种支持Web服务的机器都能阅读
* 绑定服务  
利用从Web服务中介者返回的描述信息生成相应的SOAP消息，发送给Web服务提供者，以实现Web服务的调用
Web服务提供者按SOAP消息执行相应的Web服务，并将服务结果以SOAP消息返回给Web服务请求者
