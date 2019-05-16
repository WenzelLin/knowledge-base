* [Spring 框架简介](https://www.ibm.com/developerworks/cn/java/wa-spring1/)

# 整合CXF-WebService
web.xml
```xml
<!-- Spring Context Config -->
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>classpath:applicationContext.xml</param-value>
	</context-param>

<servlet>  
  <servlet-name>CXFServlet</servlet-name>
  <servlet-class>org.apache.cxf.transport.servlet.CXFServlet</servlet-class>
  <init-param>
    <param-name>hide-service-list-page</param-name>
    <param-value>true</param-value>
  </init-param>
  <load-on-startup>11</load-on-startup>
</servlet>
<servlet-mapping>
  <servlet-name>CXFServlet</servlet-name>
  <url-pattern>/services/*</url-pattern>
</servlet-mapping>

```
applicationContext.xml
```xml
<!-- 下面的cxfserver.xml和cxfclient可以按实际注释，但是cxf.xml必须引入，不然启动报错，尽管系统没问题 -->
<import resource="classpath*:META-INF/cxf/cxf.xml" />
<!-- webservice服务器端配置文件 -->
<import resource="cxfserver.xml" />
<!-- webservice客户端配置文件 -->
<import resource="cxfclient.xml"/>
```
cxfserver.xml
```xml
<!-- 广财平台获取供应商信息接口-->
<bean id="userWebService" class="framework.services.xzxy.UserWebServiceImpl" >
  <property name="userBO" ref="UserBO"/>
</bean>
<jaxws:endpoint id="userWebSer" implementor="#userWebService"  address="/userWebSer" />
```
cxfclient.xml
```xml
<!-- 财厅ODS已办数据 -->
<bean id="completeWorkitemWSServiceFactory" class="org.apache.cxf.jaxws.JaxWsProxyFactoryBean">
  <property name="serviceClass" value="framework.schedulejob.job.service.ods.odsserverinterface.CompleteWorkitemWS"/> 
  <property name="address" value="http://esb.gdczt.gov.cn:7800/dof-stat-web/ws/WorkItemSyncSrv"/>
</bean>
<bean id="completeWorkitemWSClient" class="framework.schedulejob.job.service.ods.odsserverinterface.CompleteWorkitemWS" factory-bean="completeWorkitemWSServiceFactory" factory-method="create"/>
```
