
* [Excel 中多行时快速生成自增长序号](https://blog.csdn.net/tzhuwb/article/details/77430230)

* [Excel 中快速选择指定区域](https://www.jizhuba.com/kejiyouxi/20170822/2838.html)

* VLOOKUP函数：

  定义：

  VLOOKUP(lookup_value, table_array,col_index_num, [range_lookup])

  解释：

  lookup_value: 指的是要查询的某个值。如A2

  table_array: 指的是要查询的列。如H列则写成H:H; 若是H, I,J,K列则写成H:K

  col_index_num: 指的是要查询列的索引，索引值默认从1开始。

  range_lookup: 可选值TRUE/FALSE, 也可用0代替FALSE，TRUE表示模糊查找，但是查找列的第一列数据必须是递增排序的。FALSE表示精确查找。
  
  ```
  =IFERROR(VLOOKUP(E33,Q:S,3,FALSE),J33)
  ```
  注意：主要其中`Q:S`中Q为索引列，也就是查询E33在Q中存不存在。

* 快速移动某列数据

  在编辑Excel表格时，有时发现编辑的表格中，有的列位置不对，想要移动一下，往往要用四步，才能做到，即，在要插入的位置插入列，选择要移动的列，粘贴列，删除原列。

  今天介绍一种快速移动的方法。只要一步。
  
  表中的单价在数量的前面，这有些不合一般人看表的习惯。我们的移动一下单价，到数量的后面。

  选择要移动的整列，把光标放到要选择列两边任一边上，使光标变成带十字箭头和空心箭头形状的光标，按住Shift键，这时再按住鼠标左键拖动到要放的位置。先放开Shift键，后放开鼠标左键。
  
  ![演示Excel 快速移动列-1](https://imgsa.baidu.com/exp/pic/item/f677b1c379310a553d88a76ab54543a983261044.jpg)
  
  ![演示Excel 快速移动列-2](https://imgsa.baidu.com/exp/pic/item/425773224f4a20a48b5e445992529822730ed0a9.jpg)
  
  ![演示Excel 快速移动列-3](https://imgsa.baidu.com/exp/pic/item/3790312eb9389b505ab19acc8735e5dde6116ea6.jpg)
  
# 参考

  * [Excel 快速移动整列的方法](https://jingyan.baidu.com/article/0320e2c1ee426d1b87507ba9.html)
  
  * [excel 怎样移动列?excel 一键移动列](https://www.jb51.net/office/excel/522411.html)
  
  * [Excel 查找某列中的数据在另一列是否存在并输出其他列的数据](https://www.cnblogs.com/julygift/p/7761050.html)
