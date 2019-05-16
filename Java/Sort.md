# Sort 排序

* ## 数组Sort排序
  
  升序排序，直接使用Arrays.Sort方法。
  ```java
  int[] array = {10, 3, 6, 1, 4, 5, 9};
  //正序排序
  Arrays.sort(array);//会检查数组个数大于286且连续性好就使用归并排序，若小于47使用插入排序，其余情况使用双轴快速排序
  System.out.println("升序排序：");
  for (int num : array) {
          System.out.println(num);
  }
  ```
  降序排序
  ```java
  //倒序排序
  //(1)由于不提供倒排方法，你可以倒叙输出
  System.out.println("降序输出：");
  for (int i = array.length - 1; i >= 0; i--) {
          System.out.println(array[i]);
  }
  //(2)或者创建一个新的数组，倒叙保存到新数组
  int[] descArray = new int[array.length];
  for (int i = 0; i < array.length; i++) {
          descArray[i] = array[array.length - i - 1];
  }
  System.out.println("新数组降序输出：");
  for (int num : descArray) {
          System.out.println(num);
  }
  ```
  ```Guava
  //(3)或者使用Guava来实现，对于非引用类型，不可以使用Arrays.asList()
  //使用Guava的Ints.asList()方法转换后的集合，实现了List接口的方法，直接将数组转入内部的数组变量，
  //需要注意它并没有实现数组的操作方法
  List<Integer> integersList = Ints.asList(array);
  Collections.reverse(integersList);//冒泡交换
  System.out.println("Guava降序输出：");
  for (int num : integersList) {
      System.out.println(num);
  }
  ```
* ## 集合Sort排序
  * ### 包装类
  ```java
  //Integer集合，正序排序
  List<Integer> list = new ArrayList<Integer>(Arrays.asList(10, 3, 6, 1, 4, 5, 9));
  Collections.sort(list);
  System.out.println("集合正序排序：");
  for (Integer num : list) {
          System.out.println(num);
  }

  //倒叙排序
  Comparator<Integer> reverseComparator = Collections.reverseOrder();
  Collections.sort(list, reverseComparator);
  System.out.println("集合倒叙排序：");
  for (Integer num : list) {
      System.out.println(num);
  }
  ```
  * ### 自定义对象
    * #### 使用Collections.sort(List<T> list)方法
    
      待排序的对象实现Comparable接口，重写接口方法。
      
    * #### 使用Collections.sort(List<T> list, Comparator<? super T> c)方法
      待排序对象通过Comparator<? super T>.compare(T o1, T o2)方法比较大小，进行排序。
      
# 参考
  * [Java—Sort排序](https://blog.csdn.net/whp1473/article/details/79678974)
