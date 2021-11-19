if(years(tsim) gt 1,
   ftfp.fx(r,a,v,tsim)       = 1 - 5*0.01 ;
   lambdaf.fx(r,l,a,tsim)    = 1 - 0*0.01 ;
   if(years(tsim) ge 2,
      kstock.lo(r,tsim)         = -inf ;
      kstock.up(r,tsim)         = +inf ;
      trent.fx(r,tsim)          = trent.l(r,t00) ;
   ) ;
   ewagez.fx(r,l,"nsg",tsim) = ewagez.l(r,l,"nsg",t00) ;
*  rwage.fx(r,l,"nsg",tsim)  = rwage.l(r,l,"nsg",t00) ;
   uez.lo(r,l,"nsg",tsim)    = -inf ;
   uez.up(r,l,"nsg",tsim)    = +inf ;
) ;
