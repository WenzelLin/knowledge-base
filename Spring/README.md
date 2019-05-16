* [Spring 框架简介](https://www.ibm.com/developerworks/cn/java/wa-spring1/)

## 整合CXF-WebService
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

## jsp-config taglib
web.xml
```xml
<jsp-config>
	<taglib>
		<taglib-uri>/jsonfunction</taglib-uri>
		<taglib-location>jsonfunction.tld</taglib-location>
	</taglib>
</jsp-config>
```
jsonfunction.tld
```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib version="2.0" xmlns="http://java.sun.com/xml/ns/j2ee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee web-jsptaglibrary_2_0.xsd">
	<tlib-version>1.0</tlib-version>
	<jsp-version>2.0</jsp-version>
	<short-name>json</short-name>
	<uri>/jsonfunction</uri>
	
	<function>
		<name>docker</name>
		<function-class>framework.sys.componetcontroller.taglibs.JsonFunction</function-class>
		<function-signature>java.lang.String allDocker()</function-signature>
	</function>
</taglib>
```

## 整合 Redis
web.xml
```xml
<bean id="jedisPool" class="redis.clients.jedis.JedisPool">  
	<constructor-arg index="0" ref="jedisPoolConfig">  </constructor-arg>
	<constructor-arg index="1" value="${redis.host}">  </constructor-arg>
	<constructor-arg index="2" value="${redis.port}" type="int"> </constructor-arg> 
	<constructor-arg index="3" value="1000000" type="int"> </constructor-arg> 
	<constructor-arg index="4" value="${redis.password}">  </constructor-arg>
</bean>  

<bean id="jedisPoolConfig" class="redis.clients.jedis.JedisPoolConfig">
	<property name="maxTotal" value="-1" />
	<property name="maxIdle" value="200" />
	<property name="numTestsPerEvictionRun" value="1024"/>
	<property name="timeBetweenEvictionRunsMillis" value="30000" />
	<property name="minEvictableIdleTimeMillis" value="1800000" />
	<property name="softMinEvictableIdleTimeMillis" value="10000" />
	<property name="maxWaitMillis" value="-1"/>
	<property name="testOnBorrow" value="true" />
	<property name="testWhileIdle" value="true"/>
	<property name="testOnReturn" value="false"/>
	<property name="jmxEnabled" value="true"/>
	<property name="jmxNamePrefix" value="pool"/>
	<property name="blockWhenExhausted" value="false"/>
</bean>
<bean id="JedisDataSource" class="framework.sys.cachecontrol.redis.JedisDataSourceImpl">
	<property name="jedisPool" ref="jedisPool"/>
</bean>
<bean id="RedisCacheTemplate" class="framework.sys.cachecontrol.RedisCacheTemplate">
	<property name="redisDataSource" ref="JedisDataSource"/>
</bean>
```
framework.sys.cachecontrol.redis.JedisDataSourceImpl.java
```java
package framework.sys.cachecontrol.redis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class JedisDataSourceImpl implements JedisDataSource {

	private JedisPool jedisPool;

	public Jedis getRedisClient() {
		Jedis jedis = null;
		try {
			jedis = jedisPool.getResource();
			return jedis;
		} catch (Exception e) {
			if (null != jedis)
				jedis.close();
		}
		return null;
	}

	public void returnResource(Jedis jedis) {
		jedis.close();
	}

	public void returnResource(Jedis jedis, boolean broken) {
		jedis.close();
	}

	public JedisPool getJedisPool() {
		return jedisPool;
	}

	public void setJedisPool(JedisPool jedisPool) {
		this.jedisPool = jedisPool;
	}
}
```
framework.sys.cachecontrol.RedisCacheTemplate.java
```java
package framework.sys.cachecontrol;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeSet;

import redis.clients.jedis.Jedis;

import com.esotericsoftware.kryo.Kryo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import framework.modules.classify.domain.Classify;
import framework.modules.dataauth.dataauthfuncconfig.domain.DataAuthFuncConfig;
import framework.modules.organization.domain.Organization;
import framework.sys.cache.SystemConfigService;
import framework.sys.cachecontrol.redis.JedisDataSource;
import framework.sys.cachecontrol.redis.RedisLock;
import framework.sys.cachecontrol.redis.publishsubscribe.ChanelBusiType;
import framework.sys.cachecontrol.redis.publishsubscribe.Channels;
import framework.sys.cachecontrol.redis.publishsubscribe.Message;
import framework.sys.cachecontrol.redis.publishsubscribe.SubscribeTask;
import framework.sys.context.SpringContextUtil;
import framework.sys.tools.KryoTool;
import framework.sys.tools._Date;

/**
 * 存放缓存到redis内存的操作类
 * 
 * @author xzb
 * 
 */
public class RedisCacheTemplate implements DataCache {
	private JedisDataSource redisDataSource;

	/**
	 * 当值为对象类型时候调用，方法中会使用kryo工具类来序列化对象
	 * 
	 * @param key
	 * @param obj
	 * @return 参考 jedis api
	 */
	public <T extends Serializable> String set(String key, T obj) {
		String result = null;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			result = jedis.set(key.getBytes(), KryoTool.serializationObject(obj));
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 值为对象类型时候调用，方法中会使用kryo工具类来序列化对象。若redis已经存在key，则不会设置
	 * 
	 * @param key
	 * @param obj
	 * @return true：设置进去了，false：key已经存在，没有设置
	 */
	public <T extends Serializable> boolean setNX(String key, T obj) {
		boolean result = false;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			result = jedis.setnx(key.getBytes(), KryoTool.serializationObject(obj)) == 1 ? true : false;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 设置对象值到redis中，并返回上一个值
	 * 
	 * @param key
	 * @param obj
	 * @return 若key已经存在，则返回上一个值，否则nil
	 */
	public <T extends Serializable> byte[] getSet(String key, T obj) {
		byte[] result = null;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			result = jedis.getSet(key.getBytes(), KryoTool.serializationObject(obj));
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 获取值
	 * 
	 * @param <T>
	 * @param key
	 * @param clazz
	 * @return
	 */
	public <T extends Serializable> T getObject(String key, Class<T> clazz) {
		T obj = null;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			byte[] valueByte = jedis.get(key.getBytes());
			if (valueByte != null) {
				obj = KryoTool.deserializationObject(valueByte, clazz);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return obj;
	}

	/**
	 * 当值为集合对象类型时候调用，方法中会使用kryo工具类来序列化对象
	 * 需要注意：存放到redis中仍是以key-value的方式。而不是使用redis的集合存放
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public <T extends Serializable> String setListObj(String key, List<T> listObj, Class<T> clazz) {
		String result = null;
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			result = jedis.set(key.getBytes(), KryoTool.serializationList(listObj, clazz));
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 当值为集合对象类型时候调用，方法中会调用kryo工具类反序列化对象并返回
	 * 需要注意：存放到redis中需要是key-value的方式。value是list对象的序列化byte
	 * 
	 * @param key
	 * @return
	 */
	public <T extends Serializable> List<T> getListObj(String key, Class<T> clazz) {
		List<T> listObj = null;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			byte[] valueByte = jedis.get(key.getBytes());
			if (valueByte != null) {
				listObj = KryoTool.deserializationList(valueByte, clazz);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return listObj;
	}

	/**
	 * 初始化单位树hash，这里是为了减少连接以及对象的产生,优化初始化 当值为集合对象类型时候调用，方法中会使用kryo工具类来序列化对象
	 * 需要注意：存放到redis中仍是以key-value的方式。而不是使用redis的集合存放
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public <T extends Serializable> void initOrgHash(String key, List<Organization> orgList) {
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			Kryo kryo = new Kryo();
			byte[] keyByte = key.getBytes();
			for (int i = 0, length = orgList.size(); i < length; i++) {
				Organization organization = orgList.get(i);
				jedis.hset(keyByte, organization.getOrgCode().getBytes(), KryoTool.serializationObject(kryo, organization));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
	}

	/**
	 * 初始化元数据hash，这里是为了减少连接以及对象的产生,优化初始化 当值为集合对象类型时候调用，方法中会使用kryo工具类来序列化对象
	 * 需要注意：存放到redis中仍是以key-value的方式。而不是使用redis的集合存放
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public <T extends Serializable> void initClassifyHash(String key, List<Classify> classifyList) {
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			Kryo kryo = new Kryo();
			byte[] keyByte = key.getBytes();
			for (int i = 0, length = classifyList.size(); i < length; i++) {
				Classify classify = classifyList.get(i);
				jedis.hset(keyByte, classify.getClassifyCode().getBytes(), KryoTool.serializationObject(kryo, classify));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
	}

	/**
	 * 缓存初始化数据权限数据
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public <T extends Serializable> void initDataAuthFuncConfigHash(String key, List<DataAuthFuncConfig> dataAuthFuncConfigList) {
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			Kryo kryo = new Kryo();
			byte[] keyByte = key.getBytes();
			for (int i = 0, length = dataAuthFuncConfigList.size(); i < length; i++) {
				DataAuthFuncConfig dataAuthFuncConfig = dataAuthFuncConfigList.get(i);
				jedis.hset(keyByte, dataAuthFuncConfig.getFuncPointID().toUpperCase().getBytes(), KryoTool.serializationObject(kryo, dataAuthFuncConfig));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
	}

	/**
	 * 设置obj对象到指定的hash中
	 * 
	 * @param key
	 *            hash名称，如：REDISNAME_CLASSIFYHASH
	 * @param field
	 *            hash对象的key
	 * @param obj
	 *            hash对象的value
	 * @return
	 */
	public <T extends Serializable> void setHashObj(String key, String field, T obj) {
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			Kryo kryo = new Kryo();
			byte[] keyByte = key.getBytes();
			byte[] fieldByte = field.getBytes();
			jedis.hset(keyByte, fieldByte, KryoTool.serializationObject(kryo, obj));
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
	}

	/**
	 * 从缓存中获取对应key的某个field对应的对象
	 * 
	 * @param <T>
	 * @param key
	 * @param field
	 * @param clazz
	 * @return
	 */
	public <T extends Serializable> T getHashObj(String key, String field, Class<T> clazz) {
		T obj = null;
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			byte[] valueByte = jedis.hget(key.getBytes(), field.getBytes());
			if (valueByte != null) {
				obj = KryoTool.deserializationObject(valueByte, clazz);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return obj;
	}

	/**
	 * 从缓存取得某个名称为key的hashmap对象
	 * 
	 * @param key
	 *            对应对应的key
	 * @param clazz
	 *            key对应的hashmap中的value的数据类型
	 */
	public <T extends Serializable> HashMap<String, T> getHashAll(String key, Class<T> clazz) {
		HashMap<String, T> map = new HashMap<String, T>();
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			Map<byte[], byte[]> byteMap = jedis.hgetAll(key.getBytes());
			for (Entry<byte[], byte[]> entry : byteMap.entrySet()) {
				byte[] keyByte = entry.getKey();
				byte[] valueByte = entry.getValue();
				map.put(new String(keyByte), KryoTool.deserializationObject(valueByte, clazz));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return map;
	}

	/**
	 * 删除某个key
	 * 
	 * @param key
	 * @return 返回被删除的key的数量
	 */
	public int del(String key) {
		Long result = 0L;
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			result = jedis.del(key.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return result.intValue();
	}

	/**
	 * 删除set中的某个key指定的field
	 * 
	 * @param key
	 * @param field
	 * @return 返回被删除的key的数量
	 */
	public int delHashObj(String key, String field) {
		Long result = 0L;
		Jedis jedis = redisDataSource.getRedisClient();
		try {
			byte[] keyByte = key.getBytes();
			byte[] fieldByte = field.getBytes();
			result = jedis.hdel(keyByte, fieldByte);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return result.intValue();
	}

	/**
	 * 当值为对象类型时候调用，方法中会使用jackson工具类来序列化对象
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public String setObjectJackson(String key, Object value) {
		String result = null;
		Jedis jedis = redisDataSource.getRedisClient();
		ObjectMapper objMapper = new ObjectMapper();

		try {
			jedis.set(key, objMapper.writeValueAsString(value));
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 当值为对象类型时调用，方法中会调用Jackson工具类反序列化对象并返回
	 * 
	 * @param key
	 * @return
	 */
	public Object getObjectJackson(String key, Class objectType) {
		Object result = null;
		Jedis jedis = redisDataSource.getRedisClient();
		ObjectMapper objMapper = new ObjectMapper();

		try {
			result = objMapper.readValue(jedis.get(key), objectType);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 判读某个key是否存在
	 * 
	 * @param key
	 * @return true：存在，false：不存在
	 */
	public boolean exists(String key) {
		Boolean result = false;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			result = jedis.exists(key);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	/**
	 * 判断某个key对应的类型，如： "none", "string", "list", "set"
	 * 
	 * @param key
	 * @return
	 */
	public String type(String key) {
		String result = null;
		Jedis jedis = redisDataSource.getRedisClient();

		try {
			result = jedis.type(key);

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}

		return result;
	}

	public void disconnect() {
		Jedis jedis = redisDataSource.getRedisClient();
		jedis.disconnect();
	}

	public JedisDataSource getRedisDataSource() {
		return redisDataSource;
	}

	public void setRedisDataSource(JedisDataSource redisDataSource) {
		this.redisDataSource = redisDataSource;
	}

	public boolean isMainMachine() {
		String main = CacheControl.get("main");
		return main.equals("true") ? true : false;
	}

	public String lock(String lockKey) {
		RedisLock lock = new RedisLock(this, lockKey);
		try {
			return lock.lock();
		} catch (InterruptedException e) {
			e.printStackTrace();
			throw new RuntimeException("无法取得redis缓存的锁");
		}
	}

	public void unlock(String lockKey, String lockValue) {
		RedisLock lock = new RedisLock(this, lockKey);
		lock.unlock(lockValue);
	}

	/**
	 * 先判断是否为主机器，只有主机器才负责数据初始化。 还需判断redis缓存中是否已经存在数据，若存在，不用在初始化。
	 * 若主机器正在初始化，其他机器需要等待，直到主机器初始化ok了，才返回
	 */
	public boolean needInitData(String statusName) {
		boolean isMainMachine = isMainMachine();
		String initStatus = getObject(statusName, String.class);

		/** 当为主机器，且没有初始化，则初始化缓存 * */
		if (isMainMachine) {
			if (initStatus == null || initStatus.equals("")) {
				return true;
			} else {
				return false;
			}
		}
		/** 当前系统为非主机器系统时，只要主系统没有初始化好，则一直等待 * */
		else {
			if (initStatus == null || !initStatus.equals("1")) {
				while (true) {
					System.out.println("正在等待主系统的的：" + statusName + "业务初始化，当前时间点为：" +_Date.getSystemDateTime());
					try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
					initStatus = getObject(statusName, String.class);
					if (initStatus != null && initStatus.equals("1")) {
						break;
					}
				}
			}

			return false;
		}
	}

	public void finishInit(String statusName) {
		set(statusName, "1");
	}

	public <T extends Serializable> List<T> getHashValuesTranToList(String key, Class<T> clazz) {
		Jedis jedis = redisDataSource.getRedisClient();
		List<T> listObj = new ArrayList<T>();
		try {
			List<byte[]> valueByteList = new ArrayList(jedis.hvals(key.getBytes()));
			for (int i = 0, len = valueByteList.size(); i < len; i++) {
				listObj.add(KryoTool.deserializationObject(valueByteList.get(i), clazz));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return listObj;
	}

	public <T extends Serializable> Set<String> getHashKeys(String key) {
		Jedis jedis = redisDataSource.getRedisClient();
		Set<String> returnSet = new TreeSet<String>();
		try {
			Set<byte[]> keyByteSet = jedis.hkeys(key.getBytes());

			for (byte[] tempKey : keyByteSet) {
				returnSet.add(new String(tempKey));
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			redisDataSource.returnResource(jedis);
		}
		return returnSet;
	}

	public void publish(Channels channels, Message message) {
		Jedis jedis = redisDataSource.getRedisClient();
		ObjectMapper objMapper = new ObjectMapper();
		try {
			jedis.publish(channels.toString(),objMapper.writeValueAsString( message));
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
	}

	public void subscribe(Channels channels) {
		SubscribeTask subscribeTask = new SubscribeTask(channels);
		Thread thread = new Thread(subscribeTask);
		thread.start();
 	}

	public void publish(Channels channels, ChanelBusiType chanelBusiType) {
		Jedis jedis = redisDataSource.getRedisClient();
		ObjectMapper objMapper = new ObjectMapper();
		SystemConfigService systemConfigService = (SystemConfigService) SpringContextUtil.getBean("SystemConfigService");
		Message message = new Message();
		message.setChanelBusiType(chanelBusiType);
		message.setSourceMac(systemConfigService.getMainMac());
		try {
			jedis.publish(channels.toString(),objMapper.writeValueAsString( message));
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
	}
}
```
[jedis-2.7.2.jar](https://github.com/WenzelLin/knowledge-base/blob/master/Spring/resource/jedis-2.7.2.jar?raw=true)
