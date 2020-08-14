# Pentaho kettle

* kettle 报错【Maximum wait time of 10 seconds exceed while acquiring lock】

  报错信息：Maximum wait time of 10 seconds exceed while acquiring lock

  导致报错原因：我的情况是由于写了一个死循环，产生了一个锁，导致使用kettle的时候老是弹窗报错。

  解决方法：在/.pentaho路径下将.lock文件删除即可

  文件路径：在 C:\Users（用户）\xiaoming（你的系统登录使用的那个用户名称）\ 路径下面 括弧里面的内容是说明。

  完结。

# 参考

  * [kettle 报错【Maximum wait time of 10 seconds exceed while acquiring lock】](https://blog.csdn.net/m0_37611229/article/details/90296261)

