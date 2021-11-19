*  ROW Shock
if(years(tsim) ge 2,
   if(1,
      if(0,
         kstock.lo(r,tsim)         = -inf ;
         kstock.up(r,tsim)         = +inf ;
         if(ifNominal,
            trent.fx(r,tsim)          = trent.l(r,t00) ;
         else
            rtrent.fx(r,tsim)         = rtrent.l(r,t00) ;
         ) ;
      ) ;
      if(1,
         ueFlag(r,l,"nsg")         = MonashUE ;
         errW.fx(r,l,"nsg",tsim)   = 0 ;
         uez.lo(r,l,"nsg",tsim)    = 0    ;
         uez.up(r,l,"nsg",tsim)    = +inf ;
         if(ifNominal,
            ewagez.lo(r,l,"nsg",tsim) = ewagez.l(r,l,"nsg",t00) ;
         else
            rwage.fx(r,l,"nsg",tsim)  = rwage.l(r,l,"nsg",t00) ;
         ) ;
      ) ;
   ) ;
   if(years(tsim) eq 2,
      loop(ml$(ord(ml) ne card(ml)),
         ftfp.fx(r,a,v,tsim)$maprshk("row",r) = 1 - supShk(r)*ord(ml)/card(ml) ;
         $$batinclude "solve.gms" core
      ) ;
   ) ;
   ftfp.fx(r,a,v,tsim)$maprshk("row",r) = 1 - supShk(r) ;
) ;

*  ROW Shock
if(years(tsim) ge 3,
   if(1,
      if(0,
         kstock.lo(r,tsim)         = -inf ;
         kstock.up(r,tsim)         = +inf ;
         if(ifNominal,
            trent.fx(r,tsim)          = trent.l(r,t00) ;
         else
            rtrent.fx(r,tsim)         = rtrent.l(r,t00) ;
         ) ;
      ) ;
      if(1,
         uez.lo(r,l,"nsg",tsim)    = -inf ;
         uez.up(r,l,"nsg",tsim)    = +inf ;
         if(ifNominal,
            ewagez.fx(r,l,"nsg",tsim) = ewagez.l(r,l,"nsg",t00) ;
         else
            rwage.fx(r,l,"nsg",tsim)  = rwage.l(r,l,"nsg",t00) ;
         ) ;
      ) ;
   ) ;
   if(years(tsim) eq 3,
      loop(ml$(ord(ml) ne card(ml)),
         ftfp.fx(r,a,v,tsim)$(not maprshk("row",r)) = 1 - supShk(r)*ord(ml)/card(ml) ;
         $$batinclude "solve.gms" core
      ) ;
   ) ;
   ftfp.fx(r,a,v,tsim)$(not maprshk("row",r)) = 1 - 5*supShk(r)/5 ;
) ;

if(years(tsim) ge 4,
*  Additive shock
   tmarg.fx(s,i,r,tsim)$(not tou(i) and xwFlag(s,i,r)) = tmarg.l(s,i,r,t00) + ttShk(r) ;
   tmarg.fx(r,i,d,tsim)$(not tou(i) and xwFlag(r,i,d)) = tmarg.l(r,i,d,t00) + ttShk(r) ;
) ;

if(years(tsim) ge 5,

   if(years(tsim) eq 5,
      loop(ml$(ord(ml) ne card(ml)),
         etax.fx(s,i,r,tsim)$(tou(i) and xwFlag(s,i,r)) = etax.l(s,i,r,t00) + touShk(r)*ord(ml)/card(ml) ;
         etax.fx(r,i,d,tsim)$(tou(i) and xwFlag(r,i,d)) = etax.l(r,i,d,t00) + touShk(r)*ord(ml)/card(ml) ;
         $$batinclude "solve.gms" core
      ) ;
   ) ;
   etax.fx(s,i,r,tsim)$(tou(i) and xwFlag(s,i,r)) = etax.l(s,i,r,t00) + touShk(r) ;
   etax.fx(r,i,d,tsim)$(tou(i) and xwFlag(r,i,d)) = etax.l(r,i,d,t00) + touShk(r) ;
) ;

if(years(tsim) ge 6,

*  >>>>> Domestic demand shifts

   iphh(r,i) = no ;
   phhTaxFlag(r) = yes ;

   loop(h,
      iphh(r,i)$(xa0(r,i,h) and nCov19DemShk(r,i)) = yes ;
      phhTax.lo(r,i,tsim)$(xa0(r,i,h)) = -inf ;
      phhTax.up(r,i,tsim)$(xa0(r,i,h)) =  inf ;
   ) ;
   phhTax0.fx(r,i,tsim)$(not iphh(r,i)) = -0.01 ;
   phhTaxY.fx(r,tsim) = 0 ;
   chiPhh.lo(r,tsim) = -inf ;
   chiPhh.up(r,tsim) =  inf ;

   if(years(tsim) eq 6,
      loop(ml,
         if(ord(ml) eq 1,
*           Guess initial levels
            chiPhh.l(r,tsim)   = 0 ;
            phhTax.l(r,i,tsim)$(not iphh(r,i)) = 0 ;
            phhTax0.l(r,i,tsim)$iphh(r,i) = nCov19DemShk(r,i)*(ord(ml)-1)/card(ml) ;
            phhTax.l(r,i,tsim)$iphh(r,i)  = nCov19DemShk(r,i)*(ord(ml)-1)/card(ml) ;
         ) ;
*        Fix consumption
         xa.fx(r,i,h,tsim)$iphh(r,i) = (1-nCov19DemShk(r,i)*(ord(ml)-1)/card(ml))
                                     *        xa.l(r,i,h,tsim-1) ;
         $$batinclude "solve.gms" core
      ) ;
   ) ;

   xa.fx(r,i,h,tsim)$iphh(r,i) = (1-nCov19DemShk(r,i))*xa.l(r,i,h,tsim-1) ;
) ;
