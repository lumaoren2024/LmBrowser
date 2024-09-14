#!/bin/bash

# 获取所有已连接的设备列表
devices=$(adb devices | grep -w "device" | awk '{print $1}')

# 检查是否有设备连接
if [[ -z "$devices" ]]; then
    echo "未检测到设备，请确保设备已连接并启用调试模式。"
    exit 1
fi

# 循环遍历每个设备
for device in $devices; do
    echo "正在处理设备: $device"
    
    # 获取设备的屏幕分辨率
    resolution=$(adb -s $device shell wm size | awk '{print $3}')
    screen_width=$(echo $resolution | cut -d'x' -f1)
    screen_height=$(echo $resolution | cut -d'x' -f2)

    # 检查是否成功获取到分辨率
    if [[ -z "$screen_width" || -z "$screen_height" ]]; then
        echo "未能获取到设备 $device 的屏幕分辨率。"
        continue
    fi

    # 计算屏幕中间的坐标
    x=$((screen_width / 2))
    y=$((screen_height / 2))

    echo "设备 $device 的分辨率为: ${screen_width}x${screen_height}"
    echo "将点击屏幕中间坐标: $x, $y"

    # 点击100次
    for i in {1..100}; do
        adb -s $device shell input tap $x $y
        echo "设备 $device 第 $i 次点击"
        sleep 0.01  # 每次点击后暂停 10 毫秒
    done

    echo "设备 $device 已完成 100 次点击，切换到下一个设备..."
done

echo "所有设备操作完成。"
