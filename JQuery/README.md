
* 用代码触发事件

  * trigger
    ```javascript
    // 语法：$(seacher).trigger(eventName);
    
    $('#id').val('abc').trigger('change');// 变更值后，触发change事件
    
    $('#id').val('abc').trigger('propertychange');// 变更值后，触发propertychange事件
    
    ```

* [getScript() 方法](https://github.com/WenzelLin/knowledge-base/blob/master/JQuery/getScript.md)

# 参考
  
  * [jQuery中trigger()使用之触发select下拉框（onchange）](https://blog.csdn.net/ycharlee/article/details/52293611)
