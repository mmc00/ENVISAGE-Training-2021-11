$iftheni.type "%SAVEMAP%" == "TXT"
file mapfile / %BaseName%Sets.txt / ;
$elseifi.type   "%SAVEMAP%" == "LATEX"
file mapfile / %BaseName%Sets.tex / ;
$endif.type

put mapfile ;
mapfile.pw=10000 ;

*  Output the regional dimensions

$iftheni.Latex  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Regional concordance}" / ;
put "\label{tab:RegConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.Latex

order = 0 ;
loop(mapRegsort(sortOrder,r),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag1 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', r.te(r):card(r.te), ' (', r.tl:card(r.tl),')",' ;
   $$elseifi.tag1 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', r.te(r):card(r.te), ' (', r.tl:card(r.tl),') & ' ;
   $$endif.tag1
   loop(mapr(r0,r),
      if(ifFirst,
         $$iftheni.tag2 "%SAVEMAP%" == "TXT"
            put '"', r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
            ifFirst = 0 ;
         $$elseifi.tag2 "%SAVEMAP%" == "LATEX"
            put r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
            ifFirst = 0 ;
         $$endif.tag2
      else
         put ', ', r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
      ) ;
   ) ;
   $$iftheni.tag3 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag3 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag3
) ;

$iftheni.LTX2  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX2

put / ;

*  Output the concordance for activities

$iftheni.LTX3  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Concordance for activities}" / ;
put "\label{tab:ActConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.LTX3

order = 0 ;

scalar order ; order = 0 ;
loop(mapActsort(sortOrder,actf),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag4 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl),')",' ;
   $$elseifi.tag4 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl),') & ' ;
   $$endif.tag4
   loop(mapaf(a,actf),
      loop(mapa(a0,a),
         if(ifFirst,
            $$iftheni.tag5 "%SAVEMAP%" == "TXT"
               put '"', a0.te(a0):card(a0.te), ' (', a0.tl:card(a0.tl), ')' ;
               ifFirst = 0 ;
            $$elseifi.tag5 "%SAVEMAP%" == "LATEX"
               put a0.te(a0):card(a0.te), ' (', a0.tl:card(a0.tl), ')' ;
               ifFirst = 0 ;
            $$endif.tag5
         else
            put ', ', a0.te(a0):card(a0.te), ' (', a0.tl:card(a0.tl), ')' ;
         ) ;
      ) ;
   ) ;
   $$iftheni.tag6 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag6 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag6
) ;

$iftheni.LTX4  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX4

put / ;

*  Output the concordance for commodities

$iftheni.LTX5  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Concordance for commodities}" / ;
put "\label{tab:CommConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.LTX5

order = 0 ;

scalar order ; order = 0 ;
loop(mapCommsort(sortOrder,commf),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag7 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl),')",' ;
   $$elseifi.tag7 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl),') & ' ;
   $$endif.tag7
   loop(mapif(i,commf),
      loop(mapi(i0,i),
         if(ifFirst,
            $$iftheni.tag8 "%SAVEMAP%" == "TXT"
               put '"', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$elseifi.tag8 "%SAVEMAP%" == "LATEX"
               put i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$endif.tag8
         else
            put ', ', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
         ) ;
      ) ;
   ) ;
   $$iftheni.tag9 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag9 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag9
) ;

$iftheni.LTX6  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX6
put / ;

*  Output the aggregate regional dimensions

$iftheni.Latex  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Regional aggregation concordance}" / ;
put "\label{tab:RegAggConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.Latex

alias(r,rp) ;
set rra(ra) "Aggregate regions only" ;
loop((r,ra)$(not sameas(r,ra)), rra(ra) = yes ; ) ;

order = 0 ;
loop(ra$rra(ra),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag1 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', ra.te(ra):card(ra.te), ' (', ra.tl:card(ra.tl),')",' ;
   $$elseifi.tag1 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', ra.te(ra):card(ra.te), ' (', ra.tl:card(ra.tl),') & ' ;
   $$endif.tag1
   loop(rp$mapra(ra,rp),
      if(ifFirst,
         $$iftheni.tag2 "%SAVEMAP%" == "TXT"
            put '"', rp.te(rp):card(rp.te), ' (', rp.tl:card(rp.tl), ')' ;
            ifFirst = 0 ;
         $$elseifi.tag2 "%SAVEMAP%" == "LATEX"
            put rp.te(rp):card(rp.te), ' (', rp.tl:card(rp.tl), ')' ;
            ifFirst = 0 ;
         $$endif.tag2
      else
         put ', ', rp.te(rp):card(rp.te), ' (', rp.tl:card(rp.tl), ')' ;
      ) ;
   ) ;
   $$iftheni.tag3 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag3 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag3
) ;

$iftheni.LTX2  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX2

put / ;

*  Output the aggregate activity dimensions

$iftheni.Latex  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Activity aggregation concordance}" / ;
put "\label{tab:ActAggConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.Latex

order = 0 ;
loop(aga,
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag1 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', aga.te(aga):card(aga.te), ' (', aga.tl:card(aga.tl),')",' ;
   $$elseifi.tag1 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', aga.te(aga):card(aga.te), ' (', aga.tl:card(aga.tl),') & ' ;
   $$endif.tag1
   loop(mapaga(aga,actf),
      if(ifFirst,
         $$iftheni.tag2 "%SAVEMAP%" == "TXT"
            put '"', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl), '-a)' ;
            ifFirst = 0 ;
         $$elseifi.tag2 "%SAVEMAP%" == "LATEX"
            put actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl), '-a)' ;
            ifFirst = 0 ;
         $$endif.tag2
      else
         put ', ', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl), '-a)' ;
      ) ;
   ) ;
   $$iftheni.tag3 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag3 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag3
) ;

$iftheni.LTX2  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX2

put / ;

*  Output the aggregate commodity dimensions

$iftheni.Latex  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Commodity aggregation concordance}" / ;
put "\label{tab:CommAggConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif.Latex

order = 0 ;
loop(ia,
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni.tag1 "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', ia.te(ia):card(ia.te), ' (', ia.tl:card(ia.tl),')",' ;
   $$elseifi.tag1 "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', ia.te(ia):card(ia.te), ' (', ia.tl:card(ia.tl),') & ' ;
   $$endif.tag1
   loop(mapia(ia,commf),
      if(ifFirst,
         $$iftheni.tag2 "%SAVEMAP%" == "TXT"
            put '"', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl), '-c)' ;
            ifFirst = 0 ;
         $$elseifi.tag2 "%SAVEMAP%" == "LATEX"
            put commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl), '-c)' ;
            ifFirst = 0 ;
         $$endif.tag2
      else
         put ', ', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl), '-c)' ;
      ) ;
   ) ;
   $$iftheni.tag3 "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi.tag3 "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif.tag3
) ;

$iftheni.LTX2  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif.LTX2

put / ;
