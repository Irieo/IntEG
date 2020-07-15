*########################## fixing Variables ##################################

CAP_new.fx('RoR',co,year)        =0      ;
CAP_new.fx('Biomass',co,year)    =0      ;
CAP_new.fx(ReservT,co,year)      =0      ;
*CAP_new.fx(i,co,'y2015')         =0      ;



*Gas grid investments are fixed to interconnected arcs
grid_new.fx(n,m,year)$(not distance(n,m)) = 0;

*########################## options ##################################

    option LP = CPLEX;
    option threads = 0;
    option resLim=86400;

    LSEWglobal.optfile = 1;
    LSEWglobal.dictfile=0;
*    LSEWglobal.savepoint=1;
*    LSEWglobal.SCALEOPT = 1;
*    OBJECTIVE_GLOBAL.scale = 1e006;

* Turn off the listing of the input file
* Turn off the listing and cross-reference of the symbols used
$offlisting
$offsymxref offsymlist;
option
    limrow = 0,
    limcol = 0,
    solprint = off,
    sysout = off;
