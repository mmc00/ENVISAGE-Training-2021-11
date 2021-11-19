if(sameas(tsim,"shock"),
   loop(t0,
      pnum.fx(tsim) = 1.5*pnum.l(t0) ;
      if(0,
         if(1,
            capu.fx(r,a,v,tsim) = 0.95 ;
            if(1,
               uez.lo(r,l,"nsg",tsim)    = -inf ;
               uez.up(r,l,"nsg",tsim)    = +inf ;
               ewagez.fx(r,l,"nsg",tsim) = ewagez.l(r,l,"nsg",t00) ;
            ) ;
         else
            capuFlag(r) = yes ;
            xfd.fx(r,inv,tsim) = 0.975*xfd.l(r,inv,t00) ;
            delCapu.lo(r,tsim) = -inf ;
            delCapu.up(r,tsim) = +inf ;
            capu.lo(r,a,v,tsim)$kflag(r,a) = -inf ;
            capu.up(r,a,v,tsim)$kflag(r,a) = +inf ;
         ) ;
      ) ;
*     mtax.fx(r,i,rp,tsim) = 0.5*mtax.l(r,i,rp,t0) ;
*     mtaxa.fx(r,i,rp,aa,tsim) = 1.0*mtaxa.l(r,i,rp,aa,t0) ;
*     lambdaw(r,i,"SSA",tsim) = 1.1*lambdaw(r,i,"SSA",t0) ;
*     lambdaf.fx(r,f,a,tsim) = 1 + 0.05*uniform(0,1) ;
*     lambdaf.fx(r,l,a,tsim) = 1.1 ;
*     xp.fx("EastAsia", a, tsim) = 0.95*xp.l("EastAsia", a, t0) ;
*     tfp.lo("EastAsia", a, vOld, tsim) = -inf ;
*     tfp.up("EastAsia", a, vOld, tsim) =  inf ;

   if(0,
      loop(r$sameas(r,"EastAsia"),
         if(1,
            lsz.fx(r, l, "nsg", tsim) = (1 - 0.03)*lsz.l(r, l, "NSG", t0) ;
            omegal(r,l,z) = 0 ;
            pf.fx(r,l,a,tsim) = pf0(r,l,a) ;
            pik.lo(r,l,a,tsim) = -inf ;
            pik.up(r,l,a,tsim) = +inf ;
         else
            omegal(r,l,z) = 0 ;
            flexwage(r,l)  = no ;
            pf.lo(r,l,a,t) = pf0(r,l,a) ;
*           lsz.lo(r,l,z,tsim) = -inf ;
*           lsz.up(r,l,z,tsim) =  inf ;
*           ewagez.fx(r,l,z,tsim) = 1 ;
*           lambdaf.fx(r, l, a, tsim) = 1 - 0.02 ;
            ftfp.fx(r,a,v,tsim) = 1 - 0.03 ;
         ) ;
      ) ;

*     Unaffected regions

      loop(r$(not sameas(r,"EastAsia")),
         if(0,
            omegal(r,l,z) = 0 ;
*           lsz.lo(r,l,z,tsim) = -inf ;
*           lsz.up(r,l,z,tsim) =  inf ;
*           ewagez.fx(r,l,z,tsim) = 1 ;
            flexwage(r,l)  = no ;
         ) ;
      ) ;

*     Affected regions

      loop(r$sameas(r,"EastAsia"),
         if(1,
            kstock.fx(r, tsim)        = (1 - 0.03)*KStock.l(r, t0) ;
         else
*           Fix RoR, Kstock endogenous
            omegak(r)         =  inf ;
            kstock.lo(r,tsim) = -inf ;
            kstock.up(r,tsim) = +inf ;
            trent.fx(r,tsim)  = 1 ;
         ) ;
      ) ;

*     Unaffected regions

      loop(r$(not sameas(r,"EastAsia")),
         if(0,
*           Fix RoR, Kstock endogenous
            omegak(r)         =  inf ;
            kstock.lo(r,tsim) = -inf ;
            kstock.up(r,tsim) = +inf ;
            trent.fx(r,tsim)  = 1 ;
         ) ;
      ) ;
   ) ;


$ontext
      loop(r$rphh(r),
         phhTaxFlag(r) = 1 ;
         iphh(r,iphh0) = yes ;
         phhTax.lo(r,i,tsim) = -inf ;
         phhTax.up(r,i,tsim) =  inf ;
         chiPhh.lo(r,tsim) = -inf ;
         chiPhh.up(r,tsim) =  inf ;
         if(0,
*           Fix the tax
            phhTax0.fx(r,iphh0,tsim) = 0.15 ;
            phhTax.l(r,iphh0,tsim) = 0.15 ; ;
         else
*           Fix consumption
            xa.fx(r,iphh0,h,tsim) = 0.85*xa.l(r,iphh0,h,t0) ;
            phhTax0.l(r,iphh0,tsim) = 0.15 ;
            phhTax.l(r,iphh0,tsim) = 0.15 ;
         ) ;
         phhTax0.fx(r,i,tsim)$(not iphh(r,i)) = -0.01 ;
         phhTax.l(r,i,tsim)$(not iphh(r,i)) = -0.01 ;
         chiPhh.l(r,tsim) = 1 ;
         phhTaxY.fx(r,tsim) = 0 ;
      ) ;
$offtext
   ) ;

$ontext
   ntmFlag = 1 ;
   ntmY.lo(r,tsim) = -inf ;
   ntmY.up(r,tsim) = +inf ;
   ntmAVE.fx(r,"TextWapp-c",s,tsim) = 0.05 ;
   chigNTM(r,r,tsim) = 1 ;
$offtext

*  kappak.fx("Oceania",a,tsim) = 0*kappak.l("Oceania",a,tsim) ;

$ontext
*  A single coalition

   rq("hic")     = yes ;

*  Include all agents

   emiTotETSFlag(r,em,"all")$mapr("hic",r) = yes ;

   emicap.fx("hic","co2","all",tsim) =
        0.90*EmiTot0("Oceania","CO2")*EmiTot.l("Oceania","CO2",tsim-1)
      + 0.83*EmiTot0("NAmerica","CO2")*EmiTot.l("NAmerica","CO2",tsim-1)
      + 0.83*EmiTot0("EU_28","CO2")*EmiTot.l("EU_28","CO2",tsim-1) ;


   emiCTax.lo(rq,"CO2","all",tsim) = 0 ;
   emiCTax.up(rq,"CO2","all",tsim) = +inf ;
   loop(r$mapr("hic",r),
      emiTax.lo(r,"CO2",aa,tsim)$mapETS("all",aa) = -inf ;
      emiTax.up(r,"CO2",aa,tsim)$mapETS("all",aa) = +inf ;
      emiTotETS.lo(r,"CO2","all",tsim) = -inf ;
      emiTotETS.up(r,"CO2","all",tsim) = +inf ;
   ) ;
   emiTotETS.l(r,em,aets,t) = 1 ;
   emiTotETS0(r,em,aets) = sum((is,aa)$(mapETS(aets,aa) and emi0(r,em,is,aa)), emi0(r,em,is,aa)) ;

   loop((mapr(rq,r), mapets("All",aa)),
      ifEmiCap(rq,"CO2","all") = yes ;
      ifEmiRcap(r,em,aa) = yes ;
   ) ;

$offtext

$ontext
   rqets(ra)$(sameas(ra,"Hic")) = yes ;
   maprETS("HIC", r)$(mapr("HIC",r)) = yes ;
   ifEmiETSCAPRQ(rqets, "CO2", "ke5") = yes ;
   ifEmiETSCap(r,"CO2",aa)$(sum(rqets$maprETS(rqets,r), 1$(mapETS("KE5", aa) and ifEmiETSCAPRQ(rqets, "CO2", "ke5")))) = yes ;
   emiCAPETS.fx(rqets,"CO2","KE5",tsim) = 0.85*sum(r$maprETS(rqETS,r), emiTotETS0(r,"CO2","KE5")) ;
   emiRegTaxETS.lo(rqets,"CO2","KE5",tsim) = -inf ;
   emiRegTaxETS.up(rqets,"CO2","KE5",tsim) = +inf ;
   emiRegTaxETS.l(rqets,"CO2","KE5",tsim) = 0.001*50 ;
   loop((r,aa)$ifEmiETSCap(r,"CO2",aa),
      emiTax.lo(r,"CO2",aa,t) = 0 ;
      emiTax.up(r,"CO2",aa,t) = +inf ;
      emiTax.l(r,"CO2",aa,t) = sum(rqets$maprets(rqets,r), sum(aets$mapETS(aets,aa), emiRegTaxETS.l(rqets,"CO2",aets,t))) ;
   ) ;

*  Add regional caps

   ifEmiCap = 1 ;
   emFlag("CO2") = 1 ;
   rq("Oceania")     = yes ;
   rq("NAmerica")    = yes ;
   rq("EU_28")       = yes ;

   emiCap.fx("Oceania","CO2",tsim)     = 0.90*EmiTot0("Oceania","CO2")*EmiTot.l("Oceania","CO2",tsim-1) ;
   emiCap.fx("NAmerica","CO2",tsim)    = 0.83*EmiTot0("NAmerica","CO2")*EmiTot.l("NAmerica","CO2",tsim-1) ;
   emiCap.fx("EU_28","CO2",tsim)       = 0.83*EmiTot0("EU_28","CO2")*EmiTot.l("EU_28","CO2",tsim-1) ;

   loop(rq$(sameas(rq,"Oceania") or sameas(rq,"NAmerica") or sameas(rq,"EU_28")),
      emiRegTax.lo(rq,"CO2",tsim) = 0 ;
      emiRegTax.up(rq,"CO2",tsim) = +inf ;
      emiTax.lo(r,"CO2",aa,tsim)$mapr(rq,r) = 0 ;
      emiTax.up(r,"CO2",aa,tsim)$mapr(rq,r) = +inf ;
   ) ;
$offtext

$ontext
   ifEmiCap      = 1 ;
   emFlag("CO2") = 1 ;
   rq("wld") = yes ;
   emiCap.fx(rq,"CO2",tsim) = 0.90*emiGbl.l("CO2", tsim-1)*emiGbl0("CO2") ;
   emiRegTax.lo(rq,"CO2",tsim) = -inf ;
   emiRegTax.up(rq,"CO2",tsim) = +inf ;
   emiTax.lo(r,"CO2",tsim) = -inf ;
   emiTax.up(r,"CO2",tsim) = +inf ;
   emiRegTax.l(rq,"CO2",tsim) = 0.001*40 ;
   emiTax.l(r,"CO2",tsim)     = emiRegTax.l("wld","CO2",tsim) ;
$offtext
*  emiTax.fx(r,"CO2",tsim) = 0.001*40 ;
) ;
