#!/bin/bash

# 提示用户选择操作模式
echo "请选择操作模式："
echo "1) 单一打开"
echo "2) 批量打开 (1-1000)"
echo "3) 退出脚本"
read -p "请输入选项 (1, 2, 或 3): " mode

if [ "$mode" == "1" ]; then
    # 单一打开模式
    echo "请输入工作目录中的编号:"
    read user_input

    workdir="你的mac路径/telegram/$user_input"

    if [ ! -d "$workdir" ]; then
        echo "目录不存在: $workdir"
        echo "是否要创建目录? (y/n)"
        read create_dir
        if [ "$create_dir" == "y" ]; then
            mkdir -p "$workdir"
            echo "目录已创建: $workdir"
        else
            echo "退出程序"
            exit 0
        fi
    fi

    /Applications/Telegram.app/Contents/MacOS/Telegram -many -workdir "$workdir" >/dev/null 2>&1 &

elif [ "$mode" == "2" ]; then
    # 批量打开模式
    echo "请输入起始编号:"
    read start_num
    echo "请输入结束编号:"
    read end_num

    if [[ ! "$start_num" =~ ^[0-9]+$ ]] || [[ ! "$end_num" =~ ^[0-9]+$ ]] || [ "$start_num" -gt "$end_num" ]; then
        echo "无效的编号范围"
        exit 1
    fi

    for ((i = $start_num; i <= $end_num; i++)); do
        workdir="你的mac路径/telegram/$i"

        if [ ! -d "$workdir" ]; then
            echo "目录不存在: $workdir"
            echo "是否要创建目录? (y/n)"
            read create_dir
            if [ "$create_dir" == "y" ]; then
                mkdir -p "$workdir"
                echo "目录已创建: $workdir"
            else
                echo "跳过编号 $i"
                continue
            fi
        fi

        /Applications/Telegram.app/Contents/MacOS/Telegram -many -workdir "$workdir" >/dev/null 2>&1 &
    done

    echo "所有指定实例已启动。"

elif [ "$mode" == "3" ]; then
    # 退出脚本
    echo "退出脚本"
    exit 0

else
    echo "无效的选项，程序退出。"
    exit 1
fi

# 退出选项
echo "按任意键退出..."
read -n 1 -s
exit 0
