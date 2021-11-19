if(sameas(tsim,"miceberg"),
   lambdaw(s,i,d,tsim) = 1 + 0.01 + 0.01*uniform(-1,1) ;

elseif(sameas(tsim,"xiceberg")),
   lambdax(s,i,d,tsim) = 1 + 0.03 + 0.01*uniform(-1,1) ;

elseif(sameas(tsim,"diceberg")),
   lambdaw(s,i,d,tsim) = lambdaw(s,i,d,"miceberg") ;
   lambdax(s,i,d,tsim) = lambdax(s,i,d,"xiceberg") ;
) ;
