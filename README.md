# 高仿指纹浏览器的功能 MAC 版本

## 1、实现浏览器多开，互不影响

### 1、打开：浏览器多开脚本 mac.sh

修改里面的`/Users/sands/lumao_Chrome/`的路径

```bash
# 这个位置
chrome_path="/Users/sands/lumao_Chrome/"
```

### 2、给予脚本权限

比如你的脚本名叫`chrome.sh`那么我们就给这个文件全部权限

```bash
chmod +x chrome.sh
```

## 2、现实每一个浏览器一个代理

`代理池是在ubuntu下的，别在mac下执行哦`

我们要实现每一个浏览器一个代理的话，那么我们需要代理池。代理池应该很多的 ip 代理！理解这个原理以后我们就开干吧！

这一步我们需要在自己的局域网有一台 ububtu 系统的虚拟机或者实体机。这里我们可以在 win 下按照 vm 体验！安装教程我就不在这里重复的说，网上很多这样的教程。

### 2.1 建立代理池

机场地址：https://psub.661122.xyz/sub?target=clash&url=https://d.minions.us.kg/sub/89b3cbba-e6ac-485a-9481-976a0415eab9

我们看到这个机场地址是 clash，我们需要把他们的代理提取出来！

修改`代理提取.py`文件名字和里面的目录路径，

安装 python 插件

```bash
pip install PyYAML
```

运行`代理提取.py`

```bash
python3 代理提取.py
```

在执行中我们根目录会出现`proxy_1.yaml`,在`proxy_providers`目录下会出现很多代理池的节点。到此我们的代理池就弄好。

### 2、2 利用 clash 软件实现全部代理池在线

我们首选`mihomo`大佬的软件，[https://github.com/MetaCubeX/mihomo/releases](https://github.com/MetaCubeX/mihomo/releases)
不知道下载哪个的话就通过我的网盘下载吧：[https://drive.google.com/file/d/1c9FkArKwJub2FfwxGBNOXe7Coj4NR8ha/view?usp=sharing](https://drive.google.com/file/d/1c9FkArKwJub2FfwxGBNOXe7Coj4NR8ha/view?usp=sharing)

怕不安全又不知道下载哪个？那就得靠自己努力一个一个试试！

下载完成以后打开`config`目录。修改`yaml`文件
下面需要修改的地方，基本都是端口，每一个 yaml 文件的端口都不要重复。不然会出现端口冲突的提示，并且无法使用！

```yaml
port: 7890 #http代理端口
socks-port: 7891 #socks5代理端口
allow-lan: true
mode: Rule
log-level: info
tcp-concurrent: true
external-controller: :9090 #ui控制面板访问端口
external-ui: ./ui
geodata-mode: true
global-client-fingerprint: chrome
profile:
  store-selected: true
sniffer:
  enable: true
  force-dns-mapping: true
  parse-pure-ip: true
  force-domain:
    - "+.netflix.com"
    - "+.nflxvideo.net"
    - "+.amazonaws.com"
    - "+.media.dssott.com"
  skip-domain:
    - "+.apple.com"
    - Mijia Cloud
    - dlg.io.mi.com
  sniff:
    TLS:
    HTTP:
      ports:
        - 80
        - 8080-8880
      override-destination: true
tun:
  enable: true #需要修改为true
  stack: mixed
  dns-hijack:
    - "any:53"
  auto-route: true
  auto-detect-interface: true

dns:
  enable: true #需要修改为true
  listen: :1076 #每一个端口都不能重复
  ipv6: true
  enhanced-mode: fake-ip
  fake-ip-range: 28.0.0.1/8
  fake-ip-filter:
    - "*"
    - "+.lan"
    - "+.local"
  default-nameserver:
    - 223.5.5.5
    - 119.29.29.29
    - 114.114.114.114
    - "[2402:4e00::]"
    - "[2400:3200::1]"
  nameserver:
    - "tls://8.8.4.4#dns"
    - "tls://1.0.0.1#dns"
    - "tls://[2001:4860:4860::8844]#dns"
    - "tls://[2606:4700:4700::1001]#dns"
  proxy-server-nameserver:
    - https://doh.pub/dns-query
  nameserver-policy:
    "geosite:cn,private":
      - https://doh.pub/dns-query
      - https://dns.alidns.com/dns-query

experimental:
  ignore-resolve-fail: true
unified-delay: true

proxy-groups:
  - name: PROXY
    type: select
    proxies:
      - lumao1
      - DIRECT

  - name: "lumao1"
    # type: url-test 自动选择最快的线路 type: select 手动选择
    type: url-test
    use:
      - provider1
    url: "http://www.gstatic.com/generate_204"
    interval: 300
    tolerance: 50

proxy-providers:
  provider1:
    type: file
    path: /root/lumao/proxy_providers/proxy_1_proxy_1.yaml
    interval: 3600
    health-check:
      enable: true
      url: https://www.gstatic.com/generate_204
      interval: 300
      timeout: 5000
      expected-status: 204
    override:
      udp: true
```

### 2.3 把 mihomo 加入服务，方便管理

我这个直接写了一个脚本,如果你的目录和我的不一样，那么你直接修改`service_file`这个配置

```bash
#!/bin/bash

# Prompt the user for the service name
read -p "请输入服务名称（例如：lumao20）: " service_name

# Define the config file path
config_file="/root/lumao/config/${service_name}.yaml"

# Check if the config file exists
if [[ ! -f "$config_file" ]]; then
  echo "配置文件 ${config_file} 不存在，请检查路径并重试。"
  exit 1
fi

# Define the service file path
service_file="/etc/systemd/system/${service_name}.service"

# Create the systemd service file
cat << EOF > "$service_file"
[Unit]
Description=mihomo Daemon, Another Clash Kernel.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart=/usr/local/bin/mihomo -f $config_file
ExecReload=/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon to recognize the new service file
systemctl daemon-reload

# Enable the service to start at boot
systemctl enable "${service_name}"

# Start the service immediately
systemctl start "${service_name}"

# Reload the service
systemctl reload "${service_name}"

echo "服务 ${service_name} 已创建并启动。"

echo "使用以下命令检查 ${service_name}  的运行状况： systemctl status  ${service_name} "

echo "使用以下命令检查 ${service_name} 的运行日志：journalctl -u ${service_name} -o cat -e"

```

常用命令：
使用以下命令重新加载 systemd:
启用 lumao1 服务：

```bash
systemctl daemon-reload
```

使用以下命令立即启动 lumao1:

```bash
systemctl enable lumao1
```

使用以下命令使 lumao1 重新加载：

```bash
systemctl start lumao1
```

使用以下命令检查 mihomo 的运行状况：

```bash
systemctl reload lumao19
```

使用以下命令检查 mihomo 的运行日志：

```bash
systemctl status lumao1
```

```bash
journalctl -u lumao1 -o cat -e
#或
journalctl -u lumao1 -o cat -f
```

代理池就搭建好了。你有多少个浏览器那么我们就建立多个服务，比如:lumao1,lumao2,lumao3,lumao4.......lumao100,记得增加config目录的yaml文件就可以啦！

## 3、测试代理池

我们在浏览器安装插件：[https://chrome.google.com/webstore/detail/infajoaodhhdogakhloedbppcbeajhoo](https://chrome.google.com/webstore/detail/infajoaodhhdogakhloedbppcbeajhoo)

访问 web 控制面板: http://192.168.1.2:9090/ui

http 代理：192.168.1.7:7890

scoks5 代理：192.168.1.7:7891

在插件里面设置就可以啦！
然后访问：https://ip.sb 看看是不是和你的 lumao1 的 ip 一样

## 4、同步操作浏览器脚本

还没完成

## 5、打包成软件运行

目前还没这个计划，开源比较好！
