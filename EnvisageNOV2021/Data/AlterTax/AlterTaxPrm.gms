* ------------------------------------------------------------------------------
*
*  At a minimum, the user needs to assign the following:
*
*     utility     Utility specification: default is CDE, alternative is CD
*     rorFlag     Valid options are capFlex, capShrFix, capFix
*
* ------------------------------------------------------------------------------

* $setGlobal utility    CDE
$setGlobal utility  CD
$setGlobal savfFlag capFix

$include "%baseName%\Alt\%baseName%Sets.gms"

acronym CDE, CD, capFlex, capshrFix, capFix, capSFix ;

set rs(r) "Simulation regions" ;

alias(is,js) ; alias(r,rp) ; alias(i,j) ; alias(j,jp) ; alias(m,j) ;
alias(i0, m0) ; alias(i0, j0) ;

*  Parameters from GTAP database

Parameters
   esubt(a0,r)       "Top level CES substitution elasticity"
   esubc(a0,r)       "ND nest CES substitution elasticity"
   esubva(a0,r)      "VA nest CES substitution elasticity"

   etraq(a0,r)       "CET make elasticity"
   esubq(a0,r)       "CES make elasticity"

   incpar(i0,r)      "CDE expansion parameter"
   subpar(i0,r)      "CDE substitution parameter"

   esubg(r)          "CES government expenditure elasticity"
   esubi(r)          "CES investment expenditure elasticity"

   esubd(i0,r)       "Top level Armington elasticity"
   esubm(i0,r)       "Second level Armington elasticity"
   esubs(i0)         "CES margin elasticity"

   etrae(fp,r)       "CET elasticity for factors"
   rorFlex0(r)       "Flexibility of foreign capital"
;

execute_loaddc "%baseName%\Alt\%baseName%Par.gdx"
   esubt=esubt, esubc=esubc, esubva=esubva,
   etraq=etraq, esubq=esubq,
   incpar=incpar, subpar=subpar, esubg=esubg, esubi=esubi,
   esubd=esubd, esubm=esubm, esubs=esubs,
   etrae=etrae, rorFlex0=rorFlex
    ;

*!!!! Convert etrae back to a negative to be consistent with the GTAP in GAMS model

etrae(fp,r)$(etrae(fp,r) ne INF and etrae(fp,r) > 0) = -etrae(fp,r) ;

Parameters

*  Parameters normally sourced from GTAP

   sigmap(r,a)       "Top level CES production elasticity (ND/VA)"
   sigmand(r,a)      "CES elasticity across intermediate inputs"
   sigmav(r,a)       "CES elasticity across factors of production"

   omegas(r,a)       "Commodity supply CET elasticity"
   sigmas(r,i)       "Commodity supply CES elasticity"

   eh0(r,i)          "CDE expansion parameter"
   bh0(r,i)          "CDE substitution parameter"

   sigmag(r)         "CES government expenditure elasticity"
   sigmai(r)         "CES investment expenditure elasticity"

   sigmam(r,i,aa)    "Top level Armington elasticity"
   sigmaw(r,i)       "Second level Armington elasticity"
   sigmamg(m)        "CES expenditure elasticity for margin services exports"

   omegaf(r,fp)      "CET mobility elasticity for mobile factors"
   rorFlex(r,t)      "Flexibility of foreign capital"

*  Parameters in addition to standard GTAP model

   omegax(r,i)       "Top level output CET elasticity"
   omegaw(r,i)       "Second level export CET elasticity"

   etaf(r,fp)        "Aggregate factor supply elasticity"
   etaff(r,fp,a)     "Sector specific supply elasticity for non-mobile factors"

   mdtx0(r)          "Initial marginal tax rate"
   RoRFlag           "Capital account closure flag"
;

*  Overrides for GTAP-based parameters
*  If no overrides, parameters will be set in 'cal.gms'

sigmap(r,a)    = na ;
sigmand(r,a)   = na ;
sigmav(r,a)    = na ;

omegas(r,a)    = na ;
sigmas(r,i)    = na ;

eh0(r,i)       = na ;
bh0(r,i)       = na ;

sigmag(r)      = na ;
sigmai(r)      = na ;

sigmam(r,i,aa) = na ;
sigmaw(r,i)    = na ;
sigmamg(m)     = na ;

omegaf(r,fm)   =  na ;
rorFlex(r,t)   = rorFlex0(r) ;

*  Overrides

sigmap(r,a)   = 1.01 ;
sigmand(r,a)  = 1.01 ;
sigmav(r,a)   = 1.01 ;

omegas(r,a)   = 1.01 ;
sigmas(r,i)   = 1.01 ;

sigmag(r)     = 1.01 ;
sigmai(r)     = 1.01 ;

sigmam(r,i,aa) = 1.01 ;
sigmaw(r,i)    = 1.01 ;
sigmamg(m)     = 1.01 ;

*  Other initialization

omegax(r,i)   = inf ;
omegaw(r,i)   = inf ;

etaf(r,fm)    = 0 ;
etaff(r,fp,a) = 0 ;

mdtx0(r)      = na ;

rorFlag       = capFix ;
