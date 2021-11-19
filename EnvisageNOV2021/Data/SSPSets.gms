*  Sets for SSPs

sets
   tt          "Full time path including history" / 1950*2100 /
   th(tt)      "History"                          / 1950*2010 /
   tssp(tt)    "Full time path for SSPs"          / 2007*2100 /
   var "GDP variables" /
         GDP         "GDP in million $2007 MER"
         GDPpc       "GDP per capita in $2007 MER"
         gdpppp05    "GDP in $2005 PPP"
         gdppcppp05  "GDP per capita in $2005"
      /
   scen "Scenarios" /
      SSP1        "Sustainable development"
      SSP2        "Middle of the road"
      SSP3        "Regional rivalry"
      SSP4        "Inequality"
      SSP5        "Fossil-fueled development"
      UNMED2010   "UN Population Division Medium Variant 2010 revision"
      UNMED2012   "UN Population Division Medium Variant 2012 revision"
      UNMED2015   "UN Population Division Medium Variant 2015 revision"
      UNMED2017   "UN Population Division Medium Variant 2017 revision"
      UNMED2019   "UN Population Division Medium Variant 2019 revision"
      GIDD        "GIDD population projection"
      /
   ssp(scen) "SSP Scenarios" /
      SSP1        "Sustainable development"
      SSP2        "Middle of the road"
      SSP3        "Regional rivalry"
      SSP4        "Inequality"
      SSP5        "Fossil-fueled development"
      /
   mod "Models" /
      OECD        "OECD-based SSPs"
      IIASA       "IIASA-based SSPs"
      /
   tranche "Population cohorts" /
      PLT15       "Population less than 15"
      P1564       "Population aged 15 to 64"
      P65UP       "Population 65 and over"
      PTOTL       "Total population"
      /
   trs(tranche) "Population cohorts" /
      PLT15       "Population less than 15"
      P1564       "Population aged 15 to 64"
      P65UP       "Population 65 and over"
      /
   ed "Education levels" /
      ENONE       "No Education"
      EPRIM       "Primary Education"
      ESECN       "Secondary Education"
      ETERT       "Tertiary Education"
      ETOTL       "Total"
      /
   edx(ed) "Education levels excl total" /
      ENONE       "No Education"
      EPRIM       "Primary Education"
      ESECN       "Secondary Education"
      ETERT       "Tertiary Education"
      /
   sex   "Gender categories" /
      MAL         "Male"
      FEM         "Female"
      BOTH        "M+F"
      /
   sexx(sex) "Gender categories excl total"  /
      MAL         "Male"
      FEM         "Female"
      /

   edw "GIDD education labels" /
      educ0_6     "educ0_6"
      educ6_9     "educ6_9"
      educ9up     "educ9up"
      eductot     "eductot"
      /

   edwx(edw) "GIDD education labels /x total" /
      educ0_6     "educ0_6"
      educ6_9     "educ6_9"
      educ9up     "educ9up"
      /

   edj "Combined SSP/GIDD education levels" /
      elev0       "ENONE/EDUC0_6"
      elev1       "EPRIM/EDUC6_9"
      elev2       "ESECN/EDUC9UP"
      elev3       "ETERT"
      elevt       "Total"
   /

   mape1(edj, ed) "Mapping of SSP education to edj" /
      elev0.ENONE
      elev1.EPRIM
      elev2.ESECN
      elev3.ETERT
      elevt.ETOTL
   /

   mape2(edj, edw) "Mapping of GIDD education to edj" /
      elev0.EDUC0_6
      elev1.EDUC6_9
      elev2.EDUC9UP
      elevt.eductot
   /
;
