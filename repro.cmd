@echo off
setlocal

set vstest=vstest.console.exe
set RunNetCoreTests=%vstest% "%CD%\ProjectANetCore\bin\Debug\netcoreapp3.1\ProjectANetCore.dll"
set RunNetFrameworkTests=%vstest% "%CD%\ProjectBNetFramework\bin\Debug\net461\ProjectBNetFramework.dll"

call :VerifyRuntimeEnvironment

set RunMessage=Running .NET Core tests (without TRX logger)
set CmdToExec=%RunNetCoreTests% /TestAdapterPath:"%CD%"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

set RunMessage=Running .NET Framework tests (without TRX logger)
set CmdToExec=%RunNetFrameworkTests% /TestAdapterPath:"%CD%"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

set RunMessage=Running .NET Core tests (with TRX logger, simulating a default Azure DevOps test run)
set CmdToExec=%RunNetCoreTests% /TestAdapterPath:"%CD%" /Logger:"trx"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

set RunMessage=Running .NET Framework tests (with TRX logger, simulating a default Azure DevOps test run)
set CmdToExec=%RunNetFrameworkTests% /TestAdapterPath:"%CD%" /Logger:"trx"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

set RunMessage=Running .NET Core tests (with TRX logger, simulating a default Azure DevOps test run + using a custom test adapter path)
set CmdToExec=%RunNetCoreTests% /TestAdapterPath:"%CD%\ProjectANetCore" /Logger:"trx"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

set RunMessage=Running .NET Framework tests (with TRX logger, simulating a default Azure DevOps test run + using a custom test adapter path)
set CmdToExec=%RunNetFrameworkTests% /TestAdapterPath:"%CD%\ProjectBNetFramework" /Logger:"trx"
call :LogAndExecuteCommand "%RunMessage%" "%CmdToExec%"

@echo.
@echo * Test execution complete!
endlocal
exit /b 0


:VerifyRuntimeEnvironment
setlocal
@echo * Verifying runtime environment
where %vstest%
if %errorlevel% neq 0 (
	@echo  - Failed to locate %vstest% - please run through a VS developer command prompt
	exit /b %errorlevel%
)
endlocal
goto:eof


:LogAndExecuteCommand <RunMessage> <CmdToExec>
setlocal
set RunMessage=%~1
set CmdToExec=%~2
@echo.
@echo.
@echo.
@echo ***************************************************************************************************************************
@echo * %RunMessage%
@echo ***************************************************************************************************************************
@echo  - Executing: %CmdToExec%
%CmdToExec%
endlocal
goto:eof
