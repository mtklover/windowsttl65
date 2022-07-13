@echo off
COLOR 0A
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
@ECHO OFF
TITLE TTL/HOPLIMIT 65 WINDOWS
ECHO COMENZANDO FASE 1: FLOSHEANDO CACHE DNS ...
PAUSE
ECHO 
ipconfig /release
ipconfig /renew
arp -d *
nbtstat -R
nbtstat -RR
ipconfig /flushdns
ipconfig /registerdns
ECHO FASE 1 COMPLETADA
PAUSE
ECHO COMENZANDO FASE 2: APLICANDO PARCHEO DE TTL (IPV4) Y HOPLIMIT (IPV6).
netsh int ipv4 set global defaultcurhoplimit=65 store=persistent
ECHO PARCHEO DE TTL APLICADO
PAUSE
netsh int ipv6 set global defaultcurhoplimit=65 store=persistent
ECHO PARCHEO DE HOPLIMIT APLICADO 
PAUSE
ECHO PARCHEO EJECUTADO SIN PROBLEMAS. - KUSHPR
PAUSE
