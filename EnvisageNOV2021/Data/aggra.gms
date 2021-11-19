loop((r,actf),
   denom = sum((r0,a0,a)$(mapr(r0,r) and mapa(a0,a) and mapaf(a, actf)), %2(r0,a0)) ;
   %3(r,actf)$denom = sum((r0,a0,a)$(mapr(r0,r) and mapa(a0,a) and mapaf(a, actf)), %2(r0,a0)*%1(r0,a0))/denom ;
) ;
