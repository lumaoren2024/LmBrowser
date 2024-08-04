#!/bin/bash
clear

echo "+------------------------------------------------------------------------+"
echo "|                           开启撸毛生活                                   |"
echo "+------------------------------------------------------------------------+"
echo "|                              省钱版本                                   |"
echo "+------------------------------------------------------------------------+"

# 设置固定的 Chrome 实例文件夹路径
chrome_path="/Users/sands/lumao_Chrome/"

# 确保路径以 / 结尾
if [[ ! $chrome_path =~ /$ ]]; then
  chrome_path="${chrome_path}/"
fi

# 检查文件夹是否存在
if [ -d "$chrome_path" ]; then
  echo "文件夹存在"
else
  echo "文件夹不存在, 脚本自动创建"
  mkdir -p "$chrome_path"
fi

# 提示用户是否生成新的 Chrome 实例
read -r -p "生成新的 Chrome? [Y/n] " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # 转换为小写

if [[ $response =~ ^(yes|y| ) ]]; then
  # 提示用户输入要打开的浏览器实例数量
  read -r -p "请输入要打开的 Chrome 实例数量（1-10）: " instance_count

  # 验证用户输入是数字且在 1 到 10 之间
  if ! [[ $instance_count =~ ^[1-9]$|^10$ ]]; then
    echo "请输入有效的数字（1-10）。"
    exit 1
  fi

  # 循环创建并启动指定数量的 Chrome 实例
  for ((i = 1; i <= instance_count; i++)); do
    # 自动生成实例名称
    instance_name="lumao$i"
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="${chrome_path}${instance_name}" >/dev/null 2>&1 &
    echo "启动 Chrome 实例 $i 名称: $instance_name"
  done

  # 修改目录权限
  chmod -R 0777 "${chrome_path}"
fi
