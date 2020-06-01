* [Sublime text3最全快捷键清单](https://blog.csdn.net/mrchengzp/article/details/78508509)

* SublimeServer

  当用浏览器打开本地文件时，可能会遇到报错：
  
  ``
  XMLHttpRequest cannot load file:///Users/iceStone/Documents/Learning/angular/demo/angular-moviecat/movie/view.html. Cross origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, https, chrome-extension-resource.
  ``
  
  原因很简单，浏览器（Webkit内核）的安全策略决定了file协议访问的应用无法使用XMLHttpRequest对象，错误消息中也很清楚的说明了：
  
  ``
  Cross origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, https, chrome-extension-resource.
  ``
  ``
  跨域请求仅支持协议：http, data, chrome, chrome-extension, https, chrome-extension-resource
  ``
  
  在某些浏览器中是允许这种操作的，比如Firefox浏览器，也就是说Filefox支持file协议下的AJAX请求。

  解决办法
  
    Windows：
    
    设置Chrome的快捷方式属性，在“目标”后面加上--allow-file-access-from-files，注意前面有个空格，重新打开Chrome即可。
    
    Mac：
    
    只能通过终端打开浏览器：打开终端，输入下面命令：open -a "Google Chrome" --args --disable-web-security然后就可以屏蔽安全访问了[ --args：此参数可有可无]

  推荐一款Sublime的插件Sublime Server，这个插件可以提供一个静态文件HTTP服务器，使用方式
  
  1.安装Package Control（Sublime的插件管理工具），不会安装自行Google。
  
  2.`Ctrl+Shift+P`打开命令面板，输入`Package Control: Install Package`
  
  3.搜索`SublimeServer`
  
  4.安装完成后启动服务：`Tool → SublimeServer → Start SublimeServer`，默认端口是8080（可以通过setting修改），端口被占用是启动会报错。
  
  5.一定要用打开文件夹的方式使用Sublime，否则没有办法正常使用SublimeServer。
  
  6.打开HTML文件，在右键菜单中选择View in SublimeServer，此时就可以以HTTP方式在浏览器中访问该文件了。
  
    如果该选项是灰色的，那就说明没有启动SublimeServer，Tool → SublimeServer → Start SublimeServer
    
 # 参考
  
  * [配置Chrome支持本地（file协议）的AJAX请求](https://www.cnblogs.com/micua/p/chrome-file-protocol-support-ajax.html)
