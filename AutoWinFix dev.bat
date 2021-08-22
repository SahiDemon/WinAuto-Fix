@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
:restart

title WinAutoFix By SahiDemon
Color 5F & Mode con cols=150 lines=20
SET shut=0
SET re=0
SET ex=0
set /a rand1=%random% %% 16  
set HEX=0123456789ABCDEF
call set hexcolors=%%HEX:~%rand1%,1%%%%HEX:~%rand2%,1%%
color %hexcolors%
echo *********************************************************************************************************************************************
echo ****************************************     Windows Autofix Command Prompt v3.1     *****************************************************
echo **********************************************     Copyright (c) 2021 SahiDemon      ********************************************************
echo *********************************************************************************************************************************************
PING 127.0.0.1 -n 2 > NUL
echo                  _________-----_____
echo        ____------           __      ----_
echo  ___----             ___------              \
echo     ----________        ----                 \
echo                -----__    ^|             _____)    
echo                     __-                /     \
echo         _______-----    ___--          \    /)\
echo   ------_______      ---____            \__/  / 
echo                -----__    \ --    _          /\        
echo                       --__--__     \_____/   \_/\    
echo                               ---^|   /          ^|     
echo                                  ^| ^|___________^|     _____       __    _ ____     
echo                                  ^| ^| ((_(_)^| )_)    / ___/____ _/ /_  (_) __ \___  ____ ___  ____  ____ 
echo                                  ^|  \_((_(_)^|/(_)   \__ \/ __ `/ __ \/ / / / / _ \/ __ `__ \/ __ \/ __ \
echo                                   \             (  ___/ / /_/ / / / / / /_/ /  __/ / / / / / /_/ / / / /
echo                                    \_____________)/____/\__,_/_/ /_/_/_____/\___/_/ /_/ /_/\____/_/ /_/  Software By SahiDemon 1.0v
PING 127.0.0.1 -n 3 > NUL
Set /A "index = 1"
SET /A "count = 50"

:colors
Color 0 
if %index% leq %count% (
   
   SET /A "index = index + 1"
   set /a rand1=0
   set /a rand2=%random% %% 16
   set HEX=0123456789ABCDEF
   call set hexcolors=%%HEX:~%rand1%,1%%%%HEX:~%rand2%,1%%
   color %hexcolors%
   PING 127.0.0.1 -n 1 > NUL
   goto colors
) 

Color 4F
PING 127.0.0.1 -n 2 > NUL


Color 3F & MODE con:cols=80 lines=7
cls

Echo Optimizing The Application  
PING -n 2 127.0.0.1>nul 
cls
Color 4F & MODE con:cols=100 lines=8
Echo DISCLAIMER!
echo.
Echo This Is A Experimental Script That Uses Windows Advance Tools That Fixes Most Common Problems.
Echo This Script Is Totally Not Harmful To Your Computer And This Helps To Optimize And Improve
Echo The Performance Of Your System.
echo.
echo Script By SahiDemon
PING -n 8 127.0.0.1>nul 

Color 3F & MODE con:cols=80 lines=10


cd C:
cls

:choice
echo Select A Option
echo.
echo After Completion

echo Shutdown            = S
echo Restart		    = R
echo Exit Normally       = E
Echo.
set /P n=  Preferred Option [S/R/E]?

if /I "%n%" EQU "S"  goto :shutdown
if /I "%n%" EQU "R"  goto :restart
if /I "%n%" EQU "E"  goto :toexit
cls
echo Try Again Using (shutdown/restart/TO_EXIT))type = [S/R/E]
goto :choice



:rest
cls
echo Entering SmartMode In 5 Seconds..
echo Press Enter For Pro Mode
    call :controlTimeout 5
    if errorlevel 1 (
        echo Redirecting To SmartMode
		goto :skip
		
    ) else (
        echo Redirecting To Manual
		PING 127.0.0.1 -n 2 > NUL
		goto :break
    )

    exit /b 

:controlTimeout 
    setlocal
    start "" /belownormal /b cmd /q /d /c "timeout.exe %~1 /nobreak > nul"
    timeout.exe %~1 & tasklist | find "timeout" >nul 
    if errorlevel 1 ( set "exitCode=0" ) else ( 
        set "exitCode=1"
        taskkill /f /im timeout.exe 2>nul >nul
    )
    endlocal 
endlocal & exit /b %exitCode%


:break
Color 3F & MODE con:cols=80 lines=7 
:choice5
echo Select A Option
echo SYSTEM SCAN            = S
echo CLEANUP MODE           = C
echo WINDOWS_IMG CLEANUP    = W
echo EXIT                   = E
echo.
set /P n=  Preferred Option [S/C/W/E]?

if /I "%n%" EQU "S"  goto :system_scan
if /I "%n%" EQU "C"  goto :cleanup_scan
if /I "%n%" EQU "W"  goto :Windows_image
if /I "%n%" EQU "E"  goto :somewhere
cls
echo Try Again Using (system_scan/cleanup_scan/Windows_image/Restart/TO_EXIT))type = [S/C/W/E]
goto :choice5

:skip
sc config trustedinstaller start=auto
net start trustedinstaller
cls
chkdsk 
cls
echo Select Prefered Files And Press Ok In the Popup
cleanmgr.exe /tuneup:112
DISM.exe /Online /Cleanup-image /Scanhealth && DISM.exe /Online /Cleanup-image /Restorehealth && DISM.exe /online /cleanup-image /startcomponentcleanup
sfc /scannow
sfc /scanfile=c:\windows\system32\kernel32.dll 
goto :active


:system_scan
cls

sc config trustedinstaller start=auto
net start trustedinstaller
sfc /scannow
sfc /scanfile=c:\windows\system32\kernel32.dll
goto :active
:answer
cls
Echo We Could Not Perfrom this Task Due To Error in Your System
PING -n 5 127.0.0.1>nul 
Echo Retry Failed! We Could Not Perfrom this Task Due To Error in Your System
Echo.
Echo Try Using Manually 
PING -n 6 127.0.0.1>nul 
cls
Echo Exiting the Script....
PING -n 3 127.0.0.1>nul 
taskkill /f /im cmd.exe


pause
goto :active

:cleanup_scan
cls
Echo Perfroming Cleanup Scan This May Take A while
PING 127.0.0.1 -n 2 > NUL
Echo Process Completion Successful
chkdsk && cleanmgr.exe /autoclean && cleanmgr.exe /setup && cleanmgr.exe /tuneup:112
goto :active



:Windows_image
cls
Echo Perfroming Windows image scan This May Take A while
PING 127.0.0.1 -n 2 > NUL
DISM.exe /Online /Cleanup-image /Scanhealth  && DISM.exe /Online /Cleanup-image /Restorehealth && DISM.exe /online /cleanup-image /startcomponentcleanup
goto :active


:active
cls
Echo Process Completion Successful
PING -n 2 127.0.0.1>nul 
cls
Echo Redirecting Completion Process
PING -n 2 127.0.0.1>nul 
SET "new=1"
if /I "%shut%" == "%new%" goto :sh
echo.

SET "new=1"
if /I "%re%" == "%new%" goto :Re
echo.
SET "new=1"
if /I "%ex%" == "%new%" goto :Exx
echo.


:somewhere
taskkill /f /im cmd.exe


:shutdown
SET shut=1
goto :rest


:restart
SET re=1
goto :rest


:toexit
set ex=1
goto :rest




:sh
Echo Your System Will Turn Off Within 60 Seconds
PING -n 2 127.0.0.1>nul 
shutdown /s /c "AutoWinFix Will Shutdown Your PC In 60sec" /t 60
goto :somewhere

:Re
Echo Your System Will Restart Within 60 Seconds
PING -n 2 127.0.0.1>nul 
shutdown /r /c "AutoWinFix Will Restart Your PC In 60sec" /t 60
goto :somewhere

:Exx
Echo Exiting Script...
PING -n 2 127.0.0.1>nul 
goto :somewhere


