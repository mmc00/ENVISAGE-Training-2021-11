* --------------------------------------------------------------------------------------------------
*
*  Define a first set of global options
*
*     wdir        Active directory (normally not changed)
*     SSPMOD      Either OECD or IIASA
*     SSPSCEN     SSP1, SSP2, SSP3, SSP4, or SSP5
*     LABSCEN     SSP1, SSP2, SSP3, SSP4, or SSP5
*     POPSCEN     SSP1, SSP2, SSP3, SSP4, SSP5, UNMED2010, UNMED2012, UNMED2015, GIDD
*     OVERLAYPOP  0=keep GTAP base year pop level, 1=use SSP pop level for 2011
*     TASS        Aggregate land supply function: KELAS, LOGIST, HYPERB, INFTY
*     WASS        Aggregate water supply function: KELAS, LOGIST, HYPERB, INFTY
*     utility     CD, LES, ELES, AIDADS, CDE
*     NRITER      Best to keep 0 for the moment
*     savfFlag    Set to capFix for fixed foreign savings, set to capFlexGTAP for endogenous savf
*     NTMFlag     Set to 1 (for use of NTM) or 0
*
* --------------------------------------------------------------------------------------------------

$setGlobal wdir         %system.fp%
$setGlobal SSPMOD       OECD
$setGlobal SSPSCEN      SSP2
$setGlobal LABSCEN      SSP2
$setGlobal POPSCEN      SSP2
$setGlobal OVERLAYPOP   0
$setGlobal TASS         LOGIST
*$setGlobal TASS         INFTY
$setGlobal WASS         LOGIST
$setGlobal utility      CDE
$setGlobal NRITER       0
$setGlobal savfFlag     capFix
$setGlobal intRate      0.05
$setGlobal costCurve    HYPERB
$setGlobal NTMFlag      0
$setGlobal ifETS        OFF
$setGlobal MRIO_MODULE  ON
$setGlobal RD_MODULE    OFF
$setGlobal DEPL_MODULE  OFF

$iftheni "%simType%" == "compStat"

*  Define dynamic setup for a comparative static simulation

sets
   $$iftheni "%simName%" == "Comp"
      tt       "Full time horizon"        / base, check, shock /
      t(tt)    "Simulation time horizon"  / base, check, shock /
      t0(t)    "Base year"                / base /
   $$else
      tt       "Full time horizon"        / base, ROW, SSA, ITT, TOU, DEM /
      t(tt)    "Simulation time horizon"  / base, ROW, SSA, ITT, TOU, DEM /
      t0(t)    "Base year"                / base /
   $$endif
   v        "Vintages"                 / Old /
   vOld(v)  "Old vintage"              / Old /
   vNew(v)  "New vintage"              / Old /
;

singleton set t00(t)                   / base / ;

parameters
   years(tt)      "Contains years in value (dynamic)"
   firstYear      "First year of full time horizon"
   baseYear       "Simulation base year"
   finalYear      "Simulation final year"
   gap(t)         "Time-step"
;

years(tt) = ord(tt) ;
gap(t)    = 1 ;
firstYear = smin(tt,years(tt)) ;
loop(t0, baseYear = years(t0) ; ) ;
finalYear = smax(t,years(t)) ;

Scalars
   ifDyn       Set to 1 for dynamic simulation         / 0 /
   ifCal       Set to 1 for dynamic calibration        / 0 /
   ifVint      Set to 1 for vintage capital spec       / 0 /
;

$elseifi "%simType%" == "RcvDyn"

*  Define dynamic setup for a dynamic simulation
*  tt must start in 2007 because of scenario file

sets
   tt       "Full time horizon"                / 1960*2100 /
   t(tt)    "Simulation time horizon"          / 2014*2030 /
   t0(t)    "Base year"                        / 2014 /
   tf0(t)   "Year for starting savf phaseout"  / 2030 /
   tfT(t)   "Year for finishing savf phaseout" / 2030 /
   v        "Vintages"                         / Old, New /
   vOld(v)  "Old vintage"                      / Old /
   vNew(v)  "New vintage"                      / New /
;

singleton set t00(t)                           / 2014 / ;

parameters
   years(tt)      "Contains years in value (dynamic)"
   firstYear      "First year of full time horizon"
   baseYear       "Simulation base year"
   finalYear      "Simulation final year"
   gap(t)         "Time-step"
;

firstYear = smin(tt, tt.val) ;
years(tt) = firstYear - 1 + ord(tt) ;
gap(t)    = 1$t0(t) + (years(t) - years(t-1))$(not t0(t)) ;
loop(t0, baseYear = years(t0) ; ) ;
finalYear = smax(t,years(t)) ;

Scalars
   ifVint      Set to 1 for vintage capital spec       / 1 /
   ifDyn       Set to 1 for dynamic simulation         / 1 /
   ifCal       Set to 1 for dynamic calibration        / %ifCal% /
;

$else

   Display "Wrong simulation type" ;
   Abort "Check listing file" ;

$endif

sets
   sim      / %SIMNAME% /
   ts(t)
;

alias(t,tsim) ;
alias(v,vp) ;
scalar nriter / %NRITER% / ;

Parameters
   riter
   iter
   nSubs
;

*  A number of other global options

scalars
   inScale     "Scale factor for input data"             / 1e-6 /
   outScale    "Scale factor for output data"            / 1e6 /
   popScale    "Scale factor for population"             / 1e-3 /
   lScale      "Scale factor for labor volumes"          / 1e-9 /
   eScale      "Scale factor for energy"                 / 1e-3 /
   watScale    "Scale factor for water"                  / 1e-12 /
   cScale      "Scale factor for emissions"              / 1e-3 /
   ifCEQ       "Convert emissions to CEq"                / 0 /
   ArmFlag     "Set to 1 for agent-based Armington"      / 1 /
$iftheni "%MRIO_MODULE%" == "ON"
   MRIO        "Set to 1 for MRIO model"                 / 1 /
$else
   MRIO        "Set to 1 for MRIO model"                 / 0 /
$endif
   ifNRG       "Set to 1 to use energy volumes"          / 1 /
   intRate     "Interest rate"                           / %intRate% /
   ifNRGNest   "Set to 1 for energy nesting"             / 0 /
   ifNRGACES   "Set to 1 for ACES in energy nesting"     / 0 /
   ifMCP       "Set to 1 for MCP"                        / 1 /
   ifLandCET   "Set to 1 to use CET for land allocation" / 0 /
   ifSUB       "Set to 1 to substitute out equations"    / 1 /
   IFPOWER     "Set to 1 for power module"               / 0 /
   IFWATER     "Set to 1 for water module"               / 0 /
   ifAggTrade  "Set to 1 to aggregate trade in SAM"      / 0 /
   skLabgrwgt  "Set to between 0 and 1"                  / 0 /
   EXR         "Exchange rate"                           / 1 /
;

*  CSV results go to this file

file
   fsam   / %odir%\%SIMNAME%SAM.csv /
   screen / con /
;

*  This file is optional--sometimes useful to debug model

file debug / %odir%\%SIMNAME%DBG.csv / ;
if(1,
   put debug ;
   put "Var,Importer,Sector,Exporter,Qual,Year,Value" / ;
   debug.pc=5 ;
   debug.nd=9 ;
) ;

*  CSV output options

scalars
   ifSAM "Flag for SAM CSV file" / 1 /
   ifSAMAppend "Flag to append to existing SAM CSV file" / 0 /
;

*  Start initializing the model--read the dimensions, parameters and the model specification

$include "%BASENAME%Sets.gms"
$include "%BASENAME%Prm.gms"
$include "model.gms"

$iftheni "%MRIO_MODULE%" == "ON"
   ArmSpec(r,i) = stdArm ;
   ArmSpec(r,"Extraction-c") = aggArm ;
   ArmSpec(r,"TextWapp-c")   = MRIOArm ;
   ArmSpec(r,"LightMnfc-c")  = MRIOArm ;
$endif

savfFlag = %savfFlag% ;

*  Load the generic scenario initialization files

$iftheni "%simType%" == "compStat"

   $$include "compScen.gms"

$elseifi "%simType%" == "RcvDyn"

   $$include "initScen.gms"

$endif

*  Initialize and calibrate the model, implement the closure rules

$include "getData.gms"

$iftheni "%MRIO_MODULE%" == "ON"
*  Scale MRIO to match aggregate bilateral trade

if(1,
   put debug ;
   loop(d,
      loop((s,i0),
         put "VCIF",  d.tl, i0.tl, s.tl, "TOT", "base", (vcif(i0,s,d)) / ;
         put "VMSB",  d.tl, i0.tl, s.tl, "TOT", "base", (vmsb(i0,s,d)) / ;
         loop(amrio,
            put "VIUWS0",  d.tl, i0.tl, s.tl, amrio.tl, "base", (viuws0(i0,amrio,s,d)) / ;
            put "VIUMS0",  d.tl, i0.tl, s.tl, amrio.tl, "base", (viums0(i0,amrio,s,d)) / ;
         ) ;
      ) ;
   ) ;
) ;

alias(amrio,amriop) ;

viuws0(i0,amrio,s,d)$sum(amriop, viuws0(i0,amriop,s,d)) = viuws0(i0,amrio,s,d)*vcif(i0,s,d)/sum(amriop, viuws0(i0,amriop,s,d)) ;
viums0(i0,amrio,s,d)$sum(amriop, viums0(i0,amriop,s,d)) = viums0(i0,amrio,s,d)*vmsb(i0,s,d)/sum(amriop, viums0(i0,amriop,s,d)) ;

if(1,
   put debug ;
   loop(d,
      loop((s,i0),
         loop(amrio,
            put "VIUWS",  d.tl, i0.tl, s.tl, amrio.tl, "base", (viuws0(i0,amrio,s,d)) / ;
            put "VIUMS",  d.tl, i0.tl, s.tl, amrio.tl, "base", (viums0(i0,amrio,s,d)) / ;
         ) ;
      ) ;
   ) ;
) ;
$endif

set tou(i) / "TransComm-c", "OthServices-c" / ;
*set dtt(i) / "trd-c", "wtp-c", "atp-c", "xtp-c" / ;

if(0,
   sigmamt(r,i)   = 0.4 ;
   sigmam(r,i,aa) = 0.4 ;
   sigmaw(r,i)    = 0.8 ;

   sigmamt(r,i)$(sigmamt(r,i) eq 1)     = 1.05 ;
   sigmam(r,i,aa)$(sigmam(r,i,aa) eq 1) = 1.05 ;
   sigmaw(r,i)$(sigmaw(r,i) eq 1)       = 1.05 ;

   sigmav(r,a,v) = 0.1 ;
   sigmav1(r,a,v) = 0.1 ;
   sigmav2(r,a,v) = 0.1 ;
   sigmakef(r,a,v) = 0.1 ;
   sigmakf(r,a,v)  = 0.1 ;
   sigmakw(r,a,v) = 0.1 ;
   sigmak(r,a,v)  = 0.1 ;
) ;

$include "init.gms"

$iftheni "%MRIO_MODULE%" == "ON"
if(1,
   put screen ; put / ;
   loop((s,i,d,aa)$(mtaxa0(s,i,d,aa) gt 1.1),
      put s.tl:<15, i.tl:<15, d.tl:<15, aa.tl:<15, (100*mtaxa0(s,i,d,aa)):10:2 / ;
   ) ;
*  abort "Temp" ;
) ;

loop((s,i,d,inv),
   if(mtaxa0(s,i,d,inv) gt 1.1,
      sigmawa(d,i,inv) = 1.01 ;
   ) ;
) ;
$endif

$include "cal.gms"

omegak(r)     = 0.050 ;

file emicsv / emi.csv / ;

if(0,
   put emicsv ;
   put "When,Emi,Input,Agent,Region,Level" / ;
   emicsv.pc=5 ;
   emicsv.nd=9 ;
   loop((em,r)$emn(em),
      loop(a0$EMI_qo(em, a0, r),
         put "BeforeCAL", em.tl, "Tot", a0.tl, r.tl, EMI_qo(em,a0,r) / ;
      ) ;
      loop((i0,a0)$EMI_IO(em, i0, a0, r),
         put "BeforeCAL", em.tl, i0.tl, a0.tl, r.tl, EMI_IO(em, i0, a0, r) / ;
      ) ;
      loop((fp,a0)$EMI_ENDW(em, fp, a0, r),
         put "BeforeCAL", em.tl, fp.tl, a0.tl, r.tl, EMI_endw(em, fp, a0, r) / ;
      ) ;

      loop((i0)$EMI_hh(em, i0, r),
         put "BeforeCAL", em.tl, i0.tl, "hhd", r.tl, EMI_hh(em, i0, r) / ;
      ) ;
   ) ;
   abort "Temp" ;
) ;

$include "closure.gms"

if(0,
   lambdaf.lo(r,l,a,t) = -inf ;
   lambdaf.up(r,l,a,t) =  inf ;
   gl.fx(r,t)          = 0 ;
) ;

errW.lo(r,l,"nsg",t) = -inf ;
errW.up(r,l,"nsg",t) = +inf ;

$iftheni "%MRIO_MODULE%" == "ON"
if(0,
   put debug ;
   loop((t,d),
      loop((s,i),
         put "xw",  d.tl, i.tl, s.tl, "Tot", PUTYEAR(t), (xw.l(s,i,d,t)*xw0(s,i,d)/inscale) / ;
         loop(aa,
            put "xwa", d.tl, i.tl, s.tl, aa.tl, PUTYEAR(t), (xwa.l(s,i,d,aa,t)*xwa0(s,i,d,aa)/inscale) / ;
            put "xwa_pe", d.tl, i.tl, s.tl, aa.tl, PUTYEAR(t), (pe0(s,i,d)*pe.l(s,i,d,t)*xwa.l(s,i,d,aa,t)*xwa0(s,i,d,aa)/inscale) / ;
            put "xwa_pwe", d.tl, i.tl, s.tl, aa.tl, PUTYEAR(t), (pwe0(s,i,d)*pwe.l(s,i,d,t)*xwa.l(s,i,d,aa,t)*xwa0(s,i,d,aa)/inscale) / ;
            put "xwa_pwm", d.tl, i.tl, s.tl, aa.tl, PUTYEAR(t), (pwm0(s,i,d)*pwm.l(s,i,d,t)*xwa.l(s,i,d,aa,t)*xwa0(s,i,d,aa)/inscale) / ;
            put "xwa_pdma", d.tl, i.tl, s.tl, aa.tl, PUTYEAR(t), (pdma0(s,i,d,aa)*pdma.l(s,i,d,aa,t)*xwa.l(s,i,d,aa,t)*xwa0(s,i,d,aa)/inscale) / ;
         ) ;
      ) ;
      loop((aa,i),
         put "xm",  d.tl, i.tl, "Tot", aa.tl, PUTYEAR(t), (xm0(d,i,aa)*xm.l(d,i,aa,t)/inscale) / ;
         put "xmv", d.tl, i.tl, "Tot", aa.tl, PUTYEAR(t), (pmt0(d,i)*pmt.l(d,i,t)*xm0(d,i,aa)*xm.l(d,i,aa,t)/inscale) / ;
      ) ;
      loop((a0,i0),
         put "VMAB", d.tl, i0.tl, "Tot", a0.tl, PUTYEAR(t), (vmfb(i0,a0,d)) / ;
      ) ;
      loop((i0),
         put "VMAB", d.tl, i0.tl, "Tot", "hhd", PUTYEAR(t), (vmpb(i0,d)) / ;
         put "VMAB", d.tl, i0.tl, "Tot", "Gov", PUTYEAR(t), (vmgb(i0,d)) / ;
         put "VMAB", d.tl, i0.tl, "Tot", "Inv", PUTYEAR(t), (vmib(i0,d)) / ;
      ) ;
   ) ;
) ;
$endif

$iftheni.loadBaU "%simType%" == "CompStat"

   $$if exist "%odir%\%startNAME%.gdx" execute_loadpoint "%odir%\%startNAME%.gdx" ;
   $$if exist "%odir%\%startNAME%.gdx" ifInitFlag = 1 ;
   $$if exist "%odir%\%startNAME%.gdx" startYear = %startYear% ;

$elseifi.loadBaU "%simType%" == "RcvDyn"

*  Let's test the twist--the preference parameters are only calibrated in the BaU and thus need
*  to be read in for shock simulations (as they get crushed in the calibration)

   if(0,
      twt1("EastAsia",i,t)$(years(t) ge 2012)   = 0.02 ;
      tw1("EastAsia",i,aa,t)$(years(t) ge 2012) = 0.02 ;
      tw2("EastAsia",i,t)$(years(t) ge 2012)    = 0.02 ;
      rtwtgt(s,"EastAsia")$(not sameas(s,"EastAsia"))  = yes ;
   ) ;

*  Load a baseline, if it exists

   if(ifDyn,

      if(ifCal eq 0,

*        Load the reference data

         execute_load "%odir%/%BaUName%.gdx",
            gl, xfd, wchiNRS, chinrs, chirw, chiAPS, rwage, ldz ;

         glBaU(r,t)        = gl.l(r,t) ;
         xfdBaU(r,fd,t)    = xfd.l(r,fd,t) ;
         chiNRSBaU(r,a,t)  = chiNRS.l(r,a,t) ;
         wchiNRSBaU(a,t)   = wchiNRS.l(a,t) ;
         chirwBaU(r,l,z,t) = chirw.l(r,l,z,t) ;
         chiAPSBaU(r,h,t)  = chiAPS.l(r,h,t) ;

         rwageBaU(r,l,z,t) = rwage.l(r,l,z,t) ;
         ldzBaU(r,l,z,t)   = ldz.l(r,l,z,t) ;

         xfd.lo(r,fd,t)   = -inf ;
         xfd.up(r,fd,t)   = +inf ;

      ) ;

*     Load values from the baseline if it exists

      $$if exist "%odir%\%startNAME%.gdx" execute_loadpoint "%odir%\%startNAME%.gdx" ;
      $$if exist "%odir%\%startNAME%.gdx" ifInitFlag = 1 ;
      $$if exist "%odir%\%startNAME%.gdx" startYear = %startYear% ;

   ) ;

*  Override foreign saving

   parameter savfT(t,r) "Capital account assumption" ;
   parameter rgdpT(r,t) "GDP scenario" ;
   if(0,
      rgdpT(r,t0) = rgdpmp0(r)*rgdpmp.l(r,t0) ;
      loop((t0,t)$(years(t) gt years(t0)),
         rgdpT(r,t) = rgdpT(r,t-1)*(rgdppcT(r,t)/rgdppcT(r,t-1))*(popT(r,"PTOTL",t)/popT(r,"PTOTL",t-1)) ;
         year0 = years(t0) ;
      ) ;
      savfT(t0,r) = savf.l(r,t0) ;
      loop((r,t0),
         if(abs(100*savfT(t0,r)/rgdpT(r,t0)) > 5,
*           Capital flows are greater than 5 percent of GDP, lower it to 5 by year 2030, and then to 0 by 2050
            loop(t$(years(t) gt years(t0)),
               if(years(t) le 2030,
                  savfT(t,r) = rgdpT(r,t)*(savfT(t0,r)/rgdpT(r,t0) + (years(t) - years(t0))
                     * (sign(savfT(t0,r))*0.05 - savfT(t0,r)/rgdpT(r,t0))/(2030 - year0)) ;
               elseif (years(t) le 2050),
                  savfT(t,r) = rgdpT(r,t)*(sign(savfT(t0,r))*0.05 + (years(t) - years("2030"))
                     * (0 - sign(savfT(t0,r))*0.05)/(2050 - 2030)) ;
               elseif (years(t) gt 2050),
                  savfT(t,r) = 0 ;
               ) ;
            ) ;
         else
*           Capital flows are less than 5 percent of GDP, lower it to 0 by year 2050
            loop(t$(years(t) gt years(t0)),
               if (years(t) le 2050,
                  savfT(t,r) = rgdpT(r,t)*(savfT(t0,r)/rgdpT(r,t0) + (years(t) - years(t0))
                     * (0 - savfT(t0,r)/rgdpT(r,t0))/(2050 - year0)) ;
               elseif (years(t) gt 2050),
                  savfT(t,r) = 0 ;
               ) ;
            ) ;
         ) ;
      ) ;
*     display rgdpT, savfT ;
*     Abort "Temp" ;
   ) ;

$endif.LoadBaU

*  Define cost curve assumptions

Parameters
   costTgt(r,a)      "Cost reduction target for each activity"
   costMin(r,a)      "Long-term cost minimum--costMin < costTgt"
   costTgtYear(r,a)  "Target year"
   ifCostCurve(r,a)  "Cost curve flag"
;

costTgt(r,a)     = na ;
costMin(r,a)     = na ;
costTgtYear(r,a) = na ;
ifCostCurve(r,a) = 0 ;

*  Set the solution options

options limrow=3, limcol=3, iterlim=1000, solprint=off ;
core.tolinfrep    = 1e-5 ;
coreBaU.tolinfrep = 1e-5 ;
coreDyn.tolinfrep = 1e-5 ;

scalar ifNominal / 1 / ;

set rshk / ssa, sas, row / ;
set maprshk(rshk,r) /
   row.Oceania
   row.EastAsia
   row.SEAsia
   sas.SouthAsia
   row.NAmerica
   row.LatinAmer
   row.EU_28
   row.MENA
   ssa.SSA
   row.RestofWorld
/ ;

Table nCov19DemShk0(*,i)
         OthServices-c
all        0.15
;

Parameter
   nCov19DemShk(r,i)
;

nCov19DemShk(r,i) = nCov19DemShk0("All",i) ;

Parameter
   supShk(r)
;
scalar supShk0 / 0.050 / ;

supShk(r) = supShk0 ;

*  Set to 1 for an additive percentage change
*  Set to 0 for a multiplicative percent change

scalar aTTFlag  / 1 / ;
scalar ttShk0  ;
if(aTTFlag eq 1,
   ttShk0 = 0.025 ;
else
   ttshk0 = 0.25 ;
) ;

Parameter
   ttshk(r)
;
ttshk(r) = ttshk0 ;

scalar touShk0 / 0.50 / ;
Parameter
   toushk(r)
;

toushk(r) = touShk0 ;

set ml / ml1*ml5 / ;
