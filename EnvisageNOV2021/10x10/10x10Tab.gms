* ------------------------------------------------------------------------------
*
*     Options for creating CSV cubes
*
*     Users typically select years to output and CSV cubes to create
*
* ------------------------------------------------------------------------------

*  Set folder for Excel files

$setGlobal xclDir "v:\env10\EnvisageAUG2020\10x10\doc\"

*  Options for CreatePivot file

$setGlobal indir      %oDir%
$setGlobal wdir       %system.fp%
$setGlobal modDir     "..\Model"

$setGlobal DEPLFlag   OFF
$setGlobal simTgt     BaU
$setGlobal regTgt     EastAsia
$setGlobal timeTgt    2014
$setGlobal actTgt     Agriculture-a
$setGlobal emiRefYear 2005

*  Select report years

$iftheni "%simType%" == "compStat"

   set tr(t) "Reporting years" / base, check, shock / ;
   set trb(t) "Bilateral trade years" / base, check, shock / ;

$elseifi "%simType%" == "RcvDyn"

   set tr(t) "Reporting years" / 2014*2030 / ;
   set trb(t) "Bilateral trade years" / 2014, 2030 / ;

$endif

*  Select reporting activities (a subset of aga -- activities + aggregate activities

set aggaga(aga) "Activities to report" ;

*  Report all

aggaga(aga) = yes ;

set cpiLab / CPIFUD, CPINFD, CPITOT / ;
set mapCPILab(CPINDX,CPILAB) / FUD.cpiFUD, NFD.CPINFD, TOT.CPITOT / ;

set fpagg / nsk, skl, cap, nrs, lnd / ;
set mapfp(fpagg,fp) /
   nsk.unSkLab
   skl.SkLab
   cap.Capital
   nrs.NatRes
   lnd.Land
/ ;

scalar elyPrmNrgConv "Primary electric conversion factor" / 3 / ;

*  Pivot tables to create

*  List of tables

set tables /
   gdppop      "Macro data"
   factp       "Factor prices"
   kappah      "Household direct tax rate"
   rgovshr     "Government expenditures"
   savinv      "Savings investment balance"
   xp          "Output by activity"
   va          "Value added by activity and factor"
   inv         "Investment"
   emi         "Emissions"
   cost        "Production costs"
   ydecomp     "Growth decomposition"
   trade       "Trade by sector"
   fdem        "Final demand"
   bilat       "Bilateral trade"
   lab         "Labor demand"
   pow         "Power module"
   tot         "Terms of trade module"
   nrg         "Energy module"
   depl        "Depletion variables"
   sam         "Social  accounting matrix"
   shock       "For future use"
/ ;

*  Selected tables

set ifTab(tables) /
   gdppop      "Macro data"
   factp       "Factor prices"
*  kappah      "Household direct tax rate"
*  rgovshr     "Government expenditures"
   savinv      "Savings investment balance"
   xp          "Output by activity"
   va          "Value added by activity and factor"
   inv         "Investment"
*  emi         "Emissions"
   cost        "Production costs"
   ydecomp     "Growth decomposition"
   tot         "Terms of trade"
   trade       "Trade by sector"
*  fdem        "Final demand"
   bilat       "Bilateral trade"
*  lab         "Labor demand"
*  pow         "Power sector variables"
*  nrg         "Energy module"
*  depl        "Depletion variables"
   sam         "Social  accounting matrix"
*  shock       "For future use"
/ ;
