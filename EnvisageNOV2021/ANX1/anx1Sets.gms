$onempty

set a0 "Original activities" /
   FRS          "Forestry"
   COA          "Coal"
   OIL          "Oil"
   GAS          "Gas"
   OXT          "Minerals nec"
   P_C          "Petroleum and coal products"
   AGR          "Agriculture"
   EIT          "Vegetable oils and fats"
   XMN          "Dairy products"
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
/ ;

set i0(a0) "Original commodities" /
   FRS          "Forestry"
   COA          "Coal"
   OIL          "Oil"
   GAS          "Gas"
   OXT          "Minerals nec"
   P_C          "Petroleum and coal products"
   AGR          "Agriculture"
   EIT          "Vegetable oils and fats"
   XMN          "Dairy products"
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
/ ;

* --------------------------------------------------------------------
*
*   USER CAN MODIFY ACTIVITY/COMMODITY AGGREGATION
*   USER MUST FILL IN SUBSETS WHERE NEEDED
*
* --------------------------------------------------------------------


* >>>> PLACE TO CHANGE ACTIVITIES, i.e. model activities

set act "Modeled activities" /
   AGR-a        "Agriculture"
   FRS-a        "Forestry"
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
   OXT-a        "Minerals nec"
   EIT-a        "Vegetable oils and fats"
   XMN-a        "Dairy products"
   P_C-a        "Petroleum and coal products"
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
   SRV-a        "Services"
/ ;

* >>>> PLACE TO CHANGE COMMODITIES, i.e. model commodities

set comm "Modeled commodities" /
   AGR-c        "Agriculture"
   FRS-c        "Forestry"
   COA-c        "Coal"
   OIL-c        "Oil"
   GAS-c        "Gas"
   OXT-c        "Minerals nec"
   EIT-c        "Vegetable oils and fats"
   XMN-c        "Dairy products"
   P_C-c        "Petroleum and coal products"
   ELY-c        "Electricity"
   SRV-c        "Services"
/ ;

set endw "Modeled production factors" /
   nsk          "Unskilled labor"
   skl          "Skilled labor"
   cap          "Capital"
   lnd          "Land"
   nrs          "Natural resource"
/ ;

set stdlab "Standard SAM labels" /
   TRD          "Trade account"
   regY         "Regional household"
   hhd          "Household"
   gov          "Government"
   r_d          "Research and development"
   inv          "Investment"
   deprY        "Depreciation"
   tmg          "Trade margins"
   itax         "Indirect tax"
   ptax         "Production tax"
   mtax         "Import tax"
   etax         "Export tax"
   vtax         "Taxes on factors of production"
   ltax         "Taxes on labor use"
   ktax         "Taxes on capital use"
   rtax         "Taxes on natural resource use"
   vsub         "Subsidies on factors of production"
   wtax         "Waste tax"
   dtax         "Direct taxation"
   ctax         "Carbon tax"
   ntmY         "NTM revenues"
   bop          "Balance of payments account"
   tot          "Total for row/column sums"
/ ;

set findem(stdlab) "Final demand accounts" /
   hhd          "Household"
   gov          "Government"
   r_d          "Research and development"
   inv          "Investment"
   tmg          "Trade margins"
/ ;

set reg "Modeled regions" /
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
/ ;

set is "SAM accounts for aggregated SAM" /

*  User-defined activities

   set.act

*  User-defined commodities

   set.comm

*  User-defined factors

   set.endw

*  Standard SAM accounts

   set.stdlab

*  User-defined regions

   set.reg

/ ;

alias(is, js) ;

set aa(is) "Armington agents" /

   set.act

   set.findem

/ ;

set a(aa) "Activities" /

   set.act

/ ;

set i(is) "Commodities" /

   set.comm

/ ;

alias(i, j) ;

set fp(is) "Factors of production" /

   set.endw

/ ;

set l(fp) "Labor factors" /

   nsk          "Unskilled labor"
   skl          "Skilled labor"
/ ;

*   Subsets ul(l) and sl(l) included for backward compatibility

set ul(l) "Unskilled labor" /

   nsk          "Unskilled labor"
   skl          "Skilled labor"
/ ;

set sl(l) "Skilled labor" /

/ ;

set wb "Intermediate labor bundle(s)" /
   Single       "Single intermediate labor bundle"
/ ;

set maplab1(wb) "Mapping of intermediate labor demand bundle(s) to LAB1" /
   Single       "Single intermediate labor bundle"
/ ;

set mapl(wb,l) "Mapping of labor categories to intermedate demand bundle(s)" /
   Single   .nsk
   Single   .skl
/ ;

set lr(l) "Reference labor for skill premium" /

   skl          "Skilled labor"
/ ;

set cap(fp) "Capital" /

   cap          "Capital"
/ ;

set lnd(fp) "Land endowment" /

   lnd          "Land"
/ ;

set nrs(fp) "Natural resource" /

   nrs          "Natural resource"
/ ;

set wat(fp) "Water resource" /

/ ;

* >>>> CAN MODIFY MOBILE VS. NON-MOBILE FACTORS

set fm(fp) "Mobile factors" /

   nsk          "Unskilled labor"
   skl          "Skilled labor"
   cap          "Capital"
   lnd          "Land"
   nrs          "Natural resource"
/ ;

set fnm(fp) "Non-mobile factors" /

/ ;

set fd(aa) "Domestic final demand agents" /

   hhd          "Household"
   gov          "Government"
   r_d          "Research and development"
   inv          "Investment"
/ ;

set h(fd) "Households" /
   hhd          "Household"
/ ;

set gov(fd) "Government" /
   gov          "Government"
/ ;

set r_d(fd) "Research and development" /
   r_d          "Research and development"
/ ;

set inv(fd) "Investment" /
   inv          "Investment"
/ ;

set fdc(fd) "Final demand accounts with CES expenditure function" /
   gov          "Government"
   r_d          "Research and development"
   inv          "Investment"
/ ;

set r(is) "Regions" /

   set.reg

/ ;

alias(r, rp) ; alias(r, s) ; alias(r, d) ;

* >>>> MUST INSERT RESIDUAL REGION (ONLY ONE)

set rres(r) "Residual region" /
   USA          "United States"
/ ;

* >>>> MUST INSERT MUV REGIONS (ONE OR MORE)

set rmuv(r) "MUV regions" /
   CHN          "China"
   USA          "United States"
   EUR          "Western Europe"
   XOE          "Other HIY OECD"
/ ;

* >>>> MUST INSERT MUV COMMODITIES (ONE OR MORE)

set imuv(i) "MUV commodities" /
   EIT-c
   XMN-c
/ ;

set ia "Aggregate commodities for model output" /
   FRS-c        "Forestry"
   COA-c        "Coal"
   OIL-c        "Oil"
   GAS-c        "Gas"
   OXT-c        "Minerals nec"
   P_C-c        "Petroleum and coal products"
   AGR-c        "Agriculture"
   EIT-c        "Vegetable oils and fats"
   XMN-c        "Dairy products"
   SRV-c        "Services"
   ELY-c        "Electricity"

   tagr-c       "Agriculture"
   tman-c       "Manufacturing"
   tsrv-c       "Services"
   toth-c       "Other"
   ttot-c       "Total"
/ ;

set mapi(ia,i) "Mapping for aggregate commodities" /
   FRS-c    .FRS-c
   COA-c    .COA-c
   OIL-c    .OIL-c
   GAS-c    .GAS-c
   OXT-c    .OXT-c
   P_C-c    .P_C-c
   AGR-c    .AGR-c
   EIT-c    .EIT-c
   XMN-c    .XMN-c
   SRV-c    .SRV-c
   ELY-c    .ELY-c

   tagr-c   .FRS-c
   tagr-c   .AGR-c
   tman-c   .P_C-c
   tman-c   .EIT-c
   tman-c   .XMN-c
   tsrv-c   .SRV-c
   tsrv-c   .ELY-c
   toth-c   .COA-c
   toth-c   .OIL-c
   toth-c   .GAS-c
   toth-c   .OXT-c
   ttot-c   .FRS-c
   ttot-c   .COA-c
   ttot-c   .OIL-c
   ttot-c   .GAS-c
   ttot-c   .OXT-c
   ttot-c   .P_C-c
   ttot-c   .AGR-c
   ttot-c   .EIT-c
   ttot-c   .XMN-c
   ttot-c   .SRV-c
   ttot-c   .ELY-c
/ ;

set iaa(ia) "Aggregate commodities only" ;
loop((i,ia)$(not sameas(i,ia)), iaa(ia) = yes ; ) ;

set aga "Aggregate activities for model output" /
   FRS-a        "Forestry"
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
   OXT-a        "Minerals nec"
   P_C-a        "Petroleum and coal products"
   AGR-a        "Agriculture"
   EIT-a        "Vegetable oils and fats"
   XMN-a        "Dairy products"
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
   SRV-a        "Services"

   tagr-a       "Agriculture"
   tman-a       "Manufacturing"
   tsrv-a       "Services"
   toth-a       "Other"
   ttot-a       "Total"
/ ;

set mapaga(aga,a) "Mapping for aggregate activities" /
   FRS-a    .FRS-a
   COA-a    .COA-a
   OIL-a    .OIL-a
   GAS-a    .GAS-a
   OXT-a    .OXT-a
   P_C-a    .P_C-a
   AGR-a    .AGR-a
   EIT-a    .EIT-a
   XMN-a    .XMN-a
   ETD-a    .ETD-a
   CLP-a    .CLP-a
   OLP-a    .OLP-a
   GSP-a    .GSP-a
   NUC-a    .NUC-a
   HYD-a    .HYD-a
   SOL-a    .SOL-a
   WND-a    .WND-a
   XEL-a    .XEL-a
   SRV-a    .SRV-a

   tagr-a   .FRS-a
   tagr-a   .AGR-a
   tman-a   .P_C-a
   tman-a   .EIT-a
   tman-a   .XMN-a
   tsrv-a   .ETD-a
   tsrv-a   .CLP-a
   tsrv-a   .OLP-a
   tsrv-a   .GSP-a
   tsrv-a   .NUC-a
   tsrv-a   .HYD-a
   tsrv-a   .SOL-a
   tsrv-a   .WND-a
   tsrv-a   .XEL-a
   tsrv-a   .SRV-a
   toth-a   .COA-a
   toth-a   .OIL-a
   toth-a   .GAS-a
   toth-a   .OXT-a
   ttot-a   .FRS-a
   ttot-a   .COA-a
   ttot-a   .OIL-a
   ttot-a   .GAS-a
   ttot-a   .OXT-a
   ttot-a   .P_C-a
   ttot-a   .AGR-a
   ttot-a   .EIT-a
   ttot-a   .XMN-a
   ttot-a   .ETD-a
   ttot-a   .CLP-a
   ttot-a   .OLP-a
   ttot-a   .GSP-a
   ttot-a   .NUC-a
   ttot-a   .HYD-a
   ttot-a   .SOL-a
   ttot-a   .WND-a
   ttot-a   .XEL-a
   ttot-a   .SRV-a
/ ;

set agaa(aga) "Aggregate activities only" ;
loop((a,aga)$(not sameas(a,aga)), agaa(aga) = yes ; ) ;

set ra "Aggregate regions for emission regimes and model output" /
   CHN          "China"
   XEA          "Rest of East Asia and Pacific"
   USA          "United States"
   RUS          "Russia"
   EUR          "Western Europe"
   XOE          "Other HIY OECD"
   OPC          "Major oil and gas exporters"
   SAS          "South Asia"
   XLC          "Rest of Latin America & Caribbean"
   ROW          "Rest of the World"

   hic          "High-income countries"
   lmy          "Developing countries"
   wld          "World Total"
/ ;

set mapr(ra,r) "Mapping for aggregate regions" /
   CHN      .CHN
   XEA      .XEA
   USA      .USA
   RUS      .RUS
   EUR      .EUR
   XOE      .XOE
   OPC      .OPC
   SAS      .SAS
   XLC      .XLC
   ROW      .ROW

   hic      .USA
   hic      .EUR
   hic      .XOE
   lmy      .CHN
   lmy      .XEA
   lmy      .RUS
   lmy      .OPC
   lmy      .SAS
   lmy      .XLC
   lmy      .ROW
   wld      .CHN
   wld      .XEA
   wld      .USA
   wld      .RUS
   wld      .EUR
   wld      .XOE
   wld      .OPC
   wld      .SAS
   wld      .XLC
   wld      .ROW
/ ;

set rra(ra) "Aggregate regions only" ;
loop((r,ra)$(not sameas(r,ra)), rra(ra) = yes ; ) ;

set lagg "Aggregate labor for output" /
   nsk          "Unskilled labor"
   skl          "Skilled labor"

   tot          "Total labor"
/ ;

set maplagg(lagg,l) "Mapping for aggregate regions" /
   nsk      .nsk
   skl      .skl

   tot      .nsk
   tot      .skl
/ ;

* >>>> CAN CHANGE ACTIVITY MAPPING

set mapa0(a0, a) "Mapping from original activities to new activities" /
   FRS     .FRS-a
   COA     .COA-a
   OIL     .OIL-a
   GAS     .GAS-a
   OXT     .OXT-a
   P_C     .P_C-a
   AGR     .AGR-a
   EIT     .EIT-a
   XMN     .XMN-a
   ETD     .ETD-a
   CLP     .CLP-a
   OLP     .OLP-a
   GSP     .GSP-a
   NUC     .NUC-a
   HYD     .HYD-a
   SOL     .SOL-a
   WND     .WND-a
   XEL     .XEL-a
   SRV     .SRV-a
/ ;

* >>>> CAN CHANGE COMMODITY MAPPING

set mapi0(i0, i) "Mapping from original commodities to new commodities" /
   FRS     .FRS-c
   COA     .COA-c
   OIL     .OIL-c
   GAS     .GAS-c
   OXT     .OXT-c
   P_C     .P_C-c
   AGR     .AGR-c
   EIT     .EIT-c
   XMN     .XMN-c
   ETD     .ELY-c
   CLP     .ELY-c
   OLP     .ELY-c
   GSP     .ELY-c
   NUC     .ELY-c
   HYD     .ELY-c
   SOL     .ELY-c
   WND     .ELY-c
   XEL     .ELY-c
   SRV     .SRV-c
/ ;

set var "GDP variables" /
   GDP          "GDP in million $2007 MER"
   GDPpc        "GDP per capita in $2007 MER"
   gdpppp05     "GDP in $2005 PPP"
   gdppcppp05   "GDP per capita in $2005"
/ ;

set scen "Scenarios" /
   SSP1         "Sustainable development"
   SSP2         "Middle of the road"
   SSP3         "Regional rivalry"
   SSP4         "Inequality"
   SSP5         "Fossil-fueled development"
   UNMED2010    "UN Population Division Medium Variant 2010 revision"
   UNMED2012    "UN Population Division Medium Variant 2012 revision"
   UNMED2015    "UN Population Division Medium Variant 2015 revision"
   UNMED2017    "UN Population Division Medium Variant 2017 revision"
   UNMED2019    "UN Population Division Medium Variant 2019 revision"
   GIDD         "GIDD population projection"
/ ;

set ssp(scen) "SSP Scenarios" /
   SSP1         "Sustainable development"
   SSP2         "Middle of the road"
   SSP3         "Regional rivalry"
   SSP4         "Inequality"
   SSP5         "Fossil-fueled development"
/ ;

set mod "Models" /
   OECD         "OECD-based SSPs"
   IIASA        "IIASA-based SSPs"
/ ;

set tranche "Population cohorts" /
   PLT15        "Population less than 15"
   P1564        "Population aged 15 to 64"
   P65UP        "Population 65 and over"
   PTOTL        "Total population"
/ ;

set trs(tranche) "Population cohorts" /
   PLT15        "Population less than 15"
   P1564        "Population aged 15 to 64"
   P65UP        "Population 65 and over"
/ ;

set sex   "Gender categories" /
   MAL          "Male"
   FEM          "Female"
   BOTH         "M+F"
/ ;

set sexx(sex) "Gender categories excl total" /
   MAL          "Male"
   FEM          "Female"
/ ;

set ed "Combined SSP/GIDD education levels" /
   elev0        "ENONE/EDUC0_6"
   elev1        "EPRIM/EDUC6_9"
   elev2        "ESECN/EDUC9UP"
   elev3        "ETERT"
   elevt        "Total"
/ ;

set edx(ed) "Education levels excluding totals" /
   elev0        "ENONE/EDUC0_6"
   elev1        "EPRIM/EDUC6_9"
   elev2        "ESECN/EDUC9UP"
   elev3        "ETERT"
/ ;

set nsk(l) "Unskilled types for labor growth assumptions" /
   nsk          "Unskilled labor"
/ ;

set skl(l)  "Skill types for labor growth assumptions" /
   skl          "Skilled labor"
/ ;

set educMap(r,l,ed) "Mapping of skills to education levels" /
   CHN      .nsk     .elev0
   CHN      .skl     .elev1
   CHN      .skl     .elev2
   XEA      .nsk     .elev0
   XEA      .skl     .elev1
   XEA      .skl     .elev2
   USA      .nsk     .elev0
   USA      .nsk     .elev1
   USA      .skl     .elev2
   RUS      .nsk     .elev0
   RUS      .skl     .elev1
   RUS      .skl     .elev2
   EUR      .nsk     .elev0
   EUR      .nsk     .elev1
   EUR      .skl     .elev2
   XOE      .nsk     .elev0
   XOE      .nsk     .elev1
   XOE      .skl     .elev2
   OPC      .nsk     .elev0
   OPC      .skl     .elev1
   OPC      .skl     .elev2
   SAS      .nsk     .elev0
   SAS      .skl     .elev1
   SAS      .skl     .elev2
   XLC      .nsk     .elev0
   XLC      .skl     .elev1
   XLC      .skl     .elev2
   ROW      .nsk     .elev0
   ROW      .skl     .elev1
   ROW      .skl     .elev2
/ ;

set sortOrder / sort1*sort68 / ;

set mapOrder(sortOrder,is) /
sort1.AGR-a
sort2.FRS-a
sort3.COA-a
sort4.OIL-a
sort5.GAS-a
sort6.OXT-a
sort7.EIT-a
sort8.XMN-a
sort9.P_C-a
sort10.ETD-a
sort11.CLP-a
sort12.OLP-a
sort13.GSP-a
sort14.NUC-a
sort15.HYD-a
sort16.SOL-a
sort17.WND-a
sort18.XEL-a
sort19.SRV-a
sort20.AGR-c
sort21.FRS-c
sort22.COA-c
sort23.OIL-c
sort24.GAS-c
sort25.OXT-c
sort26.EIT-c
sort27.XMN-c
sort28.P_C-c
sort29.ELY-c
sort30.SRV-c
sort31.nsk
sort32.skl
sort33.cap
sort34.lnd
sort35.nrs
sort36.TRD
sort37.regY
sort38.hhd
sort39.gov
sort40.r_d
sort41.inv
sort42.deprY
sort43.tmg
sort44.itax
sort45.ptax
sort46.mtax
sort47.etax
sort48.vtax
sort49.ltax
sort50.ktax
sort51.rtax
sort52.vsub
sort53.wtax
sort54.dtax
sort55.ctax
sort56.ntmY
sort57.bop
sort58.tot
sort59.USA
sort60.EUR
sort61.XOE
sort62.CHN
sort63.RUS
sort64.OPC
sort65.XEA
sort66.SAS
sort67.XLC
sort68.ROW
/ ;

set gy(is) "Government revenue streams" /
   itax        "Indirect taxes"
   ptax        "Production taxes"
   vtax        "Factor taxes"
   mtax        "Import taxes"
   etax        "Export taxes"
   wtax        "Waste taxes"
   ctax        "Carbon taxes"
   dtax        "Direct taxes"
/ ;

set itx(gy) / itax / ;
set ptx(gy) / ptax / ;
set vtx(gy) / vtax / ;
set mtx(gy) / mtax / ;
set etx(gy) / etax / ;
set wtx(gy) / wtax / ;
set ctx(gy) / ctax / ;
set dtx(gy) / dtax / ;

set tot(is) "Total" /
   tot         "Total for row/column sums"
/ ;

set acr(a) "Crop activities" /
/ ;

set alv(a) "Livestock activities" /
/ ;

set ax(a) "All other activities" /
   FRS-a        "Forestry"
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
   OXT-a        "Minerals nec"
   P_C-a        "Petroleum and coal products"
   AGR-a        "Agriculture"
   EIT-a        "Vegetable oils and fats"
   XMN-a        "Dairy products"
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
   SRV-a        "Services"
/ ;

set agr(a) "Agricultural activities" /
   AGR-a        "Agriculture"
/ ;

set man(a) "Manufacturing activities" /
   EIT-a        "Vegetable oils and fats"
   XMN-a        "Dairy products"
/ ;

set srv(a) "Service activities" /
   FRS-a        "Forestry"
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
   OXT-a        "Minerals nec"
   P_C-a        "Petroleum and coal products"
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
   SRV-a        "Services"
/ ;

set aenergy(a) "Energy activities" /
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
   P_C-a        "Petroleum and coal products"
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
/ ;

set affl(a) "Fossil fuel activities" /
   COA-a        "Coal"
   OIL-a        "Oil"
   GAS-a        "Gas"
/ ;

set aw(a) "Water services activities" /
/ ;

set z "Labor market zones" /
   rur          "Agricultural sectors"
   urb          "Non-agricultural sectors"
   nsg          "Non-segmented labor markets"
/ ;

set rur(z) "Rural zone" /
   rur          "Agricultural sectors"
/ ;

set urb(z) "Urban zone" /
   urb          "Non-agricultural sectors"
/ ;

set nsg(z) "Both zones" /
   nsg          "Non-segmented labor markets"
/ ;

set mapz(z,a) "Mapping of activities to zones" /
   rur.AGR-a
   urb.FRS-a
   urb.COA-a
   urb.OIL-a
   urb.GAS-a
   urb.OXT-a
   urb.P_C-a
   urb.EIT-a
   urb.XMN-a
   urb.ETD-a
   urb.CLP-a
   urb.OLP-a
   urb.GSP-a
   urb.NUC-a
   urb.HYD-a
   urb.SOL-a
   urb.WND-a
   urb.XEL-a
   urb.SRV-a
/ ;

mapz("nsg", a) = yes ;

set frt(i) "Fertilizer commodities" /
/ ;

set feed(i) "Feed commodities" /
/ ;

set iw(i) "Water services commodities" /
/ ;

set e(i) "Energy commodities" /
   COA-c        "Coal"
   OIL-c        "Oil"
   GAS-c        "Gas"
   P_C-c        "Petroleum and coal products"
   ELY-c        "Electricity"
/ ;

set elyc(i) "Electricity commodities" /
   ELY-c        "Electricity"
/ ;

set fuel(e) "Fuel commodities" /
   COA-c        "COA"
   OIL-c        "OIL"
   GAS-c        "GAS"
   P_C-c        "P_C"
/ ;

set img(i) "Margin commodities" /
   SRV-c        "Services"
/ ;

set k "Household commodities" /
   OXT-k        "Minerals nec"
   AGR-k        "Agriculture"
   EIT-k        "Energy intensive goods"
   XMN-k        "Other manufacturing"
   SRV-k        "Services"
   nrg-k        "Energy"
/ ;

set fud(k) "Household food commodities" /
   AGR-k        "Agriculture"
/ ;

set mapk(i,k) "Mapping from i to k" /
   FRS-c    .OXT-k
   COA-c    .nrg-k
   OIL-c    .nrg-k
   GAS-c    .nrg-k
   OXT-c    .OXT-k
   P_C-c    .nrg-k
   AGR-c    .AGR-k
   EIT-c    .EIT-k
   XMN-c    .XMN-k
   SRV-c    .SRV-k
   ELY-c    .nrg-k
/ ;

set CPINDX "Categories of CPI indices" /
   tot        "Total price index"
/ ;

set mapCPI(cpindx,i) "Mapping from i to CPINDX" /
   tot    .FRS-c
   tot    .COA-c
   tot    .OIL-c
   tot    .GAS-c
   tot    .OXT-c
   tot    .P_C-c
   tot    .AGR-c
   tot    .EIT-c
   tot    .XMN-c
   tot    .SRV-c
   tot    .ELY-c
/ ;

set elya(a) "Power activities" /
   ETD-a        "Electricity transmission"
   CLP-a        "Coal-fired power"
   OLP-a        "Oil-fired power"
   GSP-a        "Gas-fired power"
   NUC-a        "Nuclear power"
   HYD-a        "Hydro power"
   SOL-a        "Solar power"
   WND-a        "Wind power"
   XEL-a        "Other power"
/ ;

set etd(a) "Electricity transmission and distribution activities" /
   ETD-a        "Electricity transmission"
/ ;

set primElya(a) "Primary power activities" /
   NUC-a        "NUC"
   HYD-a        "HYD"
   SOL-a        "SOL"
   WND-a        "WND"
   XEL-a        "XEL"
/ ;

set pb "Power bundles in power aggregation" /
   GasP         "Gas bundle"
   OilP         "Oil bundle"
   coap         "Coal bundle"
   nucp         "Nuclear"
   hydp         "Hydro"
   renp         "Renewables"
/ ;

set mappow(pb,elya) "Mapping of power activities to power bundles" /
   GasP     .GSP-a
   OilP     .OLP-a
   coap     .CLP-a
   nucp     .NUC-a
   hydp     .HYD-a
   renp     .SOL-a
   renp     .WND-a
   renp     .XEL-a
/ ;

set lb "Land bundles" /
   AGR          "Agriculture"
/ ;

set lb1(lb) "First land bundle" /
   AGR          "Agriculture"
/ ;

set maplb(lb,a) "Mapping of activities to land bundles" /
   AGR      .AGR-a
/ ;

set lh "Market condition flags" /
   lo    "Market downswing"
   hi    "Market upswing"
/ ;

set wbnd "Aggregate water markets" /
   N_A          "N_A"
/ ;

set wbnd1(wbnd) "Top level water markets" /
/ ;

set wbnd2(wbnd) "Second level water markets" /
/ ;

set wbndex(wbnd) "Second level water markets" /
/ ;

set mapw1(wbnd,wbnd) "Mapping of first level water bundles" /
/ ;

set mapw2(wbnd,a) "Mapping of second level water bundle" /
/ ;

set wbnda(wbnd) "Water bundles mapped one-to-one to activities" /
/ ;

set wbndi(wbnd) "Water bundles mapped to aggregate output" /
/ ;

set NRG "Energy bundles used in model" /
   COA          "Coal"
   OIL          "Oil"
   GAS          "Gas"
   ELY          "Electricity"
/ ;

set coa(NRG) "Coal bundle used in model" /
   COA          "Coal"
/ ;

set oil(NRG) "Oil bundle used in model" /
   OIL          "Oil"
/ ;

set gas(NRG) "Gas bundle used in model" /
   GAS          "Gas"
/ ;

set ely(NRG) "Electricity bundle used in model" /
   ELY          "Electricity"
/ ;

set mape(NRG,e) "Mapping of energy commodities to energy bundles" /
   COA      .COA-c
   OIL      .OIL-c
   OIL      .P_C-c
   GAS      .GAS-c
   ELY      .ELY-c
/ ;

set pt "Price trends" / lo, mid, ref, hi / ;

set em "Emission types" /
   co2          "Carbon emissions"
   n2o          "N2O emissions"
   ch4          "Methane emissions"
   fgas         "Emissions of fluoridated gases"
   bc           "Black carbon (Gg)"
   co           "Carbon monoxide (Gg)"
   nh3          "Ammonia (Gg)"
   nmvoc        "Non-methane volatile organic compounds (Gg)"
   nox          "Nitrogen oxides (Gg)"
   oc           "Organic carbon (Gg)"
   pm10         "Particulate matter 10 (Gg)"
   pm2_5        "Particulate matter 2.5"
   so2          "Sulfur dioxide (Gg)"
/ ;

set emn(em) "Non-CO2 emission types" /
   n2o          "N2O emissions"
   ch4          "Methane emissions"
   fgas         "Emissions of fluoridated gases"
   bc           "Black carbon (Gg)"
   co           "Carbon monoxide (Gg)"
   nh3          "Ammonia (Gg)"
   nmvoc        "Non-methane volatile organic compounds (Gg)"
   nox          "Nitrogen oxides (Gg)"
   oc           "Organic carbon (Gg)"
   pm10         "Particulate matter 10 (Gg)"
   pm2_5        "Particulate matter 2.5"
   so2          "Sulfur dioxide (Gg)"
/ ;

set ghg(em) "Greenhouse gas emission types" /
   co2          "Carbon emissions"
   n2o          "N2O emissions"
   ch4          "Methane emissions"
   fgas         "Emissions of fluoridated gases"
/ ;

set nghg(em) "Non greenhouse gas emission types" /
   bc           "Black carbon (Gg)"
   co           "Carbon monoxide (Gg)"
   nh3          "Ammonia (Gg)"
   nmvoc        "Non-methane volatile organic compounds (Gg)"
   nox          "Nitrogen oxides (Gg)"
   oc           "Organic carbon (Gg)"
   pm10         "Particulate matter 10 (Gg)"
   pm2_5        "Particulate matter 2.5"
   so2          "Sulfur dioxide (Gg)"
/ ;

set emq "Emission control aggregations" /
   CO2         "Carbon dioxide"
   CO2e        "Carbon dioxide equivalent"
/ ;

set mapEM(emq,em) /

   CO2.CO2

/ ;

mapEM("CO2e",em)$ghg(em) = yes ;

set mapi1(i,a) "Mapping of commodities to ND1 bundle" /
   FRS-c    .FRS-a
   OXT-c    .FRS-a
   AGR-c    .FRS-a
   EIT-c    .FRS-a
   XMN-c    .FRS-a
   SRV-c    .FRS-a
   FRS-c    .COA-a
   OXT-c    .COA-a
   AGR-c    .COA-a
   EIT-c    .COA-a
   XMN-c    .COA-a
   SRV-c    .COA-a
   FRS-c    .OIL-a
   OXT-c    .OIL-a
   AGR-c    .OIL-a
   EIT-c    .OIL-a
   XMN-c    .OIL-a
   SRV-c    .OIL-a
   FRS-c    .GAS-a
   OXT-c    .GAS-a
   AGR-c    .GAS-a
   EIT-c    .GAS-a
   XMN-c    .GAS-a
   SRV-c    .GAS-a
   FRS-c    .OXT-a
   OXT-c    .OXT-a
   AGR-c    .OXT-a
   EIT-c    .OXT-a
   XMN-c    .OXT-a
   SRV-c    .OXT-a
   FRS-c    .P_C-a
   OXT-c    .P_C-a
   AGR-c    .P_C-a
   EIT-c    .P_C-a
   XMN-c    .P_C-a
   SRV-c    .P_C-a
   FRS-c    .AGR-a
   OXT-c    .AGR-a
   AGR-c    .AGR-a
   EIT-c    .AGR-a
   XMN-c    .AGR-a
   SRV-c    .AGR-a
   FRS-c    .EIT-a
   OXT-c    .EIT-a
   AGR-c    .EIT-a
   EIT-c    .EIT-a
   XMN-c    .EIT-a
   SRV-c    .EIT-a
   FRS-c    .XMN-a
   OXT-c    .XMN-a
   AGR-c    .XMN-a
   EIT-c    .XMN-a
   XMN-c    .XMN-a
   SRV-c    .XMN-a
   FRS-c    .ETD-a
   OXT-c    .ETD-a
   AGR-c    .ETD-a
   EIT-c    .ETD-a
   XMN-c    .ETD-a
   SRV-c    .ETD-a
   FRS-c    .CLP-a
   OXT-c    .CLP-a
   AGR-c    .CLP-a
   EIT-c    .CLP-a
   XMN-c    .CLP-a
   SRV-c    .CLP-a
   FRS-c    .OLP-a
   OXT-c    .OLP-a
   AGR-c    .OLP-a
   EIT-c    .OLP-a
   XMN-c    .OLP-a
   SRV-c    .OLP-a
   FRS-c    .GSP-a
   OXT-c    .GSP-a
   AGR-c    .GSP-a
   EIT-c    .GSP-a
   XMN-c    .GSP-a
   SRV-c    .GSP-a
   FRS-c    .NUC-a
   OXT-c    .NUC-a
   AGR-c    .NUC-a
   EIT-c    .NUC-a
   XMN-c    .NUC-a
   SRV-c    .NUC-a
   FRS-c    .HYD-a
   OXT-c    .HYD-a
   AGR-c    .HYD-a
   EIT-c    .HYD-a
   XMN-c    .HYD-a
   SRV-c    .HYD-a
   FRS-c    .SOL-a
   OXT-c    .SOL-a
   AGR-c    .SOL-a
   EIT-c    .SOL-a
   XMN-c    .SOL-a
   SRV-c    .SOL-a
   FRS-c    .WND-a
   OXT-c    .WND-a
   AGR-c    .WND-a
   EIT-c    .WND-a
   XMN-c    .WND-a
   SRV-c    .WND-a
   FRS-c    .XEL-a
   OXT-c    .XEL-a
   AGR-c    .XEL-a
   EIT-c    .XEL-a
   XMN-c    .XEL-a
   SRV-c    .XEL-a
   FRS-c    .SRV-a
   OXT-c    .SRV-a
   AGR-c    .SRV-a
   EIT-c    .SRV-a
   XMN-c    .SRV-a
   SRV-c    .SRV-a
/ ;

set mapi2(i,a) "Mapping of commodities to ND2 bundle" /
/ ;

set GHGCodes "GHG codes from WB WDI database" /
   co2          "CO2 emissions (mt)"
   n2o          "Nitrous oxide emissions (mt of CO2 equivalent)"
   ch4          "Methane emissions (mt of CO2 equivalent)"
   fgas         "Other greenhouse gas emissions, HFC, PFC and SF6 (megaton ton of CO2 equivalent)"
   NRGUSE       "Energy use (kg of oil equivalent per capita)"
   GHGT         "Total greenhouse gas emissions (mt of CO2 equivalent)"
   HFC          "HFC gas emissions (mt of CO2 equivalent)"
   PFC          "PFC gas emissions (mt ton of CO2 equivalent)"
   SF6          "SF6 gas emissions (mt of CO2 equivalent)"
   LUCFNET      "GHG net emissions/removals by LUCF (Mt of CO2 equivalent)"
/ ;

set rq(ra) "Regions submitted to an emissions cap" ;
rq(ra) = no ;

set aets "Agent specific ETS coalitions" /
   All        "ALL agents"
/ ;

set mapETS(aets,aa) "Mapping of agents to ETS coalitions" /
   All    .FRS-a
   All    .COA-a
   All    .OIL-a
   All    .GAS-a
   All    .OXT-a
   All    .P_C-a
   All    .hhd
   All    .gov
   All    .r_d
   All    .inv
   All    .tmg
   All    .AGR-a
   All    .EIT-a
   All    .XMN-a
   All    .ETD-a
   All    .CLP-a
   All    .OLP-a
   All    .GSP-a
   All    .NUC-a
   All    .HYD-a
   All    .SOL-a
   All    .WND-a
   All    .XEL-a
   All    .SRV-a
/ ;
mapETS("All", aa) = yes ;

