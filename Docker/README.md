# Docker 入门

## 安装

### Ubuntu
    
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
    
### CentOS
   
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

### 通过脚本安装
  
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
    
## Docker 镜像

### 获取镜像（下载镜像）

### 查看镜像信息

### 搜索镜像

### 删除和清理镜像

### 创建镜像

### 存出和存入镜像

### 上传镜像


## Docker 容器

### 创建容器

### 停止容器

### 进入容器

### 删除容器

### 导入和导出容器

### 查看容器

### 其他容器命令


## Docker 仓库

### Docker Hub 公共镜像市场（官方镜像）

### 第三方镜像市场

### 本地私有仓库


## Docker 数据管理

### 数据卷

### 数据卷容器

### 迁移数据（利用数据卷容器）


## 端口映射与容器互联

### 端口映射（容器访问）

### 容器互联（互联机制实现便捷互访）


## 使用Dockerfile创建镜像

### 基本结构

### 指令清单及说明

### 创建镜像
  

# 实战案例

## 操作系统

## 为镜像添加SSH访问

## Web服务与应用

## 数据库应用

## 分布式处理与大数据平台

## 编程开发

## 容器与云服务

## 容器实战及思考


# 进阶技能

## 核心实现技术

## 配置私有仓库

## 安全防护与配置

## 高级网络功能

## libnetwork插件化网络功能


# 开源项目

## Etcd--高可用的键值数据库

## Docker三剑客之Machine

## Docker三剑客之Compose

## Docker三剑客之Swarm

## Mesos--优秀的集群资源调度平台

## Kubernetes--生产级日期集群平台

## 其他相关项目


# 附录


# 参考
  内容来源于书籍《Docker技术入门与实战（第3版）》（杨保华 戴王剑 曹亚仑著）。
