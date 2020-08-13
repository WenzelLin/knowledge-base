# Jenkins

* Jenkins部署异常：TomcatManagerException: FAIL - Unable to delete
  
  * 异常原因
  
    - Tomcat应用更新时，把新的WAR包放到webapps目录下，Tomcat就会自动把原来的同名webapp删除，并把WAR包解压，运行新的 webapp。

    - 但是，有时候Tomcat并不能把旧的webapp完全删除，通常会留下WEB-INF/lib下的某个jar包，必须关闭Tomcat才能删除，这就导致自动部署失败。

    - 解决方法是在<Context>元素中增加一个属性antiResourceLocking="true" antiJARLocking="true"，默认是"false"。这样就可以热部署了。

    - 实际上，这两个参数就是配置Tomcat的资源锁定和Jar包锁定策略。
  
  * 解决办法
    1，打开TOMCAT_HOME/conf/context.xml

    2，在<Context>元素中增加一个属性antiResourceLocking="true" antiJARLocking="true"，默认是"false"。
    
    ```xml
    <?xml version='1.0' encoding='utf-8'?>
    <!--
      Licensed to the Apache Software Foundation (ASF) under one or more
      contributor license agreements.  See the NOTICE file distributed with
      this work for additional information regarding copyright ownership.
      The ASF licenses this file to You under the Apache License, Version 2.0
      (the "License"); you may not use this file except in compliance with
      the License.  You may obtain a copy of the License at
          http://www.apache.org/licenses/LICENSE-2.0
      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      See the License for the specific language governing permissions and
      limitations under the License.
    -->
    <!-- The contents of this file will be loaded for each web application -->
    <Context antiResourceLocking="true" antiJARLocking="true">  

        <!-- Default set of monitored resources. If one of these changes, the    -->
        <!-- web application will be reloaded.                                   -->
        <WatchedResource>WEB-INF/web.xml</WatchedResource>
        <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

        <!-- Uncomment this to disable session persistence across Tomcat restarts -->
        <!--
        <Manager pathname="" />
        -->

        <!-- Uncomment this to enable Comet connection tacking (provides events
             on session expiration as well as webapp lifecycle) -->
        <!--
        <Valve className="org.apache.catalina.valves.CometConnectionManagerValve" />
        -->
    </Context>
    ```
# 参考

  * [Jenkins部署异常：TomcatManagerException: FAIL - Unable to delete](https://blog.csdn.net/fly910905/article/details/80262658)
