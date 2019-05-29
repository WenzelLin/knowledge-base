# Docker 入门

## 安装

  * Ubuntu
    
    获取当前系统代号，为系统添加Docker稳定版的官方软件源，然后开始安装
    ```
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
    
    $ sudo apt-get update
    ```
    安装Docker
    ```
    $ sudo apt-get install -y docker-ce
    ```
    或者
    ```
    $ sudo curl -sSL https://get.docker.com/ | sh
    ```
    安装完自动启动（没试验过）。
    
  * CentOS
   
    为了方便添加软件源，以及支持devicemapper存储类型，安装如下软件包
    
    ```
    $ sudo yum update
    $ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    ```
    
    添加Docker稳定版的官方软件源
    
    ```
    $ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ```
    
    更新软件源缓存并安装Docker
    
    ```
    $ sudo yum update
    $ sudo yum install -y docker-ce
    ```
    
    启动Docker服务
    
    ```
    sudo systemctl start docker
    ```

  * 通过脚本安装
  
    ```
    $ sudo curl -fsSL https://get.docker.com/ | sh
    ```
    
    或
    
    ```
    $ sudo wget -q0 https://get.docker.com/ | sh
    ```
    
    安装“尝鲜版”
    
    ```
    $ sudo curl -fsSL https://test.docker.com/ | sh
    ```
    
  
