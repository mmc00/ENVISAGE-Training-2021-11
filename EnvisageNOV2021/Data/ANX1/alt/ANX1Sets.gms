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

* >>>> PLACE TO CHANGE COMMODITIES, i.e. model commodities

set comm "Modeled commodities" /
   FRS-c        "Forestry"
   COA-c        "Coal"
   OIL-c        "Oil"
   GAS-c        "Gas"
   OXT-c        "Minerals nec"
   P_C-c        "Petroleum and coal products"
   AGR-c        "Agriculture"
   EIT-c        "Vegetable oils and fats"
   XMN-c        "Dairy products"
   ETD-c        "Electricity transmission"
   CLP-c        "Coal-fired power"
   OLP-c        "Oil-fired power"
   GSP-c        "Gas-fired power"
   NUC-c        "Nuclear power"
   HYD-c        "Hydro power"
   SOL-c        "Solar power"
   WND-c        "Wind power"
   XEL-c        "Other power"
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

   set.findem

/ ;

set h(fd) "Households" /
   hhd          "Household"
/ ;

singleton set gov(fd) "Government" /
   gov          "Government"
/ ;

singleton set r_d(fd) "Research and development" /
   r_d          "Research and development"
/ ;

singleton set inv(fd) "Investment" /
   inv          "Investment"
/ ;

set fdc(fd) "Final demand accounts with CES expenditure function" /
   gov          "Government"
   r_d          "Research and development"
   inv          "Investment"
/ ;

set tmg(fd) "Domestic supply of trade margins services" /
   tmg          "Trade margins"
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
   set.comm

/ ;

set em "Emissions" /
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

set emn(em) "Non-CO2 emissions" /
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

alias(emn, nco2) ;

set ia "Aggregate commodities for model output" /
   Total        "Aggregation of all commodities"
/ ;

set mapi(ia,i) "Mapping for aggregate commodities" ;
mapi("Total",i) = yes ;

set iaa(ia) "Aggregate commodities only" ;
loop((i,ia)$(not sameas(i,ia)), iaa(ia) = yes ; ) ;

set aga "Aggregate activities for model output" /
   Total        "Aggregation of all activities"
/ ;

set mapaga(aga,a) "Mapping for aggregate activities" ;
mapaga("Total",a) = yes ;

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
   ETD     .ETD-c
   CLP     .CLP-c
   OLP     .OLP-c
   GSP     .GSP-c
   NUC     .NUC-c
   HYD     .HYD-c
   SOL     .SOL-c
   WND     .WND-c
   XEL     .XEL-c
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

set sortOrder / sort1*sort76 / ;

set mapOrder(sortOrder,is) /
sort1.FRS-a
sort2.COA-a
sort3.OIL-a
sort4.GAS-a
sort5.OXT-a
sort6.P_C-a
sort7.AGR-a
sort8.EIT-a
sort9.XMN-a
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
sort20.FRS-c
sort21.COA-c
sort22.OIL-c
sort23.GAS-c
sort24.OXT-c
sort25.P_C-c
sort26.AGR-c
sort27.EIT-c
sort28.XMN-c
sort29.ETD-c
sort30.CLP-c
sort31.OLP-c
sort32.GSP-c
sort33.NUC-c
sort34.HYD-c
sort35.SOL-c
sort36.WND-c
sort37.XEL-c
sort38.SRV-c
sort39.nsk
sort40.skl
sort41.cap
sort42.lnd
sort43.nrs
sort44.TRD
sort45.regY
sort46.hhd
sort47.gov
sort48.r_d
sort49.inv
sort50.deprY
sort51.tmg
sort52.itax
sort53.ptax
sort54.mtax
sort55.etax
sort56.vtax
sort57.ltax
sort58.ktax
sort59.rtax
sort60.vsub
sort61.wtax
sort62.dtax
sort63.ctax
sort64.ntmY
sort65.bop
sort66.tot
sort67.USA
sort68.EUR
sort69.XOE
sort70.CHN
sort71.RUS
sort72.OPC
sort73.XEA
sort74.SAS
sort75.XLC
sort76.ROW
/ ;

