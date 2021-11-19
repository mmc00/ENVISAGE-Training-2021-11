loop(t0,
if(years(tsim) eq 2020,
   mtax.fx(s,i,d,tsim)$(sameas(s,"EastAsia") and sameas(d,"NAmerica")) = 1.0*mtax.l(s,i,d,t0) + .10 ;
elseif(years(tsim) gt 2020),
   mtax.fx(s,i,d,tsim)$(sameas(s,"EastAsia") and sameas(d,"NAmerica")) = 1.0*mtax.l(s,i,d,t0) + .20 ;
) ;
) ;
