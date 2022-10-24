@echo off
color 0A

set fw_name=webd
set exe="%~dp0%fw_name%.exe"

if not "%1" == "" (
	call :%1
	pause
	exit /b 0
)

set is_admin=0
whoami /groups | find "S-1-16-12288" && (
	color 0c
	set is_admin=1
)

for /f "tokens=3" %%l in ('reg query "hklm\system\controlset001\control\nls\language" /v installlanguage') do set lng=%%l
if not "%lng%" == "0804" set lng=0000

:loop
cls
set id=0
call :menu_%lng%
if "%id%" == "0" exit /b 0
call :cmd_%id%
pause
goto loop

:menu_0000
echo. 1.Add auto start.
echo.
echo. 2.Remove auto start.
echo.
echo. 3.Create shortcut.
echo.
echo. 4.Remove shortcut.
echo.
if %is_admin% equ 1 (
echo. 5.Add firewall rule.
echo.
echo. 6.Remove firewall rule.
echo.
)
echo. 0.Quit.
echo.
set /p id=Enter Choice: 
exit /b 0

:menu_0804
echo. 1.添加自动启动
echo.
echo. 2.取消自动启动
echo.
echo. 3.添加桌面快捷方式
echo.
echo. 4.删除桌面快捷方式
echo.
if %is_admin% equ 1 (
echo. 5.开启防火墙端口
echo.
echo. 6.关闭防火墙端口
echo.
)
echo. 0.退出
echo.
set /p id=选择菜单: 
exit /b 0

:cmd_1
:autostart
cscript //Nologo "%~dp0scripts\comm.wsf" Startup %fw_name% "%~dp0"
exit /b 0

:cmd_2
cscript //Nologo "%~dp0scripts\comm.wsf" Startup %fw_name%
exit /b 0

:cmd_3
:shortcut
cscript //Nologo "%~dp0scripts\comm.wsf" Desktop %fw_name% "%~dp0"
exit /b 0

:cmd_4
cscript //Nologo "%~dp0scripts\comm.wsf" Desktop %fw_name%
exit /b 0

:cmd_5
:fw_add
call :fw_del > nul
echo Add firewall rule:
netsh advfirewall firewall add rule name=%fw_name% dir=in action=allow program=%exe%
exit /B 0

:cmd_6
:fw_del
netsh advfirewall firewall delete rule name=%fw_name%
exit /B 0
