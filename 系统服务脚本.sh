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

