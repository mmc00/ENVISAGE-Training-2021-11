if(years(tsim) ge 2025,
   if(years(tsim) eq 2025,
      emiTax.fx(r,"CO2",aa,tsim) = 0.001*20 ;
   else
      emiTax.fx(r,"CO2",aa,tsim) = emiTax.l(r,"CO2",aa,tsim-1)*power(1.03, gap(tsim)) ;
   ) ;
) ;
