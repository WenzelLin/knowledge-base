# jQuery ajax - getScript() 方法

* 定义和用法   
    getScript() 方法通过 HTTP GET 请求载入并执行 JavaScript 文件。

* 语法    
    jQuery.getScript(url,success(response,status))

参数|描述
:--|:--
url|将要请求的 URL 字符串。
success(response,status)|可选。规定请求成功后执行的回调函数。   额外的参数：     response - 包含来自请求的结果数据   status - 包含请求的状态（"success", "notmodified", "error", "timeout" 或 "parsererror"）|

* 详细说明    
    该函数是简写的 Ajax 函数，等价于：
    ~~~javascript
    $.ajax({
      url: url,
      dataType: "script",
      success: success
    });
    ~~~
    这里的回调函数会传入返回的 JavaScript 文件。这通常不怎么有用，因为那时脚本已经运行了。    
    载入的脚本在全局环境中执行，因此能够引用其他变量，并使用 jQuery 函数。    
    比如加载一个 test.js 文件，里边包含下面这段代码：    
    ~~~javascript
    $(".result").html("<p>Lorem ipsum dolor sit amet.</p>");
    ~~~
    通过引用该文件名，就可以载入并运行这段脚本：
    ~~~javascript
    $.getScript("ajax/test.js", function() {
      alert("Load was performed.");
    });
    ~~~
    注释jQuery 1.2 版本之前，getScript 只能调用同域 JS 文件。1.2中，您可以跨域调用 JavaScript 文件。    
    注意：Safari 2 或更早的版本不能在全局作用域中同步执行脚本。如果通过 getScript 加入脚本，请加入延时函数。    

* 更多实例    
    * 例子 1    
        加载并执行 test.js：
        ~~~javascript
        $.getScript("test.js");
        ~~~
    * 例子 2    
        加载并执行 test.js ，成功后显示信息：
        ~~~javascript
        $.getScript("test.js", function(){
          alert("Script loaded and executed.");
        });
        ~~~
    * 例子 3    
        载入 jQuery 官方颜色动画插件 成功后绑定颜色变化动画：   
        HTML 代码：
        ~~~html
        <button id="go">Run</button>
        <div class="block"></div>
        ~~~
        jQuery 代码：

        ~~~javascript
        jQuery.getScript("http://dev.jquery.com/view/trunk/plugins/color/jquery.color.js",
         function(){
          $("#go").click(function(){
            $(".block").animate( { backgroundColor: 'pink' }, 1000)
              .animate( { backgroundColor: 'blue' }, 1000);
          });
        });
        ~~~
