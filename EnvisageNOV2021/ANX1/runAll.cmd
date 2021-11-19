@echo off
setlocal enableDelayedExpansion
set baseName=ANX1
set oDir=z:\Output\Env10\%baseName%

goto BaU

:BaU

set ifError=0
copy runsim.gms runBaU.gms
call gams runBaU --simName=BaU --BauName=BaU --startName=BaU --startYear=2050 --simType=RcvDyn --ifCal=1 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

set ifError=0
copy runsim.gms runnoShk.gms
call gams runnoShk --simName=noShk --BauName=BaU --startName=BaU --startYear=2050 --simType=RcvDyn --ifCal=0 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:BaU1

set ifError=0
copy runsim.gms runBaU.gms
call gams runBaU --simName=BaU1 --BauName=BaU0 --startName=BaU0 --startYear=2050 --simType=RcvDyn --ifCal=1 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:BaU2

set ifError=0
copy runsim.gms runBaU.gms
call gams runBaU --simName=BaU2 --BauName=BaU1 --startName=BaU2 --startYear=2035 --simType=RcvDyn --ifCal=1 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:noShk

set ifError=0
copy runsim.gms runnoShk.gms
call gams runnoShk --simName=noShk --BauName=BaU --startName=BaU --startYear=2050 --simType=RcvDyn --ifCal=0 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:cTax

set ifError=0
copy runsim.gms runCtax.gms
call gams runCtax --simName=Ctax --BauName=BaU --startName=cTax --startYear=2050 --simType=RcvDyn --ifCal=0 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:Covid

set ifError=0
copy runsim.gms runCovid.gms
call gams runCovid --simName=Covid --BauName=BaU --startName=Covid --startYear=2020 --simType=RcvDyn --ifCal=0 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:ctax

set ifError=0
copy runsim.gms runCtax.gms
call gams runCtax --simName=Ctax --BauName=BaU --startName=Ctax --startYear=2030 --simType=RcvDyn --ifCal=0 --baseName=%baseName% --odir=%oDir% -idir=..\Model -scrdir=%oDir% -ps=99999 -pw=150 -errmsg=1
echo.ErrorLevel = !errorlevel!
if %errorlevel% NEQ 0 (
   goto simError
)

goto endcmd

:simError
echo.Simulation failed, check listing file
set ifError=1
goto endCMD

:endCMD
if %ifError%==0 (
   echo.Successful conclusion...
   exit /b 0
) else (
   echo.Runsim failed...
   exit /b 1
)
