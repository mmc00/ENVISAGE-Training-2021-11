*-----------------------------------------------------------------------------------------
$ontext

   Envisage 10 project -- Data preparation modules

   GAMS file : AggGTAP.gms

   @purpose  : Aggregate standard GTAP database--emulation the GTAPAgg GEMPACK program.

   @author   : Dominique van der Mensbrugghe
   @date     : 21.10.16
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : AggGTAP.cmd
   @Options  : ifCSV (default=0)
               ifAggTrade (default=1)
               ifWater (default=OFF)

$offtext
*-----------------------------------------------------------------------------------------

* ----------------------------------------------------------------------------------------
*
*  GAMS program to aggregate a GTAP database
*
* ----------------------------------------------------------------------------------------

*  Define the aggregation macros

$macro AGG1(v0,v,x0,x,mapx)                     v(x)     = sum(x0$mapx(x0,x), v0(x0))
$macro AGG2(v0,v,x0,x,mapx,y0,y,mapy)           v(x,y)   = sum((x0,y0)$(mapx(x0,x) and mapy(y0,y)), v0(x0,y0))
$macro AGG3(v0,v,x0,x,mapx,y0,y,mapy,z0,z,mapz) v(x,y,z) = sum((x0,y0,z0)$(mapx(x0,x) and mapy(y0,y) and mapz(z0,z)), v0(x0,y0,z0))
$macro AGG4(v0,v,x0,x,mapx,y0,y,mapy,z0,z,mapz,w0,w,mapw) v(x,y,z,w) = sum((x0,y0,z0,w0)$(mapx(x0,x) and mapy(y0,y) and mapz(z0,z) and mapw(w0,w)), v0(x0,y0,z0,w0))

*  Labor options

acronyms off, on, noLab, agLab, allLab, giddLab, alterTax, GTAP, Env ;

$include "SSPSets.gms"

*  Load the aggregation mappings

$include "%BaseName%Map.gms"

* put  "FS = ", "%system.filesys%" / ;

$set OPSYS
$If %system.filesys% == UNIX     $set OPSYS "UNIX"
$If %system.filesys% == DOS      $set OPSYS "DOS"
$If %system.filesys% == "MSNT"   $set OPSYS "DOS"
$If "%OPSYS%." == "." Abort "filesys not recognized" ;

$set console
$iftheni "%OPSYS%" == "UNIX"
   $$set console /dev/tty
$elseifi "%OPSYS%" == "DOS"
   $$set console con
$else
   Abort "Unknown operating system" ;
$endif

file screen / '%console%' /;

put screen ;
put / ;

scalar ifWater / %ifWater% / ;

scalar ifPower / %ifPower% / ;

$if not setglobal ifCSV $setglobal ifCSV
$if "%ifCSV%" == "" $setglobal ifCSV 0
scalar ifCSV / %ifCSV% / ;

$if not setglobal ifAggTrade $setglobal ifAggTrade
$if "%ifAggTrade%" == "" $setglobal ifAggTrade 1
scalar ifAggTrade / %ifAggTrade% / ;

$if not setGlobal ifMRIO $setGlobal ifMRIO
$if "%ifMRIO%" == "" $setglobal ifMRIO OFF

$show

* ------------------------------------------------------------------------------
*
*  Validate the aggregations
*
* ------------------------------------------------------------------------------

parameters
   r0Flag(r0)
   rFlag(r)
   a0Flag(a0)
   aFlag(a)
   i0Flag(i0)
   iFlag(i)
   fpFlag(fp)
   fp0Flag(fp0)
   total
   work
   ifFirstPass    / 1 /
   ifCheck        / 1 /
   ifFirst        / 1 /
   order          / 0 /
;

r0Flag(r0) = sum(mapr(r0,r), 1) ;
loop(r0,
   if(r0Flag(r0) ne 1,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following GTAP region(s) have not been mapped:" / ;
      ) ;
      put r0.tl:<10, "     ", r0.te(r0) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
rFlag(r) = sum(mapr(r0,r), 1) ;
loop(r,
   if(rFlag(r) eq 0,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following aggregate region(s) have no GTAP regions mapped to them:" / ;
      ) ;
      put r.tl:<10, "     ", r.te(r) / ;
   ) ;
) ;

ifFirst = 1 ;

i0Flag(i0) = sum(mapi(i0,i), 1) ;
loop(i0,
   if(i0Flag(i0) ne 1,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following GTAP sector(s) have not been mapped:" / ;
      ) ;
      put i0.tl:<10, "     ", i0.te(i0) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
iFlag(i) = sum(mapi(i0,i), 1) ;
loop(i,
   if(iFlag(i) eq 0,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following aggregate sector(s) have no GTAP sectors mapped to them:" / ;
      ) ;
      put i.tl:<10, "     ", i.te(i) / ;
   ) ;
) ;

fp0Flag(fp0) = sum(mapf(fp0,fp), 1) ;
loop(fp0,
   if(fp0Flag(fp0) lt 1,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following GTAP factor(s) have not been mapped:" / ;
      ) ;
      put fp0.tl:<10, "     ", fp0.te(fp0) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
fpFlag(fp) = sum(mapf(fp0,fp), 1) ;
loop(fp,
   if(fpFlag(fp) eq 0,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following aggregate factor(s) have no GTAP factors mapped to them:" / ;
      ) ;
      put fp.tl:<10, "     ", fp.te(fp) / ;
   ) ;
) ;

put screen ; put / ;

$iftheni.ifLU "%LU%" == "ON"

ifFirst = 1
parameter fpa0Flag(fpa0) ;

fpa0Flag(fpa0) = sum(mapaez(fpa0, fp), 1) ;
loop(fpa0,
   if(fpa0Flag(fpa0) lt 1,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following GTAP factor(s) have not been mapped:" / ;
      ) ;
      put fpa0.tl:<10, "     ", fpa0.te(fpa0) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
fpFlag(fp) = sum(mapaez(fpa0, fp), 1) ;
loop(fp,
   if(fpFlag(fp) eq 0,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following aggregate factor(s) have no GTAP factors mapped to them:" / ;
      ) ;
      put fp.tl:<10, "     ", fp.te(fp) / ;
   ) ;
) ;

put screen ; put / ;

$endif.ifLU

$iftheni %Model% == Env

*  Check the mapk mappings

Parameters
   commFlag(commf)
   kFlag(k)
;

ifFirst = 1 ;

commFlag(commf) = sum(mapk(commf,k), 1) ;
loop(commf,
   if(commFlag(commf) ne 1,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following commodity(ies) have not been mapped to a consumer bundle:" / ;
      ) ;
      put commf.tl:<10, "     ", commf.te(commf) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
kFlag(k) = sum(mapk(commf,k), 1) ;
loop(k,
   if(kFlag(k) eq 0,
      put screen ;
      if(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following consumer bundle(s) have no commodities mapped to them:" / ;
      ) ;
      put k.tl:<10, "     ", k.te(k) / ;
   ) ;
) ;
$endif

*  Check the size of the residual region

put screen ; put / ;

if(card(rres) ne 1,
   ifCheck = 0 ;
   if(card(rres) eq 0,
      put "Map file doesn't contain a residual region (see subset 'rres')..." / ;
   elseif(card(rres) gt 1),
      put "There can only be one residual region (see subset 'rres'):" / ;
      loop(r$rres(r),
         put r.tl / ;
      ) ;
   ) ;
) ;

abort$(ifCheck eq 0) "Invalid mapping file" ;

put screen ;
put "All mappings have passed standard checks..." / / ;

putclose screen ;

* ------------------------------------------------------------------------------
*
*  Save the aggregation mappings
*
* ------------------------------------------------------------------------------

$iftheni "%SAVEMAP%" == "TXT"
   $$include saveMap.gms
$elseifi "%SAVEMAP%" == "LATEX"
   $$include saveMap.gms
$else
   $$show
   DISPLAY "**** -- Invalid option for SAVEMAP (%SAVEMAP%)" ;
   DISPLAY "**** -- Valid options are 'TXT' and 'LATEX'" ;
*   Abort "Invalid option" ;
$endif

* ------------------------------------------------------------------------------
*
*  Load and aggregate land use data
*
* ------------------------------------------------------------------------------

$iftheni.ifLU "%LU%" == "ON"

parameters
   LU_EVFA(fpa0,ACTS,REG)               "AEZ-related value added at agents' prices"
   LU_VFM(fpa0,ACTS,REG)                "AEZ-related value added at market prices"
   LU_EVOA(fpa0,REG)                    "AEZ-related value added net of income taxes"
;

*  Load the data

execute_loaddc "%AEZFILE%",
   lu_evfa, lu_vfm, lu_evoa ;

$endif.ifLU

* ------------------------------------------------------------------------------
*
*  Aggregate the GTAP data
*
* ------------------------------------------------------------------------------

parameters

*  From the standard database

   VDFB(COMM, ACTS, REG)            "Firm purchases of domestic goods at basic prices"
   VDFP(COMM, ACTS, REG)            "Firm purchases of domestic goods at purchaser prices"
   VMFB(COMM, ACTS, REG)            "Firm purchases of imported goods at basic prices"
   VMFP(COMM, ACTS, REG)            "Firm purchases of domestic goods at purchaser prices"
   VDPB(COMM, REG)                  "Private purchases of domestic goods at basic prices"
   VDPP(COMM, REG)                  "Private purchases of domestic goods at purchaser prices"
   VMPB(COMM, REG)                  "Private purchases of imported goods at basic prices"
   VMPP(COMM, REG)                  "Private purchases of domestic goods at purchaser prices"
   VDGB(COMM, REG)                  "Government purchases of domestic goods at basic prices"
   VDGP(COMM, REG)                  "Government purchases of domestic goods at purchaser prices"
   VMGB(COMM, REG)                  "Government purchases of imported goods at basic prices"
   VMGP(COMM, REG)                  "Government purchases of domestic goods at purchaser prices"
   VDIB(COMM, REG)                  "Investment purchases of domestic goods at basic prices"
   VDIP(COMM, REG)                  "Investment purchases of domestic goods at purchaser prices"
   VMIB(COMM, REG)                  "Investment purchases of imported goods at basic prices"
   VMIP(COMM, REG)                  "Investment purchases of domestic goods at purchaser prices"

   EVFB(ENDW, ACTS, REG)            "Primary factor purchases at basic prices"
   EVFP(ENDW, ACTS, REG)            "Primary factor purchases at purchaser prices"
   EVOS(ENDW, ACTS, REG)            "Factor remuneration after income tax"

   VXSB(COMM, REG, REG)             "Exports at basic prices"
   VFOB(COMM, REG, REG)             "Exports at FOB prices"
   VCIF(COMM, REG, REG)             "Import at CIF prices"
   VMSB(COMM, REG, REG)             "Imports at basic prices"

   VST(MARG, REG)                   "Exports of trade and transport services"
   VTWR(MARG, COMM, REG, REG)       "Margins by margin commodity"

   SAVE(REG)                        "Net saving, by region"
   VDEP(REG)                        "Capital depreciation"
   VKB(REG)                         "Capital stock"
   POP(REG)                         "Population"

   MAKS(COMM,ACTS,REG)              "Make matrix at supply prices"
   MAKB(COMM,ACTS,REG)              "Make matrix at basic prices (incl taxes)"
   PTAX(COMM,ACTS,REG)              "Output taxes"

*  Auxiliary data

   VOA(ACTS, REG)                   "Value of output pre-tax"
;

*  Load the GTAP data base

execute_load "%gtpDir%/%GTAPBASE%DAT.gdx",
   vdfb, vdfp, vmfb, vmfp,
   vdpb, vdpp, vmpb, vmpp,
   vdgb, vdgp, vmgb, vmgp,
   vdib, vdip, vmib, vmip,
   evfb, evfp, evos,
   vxsb, vfob, vcif, vmsb,
   vst, vtwr,
   save, vdep, vkb, pop,
   maks, makb, ptax
;

$ontext
$include "EUTRADE.gms"
* abort "Temp" ;
$offtext

voa(acts,reg) = sum(comm, maks(comm,acts,reg)) ;
file xpcsv / xp.csv / ;
if(0,
   put xpcsv ;
   put "Region,Acts,Value" / ;
   xpcsv.pc=5 ;
   xpcsv.nd=9 ;
   loop((acts,reg),
      put reg.tl, acts.tl, voa(acts,reg) / ;
   ) ;
   abort$1 "Temporary" ;
) ;
parameter
   gdpmp(reg)
;

alias(reg,dst) ; alias(reg,src) ;

file gdpcsv / gdp.csv / ;
if(0,
   put gdpcsv ;
   put "Var,Reg,Value" / ;
   gdpcsv.pc=5 ;
   gdpcsv.nd=9 ;
   loop(reg,
      gdpmp(reg) = sum(comm, vdpp(comm,reg) + vmpp(comm,reg)
                 +           vdgp(comm,reg) + vmgp(comm,reg)
                 +           vdip(comm,reg) + vmip(comm,reg)
                 + sum(dst,  vfob(comm,reg,dst))
                 - sum(src,  vcif(comm,src,reg)))
                 + sum(marg, vst(marg,reg)) ;
      put "GDPMP", reg.tl, (gdpmp(reg)) / ;
      put "Pop",   reg.tl, (pop(reg)) / ;
   ) ;
   abort "Temp" ;
) ;

*  Scale output -- takes care of advanced technologies
display scaleXP ;
vdfb(comm,acts,reg) = scaleXP(acts)*vdfb(comm,acts,reg) ;
vdfp(comm,acts,reg) = scaleXP(acts)*vdfp(comm,acts,reg) ;
vmfb(comm,acts,reg) = scaleXP(acts)*vmfb(comm,acts,reg) ;
vmfp(comm,acts,reg) = scaleXP(acts)*vmfp(comm,acts,reg) ;
evfb(endw,acts,reg) = scaleXP(acts)*evfb(endw,acts,reg) ;
evfp(endw,acts,reg) = scaleXP(acts)*evfp(endw,acts,reg) ;

$setGlobal VER V10AFG
file ecsv / "evfb%VER%.csv" / ;
if(0,
   if(1,
      execute_unload "evfb%VER%.gdx", EVFB ;
   ) ;
   put ecsv ;
   put "Region,Factor,Activity,Value" / ;
   ecsv.pc=5 ;
   ecsv.nd=9 ;
   loop((reg,endw,acts),
      put reg.tl, endw.tl, acts.tl, evfb(endw,acts,reg) / ;
   ) ;
   Abort "TEMP" ;
) ;

* ----------------------------------------------------------------------------------------
*
*  Declare the aggregated parameters
*
* ----------------------------------------------------------------------------------------

alias(r,rp) ; alias(r,s) ; alias(r,d) ; alias(img,i) ; alias(a,a1) ;
alias(reg,src) ; alias(reg,dst) ;

parameters
   VDFB1(i, a, r)             "Firm purchases of domestic goods at basic prices"
   VDFP1(i, a, r)             "Firm purchases of domestic goods at purchaser prices"
   VMFB1(i, a, r)             "Firm purchases of imported goods at basic prices"
   VMFP1(i, a, r)             "Firm purchases of domestic goods at purchaser prices"
   VDPB1(i, r)                "Private purchases of domestic goods at basic prices"
   VDPP1(i, r)                "Private purchases of domestic goods at purchaser prices"
   VMPB1(i, r)                "Private purchases of imported goods at basic prices"
   VMPP1(i, r)                "Private purchases of domestic goods at purchaser prices"
   VDGB1(i, r)                "Government purchases of domestic goods at basic prices"
   VDGP1(i, r)                "Government purchases of domestic goods at purchaser prices"
   VMGB1(i, r)                "Government purchases of imported goods at basic prices"
   VMGP1(i, r)                "Government purchases of domestic goods at purchaser prices"
   VDIB1(i, r)                "Investment purchases of domestic goods at basic prices"
   VDIP1(i, r)                "Investment purchases of domestic goods at purchaser prices"
   VMIB1(i, r)                "Investment purchases of imported goods at basic prices"
   VMIP1(i, r)                "Investment purchases of domestic goods at purchaser prices"

   EVFB1(fp, a, r)            "Primary factor purchases at basic prices"
   EVFP1(fp, a, r)            "Primary factor purchases at purchaser prices"
   EVOS1(fp, a, r)            "Factor remuneration after income tax"

   VXSB1(i, r, r)             "Exports at basic prices"
   VFOB1(i, r, r)             "Exports at FOB prices"
   VCIF1(i, r, r)             "Import at CIF prices"
   VMSB1(i, r, r)             "Imports at basic prices"

   VST1(img, r)               "Exports of trade and transport services"
   VTWR1(img, i, r, r)        "Margins by margin commodity"

   SAVE1(r)                   "Net saving, by region"
   VDEP1(r)                   "Capital depreciation"
   VKB1(r)                    "Capital stock"
   POP1(r)                    "Population"

   MAKS1(i,a,r)               "Make matrix at supply prices"
   MAKB1(i,a,r)               "Make matrix at basic prices (incl taxes)"
   PTAX1(i,a,r)               "Output taxes"

*  Auxiliary data
   voa1(a,r)                  "Value of output pre-tax"
   voi1(i,r)                  "Value of supply post-tax"
;

*  Aggregate the GTAP matrices

Agg3(vdfb,vdfb1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(vdfp,vdfp1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(vmfb,vmfb1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(vmfp,vmfp1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;

Agg2(vdpb,vdpb1,i0,i,mapi,r0,r,mapr) ;
Agg2(vdpp,vdpp1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmpb,vmpb1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmpp,vmpp1,i0,i,mapi,r0,r,mapr) ;

Agg2(vdgb,vdgb1,i0,i,mapi,r0,r,mapr) ;
Agg2(vdgp,vdgp1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmgb,vmgb1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmgp,vmgp1,i0,i,mapi,r0,r,mapr) ;

Agg2(vdib,vdib1,i0,i,mapi,r0,r,mapr) ;
Agg2(vdip,vdip1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmib,vmib1,i0,i,mapi,r0,r,mapr) ;
Agg2(vmip,vmip1,i0,i,mapi,r0,r,mapr) ;

$show

put screen ; put / ;
$iftheni.ifLU "%LU%" == "ON"
   loop(fp,
      evfb1(fp,i,r) = sum((i0,r0)$(mapi(i0,i) and mapr(r0,r)),
                        sum(fpa0$mapaez(fpa0,fp), lu_vfm(fpa0,i0,r0))) ;
      evfp1(fp,i,r) = sum((i0,r0)$(mapi(i0,i) and mapr(r0,r)),
                        sum(fpa0$mapaez(fpa0,fp), lu_evfa(fpa0,i0,r0))) ;
*     Calculate income tax based assuming uniformity across activities
      evos1(fp,i,r) = sum(fpa0$mapaez(fpa0,fp), sum((i0,r0)$(mapr(r0,r)), lu_vfm(fpa0,i0,r0))) ;

      evos1(fp,i,r)$evos1(fp,i,r) = sum(fpa0$mapaez(fpa0,fp), sum(r0$mapr(r0,r), lu_evoa(fpa0,r0)))
        /  evos1(fp,i,r) ;
      evos1(fp,i,r) = evos1(fp,i,r)*evfb1(fp,i,r) ;
   ) ;
$else.ifLU
   $$iftheni.ifGender "%ifGENDER%" == "OFF"
      Agg3(evfb,evfb1,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
      Agg3(evfp,evfp1,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
      Agg3(evos,evos1,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
   $$endif.ifGender
$endif.ifLU
*  !!!!!!!! There are issues with the LU database--natlres label and no EVOA for natural resources
* display evos1 ; abort "Temp" ;

*  Deal with the backstops

$iftheni "%ifBKSTOP%" == "ON"
   $$include "%BaseName%BKStp.gms"
   Parameter
      VDFBBKSTP1(i, bkstp, r)      "Firm purchases of domestic goods at basic prices"
      VDFPBKSTP1(i, bkstp, r)      "Firm purchases of domestic goods at purchaser prices"
      VMFBBKSTP1(i, bkstp, r)      "Firm purchases of imported goods at basic prices"
      VMFPBKSTP1(i, bkstp, r)      "Firm purchases of domestic goods at purchaser prices"

      EVFBBKSTP1(fp, bkstp, r)     "Primary factor purchases at basic prices"
      EVFPBKSTP1(fp, bkstp, r)     "Primary factor purchases at purchaser prices"
      EVOSBKSTP1(fp, bkstp, r)     "Factor remuneration after income tax"
   ;
   VDFBBKSTP1(i, bkstp, r)  = sum((comm,reg)$(mapi(comm,i) and mapr(reg,r)), VDFBBKSTP(COMM, bkstp, REG)) ;
   VDFPBKSTP1(i, bkstp, r)  = sum((comm,reg)$(mapi(comm,i) and mapr(reg,r)), VDFPBKSTP(COMM, bkstp, REG)) ;
   VMFBBKSTP1(i, bkstp, r)  = sum((comm,reg)$(mapi(comm,i) and mapr(reg,r)), VMFBBKSTP(COMM, bkstp, REG)) ;
   VMFPBKSTP1(i, bkstp, r)  = sum((comm,reg)$(mapi(comm,i) and mapr(reg,r)), VMFPBKSTP(COMM, bkstp, REG)) ;
   EVFBBKSTP1(fp, bkstp, r) = sum((fp0,reg)$(mapf(fp0,fp) and mapr(reg,r)), EVFBBKSTP(fp0, bkstp, REG)) ;
   EVFPBKSTP1(fp, bkstp, r) = sum((fp0,reg)$(mapf(fp0,fp) and mapr(reg,r)), EVFPBKSTP(fp0, bkstp, REG)) ;
   EVOSBKSTP1(fp, bkstp, r) = sum((fp0,reg)$(mapf(fp0,fp) and mapr(reg,r)), EVOSBKSTP(fp0, bkstp, REG)) ;
$endif

*!!!! Special treatment for the GENDER database

$iftheni.ifGender "%ifGENDER%" == "ON"

*  Load the GIDD labor/wage split

Parameter
   GIDDLab0(lgg, i0, r0)
   GIDDWages0(lgg, i0, r0)
   GIDDLab1(l, i, r)
   GIDDWages(l, i, r)
;

execute_load "%gtpDir%/%GTAPBASE%GIDDWages.gdx", GIDDLab0=GIDDLab, GIDDWages0=GIDDWages ;

EVFB1(l,i,r) = sum((lgg,i0,r0)$(maplGIDDGen(lgg, l) and mapr(r0,r) and mapi(i0,i)),
                  GIDDLab0(lgg, i0, r0)*GIDDWages0(lgg,i0,r0)) ;
GIDDLab1(l,i,r) = sum((lgg,i0,r0)$(maplGIDDGen(lgg, l) and mapr(r0,r) and mapi(i0,i)),
                     GIDDLab0(lgg, i0, r0)) ;
GIDDWages(l,i,r)$GIDDLab1(l,i,r) = EVFB1(l,i,r)/GIDDLab1(l,i,r) ;

loop(l,
*  Calculate the tax-adjusted value added vectors for labor
   EVFP1(l,i,r)$EVFB1(l,i,r) = EVFB1(l,i,r)
                             * sum((lab,i0,r0)$(mapi(i0,i) and mapr(r0,r)), EVFP(lab,i0,r0))
                             / sum((lab,i0,r0)$(mapi(i0,i) and mapr(r0,r)), EVFB(lab,i0,r0)) ;
   EVOS1(l,i,r)$EVFB1(l,i,r) = EVFB1(l,i,r)
                             * sum((lab,i0,r0)$(mapi(i0,i) and mapr(r0,r)), EVOS(lab,i0,r0))
                             / sum((lab,i0,r0)$(mapi(i0,i) and mapr(r0,r)), EVFB(lab,i0,r0)) ;
) ;

*  Then aggregate the non-labor components

loop(fp$(not l(fp)),
   EVFB1(fp,i,r) = sum((fp0,i0,r0)$(mapf(fp0,fp) and mapi(i0,i) and mapr(r0,r)), EVFB(fp0,i0,r0)) ;
   EVFP1(fp,i,r) = sum((fp0,i0,r0)$(mapf(fp0,fp) and mapi(i0,i) and mapr(r0,r)), EVFP(fp0,i0,r0)) ;
   EVOS1(fp,i,r) = sum((fp0,i0,r0)$(mapf(fp0,fp) and mapi(i0,i) and mapr(r0,r)), EVOS(fp0,i0,r0)) ;
) ;
$endif.ifGender

Agg3(VXSB,VXSB1,i0,i,mapi,r0,r,mapr,rp0,rp,mapr) ;
Agg3(VFOB,VFOB1,i0,i,mapi,r0,r,mapr,rp0,rp,mapr) ;
Agg3(VCIF,VCIF1,i0,i,mapi,r0,r,mapr,rp0,rp,mapr) ;
Agg3(VMSB,VMSB1,i0,i,mapi,r0,r,mapr,rp0,rp,mapr) ;

Agg2(VST,VST1,img0,img,mapi,r0,r,mapr) ;

Agg4(VTWR,VTWR1,img0,img,mapi,i0,i,mapi,r0,r,mapr,rp0,rp,mapr) ;

Agg1(SAVE,SAVE1,r0,r,mapr) ;
Agg1(VDEP,VDEP1,r0,r,mapr) ;
Agg1(VKB,VKB1,r0,r,mapr) ;
Agg1(POP,POP1,r0,r,mapr) ;

Agg3(maks,maks1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(makb,makb1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(ptax,ptax1,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;

voa1(a,r) = sum(i, maks1(i,a,r)) ;
voi1(i,r) = sum(a, makb1(i,a,r)) ;

*  Move land to capital

loop((cap,lnd,a)$mapt(a),
   evfp1(cap,a,r) = evfp1(cap,a,r) + evfp1(lnd,a,r) ;
   evfp1(lnd,a,r) = 0 ;
   evfb1(cap,a,r) = evfb1(cap,a,r) + evfb1(lnd,a,r) ;
   evfb1(lnd,a,r) = 0 ;
   evos1(cap,a,r) = evos1(cap,a,r) + evos1(lnd,a,r) ;
   evos1(lnd,a,r) = 0 ;
) ;


*  Move natural resource to capital

loop((cap,nrs,a)$mapn(a),
   evfp1(cap,a,r) = evfp1(cap,a,r) + evfp1(nrs,a,r) ;
   evfp1(nrs,a,r) = 0 ;
   evfb1(cap,a,r) = evfb1(cap,a,r) + evfb1(nrs,a,r) ;
   evfb1(nrs,a,r) = 0 ;
   evos1(cap,a,r) = evos1(cap,a,r) + evos1(nrs,a,r) ;
   evos1(nrs,a,r) = 0 ;
) ;

*  Save the data

execute_unload "%baseName%/agg/%baseName%Dat.gdx",

   vdfb1=vdfb, vdfp1=vdfp, vmfb1=vmfb, vmfp1=vmfp,
   vdpb1=vdpb, vdpp1=vdpp, vmpb1=vmpb, vmpp1=vmpp,
   vdgb1=vdgb, vdgp1=vdgp, vmgb1=vmgb, vmgp1=vmgp,
   vdib1=vdib, vdip1=vdip, vmib1=vmib, vmip1=vmip,
   evfb1=evfb, evfp1=evfp, evos1=evos,
   vxsb1=vxsb, vfob1=vfob, vcif1=vcif, vmsb1=vmsb,
   vst1=vst,   vtwr1=vtwr,
   save1=save, vdep1=vdep,
   vkb1=vkb,   pop1=pop,
   maks1=maks, makb1=makb, ptax1=ptax
;

*  Save the NIPA accounts for dis-aggregated and aggregated database
*  Save energy subsidies as well

*$include "nipa.gms"

*  Save the SAM if requested

file csv / "%baseName%/agg/%baseName%Agg.csv" / ;
$batinclude "aggsam.gms" AggGTAP 1

* ------------------------------------------------------------------------------
*
*  Aggregate the GTAP parameters
*
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
*
*  Aggregate GTAP parameters
*
* ------------------------------------------------------------------------------

*  GTAP parameters

parameters
   ESUBT(ACTS,REG)         "Top level production elasticity"
   ESUBC(ACTS,REG)         "Elasticity across intermedate inputs"
   ESUBVA(ACTS,REG)        "Inter-factor substitution elasticity"
   ETRAQ(ACTS,REG)         "CET make elasticity"
   ESUBQ(COMM,REG)         "CES make elasticity"
   INCPAR(COMM, REG)       "CDE expansion parameter"
   SUBPAR(COMM, REG)       "CDE substitution parameter"
   ESUBG(REG)              "CES government expenditure elasticity"
   ESUBI(REG)              "CES investment expenditure elasticity"
   ESUBD(COMM,REG)         "Top level Armington elasticity"
   ESUBM(COMM,REG)         "Second level Armington elasticity"
   ESUBS(MARG)             "CES margin elasticity"
   ETRAE(ENDW,REG)         "CET transformation elasticities for factors"
   RORFLEX(REG)            "Flexibility of expected net ROR wrt investment"
;

*  Load the data

execute_load "%gtpDir%/%GTAPBASE%par.gdx",
   ESUBT, ESUBC, ESUBVA, ETRAQ, ESUBQ,
   INCPAR, SUBPAR, ESUBG, ESUBI,
   ESUBD, ESUBM, ESUBS, ETRAE, RORFLEX
;

*  Aggregate to intermediate levels

parameters
   ESUBT1(a,r)          "Top level production elasticity"
   ESUBC1(a,r)          "Elasticity across intermedate inputs"
   ESUBVA1(a,r)         "Inter-factor substitution elasticity"
*  USER SUPPLIED
*  ETRAQ1(a,r)          "CET make elasticity"
*  ESUBQ1(i,r)          "CES make elasticity"
   INCPAR1(i,r)         "CDE expansion parameter"
   SUBPAR1(i,r)         "CDE substitution parameter"
*  USER SUPPLIED
*  ESUBG1(r)            "CES government expenditure elasticity"
*  ESUBI1(r)            "CES investment expenditure elasticity"
   ESUBD1(i,r)          "Top level Armington elasticity"
   ESUBM1(i,r)          "Second level Armington elasticity"
*  USER SUPPLIED
   ESUBS1(img)          "CES margin elasticity"
   RORFLEX1(r)          "Flexibility of expected net ROR wrt investment"
;

*  Aggregate the data

*  ESUBT -- use regional output as weight

esubt1(a,r) = sum(a0$mapa(a0,a), sum(reg$mapr(reg,r), voa(a0, reg))) ;
esubt1(a,r)$esubt1(a,r) = sum(a0$mapa(a0,a),
      sum(reg$mapr(reg,r), voa(a0, reg)*ESUBT(a0,reg))) / esubt1(a,r) ;

*  ESUBC -- use regional intermediate demand at purchasers' prices as weight

esubc1(a,r) = sum(a0$mapa(a0,a), sum((reg,i0)$mapr(reg,r), (vdfp(i0,a0,reg)+vmfp(i0,a0,reg)))) ;
esubc1(a,r)$esubc1(a,r) = sum(a0$mapa(a0,a), sum((reg,i0)$mapr(reg,r),
      (vdfp(i0,a0,reg)+vmfp(i0,a0,reg))*ESUBC(a0,reg))) / esubc1(a,r) ;

*  ESUBVA -- use regional value added at agents' prices as weight

esubva1(a,r) = sum(a0$mapa(a0,a), sum((reg,fp0)$mapr(reg,r), evfp(fp0, a0, reg))) ;
esubva1(a,r)$esubva1(a,r) = sum(a0$mapa(a0,a),
      sum((reg,fp0)$mapr(reg,r), evfp(fp0, a0, reg)*ESUBVA(a0,reg))) / esubva1(a,r) ;

*  INCPAR, SUBPAR -- Use regional private demand at agents' prices

incpar1(i,r) = sum((i0,r0)$(mapi(i0,i) and mapr(r0,r)), vdpp(i0,r0) + vmpp(i0,r0)) ;
subpar1(i,r) = incpar1(i,r) ;
incpar1(i,r)$incpar1(i,r)
          = sum((i0,r0)$(mapi(i0,i) and mapr(r0,r)), INCPAR(i0,r0)*(vdpp(i0,r0) + vmpp(i0,r0)))
          / incpar1(i,r) ;
subpar1(i,r)$subpar1(i,r)
          = sum((i0,r0)$(mapi(i0,i) and mapr(r0,r)), SUBPAR(i0,r0)*(vdpp(i0,r0) + vmpp(i0,r0)))
          / subpar1(i,r) ;

*  ESUBD -- Use regional aggregate Armington demand

esubd1(i,r) = sum(i0$mapi(i0,i), sum(reg$mapr(reg,r),
               sum(a0, vdfp(i0,a0,reg) + vmfp(i0,a0,reg))
          +            vdpp(i0,reg) + vmpp(i0,reg)
          +            vdgp(i0,reg) + vmgp(i0,reg)
          +            vdip(i0,reg) + vmip(i0,reg)
               )) ;
esubd1(i,r)$esubd1(i,r)
          = sum(i0$mapi(i0,i), sum(reg$mapr(reg,r), ESUBD(i0,reg)*(
               sum(a0, vdfp(i0,a0,reg) + vmfp(i0,a0,reg))
          +            vdpp(i0,reg) + vmpp(i0,reg)
          +            vdgp(i0,reg) + vmgp(i0,reg)
          +            vdip(i0,reg) + vmip(i0,reg))))
          / esubd1(i,r) ;

*  ESUBM -- Use regional aggregate import demand

esubm1(i,r) = sum(i0$mapi(i0,i), sum(reg$mapr(reg,r),
            +  sum(a0, vmfp(i0,a0,reg))
            +          vmpp(i0,reg)
            +          vmgp(i0,reg)
            +          vmip(i0,reg))) ;
esubm1(i,r)$esubm1(i,r)
            = sum(i0$mapi(i0,i), sum(reg$mapr(reg,r), ESUBM(i0,reg)*(
            +  sum(a0, vmfp(i0,a0,reg))
            +          vmpp(i0,reg)
            +          vmgp(i0,reg)
            +          vmip(i0,reg))))
            / esubm1(i,r) ;

*  RORFLEX -- Use regional level of capital stock

RORFLEX1(r) = sum(r0$mapr(r0,r), vkb(r0)) ;
RORFLEX1(r)$RORFLEX1(r) =sum(r0$mapr(r0,r), RORFLEX(r0)*vkb(r0)) / RORFLEX1(r) ;

*  Save the data

execute_unload "%baseName%/agg/%baseName%Par.gdx",
   ESUBT1=ESUBT, ESUBC1=ESUBC, ESUBVA1=ESUBVA, ETRAQ1=ETRAQ, ESUBQ1=ESUBQ,
   INCPAR1=INCPAR, SUBPAR1=SUBPAR, ESUBG1=ESUBG, ESUBI1=ESUBI,
   ESUBD1=ESUBD, ESUBM1=ESUBM, ESUBS1=ESUBS, ETRAE1=ETRAE, RORFLEX1=RORFLEX
;

* ------------------------------------------------------------------------------
*
*  Aggregate energy data
*
* ------------------------------------------------------------------------------

*  Energy matrices

parameters
   EDF(ERG, ACTS, REG)     "Usage of domestic products by firm"
   EMF(ERG, ACTS, REG)     "Usage of imported products by firm"
   EDP(ERG,REG)            "Private consumption of domestic goods"
   EMP(ERG,REG)            "Private consumption of imported goods"
   EDG(ERG,REG)            "Public consumption of domestic goods"
   EMG(ERG,REG)            "Public consumption of imported goods"
   EDI(ERG,REG)            "Investment consumption of domestic goods"
   EMI(ERG,REG)            "Investment consumption of imported goods"
   EXI(ERG, REG, REG)      "Bilateral trade in energy"
;

execute_load "%gtpDir%/%GTAPBASE%vole.gdx",
   EDF, EMF, EDP, EMP, EDG, EMG, EDI, EMI, EXI
;

parameters
   EDF1(i, a, r)           "Usage of domestic products by firm"
   EMF1(i, a, r)           "Usage of imported products by firm"
   EDP1(i, r)              "Private consumption of domestic goods"
   EMP1(i, r)              "Private consumption of imported goods"
   EDG1(i, r)              "Public consumption of domestic goods"
   EMG1(i, r)              "Public consumption of imported goods"
   EDI1(i, r)              "Investment consumption of domestic goods"
   EMI1(i, r)              "Investment consumption of imported goods"
   EXI1(i, r, rp)          "Bilateral trade in energy"
;

Agg3(edf,edf1,ERG,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(emf,emf1,ERG,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg2(edp,edp1,ERG,i,mapi,r0,r,mapr) ;
Agg2(emp,emp1,ERG,i,mapi,r0,r,mapr) ;
Agg2(edg,edg1,ERG,i,mapi,r0,r,mapr) ;
Agg2(emg,emg1,ERG,i,mapi,r0,r,mapr) ;
Agg2(edi,edi1,ERG,i,mapi,r0,r,mapr) ;
Agg2(emi,emi1,ERG,i,mapi,r0,r,mapr) ;
Agg3(exi,exi1,ERG,i,mapi,r0,r,mapr,rp0,rp,mapr) ;

edf1(i,a,r)$(voi1(i,r) = 0)  = 0 ;
edp1(i,r)$(voi1(i,r) = 0)    = 0 ;
edg1(i,r)$(voi1(i,r) = 0)    = 0 ;
exi1(i,r,rp)$(voi1(i,r) = 0) = 0 ;

*  Save the data

execute_unload  "%baseName%/agg/%baseName%Vole.gdx",
   EDF1=EDF, EMF1=EMF,
   EDP1=EDP, EMP1=EMP,
   EDG1=EDG, EMG1=EMG,
   EDI1=EDI, EMI1=EMI,
   EXI1=EXI
;

* ------------------------------------------------------------------------------
*
*  Aggregate CO2 emissions data
*
* ------------------------------------------------------------------------------

*  CO2 Emission matrices

parameters
   MDF(FUEL, ACTS, REG)          "Emissions from domestic product in current production, .."
   MMF(FUEL, ACTS, REG)          "Emissions from imported product in current production, .."
   MDP(FUEL, REG)                "Emissions from private consumption of domestic product, Mt CO2"
   MMP(FUEL, REG)                "Emissions from private consumption of imported product, Mt CO2"
   MDG(FUEL, REG)                "Emissions from govt consumption of domestic product, Mt CO2"
   MMG(FUEL, REG)                "Emissions from govt consumption of imported product, Mt CO2"
   MDI(FUEL, REG)                "Emissions from invt consumption of domestic product, Mt CO2"
   MMI(FUEL, REG)                "Emissions from invt consumption of imported product, Mt CO2"
;

execute_load "%gtpDir%/%GTAPBASE%emiss.gdx",
   MDF, MMF, MDP, MMP, MDG, MMG, MDI, MMI
;

parameters
   MDF1(i, a, r)         "Emissions from domestic product in current production, .."
   MMF1(i, a, r)         "Emissions from imported product in current production, .."
   MDP1(i, r)            "Emissions from private consumption of domestic product, Mt CO2"
   MMP1(i, r)            "Emissions from private consumption of imported product, Mt CO2"
   MDG1(i, r)            "Emissions from govt consumption of domestic product, Mt CO2"
   MMG1(i, r)            "Emissions from govt consumption of imported product, Mt CO2"
   MDI1(i, r)            "Emissions from invt consumption of domestic product, Mt CO2"
   MMI1(i, r)            "Emissions from invt consumption of imported product, Mt CO2"
;

Agg3(mdf,mdf1,fuel,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg3(mmf,mmf1,fuel,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg2(mdp,mdp1,fuel,i,mapi,r0,r,mapr) ;
Agg2(mmp,mmp1,fuel,i,mapi,r0,r,mapr) ;
Agg2(mdg,mdg1,fuel,i,mapi,r0,r,mapr) ;
Agg2(mmg,mmg1,fuel,i,mapi,r0,r,mapr) ;
Agg2(mdi,mdi1,fuel,i,mapi,r0,r,mapr) ;
Agg2(mmi,mmi1,fuel,i,mapi,r0,r,mapr) ;

*  Save the data

execute_unload  "%baseName%/agg/%baseName%Emiss.gdx",
   MDF1=MDF, MMF1=MMF, MDP1=MDP, MMP1=MMP, MDG1=MDG, MMG1=MMG, MDI1=MDI, MMI1=MMI
;

* -------------------------------------------------------------------------------
*

*  Calculate the energy content of fossil fuel consumption
*
*  THIS IS A QUICK FIX AND NEEDS REVIEW

parameters
   eaf(e0,a0,r0)     "Armington energy consumption by firms"
   phiNRG(f0,a0,r0)  "Rate of burning of fossil fuels"
   nrgCOMB(f0,a0,r0) "Energy combusted"
   nrgCOMB1(i,a,r)   "Aggregated combusted energy"
;

*  Convert to c_mtoe

co2_mtoe(f0) = co2_mtoe(f0)*12/44 ;

*  Total energy
eaf(e0,a0,r0) = edf(e0,a0,r0) + emf(e0,a0,r0) ;

*  Calculate combustion based on the standard emissions coefficient
nrgCOMB(f0,a0,r0) = ((mdf(f0,a0,r0)+mmf(f0,a0,r0))/co2_mtoe(f0))$(etr0(f0) and atr0(a0))
                  +  eaf(f0,a0,r0)$(not (etr0(f0) and atr0(a0))) ;

*  Cap combustion to actual energy consumption
nrgCOMB(f0,a0,r0) = eaf(f0,a0,r0)$(nrgCOMB(f0,a0,r0) > eaf(f0,a0,r0))
                  + nrgCOMB(f0,a0,r0)$(nrgCOMB(f0,a0,r0) <= eaf(f0,a0,r0))
                  ;

*  Aggregate
nrgCOMB1(i,a,r) = sum((r0,f0,a0)$(mapr(r0,r) and mapi(f0,i) and mapa(a0,a)), nrgCOMB(f0,a0,r0)) ;

$ontext
file xcsv / nrgComb.csv / ;
put xcsv ;
put "Var,Region,Input,Activity,Value" / ;
xcsv.pc=5 ;
xcsv.nd=9 ;

loop((f0,i0,r0),
   put "MDF",r0.tl,f0.tl,i0.tl,mdf(f0,i0,r0) / ;
   put "MMF",r0.tl,f0.tl,i0.tl,mmf(f0,i0,r0) / ;
   put "EDF",r0.tl,f0.tl,i0.tl,edf(f0,i0,r0) / ;
   put "EMF",r0.tl,f0.tl,i0.tl,emf(f0,i0,r0) / ;
   put "EAF",r0.tl,f0.tl,i0.tl,eaf(f0,i0,r0) / ;
   put "nrgComb",r0.tl,f0.tl,i0.tl,nrgComb(f0,i0,r0) / ;
) ;
loop((i,a,r),
   put "MDF1",r.tl,i.tl,a.tl,mdf1(i,a,r) / ;
   put "MMF1",r.tl,i.tl,a.tl,mmf1(i,a,r) / ;
   put "EDF1",r.tl,i.tl,a.tl,edf1(i,a,r) / ;
   put "EMF1",r.tl,i.tl,a.tl,emf1(i,a,r) / ;
) ;
loop((i,a,r),
   put "nrgComb1",r.tl,i.tl,a.tl,nrgComb1(i,a,r) / ;
) ;

putclose xcsv ;
$offtext

* ------------------------------------------------------------------------------
*
*  Load and aggregate satellite accounts if requested
*
* ------------------------------------------------------------------------------

$iftheni.nco2 "%NCO2%" == "ON"

* ------------------------------------------------------------------------------
*
*  Aggregate non-CO2 emissions data
*
* ------------------------------------------------------------------------------

*  Mostly NON-CO2 emission matrices

sets
   LU       "Land use categories"
   LUType   "Land use sub-categories"
   AR       "IPCC Assessment Reports"
;

$gdxin "%gtpDir%/%GTAPBASE%nco2.gdx"
$load LU, LUType, AR

parameters
   EMI_IO(EM, COMM, ACTS, REG)         "IO-based emissions in Mmt"
   EMI_IOP(EM, COMM, ACTS, REG)        "IO-based process emissions in Mmt"
   EMI_ENDW(EM, ENDW, ACTS, REG)       "Endowment-based emissions in Mmt"
   EMI_QO(EM, ACTS, REG)               "Output-based emissions in Mmt"
   EMI_HH(EM, COMM, REG)               "Private consumption-based emissions in Mmt"
   EMI_LU(GHG,LU,LUType,REG)           "Land-use based emissions"
   GWP(ghg, reg, ar)                   "Global warming potential"
;

*  Load the data

execute_loaddc "%gtpDir%/%GTAPBASE%nco2.gdx",
   EMI_IO, EMI_IOP, EMI_ENDW, EMI_QO, EMI_HH, EMI_LU, GWP ;
;

parameters
   EMI_IO1(EM, i, a, r)          "IO-based emissions in Mmt"
   EMI_IOP1(EM, i, a, r)         "IO-based process emissions in Mmt"
   EMI_ENDW1(EM, fp, a, r)       "Endowment-based emissions in Mmt"
   EMI_QO1(EM, a, r)             "Output-based emissions in Mmt"
   EMI_HH1(EM, i, r)             "Private consumption-based emissions in Mmt"
   EMI_LU1(GHG,LU,LUType,r)      "Land-use based emissions"
   GWP1(ghg, r, ar)              "Global warming potential"
;

file prcsv / procEmi.csv / ;
if(0,
   put prcsv ;
   prcsv.pc=5 ;
   prcsv.nd=10 ;
   if(0,
      put "GHG,Activity,Value" / ;
      loop((ghg,acts),
         put ghg.tl, acts.tl, (sum(reg, gwp(ghg,reg,"AR4")*(sum(comm, emi_iop(ghg,comm,acts,reg))
            + sum(endw, EMI_ENDW(ghg,endw,acts,reg))
            + emi_qo(ghg,acts,reg)))) / ;
      ) ;
   else
      put '' ; loop(ghg, put ghg.tl ; ) put / ;
      loop(acts,
         put acts.tl ;
         loop(ghg,
            put (sum(reg, gwp(ghg,reg,"AR4")*(sum(comm, emi_iop(ghg,comm,acts,reg))
                  + sum(endw, EMI_ENDW(ghg,endw,acts,reg))
                  + emi_qo(ghg,acts,reg)))) ;
         ) ;
         put / ;
      ) ;
   ) ;

   abort "Temp" ;
) ;

*  Aggregate the data

EMI_IO1(EM, i, a, r)
   =sum((mapi(comm,i), mapa(acts,a), mapr(reg,r)), EMI_IO(EM, COMM, ACTS, REG)) ;

EMI_IOP1(EM, i, a, r)
   =sum((mapi(comm,i), mapa(acts,a), mapr(reg,r)), EMI_IOP(EM, COMM, ACTS, REG)) ;

EMI_ENDW1(EM, fp, a, r)
   =sum((mapf(ENDW,fp), mapa(acts,a), mapr(reg,r)), EMI_ENDW(EM, ENDW, ACTS, REG)) ;

EMI_QO1(EM, a, r)
   =sum((mapa(acts,a), mapr(reg,r)), EMI_QO(EM, ACTS, REG)) ;

display emi_qo1, emi_qo ;

EMI_HH1(EM, i, r)
   =sum((mapi(comm,i), mapr(reg,r)), EMI_HH(EM, COMM, REG)) ;

EMI_LU1(GHG,LU,LUType,r)
   =sum((mapr(reg,r)), EMI_LU(GHG,LU,LUType,REG)) ;

*  !!!! Should we add LU emissions?

GWP1(ghg,r,ar) = sum(mapr(REG,R),
     sum((COMM, ACTS), EMI_IO(GHG, COMM, ACTS, REG) + EMI_IOP(GHG, COMM, ACTS, REG))
   + sum((ENDW, ACTS), EMI_ENDW(GHG, ENDW, ACTS, REG))
   + sum((ACTS), EMI_QO(GHG, ACTS, REG))
   + sum((COMM), EMI_HH(GHG, COMM, REG))) ;

GWP1(ghg,r,ar) = (sum(mapr(REG,R), GWP(ghg,REG,ar)*(
     sum((COMM, ACTS), EMI_IO(GHG, COMM, ACTS, REG) + EMI_IOP(GHG, COMM, ACTS, REG))
   + sum((ENDW, ACTS), EMI_ENDW(GHG, ENDW, ACTS, REG))
   + sum((ACTS), EMI_QO(GHG, ACTS, REG))
   + sum((COMM), EMI_HH(GHG, COMM, REG)))) / GWP1(ghg,r,ar))$GWP1(ghg,r,ar)
*  IF THERE ARE NO EMISSIONS
   + (sum(mapr(REG,R), GWP(ghg,REG,ar)) / sum(mapr(REG,R), 1))$(GWP1(ghg,r,ar) eq 0)
   ;

*  Save the data

execute_unload "%baseName%/agg/%baseName%NCO2.gdx",
   ar, i=comm, fp=endw, a=acts, r=reg, em, emn, ghg, nghg, lu, luType,
   gwp1=GWP, emi_IO1=emi_IO, emi_IOP1=emi_IOP,
   emi_ENDW1=emi_ENDW, emi_QO1=emi_QO, emi_HH1=emi_HH, emi_LU1=emi_LU ;
;

*  Save the energy and emissions data to the CSV file if requested

$batinclude "aggNRG.gms" AggGTAP 1

$endif.nco2

$iftheni.BoP "%BoP%" == "ON"

* ------------------------------------------------------------------------------
*
*  Additional BoP accounts -- from GMiG and GDyn
*
* ------------------------------------------------------------------------------

parameters
   remit(lab,reg,reg)   "Initial remittances"
   yqtf(reg)            "Initial outflow of capital income"
   yqht(reg)            "Initial inflow of capital income"
   ODAIn(reg)           "Initial ODA inflows"
   ODAOut(reg)          "Initial ODA outflows"
;

parameters
   remit1(l,s,d)        "Initial remittances"
   yqtf1(r)             "Initial outflow of capital income"
   yqht1(r)             "Initial inflow of capital income"
   ODAIn1(r)            "Initial ODA inflows"
   ODAOut1(r)           "Initial ODA outflows"
;

*  Remittances and flow of profits

$ifthen exist "%gtpDir%/%GTAPBASE%BOP.gdx"
   execute_load "%gtpDir%/%GTAPBASE%BOP.gdx", remit, yqtf, yqht, ODAIn, ODAOut ;

   Agg3(remit,remit1,lab,l,mapf,r0,s,mapr,rp0,d,mapr) ;
   Agg1(yqtf,yqtf1,r0,r,mapr) ;
   Agg1(yqht,yqht1,r0,r,mapr) ;
   Agg1(ODAIn,ODAIn1,r0,r,mapr) ;
   Agg1(ODAOut,ODAOut1,r0,r,mapr) ;
$else
   remit1(l,s,d) = 0 ;
   yqtf1(r)      = 0 ;
   yqht1(r)      = 0 ;
   ODAIn1(r)     = 0 ;
   ODAOut1(r)    = 0 ;

$endif

execute_unload "%baseName%/agg/%baseName%BoP.gdx",
   REMIT1=REMIT, YQTF1=YQTF, YQHT1=YQHT, ODAIn1=ODAIn, ODAOut1=ODAOut ;

$endif.BoP

$iftheni.elast "%ELAST%" == "ON"

parameters
   etat0(reg)           "Aggregate land elasticities"
   landmax0(reg)        "Land maximum"
   etanrf0(reg,acts)    "Natural resource elasticities"
;

parameters
   etat1(r)             "Aggregate land elasticities"
   landmax1(r)          "Land maximum"
   etanrf1(r,a)         "Natural resource elasticities"
;

*  Land parameters

$ifthen exist "%gtpDir%//%GTAPBASE%ELAST.gdx"
   execute_load "%gtpDir%//%GTAPBASE%ELAST.gdx",
      etat0, landmax0, etanrf0 ;

   loop(LAND,
      etat1(r)     = sum(r0$mapr(r0,r), sum(a0, evfb(LAND, a0, r0))) ;
      landMax1(r)  = etat1(r) ;
      etat1(r)$etat1(r) = sum(r0$mapr(r0,r), etat0(r0)*sum(a0, evfb(LAND, a0, r0)))/etat1(r) ;
      landMax1(r)$landMax1(r) = sum(r0$mapr(r0,r),
         landMax0(r0)*sum(a0, evfb(LAND,a0,r0)))/landMax1(r) ;
   ) ;

   loop(NTRS,
      etanrf1(r,a) = sum(r0$mapr(r0,r), sum(a0$mapa(a0,a), evfb(NTRS, a0, r0))) ;
      etanrf1(r,a)$etanrf1(r,a) = sum(r0$mapr(r0,r), sum(a0$mapa(a0,a),
         etanrf0(r0,a0)*evfb(NTRS, a0, r0)))/etanrf1(r,a) ;
   ) ;
   display etanrf1 ;

$else

   etat1(r)     = 0 ;
   landmax1(r)  = 1 ;
   etanrf1(r,a) = 1 ;

$endif

execute_unload "%baseName%/agg/%baseName%Elast.gdx",
   ETAT1=ETAT, LANDMAX1=LANDMAX, ETANRF1=ETANRF ;

$endif.elast

$iftheni.lab "%LAB%" == "ON"

parameters

*  Input data from ILO

   labvol(lab,acts,reg)    "Labor volumes in millions"
   wageILO(lab, acts, reg) "Wages imputed from ILO"

*  Labor/VA (from GIDD)

   emplg(lg, acts, reg)    "Labor volumes emanating from GIDD"
   evfbg(lg, acts, reg)    "Labor value added at basic prices emanating from GIDD"
   evfpg(lg, acts, reg)    "Labor value added at purchasers prices emanating from GIDD"
   empl2014(reg, lg)       "Aging of GIDD volumes"

   evfbg1(l, a, r)         "Labor value added at basic prices emanating from GIDD"
   evfpg1(l, a, r)         "Labor value added at purchasers prices emanating from GIDD"
   emplg1(l, a, r)         "GIDD employment data"

   premg0(l, a, r)         "Base wage premium"
   wageBar(l, r)           "Base avg. wage"
   labShr(l, a, r)         "Labor share share of GIDD"
   tlabg(l, r)             "Total labor"

*  Output vectors

   empl1(l, a, r)         "Employment data in person years"
   wage1(l, a, r)         "Imputed wages"
   emplz(l,z,r)           "Total employment by zone"
;

file wcsv / wages.csv / ;

if(IFLABOR = noLab,

*  Just set wages to 1 and employment to evfb1

   empl1(l,a,r) = evfb1(l,a,r) ;

elseif(IFLABOR = agLab),

*  Read the labor volumes and do a two-sector aggregation

   execute_load "%gtpDir%//%GTAPBASE%Wages.gdx" labvol=q, wageILO=w ;
   if(0,
      put wcsv ;
      put "Region,Variable,Skill,Sector,Value" / ;
      wcsv.pc=5 ;
      wcsv.nd=9 ;
      loop((lab,acts,reg),
         put reg.tl, "LabVol", lab.tl, acts.tl, labvol(lab,acts,reg) / ;
         put reg.tl, "Wage", lab.tl, acts.tl, wageILO(lab,acts,reg) / ;
         put reg.tl, "VFM", lab.tl, acts.tl, evfb(lab,acts,reg) / ;
      ) ;
   ) ;

   loop(z$(not sameas(z,"nsg")),

*     Employment equals remuneration divided by average wage by zone

*     Total employment in zone z
      emplz(l,z,r) = sum(a$mapz(z,a),
         sum((lab, a0, r0)$(mapf(lab,l) and mapa(a0,a) and mapr(r0,r)), labvol(lab,a0,r0))) ;
      display emplz ;
*     Average wage in zone z (Total remuneration in z divided by total employment in z)
      emplz(l,z,r)$emplz(l,z,r) = sum(a$mapz(z,a), evfb1(l,a,r)) /  emplz(l,z,r) ;
      display emplz ;
*     And thus employment by activity
      empl1(l,a,r)$(mapz(z,a) and emplz(l,z,r)) = evfb1(l,a,r)/emplz(l,z,r) ;
      display empl1 ;
   ) ;

elseif(IFLABOR = allLab),

*  Read the labor volumes and make wages fully sector-specific

   execute_load "%gtpDir%//%GTAPBASE%Wages.gdx" labvol=q ;

   Agg3(labvol,empl1,lab,l,mapf,a0,a,mapa,r0,r,mapr) ;

elseif(IFLABOR = giddLab),

   $$iftheni.ifGender "%ifGENDER%" == "ON"

      empl1(l,i,r) = GIDDLab1(l,i,r) ;

   $$else.ifGender
*     Read the GIDD data
*     !!!! THIS SECTION NEEDS WORK -- FOR EXAMPLE IF USING ALL 5 LABOR SKILLS IN GTAP, re-balancing, etc.

      execute_load "%giddLab%"  evfbg=vfmg, evfpg=evfag, emplg=empl ;

*     !!!! NEED TO REBALANCE EVFB AND EMPL

      Agg3(evfbg,evfbg1,lg,l,maplGIDD,a0,a,mapa,r0,r,mapr) ;
      Agg3(evfpg,evfpg1,lg,l,maplGIDD,a0,a,mapa,r0,r,mapr) ;
      Agg3(emplg,emplg1,lg,l,maplGIDD,a0,a,mapa,r0,r,mapr) ;

      if(ver eq 10,

*        This is a temporary fix to wages and volumes to re-base 2011 to 2014

*        Calculate wage premium from the GIDD (calibrated to GTAP v9)

         wageBar(l,r)   = sum(a, evfpg1(l,a,r)) / sum(a, emplg1(l,a,r)) ;
         premg0(l,a,r)$emplg1(l,a,r) = (evfpg1(l,a,r)/emplg1(l,a,r)) / wageBar(l,r) ;

*        Get projected labor volumes

         execute_load "../SatAcct/GIDDV10.gdx", empl2014 ;

*        display empl2014 ;

*        Aggregate projected labor volumes

         tlabg(l, r) = sum((r0,lg)$(mapr(r0,r) and maplGIDD(lg,l)), empl2014(r0, lg)) ;

*        Calculate labor value shares

         labshr(l,a,r) = evfb1(l,a,r) / sum(a1, evfb1(l,a1,r)) ;

*        display premg0, labshr, tlabg ;

*        Calulate employment consistent with new employment level and assuming
*        'old' wage premia

         empl1(l,a,r)$premg0(l,a,r) = tlabg(l, r)
                      * (labshr(l, a, r)/premg0(l,a,r))
                      / sum(a1$premg0(l,a1,r), labshr(l,a1,r)/premg0(l,a1,r)) ;
      else

         empl1(l,a,r) = emplg1(l,a,r) ;
      ) ;

   $$endif.ifGender

*  Re-scale labor

   empl1(l,a,r) = 1*empl1(l,a,r) ;

) ;

$ontext
file xxx / gidd.csv / ;
if(0,
   put xxx ;
   put "Var,Lab,Act,Reg,Value" / ;
   xxx.pc=5 ;
   xxx.nd=9 ;
   loop((l,a,r),
      put "Empl",  l.tl, a.tl, r.tl, empl1(l,a,r) / ;
      put "EmplG", l.tl, a.tl, r.tl, emplg1(l,a,r) / ;
      put "EVFB",  l.tl, a.tl, r.tl, evfb1(l,a,r) / ;
      put "EVFP",  l.tl, a.tl, r.tl, evfp1(l,a,r) / ;
      put "EVFBG",  l.tl, a.tl, r.tl, evfbg1(l,a,r) / ;
      put "EVFPG",  l.tl, a.tl, r.tl, evfpg1(l,a,r) / ;
      put "PREMG0", l.tl, a.tl, r.tl, premg0(l,a,r) / ;
   ) ;
   abort "Temp" ;
) ;
$offtext

wage1(l,a,r)$empl1(l,a,r) = evfb1(l,a,r) / empl1(l,a,r) ;
empl1(l,a,r) = 1e6*empl1(l,a,r) ;

execute_unload "%baseName%/agg/%baseName%Wages.gdx",
   EMPL1=q, wage1=wage ;

$endif.lab

* ------------------------------------------------------------------------------
*
*  Deal with water volumes
*
* ------------------------------------------------------------------------------

Parameter
*  Water data
   h2ocrp(reg, i0)            "Water withdrawal for activities"
   h2oUse(wbnd0, reg)         "Water withdrawal for aggregate uses"
   h2ocrp1(a, r)              "Water withdrawal for activities"
   h2oUse1(wbnd0, r)          "Water withdrawal for aggregate uses"
;

$iftheni.WAT %IFWATER% == "ON"

execute_load "%gtpDir%/%GTAPBASE%DAT.gdx", h2oCrp, h2oUse ;

*  Water aggregation

h2ocrp1(a,r)     = sum((i0, r0)$(mapi(i0,a) and mapr(r0,r)), h2ocrp(r0,i0)) ;
h2oUse1(wbnd0,r) = sum(r0$mapr(r0,r), h2oUse(wbnd0, r0)) ;

if(1,

*  Check to see if value added and volume of water are consistent

   put screen ;
   put / ;
   loop((r,wat,a)$((h2ocrp1(a,r) eq 0 and evfp1(wat, a, r) ne 0) or
                   (h2ocrp1(a,r) ne 0 and evfp1(wat, a, r) eq 0)),
      put "Water warning: ", r.tl:<10, a.tl:<10, "h2o(cu.m.) = ", (1e-6*h2ocrp1(a,r)):15:4,
          " Cost($mn) = ", evfp1(wat,a,r):14:4 / ;
   ) ;
   putclose screen ;
) ;

$else.WAT

h2oCrp1(a,r)      = 0 ;
h2oUse1(wbnd0, r) = 0 ;

$endif.WAT

execute_unload "%baseName%/agg/%baseName%Sat.gdx"
   nrgComb1=nrgComb, h2ocrp1=h2ocrp, h2ouse1=h2ouse
;

* ------------------------------------------------------------------------------
*
*  Aggregate the MRIO database
*
* ------------------------------------------------------------------------------

$iftheni.MRIO "%ifMRIO%" == "ON"

set amrio "MRIO agents" /
   INT   "Intermediate demand"
   CONS  "Private and public demand"
   CGDS  "Investment demand"
/ ;

Parameter
   VIUMS(comm, amrio, reg, reg)  "Tariff inclusive value of imports by end-user"
   VIUWS(comm, amrio, reg, reg)  "Value of imports at CIF prices by end-user"

   VIUMS1(i, amrio, r, r)        "Aggregate tariff inclusive value of imports by end-user"
   VIUWS1(i, amrio, r, r)        "Aggregate value of imports at CIF prices by end-user"
;

execute_load "%gtpDir%/%GTAPBASE%MRIO.gdx", VIUMS, VIUWS ;

viums1(i, amrio, s, d) =
   sum((comm,src,dst)$(mapi(comm,i) and mapr(src,s) and mapr(dst,d)), viums(comm,amrio,src,dst)) ;
viuws1(i, amrio, s, d) =
   sum((comm,src,dst)$(mapi(comm,i) and mapr(src,s) and mapr(dst,d)), viuws(comm,amrio,src,dst)) ;

execute_unload "%baseName%/agg/%baseName%MRIO.gdx"
   VIUMS1=VIUMS, VIUWS1=VIUWS ;

$endif.MRIO

* ------------------------------------------------------------------------------
*
*  Load and aggregate land use data
*
* ------------------------------------------------------------------------------

$iftheni.ifLU "%LU%" == "ON"

parameters
   AEZ_EVFA(AEZ0,ACTS,REG)              "AEZ-related land value added at agents' prices"
   AEZ_VFM(AEZ0,ACTS,REG)               "AEZ-related land value added at market prices"
   AEZ_EVOA(AEZ0,REG)                   "AEZ-related land value added net of income taxes"
   WGHT_MATRIX(AEZ0,ACTS,REG)           "AEZ weights used to share out data"
   LU_EVFA(fpa0,ACTS,REG)               "AEZ-related value added at agents' prices"
   LU_VFM(fpa0,ACTS,REG)                "AEZ-related value added at market prices"
   LU_EVOA(fpa0,REG)                    "AEZ-related value added net of income taxes"
   prod_aez(reg,aez0,acr0)              "Crop production in '000 metric tons"
   harvarea_aez(reg,aez0,acr0)          "Harvested area in '000 hectars"
   lcover(reg,aez0,LCOVER_TYPE)         "Land cover by AEZ"
   lvstck_aez(reg,aez0,rum0)            "Herd size in '000 head by aez"
;

*  Load the data

execute_load "%AEZFILE%",
   AEZ_EVFA, aez_vfm, aez_evoa, wght_matrix, lu_evfa, lu_vfm, lu_evoa, prod_aez, harvarea_aez, lcover, lvstck_aez
;

file aezcsv / aez.csv / ;
if(1,
   put aezcsv ;
   put "Var,Region,Act,LT,Value" / ;
   aezcsv.pc=5 ;
   aezcsv.nd=9 ;
   loop((aez0,a,r),
      put "aez_evfa", r.tl, a.tl, aez0.tl, (sum((acts,reg)$(mapa(acts,a) and mapr(reg,r)), AEZ_EVFA(AEZ0,ACTS,REG))) / ;
      put "aez_vfm",  r.tl, a.tl, aez0.tl, (sum((acts,reg)$(mapa(acts,a) and mapr(reg,r)), AEZ_VFM(AEZ0,ACTS,REG))) / ;
   ) ;
   loop((aez0,r),
      put "aez_evoa", r.tl, "Tot", aez0.tl, (sum((reg)$(mapr(reg,r)), AEZ_EVOA(aez0,REG))) / ;
   ) ;
   loop((fpa0,a,r),
      put "lu_evfa", r.tl, a.tl, fpa0.tl, (sum((acts,reg)$(mapa(acts,a) and mapr(reg,r)), LU_EVFA(fpa0,ACTS,REG))) / ;
      put "lu_vfm",  r.tl, a.tl, fpa0.tl, (sum((acts,reg)$(mapa(acts,a) and mapr(reg,r)), LU_VFM(fpa0,ACTS,REG))) / ;
   ) ;
   loop((fpa0,r),
      put "lu_evoa", r.tl, "Tot", fpa0.tl, (sum((reg)$(mapr(reg,r)), LU_EVOA(fpa0,REG))) / ;
   ) ;
   loop((aez0,acr0,r),
      put "prod_aez",     r.tl, acr0.tl, aez0.tl, (sum((reg)$(mapr(reg,r)), prod_aez(reg,aez0,acr0))) / ;
      put "harvarea_aez", r.tl, acr0.tl, aez0.tl, (sum((reg)$(mapr(reg,r)), harvarea_aez(reg,aez0,acr0))) / ;
   ) ;
   loop((aez0,rum0,r),
      put "lvstck_aez",     r.tl, rum0.tl, aez0.tl, (sum((reg)$(mapr(reg,r)), lvstck_aez(reg,aez0,rum0))) / ;
   ) ;
   loop((aez0,LCOVER_TYPE,r),
      put "LCOVER_TYPE",  r.tl, LCOVER_TYPE.tl, aez0.tl, (sum((reg)$(mapr(reg,r)), lcover(reg,aez0,LCOVER_TYPE))) / ;
   ) ;
   loop((fp,a,r),
      put "evfa",  r.tl, a.tl, fp.tl, evfp1(fp,a,r) / ;
      put "vfm",   r.tl, a.tl, fp.tl, evfb1(fp,a,r) / ;
      put "evoa",  r.tl, a.tl, fp.tl, evos1(fp,a,r) / ;
   ) ;
   loop((a,r),
      put "voa",  r.tl, a.tl, "Tot", voa1(a,r) ;
   ) ;
) ;

$batinclude "aggsamAEZ.gms" AggGTAPAEZ 1

$ontext

Agg4(NC_TRAD,NC_TRAD1,nco2,emn,mapnco2,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg4(NC_ENDW,NC_ENDW1,nco2,emn,mapnco2,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
Agg3(NC_QO,NC_QO1,nco2,emn,mapnco2,a0,a,mapa,r0,r,mapr) ;
Agg3(NC_HH,NC_HH1,nco2,emn,mapnco2,i0,i,mapi,r0,r,mapr) ;

Agg4(NC_TRAD_CEQ,NC_TRAD_CEQ1,nco2,emn,mapnco2,i0,i,mapi,a0,a,mapa,r0,r,mapr) ;
Agg4(NC_ENDW_CEQ,NC_ENDW_CEQ1,nco2,emn,mapnco2,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
Agg3(NC_QO_CEQ,NC_QO_CEQ1,nco2,emn,mapnco2,a0,a,mapa,r0,r,mapr) ;
Agg3(NC_HH_CEQ,NC_HH_CEQ1,nco2,emn,mapnco2,i0,i,mapi,r0,r,mapr) ;

*  Save the data

execute_unload "%baseName%/Agg/%baseName%NCO2.gdx",
   NC_TRAD1=NC_TRAD, NC_ENDW1=NC_ENDW, NC_QO1=NC_QO, NC_HH1=NC_HH,
   NC_TRAD_CEQ1=NC_TRAD_CEQ, NC_ENDW_CEQ1=NC_ENDW_CEQ, NC_QO_CEQ1=NC_QO_CEQ, NC_HH_CEQ1=NC_HH_CEQ
;

$offtext
$endif.ifLU

* ------------------------------------------------------------------------------
*
*  Load and aggregate the fossil fuel reserve data
*
* ------------------------------------------------------------------------------

$iftheni.ifDepl "%DEPL%" == "ON"

sets
   ri0               "Rystad production sectors" /
                        OIL   "Crude Oil"
                        CND   "Condensate"
                        RFG   "Refinery gains"
                        XLQ   "Other liquids"
                        GAS   "Natural gas"
                        NGL   "NGL"
                        IGS   "Injected gas--unsold"
                        FGS   "Flared gas--unsold"
                     /
   ffl(i0)           / coa, oil, gas /
   mapRysp(ffl,ri0)  "Mapping from GTAP FFL to Rystad production types" /
                        oil.(oil,cnd,rfg,xlq)
                        gas.(gas,ngl,igs,fgs)
                     /
   rf0               "Resource types" /
                        ABD   "Abandoned"
                        PRD   "Producing"
                        UDV   "Under development"
                        DSC   "Discovery"
                        YTD   "Undiscovered, or yet-to-find"
                     /
   resType           "Reserve type"       / res, ytd /
   mapRysr(resType,rf0) /
                        res.(abd, prd, udv, dsc)
                        ytd.(ytd)
                     /
   s0                "Rystad scenarios"   / hi, lo, mid, std /
   pt                "Envisage scenarios" / hi, lo, mid, ref /
   mappt(s0,pt)      "Scenario mapping"   / (hi.hi), (lo.lo), (mid.mid), (std.ref) /
;

parameters
   RysProd(reg,ri0)        "Production in KB/D"
   RysRes(reg,ri0,s0,rf0)  "Rystad reserves in MB"
   r_p_coa0(reg)           "Resource to production ratio for coal"

   extraction(r,a)         "Base year production from reserves in MTOE"
   reserves(r,a,pt)        "Proven reserves in MTOE"
   ytdreserves(r,a,pt)     "Unproven reserves in MTOE"
   r_p(r,a,pt)             "Base year reserve to production ratio"
;

*  Load the data

$ifthen not exist "%DEPLFILE%"
   put screen ; put / ;
   put ">>>>> ERROR: Depletion flag is ON, but unable to find data file:" / ;
   put ">>>>>       ", "%deplfile%" / ;
   Abort "Temp" ;
$endif

execute_loaddc "%DEPLFILE%", RysProd=xp1, RysRes=Res1, r_p_coa0 ;

set eu Energy units /
   toe      Tons of oil equivalent
   mtoe     Millions of tons of oil equivalent
   tj       Terajoules
   ej       Exajoules
   cal      Calories
   gCal     Giga calories
   kwh      Kilowatt hour
   mWh      Megawatt hour
   gWh      Gigawatt hour
   mBTU     Million BTU
   mbd      Million barrels of oil equivalent per day
   mb       Million barrels of oil equivalent
   bcm      Billion cubic meters
   mt       Million tons of coal equivalent
/

alias(eu, eup) ;

Table emat(eu, eup) Energy conversion matrix

*         TO:
                    TOE           MTOE             TJ              EJ            CAL            kWh            mWh            gWh          mBTU            gCal           mbd            mb              bcm             mt
*  FROM:    multiply by:
   TOE   1.00000000E+00 1.00000000E-06 4.18680000E-02  4.18680000E-08 1.00000000E+10 1.16309304E+04 1.16309304E+01 1.16309304E-02 3.96815468E+01 1.00000000E+01 2.09000000E-08 7.62850000E-06  1.21170000E-06 1.98140000E-06
   MTOE  1.00000000E+06 1.00000000E+00 4.18680000E+04  4.18680000E-02 1.00000000E+16 1.16309304E+10 1.16309304E+07 1.16309304E+04 3.96815468E+07 1.00000000E+07 2.09000000E-02 7.62850000E+00  1.21170000E+00 1.98140000E+00
   TJ    2.38845897E+01 2.38845897E-05 1.00000000E+00  1.00000000E-06 2.38845897E+11 2.77800000E+05 2.77800000E+02 2.77800000E-01 9.47777462E+02 2.38845897E+02 4.99187924E-07 1.82203592E-04  2.89409573E-05 4.73249260E-05
   EJ    2.38845897E+07 2.38845897E+01 1.00000000E+06  1.00000000E+00 2.38845897E+17 2.77800000E+11 2.77800000E+08 2.77800000E+05 9.47777462E+08 2.38845897E+08 4.99187924E-01 1.82203592E+02  2.89409573E+01 4.73249260E+01
   CAL   1.00000000E-10 1.00000000E-16 4.18680000E-12  4.18680000E-18 1.00000000E+00 1.16309304E-06 1.16309304E-09 1.16309304E-12 3.96815468E-09 1.00000000E-09 2.09000000E-18 7.62850000E-16  1.21170000E-16 1.98140000E-16
   kWh   8.59776446E-05 8.59776446E-11 3.59971202E-06  3.59971202E-12 8.59776446E+05 1.00000000E+00 1.00000000E-03 1.00000000E-06 3.41172592E-03 8.59776446E-04 1.79693277E-12 6.55880461E-10  1.04179112E-10 1.70356105E-10
   mWh   8.59776446E-02 8.59776446E-08 3.59971202E-03  3.59971202E-09 8.59776446E+08 1.00000000E+03 1.00000000E+00 1.00000000E-03 3.41172592E+00 8.59776446E-01 1.79693277E-09 6.55880461E-07  1.04179112E-07 1.70356105E-07
   gWh   8.59776446E+01 8.59776446E-05 3.59971202E+00  3.59971202E-06 8.59776446E+11 1.00000000E+06 1.00000000E+03 1.00000000E+00 3.41172592E+03 8.59776446E+02 1.79693277E-06 6.55880461E-04  1.04179112E-04 1.70356105E-04
   mBTU  2.52006306E-02 2.52006306E-08 1.05510000E-03  1.05510000E-09 2.52006306E+08 2.93106780E+02 2.93106780E-01 2.93106780E-04 1.00000000E+00 2.52006306E-01 5.26693179E-10 1.92243010E-07  3.05356040E-08 4.99325294E-08
   Gcal  1.00000000E-01 1.00000000E-07 4.18680000E-03  4.18680000E-09 1.00000000E+09 1.16309304E+03 1.16309304E+00 1.16309304E-03 3.96815468E+00 1.00000000E+00 2.09000000E-09 7.62850000E-07  1.21170000E-07 1.98140000E-07
   mbd   4.78468900E+07 4.78468900E+01 2.00325359E+06  2.00325359E+00 4.78468900E+17 5.56503847E+11 5.56503847E+08 5.56503847E+05 1.89863860E+09 4.78468900E+08 1.00000000E+00 3.65000000E+02  5.79760766E+01 9.48038278E+01
   mb    1.31087370E+05 1.31087370E-01 5.48836600E+03  5.48836600E-03 1.31087370E+15 1.52466807E+09 1.52466807E+06 1.52466807E+03 5.20174959E+06 1.31087370E+06 2.73972603E-03 1.00000000E+00  1.58838566E-01 2.59736515E-01
   bcm   8.25286787E+05 8.25286787E-01 3.45531072E+04  3.45531072E-02 8.25286787E+15 9.59885318E+09 9.59885318E+06 9.59885318E+03 3.27486562E+07 8.25286787E+06 1.72484939E-02 6.29570027E+00  1.00000000E+00 1.63522324E+00
   mt    5.04693651E+05 5.04693651E-01 2.11305138E+04  2.11305138E-02 5.04693651E+15 5.87005673E+09 5.87005673E+06 5.87005673E+03 2.00270247E+07 5.04693651E+06 1.05480973E-02 3.85005551E+00  6.11537297E-01 1.00000000E+00
;

*  Convert the data to MTOE

RysProd(reg,ri0)       = RysProd(reg,ri0)*0.001*emat("mbd","MTOE") ;
RysRes(reg,ri0,s0,rf0) = RysRes(reg,ri0,s0,rf0)*emat("MB", "MTOE") ;

file dcsv / Rystad.csv / ;
if(0,
   put dcsv ;
   put "Var,Region,Fuel,Scenario,Type,Value" / ;
   dcsv.pc=5 ;
   dcsv.nd=9 ;
   loop((reg,ffl),
      put "Production", reg.tl, ffl.tl, "", "", sum(mapRysp(ffl,ri0), RysProd(reg,ri0)) / ;
      loop((s0,restype),
         put "Reserves", reg.tl, ffl.tl, s0.tl, resType.tl,
            sum(mapRysp(ffl,ri0), sum(mapRysr(resType,rf0),RysRes(reg,ri0,s0,rf0))) / ;
      ) ;
   ) ;
   Abort "Temp" ;
) ;

loop(mapa(ffl,a),
   extraction(r,a)     = sum(mapr(reg,r), sum(mapRysp(ffl,ri0), RysProd(reg,ri0))) ;
   reserves(r,a,pt)    = sum(mapr(reg,r), sum(mapRysp(ffl,ri0), sum(mappt(s0,pt), sum(rf0$(not sameas(rf0, "YTD")), RysRes(reg,ri0,s0,rf0))))) ;
   ytdreserves(r,a,pt) = sum(mapr(reg,r), sum(mapRysp(ffl,ri0), sum(mappt(s0,pt), sum(rf0$(sameas(rf0, "YTD")), RysRes(reg,ri0,s0,rf0))))) ;
) ;

*  !!!! Assumes 1 to 1 mapping between ffl, i0 and a

loop(mapa(ffl,a),

   if(sameas(ffl,"coa"),

      r_p(r,a,pt) = sum(mapr(reg,r), voa(ffl, reg)) ;
      r_p(r,a,pt)$r_p(r,a,pt) = sum(mapr(reg,r), voa(ffl,reg)*r_p_coa0(reg))/r_p(r,a,pt) ;

   else

      r_p(r,a,pt)$extraction(r,a) = reserves(r,a,pt)/extraction(r,a) ;

   ) ;
) ;

display extraction, reserves, ytdreserves, r_p ;
execute_unload "%baseName%/Fnl/%baseName%Depl.gdx" extraction, reserves, ytdreserves, r_p ;

$endif.ifDepl

$iftheni.DYN "%DYN%" == "ON"

file cmap / %BaseName%CMap.txt / ;
if(0,

*  Save the regional mappings

   put cmap ;

   put 'set c "World economies" /' / ;
   loop(c,
      put '   ', c.tl:<8, '"', c.te(c), '"' / ;
   ) ;
   put "/ ;" / / ;

   put 'set r0 "GTAP Regions" /' / ;
   loop(r0,
      put '   ', r0.tl:<8, '"', r0.te(r0), '"' / ;
   ) ;
   put "/ ;" / / ;

   put 'set r "Project Regions" /' / ;
   loop(r,
      put '   ', r.tl:<8, '"', r.te(r), '"' / ;
   ) ;
   put "/ ;" / / ;

   put 'set cMap(r,c) "Mapping of countries to project regions / ' / ;
   loop((r,r0,c)$(mapr(r0,r) and mapc(r0,c)),
      put "   ", r.tl:<15, ".", c.tl / ;
   ) ;
   put "/ ;" / / ;

   put 'set rMap(r,r0) "Mapping of GTAP regions to project regions / ' / ;
   loop((r,r0)$mapr(r0,r),
      put "   ", r.tl:<15, ".", r0.tl / ;
   ) ;
   put "/ ;" / / ;
) ;

* ------------------------------------------------------------------------------
*
*  Aggregate the dynamic scenarios
*
* ------------------------------------------------------------------------------

sets GHGCodes ;

Parameters
   tPop(scen, c, tranche, tssp)
   popScen(scen, c, sex, tranche, ed, tssp)
   gdpScen(mod, ssp, var, c, tssp)
   popHist(c, tranche, th)
   ghghist(ghgcodes,c,th)
   tpop1(scen, r, tranche, tssp)
   popScen1(scen, r, tranche, edj, tssp)
   gdpScen1(mod, ssp, var, r, tssp)
   popHist1(r, tranche, th)
   ghghist1(ghgcodes,r,th)
;

*  Load the SSP database

* !!!! THIS NEEDS FIXING !!!!
$gdxin "../SatAcct/sspScenV9_2.gdx"
$load GHGCodes
$gdxin
execute_load "%SSPFile%", tPop=pop, popScen, gdpScen, popHist ;
execute_load "../SatAcct/sspScenV9_2.gdx", ghghist ;

*  Aggregate population (ignore gender)

tpop1(scen, r, tranche, tssp)           = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), tpop(scen, c, tranche, tssp)) ;
popScen1(scen, r, tranche, edj, tssp)   = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), sum((sexx,ed)$mape1(edj,ed), popScen(scen, c, sexx, tranche, ed, tssp))) ;
popHist1(r, tranche, th)                = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), popHist(c, tranche, th)) ;

*  Aggregate GDP

gdpScen1(mod, ssp, "gdp", r, tssp)      = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), gdpScen(mod, ssp, "gdp", c, tssp)) ;
gdpScen1(mod, ssp, "gdpppp05", r, tssp) = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), gdpScen(mod, ssp, "gdpppp05", c, tssp)) ;
gdpScen1(mod, ssp, "gdppc", r, tssp)$tpop1(ssp,r,"PTOTL",tssp)
   = (1e6)*gdpScen1(mod, ssp, "gdp", r, tssp) / tpop1(ssp, r, "PTOTL", tssp) ;

*  Aggregate GHG

ghghist1(ghgcodes,r,th)$(not sameas(ghgcodes,"NRGUSE")) = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), ghghist(ghgcodes, c, th)) ;
*  Energy is evaluated in per capita terms
ghghist1("NRGUSE",r,th) = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), popHist(c,"PTOTL",th)) ;
ghghist1("NRGUSE",r,th)$ghghist1("NRGUSE",r,th)
   = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), ghghist("NRGUSE", c, th)*popHist(c,"PTOTL",th))
   / ghghist1("NRGUSE",r,th) ;

* ------------------------------------------------------------------------------
*
*  Aggregate the GIDD population/education scenarios
*
* ------------------------------------------------------------------------------

parameters
   GIDDPopProj(r0, edw, tranche, tssp)
   GIDDPopProj1(r, edw, tranche, tssp)
;

execute_load "%giddProj%", GIDDPopProj ;

*  Load the GIDD scenario

popScen1("GIDD", r, tranche, edj, tssp) = sum(r0$mapr(r0,r), sum(edw$mape2(edj, edw), GiDDPopProj(r0, edw, tranche, tssp))) ;

popScen1(scen,r,trs,"elevt",tssp) = sum(edj$(not sameas(edj,"elevt")), popScen1(scen,r,trs,edj,tssp)) ;
popScen1(scen,r,"ptotl",edj,tssp) = sum(trs, popScen1(scen,r,trs,edj,tssp)) ;
tpop1("GIDD",r,tranche,tssp) = popScen1("GIDD",r,tranche,"elevt",tssp) ;

* --------------------------------------------------------------------------------------------------
*
*  Aggregate the WEO targets
*
* --------------------------------------------------------------------------------------------------

sets
   weo   "Set of WEO forecasts"
   ind   "Set of WEO indicators"
;

Parameter
   WEOData(weo,c,ind,tt) "WEO data"
;

$gdxin "../SatAcct/WEOData.gdx"
* Andre modified this line to get the WEO data working

$load weo, ind

execute_loaddc "../SatAcct/WEOData.gdx", WEOData ;
* Andre modified this line to get the WEO data working


set vWEO "WEO variables"   /
      RGDPD2014   "Real GDP in 2014 dollars"
   /
   WEOFlag(weo,tt)
;

Parameter
   RGDPD2014(weo, c, tt)
   WEOData1(weo, r, vWEO, tt)
;

weoFlag(weo,tt)$sum(c,WEOData(weo, c, "PPPGDP", tt)) = yes ;

RGDPD2014(weo, c, "2014") = WEOData(weo, c, "NGDPD", "2014") ;

*  !!!! Special for Spring 2020

RGDPD2014("WEOSPRING2020", c, "2014") = WEOData("WEOFALL2019", c, "NGDPD", "2014") ;

loop((weo,tt)$(tt.val gt 2014 and weoFlag(weo,tt)),
   RGDPD2014(weo, c, tt) = RGDPD2014(weo, c, tt-1)*(1 + 0.01*WEOData(weo, c, "NGDP_RPCH", tt)) ;
) ;

scalar period ;

for(period=2014 downto 1980 by 1,
   loop(tt$(tt.val = period),
      RGDPD2014(weo, c, tt-1) = RGDPD2014(weo, c, tt)/(1 + 0.01*WEOData(weo, c, "NGDP_RPCH", tt)) ;
   ) ;
) ;


WEOData1(weo, r, "RGDPD2014", tt) = sum((r0,c)$(mapr(r0,r) and mapc(r0,c)), RGDPD2014(weo, c, tt)) ;

execute_unload "%baseName%/agg/%baseName%Scn.gdx",
   weo, vWEO,
   tpop1=popscen, gdpscen1=gdpscen, popHist1=popHist, popScen1=educScen, weoData1=WEOData,
   ghgcodes, ghghist1=ghghist ;
;

$endif.DYN

* ------------------------------------------------------------------------------
*
*  Create the set definitions for the model(s)
*
* ------------------------------------------------------------------------------

file fsetAlt / "%BaseName%/alt/%BaseName%Sets.gms" / ;
file fsetMod / "%BaseName%/fnl/%BaseName%Sets.gms" / ;

*  Create the 'sets' file for AlterTax if requested

$iftheni.ifAlt "%ifAlt%" == "ON"

   put fsetAlt ;
   $$batinclude "makeset.gms" AlterTax
   putclose fsetAlt ;

$endif.ifAlt

*  Create the 'final sets' file for the requested model

$iftheni.ifGTAP %Model% == GTAP

   put fsetMod ;
   $$batinclude "makeset.gms" GTAP
   putclose fsetMod

$elseifi.ifGTAP %Model% == Env

   put fsetMod ;
   $$batinclude "makeset.gms" Env
   $$batinclude "makesetEnv.gms"
   putclose fsetMod ;

$endif.ifGTAP

* --------------------------------------------------------------------------------------------------
*
*  Aggregate the elasticities for the Env model
*
* --------------------------------------------------------------------------------------------------

$iftheni.ifEnv %Model% == Env

*  Set first param to 1 to override GTAP parameters
*  Set second param to 1 to override GTAP income elasticities

   $$batinclude "aggEnvElast.gms" %OVRRIDEGTAPARM% %OVRRIDEGTAPINC%

*  Prepare special sets file to convert labels in GDX file to final labels
   $$batinclude "makeAggSets.gms"

$ontext
   file fx ;
   scalar jh, status ;
*  Following need to be invoked at the end to do the conversion
   execute.ASync 'gams convertLabel --baseName=%baseName% -pw=150 -ps=9999' ;
   jh = JobHandle ; status = 1 ;
*  put_utility fx 'log' / '>>> JobHandle :' jh;
   while(status = 1,
      status = JobStatus(jh);
*     put_utility fx 'log' / '>>> Status    :' status;
   );
   abort$(status <> 2) '*** Execute.ASync gams... failed: wrong status';
   abort$errorlevel    '*** Execute.ASync gams... failed: wrong errorlevel';
$offtext

   execute 'gams convertLabel --baseName=%baseName% -pw=150 -ps=9999' ;
   abort$errorlevel    '*** Execute gams... failed: wrong errorlevel';

*  Delete temporary labels
*  NEED TO FIX FOR UNIX
*  execute 'del tmpSets.gms'
$iftheni "%OPSYS%" == "UNIX"
   execute 'rm tmpSets.gms'
$elseifi "%OPSYS%" == "DOS"
   execute 'del tmpSets.gms'
$endif

$endif.ifEnv

*  Special data handling for this aggregation

$ifthen.Spc exist "%BaseName%Spc.gms"

   $$include "%BaseName%Spc.gms"

$endif.Spc

* --------------------------------------------------------------------------------------------------
*
*  Calculate the investment targets using the macro model
*
* --------------------------------------------------------------------------------------------------

$iftheni.Macro "%MACRO%" == "ON"

   $$include "macro.gms"

$endif.Macro
