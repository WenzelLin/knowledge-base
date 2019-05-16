com.alibaba.fastjson.JSONObject
com.alibaba.fastjson.JSONArray

com.google.gson.JsonArray
com.google.gson.JsonObject

com.fasterxml.jackson.databind.ObjectMapper


* JSONObject解析  
  json文件
  ```json
  {
    "resultcode": "200",
    "reason": "successed!",
    "result": {
        "sk": {
            "temp": "24",
            "wind_direction": "西南风",
            "wind_strength": "2级",
            "humidity": "51%",
            "time": "10:11"
        },
        "today": {
            "temperature": "16℃~27℃",
            "weather": "阴转多云",
            "weather_id": {
                "fa": "02",
                "fb": "01"
            },
            "wind": "西南风3-4 级",
            "week": "星期四",
            "city": "滨州",
            "date_y": "2015年06月04日",
            "dressing_index": "舒适",
            "dressing_advice": "建议着长袖T恤、衬衫加单裤等服装。年老体弱者宜着针织长袖衬衫、马甲和长裤。",
            "uv_index": "最弱",
            "comfort_index": "",
            "wash_index": "较适宜",
            "travel_index": "",
            "exercise_index": "较适宜",
            "drying_index": ""
        },
        "future": [
            {
                "temperature": "16℃~27℃",
                "weather": "阴转多云",
                "weather_id": {
                    "fa": "02",
                    "fb": "01"
                },
                "wind": "西南风3-4 级",
                "week": "星期四",
                "date": "20150604"
            },
            {
                "temperature": "20℃~32℃",
                "weather": "多云转晴",
                "weather_id": {
                    "fa": "01",
                    "fb": "00"
                },
                "wind": "西风3-4 级",
                "week": "星期五",
                "date": "20150605"
            },
            {
                "temperature": "23℃~35℃",
                "weather": "多云转阴",
                "weather_id": {
                    "fa": "01",
                    "fb": "02"
                },
                "wind": "西南风3-4 级",
                "week": "星期六",
                "date": "20150606"
            },
            {
                "temperature": "20℃~33℃",
                "weather": "多云",
                "weather_id": {
                    "fa": "01",
                    "fb": "01"
                },
                "wind": "北风微风",
                "week": "星期日",
                "date": "20150607"
            },
            {
                "temperature": "22℃~34℃",
                "weather": "多云",
                "weather_id": {
                    "fa": "01",
                    "fb": "01"
                },
                "wind": "西南风3-4 级",
                "week": "星期一",
                "date": "20150608"
            },
            {
                "temperature": "22℃~33℃",
                "weather": "阴",
                "weather_id": {
                    "fa": "02",
                    "fb": "02"
                },
                "wind": "西南风3-4 级",
                "week": "星期二",
                "date": "20150609"
            },
            {
                "temperature": "22℃~33℃",
                "weather": "多云",
                "weather_id": {
                    "fa": "01",
                    "fb": "01"
                },
                "wind": "南风3-4 级",
                "week": "星期三",
                "date": "20150610"
            }
        ]
    },
    "error_code": 0
  }
  ```
  解析json数据
  ```java
  package cn.edu.bzu.json;

  import java.io.FileNotFoundException;
  import java.io.FileReader;

  import com.google.gson.JsonArray;
  import com.google.gson.JsonIOException;
  import com.google.gson.JsonObject;
  import com.google.gson.JsonParser;
  import com.google.gson.JsonSyntaxException;

  public class Read {
      public static void main(String args[]){
          JsonParser parse =new JsonParser();  //创建json解析器
          try {
              JsonObject json=(JsonObject) parse.parse(new FileReader("weather.json"));  //创建jsonObject对象
              System.out.println("resultcode:"+json.get("resultcode").getAsInt());  //将json数据转为为int型的数据
              System.out.println("reason:"+json.get("reason").getAsString());     //将json数据转为为String型的数据

              JsonObject result=json.get("result").getAsJsonObject();
              JsonObject today=result.get("today").getAsJsonObject();
              System.out.println("temperature:"+today.get("temperature").getAsString());
              System.out.println("weather:"+today.get("weather").getAsString());

          } catch (JsonIOException e) {
              e.printStackTrace();
          } catch (JsonSyntaxException e) {
              e.printStackTrace();
          } catch (FileNotFoundException e) {
              e.printStackTrace();
          }
      }
  }
  ```

* JSONArray的解析
  json文件
  ```json
  {
    "cat":"it",
    "language":[
        {"id":1,"ide":"eclipse","name":"Java"},
        {"id":2,"ide":"XCode","name":"Swift"},
        {"id":3,"ide":"Visual Stdio","name":"C#"}     
    ],
    "pop":true
  }
  ```
  解析json数据
  ```java
  package cn.edu.bzu.json;

  import java.io.FileNotFoundException;
  import java.io.FileReader;

  import com.google.gson.JsonArray;
  import com.google.gson.JsonIOException;
  import com.google.gson.JsonObject;
  import com.google.gson.JsonParser;
  import com.google.gson.JsonSyntaxException;

  public class ReadJSON {
      public static void main(String args[]){
          try {

              JsonParser parser=new JsonParser();  //创建JSON解析器
              JsonObject object=(JsonObject) parser.parse(new FileReader("test.json"));  //创建JsonObject对象
              System.out.println("cat="+object.get("cat").getAsString()); //将json数据转为为String型的数据
              System.out.println("pop="+object.get("pop").getAsBoolean()); //将json数据转为为boolean型的数据

              JsonArray array=object.get("language").getAsJsonArray();    //得到为json的数组
              for(int i=0;i<array.size();i++){
                  System.out.println("---------------");
                  JsonObject subObject=array.get(i).getAsJsonObject();
                  System.out.println("id="+subObject.get("id").getAsInt());
                  System.out.println("name="+subObject.get("name").getAsString());
                  System.out.println("ide="+subObject.get("ide").getAsString());
              }

          } catch (JsonIOException e) {
              e.printStackTrace();
          } catch (JsonSyntaxException e) {
              e.printStackTrace();
          } catch (FileNotFoundException e) {
              e.printStackTrace();
          }
      }
  }
  ```
  
# 参考
  * [JAVA解析JSON数据](https://www.cnblogs.com/boy1025/p/4551593.html)
