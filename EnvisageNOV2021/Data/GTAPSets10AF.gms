* ----------------------------------------------------------------------------------------
*
*  Set definitions for standard GTAP database
*
*     Includes water endowment
*
* ----------------------------------------------------------------------------------------

scalar ver / 10 / ;

$onempty

set REG Set of regions in GTAP /
   AUS     "Australia"
   NZL     "New Zealand"
   XOC     "Rest of Oceania"
   CHN     "China"
   HKG     "Hong Kong"
   JPN     "Japan"
   KOR     "Korea"
   MNG     "Mongolia"
   TWN     "Taiwan"
   XEA     "Rest of East Asia"
   BRN     "Brunei Darussalam"
   KHM     "Cambodia"
   IDN     "Indonesia"
   LAO     "Laos"
   MYS     "Malaysia"
   PHL     "Philippines"
   SGP     "Singapore"
   THA     "Thailand"
   VNM     "Viet Nam"
   XSE     "Rest of Southeast Asia"
   BGD     "Bangladesh"
   IND     "India"
   NPL     "Nepal"
   PAK     "Pakistan"
   LKA     "Sri Lanka"
   XSA     "Rest of South Asia"
   CAN     "Canada"
   USA     "United States of America"
   MEX     "Mexico"
   XNA     "Rest of North America"
   ARG     "Argentina"
   BOL     "Bolivia"
   BRA     "Brazil"
   CHL     "Chile"
   COL     "Colombia"
   ECU     "Ecuador"
   PRY     "Paraguay"
   PER     "Peru"
   URY     "Uruguay"
   VEN     "Venezuela"
   XSM     "Rest of South America"
   CRI     "Costa Rica"
   GTM     "Guatemala"
   HND     "Honduras"
   NIC     "Nicaragua"
   PAN     "Panama"
   SLV     "El Salvador"
   XCA     "Rest of Central America"
   DOM     "Dominican Republic"
   JAM     "Jamaica"
   PRI     "Puerto Rico"
   TTO     "Trinidad and Tobago"
   XCB     "Rest of Caribbean"
   AUT     "Austria"
   BEL     "Belgium"
   CYP     "Cyprus"
   CZE     "Czech Republic"
   DNK     "Denmark"
   EST     "Estonia"
   FIN     "Finland"
   FRA     "France"
   DEU     "Germany"
   GRC     "Greece"
   HUN     "Hungary"
   IRL     "Ireland"
   ITA     "Italy"
   LVA     "Latvia"
   LTU     "Lithuania"
   LUX     "Luxembourg"
   MLT     "Malta"
   NLD     "Netherlands"
   POL     "Poland"
   PRT     "Portugal"
   SVK     "Slovakia"
   SVN     "Slovenia"
   ESP     "Spain"
   SWE     "Sweden"
   GBR     "United Kingdom"
   CHE     "Switzerland"
   NOR     "Norway"
   XEF     "Rest of EFTA"
   ALB     "Albania"
   BGR     "Bulgaria"
   BLR     "Belarus"
   HRV     "Croatia"
   ROU     "Romania"
   RUS     "Russian Federation"
   UKR     "Ukraine"
   XEE     "Rest of Eastern Europe"
   XER     "Rest of Europe"
   KAZ     "Kazakhstan"
   KGZ     "Kyrgyzstan"
   TJK     "Tajikistan"
   XSU     "Rest of Former Soviet Union"
   ARM     "Armenia"
   AZE     "Azerbaijan"
   GEO     "Georgia"
   BHR     "Bahrain"
   IRN     "Iran"
   ISR     "Israel"
   JOR     "Jordan"
   KWT     "Kuwait"
   OMN     "Oman"
   QAT     "Qatar"
   SAU     "Saudi Arabia"
   TUR     "Turkey"
   ARE     "United Arab Emirates"
   XWS     "Rest of Western Asia"
   EGY     "Egypt"
   MAR     "Morocco"
   TUN     "Tunisia"
   XNF     "Rest of North Africa"
   BEN     "Benin"
   BFA     "Burkina Faso"
   CMR     "Cameroon"
   CIV     "Côte d'Ivoire"
   GHA     "Ghana"
   GIN     "Guinea"
   NGA     "Nigeria"
   SEN     "Senegal"
   TGO     "Togo"
   XWF     "Rest of Western Africa"
   XCF     "Central Africa"
   XAC     "Rest of South-Central Africa"
   ETH     "Ethiopia"
   KEN     "Kenya"
   MDG     "Madagascar"
   MWI     "Malawi"
   MUS     "Mauritius"
   MOZ     "Mozambique"
   RWA     "Rwanda"
   TZA     "Tanzania"
   UGA     "Uganda"
   ZMB     "Zambia"
   ZWE     "Zimbabwe"
   XEC     "Rest of Eastern Africa"
   BWA     "Botswana"
   NAM     "Namibia"
   ZAF     "South Africa"
   XSC     "Rest of South African Customs Union"
   XTW     "Rest of the World"
/ ;

alias(reg,r0) ; alias(reg,rp0) ;

set comm "Set of activities in GTAP" /
   PDR     "Paddy rice"
   WHT     "Wheat"
   GRO     "Cereal grains nec"
   V_F     "Vegetables, fruit, nuts"
   OSD     "Oil seeds"
   C_B     "Sugar cane, sugar beet"
   PFB     "Plant-based fibers"
   OCR     "Crops nec"
   CTL     "Bovine cattle, sheep and goats, horses"
   OAP     "Animal products nec"
   RMK     "Raw milk"
   WOL     "Wool, silk-worm cocoons"
   FRS     "Forestry"
   FSH     "Fishing"
   COA     "Coal"
   OIL     "Oil"
   GAS     "Gas"
   OXT     "Other Extraction (formerly omn Minerals nec)"
   CMT     "Bovine meat products"
   OMT     "Meat products nec"
   VOL     "Vegetable oils and fats"
   MIL     "Dairy products"
   PCR     "Processed rice"
   SGR     "Sugar"
   OFD     "Food products nec"
   B_T     "Beverages and tobacco products"
   TEX     "Textiles"
   WAP     "Wearing apparel"
   LEA     "Leather products"
   LUM     "Wood products"
   PPP     "Paper products, publishing"
   P_C     "Petroleum, coal products"
   CHM     "Chemical products"
   BPH     "Basic pharmaceutical products"
   RPP     "Rubber and plastic products"
   NMM     "Mineral products nec"
   I_S     "Ferrous metals"
   NFM     "Metals nec"
   FMP     "Metal products"
   ELE     "Computer, electronic and optical products"
   EEQ     "Electrical equipment"
   OME     "Machinery and equipment nec"
   MVH     "Motor vehicles and parts"
   OTN     "Transport equipment nec"
   OMF     "Manufactures nec"
   ELY     "Electricity"
   GDT     "Gas manufacture, distribution"
   WTR     "Water"
   CNS     "Construction"
   TRD     "Trade"
   AFS     "Accommodation, Food and service activities"
   OTP     "Transport nec"
   WTP     "Water transport"
   ATP     "Air transport"
   WHS     "Warehousing and support activities"
   CMN     "Communication"
   OFI     "Financial services nec"
   INS     "Insurance (formerly isr)"
   RSA     "Real estate activities"
   OBS     "Business services nec"
   ROS     "Recreational and other services"
   OSG     "Public Administration and defense"
   EDU     "Education"
   HHT     "Human health and social work activities"
   DWE     "Dwellings"
/ ;

alias(acts,comm) ;

alias(comm, i0) ;
alias(acts, a0) ;

SET MARG(comm) /

otp
wtp
atp

/;
alias(img0, marg) ;

set erg(comm) /

   "coa"    "Coal"
   "oil"    "Crude oil"
   "gas"    "Natural gas"
   "p_c"    "Refined oil"
   "ely"    "Electricity"
   "gdt"    "Gas distribution"
/ ;


*  !!!! NEEDS REVIEW -- SHOULD PROBABLY MOVE THIS TO A MAP FILE

parameter scaleXP(a0) ;
scaleXP(a0) = 1 ;

set fuel(erg) /

   coa   "Coal"
   oil   "Oil"
   gas   "Gas"
   p_c   "Petroleum, coal products"
   gdt   "Gas manufacture, distribution"

/ ;


*  Calculate the energy content of fossil fuel consumption
*
*  THIS IS A QUICK FIX AND NEEDS REVIEW

alias(fuel,f0) ;
alias(erg,e0) ;

set etr0(f0) "Which fuels"      / coa, oil, gas, p_c, gdt / ;
set atr0(a0) "Which activities" / oil, p_c, chm, bph, rpp / ;

sets
    acr0(a0) "Crop activities" /
      pdr   "Paddy rice"
      wht   "Wheat"
      gro   "Cereal grains, n.e.s."
      v_f   "Vegetables and fruits"
      osd   "Oil seeds"
      c_b   "Sugar cane and sugar beet"
      pfb   "Plant-based fibers"
      ocr   "Crops, n.e.s."
      /
   alv0(a0) "Livestock activities" /
      ctl   "Bovine cattle, sheep and goats, horses"
      oap   "Animal products n.e.s."
      rmk   "Raw milk"
      wol   "Wool, silk-worm cocoons"
      /
;

set elya0(a0)  "Power activities" /

/ ;

set endw Set of endowment factors /
   Land           "Land"
   tech_aspros    "Technical and professional workers"
   clerks         "Clerical workers"
   service_shop   "Service shop"
   off_mgr_pros   "Management"
   ag_othlowsk    "Agriculture and other low-skill workers"
   Capital        "Capital"
   NatlRes        "Natural resources"
$iftheni %ifWater% == "on"
   Water          "Water resource"
$endif
/ ;

set lab(endw) Set of labor factors /
   tech_aspros    "Technical and professional workers"
   clerks         "Clerical workers"
   service_shop   "Service shop"
   off_mgr_pros   "Management"
   ag_othlowsk    "Agriculture and other low-skill workers"
/ ;

alias(endw, fp0) ;

set ENDWS(endw) "Sluggish endowments" /
   Land     "Land"
   NatlRes  "Natural resources"
/ ;

set CAPT(endw) "Capital endowment" /
   Capital  "Capital"
/ ;

set LAND(endw) "Land endowment" /
   Land     "Land"
/ ;

set NTRS(endw) "Natural resource endowment" /
   NatlRes  "Natural resources"
/ ;

set WATER(endw) "Water commodity" /
$iftheni %ifWater% == "on"
   Water          "Water resource"
$endif
/ ;

set DIR /
   Domestic
   Imported
/ ;

set TARTYPE /
   ADV      "Ad valorem"
   SPE      "Specific"
/ ;

set wbnd0 "Aggregate water markets" /
   crp      "Crops"
   lvs      "Livestock"
   ind      "Industrial use"
   mun      "Municipal use"
/ ;

*  Emissions sets

set em "Emissions" /
   co2      "Carbon emissions"
   n2o      "N2O emissions"
   ch4      "Methane emissions"
   fgas     "Emissions of fluoridated gases"

   bc       "Black carbon (Gg)"
   co       "Carbon monoxide (Gg)"
   nh3      "Ammonia (Gg)"
*  nmvb     "Non-methane volatile organic compounds (Gg)"
*  nmvf     "Non-methane volatile organic compounds (Gg)"
   nmvoc    "Non-methane volatile organic compounds (Gg)"
   nox      "Nitrogen oxides (Gg)"
   oc       "Organic carbon (Gg)"
   pm10     "Particulate matter 10 (Gg)"
*  pm2_5b   "Particulate matter 2.5 bio (Gg)"
*  pm2_5f   "Particulate matter 2.5 fossil fuels (Gg)"
   pm2_5    "Particulate matter 2.5"
   so2      "Sulfur dioxide (Gg)"
/ ;

set ghg(em) "Greenhouse gas emissions" /

   co2      "Carbon emissions"
   n2o      "N2O emissions"
   ch4      "Methane emissions"
   fgas     "Emissions of fluoridated gases"

/ ;

set nghg(em) "Non-greenhouse gas emissions" /

   bc       "Black carbon (Gg)"
   co       "Carbon monoxide (Gg)"
   nh3      "Ammonia (Gg)"
*  nmvb     "Non-methane volatile organic compounds (Gg)"
*  nmvf     "Non-methane volatile organic compounds (Gg)"
   nmvoc    "Non-methane volatile organic compounds (Gg)"
   nox      "Nitrogen oxides (Gg)"
   oc       "Organic carbon (Gg)"
   pm10     "Particulate matter 10 (Gg)"
*  pm2_5b   "Particulate matter 2.5 bio (Gg)"
*  pm2_5f   "Particulate matter 2.5 fossil fuels (Gg)"
   pm2_5    "Particulate matter 2.5"
   so2      "Sulfur dioxide (Gg)"

/ ;

*  Non-CO2 Emissions sets

set emn(em) "Non-CO2 emissions" /
   n2o      "N2O emissions"
   ch4      "Methane emissions"
   fgas     "Emissions of fluoridated gases"

   bc       "Black carbon (Gg)"
   co       "Carbon monoxide (Gg)"
   nh3      "Ammonia (Gg)"
*  nmvb     "Non-methane volatile organic compounds (Gg)"
*  nmvf     "Non-methane volatile organic compounds (Gg)"
   nmvoc    "Non-methane volatile organic compounds (Gg)"
   nox      "Nitrogen oxides (Gg)"
   oc       "Organic carbon (Gg)"
   pm10     "Particulate matter 10 (Gg)"
*  pm2_5b   "Particulate matter 2.5 bio (Gg)"
*  pm2_5f   "Particulate matter 2.5 fossil fuels (Gg)"
   pm2_5    "Particulate matter 2.5"
   so2      "Sulfur dioxide (Gg)"
/ ;

alias(emn, nco2) ;

set mapnco2(nco2,nco2) ; mapnco2(nco2,nco2) = yes ;

set nco2eq "Labels for NCO2 gases in GWP units" /
   n2o_co2eq
   ch4_co2eq
   fgas_co2eq
/ ;

set mapco2eq(em,nco2eq) /
   n2o . n2o_co2eq
   ch4 . ch4_co2eq
   fgas. fgas_co2eq
/ ;

parameters co2_mtoe(f0) "Standard emissions coefficients" /
coa     3.881135
oil     3.03961
gas     2.22606
p_c     2.89167
gdt     2.22606
/ ;

set lg "Labor sets in the GIDD database" /
      nsk      "Unskilled labor"
      skl      "Skilled labor"
/ ;

set lgg "Labor sets in the GIDD gender database" /
      f_nsk      "Unskilled female labor"
      f_skl      "Skilled female labor"
      m_nsk      "Unskilled male labor"
      m_skl      "Skilled male labor"
/ ;

set z Zones /
   rur   "Agricultural sectors"
   urb   "Non-agricultural sectors"
   nsg   "Non-segmented labor markets"
/ ;

set rur(z) "Rural zone" /
   rur         "Rural zone"
/ ;

set urb(z) "Urban zone" /
   urb         "Urban zone"
/ ;

set nsg(z) "Both zones" /
   nsg         "Non-segmented labor markets"
/ ;

set stdlab  "Standard SAM labels" /
   regY           "Regional household"
   hhd            "Household"
   gov            "Government"
$iftheni "%ifR_D%" == "ON"
   r_d            "Research and development"
$endif
$iftheni "%ifIFI%" == "ON"
   ifi            "International financial institutions"
$endif
   inv            "Investment"
   deprY          "Depreciation"
   tmg            "Trade margins"
   itax           "Indirect tax"
   ptax           "Production tax"
   mtax           "Import tax"
   etax           "Export tax"
   vtax           "Taxes on factors of production"
   ltax           "Taxes on labor use"
   ktax           "Taxes on capital use"
   rtax           "Taxes on natural resource use"
   vsub           "Subsidies on factors of production"
   wtax           "Waste tax"
   dtax           "Direct taxation"
   ctax           "Carbon tax"
   ntmY           "NTM revenues"
   trd            "Trade account"
   bop            "Balance of payments account"
   tot            "Total for row/column sums"
/ ;

set fd(stdlab) "Domestic final demand agents" /

   hhd            "Household"
   gov            "Government"
$iftheni "%ifR_D%" == "ON"
   r_d            "Research and development"
$endif
$iftheni "%ifIFI%" == "ON"
   ifi            "International financial institutions"
$endif
   inv            "Investment"
   tmg            "Trade margins"

/ ;

set h(fd) "Households" /
   hhd            "Household"
/ ;

set gov(fd) "Government" /
   gov            "Government"
/ ;

$iftheni "%ifR_D%" == "ON"
set r_d(fd) "Research and development" /
   r_d            "Research and development"
/ ;
$endif

$iftheni "%ifIFI%" == "ON"
set ifi(fd) "International financial institutions" /
   ifi            "International financial institutions"
/ ;
$endif

set inv(fd) "Investment"/
   inv            "Investment"
/ ;

set tmg(fd) "Domestic supply of trade margins services" /
   tmg            "Trade margins"
/ ;

* --------------------------------------------------------------------------------------------------
*
*  Mapping of SSP countries to GTAP regions
*
* --------------------------------------------------------------------------------------------------

set c "Countries" /

   AUS     "Australia"
   NZL     "New Zealand"
   ASM     "American Samoa"
   COK     "Cook Islands, The"
   FJI     "Fiji, The Republic of"
   PYF     "French Polynesia"
   GUM     "Guam"
   KIR     "Kiribati, The Republic of"
   MHL     "Marshall Islands, The Republic of the"
   FSM     "Micronesia, The Federated States of"
   NRU     "Nauru, The Republic of"
   NCL     "New Caledonia"
   NIU     "Niue"
   MNP     "Northern Mariana Islands, The Commonwealth of the"
   PLW     "Palau, The Republic of"
   PNG     "Papua New Guinea, The Independent State of"
   WSM     "Samoa, The Independent State of"
   SLB     "Solomon Islands"
   TKL     "Tokelau"
   TON     "Tonga, The Kingdom of"
   TUV     "Tuvalu"
   VUT     "Vanuatu, The Republic of"
   WLF     "Wallis and Futuna Islands"
   CHN     "China, The People's Republic of"
   HKG     "Hong Kong Special Administrative Region of China, The"
   JPN     "Japan"
   KOR     "Korea, The Republic of"
   MNG     "Mongolia"
   TWN     "Taiwan Province of China"
   MAC     "Macao Special Administrative Region of China"
   PRK     "Korea, The Democratic People's Republic of"
   BRN     "Brunei Darussalam"
   KHM     "Cambodia, The Kingdom of"
   IDN     "Indonesia, The Republic of"
   LAO     "Lao People's Democratic Republic, The"
   MYS     "Malaysia"
   PHL     "Philippines, The Republic of the"
   SGP     "Singapore, The Republic of"
   THA     "Thailand, The Kingdom of"
   VNM     "Viet Nam, The Socialist Republic of"
   MMR     "Myanmar, The Republic of the Union of"
   TLS     "Timor-Leste, The Democratic Republic of"
   BGD     "Bangladesh, The People's Republic of"
   IND     "India, The Republic of"
   NPL     "Nepal, The Federal Democratic Republic of"
   PAK     "Pakistan, The Islamic Republic of"
   LKA     "Sri Lanka, The Democratic Socialist Republic of"
   AFG     "Afghanistan, The Islamic Republic of"
   BTN     "Bhutan, The Kingdom of"
   MDV     "Maldives, The Republic of"
   CAN     "Canada"
   USA     "United States of America, The"
   MEX     "United Mexican States, The"
   BMU     "Bermuda"
   GRL     "Greenland"
   SPM     "Saint Pierre and Miquelon"
   ARG     "Argentine Republic, The"
   BOL     "Bolivia, The Plurinational State of"
   BRA     "Brazil, The Federative of Brazil"
   CHL     "Chile, The Republic"
   COL     "Colombia, The Republic of"
   ECU     "Ecuador, The Republic of"
   PRY     "Paraguay, The Republic of"
   PER     "Peru, The Republic of"
   URY     "Uruguay, The Eastern Republic of"
   VEN     "Venezuela, The Bolivarian Republic of"
   FLK     "Falkland Islands (Malvinas), The"
   GUF     "French Guiana"
   GUY     "Guyana, The Republic of"
   SUR     "Suriname, The Republic of"
   CRI     "Costa Rica, The Republic of"
   GTM     "Guatemala, The Republic of"
   HND     "Honduras, The Republic of"
   NIC     "Nicaragua, The Republic of"
   PAN     "Panama, The Republic of"
   SLV     "El Salvador, The Republic of"
   BLZ     "Belize"
   DOM     "Dominican Republic, The"
   JAM     "Jamaica"
   PRI     "Puerto Rico"
   TTO     "Trinidad and Tobago, The Republic of"
   AIA     "Anguilla"
   ATG     "Antigua and Barbuda"
   ABW     "Aruba"
   ANT     "Netherland Antilles"
   BHS     "Bahamas, The Commonwealth of the"
   BRB     "Barbados"
   VGB     "British Virgin Islands, The"
   CYM     "Cayman Islands, The"
   CUB     "Cuba, The Republic of"
   DMA     "Dominica, The Commonwealth of"
   GRD     "Grenada"
   HTI     "Haiti, The Republic of"
   MSR     "Montserrat"
   KNA     "Saint Kitts and Nevis"
   LCA     "Saint Lucia"
   VCT     "Saint Vincent and the Grenadines"
   TCA     "Turks and Caicos Islands, The"
   VIR     "Virgin Islands of the United States, The"
   AUT     "Austria, The Republic of"
   BEL     "Belgium, The Kingdom of"
   CYP     "Cyprus, The Republic of"
   CZE     "Czech Republic, The"
   DNK     "Denmark, The Kingdom of"
   EST     "Estonia, The Republic of"
   FIN     "Finland, The Republic of"
   FRA     "French Republic, The"
   GLP     "Guadeloupe"
   MTQ     "Martinique"
   REU     "Réunion"
   DEU     "Germany, The Federal Republic of"
   GRC     "Hellenic Republic, The"
   HUN     "Hungary"
   IRL     "Ireland"
   ITA     "Italy, The Republic of"
   LVA     "Latvia, The Republic of"
   LTU     "Lithuania, The Republic of"
   LUX     "Luxembourg, The Grand Duchy of"
   MLT     "Malta, The Republic of"
   NLD     "Netherlands, The Kingdom of the"
   POL     "Poland, The Republic of"
   PRT     "Portuguese Republic, The"
   SVK     "Slovak Republic, The"
   SVN     "Slovenia, The Republic of"
   ESP     "Spain, The Kingdom of"
   SWE     "Sweden, The Kingdom of"
   GBR     "United Kingdom of Great Britain and Northern Ireland, The"
   CHE     "Swiss Confederation, The"
   NOR     "Norway, The Kingdom of"
   ISL     "Iceland, The Republic of"
   LIE     "Liechtenstein, The Principality of"
   ALB     "Albania, The Republic of"
   BGR     "Bulgaria, The Republic of Bulgaria"
   BLR     "Belarus, The Republic of"
   HRV     "Croatia, The Republic of"
   ROU     "Romania"
   RUS     "Russian Federation, The"
   UKR     "Ukraine"
   MDA     "Moldova, The Republic of"
   AND     "Andorra, The Principality of"
   BIH     "Bosnia and Herzegovina"
   CHI     "Channel Islands"
   FRO     "Faeroe Islands, The"
   GIB     "Gibraltar"
   VAT     "Holy See, The"
   IMN     "Isle of Man"
   MKD     "Macedonia, The Former Yugoslav Republic of"
   MCO     "Monaco, The Principality of"
   MNE     "Montenegro"
   SMR     "San Marino, The Republic of"
   SRB     "Serbia, The Republic of"
   UVK     "Kosovo"
   KAZ     "Kazakhstan, The Republic of"
   KGZ     "Kyrgyz Republic,The"
   TJK     "Tajikistan, The Republic of"
   TKM     "Turkmenistan"
   UZB     "Uzbekistan, The Republic of"
   ARM     "Armenia, The Republic of"
   AZE     "Azerbaijan, The Republic of"
   GEO     "Georgia"
   BHR     "Bahrain, The Kingdom of"
   IRN     "Iran, The Islamic Republic of"
   ISR     "Israel, The State of"
   JOR     "Jordan, The Hashemite Kingdom of"
   KWT     "Kuwait, The State of"
   OMN     "Oman, The Sultanate of"
   QAT     "Qatar, The State of"
   SAU     "Saudi Arabia, The Kingdom of"
   TUR     "Turkey, The Republic of"
   ARE     "United Arab Emirates, The"
   IRQ     "Iraq, The Republic of"
   LBN     "Lebanese Republic, The"
   PSE     "Palestine, The State of"
   SYR     "Syrian Arab Republic, The"
   YEM     "Yemen, The Republic of"
   EGY     "Egypt, The Arab Republic of"
   MAR     "Morocco, The Kingdom of"
   TUN     "Tunisia, The Republic of"
   DZA     "Algeria, The People's Democratic Republic of"
   LBY     "Libya"
   ESH     "Western Sahara"
   BEN     "Benin, The Republic of"
   BFA     "Burkina Faso"
   CMR     "Cameroon, The Republic"
   CIV     "Côte d'Ivoire, The Republic of"
   GHA     "Ghana, The Republic of"
   GIN     "Guinea, The Republic of"
   NGA     "Nigeria, The Federal Republic of"
   SEN     "Senegal, The Republic of"
   TGO     "Togolese Republic, The"
   CPV     "Cabo Verde, The Republic of"
   GMB     "Gambia, The Republic of the"
   GNB     "Guinea-Bissau, The Republic of"
   LBR     "Liberia, The Republic of"
   MLI     "Mali, The Republic of"
   MRT     "Mauritania, The Islamic Republic of"
   NER     "Niger, The Republic of the"
   SHN     "Saint Helena, Ascension and Tristan da Cunha"
   SLE     "Sierra Leone, The Republic of"
   CAF     "Central African Republic, The"
   TCD     "Chad, The Republic of"
   COG     "Congo, The Republic of the"
   GNQ     "Equatorial Guinea, The Republic of"
   GAB     "Gabonese Republic, The"
   STP     "Sao Tome and Principe, The Democratic Republic of"
   AGO     "Angola, The Republic of"
   COD     "Congo, The Democratic Republic of the"
   ETH     "Ethiopia, The Federal Democratic Republic of"
   KEN     "Kenya, The Republic of"
   MDG     "Madagascar, The Republic of"
   MWI     "Malawi, The Republic of"
   MUS     "Mauritius, The Republic of"
   MOZ     "Mozambique, The Republic of"
   RWA     "Rwanda, The Republic of"
   TZA     "Tanzania, The United Republic of"
   UGA     "Uganda, The Republic of"
   ZMB     "Zambia, The Republic of"
   ZWE     "Zimbabwe, The Republic of"
   BDI     "Burundi, The Republic of"
   COM     "Comoros, The Union of the"
   DJI     "Djibouti, The Republic of"
   ERI     "Eritrea, The State of"
   MYT     "Mayotte"
   SYC     "Seychelles, The Republic of"
   SOM     "Somalia, The Federal Republic of"
   SDN     "Sudan, The Republic of the"
   SSD     "South Sudan"
   BWA     "Botswana, The Republic of"
   NAM     "Namibia, The Republic of"
   ZAF     "South Africa, The Republic of"
   LSO     "Lesotho, The Kingdom of"
   SWZ     "Swaziland, The Kingdom of"

/ ;

set mapc(reg,c) "GTAP mapping" /

   AUS.AUS
*  AUS.CXR
*  AUS.CCK
*  AUS.HMD
*  AUS.NFK
   NZL.NZL
   XOC.ASM
   XOC.COK
   XOC.FJI
   XOC.PYF
   XOC.GUM
   XOC.KIR
   XOC.MHL
   XOC.FSM
   XOC.NRU
   XOC.NCL
   XOC.MNP
   XOC.NIU
   XOC.PLW
   XOC.PNG
   XOC.WSM
   XOC.SLB
   XOC.TKL
   XOC.TON
   XOC.TUV
   XOC.VUT
   XOC.WLF
   CHN.CHN
   HKG.HKG
   JPN.JPN
   KOR.KOR
   MNG.MNG
   TWN.TWN
   XEA.MAC
   XEA.PRK
   BRN.BRN
   KHM.KHM
   IDN.IDN
   LAO.LAO
   MYS.MYS
   PHL.PHL
   SGP.SGP
   THA.THA
   VNM.VNM
   XSE.MMR
   XSE.TLS
   BGD.BGD
   IND.IND
   NPL.NPL
   PAK.PAK
   LKA.LKA
   XSA.AFG
   XSA.BTN
   XSA.MDV
   CAN.CAN
   USA.USA
   MEX.MEX
   XNA.BMU
   XNA.GRL
   XNA.SPM
   ARG.ARG
   BOL.BOL
   BRA.BRA
   CHL.CHL
   COL.COL
   ECU.ECU
   PRY.PRY
   PER.PER
   URY.URY
   VEN.VEN
   XSM.FLK
   XSM.GUF
   XSM.GUY
   XSM.SUR
   CRI.CRI
   GTM.GTM
   HND.HND
   NIC.NIC
   PAN.PAN
   SLV.SLV
   XCA.BLZ
   DOM.DOM
   JAM.JAM
   PRI.PRI
   TTO.TTO
   XCB.AIA
   XCB.ATG
   XCB.ABW
   XCB.BHS
   XCB.BRB
   XCB.CYM
   XCB.CUB
   XCB.DMA
   XCB.GRD
   XCB.HTI
   XCB.MSR
   XCB.ANT
   XCB.KNA
   XCB.LCA
   XCB.VCT
   XCB.TCA
   XCB.VGB
   XCB.VIR
   AUT.AUT
   BEL.BEL
   CYP.CYP
   CZE.CZE
   DNK.DNK
   EST.EST
   FIN.FIN
   FRA.FRA
   FRA.MTQ
   FRA.GLP
   DEU.DEU
   GRC.GRC
   HUN.HUN
   IRL.IRL
   ITA.ITA
   LVA.LVA
   LTU.LTU
   LUX.LUX
   MLT.MLT
   NLD.NLD
   POL.POL
   PRT.PRT
   SVK.SVK
   SVN.SVN
   ESP.ESP
   SWE.SWE
   GBR.GBR
   GBR.CHI
   GBR.IMN
   CHE.CHE
   NOR.NOR
   XEF.ISL
   XEF.LIE
   ALB.ALB
   BGR.BGR
   BLR.BLR
   HRV.HRV
   ROU.ROU
   RUS.RUS
   UKR.UKR
   XEE.MDA
   XER.AND
   XER.BIH
   XER.FRO
   XER.GIB
*  XER.GGY
   XER.VAT
*  XER.JEY
*  XER.KSV
   XER.MKD
   XER.MCO
   XER.MNE
   XER.SMR
   XER.SRB
   XER.UVK
   KAZ.KAZ
   KGZ.KGZ
   TJK.TJK
   XSU.TKM
   XSU.UZB
   ARM.ARM
   AZE.AZE
   GEO.GEO
   BHR.BHR
   IRN.IRN
   ISR.ISR
   JOR.JOR
   KWT.KWT
   OMN.OMN
   QAT.QAT
   SAU.SAU
   TUR.TUR
   ARE.ARE
   XWS.IRQ
   XWS.LBN
   XWS.PSE
   XWS.SYR
   XWS.YEM
   EGY.EGY
   MAR.MAR
   TUN.TUN
   XNF.DZA
   XNF.LBY
   XNF.ESH
   BEN.BEN
   BFA.BFA
   CMR.CMR
   CIV.CIV
   GHA.GHA
   GIN.GIN
   NGA.NGA
   SEN.SEN
   TGO.TGO
   XWF.CPV
   XWF.GMB
   XWF.GNB
   XWF.LBR
   XWF.MLI
   XWF.MRT
   XWF.NER
   XWF.SHN
   XWF.SLE
   XCF.CAF
   XCF.TCD
   XCF.COG
   XCF.GNQ
   XCF.GAB
   XCF.STP
   XAC.AGO
   XAC.COD
   ETH.ETH
   KEN.KEN
   MDG.MDG
   MWI.MWI
   MUS.MUS
   MOZ.MOZ
   TZA.TZA
   RWA.RWA
   UGA.UGA
   ZMB.ZMB
   ZWE.ZWE
   XEC.BDI
   XEC.COM
   XEC.DJI
   XEC.ERI
   XEC.MYT
   XEC.REU
   XEC.SYC
   XEC.SOM
   XEC.SDN
   XEC.SSD
   BWA.BWA
   NAM.NAM
   ZAF.ZAF
   XSC.LSO
   XSC.SWZ
*  XTW.ATA
*  XTW.BVT
*  XTW.IOT
*  XTW.ATF
/ ;

* --------------------------------------------------------------------------------------------------
*
*     Additions for AEZ database
*
* --------------------------------------------------------------------------------------------------

sets
   aez0     /
      AEZ1           "Tropical and arid LGP000_060"
      AEZ2           "Tropical and dry semi-arid LGP060_119"
      AEZ3           "Tropical and moist semi-arid LGP120_179"
      AEZ4           "Tropical and sub-humid LGP180_239"
      AEZ5           "Tropical and humid LGP240_299"
      AEZ6           "Tropical and humid; year round growing season LGP300PLUS"
      AEZ7           "Temperate and arid LGP000_060"
      AEZ8           "Temperate and dry semi-arid LGP060_119"
      AEZ9           "Temperate and moist semi-arid LGP120_179"
      AEZ10          "Temperate and sub-humid LGP180_239"
      AEZ11          "Temperate and humid LGP240_299"
      AEZ12          "Temperate and humid; year round growing season LGP300PLUS"
      AEZ13          "Boreal and arid LGP000_060"
      AEZ14          "Boreal and dry semi-arid LGP060_119"
      AEZ15          "Boreal and moist semi-arid LGP120_179"
      AEZ16          "Boreal and sub-humid LGP180_239"
      AEZ17          "Boreal and humid LGP240_299"
      AEZ18          "Boreal and humid; year round growing season LGP300PLUS"
   /
   LCOVER_TYPE Land cover type /
      Forest         "Forest (accesible only)"
      SavnGrasslnd   "Savanna and grass land"
      Shrubland      "Shrub land"
      Cropland       "Crop land"
      Pastureland    "Pasture land"
      Builtupland    "Built-up land"
      Otherland      "All other land"
   /
   rum0(alv0) "Ruminants" /
      ctl   "Bovine cattle, sheep and goats, horses"
*     oap   "Animal products n.e.s."
      rmk   "Raw milk"
      wol   "Wool, silk-worm cocoons"
   /
   fpa0 "Set of endowment factors associated with the AEZ" /
      set.aez0
      unSkLab     "Unskilled labor"
      SkLab       "Skilled labor"
      Capital     "Capital"
      NatlRes     "Natural resources"
   /
;

$offempty
