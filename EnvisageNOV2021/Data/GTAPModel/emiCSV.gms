if(%ifCSV%,
   put csv ;

*  Production

   loop((r,a0),
      loop(i0$(edf%2(i0,a0,r) + emf%2(i0,a0,r)),
         put "NRG", r.tl, i0.tl, a0.tl, %1:1:0, (edf%2(i0,a0,r) + emf%2(i0,a0,r)) / ;
      ) ;
      loop(i0$(mdf%2(i0,a0,r) + mmf%2(i0,a0,r)),
         put "CO2", r.tl, i0.tl, a0.tl, %1:1:0, (mdf%2(i0,a0,r) + mmf%2(i0,a0,r)) / ;
      ) ;

      $$iftheni.nco2a "%NCO2%" == "ON"
         loop(EM,
            loop(i0$(EMI_IO%2(EM, i0, a0, r)),
               put em.tl, r.tl, i0.tl, a0.tl, %1:1:0, (EMI_IO%2(EM, i0, a0, r)) / ;
            ) ;
            loop(i0$(EMI_IOP%2(EM, i0, a0, r)),
               put em.tl, r.tl, i0.tl, a0.tl, %1:1:0, (EMI_IOP%2(EM, i0, a0, r)) / ;
            ) ;
            loop(fp$(EMI_ENDW%2(EM, fp, a0, r)),
               put em.tl, r.tl, fp.tl, a0.tl, %1:1:0, (EMI_ENDW%2(EM, fp, a0, r)) / ;
            ) ;
            put$(EMI_QO%2(EM, a0, r)) em.tl, r.tl, "qo", a0.tl, %1:1:0, (EMI_QO%2(EM, a0, r)) / ;
         ) ;

*        Output same in CO2eq
         loop(GHG,
            loop(i0$(EMI_IO%2(GHG, i0, a0, r)),
               put ghg.tl, r.tl, i0.tl, a0.tl, %1:1:0, (GWP*(GHG,r,"AR5")*EMI_IO_Ceq%2(GHG, i0, a0, r)) / ;
            ) ;
            loop(i0$(EMI_IOP%2(GHG, i0, a0, r)),
               put ghg.tl, r.tl, i0.tl, a0.tl, %1:1:0, (GWP*(GHG,r,"AR5")*EMI_IOP_Ceq%2(GHG, i0, a0, r)) / ;
            ) ;
            loop(fp$(EMI_ENDW%2(GHG, fp, a0, r)),
               put ghg.tl, r.tl, fp.tl, a0.tl, %1:1:0, (GWP*(GHG,r,"AR5")*EMI_ENDW_Ceq%2(GHG, fp, a0, r)) / ;
            ) ;
            put$(EMI_QO%2(GHG, a0, r)) ghg.tl, r.tl, "qo", a0.tl, %1:1:0, (GWP*(GHG,r,"AR5")*EMI_QO_Ceq%2(GHG, a0, r)) / ;
         ) ;
      $$endif.nco2a
   ) ;

*  Final demand

   loop(r,
      loop(i0$(edp%2(i0,r) + emp%2(i0,r)),
         put "NRG", r.tl, i0.tl, "PRIV", %1:1:0, (edp%2(i0,r) + emp%2(i0,r)) / ;
      ) ;
      loop(i0$(mdp%2(i0,r) + mmp%2(i0,r)),
         put "CO2", r.tl, i0.tl, "PRIV", %1:1:0, (mdp%2(i0,r) + mmp%2(i0,r)) / ;
      ) ;

      $$iftheni.nco2b "%NCO2%" == "ON"
         loop(em,
            loop(i0$EM_HH%2(em, i0, r),
               put em.tl, r.tl, i0.tl, "PRIV", %1:1:0, (EM_HH%2(em, i0, r)) / ;
            ) ;
         ) ;

*           Output same in CO2eq

         loop(ghg,
            loop(i0$NC_HH%2(ghg, i0, r),
               put ghg.tl, r.tl, i0.tl, "PRIV", %1:1:0, (GWP*(GHG,r,"AR5")*EM_HH%2(GHG, i0, r)) / ;
            ) ;
         ) ;
      $$endif.nco2b

      loop(i0$(edg%2(i0,r) + emg%2(i0,r)),
         put "NRG", r.tl, i0.tl, "GOV", %1:1:0, (edg%2(i0,r) + emg%2(i0,r)) / ;
      ) ;
      loop(i0$(mdg%2(i0,r) + mmg%2(i0,r)),
         put "CO2", r.tl, i0.tl, "GOV", %1:1:0, (mdg%2(i0,r) + mmg%2(i0,r)) / ;
      ) ;
      loop(i0$(edi%2(i0,r) + emi%2(i0,r)),
         put "NRG", r.tl, i0.tl, "INV", %1:1:0, (edi%2(i0,r) + emi%2(i0,r)) / ;
      ) ;
      loop(i0$(mdi%2(i0,r) + mmi%2(i0,r)),
         put "CO2", r.tl, i0.tl, "INV", %1:1:0, (mdi%2(i0,r) + mmi%2(i0,r)) / ;
      ) ;

   ) ;

*  Exports

   loop((r,i0,rp)$(EXI%2(i0,r,rp)),
      put "NRG", r.tl, i0.tl, rp.tl, %1:1:0, EXI%2(i0,r,rp) / ;
   ) ;
) ;
