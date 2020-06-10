# @font-face

  CSS3 @font-face 规则  
  在 CSS3 之前，web 设计师必须使用已在用户计算机上安装好的字体。  
  通过 CSS3，web 设计师可以使用他们喜欢的任意字体。  
  当您您找到或购买到希望使用的字体时，可将该字体文件存放到 web 服务器上，它会在需要时被自动下载到用户的计算机上。  
  您“自己的”的字体是在 CSS3 @font-face 规则中定义的。  
  使用您需要的字体  
  在新的 @font-face 规则中，您必须首先定义字体的名称（比如 myFirstFont），然后指向该字体文件。  
  如需为 HTML 元素使用字体，请通过 font-family 属性来引用字体的名称 (myFirstFont)：  

  * 语法
  ```
  @font-face {
    [ font-family: <family-name>; ] ||
    [ src: <src>; ] ||
    [ unicode-range: <unicode-range>; ] ||
    [ font-variant: <font-variant>; ] ||
    [ font-feature-settings: <font-feature-settings>; ] ||
    [ font-variation-settings: <font-variation-settings>; ] ||
    [ font-stretch: <font-stretch>; ] ||
    [ font-weight: <font-weight>; ] ||
    [ font-style: <font-style>; ]
  }
  where 
  <family-name> = <string> | <custom-ident>+
  ```
  * 取值  
  |描述符|值|描述|
  |:--|:--|:--|
  |font-family|name|必需。规定字体的名称。|
  |src|URL|必需。定义字体文件的 URL。|
  |font-stretch|normal condensed ultra-condensed extra-condensed semi-condensed expanded semi-expanded extra-expanded ultra-expanded|可选。定义如何拉伸字体。默认是 "normal"。|
  |font-style|ormal italic oblique|可选。定义字体的样式。默认是 "normal"。|
  |font-weight|normal bold 100 200 300 400 500 600 700 800 900|可选。定义字体的粗细。默认是 "normal"。|
  |unicode-range|unicode-range|可选。定义字体支持的 UNICODE 字符范围。默认是 "U+0-10FFFF"。|
  
  * 实例
  ```html
  <html>
  <head>
    <style>
      @font-face {
        font-family: cap-icon-v4;
        src: url(../font/iconfont.eot?37a41f6);
        src: url(../font/iconfont.eot?37a41f6) format("embedded-opentype"),url(../font/iconfont.woff2?6bd5167) format("woff2"),url(../font/iconfont.woff?77045ad) format("woff"),url(../font/iconfont.ttf?e3f525c) format("truetype"),url(../font/iconfont.svg?f732130) format("svg")
      }
      .cap-icon-wenbenyu:before {
        content: "\e6db"
      }
    </style>
  </head>
  <div class="da-ctrl-icon"><i class="cap-icon-wenbenyu"></i></div>
  </html>
  ```


# box-shadow 属性

* 定义和用法

  box-shadow 属性向框添加一个或多个阴影。

  >提示：请使用 border-image-* 属性来构造漂亮的可伸缩按钮！

  name|value
  :--|:--
  默认值：|none
  继承性：|no
  版本：|CSS3
  JavaScript 语法：|object.style.boxShadow="10px 10px 5px #888888"

  语法
  ```css
  box-shadow: h-shadow v-shadow blur spread color inset;
  ```
  注释：box-shadow 向框添加一个或多个阴影。该属性是由逗号分隔的阴影列表，每个阴影由 2-4 个长度值、可选的颜色值以及可选的 inset 关键词来规定。省略长度的值是 0。

  值|描述|测试
  :--|:--|:--
  h-shadow|必需。水平阴影的位置。允许负值。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)
  v-shadow|必需。垂直阴影的位置。允许负值。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)
  blur|可选。模糊距离。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)
  spread|可选。阴影的尺寸。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)
  color|可选。阴影的颜色。请参阅 CSS 颜色值。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)
  inset|可选。将外部阴影 (outset) 改为内部阴影。|[测试](http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow)

# 参考
  * [CSS3 box-shadow 属性](http://www.w3school.com.cn/cssref/pr_box-shadow.asp)
