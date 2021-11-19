if(sameas(tsim,"Shock"),
   pftax.fx(r,fp,a,tsim) = 0 ;
   $$batinclude "solve.gms" core
) ;
if(sameas(tsim,"Shock"),
   etax.fx(s,i,d,tsim) = 0 ;
   $$batinclude "solve.gms" core
) ;
if(sameas(tsim,"Shock"),
   pdtax.fx(r,i,aa,tsim) = 0 ;
   pmtax.fx(r,i,aa,tsim) = 0 ;
   $$batinclude "solve.gms" core
) ;
if(sameas(tsim,"Shock"),
   tmarg.fx(s,i,d,tsim) = 0.75*tmarg.l(s,i,d,t00) ;
   $$batinclude "solve.gms" core
   tmarg.fx(s,i,d,tsim) = 0.5*tmarg.l(s,i,d,t00) ;
   $$batinclude "solve.gms" core
   tmarg.fx(s,i,d,tsim) = 0.25*tmarg.l(s,i,d,t00) ;
   $$batinclude "solve.gms" core
   tmarg.fx(s,i,d,tsim) = 0.1*tmarg.l(s,i,d,t00) ;
   $$batinclude "solve.gms" core
   tmarg.fx(s,i,d,tsim) = 0.05*tmarg.l(s,i,d,t00) ;
   $$batinclude "solve.gms" core
   tmarg.fx(s,i,d,tsim) = 0.0*tmarg.l(s,i,d,t00) ;
) ;
if(sameas(tsim,"Shock"),
   ptax.fx(r,a,i,tsim)   = 0 ;
   kappaf.fx(r,f,a,tsim) = 0 ;
) ;
