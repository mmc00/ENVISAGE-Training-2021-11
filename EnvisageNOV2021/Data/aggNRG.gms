if(%ifCSV%,
   put csv ;

*  Production

   loop((r,a),
      loop(i$(edf%2(i,a,r) + emf%2(i,a,r)),
         put "%1", "NRG", r.tl, i.tl, a.tl, (edf%2(i,a,r) + emf%2(i,a,r)) / ;
      ) ;
      loop(i$(mdf%2(i,a,r) + mmf%2(i,a,r)),
         put "%1", "CO2", r.tl, i.tl, a.tl, (mdf%2(i,a,r) + mmf%2(i,a,r)) / ;
      ) ;
      loop(i$(mdf%2(i,a,r) + mmf%2(i,a,r)),
         put "%1", "CO2_CEQ", r.tl, i.tl, a.tl, (GWP%2("CO2",r,"AR5")*(mdf%2(i,a,r) + mmf%2(i,a,r))) / ;
      ) ;

      $$iftheni.nco2a "%NCO2%" == "ON"
         loop(em,
            loop(i$(EMI_IO%2(EM, i, a, r)),
               put "%1", em.tl, r.tl, i.tl, a.tl, (EMI_IO%2(EM, i, a, r)) / ;
            ) ;
            loop(i$(EMI_IOP%2(EM, i, a, r)),
               csv.pc=2 ; put '"%1","', em.tl:card(em.tl),'_PR"' ; csv.pc=5 ;
               put r.tl, i.tl, a.tl, (EMI_IOP%2(EM, i, a, r)) / ;
            ) ;
            loop(fp$(EMI_ENDW%2(EM, fp, a, r)),
               put "%1", em.tl, r.tl, fp.tl, a.tl, (EMI_ENDW%2(EM, fp, a, r)) / ;
            ) ;
            put$(EMI_QO%2(EM, a, r)) "%1", em.tl, r.tl, "qo", a.tl, (EMI_QO%2(EM, a, r)) / ;
         ) ;

*        Output same in CO2eq

         loop(GHG,
            loop(i$(EMI_IO%2(GHG, i, a, r)),
               csv.pc=2 ; put '"%1","', GHG.tl:card(ghg.tl),'_CEQ"' ; csv.pc=5 ;
               put r.tl, i.tl, a.tl, (GWP%2(GHG,r,"AR5")*EMI_IO%2(GHG, i, a, r)) / ;
            ) ;
            loop(i$(EMI_IOP%2(GHG, i, a, r)),
               csv.pc=2 ; put '"%1","', GHG.tl:card(ghg.tl),'_PR_CEQ"' ; csv.pc=5 ;
               put r.tl, i.tl, a.tl, (GWP%2(GHG,r,"AR5")*EMI_IOP%2(GHG, i, a, r)) / ;
            ) ;
            loop(fp$(EMI_ENDW%2(GHG, fp, a, r)),
               csv.pc=2 ; put '"%1","', GHG.tl:card(ghg.tl),'_CEQ"' ; csv.pc=5 ;
               put r.tl, fp.tl, a.tl, (GWP%2(GHG,r,"AR5")*EMI_ENDW%2(GHG, fp, a, r)) / ;
            ) ;
            csv.pc=2 ; put '"%1","', GHG.tl:card(ghg.tl),'_CEQ"' ; csv.pc=5 ;
            put r.tl, "qo", a.tl, (GWP%2(GHG,r,"AR5")*EMI_QO%2(GHG, a, r)) / ;
         ) ;
      $$endif.nco2a
   ) ;

*  Final demand

   loop(r,
      loop(i$(edp%2(i,r) + emp%2(i,r)),
         put "%1", "NRG", r.tl, i.tl, "PRIV", (edp%2(i,r) + emp%2(i,r)) / ;
      ) ;
      loop(i$(mdp%2(i,r) + mmp%2(i,r)),
         put "%1", "CO2", r.tl, i.tl, "PRIV", (mdp%2(i,r) + mmp%2(i,r)) / ;
      ) ;
      loop(i$(mdp%2(i,r) + mmp%2(i,r)),
         put "%1", "CO2_CEQ", r.tl, i.tl, "PRIV", (GWP%2("CO2",r,"AR5")*(mdp%2(i,r) + mmp%2(i,r))) / ;
      ) ;

      $$iftheni.nco2b "%NCO2%" == "ON"
         loop(em,
            loop(i$EMI_HH%2(em, i, r),
               put "%1", em.tl, r.tl, i.tl, "PRIV", (EMI_HH%2(em, i, r)) / ;
            ) ;
         ) ;

*        Output same in CO2eq

         loop(ghg,
            loop(i$EMI_HH%2(GHG, i, r),
               csv.pc=2 ; put '"%1","', GHG.tl:card(ghg.tl),'_CEQ"' ; csv.pc=5 ;
               put r.tl, i.tl, "PRIV", (GWP%2(GHG,r,"AR5")*EMI_HH%2(GHG, i, r)) / ;
            ) ;
         ) ;
      $$endif.nco2b

      loop(i$(edg%2(i,r) + emg%2(i,r)),
         put "%1", "NRG", r.tl, i.tl, "GOV", (edg%2(i,r) + emg%2(i,r)) / ;
      ) ;
      loop(i$(mdg%2(i,r) + mmg%2(i,r)),
         put "%1", "CO2", r.tl, i.tl, "GOV", (mdg%2(i,r) + mmg%2(i,r)) / ;
      ) ;
      loop(i$(edi%2(i,r) + emi%2(i,r)),
         put "%1", "NRG", r.tl, i.tl, "INV", (edi%2(i,r) + emi%2(i,r)) / ;
      ) ;
      loop(i$(mdi%2(i,r) + mmi%2(i,r)),
         put "%1", "CO2", r.tl, i.tl, "INV", (mdi%2(i,r) + mmi%2(i,r)) / ;
      ) ;

   ) ;

*  Exports

   if(ifAggTrade,
      loop((r,i)$(sum(rp, EXI%2(i,r,rp))),
         put "%1", "NRG", r.tl, i.tl, "BOP",  (sum(rp, EXI%2(i,r,rp))) / ;
      ) ;
   else
      loop((r,i,rp)$(EXI%2(i,r,rp)),
         put "%1", "NRG", r.tl, i.tl, rp.tl,  EXI%2(i,r,rp) / ;
      ) ;
   ) ;
) ;
