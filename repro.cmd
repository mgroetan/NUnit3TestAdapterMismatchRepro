@echo off
setlocal

set vstest=vstest.console.exe
set TestAdapterPathOption=/TestAdapterPath:"%CD%"
set TestAdapterTrxLoggerOption=/Logger:"trx"
set RunNetCoreTests=%vstest% "%CD%\ProjectANetCore\bin\Debug\netcoreapp3.1\ProjectANetCore.dll" %TestAdapterPathOption%
set RunNetFrameworkTests=%vstest% "%CD%\ProjectBNetFramework\bin\Debug\net461\ProjectBNetFramework.dll" %TestAdapterPathOption%

@echo * Verifying runtime environment
where %vstest%
if %errorlevel% neq 0 (
	@echo  - Failed to locate %vstest% - please run through a VS developer command prompt
	exit /b %errorlevel%
)

call :RunTests false
call :RunTests true

@echo.
@echo * Test execution complete!
endlocal
exit /b 0


:RunTests <RunWithTrxLogger>
setlocal

set RunWithTrxLogger=%1
if "%RunWithTrxLogger%" equ "false" set RunMessage=without TRX logger
if "%RunWithTrxLogger%" equ "true" (
	set RunMessage=with TRX logger, simulating a default Azure DevOps test run
	set TestAdapterLoggerOption=%TestAdapterTrxLoggerOption%
)

@echo.
@echo * Running .NET Core tests (%RunMessage%)
%RunNetCoreTests% %TestAdapterLoggerOption%

@echo.
@echo * Running .NET Framework tests (%RunMessage%)
%RunNetFrameworkTests% %TestAdapterLoggerOption%

endlocal
goto:eof
