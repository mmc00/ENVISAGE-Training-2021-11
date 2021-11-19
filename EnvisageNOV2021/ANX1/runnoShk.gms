* --------------------------------------------------------------------------------------------------
*
*  Generic simulation file that can run most simulations both comparative static and
*     dynamic
*
*  Call:
*        gams runSim --simName=%1 --BauName=%2 --simType=%3 --ifCal=%4 --baseName=[basename]
*           --odir=[oDir] -idir=[modDir] -scrdir=[scrDir]
*            -ps=9999 -pw=150
*
*  where:
*     simName  is a name for the simulation, e.g. Homog, BaUSSP2, SSP2CC, etc.
*     BaUName  is a name of a baseline (ignored for comparative static simulations),
*           e.g. BaUSSP2
*     simType  is the type of simulation (CompStat or RcvDyn)
*     ifCal    is the type of dynamic simulation (1=baseline, 0=pre-calibrated)
*     baseName is the basename of the aggregation
*     oDir     is the name of the directory for the output files
*     iDir     is the name of the directory of the core model files
*
*     The other arguments are optional
*
*  Examples:
*     gams runSim --simName=Homog --BaUName=comp --simType=CompStat --ifCal=0 --baseName=10x10
*        --odir=.
*     gams runSim --simName=BaUSSP2 --BaUName=BaUSSP2 --simType=RcvDyn --ifCal=1 --baseName=10x10
*        --odir=c:\Users\Hazard\Output\10x10
*     gams runSim --simName=SSP2CC --BaUName=BaUSSP2 --simType=RcvDyn --ifCal=0 --baseName=10x10
*        --odir=c:\Users\Hazard\Output\10x10
*
*  This file is linked with the command file 'runSim.cmd'
*
* --------------------------------------------------------------------------------------------------

*  Read the key global options and initialize the model

$include "%BaseName%Opt.gms"

*  Initialize dynamic parameters

$iftheni "%simType%" == "RcvDyn"
$include "calDyn.gms"
$endif
*  Loop over all time periods and solve the model (save for the first time period)

loop(tsim$(years(tsim) le 2050),

   ts(tsim) = yes ;

*  Initialize the model for the new time period

   if(ifDyn eq 0,
      $$batinclude "iterloop.gms" startyear
   elseif (ifDyn and ifCal),
      $$batinclude "iterloop.gms" startyear
   elseif (ifDyn and not ifCal),
      $$batinclude "iterloop.gms" startyear
   ) ;

*  If a dynamic simulation, include the standard baseline shocks

   $$iftheni "%simType%" == "RcvDyn"
      $$include "BaUShk.gms"
   $$endif

*  Include the simulation-specific shocks

   $$if exist "%SIMNAME%Shk.gms" $include "%SIMNAME%Shk.gms"

*  Invoke the solver with the appropriate model definition

   if(ord(tsim) gt 1,
      if(ifDyn eq 0,
         options limrow=300, limcol=3, solprint=off,iterlim=10000 ;
         $$batinclude "solve.gms" core
         put logFile ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "SolveStat", core.solveStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "ModelStat", core.modelStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numInfes",  core.numInfes  / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numRedef",  core.numRedef / ;

      elseif(ifDyn and ifCal),
         options limrow=3000, limcol=3, solprint=off, iterlim=10000 ;
         if(years(tsim) eq 2221 or years(tsim) eq 2223,
            options solprint = on, limrow=0, limcol=0, iterlim=10000 ;
         else
            options solprint=off ;
         ) ;
         if(dynPhase ge 5,
            $$batinclude "solve.gms" coreBaU
         else
            $$batinclude "solve.gms" coreDyn
         ) ;
         if(years(tsim) eq 2221, abort "Temp" ; ) ;
         put logFile ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "SolveStat", coreBaU.solveStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "ModelStat", coreBaU.modelStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numInfes",  coreBaU.numInfes  / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numRedef",  coreBaU.numRedef / ;
      elseif(ifDyn and not ifCal),
         options limrow=0, limcol=0, solprint=off, iterlim=10000 ;
         if(years(tsim) eq 2050,
            options solprint = on, limrow=0, limcol=0, iterlim=10000 ;
         else
            options solprint=off ;
         ) ;
         $$batinclude "solve.gms" coreDyn
         put logFile ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "SolveStat", coreDyn.solveStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "ModelStat", coreDyn.modelStat / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numInfes",  coreDyn.numInfes  / ;
         put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "numRedef",  coreDyn.numRedef / ;
      ) ;
      put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "Walras",  walras.l(tsim):15:7 / ;

   else
*     Initialize the log file

      $$ifthen exist "%basename%Log.CSV"
         logFile.ap = 1 ;
         logfile.pc = 5 ;
         put logFile ;
      $$else
         logFile.ap = 0 ;
         put logFile ;
         put "SimID,SimName,Year,Indicator,Value" / ;
         logfile.pc = 5 ;
      $$endif

      put startTime:14:0, "%SIMNAME%", PUTYEAR(tsim), "Walras",  walras.l(tsim):15:7 / ;
   ) ;

   display walras.l ;

   put debug ;
   loop((r,a,vOld)$(xp0(r,a) and xpv.l(r,a,vOld,tsim) eq xpv.lo(r,a,vOld,tsim)),
      put '         xpv.l("', r.tl:card(r.tl),'","', a.tl:card(a.tl), '","Old","',tsim.val:4:0,'") = ', sum(v$vNew(v), xpv.l(r,a,v,tsim)):7:2, ' ;' / ;
      put '         xpv.l("', r.tl:card(r.tl),'","', a.tl:card(a.tl), '","New","',tsim.val:4:0,'") = ', 0.01:7:2, ' ;' / ;
   ) ;
   loop((r,a,NRG,vOld)$(xaNRG0(r,a,NRG) and paNRG.l(r,a,NRG,vOld,tsim) eq paNRG.lo(r,a,NRG,vOld,tsim)),
      put '         paNRG.l("', r.tl:card(r.tl),'","', a.tl:card(a.tl), '","', NRG.tl:card(NRG.tl), '","Old","',tsim.val:4:0,'") = ', (1):7:2, ' ;' / ;
   ) ;
   loop((r,a,v)$(xp0(r,a) and pk.l(r,a,v,tsim) eq pk.lo(r,a,v,tsim)),
      put '         pk.l("', r.tl:card(r.tl),'","', a.tl:card(a.tl), '","', v.tl:card(v.tl), '","', tsim.val:4:0,'") = ', trent.l(r,tsim):7:2, ' ;' / ;
   ) ;

*  Update the SAM

   $$include "sam.gms"

   ts(tsim) = no ;
) ;

*  Save the CSV-formatted results

$include "postsim.gms"

$ifthen exist "%BASENAME%PSM.gms"
   $$include "%BASENAME%PSM.gms"
$endif

$ontext
file nrgcsv / nrgParm.csv / ;

$include "nrgParm.gms"
$offtext

*  Save the full simulation results in a GDX container

execute_unload "%odir%\%SIMNAME%.gdx" ;

$iftheni "%simType%" == "RcvDyn"

*  This is still undergoing testing and is only appropriate for the 10x10 model
*
*  Save the key model parameters for the baseline simulation

   if(ifCal,
      $$setGlobal IFSAVEPARM    1
   else
      $$setGlobal IFSAVEPARM    0
   ) ;

$else

$ontext
   file wcsv / wtf.csv / ;
   $$include "wtf.gms"
$offtext
$endif

$ifthen "%IFSAVEPARM%" == "1"

   scalar ifCSVVerbose / 0 / ;

   set sortOrder / sort1*sort1000 / ;

   set mapRegSort(sortOrder,r) /
      sort1.Oceania
      sort2.EU_25
      sort3.NAmerica
      sort4.EastAsia
      sort5.SEAsia
      sort6.SouthAsia
      sort7.MENA
      sort8.SSA
      sort9.LatinAmer
      sort10.RestofWorld
   / ;

   set mapActSort(sortOrder,a) /
      sort1."Agriculture-a"
      sort2."Extraction-a"
      sort3."ProcFood-a"
      sort4."TextWapp-a"
      sort5."LightMnfc-a"
      sort6."HeavyMnfc-a"
      sort7."Util_Cons-a"
      sort8."TransComm-a"
      sort9."OthServices-a"
   / ;

   set mapCommSort(sortOrder,i) /
      sort1."GrainsCrops-c"
      sort2."MeatLstk-c"
      sort3."Extraction-c"
      sort4."ProcFood-c"
      sort5."TextWapp-c"
      sort6."LightMnfc-c"
      sort7."HeavyMnfc-c"
      sort8."Util_Cons-c"
      sort9."TransComm-c"
      sort10."OthServices-c"
   / ;

   set mapkCommSort(sortOrder,k) /
      Sort1."GrainsCrops-k"
      Sort2."MeatLstk-k"
      Sort3."Energy-k"
      Sort4."ProcFood-k"
      Sort5."TextWapp-k"
      Sort6."LightMnfc-k"
      Sort7."HeavyMnfc-k"
      Sort8."TransComm-k"
      Sort9."OthServices-k"
   / ;

   $$include "saveParm.gms"

$endif
