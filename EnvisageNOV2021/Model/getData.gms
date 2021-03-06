* --------------------------------------------------------------------------------------------------
*
*  Load the base SAM from GTAP
*
* --------------------------------------------------------------------------------------------------

$include "miscdat.gms"
alias(i0,j0) ;

parameters

*  From the standard database

   VDFB(i0, a0, r)      "Firm purchases of domestic goods at basic prices"
   VDFP(i0, a0, r)      "Firm purchases of domestic goods at purchaser prices"
   VMFB(i0, a0, r)      "Firm purchases of imported goods at basic prices"
   VMFP(i0, a0, r)      "Firm purchases of domestic goods at purchaser prices"
   VDPB(i0, r)          "Private purchases of domestic goods at basic prices"
   VDPP(i0, r)          "Private purchases of domestic goods at purchaser prices"
   VMPB(i0, r)          "Private purchases of imported goods at basic prices"
   VMPP(i0, r)          "Private purchases of domestic goods at purchaser prices"
   VDGB(i0, r)          "Government purchases of domestic goods at basic prices"
   VDGP(i0, r)          "Government purchases of domestic goods at purchaser prices"
   VMGB(i0, r)          "Government purchases of imported goods at basic prices"
   VMGP(i0, r)          "Government purchases of domestic goods at purchaser prices"
   VDIB(i0, r)          "Investment purchases of domestic goods at basic prices"
   VDIP(i0, r)          "Investment purchases of domestic goods at purchaser prices"
   VMIB(i0, r)          "Investment purchases of imported goods at basic prices"
   VMIP(i0, r)          "Investment purchases of domestic goods at purchaser prices"

   EVFB(fp, a0, r)      "Primary factor purchases at basic prices"
   EVFP(fp, a0, r)      "Primary factor purchases at purchaser prices"
   EVOS(fp, a0, r)      "Factor remuneration after income tax"

   VXSB(i0, r, r)       "Exports at basic prices"
   VFOB(i0, r, r)       "Exports at FOB prices"
   VCIF(i0, r, r)       "Import at CIF prices"
   VMSB(i0, r, r)       "Imports at basic prices"

   VST(i0, r)           "Exports of trade and transport services"
   VTWR(j0, i0, r, r)   "Margins by margin commodity"

   SAVE(r)              "Net saving, by region"
   VDEP(r)              "Capital depreciation"
   VKB(r)               "Capital stock"
   POPG(r)              "GTAP population"

   MAKS(i0,a0,r)        "Make matrix at supply prices"
   MAKB(i0,a0,r)        "Make matrix at basic prices (incl taxes)"
*  PTAX(i0,a0,r)        "Output taxes"

   VNTM(i0, r, rp)      "Non-tariff measures revenue"

   remit00(l,r,rp)      "Initial remittances"
   yqtf0(r)             "Initial outflow of capital income"
   yqht0(r)             "Initial inflow of capital income"

   voa0(a0,r)           "Value of output"
   voa(a,r)             "Value of output"
   osep0(a0,r)          "Value of output subsidies"
   osep(a,r)            "Value of output subsidies"
   cmat(i,k,r)          "Consumer transition matrix"

   empl(l,a0,r)         "Employment levels"

*  Water data

   h2ocrp(a0,r)         "Water withdrawal in crop activities"
   h2oUse(wbnd,r)       "Water withdrawal by aggregate uses"

*  Energy matrices

   nrgdf(i0, a0, r)     "Usage of domestic products by firm, MTOE"
   nrgmf(i0, a0, r)     "Usage of imported products by firm, MTOE"
   nrgdp(i0, r)         "Private usage of domestic products, MTOE"
   nrgmp(i0, r)         "Private usage of imported products, MTOE"
   nrgdg(i0, r)         "Government usage of domestic products, MTOE"
   nrgmg(i0, r)         "Government usage of imported products, MTOE"
   nrgdi(i0, r)         "Investment usage of domestic products, MTOE"
   nrgmi(i0, r)         "Investment usage of imported products, MTOE"
   exi(i0, r, rp)       "Bilateral trade in energy"

   nrgComb(i0, a0, r)   "Energy combustion matrix"

   gwhr0(a0,r)          "Electricity output in gwhr"
   gwhr(r,a)            "Electricity output in gwhr"

*  Carbon emission matrices

   mdf(i0, a0, r)       "Emissions from domestic product in current production, .."
   mmf(i0, a0, r)       "Emissions from imported product in current production, .."
   mdp(i0, r)           "Emissions from private consumption of domestic product, Mt CO2"
   mmp(i0, r)           "Emissions from private consumption of imported product, Mt CO2"
   mdg(i0, r)           "Emissions from govt consumption of domestic product, Mt CO2"
   mmg(i0, r)           "Emissions from govt consumption of imported product, Mt CO2"
   mdi(i0, r)           "Emissions from invt consumption of domestic product, Mt CO2"
   mmi(i0, r)           "Emissions from invt consumption of imported product, Mt CO2"

*  Combustion-based emission matrices

   EMI_IO(em, i0, a0, r)      "IO-based emissions"
   EMI_IOP(em, i0, a0, r)     "IO-based processed emissions"
   EMI_endw(em, fp, a0, r)    "Endowment-based emissions"
   EMI_qo(em, a0, r)          "Output-based emissions"
   EMI_hh(em, i0, r)          "Private consumption-based emissions"
;

execute_load "%BASENAME%Dat.gdx"
   vdfb, vdfp, vmfb, vmfp,
   vdpb, vdpp, vmpb, vmpp,
   vdgb, vdgp, vmgb, vmgp,
   vdib, vdip, vmib, vmip,
   evfb, evfp, evos,
   vxsb, vfob, vcif, vmsb,
   vst, vtwr,
   save, vdep, vkb, popg=pop,
*  ptax,
   maks, makb
;

*  For Comp Stat Overlaypop should always be 0
*  For dynamics, popg = SSP_POP if Overlaypop = 1, else equals GTAP level

if(%OVERLAYPOP% eq 0,
   execute_load "%BASENAME%Dat.gdx" , popg=pop ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Load the satellite file
*
* --------------------------------------------------------------------------------------------------

execute_load "%BASENAME%Sat.gdx"
   nrgComb, h2ocrp, h2oUse
;

* --------------------------------------------------------------------------------------------------
*
*  Load the energy file
*
* --------------------------------------------------------------------------------------------------

execute_load "%BASENAME%Vole.gdx"
   nrgdf=edf, nrgmf=emf,
   nrgdp=edp, nrgmp=emp,
   nrgdg=edg, nrgmg=emg,
   nrgdi=edi, nrgmi=emi,
   exi=exi ;
;

Parameters
   nrgxp0(i0,r)
;

*  Domestic output = domestic sales + exports
nrgxp0(i0,r) = sum(a0, nrgdf(i0,a0,r)) + nrgdp(i0, r) + nrgdg(i0, r)
             +    nrgmi(i0, r) + sum(d, exi(i0, r, d)) ;

*  Convert to gwhr
loop((i0,a0)$sameas(i0,a0),
   gwhr0(a0,r) = emat("MTOE", "gWh") * nrgxp0(i0,r) ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Load the emission files
*
* --------------------------------------------------------------------------------------------------

execute_load "%BASENAME%Emiss.gdx"
   mdf, mmf, mdp,  mmp, mdg, mmg, mdi, mmi ;

$ifthen exist "%BASENAME%NCO2.gdx"

   sets
      AR       "IPPC Reports"
      LU       "Land use categories"
      LUType   "Land use sub-categories"
   ;
   Parameter
      EMI_LU(GHG,LU,LUType,r)    "Land-use based emissions"
      GWP0(GHG, r, ar)
   ;

   $$gdxin "%BASENAME%NCO2.gdx"
   $$load AR, LU, LUType

   execute_loaddc  "%BASENAME%NCO2.gdx",
      GWP0=GWP, EMI_IO, EMI_IOP, EMI_ENDW, EMI_QO, EMI_HH, EMI_LU ;

   ifNCO2 = 1 ;

$else

   EMI_io(em, i0, a0, r)      = 0 ;
   EMI_iop(em, i0, a0, r)     = 0 ;
   EMI_endw(em, fp, a0, r)    = 0 ;
   EMI_qo(em, a0, r)          = 0 ;
   EMI_hh(em, i0, r)          = 0 ;

   ifNCO2 = 0 ;

$endif

* --------------------------------------------------------------------------------------------------
*
*  Load the BoP file
*
* --------------------------------------------------------------------------------------------------

$ifthen exist "%BASENAME%BoP.gdx"

   execute_load "%BASENAME%BoP.gdx"
      remit00=remit, yqtf0=yqtf, yqht0=yqht, ODAIn0=ODAIn, ODAOut0=ODAOut ;

$else

   remit00(l,r,rp) = 0 ;
   yqtf0(r)        = 0 ;
   yqht0(r)        = 0 ;
   ODAIn0(r)       = 0 ;
   ODAOut0(r)      = 0 ;

$endif

* --------------------------------------------------------------------------------------------------
*
*  Load the employment file
*
* --------------------------------------------------------------------------------------------------

$ifthen exist "%BASENAME%Wages.gdx"

   execute_load "%BASENAME%Wages.gdx", empl=q ;

*  !!!! It's possible that the filtering process zeroes out VA in EVFB, but not employment

   empl(l,a0,r)$(evfb(l,a0,r) eq 0) = 0 ;

$else

   empl(l,a0,r) = na ;

$endif

* --------------------------------------------------------------------------------------------------
*
*  Load the NTM file
*
* --------------------------------------------------------------------------------------------------

$iftheni %NTMFlag% == 1

   $$ifthen exist "%BASENAME%NTM.gdx"

      ntmFlag = 1 ;

      execute_load "%BASENAME%NTM.gdx", VNTM ;

   $$else

      ntmFlag = 0 ;

      VNTM(i0, r, rp) = 0 ;

   $$endif

$else

      ntmFlag = 0 ;

      VNTM(i0, r, rp) = 0 ;

$endif

* --------------------------------------------------------------------------------------------------
*
*  Load the embodied emissions coefficients
*  !!!! This needs to be refined
*
* --------------------------------------------------------------------------------------------------

set
   temix "Time scope for emix coefficients"  / 1990*2100 /
   scope "Scope levels for emissions"        / scope1*scope3 /
;

Parameter
   EmiX0(s,i,temix,scope) "Export embodied emissions KgCO2 per $"
;

$ifthen.EmiX exist "%BASENAME%EmiX.gdx"

   execute_loaddc "%BASENAME%EmiX.gdx", EmiX0 = EmiX ;

*  Convert to tons of CO2 emissions per $1 export

   EmiX0(s,i,temix,scope) = 0.001*EmiX0(s,i,temix,scope) ;

$else.Emix

   EmiX0(s,i,temix,scope) = 0 ;

$endif.EmiX

* --------------------------------------------------------------------------------------------------
*
*  MRIO module
*
* --------------------------------------------------------------------------------------------------

set amrio "End-user accounts in MRIO database" /
   INT   "Intermediate demand"
   CONS  "Private and public demand"
   CGDS  "Investment demand"
/ ;

Parameter
   VIUMS0(i0,amrio,s,d)    "Value of imports by end-user, tariff-inclusive"
   VIUWS0(i0,amrio,s,d)    "Value of imports by end-user, at border prices"
   VIUMS(i,amrio,s,d)      "Value of imports by end-user, tariff-inclusive"
   VIUWS(i,amrio,s,d)      "Value of imports by end-user, at border prices"
   max1
   max2
   max3
   max4
   max5
   mtaxa00(i0, amrio,s,d)
;


VIUMS(i,amrio,s,d) = 0 ;
VIUWS(i,amrio,s,d) = 0 ;

alias(amrio, aaa) ; alias(aa0,a0) ;
set mrioIter / mrioi1*mrioi50 / ;
put screen ; put / ;

if(MRIO,

   $$ifthen exist "%BASENAME%MRIO.gdx"

*     Get the MRIO data

      execute_load "%BASENAME%MRIO.gdx", viums0=viums, viuws0=viuws ;

*     Verify consistency
*     !!!! Maybe add some tolerance checks !!!!

      if(0,
      mtaxa00(i0,amrio,s,d) = (VIUMS0(i0,amrio,s,d)/VIUWS0(i0,amrio,s,d))$VIUWS0(i0,amrio,s,d) + 1$(not VIUWS0(i0,amrio,s,d)) ;

      loop(mrioIter,

         max1 = smax((i0,s,d), abs(sum(aaa,VIUWS0(i0,aaa,s,d)) - VCIF(i0,s,d))) ;
         max2 = smax((i0,s,d), abs(sum(aaa,VIUMS0(i0,aaa,s,d)) - VMSB(i0,s,d))) ;
         put "MAX1 = ", max1:15:6, " MAX2 = ", max2:15:6 / ;

         if(1,
            VIUWS0(i0,amrio,s,d)$sum(aaa,VIUWS0(i0,aaa,s,d)) =
               VIUWS0(i0,amrio,s,d)*VCIF(i0,s,d) / sum(aaa,VIUWS0(i0,aaa,s,d)) ;
            VIUMS0(i0,amrio,s,d)$sum(aaa,VIUMS0(i0,aaa,s,d)) =
               VIUMS0(i0,amrio,s,d)*VMSB(i0,s,d) / sum(aaa,VIUMS0(i0,aaa,s,d)) ;
         ) ;

         max1 = smax((i0,s,d), abs(sum(aaa,VIUWS0(i0,aaa,s,d)) - VCIF(i0,s,d))) ;
         max2 = smax((i0,s,d), abs(sum(aaa,VIUMS0(i0,aaa,s,d)) - VMSB(i0,s,d))) ;

         put "MAX1 = ", max1:15:6, " MAX2 = ", max2:15:6 / ;

         max3 = smax((i0,d), abs(sum(aa0,VMFB(i0,aa0,d)) - sum(s, VIUMS0(i0,"INT",s,d)))) ;
         put "MAX3 = ", max3:15:6 / ;
         VIUMS0(i0,"INT",s,d)$sum(r,VIUMS0(i0,"INT",r,d))
            = VIUMS0(i0,"INT",s,d)*sum(a0, VMFB(i0,a0,d))/sum(r,VIUMS0(i0,"INT",r,d)) ;

         max3 = smax((i0,d), abs(sum(aa0,VMFB(i0,aa0,d)) - sum(s, VIUMS0(i0,"INT",s,d)))) ;
         put "MAX3 = ", max3:15:6 / ;

         max4 = smax((i0,d), abs(VMPB(i0,d)+VMGB(i0,d) - sum(s, VIUMS0(i0,"CONS",s,d)))) ;
         put "MAX4 = ", max4:15:6 / ;
         VIUMS0(i0,"CONS",s,d)$sum(r,VIUMS0(i0,"CONS",r,d))
            = VIUMS0(i0,"CONS",s,d)*(VMPB(i0,d)+VMGB(i0,d))/sum(r,VIUMS0(i0,"CONS",r,d)) ;

         max4 = smax((i0,d), abs(VMPB(i0,d)+VMGB(i0,d) - sum(s, VIUMS0(i0,"CONS",s,d)))) ;
         put "MAX4 = ", max4:15:6 / ;

         max5 = smax((i0,d), abs(VMIB(i0,d) - sum(s, VIUMS0(i0,"CGDS",s,d)))) ;
         put "MAX5 = ", max5:15:6 / ;
         VIUMS0(i0,"CGDS",s,d)$sum(r,VIUMS0(i0,"CGDS",r,d))
            = VIUMS0(i0,"CGDS",s,d)*VMIB(i0,d)/sum(r,VIUMS0(i0,"CGDS",r,d)) ;

         max5 = smax((i0,d), abs(VMIB(i0,d) - sum(s, VIUMS0(i0,"CGDS",s,d)))) ;
         put "MAX5 = ", max5:15:6 / ;

         if(ord(mrioiter) eq 1, VIUWS0(i0,amrio,s,d) = VIUMS0(i0,amrio,s,d)/mtaxa00(i0,amrio,s,d) ;) ;

         max1 = smax((i0,s,d), abs(sum(aaa,VIUWS0(i0,aaa,s,d)) - VCIF(i0,s,d))) ;
         max2 = smax((i0,s,d), abs(sum(aaa,VIUMS0(i0,aaa,s,d)) - VMSB(i0,s,d))) ;
         put "MAX1 = ", max1:15:6, " MAX2 = ", max2:15:6 / ;
      ) ;

      abort "Temp" ;
      ) ;
   $$endif
) ;

$iftheni.ifDEPL "%DEPL_MODULE%" == "ON"

* --------------------------------------------------------------------------------------------------
*
*  Initialize depletion module
*
* --------------------------------------------------------------------------------------------------

Parameters
   extraction(r,a0)      "Base year extraction"
   reserves(r,a0,pt)     "Base year proven reserves"
   ytdreserves(r,a0,pt)  "Base year unproven reserves"
   r_p(r,a0,pt)          "Base year reserve to production ratio"
;

   $$ifthen.ifFile exist "%BASENAME%DEPL.gdx"

      execute_load "%BASENAME%DEPL.gdx", extraction, reserves, ytdreserves, r_p ;

   $$else.ifFile

      extraction(r,a0)     = 0 ;
      reserves(r,a0,pt)    = 0 ;
      ytdreserves(r,a0,pt) = 0 ;
      r_p(r,a0,pt)         = 0 ;

      put screen ; put / ;
      put ">>>>> ERROR: Requested depletion module, but data file not loaded:" / ;
      put ">>>>>        ", "%BASENAME%DEPL.gdx" / ;
      Abort "Temp" ;

   $$endif.ifFile

$endif.ifDEPL

$iftheni "%RD_MODULE%" == "ON"

* --------------------------------------------------------------------------------------------------
*
*  Initialize R&D module
*
* --------------------------------------------------------------------------------------------------

   Parameter
      VDRB(i0, r)          "R&D purchases of domestic goods at basic prices"
      VDRP(i0, r)          "R&D purchases of domestic goods at purchaser prices"
      VMRB(i0, r)          "R&D purchases of imported goods at basic prices"
      VMRP(i0, r)          "R&D purchases of domestic goods at purchaser prices"
      rdShr0(r)            "Initial share of R&D in government expenditures"
   ;

*  Do we have data for R&D costs

   $$ifthen exist "%BASENAME%R_D.gdx"

      execute_load "%BASENAME%R_D.gdx", VDRB, VDRP, VMRB, VMRP ;

   $$else

*     Assume same cost structure as for government expenditures

      gdpmp0(r) = sum(i0, VDPP(i0,r) + VMPP(i0,r)
                +         VDGP(i0,r) + VMGP(i0,r)
                +         VDIP(i0,r) + VMIP(i0,r)
                +         VST(i0,r)
                +  sum(d, VFOB(i0,r,d)) - sum(s, VCIF(i0,s,r))) ;
*     display gdpmp0 ; abort "Temp" ;

      rdShr0(r) = 0.01*KnowledgeData0(r,"rd0")*gdpmp0(r)
                / sum(i0, VDGP(i0,r) + VMGP(i0,r)) ;

*     display rdShr0 ; abort "Temp" ;

      vdrb(i0,r) = rdshr0(r)*vdgb(i0,r) ;
      vdrp(i0,r) = rdshr0(r)*vdgp(i0,r) ;
      vmrb(i0,r) = rdshr0(r)*vmgb(i0,r) ;
      vmrp(i0,r) = rdshr0(r)*vmgp(i0,r) ;

   $$endif

*  Subtract R&D from government expenditures

   vdgb(i0,r) = vdgb(i0,r) - vdrb(i0,r) ;
   vdgp(i0,r) = vdgp(i0,r) - vdrp(i0,r) ;
   vmgb(i0,r) = vmgb(i0,r) - vmrb(i0,r) ;
   vmgp(i0,r) = vmgp(i0,r) - vmrp(i0,r) ;

*  display vdrb ;

*  Adjust energy/emissions tables

   Parameters

*     Energy

      nrgdr(i0,r)          "R&D usage of domestic products, MTOE"
      nrgmr(i0,r)          "R&D usage of domestic products, MTOE"

*     Carbon emission matrices

      mdr(i0, r)           "Emissions from R&D of domestic product, Mt CO2"
      mmr(i0, r)           "Emissions from R&D of imported product, Mt CO2"
   ;

   nrgdr(i0,r) = vdgb(i0,r)+vdrb(i0,r) ;
   nrgdr(i0,r)$nrgdr(i0,r) = nrgdg(i0,r)*(vdrb(i0,r)/nrgdr(i0,r)) ;
   nrgdg(i0,r) = nrgdg(i0,r) - nrgdr(i0,r) ;

   nrgmr(i0,r) = vmgb(i0,r)+vmrb(i0,r) ;
   nrgmr(i0,r)$nrgmr(i0,r) = nrgmg(i0,r)*(vmrb(i0,r)/nrgmr(i0,r)) ;
   nrgmg(i0,r) = nrgmg(i0,r) - nrgmr(i0,r) ;

   mdr(i0,r) = nrgdg(i0,r)+nrgdr(i0,r) ;
   mdr(i0,r)$mdr(i0,r) = mdg(i0,r)*(nrgdr(i0,r)/mdr(i0,r)) ;
   mdg(i0,r) = mdg(i0,r) - mdr(i0,r) ;

   mmr(i0,r) = nrgmg(i0,r)+nrgmr(i0,r) ;
   mmr(i0,r)$mmr(i0,r) = mmg(i0,r)*(nrgmr(i0,r)/mmr(i0,r)) ;
   mmg(i0,r) = mmg(i0,r) - mmr(i0,r) ;

$endif

$iftheni "%IFI_MODULE%" == "ON"

* --------------------------------------------------------------------------------------------------
*
*  Initialize IFI module
*
* --------------------------------------------------------------------------------------------------

   Parameter
      VDDB(i0, r)          "IFI purchases of domestic goods at basic prices"
      VDDP(i0, r)          "IFI purchases of domestic goods at purchaser prices"
      VMDB(i0, r)          "IFI purchases of imported goods at basic prices"
      VMDP(i0, r)          "IFI purchases of domestic goods at purchaser prices"
      VIUMSD0(i0, r, s)    "Source of IFI import purchases at tariff inclusive prices"
      VIUWSD0(i0, r, s)    "Source of IFI import purchases at CIF prices"
      VIUMSD(i, r, s)      "Source of IFI import purchases at tariff inclusive prices"
      VIUWSD(i, r, s)      "Source of IFI import purchases at CIF prices"
      YFDWFP0(r)           "Initial WFP expenditures"
      YFDWFP(r)            "Data-base WFP expenditures"
      ddShr0(r)            "Initial share of IFI in government expenditures"
   ;

*  Do we have data for IFI costs

   $$ifthen exist "%BASENAME%IFI.gdx"

      execute_load "%BASENAME%IFI.gdx", VDDB, VDDP, VMDB, VMDP, VIUMSD0=VIUMSD, VIUWSD0=VIUWSD, YFDWFP0 ;
      YFDWFP(r) = sum(i0, VDDP(i0,r) + VMDP(i0,r)) ;

*     Rescale

      VDDB(i0,r)$YFDWFP(r) = VDDB(i0,r)*YFDWFP0(r)/YFDWFP(r) ;
      VDDP(i0,r)$YFDWFP(r) = VDDP(i0,r)*YFDWFP0(r)/YFDWFP(r) ;
      VMDB(i0,r)$YFDWFP(r) = VMDB(i0,r)*YFDWFP0(r)/YFDWFP(r) ;
      VMDP(i0,r)$YFDWFP(r) = VMDP(i0,r)*YFDWFP0(r)/YFDWFP(r) ;
      VIUMSD0(i0,s,r)$YFDWFP(r) = VIUMSD0(i0,s,r)*YFDWFP0(r)/YFDWFP(r) ;
      VIUWSD0(i0,s,r)$YFDWFP(r) = VIUWSD0(i0,s,r)*YFDWFP0(r)/YFDWFP(r) ;
      ifiin0(r)  = inscale*YFDWFP0(r) ;

   $$else

*     Assume same cost structure as for government expenditures

      gdpmp0(r) = sum(i0, VDPP(i0,r) + VMPP(i0,r)
                +         VDGP(i0,r) + VMGP(i0,r)
                +         VDIP(i0,r) + VMIP(i0,r)
                +         VST(i0,r)
                +  sum(d, VFOB(i0,r,d)) - sum(s, VCIF(i0,s,r))) ;

      ddShr0(r) = 0.01*IFIData0(r,"ifi0")*gdpmp0(r)
                / sum(i0, VDGP(i0,r) + VMGP(i0,r)) ;

      if(0,
         display gdpmp0, ddShr0 ;
         abort "Temp" ;
      ) ;

      vmdb(i0,r) = ddshr0(r)*vdgb(i0,r) ;
      vmdp(i0,r) = ddshr0(r)*vdgp(i0,r) ;
      vddb(i0,r) = ddshr0(r)*vmgb(i0,r) ;
      vddp(i0,r) = ddshr0(r)*vmgp(i0,r) ;
      ifiin0(r) = inscale * sum(i0, vddp(i0,r) + vmdp(i0,r)) ;

   $$endif

   ifiout0(r) = 0.01*IFIData0(r,"ifiOut0") * sum(d, ifiin0(d)) ;

*  Subtract IFI from government expenditures

   if(0,
      vdgb(i0,r) = vdgb(i0,r) - vddb(i0,r) ;
      vdgp(i0,r) = vdgp(i0,r) - vddp(i0,r) ;
      vmgb(i0,r) = vmgb(i0,r) - vmdb(i0,r) ;
      vmgp(i0,r) = vmgp(i0,r) - vmdp(i0,r) ;
   ) ;

*  display vdrb ;

*  Adjust energy/emissions tables

   Parameters

*     Energy

      nrgdd(i0,r)          "IFI usage of domestic products, MTOE"
      nrgmd(i0,r)          "IFI usage of domestic products, MTOE"

*     Carbon emission matrices

      mdd(i0, r)           "Emissions from IFI of domestic product, Mt CO2"
      mmd(i0, r)           "Emissions from IFI of imported product, Mt CO2"
   ;

   nrgdd(i0,r) = vdgb(i0,r)+vddb(i0,r) ;
   nrgdd(i0,r)$nrgdd(i0,r) = nrgdg(i0,r)*(vddb(i0,r)/nrgdd(i0,r)) ;
   if(0,
      nrgdg(i0,r) = nrgdg(i0,r) - nrgdd(i0,r) ;
   ) ;

   nrgmd(i0,r) = vmgb(i0,r)+vmdb(i0,r) ;
   nrgmd(i0,r)$nrgmd(i0,r) = nrgmg(i0,r)*(vmdb(i0,r)/nrgmd(i0,r)) ;
   if(0,
      nrgmg(i0,r) = nrgmg(i0,r) - nrgmd(i0,r) ;
   ) ;

   mdd(i0,r) = nrgdg(i0,r)+nrgdd(i0,r) ;
   mdd(i0,r)$mdd(i0,r) = mdg(i0,r)*(nrgdd(i0,r)/mdd(i0,r)) ;
   if(0,
      mdg(i0,r) = mdg(i0,r) - mdd(i0,r) ;
   ) ;

   mmd(i0,r) = nrgmg(i0,r)+nrgmd(i0,r) ;
   mmd(i0,r)$mmd(i0,r) = mmg(i0,r)*(nrgmd(i0,r)/mmd(i0,r)) ;
   if(0,
      mmg(i0,r) = mmg(i0,r) - mmd(i0,r) ;
   ) ;

$endif
