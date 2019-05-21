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
