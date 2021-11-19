set bkstp "Set of backstop activities" /
   HFL      "Hydrogen fuel"
   CCS      "Coal-fired CCS"
   GCS      "Gas-fired CCS"
   ADV      "Advanced nuclear"
/ ;

singleton set aloc(actf) "Sort order for backstops" / XEL / ;

*  Aggregation mappings

set mapabkstp(aga,bkstp) /
   tman-a.hfl
   tsrv-a.(ccs,gcs,adv)
   ttot-a.(hfl,ccs,gcs,adv)
/ ;

set bkstpman(bkstp) / hfl / ;
set bkstpsrv(bkstp) / CCS, GCS, ADV / ;
set bkstpely(bkstp) / CCS, GCS, ADV / ;
set bkstpprm(bkstp) / ADV / ;
set mappowbkstp(pb,bkstpely) /
   GasP     .GCS
   coap     .CCS
   nucp     .ADV
/ ;

Parameters
   VDFBBKSTP(COMM, bkstp, REG)            "Firm purchases of domestic goods at basic prices"
   VDFPBKSTP(COMM, bkstp, REG)            "Firm purchases of domestic goods at purchaser prices"
   VMFBBKSTP(COMM, bkstp, REG)            "Firm purchases of imported goods at basic prices"
   VMFPBKSTP(COMM, bkstp, REG)            "Firm purchases of domestic goods at purchaser prices"

   EVFBBKSTP(ENDW, bkstp, REG)            "Primary factor purchases at basic prices"
   EVFPBKSTP(ENDW, bkstp, REG)            "Primary factor purchases at purchaser prices"
   EVOSBKSTP(ENDW, bkstp, REG)            "Factor remuneration after income tax"
   VOS(bkstp,reg)                         "Value of output"
;

Parameter CostBkstp(bkstp) /

HFL   2.0
CCS   1.5
GCS   1.5
ADV   2.0

/ ;

set mapCost(bkstp,ACTS) /
   ccs.coalbl
   gcs.gasbl
   adv.NUCLEARBL
/ ;

loop(mapCost(bkstp,ACTS),
*  Assume same cost structure, except for capital

*  Initial output of corresponding conventional technology

   vos(bkstp,reg) = sum(comm, VDFP(Comm, acts, reg)+VMFP(Comm, acts, reg)) + sum(endw, EVFP(endw, acts, reg)) ;

   VDFBBKSTP(COMM, bkstp, REG)$vos(bkstp,reg) = (VDFB(COMM, acts, REG)/CostBkstp(bkstp))/vos(bkstp,reg) ;
   VDFPBKSTP(COMM, bkstp, REG)$vos(bkstp,reg) = (VDFP(COMM, acts, REG)/CostBkstp(bkstp))/vos(bkstp,reg) ;
   VMFBBKSTP(COMM, bkstp, REG)$vos(bkstp,reg) = (VMFB(COMM, acts, REG)/CostBkstp(bkstp))/vos(bkstp,reg) ;
   VMFPBKSTP(COMM, bkstp, REG)$vos(bkstp,reg) = (VMFP(COMM, acts, REG)/CostBkstp(bkstp))/vos(bkstp,reg) ;
   EVFPBKSTP(ENDW, bkstp, REG)$vos(bkstp,reg) = (EVFP(ENDW, acts, REG)/CostBkstp(bkstp))/vos(bkstp,reg) ;
   EVFPBKSTP(CAPT, bkstp, REG)$vos(bkstp,reg) = ((CostBkstp(bkstp) - 1) + EVFP(CAPT, acts, REG)/vos(bkstp,reg))/CostBkstp(bkstp) ;
   EVFBBKSTP(ENDW, bkstp, REG)$EVFP(ENDW, acts, REG) = EVFPBKSTP(ENDW, bkstp, REG) * EVFB(ENDW, acts, REG) / EVFP(ENDW, acts, REG) ;
   EVOSBKSTP(ENDW, bkstp, REG)$EVFB(ENDW, acts, REG) = EVFBBKSTP(ENDW, bkstp, REG) * EVOS(ENDW, acts, REG) / EVFB(ENDW, acts, REG) ;
) ;

Parameter EmiBkstp(bkstp) /

HFL   2.0
CCS   1.5
GCS   1.5
ADV   2.0

/ ;

*  Phase in assumptions

Table BStpPhaseIn(bkstp, *)
      Start StartShare  Stop  StopShare
hfl    2030    0.05     2050     0.3
ccs    2030    0.05     2050     0.3
gcs    2030    0.05     2050     0.3
adv    2030    0.05     2050     0.3
;

file bcsv / bkstp.csv / ;
if(1,
   put bcsv ;
   put "Var,Region,Comm,Act,Value" / ;
   bcsv.pc=5 ; bcsv.nd=9 ;
   loop(mapCost(bkstp,ACTS),
      loop(reg,
         loop(comm,
            put "VDFB", reg.tl, comm.tl, bkstp.tl, VDFBBKSTP(comm, bkstp, reg) / ;
            put "VDFP", reg.tl, comm.tl, bkstp.tl, VDFPBKSTP(comm, bkstp, reg) / ;
            put "VMFB", reg.tl, comm.tl, bkstp.tl, VMFBBKSTP(comm, bkstp, reg) / ;
            put "VMFP", reg.tl, comm.tl, bkstp.tl, VMFPBKSTP(comm, bkstp, reg) / ;
            put "VDFB", reg.tl, comm.tl, acts.tl, VDFB(comm, acts, reg) / ;
            put "VDFP", reg.tl, comm.tl, acts.tl, VDFB(comm, acts, reg) / ;
            put "VMFB", reg.tl, comm.tl, acts.tl, VMFB(comm, acts, reg) / ;
            put "VMFP", reg.tl, comm.tl, acts.tl, VMFB(comm, acts, reg) / ;
         ) ;
         loop(endw,
            put "EVFB", reg.tl, endw.tl, bkstp.tl, EVFBBKSTP(endw, bkstp, reg) / ;
            put "EVFP", reg.tl, endw.tl, bkstp.tl, EVFPBKSTP(endw, bkstp, reg) / ;
            put "EVOS", reg.tl, endw.tl, bkstp.tl, EVOSBKSTP(endw, bkstp, reg) / ;
            put "EVFB", reg.tl, endw.tl, acts.tl, EVFB(endw, acts, reg) / ;
            put "EVFP", reg.tl, endw.tl, acts.tl, EVFP(endw, acts, reg) / ;
            put "EVOS", reg.tl, endw.tl, acts.tl, EVOS(endw, acts, reg) / ;
         ) ;
      ) ;
   ) ;
) ;
