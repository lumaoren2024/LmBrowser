// 定义一个函数来点击按钮
function clickButton() {
    // 查找按钮元素
    const button = document.querySelector('button.bg-green-600');
    if (button) {
        button.click(); // 点击按钮
        console.log('按钮已点击');
    } else {
        console.log('按钮未找到');
    }
}

// 每 3 分钟（180000 毫秒）点击一次按钮
setInterval(clickButton, 180000);

// 立即点击一次以确认按钮存在
clickButton();
