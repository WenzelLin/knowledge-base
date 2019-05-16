new PathMatchingResourcePatternResolver(ResourcePatternResolver.CLASSPATH_ALL_URL_PREFIX  +propertiesPattern)
new PathMatchingResourcePatternResolver(ResourcePatternResolver.CLASSPATH_ALL_URL_PREFIX  +"/test.properties")
new PathMatchingResourcePatternResolver("classpath*:/test.properties")

```java
/**
 * 加载配置文件
 * @param propertyFile 配置文件
 * @return 配置文件对象
 */
private static Properties loadProperties(File propertyFile){
    FileInputStream fis = null;
    BufferedInputStream bis = null;
    InputStreamReader isr = null;
    Properties pro = new Properties();
    try {
        fis = new FileInputStream(propertyFile);
        bis = new BufferedInputStream(fis);
        isr = new InputStreamReader(bis, "UTF-8");
        pro.load(isr);
    } catch (Exception e) {
        // 程序异常
        throw new RuntimeException(e);
    } finally {
        try {
            if (isr != null) isr.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            if (bis != null) bis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            if (fis != null) fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    return pro;
}
```
```java
/**
 * 已更新的方式将配置信息存储至配置文件
 * @param prop 配置信息
 * @param propertyFile 配置文件
 */
private static void storeProperties4Update(Properties prop, File propertyFile){
    FileOutputStream fos = null;
    BufferedOutputStream bos = null;
    OutputStreamWriter osw = null;
    try {
        fos = new FileOutputStream(propertyFile);
        bos = new BufferedOutputStream(fos);
        osw = new OutputStreamWriter(bos, "UTF-8");
        prop.store(osw, "Update value");
    } catch (Exception e) {
        // 程序异常
        throw new RuntimeException(e);
    } finally {
        try {
            if (osw != null) osw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            if (bos != null) bos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            if (fos != null) fos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

# 参考
  * [JAVA操作properties文件](http://www.cnblogs.com/panjun-Donet/archive/2009/07/17/1525597.html)
