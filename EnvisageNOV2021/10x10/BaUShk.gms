*  Default is to set savfbar to savf0 (see init.gms)

if(0,
*  Make trade imbalances disappear between tf0 and tfT

   loop((t0,tf0,tfT)$(years(tsim) gt years(t0)),
      if (years(tsim) lt years(tf0),
         savfBar(r,tsim) = savfBar(r,tsim-1) ;
      elseif (years(tsim) gt years(tfT)),
         savfBar(r,tsim) = 0 ;
      elseif (years(tfT) eq years(tf0)),
         savfBar(r,tsim) = savfBar(r,tsim-1) ;
      else
         savfBar(r,tsim) = (savfBar(r,tf0)*(years(tfT)-years(tsim))
                         + 0*(years(tsim) - years(tf0)))/(years(tfT) - years(tf0)) ;
      ) ;
   ) ;
) ;

*fixER("RestofWorld")$(years(tsim) gt baseYear) = yes ;
*pfact.fx("RestofWorld",tsim)$(years(tsim) gt baseYear) = 1.03*pfact.l("RestofWorld",tsim-1) ;

*  Make savings endogenous in baseline and investment fixed

if(ifCal,
   loop((r,inv,t0)$(years(tsim) gt years(t0)),
      if(invTargetT(r,tsim) ne na,
         chiaps.lo(r,h,tsim)  = -inf ;
         chiaps.up(r,h,tsim)  = +inf ;
         if(ifInitFlag ne 1 or years(tsim) gt startYear ,
            chiaps.l(r,h,tsim)   = chiaps.l(r,h,tsim-1) ;
         ) ;
         rfdshr.fx(r,inv,tsim) = 0.01*invTargetT(r,tsim) ;
      else
         chiaps.fx(r,h,tsim)     = chiaps.l(r,h,tsim-1) ;
         rfdshr.lo(r,inv,tsim) = -inf ;
         rfdshr.up(r,inv,tsim) = +inf ;
      ) ;
   ) ;
else
   chiaps.fx(r,h,tsim)  = chiaps.l(r,h,tsim) ;
   rfdshr.lo(r,inv,tsim) = -inf ;
   rfdshr.up(r,inv,tsim) = +inf ;
) ;

*  Make UE fixed and endogenize the wage shifter

if(ifCal,
   chirw.lo(r,l,z,tsim)$(ueFlag(r,l,z) eq resWageUE) = -inf ;
   chirw.up(r,l,z,tsim)$(ueFlag(r,l,z) eq resWageUE) =  inf ;
   uez.fx(r,l,z,tsim)$(ueFlag(r,l,z) ne fullEmpl)    = uez0(r,l,z) ;
   rwage.lo(r,l,z,tsim)$lsflag(r,l,z) = -inf ;
   rwage.up(r,l,z,tsim)$lsflag(r,l,z) = +inf ;
   ldz.lo(r,l,z,tsim)$lsflag(r,l,z) = -inf ;
   ldz.up(r,l,z,tsim)$lsflag(r,l,z) = +inf ;
else
   uez.fx(r,l,z,tsim)$(ueFlag(r,l,z) eq fullEmpl)    = uez0(r,l,z) ;
   uez.lo(r,l,z,tsim)$(ueFlag(r,l,z) eq resWageUE)   = ueminz(r,l,z,tsim) ;
   uez.lo(r,l,z,tsim)$(ueFlag(r,l,z) eq MonashUE)    = -inf ;
   uez.up(r,l,z,tsim)$(ueFlag(r,l,z) ne fullEmpl)    =  inf ;
   chirw.fx(r,l,z,tsim)$(ueFlag(r,l,z) eq resWageUE) = chirwBaU(r,l,z,tsim) ;
   errW.fx(r,l,z,tsim)$(ueFlag(r,l,z) eq MonashUE)   = 0 ;
   rwage.lo(r,l,z,tsim)$lsflag(r,l,z) = -inf ;
   rwage.up(r,l,z,tsim)$lsflag(r,l,z) = +inf ;
   ldz.lo(r,l,z,tsim)$lsflag(r,l,z) = -inf ;
   ldz.up(r,l,z,tsim)$lsflag(r,l,z) = +inf ;
) ;

errW.lo(r,l,z,tsim)$(lsFlag(r,l,z) and ueFlag(r,l,z) ne MonashUE) = -inf ;
errW.up(r,l,z,tsim)$(lsFlag(r,l,z) and ueFlag(r,l,z) ne MonashUE) = +inf ;

*  Tease a first solution for 2012

if(0 and ifCal,
   if(sameas(tsim,"2012"),
      gl.fx(r,tsim) = ((rgdppcT(r,tsim)/rgdppcT(r,tsim-1))**(1/gap(tsim)) - 1) ;
      grrgdppc.lo(r,tsim) = -inf ;
      grrgdppc.up(r,tsim) = +inf ;
      options iterlim = 10000 ;
      $$batinclude "solve.gms" coreDyn
      grrgdppc.fx(r,tsim) = 100*((rgdppcT(r,tsim)/rgdppcT(r,tsim-1))**(1/gap(tsim)) - 1) ;
      gl.lo(r,tsim) = -inf ;
      gl.up(r,tsim) = +inf ;
   ) ;
) ;
