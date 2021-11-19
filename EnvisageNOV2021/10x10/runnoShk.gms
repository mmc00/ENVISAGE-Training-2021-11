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

*  Loop over all time periods and solve the model (save for the first time period)

loop(tsim$(years(tsim) le (1*finalYear + 0*2015)),

   ts(tsim) = yes ;

*  Initialize the model for the new time period

   display kslo.l, kv.l ;

   if(ifDyn eq 0,
      $$batinclude "iterloop.gms" startYear
   elseif (ifDyn and ifCal),
      $$batinclude "iterloop.gms" startYear
   elseif (ifDyn and not ifCal),
      $$batinclude "iterloop.gms" startYear
   ) ;

   display kslo.l, kv.l ;

*  If a dynamic simulation, include the standard baseline shocks

   $$iftheni "%simType%" == "RcvDyn"
      $$include "BaUShk.gms"
   $$endif

*  Include the simulation-specific shocks

   $$if exist "%SIMNAME%Shk.gms" $include "%SIMNAME%Shk.gms"

$ondotl
   pfp.l(r,f,a,tsim) = 1/m_pfp(r,f,a,tsim) ;
$offdotl

   display xf.l, pf.l ;

*  Invoke the solver with the appropriate model definition

   if(ord(tsim) gt 1,
      if(ifDyn eq 0,
         options limrow=0, limcol=0, iterlim=1000, reslim=1000 ;
         $$batinclude "solve.gms" core
      elseif(ifDyn and ifCal),
         options limrow=0, limcol=0, iterlim=1000, reslim=100 ;
         $$batinclude "solve.gms" coreBaU
      elseif(ifDyn and not ifCal),
         options limrow=3, limcol=3 ;
         $$batinclude "solve.gms" coreDyn
      ) ;
   ) ;

   display walras.l ;

*  Update the SAM

   $$include "sam.gms"

   ts(tsim) = no ;

) ;

*  Save the CSV-formatted results

$include "postsim.gms"

*  Save the full simulation results in a GDX container

execute_unload "%odir%\%SIMNAME%.gdx" ;

* Special treatment

set isa / acts, comm, lab, cap, hhd, gov, inv, mtax, hic, lmy, bop / ;
set rsa(isa) / hic, lmy / ;
alias(jsa,isa) ;

set mapis(is,isa) /
   Agriculture-a . acts
   Extraction-a . acts
   ProcFood-a . acts
   TextWapp-a . acts
   LightMnfc-a . acts
   HeavyMnfc-a . acts
   Util_Cons-a . acts
   TransComm-a . acts
   OthServices-a . acts

   GrainsCrops-c . comm
   MeatLstk-c . comm
   Extraction-c . comm
   ProcFood-c . comm
   TextWapp-c . comm
   LightMnfc-c . comm
   HeavyMnfc-c . comm
   Util_Cons-c . comm
   TransComm-c . comm
   OthServices-c . comm

   Land     .cap
   Capital  .cap
   unSkLab  .lab
   SkLab    .lab
   NatRes   .cap
*  TRD               "Trade account"
*  regY              "Regional household"
   hhd      .hhd
   gov      .gov
   inv      .inv
   deprY    .inv
*  tmg               "Trade margins"
*  itax              "Indirect tax"
*  ptax              "Production tax"
   mtax     .mtax
*  etax              "Export tax"
*  vtax              "Taxes on factors of production"
*  ltax              "Taxes on labor use"
*  ktax              "Taxes on capital use"
*  rtax              "Taxes on natural resource use"
*  vsub              "Subsidies on factors of production"
*  wtax              "Waste tax"
   dtax     .gov
*  ctax              "Carbon tax"
*  ntmY              "NTM revenues"

   Oceania           .hic
   EastAsia          .lmy
   SEAsia            .lmy
   SouthAsia         .lmy
   NAmerica          .hic
   LatinAmer         .lmy
   EU_28             .hic
   MENA              .lmy
   SSA               .lmy
   RestofWorld       .lmy

   bop               .bop
*  tot               "Total for row/column sums"
/ ;

$ontext
file aggcsv / aggsam.csv / ;
put aggcsv ;
put "Region,Rlab,Clab,Value" / ;
aggcsv.pc=5 ;
loop((rsa,t)$(sameas(t,"Shock")),
   loop((isa,jsa),
      work = sum((r,is,js)$(sam(r,is,js,t) and mapis(r,rsa) and mapis(is,isa) and mapis(js,jsa)), sam(r,is,js,t)) ;
      if(work,
         put rsa.tl, isa.tl, jsa.tl, (work/inscale) / ;
      ) ;
   ) ;
) ;
$offtext

$iftheni "%simType%" == "RcvDyn"

*  This is still undergoing testing and is only appropriate for the 10x10 model
*
*  Save the key model parameters for the baseline simulation

if(ifCal,
$setGlobal IFSAVEPARM    1
else
$setGlobal IFSAVEPARM    0
) ;

$endif

$ifthen "%IFSAVEPARM%" == "1"

scalar ifCSVVerbose / 0 / ;

set sortOrder / sort1*sort1000 / ;

set mapRegSort(sortOrder,r) /
   sort1.Oceania
   sort2.EU_28
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

$include "saveParm.gms"

$endif
