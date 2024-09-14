#!/bin/bash

# 获取设备屏幕的分辨率
resolution=$(adb shell wm size | awk '{print $3}')
screen_width=$(echo $resolution | cut -d'x' -f1)
screen_height=$(echo $resolution | cut -d'x' -f2)

# 检查是否成功获取到分辨率
if [[ -z "$screen_width" || -z "$screen_height" ]]; then
    echo "未能获取到屏幕分辨率，请确保设备已连接并启用调试模式。"
    exit 1
fi

# 计算屏幕中间的坐标
x=$((screen_width / 2))
y=$((screen_height / 2))

echo "Screen resolution: ${screen_width}x${screen_height}"
echo "Tapping at: $x, $y"

# 开始每 10 毫秒点击一次屏幕中间
while true; do
    adb shell input tap $x $y
    sleep 0.1 # 每次点击后暂停 10 毫秒
done
