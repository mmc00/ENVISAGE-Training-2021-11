$setGlobal DIAG      ON
$setGlobal DYN       ON
$setGlobal MACRO     ON
$setGlobal ifPower   ON
$setGlobal ifBKSTOP  OFF
$setGlobal ifWater   OFF
$setGlobal NCO2      ON
$setGlobal ELAST     OFF
$setGlobal LAB       ON
$setGlobal BoP       ON
$setGlobal LU        OFF
$setGlobal SAVEMAP   TXT
$setGlobal ifMRIO    OFF
$setGlobal ifR_D     ON
$setGlobal DEPL      ON
$setGlobal ifGENDER  OFF

*  Only used to override GTAP parameters for Env model

$setGlobal OVRRIDEGTAPARM 1
$setGlobal OVRRIDEGTAPINC 1

*  Select a labor option
*  Valid options are:
*     noLab  -- ignore employment volumes (all wages are set to 1)
*     agLab  -- calculate ag and non-ag employment (wages uniform within zones)
*     allLab -- assume employment data is correct for each sector (wages differ for each sector)
*     giddLab -- Use the GIDD labor data

$macro IFLABOR noLab

$include "GTAPSets10APOWF.gms"

$setGlobal gtpDir    "../GTAP10POW"
* Andre modified this line to use a relative path

$setGlobal GTAPBASE  "GSDF"
$setGlobal SSPFile   "../SatAcct/sspScenV9_2.gdx"
$setGLobal DEPLFile  "../SatAcct/RystadGTAP2014.gdx"
$setGlobal giddLab   "../SatAcct/giddLab.gdx"
$setGlobal giddProj  "../SatAcct/giddProj.gdx"
$setGlobal EnvElast  "../SatAcct/EnvLinkElast10APOW.gdx"

$onempty

sets

   i  "Commodities"   /
         AGR          "Agriculture"
         FRS          "Forestry"
         COA          "Coal"
         OIL          "Oil"
         GAS          "Gas"
         OXT          "Minerals nec"
         EIT          "Vegetable oils and fats"
         XMN          "Dairy products"
         P_C          "Petroleum and coal products"
         ETD          "Electricity transmission"
         CLP          "Coal-fired power"
         OLP          "Oil-fired power"
         GSP          "Gas-fired power"
         NUC          "Nuclear power"
         HYD          "Hydro power"
         SOL          "Solar power"
         WND          "Wind power"
         XEL          "Other power"
         SRV          "Services"
      /

   r  "Regions" /
         USA          "United States"
         EUR          "Western Europe"
         XOE          "Other HIY OECD"
         CHN          "China"
         RUS          "Russia"
         OPC          "Major oil and gas exporters"
         XEA          "Rest of East Asia and Pacific"
         SAS          "South Asia"
         XLC          "Rest of Latin America & Caribbean"
         ROW          "Rest of the World"
      /

   fp  "Factors of production"  /
      nsk            "Unskilled labor"
      skl            "Skilled labor"
      cap            "Capital"
      lnd            "Land"
      nrs            "Natural resource"
      /

   l(fp)  "Labor factors" /
      nsk            "Unskilled labor"
      skl            "Skilled labor"
      /
   wb "Intermediate labor bundle(s)" /
      Single         "Single intermediate labor bundle"
   /
   maplab1(wb) "Mapping of intermediate labor demand bundle(s) to LAB1" /
      Single
   /
   mapl(wb,l) "Mapping of labor categories to intermedate demand bundle(s)" /
      Single.(nsk, skl)
   /
   lr(l) "Reference labor for skill premium" /
      skl            "Skilled labor"
      /
   cap(fp) "Capital" /
      cap            "Capital"
      /
   lnd(fp) "Land endowment" /
      lnd            "Land"
      /
   nrs(fp) "Natural resource" /
      nrs            "Natural resource"
      /
   wat(fp) "Water resource" / /

   ra "Aggregate regions for emission regimes and model output" /
      hic   "High-income countries"
      lmy   "Developing countries"
      wld   "World Total"
      /
   ia "Aggregate commodities for model output" /
      tagr-c      "Agriculture"
      tman-c      "Manufacturing"
      tsrv-c      "Services"
      toth-c      "Other"
      ttot-c      "Total"
      /
   aga  "Aggregate activities for model output" /
      tagr-a      "Agriculture"
      tman-a      "Manufacturing"
      tsrv-a      "Services"
      toth-a      "Other"
      ttot-a      "Total"
      /
   lagg "Aggregate labor for model output" /
      tot         "Total labor"
      /
;

*  !!!! Explicit assumption about diagonality

alias(i,a) ;

alias(m,i) ;

*  User defined parameters (i.e. not aggregated by aggregation facility)
*  NEW -- New region specific

Parameter
   etrae1(fp,r) "CET transformation elasticities for factor allocation"
;

parameter etrae0(fp) "CET transformation elasticities for factor allocation" /
   nsk       inf
   skl       inf
   cap       inf
   lnd       1.0
   nrs      0.001
/ ;

etrae1(fp,r) = etrae0(fp) ;

*  NEW -- MAKE ELASTICITIES

Parameter
   etraq1(a,r)       "MAKE CET Elasticity"
   esubq1(i,r)       "MAKE CES Elasticity"
;
etraq1(a,r) = 5 ;
esubq1(i,r) = inf ;

*  NEW -- EXPENDITURE ELASTICITIES

Parameter
   esubg1(r)         "Government expenditure CES elasticity"
   esubi1(r)         "Investment expenditure CES elasticity"
   esubs1(m)         "Transport margins CES elasticity"
;

esubg1(r) = 1 ;
esubi1(r) = 0 ;
esubs1(m) = 1 ;

*  This zonal mapping is for labor/volume splits between agriculture and other

set mapz(z,a)  "Mapping of activities to zones" /
   rur.(agr)
/ ;

mapz("urb",a) = not mapz("rur",a) ;
mapz("nsg",a) = yes ;

* >>>> MUST INSERT RESIDUAL REGION (ONLY ONE)

set rres(r) "Residual region" /

   USA

/ ;

* >>>> MUST INSERT MUV REGIONS (ONE OR MORE)

set rmuv(r) "MUV regions" /
   USA
   EUR
   XOE
   CHN
/ ;

set mapt(a) "Merge land and capital payments in the following sectors" /

/ ;

set mapn(a) "Merge natl. res. and capital payments in the following sectors" /
   xmn
/ ;

*  MAPPINGS TO GTAP

set mapa(acts,a) /
   PDR.AGR
   WHT.AGR
   GRO.AGR
   V_F.AGR
   OSD.AGR
   C_B.AGR
   PFB.AGR
   OCR.AGR
   CTL.AGR
   OAP.AGR
   RMK.AGR
   WOL.AGR
   FRS.FRS
   FSH.XMN
   COA.COA
   OIL.OIL
   GAS.GAS
   OXT.OXT
   CMT.XMN
   OMT.XMN
   VOL.XMN
   MIL.XMN
   PCR.XMN
   SGR.XMN
   OFD.XMN
   B_T.XMN
   TEX.XMN
   WAP.XMN
   LEA.XMN
   LUM.XMN
   PPP.EIT
   P_C.P_C
   CHM.EIT
   BPH.XMN
   RPP.EIT
   NMM.EIT
   I_S.EIT
   NFM.EIT
   FMP.XMN
   MVH.XMN
   OTN.XMN
   ELE.XMN
   EEQ.XMN
   OME.XMN
   OMF.XMN
   TND.ETD
   NUCLEARBL.NUC
   COALBL.CLP
   GASBL.GSP
   WINDBL.WND
   HYDROBL.HYD
   OILBL.OLP
   OTHERBL.XEL
   GASP.GSP
   HYDROP.HYD
   OILP.OLP
   SOLARP.SOL
   GDT.GAS
   WTR.SRV
   CNS.SRV
   TRD.SRV
   AFS.SRV
   OTP.SRV
   WTP.SRV
   ATP.SRV
   WHS.SRV
   CMN.SRV
   OFI.SRV
   INS.SRV
   RSA.SRV
   OBS.SRV
   ROS.SRV
   OSG.SRV
   EDU.SRV
   HHT.SRV
   DWE.SRV
/ ;

$iftheni "%DIAG%" == ON
   set mapi(comm,i) ;
   loop((acts,comm)$sameas(acts,comm),
      mapi(comm,i) = mapa(acts,i) ;
   ) ;
$endif

set mapr(reg,r) /
   AUS.XOE
   NZL.XOE
   XOC.XEA
   CHN.CHN
   HKG.XEA
   JPN.XOE
   KOR.XOE
   MNG.XEA
   TWN.XEA
   XEA.XEA
   BRN.XEA
   KHM.XEA
   IDN.XEA
   LAO.XEA
   MYS.XEA
   PHL.XEA
   SGP.XEA
   THA.XEA
   VNM.XEA
   XSE.XEA
   BGD.SAS
   IND.SAS
   NPL.SAS
   PAK.SAS
   LKA.SAS
   XSA.SAS
   CAN.XOE
   USA.USA
   MEX.XLC
   XNA.XLC
   ARG.XLC
   BOL.XLC
   BRA.OPC
   CHL.XLC
   COL.XLC
   ECU.XLC
   PRY.XLC
   PER.XLC
   URY.XLC
   VEN.OPC
   XSM.XLC
   CRI.XLC
   GTM.XLC
   HND.XLC
   NIC.XLC
   PAN.XLC
   SLV.XLC
   XCA.XLC
   DOM.XLC
   JAM.XLC
   PRI.XLC
   TTO.XLC
   XCB.XLC
   AUT.EUR
   BEL.EUR
   CYP.EUR
   CZE.EUR
   DNK.EUR
   EST.EUR
   FIN.EUR
   FRA.EUR
   DEU.EUR
   GRC.EUR
   HUN.EUR
   IRL.EUR
   ITA.EUR
   LVA.EUR
   LTU.EUR
   LUX.EUR
   MLT.EUR
   NLD.EUR
   POL.EUR
   PRT.EUR
   SVK.EUR
   SVN.EUR
   ESP.EUR
   SWE.EUR
   GBR.EUR
   CHE.EUR
   NOR.EUR
   XEF.EUR
   ALB.ROW
   BGR.ROW
   BLR.ROW
   HRV.ROW
   ROU.ROW
   RUS.RUS
   UKR.ROW
   XEE.ROW
   XER.ROW
   KAZ.OPC
   KGZ.ROW
   TJK.ROW
   XSU.ROW
   ARM.ROW
   AZE.ROW
   GEO.ROW
   BHR.OPC
   IRN.OPC
   ISR.ROW
   JOR.ROW
   KWT.OPC
   OMN.OPC
   QAT.OPC
   SAU.OPC
   TUR.ROW
   ARE.OPC
   XWS.OPC
   EGY.ROW
   MAR.ROW
   TUN.ROW
   XNF.OPC
   BEN.ROW
   BFA.ROW
   CMR.ROW
   CIV.ROW
   GHA.ROW
   GIN.ROW
   NGA.OPC
   SEN.ROW
   TGO.ROW
   XWF.ROW
   XCF.ROW
   XAC.OPC
   ETH.ROW
   KEN.ROW
   MDG.ROW
   MWI.ROW
   MUS.ROW
   MOZ.ROW
   RWA.ROW
   TZA.ROW
   UGA.ROW
   ZMB.ROW
   ZWE.ROW
   XEC.ROW
   BWA.ROW
   NAM.ROW
   ZAF.ROW
   XSC.ROW
   XTW.ROW
/ ;

set mapf(endw, fp) /
   ag_othlowsk  . nsk
   service_shop . nsk
   clerks       . nsk
   tech_aspros  . skl
   off_mgr_pros . skl
   Capital      . cap
   Land         . lnd
   NatlRes      . nrs
*  Water        . lnd
/ ;

set maplGIDD(lg, l) "Mapping to GIDD labor database" /
   nsk.(nsk)
   skl.(skl)
/ ;

* ----------------------------------------------------------------------------------------
*
*     Section dealing with model aggregations (to handle non-diagonal make matrix)
*
* ----------------------------------------------------------------------------------------

*  Model aggregation(s)

set actf "Model activities" /
         sets.i
/ ;

set commf "Model commodities" /
         AGR          "Agriculture"
         FRS          "Forestry"
         COA          "Coal"
         OIL          "Oil"
         GAS          "Gas"
         OXT          "Minerals nec"
         EIT          "Vegetable oils and fats"
         XMN          "Dairy products"
         P_C          "Petroleum and coal products"
         ELY          "Electricity"
         SRV          "Services"
/ ;

set mapaf(i, actf) "Mapping from original to modeled activities" /
     AGR.AGR
     FRS.FRS
     COA.COA
     OIL.OIL
     GAS.GAS
     OXT.OXT
     EIT.EIT
     XMN.XMN
     P_C.P_C
     ETD.ETD
     CLP.CLP
     OLP.OLP
     GSP.GSP
     NUC.NUC
     HYD.HYD
     SOL.SOL
     WND.WND
     XEL.XEL
     SRV.SRV
/ ;

set mapif(i, commf) "Mapping from original to modeled commodities" /
     AGR.AGR
     FRS.FRS
     COA.COA
     OIL.OIL
     GAS.GAS
     OXT.OXT
     EIT.EIT
     XMN.XMN
     P_C.P_C
     ETD.ELY
     CLP.ELY
     OLP.ELY
     GSP.ELY
     NUC.ELY
     HYD.ELY
     SOL.ELY
     WND.ELY
     XEL.ELY
     SRV.SRV
/ ;

* >>>> MUST INSERT MUV COMMODITIES (ONE OR MORE)
*      !!!! Be careful of compatibility with modeled imuv
*           This one is intended for AlterTax

set imuvf(commf) "MUV commodities" /
   eit, xmn
/ ;

*  >>>> Aggregation of modeled sectors and regions

set mapia(ia,commf)"mapping of individual comm to aggregate comm" /
     tagr-c.agr
     tagr-c.frs
     toth-c.coa
     toth-c.oil
     toth-c.gas
     toth-c.oxt
     tman-c.xmn
     tman-c.p_c
     tman-c.eit
     tsrv-c.ely
     tsrv-c.srv
/ ;
mapia("ttot-c",commf) = yes ;

set mapaga(aga,actf)"mapping of individual comm to aggregate activities" /
     tagr-a.agr
     tagr-a.frs
     toth-a.coa
     toth-a.oil
     toth-a.gas
     toth-a.oxt
     tman-a.xmn
     tman-a.p_c
     tman-a.eit
     tsrv-a.etd
     tsrv-a.nuc
     tsrv-a.clp
     tsrv-a.gsp
     tsrv-a.wnd
     tsrv-a.hyd
     tsrv-a.olp
     tsrv-a.xel
     tsrv-a.sol
     tsrv-a.srv
/ ;
mapaga("ttot-a",actf) = yes ;

set mapra(ra,r) "Mapping of model regions to aggregate regions" /
   hic.(USA, EUR, XOE)
/ ;
mapra("lmy", r)$(not mapra("hic",r)) = yes ;
mapra("wld", r) = yes ;
mapra(ra,r)$sameas(ra,r) = yes ;

*  If none, just use 'all'. The mapping for 'All' will be done automatically.
*  Here the user can only input the activity subset of agents as the
*  aggregation facility is unaware of Armington agents

set
   aets "Agent specific ETS definitions" /
      All      "ALL agents"
   /
   aa   "Armington agents" / sets.actf, sets.fd /
   mapets(aets,aa)
;
mapets("all",aa) = yes;

set maplagg(lagg,l) "Mapping of model labor to aggregate labor" ;
maplagg("Tot",l) = yes ;

set sortOrder / sort1*sort500 / ;
set mapRegSort(sortOrder,r) /
   Sort1  . USA
   Sort2  . EUR
   Sort3  . XOE
   Sort4  . CHN
   Sort5  . RUS
   Sort6  . OPC
   Sort7  . XEA
   Sort8  . SAS
   Sort9  . XLC
   Sort10 . ROW
/ ;

set mapActSort(sortOrder,actf) /
   Sort1  . AGR
   Sort2  . FRS
   Sort3  . COA
   Sort4  . OIL
   Sort5  . GAS
   Sort6  . OXT
   Sort7  . EIT
   Sort8  . XMN
   Sort9  . P_C
   Sort10 . ETD
   Sort11 . CLP
   Sort12 . OLP
   Sort13 . GSP
   Sort14 . NUC
   Sort15 . HYD
   Sort16 . SOL
   Sort17 . WND
   Sort18 . XEL
   Sort19 . SRV
/ ;

set mapCommSort(sortOrder,commf) /
   Sort1  . AGR
   Sort2  . FRS
   Sort3  . COA
   Sort4  . OIL
   Sort5  . GAS
   Sort6  . OXT
   Sort7  . EIT
   Sort8  . XMN
   Sort9  . P_C
   Sort10 . ELY
   Sort11 . SRV
/ ;

* ----------------------------------------------------------------------------------------
*
*     Envisage section
*
* ----------------------------------------------------------------------------------------

*  >>>> Activity related sets and subsets

set acr(actf)  "Crop activities" /
/ ;

set alv(actf)  "Livestock activities" /
/ ;

set agr(actf)  "Agricultural activities" /
   agr
/ ;

set man(actf)  "Manufacturing activities" /
     xmn
     eit
/ ;

set aenergy(actf) "Energy activities" /
      coa
      oil
      gas
      p_c
      clp
      olp
      gsp
      nuc
      hyd
      wnd
      sol
      xel
      etd
/ ;

set affl(actf) "Fossil fuel activities" /
      coa
      oil
      gas
/ ;

set aw(actf)   "Water services activities" /
/ ;

set elya(actf) "Power activities" /
      clp
      olp
      gsp
      nuc
      hyd
      wnd
      sol
      xel
      etd
/ ;

set etd(actf)  "Electricity transmission and distribution activities" /
      etd
/ ;

set primElya(actf) "Primary power activities" /
      nuc
      hyd
      wnd
      sol
      xel
/ ;

set pb   "Power bundles" /
   coap       "Coal bundle"
   oilp       "Oil bundle"
   gasp       "Gas bundle"
   nucp       "Nuclear"
   hydp       "Hydro"
   renp       "Renewables"
/ ;

set mappow(pb,elya) "Mapping of power activities to power bundles" /
   nucp    .NUC
   hydp    .HYD
   renp    .WND
   renp    .SOL
   renp    .XEL
   coap    .CLP
   oilp    .OLP
   gasp    .GSP
/ ;

*  >>>> Commodity sets and subsets

set frt(commf) "Fertilizer commodities" /
/ ;

set feed(commf) "Feed commodities" /
/ ;

set iw(commf) "Water services commodities" /
/ ;

set e(commf) "Energy commodities" /
      coa
      oil
      gas
      p_c
      ely
/ ;

set elyc(commf) "Electricity commodities" /
      ely
/ ;

set f(commf) "Fuel commodities" /
      coa
      oil
      gas
      p_c
/ ;

*  This zonal mapping is for labor market segmentation in final model

set mapzf(z,actf)  "Mapping of activities to zones" /
     rur.agr
/ ;

mapzf("urb",actf) = not mapzf("rur",actf) ;
mapzf("nsg",actf) = yes ;

* >>>> Household commodity section

set k "Household commodities" /
         agr          "Agriculture"
         nrg          "Energy"
         oxt          "Minerals nec"
         xmn          "Other manufacturing"
         eit          "Energy intensive goods"
         srv          "Services"
/ ;

set fud(k) "Household food commodities" /
         agr          "Agriculture"
/ ;

set mapk(commf,k) "Mapping from i to k" /
     agr.agr
     frs.oxt
     coa.nrg
     oil.nrg
     gas.nrg
     oxt.oxt
     xmn.xmn
     p_c.nrg
     eit.eit
     ely.nrg
     srv.srv
/ ;

set cpindx  "CPI indices to be derived by the model" /
   tot      "Total price index"
/ ;

set mapCPI(cpindx,commf)   "Mapping from i to CPI index" ;
mapCPI("tot",commf)              = yes ;

set lb "Land bundles" /
   agr      "Agriculture"
/ ;

set lb1(lb) "First land bundle" /
   agr      "Agriculture"
/ ;

set maplb(lb,actf) "Mapping of activities to land bundles" /
     agr.agr
/ ;

*  !!!! TO BE REVIEWED

set lb0   "Default land bundles" / lb1 / ;
set maplb0(lb, lb0) "Mapping of land bundles to original" /
   agr.lb1
/ ;

set wbnd "Aggregate water markets" /
   N_A         "N_A"
/ ;

set wbnd1(wbnd) "Top level water markets" /
/ ;

set wbnd2(wbnd) "Second level water markets" /
/ ;

set wbndEx(wbnd) "Exogenous water markets" /
/ ;

set mapw1(wbnd,wbnd) "Mapping of first level water bundles" /
/ ;

set mapw2(wbnd,actf) "Mapping of second level water bundle" /
/ ;

set wbnda(wbnd) "Water bundles mapped one-to-one to activities" /
/ ;

set wbndi(wbnd) "Water bundles mapped to aggregate output" /
/ ;

set NRG "Energy bundles used in model" /
   coa         "Coal"
   oil         "Oil"
   gas         "Gas"
   ely         "Electricity"
/ ;

set coa(NRG) "Coal bundle used in model" /
   coa         "Coal"
/ ;

set oil(NRG) "Oil bundle used in model" /
   oil         "Oil"
/ ;

set gas(NRG) "Gas bundle used in model" /
   gas         "Gas"
/ ;

set ely(NRG) "Electricity bundle used in model" /
   ely         "Electricity"
/ ;

set mape(NRG,e) "Mapping of energy commodities to energy bundles" /
   COA.(coa)
   OIL.(oil, p_c)
   GAS.(gas)
   ELY.(ely)
/ ;

*  >>>> Sets required for 'growing' labor by skill

set skl(l)  "Skill types for labor growth assumptions" /
   skl
/ ;

set elev / elev0*elev3 / ;

set educMap(r,l,elev) "Mapping of skills to education levels" ;

*  Use GIDD definitions (i.e. "elev3" has no meaning)

educMap(r,"nsk","elev0")$mapra("lmy",r) = yes ;
educMap(r,"skl","elev1")$mapra("lmy",r)   = yes ;
educMap(r,"skl","elev2")$mapra("lmy",r)   = yes ;

educMap(r,"nsk","elev0")$mapra("hic",r) = yes ;
educMap(r,"nsk","elev1")$mapra("hic",r) = yes ;
educMap(r,"skl","elev2")$mapra("hic",r)   = yes ;

$iftheni "%LU%" == "OFF"


$endif

$iftheni "%MACRO%" == "ON"

$setGlobal ifDual    1
$setGlobal SIGMA     1.0
$setGlobal SIGMAM    1.5
$setGlobal OMEGA     4
$setGlobal ETAM      inf
$setGlobal ETAE      inf

set
   t(tssp)  "Modeled years"      /
            2014*2100
   /
   t0(t)    "First simulation year"
   te(t)    "Equilibrium year"   / 2100 /
;

file mcsv    / macro%BaseName%.csv / ;
file msamcsv / macroSAM%BaseName%.csv / ;

parameter depr(r,t) ;

*  Possible adjustments (depends on ra defined above)
depr(r,t) = 0.04 ;
depr(r,t)$mapra("lmy",r) = 0.05$(t.val le 2030) + 0.05$(t.val gt 2030) ;
$ontext
*  Possible additional adjustments
depr("chn",t) = 0.06$(t.val le 2030)
              + 0.05$(t.val gt 2030 and t.val le 2040)
              + 0.05$(t.val gt 2040)
              ;
$offtext

set mapcr(c,r) "Mapping from countries to model aggregation" ;
loop((c,r,reg),
   mapcr(c,r)$(mapr(reg,r) and mapc(reg,c)) = yes ;
) ;

set
   maprg(reg,r) "Mapping for missing regions 'r'"
;

maprg(reg,r)$mapr(reg,r) = yes ;

display mapcr, maprg ;

$onempty
set
   rx(r) "Regions not part of GTAP database" /
   /
   maprx(rx,r) "Mapping of missing regions to original GTAP region" /
   /
;
$offempty

* parameter kadj0(r) ; kadj0(r) = 1 ;

Parameter kadj0(r) "Adjustment to initial K/Y ratio" ;
kadj0(r) = 1 ;

scalar lfpr0 / 0.75 / ;
parameter lfpr(r) ; lfpr(r) = lfpr0 ;

$endif

$offempty
