@ECHO OFF&PUSHD %~DP0 &TITLE 判断DOS批处理文件是否以管理员运行

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' EQU '0' (
    echo 当前脚本正在使用管理员身份运行
) else (
    echo 当前脚本正在使用普通身份运行
)

::该方法是在一些流氓软件的看到的..   很是不错
::【&&】 连接两个命令，当&&前的命令成功时，才执行&&后的命令。   
::【||】 连接两个命令，当||前的命令失败时，才执行||后的命令。
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
 
echo 当前是管理员运行了
pause >NUL && EXIT