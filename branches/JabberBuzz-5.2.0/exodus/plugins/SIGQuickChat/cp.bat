copy ..\SIGQuickChat.dll "C:\Program Files\Exodus\Plugins\SIGQuickChat.dll"
if errorlevel 1 goto BAD

rem copy ..\SIGScreener.dll "C:\Program Files\Exodus\Plugins\SIGScreener.dll"
if errorlevel 1 goto BAD

rem copy ..\..\Exodus.exe "C:\Program Files\Exodus\"
if errorlevel 1 goto BAD

goto DONE
:BAD
pause
:DONE