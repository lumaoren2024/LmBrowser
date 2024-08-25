@echo off
REM 提示用户输入起始值
echo Enter the starting number:

REM 让用户输入起始值
set /p start=Enter Start number:

REM 检查用户输入是否是数字
setlocal EnableDelayedExpansion
echo !start!| findstr /R "^[0-9]*$" >nul
if errorlevel 1 (
    echo The entered number is not a valid number.
    goto :eof
)

REM 提示用户输入循环次数
echo Enter the ending number:

REM 让用户输入循环次数
set /p loop=Enter End number:

REM 检查用户输入是否是数字
echo !loop!| findstr /R "^[0-9]*$" >nul
if errorlevel 1 (
    echo The entered number is not a valid number.
    goto :eof
)

REM 定义随机语言、用户代理和时区
set "langs=en-US,fr-FR,de-DE"
set "user_agents=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36, Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"
set "tzs=America/New_York,Europe/Paris,Asia/Tokyo"

REM 启动指定数量的 Chrome 浏览器
for /l %%i in (%start%,1,%loop%) do (
    REM 设置配置文件路径
    set "config_file=C:\lumao\chrome\Chrome%%i\config.txt"

    REM 检查是否存在配置文件
    if exist "%config_file%" (
        REM 如果存在，读取配置文件中的设置
        for /f "tokens=1,2,3 delims=," %%a in ('type "%config_file%"') do (
            set "lang=%%a"
            set "user_agent=%%b"
            set "tz=%%c"
        )
    ) else (
        REM 如果不存在，随机选择语言、用户代理和时区
        set /a rand_lang=!random! %% 3
        set /a rand_agent=!random! %% 2
        set /a rand_tz=!random! %% 3

        for /f "tokens=%rand_lang% delims=," %%l in ("%langs%") do set lang=%%l
        for /f "tokens=%rand_agent% delims=," %%a in ("%user_agents%") do set user_agent=%%a
        for /f "tokens=%rand_tz% delims=," %%t in ("%tzs%") do set tz=%%t

        REM 保存设置到配置文件
        echo %lang%,%user_agent%,%tz% > "%config_file%"
    )

    REM 启动 Chrome 浏览器
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --user-data-dir="C:\lumao\chrome\Chrome%%i" --lang=%lang% --user-agent="%user_agent%" --timezone="UTC%tz%"
)
