$setGlobal ifTFP     0

put screen ; put screen / ;
scalar ifmcsv / 1 / ;

set
   rs(r)
   ts(t)
;

alias(r,s) ; alias(r,d) ;

parameters
   gap(t)      "Time step"
   year0       "First year"
   yearE       "Year equilibrium is assumed"
   year1       "First simulation year"
   years(tt)   "Year values"
;

year0 = smin(t, t.val) ;
years(tt) = tt.val ;
t0(t)$(years(t) eq year0) = yes ;
singleton set t00(t) ; t00(t)$t0(t) = yes ;

loop(t$te(t), yearE = years(t) ; ) ;
loop(t$(not t0(t)),
   gap(t) = years(t) - years(t-1) ;
) ;
loop((t,t0)$(years(t)-years(t0) = gap(t)),
   year1 = years(t) ;
) ;
display years, yearE, year1, gap, year0 ;

* --------------------------------------------------------------------------------------------------
*
*     Prepare the data
*
* --------------------------------------------------------------------------------------------------

set is "SAM Labels" /
   act   "Activities"
   com   "Commodities"
   lab   "Labor"
   cap   "Capital"
   itx   "Indirect taxes"
   ptx   "Production taxes"
   etx   "Export taxes"
   mtx   "Import taxes"
   hhd   "Households"
   gov   "Government"
   inv   "Investment"
   row   "Rest of the world"
/ ;
alias(is,js) ;

Parameters
   popT(r, tranche, tssp)        "SSP-based population profiles"
   GDPT(r, tssp)                 "SSP-based GDP profiles"
   GDPpcT(r, tssp)               "SSP-based GDP per capita profiles"
;

scalars
   pscale   "Population scale factor"  / 1e-9 /
   yscale   "GDP scale factor"         / 1e-12 /
   gscale   "GTAP scale factor"        / 1e-6 /
;

Parameters
   tlab0(r)       "GTAP labor remuneration"
   tcap0(r)       "GTAP capital remuneration"
   gdpfc0(r)      "GTAP GDP at factor cost excl. indirect taxes"
   cons0(r)       "GTAP private consumption"
   gov0(r)        "GTAP public expenditure"
   inv0(r)        "GTAP investment expenditure"
   exp0(r)        "GTAP exports at FOB price incl. trade&transport services"
   imp0(r)        "GTAP imports at CIF price"
   gdp0(r)        "GTAP GDP at market price"
   abs0(r)        "Domestic absorption"
   ptax0(r)       "Production taxes"
   itax0(r)       "Indirect taxes on final demand"
   mtax0(r)       "Import taxes"
   etax0(r)       "Export taxes"
   save0(r)       "National savings"
   savf0(r)       "Capital account balance"

   yqtf0(r)       "Domestic profits accruing to global trust"
   trustY0        "Total cross border profit flows"
   yqht0(r)       "Receipt of foreign profits"
   remit0(s,r)    "Labor income in r remitted to s"
   ODAOut0(r)     "Outbound ODA"
   ODAIn0(r)      "Inbound ODA"
   ODAGbl0        "Total ODA"

   sam0(r,is,js)  "Initial SAM"

   kstock0(r)     "Capital stock"

   consshr0(r)    "Consumption share in absorption"
   govshr0(r)     "Government share in absorption"
   invShr0(r)     "Investment share in absorption"
   expshr0(r)     "Export share in GDP"
   impshr0(r)     "Import share in GDP"
   labShr0(r)     "Labor share in value added"
   capShr0(r)     "Capital share in value added"
   k_yRatio0(r)   "Capital output ratio"
;

tlab0(r)   = gscale*sum((l,a), evfb1(l,a,r)) ;
tcap0(r)   = gscale*sum((fp,a)$(not l(fp)), evfb1(fp,a,r)) ;
ptax0(r)   = gscale*(sum((l,a), evfp1(l,a,r) - evfb1(l,a,r))
           +         sum((fp,a)$(not l(fp)), evfp1(fp,a,r) - evfb1(fp,a,r))
           +         sum((i,a), vdfp1(i,a,r) + vmfp1(i,a,r) - vdfb1(i,a,r) - vmfb1(i,a,r))
           +         sum((a,i), makb1(i,a,r) - maks1(i,a,r)))
           ;

gdpfc0(r)  = tlab0(r) + tcap0(r) ;
cons0(r)   = gscale*sum((i),  vdpp1(i,r) + vmpp1(i,r)) ;
gov0(r)    = gscale*sum((i),  vdgp1(i,r) + vmgp1(i,r)) ;
inv0(r)    = gscale*sum((i),  vdip1(i,r) + vmip1(i,r)) ;
itax0(r)   = gscale*(sum((i), vdpp1(i,r) + vmpp1(i,r) - vdpb1(i,r) - vmpb1(i,r))
           +         sum((i), vdgp1(i,r) + vmgp1(i,r) - vdgb1(i,r) - vmgb1(i,r))
           +         sum((i), vdip1(i,r) + vmip1(i,r) - vdib1(i,r) - vmib1(i,r)))
           ;

$iftheni.BoP "%BoP%" == "ON"
   yqtf0(r)    = gscale*yqtf1(r) ;
   yqht0(r)    = gscale*yqht1(r) ;
   remit0(s,r) = gscale*sum(l, remit1(l,s,r)) ;

   ODAOut0(r)  = gscale*ODAOut1(r) ;
   ODAIn0(r)   = gscale*ODAIn1(r) ;
$else.BoP
   yqtf0(r)    = 0 ;
   yqht0(r)    = 0 ;
   remit0(s,r) = 0 ;
   ODAOut0(r)  = 0 ;
   ODAIn0(r)   = 0 ;
$endif.BoP

trustY0      = sum(r, yqtf0(r)) ;
ODAGbl0      = sum(r, ODAOut0(r)) ;

exp0(r)    = gscale*(sum((i,d), vfob1(i,r,d)) + sum((i), vst1(i,r))) ;
etax0(r)   = gscale*(sum((i,d), vfob1(i,r,d) - vxsb1(i,r,d))) ;
imp0(r)    = gscale*sum((i,s), vcif1(i,s,r)) ;
mtax0(r)   = gscale*sum((i,s), vmsb1(i,s,r) - vcif1(i,s,r)) ;
abs0(r)    = cons0(r) + gov0(r) + inv0(r) ;
gdp0(r)    = abs0(r) + exp0(r) - imp0(r) ;
savf0(r)   = imp0(r) - exp0(r)
           + yqtf0(r) - yqht0(r)
           + sum(s, remit0(s,r)) - sum(s, remit0(r,s))
           + odaOut0(r) - ODAIn0(r) ;
save0(r)   = inv0(r) - savf0(r) ;
kstock0(r) = gscale*(vkb1(r)) ;

* display tlab0, tcap0, cons0, gov0, inv0, exp0, imp0, abs0, gdp0, kstock0 ;

labShr0(r)   = tlab0(r) / gdpfc0(r) ;
capShr0(r)   = tcap0(r) / gdpfc0(r) ;
consShr0(r)  = cons0(r) / abs0(r) ;
govShr0(r)   = gov0(r) / abs0(r) ;
invShr0(r)   = inv0(r) / abs0(r) ;
k_yRatio0(r) = kstock0(r) / gdp0(r) ;

expshr0(r)   = exp0(r)/gdp0(r) ;
impshr0(r)   = imp0(r)/gdp0(r) ;

sam0(r,"Lab","Act") = tlab0(r) ;
sam0(r,"Cap","Act") = tcap0(r) ;
sam0(r,"ptx","Act") = ptax0(r) ;
sam0(r,"Act","Com") = tlab0(r) + tcap0(r) + ptax0(r) ;
sam0(r,"itx","Com") = itax0(r) ;
sam0(r,"etx","Com") = etax0(r) ;
sam0(r,"mtx","Com") = mtax0(r) ;
sam0(r,"row","Com") = imp0(r) ;
sam0(r,"hhd","lab") = tlab0(r) - sum(s, remit0(s,r)) ;
sam0(r,"row","lab") = sum(s, remit0(s,r)) ;
sam0(r,"hhd","cap") = tcap0(r) - yqtf0(r) ;
sam0(r,"hhd","ptx") = ptax0(r) ;
sam0(r,"hhd","itx") = itax0(r) ;
sam0(r,"hhd","etx") = etax0(r) ;
sam0(r,"hhd","mtx") = mtax0(r) ;
sam0(r,"hhd","row") = yqht0(r) + sum(s, remit0(r,s)) + ODAIn0(r) ;
sam0(r,"row","HHD") = ODAOut0(r) ;
sam0(r,"row","cap") = yqtf0(r) ;
sam0(r,"com","hhd") = cons0(r) + gov0(r) ;
sam0(r,"com","inv") = inv0(r) ;
sam0(r,"com","row") = exp0(r) ;
sam0(r,"inv","hhd") = save0(r) ;
sam0(r,"inv","row") = imp0(r) - exp0(r)
                    + yqtf0(r) - yqht0(r)
                    + sum(s, remit0(s,r)) - sum(s, remit0(r,s))
                    + ODAOut0(r) - ODAIn0(r) ;

put msamcsv ;
if(ifmcsv,
   put "SSP,Mod,Region,RLab,CLab,Year,Value" / ;
   msamcsv.pc=5 ;
   msamcsv.nd=9 ;

   loop((r,is,js)$sam0(r,is,js),
      put "SSP2", "OECD", r.tl, is.tl, js.tl, 0:4:0, (sam0(r,is,js)/gscale) / ;
   ) ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Declare model variables, parameters and equations
*
* --------------------------------------------------------------------------------------------------

variables
*  Endogenous variables

   wage(r,t)            "Wage rate"
   rent(r,t)            "Rental rate"
   x(r,t)               "Gross output"

   taxrev(r,t)          "Aggregate tax revenues"
   yqtfv(r,t)           "Domestic profits accruing to global trust"
   trustY(t)            "Total cross border profit flows"
   yqhtv(r,t)           "Receipt of foreign profits"
   remitv(s,r,t)        "Remitances in r transferred to s"
   ODAOutv(r,t)         "Outbound ODA"
   ODAInv(r,t)          "Inbound ODA"
   ODAGbl(t)            "Total ODA"

   yh(r,t)              "Household income"

   htax(r,t)            "Direct tax on households"
   cons(r,t)            "Household consumption"
   govt(r,t)            "Government consumption"
   chig(r,t)            "Government expenditure as a share of real GDP"
   savg(r,t)            "Government savings"
   chis(r,t)            "Government savings as a share nominal GDP"

   invt(r,t)            "Investment level"
   aps(r,t)             "Savings rate"
   xa(r,t)              "Domestic absorption"

   xd(r,t)              "Domestic absorption of domestically goods"
   xm(r,t)              "Imports"
   pa(r,t)              "Armington price tax inclusive"

   pd(r,t)              "Price of domestic goods"
   xe(r,t)              "Exports"
   px(r,t)              "Unit cost"

   pe(r,t)              "Export price in LCU tax exclusive"
   pm(r,t)              "CIF Import price in LCU"

   kap(r,t)             "Capital stock"

   gdp(r,t)             "Nominal GDP"
   rgdp(r,t)            "Real GDP"
   pgdp(r,t)            "GDP price deflator"

   walras(r,t)          "Walras' law"
   obj                  "Objective function"

*  Closure variables

   tfp(r,t)             "TFP"
   lambdal(r,t)         "Labor-biased technical change"
   lambdak(r,t)         "Capital-biased technical change"

*  Numéraire and exogenous prices

   p(r,t)               "Output price"
   exr(r,t)             "Exchange rate"
   pwe(r,t)             "Export price in FCU"
   pwm(r,t)             "Import price in FCU"
   pwebar(r,t)          "Export price index"
   pwmbar(r,t)          "Import price index"

*  Exogenous variables

   tlab(r,t)            "Labor supply"
   savf(r,t)            "Foreign savings"

   ptx(r,t)             "Output tax"
   itx(r,t)             "Sales tax"
   mtx(r,t)             "Import tax"
   etx(r,t)             "Export tax"
;

Parameters
   alphal(r,t)          "Labor share parameter"
   alphak(r,t)          "Capital share parameter"
   sigma(r,t)           "Capital-labor substitution elasticity"

   chik(r,t)            "Share of domestic profits flowing to RoW"
   chit(r,t)            "Share of global cross border profit flows accruing to region r"
   chiRemit(s,r,t)      "Share of region r's labor income remitted to s"

   chiODAOut(r,t)       "Initial share of ODA wrt to GDP"
   chiODAIn(r,t)        "Inbound share of global ODA"
   etaODA(r,t)          "Elasticity of ODA donation wrt to per capita income"

   alphad(r,t)          "Armington domestic share parameter"
   alpham(r,t)          "Armington import share parameter"
   gammad(r,t)          "Output domestic share parameter"
   gammae(r,t)          "Output export share parameter"
   chim(r,t)            "Import supply shifter"
   chie(r,t)            "Export supply shifter"

   sigmat(r,t)          "Armington CES elasticity"
   omega(r,t)           "Output CET elasticity"

   etam(r,t)            "Import supply elasticity"
   etae(r,t)            "Export demand elasticity"

   depr(r,t)            "Annual depreciation rate"
   popw(r,t)            "Population"
;

equations
   wageeq(r,t)          "Labor demand equation"
   renteq(r,t)          "Capital demand equation"
   xeq(r,t)             "Output equation"

   ODAOuteq(r,t)    "Outbound ODA"
   ODAIneq(r,t)     "Inbound ODA"
   ODAGbleq(t)      "Total ODA"

   taxreveq(r,t)        "Tax revenues"
   yqtfeq(r,t)          "Domestic profits accruing to global trust"
   trustYeq(t)          "Total cross border profit flows"
   yqhteq(r,t)          "Receipt of foreign profits"
   remiteq(s,r,t)       "Remittances from r to s"
   yheq(r,t)            "Household income"
   peq(r,t)             "Price of gross GDP"

   conseq(r,t)          "Household consumption"
   goveq(r,t)           "Government expenditures"
   savgeq(r,t)          "Government savings"
   htaxeq(r,t)          "Fiscal closure equation"
   inveq(r,t)           "Investment equation"
   xaeq(r,t)            "Armington demand"

   xddeq(r,t)           "Demand for domestic goods"
   xmdeq(r,t)           "Demand for imports"
   paeq(r,t)            "Armington price"

   xdseq(r,t)           "Supply of domestic goods, i.e. pd"
   xeseq(r,t)           "Supply of exports"
   pxeq(r,t)            "Price of net output"

   peeq(r,t)            "Price of exports"
   pmeq(r,t)            "Price of imports"

   apseq(r,t)           "Average propensity to consume"
   capeq(r,t)           "Capital motion equation"

   gdpeq(r,t)           "Nominal GDP"
   rgdpeq(r,t)          "Real GDP"
   pgdpeq(r,t)          "GDP price deflator"

   walraseq(r,t)        "Walras' Law"
   objeq                "Objective function"
;

wageeq(r,t)$(rs(r) and ts(t))..
   tlab(r,t)*wage(r,t)**sigma(r,t) =e=
         alphal(r,t)*((tfp(r,t)*lambdal(r,t))**(sigma(r,t)-1))*x(r,t)*px(r,t)**sigma(r,t) ;

renteq(r,t)$(rs(r) and ts(t))..
   kap(r,t)*rent(r,t)**sigma(r,t) =e=
         alphak(r,t)*((tfp(r,t)*lambdak(r,t))**(sigma(r,t)-1))*x(r,t)*px(r,t)**sigma(r,t) ;

xeq(r,t)$(rs(r) and ts(t))..
$iftheni %ifDual% == 1
   px(r,t) =e= ((1/tfp(r,t))*(alphal(r,t)*(wage(r,t)/lambdal(r,t))**(1-sigma(r,t))
            +               alphak(r,t)*(rent(r,t)/lambdak(r,t))**(1-sigma(r,t)))
            **  (1/(1-sigma(r,t))))
            $(sigma(r,t) ne 1)
            +  ((1/tfp(r,t))*(((wage(r,t)/(alphal(r,t)*lambdal(r,t)))**alphal(r,t))
            *               ((rent(r,t)/(alphak(r,t)*lambdak(r,t)))**alphak(r,t))))
            $(sigma(r,t) eq 1)
            ;
$else
   $$macro rhoexp(sigma,r,t)  ((sigma(r,t)-1)/sigma(r,t))
   x(r,t) =e= (tfp(r,t)*((alphal(r,t)**(1/sigma(r,t)))*(lambdal(r,t)*tlab(r,t))**rhoexp(sigma,r,t)
           +           (alphak(r,t)**(1/sigma(r,t)))*(lambdak(r,t)*kap(r,t))**rhoexp(sigma,r,t))
           **  (1/rhoexp(sigma,r,t)))
           $(sigma(r,t) ne 1)
           +  (tfp(r,t)*((lambdal(r,t)*tlab(r,t))**alphal(r,t))
           *          ((lambdak(r,t)*kap(r,t))**alphak(r,t)))
           $(sigma(r,t) eq 1)
           ;
$endif

peq(r,t)$(rs(r) and ts(t))..
   p(r,t) =e= px(r,t)*(1+ptx(r,t)) ;

taxreveq(r,t)$(rs(r) and ts(t))..
   taxrev(r,t) =e= ptx(r,t)*px(r,t)*x(r,t)
                +  itx(r,t)*pa(r,t)*xa(r,t)/(1+itx(r,t))
                +  mtx(r,t)*pm(r,t)*xm(r,t)
                +  etx(r,t)*pe(r,t)*xe(r,t)
                +  htax(r,t)*yh(r,t)
                ;

*  Outflow of capital income

yqtfeq(r,t)$(rs(r) and ts(t) and yqtf0(r))..
   yqtfv(r,t) =e= chik(r,t) * kap(r,t) * rent(r,t) ;
yqtfv.fx(r,t)$(yqtf0(r) eq 0) = 0 ;

*  Total outflows of capital income

trustYeq(t)$(ts(t) and trustY0)..
   trustY(t) =e= sum(r, yqtfv(r,t)) ;
trustY.fx(t)$(trustY0 eq 0) = 0 ;

*  Inflow of capital income

yqhteq(r,t)$(rs(r) and ts(t) and yqht0(r))..
   yqhtv(r,t) =e= chiT(r,t)*trustY(t) ;
yqhtv.fx(r,t)$(yqht0(r) eq 0) = 0 ;

remiteq(s,r,t)$(rs(r) and ts(t) and remit0(s,r))..
   remitv(s,r,t) =e= chiRemit(s,r,t) * tlab(r,t) * wage(r,t) ;

remitv.fx(s,r,t)$(remit0(s,r) eq 0) = 0 ;

$macro M_YPC(r,t)  ((rgdp(r,t) / popw(r,t))/ (rgdp(r,t00) / popw(r,t00)))

*  ODA outflows

ODAOuteq(r,t)$(rs(r) and ts(t) and ODAOut0(r))..
   ODAOutv(r,t) =e= chiODAOut(r,t)*GDP(r,t)*M_YPC(r,t)**etaODA(r,t) ;
ODAOutv.fx(r,t)$(ODAOut0(r) eq 0) = 0 ;

*  Total ODA

ODAGbleq(t)$(ts(t) and ODAGbl0)..
   ODAGbl(t) =e= sum(r, ODAOutv(r,t)) ;
ODAGbl.fx(t)$(ODAGbl0 eq 0) = 0 ;

*  ODA inflows

ODAIneq(r,t)$(rs(r) and ts(t) and ODAIn0(r))..
   ODAInv(r,t) =e= chiODAIn(r,t)*ODAGbl(t) ;
ODAInv.fx(r,t)$(ODAIn0(r) eq 0) = 0 ;

yheq(r,t)$(rs(r) and ts(t))..
   yh(r,t) =e= px(r,t)*x(r,t)
            +  yqhtv(r,t) - yqtfv(r,t)
            +  sum(s, remitv(r,s,t)) - sum(s, remitv(s,r,t)) ;

conseq(r,t)$(rs(r) and ts(t))..
   pa(r,t)*cons(r,t) =e= (1-aps(r,t))*yh(r,t)*(1 - htax(r,t)) ;

goveq(r,t)$(rs(r) and ts(t))..
   govt(r,t) =e= chig(r,t)*rgdp(r,t) ;

savgeq(r,t)$(rs(r) and ts(t))..
   savg(r,t) =e= taxrev(r,t) + odaInv(r,t) - pa(r,t)*govt(r,t) - odaOutv(r,t) ;

htaxeq(r,t)$(rs(r) and ts(t))..
   savg(r,t) =e= chis(r,t)*gdp(r,t) ;

inveq(r,t)$(rs(r) and ts(t))..
   pa(r,t)*invt(r,t) =e= aps(r,t)*yh(r,t)*(1 - htax(r,t)) + savg(r,t) + exr(r,t)*savf(r,t) ;

xaeq(r,t)$(rs(r) and ts(t))..
   xa(r,t) =e= cons(r,t) + govt(r,t) + invt(r,t) ;

xddeq(r,t)$(rs(r) and ts(t))..
   xd(r,t) =e= alphad(r,t)*xa(r,t)*(pa(r,t)/((1+itx(r,t))*pd(r,t)))**sigmat(r,t) ;

xmdeq(r,t)$(rs(r) and ts(t) and alpham(r,t) ne 0)..
   xm(r,t) =e= alpham(r,t)*xa(r,t)*(pa(r,t)/((1+itx(r,t))*(1+mtx(r,t))*pm(r,t)))**sigmat(r,t) ;

paeq(r,t)$(rs(r) and ts(t))..
   (pa(r,t)/(1+itx(r,t)))**(1-sigmat(r,t))
      =e= (alphad(r,t)*pd(r,t)**(1-sigmat(r,t))
       +   alpham(r,t)*((1+mtx(r,t))*pm(r,t))**(1-sigmat(r,t)))
       ;

xdseq(r,t)$(rs(r) and ts(t))..
   0 =e= (xd(r,t) - gammad(r,t)*x(r,t)*(pd(r,t)/p(r,t))**omega(r,t))$(omega(r,t) ne inf)
      +  (pd(r,t) - p(r,t))$(omega(r,t) eq inf) ;

xeseq(r,t)$(rs(r) and ts(t) and gammae(r,t) ne 0)..
   0 =e= (xe(r,t) - gammae(r,t)*x(r,t)*(pe(r,t)/p(r,t))**omega(r,t))$(omega(r,t) ne inf)
      +  (pe(r,t) - p(r,t))$(omega(r,t) eq inf) ;

pxeq(r,t)$(rs(r) and ts(t))..
   0 =e= (p(r,t)**(1+omega(r,t)) - (gammad(r,t)*pd(r,t)**(1+omega(r,t))
      +                             gammae(r,t)*pe(r,t)**(1+omega(r,t))))
      $(omega(r,t) ne inf)
      +  (x(r,t) - (xd(r,t) + xe(r,t)))
      $(omega(r,t) eq inf)
      ;

peeq(r,t)$(rs(r) and ts(t) and gammae(r,t) ne 0)..
*  0 =e= (xe(r,t) - chie(r,t)*(exr(r,t)*pwebar(r,t)/((1+etx(r,t))*pe(r,t)))**etae(r,t))
*     $(etae(r,t) ne inf)
   0 =e= (log(xe(r,t)) - (log(chie(r,t)) + etae(r,t)*(log(exr(r,t)*pwebar(r,t))
      -   log((1+etx(r,t))*pe(r,t)))))
      $(etae(r,t) ne inf)
      +  ((1+etx(r,t))*pe(r,t) - exr(r,t)*pwebar(r,t))
      $(etae(r,t) eq inf) ;

pmeq(r,t)$(rs(r) and ts(t) and alpham(r,t) ne 0)..
   0 =e= (xm(r,t) - chim(r,t)*(pm(r,t)/(exr(r,t)*pwmbar(r,t)))**etam(r,t))$(etam(r,t) ne inf)
      +  (pm(r,t) - exr(r,t)*pwmbar(r,t))$(etam(r,t) eq inf) ;

apseq(r,t)$(rs(r) and ts(t) and years(t) ge yearE)..
   aps(r,t) =e= aps(r,t-1) ;

capeq(r,t)$(rs(r) and ts(t) and years(t) gt year0)..
   kap(r,t) =e= tcap0(r)$(years(t) eq year0)
             + (kap(r,t-1)*power(1-depr(r,t), gap(t))
             +  gap(t)*invt(r,t-1))$(years(t) gt year0)
             ;

$macro VGDP(r,tp,tq) \
   (pa(r,tp)*cons(r,tq) + pa(r,tp)*govt(r,tq) + pa(r,tp)*invt(r,tq) + \
   (1+etx(r,tp))*pe(r,tp)*xe(r,tq) - pm(r,tp)*xm(r,tq))

gdpeq(r,t)$(rs(r) and ts(t))..
   gdp(r,t) =e= VGDP(r,t,t) ;

pgdpeq(r,t)$(rs(r) and ts(t) and years(t) gt year0)..
   pgdp(r,t) =e= pgdp(r,t-1)*sqrt((VGDP(r,t,t-1)/VGDP(r,t-1,t-1))*(VGDP(r,t,t)/VGDP(r,t-1,t))) ;
*  log(pgdp(r,t)) =e= log(pgdp(r,t-1))
*                  + 0.5*(log(VGDP(r,t,t-1)) - log(VGDP(r,t-1,t-1))
*                  + log(VGDP(r,t,t)) - log(VGDP(r,t-1,t))) ;

rgdpeq(r,t)$(rs(r) and ts(t))..
   rgdp(r,t)*pgdp(r,t) =e= gdp(r,t) ;

walraseq(r,t)$(rs(r) and ts(t))..
   walras(r,t) =e= exr(r,t)*savf(r,t)
                +  (1+etx(r,t))*pe(r,t)*xe(r,t) - pm(r,t)*xm(r,t)
                +  yqhtv(r,t) - yqtfv(r,t)
                +  sum(s, remitv(r,s,t)) - sum(s, remitv(s,r,t))
                +  OdaInv(r,t) - odaOutv(r,t)
                ;

objeq..
   obj =e= sum((r,t), walras(r,t))
        ;

model macro /
   wageeq.wage, renteq, xeq,
   yqtfeq, trustYeq, yqhteq, remiteq,
   odaineq, odagbleq, odaouteq,
   taxreveq, peq, yheq,
   conseq, goveq, savgeq, htaxeq,
   inveq, xaeq, xddeq, xmdeq, paeq.pa,
   xdseq.pd, xeseq, pxeq,
   peeq.pe, pmeq.pm,
   apseq, capeq,
   gdpeq, rgdpeq, pgdpeq,
   walraseq, objeq,
/ ;
macro.holdfixed = 1 ;
macro.tolinfrep = 1e-6 ;

*  Initialize key parameters (may want to make them region and time specific in the future)

sigma(r,t)  = %SIGMA% ;
* depr(r,t)   = %DEPR% ;
sigmat(r,t) = %SIGMAM% ;
omega(r,t)  = %OMEGA% ;
etam(r,t)   = %ETAM% ;
etae(r,t)   = %ETAE% ;

*  Initialize the economic model

rgdp.l(r,t)  = gdp0(r) ;
x.l(r,t)     = (tlab0(r)+tcap0(r)+ptax0(r)) ;
ptx.fx(r,t)  = (tlab0(r)+tcap0(r)+ptax0(r))/(tlab0(r)+tcap0(r)) - 1 ;
mtx.fx(r,t)  = (imp0(r) + mtax0(r))/imp0(r) - 1 ;
etx.fx(r,t)  = exp0(r)/(exp0(r) - etax0(r)) - 1 ;
itx.fx(r,t)  = (cons0(r) + gov0(r) + inv0(r))/(cons0(r) + gov0(r) + inv0(r) - itax0(r)) - 1 ;
display ptx.l, mtx.l, etx.l, itx.l ;

parameter rwork(r) ;

*  Calculate first period growth of GDP in SSP2 scenario

loop(t$t0(t),
   rwork(r) = gdpScen1("OECD", "SSP2", "gdp", r, t+1)/gdpScen1("OECD", "SSP2", "gdp", r, t) ;
) ;

display "Pre-adjustment:", kstock0 ;

*  Adjust Kstock0 so that its initial growth is equal to GDP growth
*  Only if the user asks for it

kadj0(r)$(kadj0(r) eq na) = (inv0(r)/kstock0(r))
                          / (rwork(r) - (1 - depr(r,t00))) ;

kstock0(r)   = kadj0(r)*kstock0(r) ;
k_yRatio0(r) = kstock0(r) / gdp0(r) ;
p.l(r,t)    = 1 ;
x.l(r,t)    = x.l(r,t) / p.l(r,t) ;
px.l(r,t)   = p.l(r,t) / (1 + ptx.l(r,t)) ;
kap.l(r,t)  = kstock0(r) ;
rent.l(r,t) = capShr0(r)*px.l(r,t)*x.l(r,t)/kap.l(r,t) ;

display "Post-adjustment:", kstock0, inv0, rwork, kadj0, k_yRatio0, x.l, kap.l, rent.l ;

pa.l(r,t)   = 1 ;
exr.l(r,t)  = 1 ;
pm.l(r,t)   = 1 ;
pd.l(r,t)   = p.l(r,t) ;
pe.l(r,t)   = p.l(r,t) ;

pwebar.l(r,t) = pe.l(r,t)*(1 + etx.l(r,t)) / exr.l(r,t) ;
pwmbar.l(r,t) = pm.l(r,t) / exr.l(r,t) ;
pwe.l(r,t)    = pwebar.l(r,t) ;
pwm.l(r,t)    = pwmbar.l(r,t) ;

xe.l(r,t)     = expshr0(r)*rgdp.l(r,t)/((1 + etx.l(r,t))*pe.l(r,t)) ;
xm.l(r,t)     = impshr0(r)*rgdp.l(r,t)/pm.l(r,t) ;

yqtfv.l(r,t)    = yqtf0(r) ;
yqhtv.l(r,t)    = yqht0(r) ;
trustY.l(t)     = trustY0 ;
remitv.l(s,r,t) = remit0(s,r) ;
odaInv.l(r,t)   = odaIn0(r) ;
odaOutv.l(r,t)  = odaOut0(r) ;
odaGBL.l(t)     = odaGBL0 ;

savf.l(r,t)   = (pm.l(r,t)*xm.l(r,t) - (1 + etx.l(r,t))*pe.l(r,t)*xe.l(r,t))/exr.l(r,t)
              + (yqtfv.l(r,t) - yqhtv.l(r,t))
              + sum(s, remitv.l(s,r,t)) - sum(s, remitv.l(r,s,t))
              + odaOutv.l(r,t) - odaInv.l(r,t) ;

pgdp.l(r,t) = 1 ;
gdp.l(r,t)  = pgdp.l(r,t)*rgdp.l(r,t) ;
invt.l(r,t) = (gdp.l(r,t)*inv0(r)/gdp0(r)) / pa.l(r,t) ;
cons.l(r,t) = (gdp.l(r,t)*cons0(r)/gdp0(r)) / pa.l(r,t) ;
govt.l(r,t) = (gdp.l(r,t)*gov0(r)/gdp0(r)) / pa.l(r,t) ;

*  Trade

xa.l(r,t) = invt.l(r,t) + cons.l(r,t) + govt.l(r,t) ;
xd.l(r,t) = (pa.l(r,t)*xa.l(r,t)/(1+itx.l(r,t)) - (1 + mtx.l(r,t))*pm.l(r,t)*xm.l(r,t))/pd.l(r,t) ;
xd.l(r,t) = (p.l(r,t)*x.l(r,t) - pe.l(r,t)*xe.l(r,t)) / pd.l(r,t) ;

taxrev.l(r,t) = ptx.l(r,t)*px.l(r,t)*x.l(r,t)
              + itx.l(r,t)*pa.l(r,t)*xa.l(r,t)/(1+itx.l(r,t))
              + mtx.l(r,t)*pm.l(r,t)*xm.l(r,t)
              + etx.l(r,t)*pe.l(r,t)*xe.l(r,t)
              ;

chik(r,t)         = yqtf0(r) / tcap0(r) ;
chit(r,t)$trustY0 = yqht0(r) / trustY0 ;
chit(r,t)$rres(r) = 1 - sum(s$(not rres(s)), chit(s,t)) ;

chiRemit(s,r,t) = remit0(s,r) / tlab0(r) ;
etaODA(r,t)    = 0.1 ;
chiODAOut(r,t) = ODAOut0(r) / GDP.l(r,t00) ;
chiODAIn(r,t)$ODAGbl0 = ODAIN0(r) / ODAGBL0 ;
chiODAIn(r,t)$rres(r) = 1 - sum(s$(not rres(s)), chiODAIn(s,t)) ;

yh.l(r,t)    = p.l(r,t)*x.l(r,t) - ptx.l(r,t)*px.l(r,t)*x.l(r,t)
             + yqhtv.l(r,t) - yqtfv.l(r,t)
             + sum(s, remitv.l(r,s,t)) - sum(s, remitv.l(s,r,t)) ;

* !!!! MOVE SOMEWHERE ELSE

parameter chis0(r) "Original public savings" ; chis0(r) = 0 ;

chis.fx(r,t) = chis0(r) ;
savg.l(r,t)  = chis.l(r,t)*gdp.l(r,t) ;

htax.l(r,t)   = (savg.l(r,t) - taxrev.l(r,t) + (odaOutv.l(r,t) - odaInv.l(r,t)) + pa.l(r,t)*govt.l(r,t)) ;
htax.l(r,t)   = htax.l(r,t) / yh.l(r,t) ;

taxrev.l(r,t) = taxrev.l(r,t) + htax.l(r,t)*yh.l(r,t) ;
aps.l(r,t)    = 1 - pa.l(r,t)*cons.l(r,t)/(yh.l(r,t)*(1-htax.l(r,t))) ;
loop(t0,
   chig.fx(r,t) = govt.l(r,t0)/rgdp.l(r,t0) ;
) ;

lambdal.l(r,t) = 1 ;
lambdak.l(r,t) = 1 ;
tfp.l(r,t)     = 1 ;

*  Calibrate trade

loop((r,t0),
   alphad(r,t) = (xd.l(r,t0)/xa.l(r,t0))*((1+itx.l(r,t0))*pd.l(r,t0)/pa.l(r,t0))**sigmat(r,t0) ;
   alpham(r,t) = (xm.l(r,t0)/xa.l(r,t0))*((1+itx.l(r,t0))
               *     (1 + mtx.l(r,t0))*pm.l(r,t0)/pa.l(r,t0))**sigmat(r,t0) ;
   if(omega(r,t0) ne inf,
      gammad(r,t) = (xd.l(r,t0)/x.l(r,t0))*(p.l(r,t0)/pd.l(r,t0))**omega(r,t0) ;
      gammae(r,t) = (xe.l(r,t0)/x.l(r,t0))*(p.l(r,t0)/pe.l(r,t0))**omega(r,t0) ;
   else
      gammad(r,t) = (pd.l(r,t0)*xd.l(r,t0)/(p.l(r,t0)*x.l(r,t0))) ;
      gammae(r,t) = (pe.l(r,t0)*xe.l(r,t0)/(p.l(r,t0)*x.l(r,t0))) ;
   ) ;
   if(etam(r,t0) ne inf,
      chim(r,t) = xm.l(r,t0)*(exr.l(r,t0)*pwmbar.l(r,t0)/pm.l(r,t0))**etam(r,t0) ;
   ) ;
   if(etae(r,t0) ne inf,
      chie(r,t) = xe.l(r,t0)*((1+etx.l(r,t0))*pe.l(r,t0)/(exr.l(r,t0)*pwebar.l(r,t0)))**etae(r,t0) ;
   ) ;
) ;

*  Trade closure

pwmbar.fx(r,t) = pwmbar.l(r,t) ;
pwebar.fx(r,t) = pwebar.l(r,t) ;

parameters
   ydot(r,t)   "Growth of GDP"
   ldot(r,t)   "Growth of labor"
   popw(r,t)   "Population"
   sam(r,is,js,t)
   invTgt(mod,ssp,r,t)
;
alias(t,tsim) ;

sets
   ragg /
      set.r
      set.ra
   /
   mapragg(ragg,r)
;

mapragg(ragg,r)$sameas(ragg,r) = yes ;
loop(ra,
   mapragg(ragg,r)$(sameas(ra,ragg) and mapra(ra,r)) = yes ;
) ;

display ragg, mapragg ;

$macro mLag1(v) v.fx(r,t00) = v.l(r,t00) ;
$macro mLagB(v) v.fx(s,r,t00) = v.l(s,r,t00) ;
$macro mLagG(v) v.fx(t00)   = v.l(t00) ;

mLag1(rent)
mLag1(x)
mLag1(p)
mLag1(taxRev)
mLag1(yqtfv)
mLagG(trustY)
mLag1(yqhtv)
mLagb(remitv)
mLag1(ODAOutv)
mLagG(ODAGbl)
mLag1(ODAInv)
mLag1(yh)
mLag1(cons)
mLag1(pa)
mLag1(govt)
mLag1(savg)
mLag1(htax)
mLag1(invt)
mLag1(xa)
mLag1(xd)
mLag1(xm)
mLag1(pa)
mLag1(pd)
mLag1(xe)
mLag1(px)
mLag1(pe)
mLag1(pm)
mLag1(aps)
mLag1(kap)
mLag1(gdp)
mLag1(pgdp)
mLag1(rgdp)

$macro usum(v)    (sum(r$mapragg(ragg,r), v(r,t)))
$macro wsum(v,w)  (sum(r$mapragg(ragg,r), w(r,t)*v(r,t)) / sum(r$mapragg(ragg,r), w(r,t)))
$macro psum(v,w)  (sum(r$mapragg(ragg,r), v(r,t)) / sum(r$mapragg(ragg,r), w(r,t)))

loop((mod,ssp)$((sameas(mod,"OECD") and sameas(ssp,"SSP2")) or 1),

   tlab.fx(r,t) = pScale*lfpr(r)*tpop1(ssp, r, "P1564", t) ;
   popw(r,t)    = pScale*tpop1(ssp, r, "PTOTL", t) ;
   wage.l(r,t)  = (1-capshr0(r))*px.l(r,t)*x.l(r,t)/tlab.l(r,t) ;
   mLag1(wage)

   display tlab.l, popw, wage.l, capshr0 ;

   loop(t0,
      alphak(r,t) = capShr0(r)*(px.l(r,t0)/rent.l(r,t0))**(1-sigma(r,t0)) ;
      alphal(r,t) = (1-capshr0(r))*(px.l(r,t0)/wage.l(r,t0))**(1-sigma(r,t0)) ;
   ) ;

   loop(t$(not t0(t)),
      rgdp.l(r,t) = rgdp.l(r,t-1)
                  *  gdpScen1(mod, ssp, "gdp", r, t)/gdpScen1(mod, ssp, "gdp", r, t-1) ;
      x.l(r,t)    = x.l(r,t-1)*gdpScen1(mod, ssp, "gdp", r, t)/gdpScen1(mod, ssp, "gdp", r, t-1) ;
   ) ;

   loop(t0,
      rent.fx(r,t)$(years(t) ne year1 and years(t) le yearE) = rent.l(r,t0) ;
      rgdp.fx(r,t) = rgdp.l(r,t) ;

      tfp.l(r,t) = ((1/px.l(r,t0))*(alphal(r,t0)*(wage.l(r,t0)/lambdal.l(r,t0))**(1-sigma(r,t0))
                 +                  alphak(r,t0)*(rent.l(r,t0)/lambdak.l(r,t0))**(1-sigma(r,t0)))
                 **  (1/(1-sigma(r,t0))))
                 $(sigma(r,t0) ne 1)
                 +  ((1/px.l(r,t0))*(((wage.l(r,t0)/(alphal(r,t0)*lambdal.l(r,t0)))**alphal(r,t0))
                 *                   ((rent.l(r,t0)/(alphak(r,t0)*lambdak.l(r,t0)))**alphak(r,t0))))
                 $(sigma(r,t0) eq 1)
   ) ;

   if(%ifTFP%,
      lambdal.fx(r,t) = lambdal.l(r,t) ;
      lambdak.fx(r,t) = lambdak.l(r,t) ;
   else
      lambdak.fx(r,t) = lambdak.l(r,t) ;
      tfp.fx(r,t)     = tfp.l(r,t) ;
   ) ;

   loop(t0,
      tcap0(r) = kap.l(r,t0) ;
      inv0(r)  = invt.l(r,t0) ;
      aps.fx(r,t0)  = aps.l(r,t0) ;
*     invt.fx(r,t0) = invt.l(r,t0) ;
   ) ;

   walras.l(r,t) = exr.l(r,t)*savf.l(r,t)
                 +  (1+etx.l(r,t))*pe.l(r,t)*xe.l(r,t) - pm.l(r,t)*xm.l(r,t)
                 +  yqhtv.l(r,t) - yqtfv.l(r,t)
                 +  sum(s, remitv.l(r,s,t)) - sum(s, remitv.l(s,r,t))
                 +  OdaInv.l(r,t) - odaOutv.l(r,t)
                 ;

   mLag1(walras)
   obj.l = sum((r,t), walras.l(r,t)) ;

*  Give a better guess for tfp, wage and cap growth

   loop(t$(not t0(t)),
      ydot(r,t) = x.l(r,t)/x.l(r,t-1) - 1 ;
      ldot(r,t) = tlab.l(r,t)/tlab.l(r,t) - 1 ;

      if(%ifTFP%,

         tfp.l(r,t)    = tfp.l(r,t-1)*(1 + (ydot(r,t) - ldot(r,t))
                       /  (1 + sigma(r,t)*capshr0(r)/(1-capshr0(r)))) ;

         wage.l(r,t) = wage.l(r,t-1)*(1 + (ydot(r,t) - ldot(r,t))
                     /  ((1-capshr0(r)) + sigma(r,t)*capshr0(r))) ;

         kap.l(r,t)  = kap.l(r,t-1)*(1 + sigma(r,t)*ydot(r,t)
                     - ldot(r,t)*(sigma(r,t)-1)/(1 + sigma(r,t)*capshr0(r)/(1-capshr0(r)))) ;

      else

         lambdal.l(r,t) = lambdal.l(r,t-1)*(1 + ydot(r,t) - ldot(r,t)) ;

         wage.l(r,t)    = wage.l(r,t-1)*(lambdal.l(r,t)/lambdal.l(r,t-1)) ;

         kap.l(r,t)     = kap.l(r,t-1)*(1 + ydot(r,t)) ;
      ) ;

   ) ;

   display tfp.l, wage.l, kap.l, lambdal.l ;

*  FIX LAGS

   pgdp.fx(r,t0) = pgdp.l(r,t0) ;

*  Macro closure

   if(1,
      px.fx(r,t)    = px.l(r,t) ;
   else
      exr.fx(r,t)   = exr.l(r,t) ;
   ) ;

   savf.fx(r,t)  = savf.l(r,t) ;

   xe.fx(r,t)$(gammae(r,t) eq 0) = 0 ;
   xm.fx(r,t)$(alpham(r,t) eq 0) = 0 ;

   loop((t0,t)$(not t00(t)),
      wage.lo(r,t) = 0.001*wage.l(r,t0) ;
      pa.lo(r,t) = 0.001*pa.l(r,t0) ;
      pd.lo(r,t) = 0.001*pd.l(r,t0) ;
      pe.lo(r,t) = 0.001*pe.l(r,t0) ;
      pm.lo(r,t) = 0.001*pm.l(r,t0) ;
   ) ;

   if(1,
      rs(r) = yes ;
      ts(t) = yes ; ts(t00) = no ;
      if(0,
         options limrow=0, limcol=0, solprint=off, iterlim=3000 ;
      else
         options limrow=3, limcol=3, solprint=off, iterlim=3000 ;
      ) ;

      if(1,
         solve macro using mcp ;
      else
         solve macro minimizing obj using nlp ;
      ) ;
   ) ;

   invTgt(mod,ssp,r,t) = 100*invt.l(r,t)/rgdp.l(r,t) ;

   display rent.l ;

   if(ifmcsv,
      put mcsv ;
      put "SSP,Mod,Var,Region,Year,Value" / ;
      mcsv.pc=5 ;
      mcsv.nd=9 ;

      $$ondotl
      loop((ragg,t),
         put ssp.tl, Mod.tl, "Wage",      ragg.tl, t.val:4:0, wsum(wage, tlab) / ;
         put ssp.tl, Mod.tl, "Rent",      ragg.tl, t.val:4:0, wsum(rent, kap) / ;
         put ssp.tl, Mod.tl, "Cap",       ragg.tl, t.val:4:0, usum(kap) / ;
         put ssp.tl, Mod.tl, "Lab",       ragg.tl, t.val:4:0, usum(tlab) / ;
         put ssp.tl, Mod.tl, "Pop",       ragg.tl, t.val:4:0, usum(popw) / ;
         put ssp.tl, Mod.tl, "x",         ragg.tl, t.val:4:0, usum(x) / ;
         put ssp.tl, Mod.tl, "yh",        ragg.tl, t.val:4:0, usum(yh) / ;
         put ssp.tl, Mod.tl, "gdp",       ragg.tl, t.val:4:0, usum(gdp) / ;
         put ssp.tl, Mod.tl, "rgdp",      ragg.tl, t.val:4:0, usum(rgdp) / ;
         put ssp.tl, Mod.tl, "xa",        ragg.tl, t.val:4:0, usum(xa) / ;
         put ssp.tl, Mod.tl, "xd",        ragg.tl, t.val:4:0, usum(xd) / ;
         put ssp.tl, Mod.tl, "xm",        ragg.tl, t.val:4:0, usum(xm) / ;
         put ssp.tl, Mod.tl, "xe",        ragg.tl, t.val:4:0, usum(xe) / ;
         put ssp.tl, Mod.tl, "ypc",       ragg.tl, t.val:4:0, psum(rgdp, popw) / ;
         put ssp.tl, Mod.tl, "Cons",      ragg.tl, t.val:4:0, usum(cons) / ;
         put ssp.tl, Mod.tl, "Gov",       ragg.tl, t.val:4:0, usum(govt) / ;
         put ssp.tl, Mod.tl, "Inv",       ragg.tl, t.val:4:0, usum(invt) / ;
         put ssp.tl, Mod.tl, "savg",      ragg.tl, t.val:4:0, usum(savg) / ;
         put ssp.tl, Mod.tl, "savf",      ragg.tl, t.val:4:0, usum(savf) / ;
         put ssp.tl, Mod.tl, "walras",    ragg.tl, t.val:4:0, usum(walras) / ;
         put ssp.tl, Mod.tl, "aps",       ragg.tl, t.val:4:0, wsum(aps, yh) / ;
         put ssp.tl, Mod.tl, "htax",      ragg.tl, t.val:4:0, wsum(htax, yh) / ;
         put ssp.tl, Mod.tl, "tfp",       ragg.tl, t.val:4:0, wsum(tfp,x) / ;
         put ssp.tl, Mod.tl, "p",         ragg.tl, t.val:4:0, wsum(p,x) / ;
         put ssp.tl, Mod.tl, "px",        ragg.tl, t.val:4:0, wsum(px,x) / ;
         put ssp.tl, Mod.tl, "exr",       ragg.tl, t.val:4:0, wsum(exr,xe) / ;
         put ssp.tl, Mod.tl, "pa",        ragg.tl, t.val:4:0, wsum(pa,xa) / ;
         put ssp.tl, Mod.tl, "pd",        ragg.tl, t.val:4:0, wsum(pd,xd) / ;
         put ssp.tl, Mod.tl, "pe",        ragg.tl, t.val:4:0, wsum(pe,xe) / ;
         put ssp.tl, Mod.tl, "pm",        ragg.tl, t.val:4:0, wsum(pm,xm) / ;
         put ssp.tl, Mod.tl, "lambdal",   ragg.tl, t.val:4:0, wsum(lambdal, tlab) / ;
         put ssp.tl, Mod.tl, "lambdak",   ragg.tl, t.val:4:0, wsum(lambdak, kap) / ;
         put ssp.tl, Mod.tl, "sigma",     ragg.tl, t.val:4:0, wsum(sigma, x) / ;
         put ssp.tl, Mod.tl, "depr",      ragg.tl, t.val:4:0, wsum(depr, kap) / ;
      ) ;

      sam(r,"Lab","Act",t) = wage.l(r,t)*tlab.l(r,t) ;
      sam(r,"Cap","Act",t) = rent.l(r,t)*kap.l(r,t) ;
      sam(r,"ptx","Act",t) = ptx.l(r,t)*px.l(r,t)*x.l(r,t) ;
      sam(r,"Act","Com",t) = p.l(r,t)*x.l(r,t) ;
      sam(r,"itx","Com",t) = itx.l(r,t)*pa.l(r,t)*xa.l(r,t)/(1+itx.l(r,t)) ;
      sam(r,"etx","Com",t) = etx.l(r,t)*pe.l(r,t)*xe.l(r,t) ;
      sam(r,"mtx","Com",t) = mtx.l(r,t)*pm.l(r,t)*xm.l(r,t) ;
      sam(r,"ROW","Com",t) = pm.l(r,t)*xm.l(r,t) ;
      sam(r,"hhd","Lab",t) = wage.l(r,t)*tlab.l(r,t) - sum(s, remitv.l(s,r,t)) ;
      sam(r,"row","Lab",t) = sum(s, remitv.l(s,r,t)) ;
      sam(r,"hhd","Cap",t) = rent.l(r,t)*kap.l(r,t) - yqtfv.l(r,t) ;
      sam(r,"ROW","Cap",t) = yqtfv.l(r,t) ;
      sam(r,"gov","ptx",t) = sam(r,"ptx","act",t) ;
      sam(r,"gov","itx",t) = sam(r,"itx","com",t) ;
      sam(r,"gov","mtx",t) = sam(r,"mtx","com",t) ;
      sam(r,"gov","etx",t) = sam(r,"etx","com",t) ;
      sam(r,"Com","hhd",t) = pa.l(r,t)*cons.l(r,t) ;
      sam(r,"Com","gov",t) = pa.l(r,t)*govt.l(r,t) ;
      sam(r,"Com","inv",t) = pa.l(r,t)*invt.l(r,t) ;
      sam(r,"Com","row",t) = (1+etx.l(r,t))*pe.l(r,t)*xe.l(r,t) ;
      sam(r,"Gov","hhd",t) = htax.l(r,t)*yh.l(r,t) ;
      sam(r,"Inv","hhd",t) = aps.l(r,t)*yh.l(r,t)*(1-htax.l(r,t)) ;
      sam(r,"Inv","gov",t) = savg.l(r,t) ;
      sam(r,"inv","row",t) = exr.l(r,t)*savf.l(r,t) ;
      sam(r,"hhd","row",t) = yqhtv.l(r,t) + sum(s, remitv.l(r,s,t)) ;
      sam(r,"gov","row",t) = odaInv.l(r,t) ;
      sam(r,"row","gov",t) = odaOutv.l(r,t) ;

      put ssp.tl, Mod.tl, msamcsv ;

      loop((r,is,js,t)$sam(r,is,js,t),
         put ssp.tl, Mod.tl, r.tl, is.tl, js.tl, t.val:4:0, (sam(r,is,js,t)/gscale) / ;
      ) ;

      $$offdotl
   ) ;

) ;

execute_unload "%BaseName%/fnl/%BaseName%InvTgt.gdx", invTgt, kadj0, depr=deprT ;

$ontext
file invf / "v:/Env10/%BaseName%/%BaseName%InvTgt.gms" / ;
put ssp.tl, Mod.tl, invf ;
put ssp.tl, Mod.tl, "Parameter invTarget0(r,tt) /" / ;
loop(t$tr(t),
   loop(r,
      put ssp.tl, Mod.tl, r.tl, ".", t.val:<7:0, (100*inv.l(r,t)/rgdp.l(r,t)):12:5 / ;
   ) ;
   put ssp.tl, Mod.tl, / ;
) ;
put ssp.tl, Mod.tl, "/ ;" / /;

put ssp.tl, Mod.tl, "Parameter kadj0(r) /" / ;
loop(r,
   put ssp.tl, Mod.tl, r.tl, (kadj0(r)):10:3 / ;
) ;
put ssp.tl, Mod.tl, "/ ;" ;
$offtext
