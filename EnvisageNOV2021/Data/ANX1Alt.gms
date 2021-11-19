*  Altertax shock
*
*  If new policy needs to be phased in, the basic implementation is
*
*     p(it) = pfinal*(it/n) + pinitial*(1-it/n)
*
*  See below for an example
*
*  Set the number of iterations on the command line, for example --niter=4

$ontext

*  Cut initial tariffs by 50%

if(niter(tsim) eq 1,

*  No phase in of cuts

   imptx.fx(r,i,rp,tsim) = 0.5*imptx.l(r,i,rp,"base") ;

else

*  Phase in the shock

   for(iter=1 to niter(tsim),
      imptx.fx(r,i,rp,tsim) = 0.5*imptx.l(r,i,rp,"base") * (iter/niter(tsim))
                            + imptx.l(r,i,rp,"Base") * (1 - iter/niter(tsim)) ;
      if(iter < niter(tsim),
         $$batinclude "solve.gms" gtap
      ) ;
   ) ;
) ;
$offtext

* imptx.fx(r,"LightMnfc-c","NAmerica",tsim) = 0.5*imptx.l(r,"LightMnfc-c","NAmerica",tsim) ;

*  Test the NTM module
$ontext
ntmFlag = 1 ;
ntmY.lo(r,tsim) = -inf ;
ntmY.up(r,tsim) = +inf ;
ntmAVE.fx(r,"TextWapp-c",rp,tsim) = 0.10 ;
chiNTM(r,r,tsim) = 1 ;
$offtext

*  Add a shock and then take it away

if(0,
   lambdaf.fx(r,l,a,tsim) = 1.1 ;
   $$batinclude "solve.gms" gtap
   lambdaf.fx(r,l,a,tsim) = 1.0 ;
) ;

*Dominique told Andre to comment out these lines BEGINNING
*This was an alter tax xhock that dominique left in for some other work he was doing
if(0,
ytax0(r,"ct")     = 1 ;

execute_load "%inDir%/%BaseName%NCO2.gdx", gwp, emi_iop, emi_endw, emi_qo ;

ProcEmi0(r,em,a)  = gwp(em,r,"AR4")*cscale
                  *  (sum((i0,a0)$(mapa0(a0,a)), emi_iop(em, i0, a0, r))
                  +   sum((fp,a0)$mapa0(a0,a), emi_endw(em, fp, a0, r))
                  +   sum(a0$mapa0(a0,a), emi_qo(em, a0, r))) ;

ctaxFlag(r,a)$sum(em, 0.25*(inscale/cscale)*procEmi0(r,em,a)) = yes ;
ctax.l(r,a,tsim)$ctaxFlag(r,a) = 0.0003 ;
ctax.lo(r,a,tsim)$ctaxFlag(r,a) = -inf ;
ctax.up(r,a,tsim)$ctaxFlag(r,a) = +inf ;
);
*Dominique told Andre to comment out these lines END
