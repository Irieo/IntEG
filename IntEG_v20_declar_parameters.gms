
*********************************  ELECTRICITY  MODEL  *************************

    Parameters
* Generation Cost Parameters

        vc_f(i,co,year,allscen)             unit cost (€ per MWhel) at minimum load level
        vc_m(i,co,year,allscen)             unit cost (€ per MWhel) at minimum load level
        co2_price_upload(scen_up,year)      co2_price EUR per ton to upload data set for all scenarios
        co2_price(allscen,year)             co2_price EUR per ton
        fc_upload(i,n,year,scen_up)         fuel costs [€ per MWhth] to upload data set for all scenarios
        fc(i,co,year,allscen)               fuel costs [€ per MWhth]

        sc(i)            startup costs (€ per MW)
        ic(i)            annualized investment costs

        discountfactor    discount factor to discount cash flows

*Capacity Parameters

        cap_max(i,n)                                maximum potential of installed capacity for each technology
        cap_existing_upload(i,n,year,scen_up)       already fixed capacities for each year to upload data set for all scenarios
        cap_existing(i,n,year,allscen)              already fixed capacities for each year
        g_min(i)                                    minimum generation

        eta_f(i,n,year)                         efficiency at full load
        eta_m(i,n,year)                         efficiency at min load
        carb_cont(i)                            carbon content of a fossil fuel (thermal)
        af(i,n)                                 availability factor for conv. technologies
        co_af(i,n)                              country specific availabilities
        CHP_factor(n,year)                      factor to scale the CHP production by gas power plants

*Time Varying load and RES parameters
        pf(i,n,t_all)                       hourly production factor for RES
        demand(co,t,year,allscen)           electricity demand per year
        demand_upload(n,t_all,year,scen_up) electricity demand per year (scenario dependent upload)
        all_dem(n,year,scen_up)             overall consumption within one year for each country
        VoLa(co)                            value of lost adequacy
        heat_factor(t_all,n)                  hourly degree day


*Electricity Transfer Parameters
        ntc(co,year,coco)                   Net Transfer Capacities between two nodes
        ntc_dist(co,coco)                   distance between two electricity nodes [km]

*Data Upload Parameters
        techup           technology Upload
        genup            generation capacity upload
        timeup           upload of time data (Demand)
        nodeup           upload of country specific data
        RESup            upload for RES production factors

*EVP Values
    EVP_demand(co,t,year)
    EVP_cap_existing(i,co,year)
    EVP_fc(i,co,year)
    EVP_co2_price(year)
    EVP_vc_f(i,co,year)
    EVP_vc_m(i,co,year)

        ;

    Scalars
        cpf              capacity power factor for storages                                      /9/
        flh_Reservoir    full load hours reservoir                                               /6100/
        volg             dummy value for gas shedding (for INFES checks)                         /1000000/
        ic_ntc           specific investment costs for NTC in EUR per MW and km                  /81/
        ic_gas_grid      specific investment costs for gas infrastructure in EUR per MWh*km      /0.000437/
        ic_LNG           specific investment costs LNG regasification in EUR per MWh             /0.246298/
        discount_rate    discount rate to discount cash flows                                    /0.06/
        inf_rate         average annual inflation rate to convert cost data y2015 to y2020       /0.013/
        inf_factor       converting cost from y2015 to y2020 
        ;

* if 2015: discountfactor(year) = 1/((1+discount_rate)**((ord(year)-1)*5));
        discountfactor(year) = 1/((1+discount_rate)**((ord(year)-1)*5));
        inf_factor           = 1 * (1+inf_rate)**5;

*********************************  GAS  MODEL  *************************

    PARAMETERS

    #production capacities LP
        LP_prod_costs_gas(p,n)          linearized production cost
        LP_prodCap(p,n,year,month)      capacity blocks at each producer node
        LP_prod_table                   data table

    #capacity block
        transCap(n,m)                  transportation capacity
        transMC(n,m)                   transportation marginal costs
        extra_cap(n,m, year, month)    exogenous capacity additions for all infrastructure elements
        distance(n,m)                  matrix of distances between trading nodes (inner-EU grid)

    #demand function block
        cons_EUCO(co, year, month)      gas consumption EUCO30 scenario
        cons_ST(co, year, month)        gas consumption ST scenario
        cons_DG(co, year, month)        gas consumption DG scenario
*        cons_scen(co, year, month,scen) consumption in a spesific scenario branch
        nonPowerDem(co,year,month,allscen) non power sector gas demand in a spesific scenario branch

        PS_EUCO(co, year)               Share of Gas used for Electricity in total natural Gas consumption (%)
        PS_ST(co, year)                 Share of Gas used for Electricity in total natural Gas consumption (%)
        PS_DG(co, year)                 Share of Gas used for Electricity in total natural Gas consumption (%)
*        PS_Scen(co, year,scen)          Share of Gas used for Electricity in total natural Gas consumption (%)

    #mapping block (used for $ conditions)
        prod_to_node(P,n)               connects the each producer to its respective production node
        exp_direction(P,n)              all nodes that a producer can sell gas to
        exp_pipelines(P,n,m)            path for physical gas flow from producer to node m
        exp_eu_cut(eu_p,trgen)          European-only producers
        ws_direction_cut(W,n,co)        direction a wholesaler can deliver gas
        ws_to_home(W,n)                 connects the each wholesaler to its respective transport node
        ws_to_cons(n,co)                connects the each wholesaler to its respective consumption node
        ws_to_stor(co)                  nodes with storages
        reg_to_trans(n,m)               regasification node (terminal(m)) to its wholesaler
        prod_to_liq(p,n)                connects production node to its liquiefaction node (terminal)
        prod_w_liq(P)                   producers with liquifation terminals

    #storage block
        stor_cons_cap(co,year, month)    storage capacity constraint
        stor_min_obl (co)                minimum storage level (obligation)
        stor_loss(co)                    storage gas loss per cycle
        stor_cons_in(co, year, month)    storage injection speed constraint
        stor_cons_out(co, year, month)   storage withdraw speed constraint
        st_lev_start(co)
        st_lev_end(co)

    #Additional block
        LTC(n,m,year, month)     long-term contracts obligation
        arc_loss(p,n)          loss of gas flows in an arc n-m (p-n is a virtual arc for gas liquefaction)
        ;

    SCALARS

        TOP             Take-or-Pay obligation part in LTCs
        stor_cost_in    cost for gas injection into storage
        stor_cost_out   cost for gas withdrawal from storage
        SlevelF         storage stock level on first period
        SlevelL         storage stock level on last period
        ;

*###############################################################################
*                               READING OF SETS & DATA
*###############################################################################

*Don't write comments inside onecho file!
$onecho > ImportINTEG.txt

        set=N               rng=nodemaps!B2       rdim=1
        set=P               rng=nodemaps!D60      rdim=1
        set=W               rng=nodemaps!D37:D57  rdim=1

        set=prall           rng=nodemaps!E4       rdim=1
        set=trgen           rng=nodemaps!E37:E57  rdim=1
        set=co              rng=nodemaps!F37:F57  rdim=1
        set=coo             rng=nodemaps!F37:F56  rdim=1
        set=Liqn            rng=nodemaps!I4       rdim=1
        set=Regn            rng=nodemaps!L4       rdim=1
        set=storall         rng=nodemaps!M37      rdim=1

        par=PS_EUCO         rng=PS_EUCO!B5      cdim=1 rdim=1
        par=PS_ST           rng=PS_ST!B5        cdim=1 rdim=1
        par=PS_DG           rng=PS_DG!B5        cdim=1 rdim=1

        par=LTC         rng=LTC_M!B2          rdim=2 cdim=2
        par=TOP         rng=scalars!D30       dim=0

        par=stor_cost_in    rng=scalars!C4  dim=0
        par=stor_cost_out   rng=scalars!C5  dim=0
        par=stor_loss       rng=scalars!B10 cdim=0 rdim=1
        par=SlevelF         rng=scalars!I4  dim=0
        par=SlevelL         rng=scalars!I5  dim=0

        Par=distance        Rng=NTC!A25:V45      Cdim=1 Rdim=1

        set=lng_p           rng=nodemaps!P4      rdim=1
        set=eu_p            rng=nodemaps!D132    rdim=1
        par=exp_eu_cut      rng=nodemaps!H132    rdim=2

        par=prod_to_node    rng=nodemaps!D60    rdim=2
        par=ws_to_home      rng=nodemaps!H37    rdim=2
        par=ws_to_cons      rng=nodemaps!E37    rdim=2
        par=ws_to_stor      rng=nodemaps!M37    rdim=1
        par=reg_to_trans    rng=nodemaps!L4     rdim=2
        par=prod_to_liq     rng=nodemaps!H60    rdim=2

        par=LP_prod_table   rng=prod_cost_gas!A60   rdim=2 cdim=2

        par=transCap        rng=cap.pipeREFm!c3     cdim=1 rdim=1
        par=extra_cap       rng=cap.pipeREFm!C66    rdim=2 cdim=2
        par=transMC         rng=MTCref!c3           cdim=1 rdim=1

        par=cons_EUCO      rng=Dem_EUCO30!b30       cdim=2 rdim=1
        par=cons_ST        rng=Dem_ST!b30           cdim=2 rdim=1
        par=cons_DG        rng=Dem_DG!b30           cdim=2 rdim=1

        par=stor_cons_cap   rng=StorRef!B29         cdim=2 rdim=1
        par=stor_min_obl    rng=StorRef!AB6         cdim=0 rdim=1
        par=stor_cons_in    rng=StorRef!B54         cdim=2 rdim=1
        par=stor_cons_out   rng=StorRef!B79         cdim=2 rdim=1

        set=i               Rng=Technology!A4    Cdim=0 Rdim=1
        Par=techup          Rng=Technology!A1    Cdim=3 Rdim=1
        Par=genup           Rng=Capacity!A1      Cdim=3 Rdim=2
        Par=timeup          Rng=ElDemTS!A1      Cdim=3 Rdim=1
        Par=RESup           Rng=RESdata!A1       Cdim=2 Rdim=1
        Par=nodeup          Rng=Country!A1       Cdim=3 Rdim=1
        Par=co2_price_upload Rng=Technology!L23   Cdim=1 Rdim=1
        Par=ntc             Rng=NTC!A1           Cdim=2 Rdim=1
        Par=ntc_dist        Rng=NTC!A48:T69      Cdim=1 Rdim=1
        Par=heat_factor     Rng=time!H2          Cdim=1 Rdim=1

$offecho

$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%%DataIn%.gdx cmerge=1 @ImportINTEG.txt
$gdxin %datadir%%DataIn%.gdx

$LOAD P, W, N, CO, COO, liqn, prall, trgen, storall,regn
$LOAD eu_p, exp_eu_cut, lng_p
$LOAD transCap, extra_cap, transMC,distance
$LOAD LP_prod_table, cons_EUCO, cons_ST, cons_DG
$LOAD prod_to_node, ws_to_home, ws_to_cons, ws_to_stor,reg_to_trans,  prod_to_liq
$LOAD stor_cost_in, stor_cost_out, stor_loss, stor_cons_cap, stor_min_obl, stor_cons_in, stor_cons_out, SlevelF, SlevelL
$LOAD LTC, TOP

***** LOAD ONLY INTEG DATA
$LOAD PS_EUCO, PS_ST, PS_DG

***** LOAD EL MODEL DATA
$LOAD i
$LOAD techup, genup, timeup, nodeup, RESup
$LOAD co2_price_upload
$LOAD ntc, ntc_dist, heat_factor

$gdxin

scalars
        hour_scaling            scaling investment costs to representitive hours
        t_number                number of representitive hours
        conversion_factor_gas   conversion from MWhth to BCM

        number_scenarios        number of scenarios
        RHS                     it is 1 div conversion_factor_gas
        scaling                 scales objective
        ;

        t_number              = card(t);
        hour_scaling          = t_number/8760;
        RHS                   = 8760/t_number;
        conversion_factor_gas = 1/(10.76*1000000);
        scaling               = 1;


*###############################################################################
*                               PREPARING SETS AND DATA
*###############################################################################

*********************************  GAS  MODEL  *********************************
        prod_w_liq(p)                                                               = sum(liqn, prod_to_liq(p,liqn));
        ws_direction_cut(w,n,co)$(ws_to_home(w,n) and ws_to_cons(n,co))             = 1;
        exp_direction(p,trgen)                                                      = 1;
        exp_direction(p,n)$prod_to_liq(p,n)                                         = 1;
        exp_direction(p,regn)$prod_w_liq(p)                                         = 1;
        exp_direction(eu_p,trgen)$(not exp_eu_cut(eu_p,trgen))                      = 0;

        exp_pipelines(p,n,m)$(prod_to_node(p,n) and transCap(n,m))                  = 1;
        exp_pipelines(p,trgen,jtrgen)$transCap(trgen,jtrgen)                        = 1;
        exp_pipelines(p,prall,liqn)$(prod_to_node(p,prall) AND prod_to_liq(p,liqn)) = 1;
        exp_pipelines(p,n,regn)$prod_to_liq(p,n)                                    = 1;
        exp_pipelines(p,regn,trgen)$reg_to_trans(regn,trgen)                        = 1;

        LP_prod_costs_gas(p,n)       = LP_prod_table(p,n,'cost','cost') ;
        LP_prodCap(p,n,year,month)   = LP_prod_table(p,n,'capacities (bcm)', year) / card(month);

        arc_loss(p,n)$(prod_to_liq(p,n)) = 0.10;

*       STORAGE LEVEL AT 'ZERO' PERIOD
        st_lev_start(co) = SlevelF * sum((year,month)$m_first_global(year,month), stor_cons_cap(co,year,month));
        st_lev_end(co) = SlevelF * sum((year,month)$m_last_global(year, month), stor_cons_cap(co,year,month));

*2272###############################################################################
*                              ELECTRICITY  MODEL
*###############################################################################

    ConvT(i)   = NO;
    noGas(i)   = NO;
    StorT(i)   = NO;
    ResT(i)    = NO;
    GasT(i)    = NO;
    ReservT(i) = NO;

    ConvT(i)  = techup(i,'Tech classification','','')= 1 OR techup(i,'Tech classification','','')= 4 ;
    StorT(i)  = techup(i,'Tech classification','','')= 2 ;
    ResT(i)   = techup(i,'Tech classification','','')= 3 ;
    GasT(i)   = techup(i,'Tech classification','','')= 4 ;
    noGas(i)  = techup(i,'Tech classification','','')= 1 ;
    ReservT(i)= techup(i,'Tech classification','','')= 5 ;

    Parameter GasTech(i);
    GasTech(i)$(techup(i,'Tech classification','','') eq 4) = yes;

display ConvT, StorT, noGas, ResT, GasT, ReservT;

*Define parameters from  'techup'
        ic (i)                               =techup(i,'annual investment costs','','');
        fc_upload(i,co,year,scen_up)         =techup(i,'fuel_cost',scen_up,year);
        fc_upload(GasT,'cn_NO',year,scen_up) = 10;
        carb_cont(i)                         = techup(i,'carbon content','','');
        eta_f(i,co,year)                     =techup(i,'efficiency_full_load','',year);
        eta_m(i,co,year)                     =eta_f(i,co,year) - techup(i,'efficiency_loss','','');
        sc(i)                                =techup(i,'sc','','');
        g_min(i)                             =techup(i,'g_min','','');
        co_af(i,co)                          =nodeup(co,i,'allyears','') ;
        af(i,co)                             =techup(i,'af','','') ;
        af(i,co)$co_af(i,co)                 =techup(i,'af','','')*co_af(i,co);

*Define parameters from  'genup'
        cap_max(i,co)= genup('EUCO_up',co,'max added capacity [MW]', '', i);
        cap_existing_upload(i,co,year,scen_up)=genup(scen_up,co,'installed Capacity [MW]',year,i);

*Define parameters from  'timeup'
        pf(ResT,co,t)=RESup(t,ResT,co);
*        all_dem(co,'y2015',scen_up) = nodeup(co,'overall demand','y2015','') ;
        all_dem(co,'y2020',scen_up) = nodeup(co,'overall demand','y2020','')    ;
        all_dem(co,'y2025',scen_up) = nodeup(co,'overall demand','y2025','')   ;
        all_dem(co,'y2030',scen_up) = nodeup(co,'overall demand','y2030',scen_up)  ;

*        demand_upload(co,t,'y2015',scen_up) = timeup(t,'y2015','real',co);
        demand_upload(co,t,'y2020',scen_up) = timeup(t,'y2020','best estimate',co) ;
        demand_upload(co,t,'y2030',scen_up) = timeup(t,'y2030',scen_up,co);
        demand_upload(co,t,'y2025',scen_up) = demand_upload(co,t,'y2020',scen_up)+(demand_upload(co,t,'y2030',scen_up)-demand_upload(co,t,'y2020',scen_up))/2;

        VoLa(co) = nodeup(co,'VoLA','','') ;

*Define parameters from 'countryup'
        CHP_factor(n,year)= nodeup(n,'CHP_production_gas',year,'') ;

        EVP_demand(co,t,year)                = sum(scen_up, demand_upload(co,t,year,scen_up))/3;
        EVP_cap_existing(i,co,year)          = sum(scen_up, cap_existing_upload(i,co,year,scen_up))/3;
        EVP_fc(i,co,year)                    = sum(scen_up, fc_upload(i,co,year,scen_up))/3;
        EVP_co2_price(year)                  = sum(scen_up, co2_price_upload(scen_up,year))/3;
        EVP_vc_f(i,co,year)$eta_f(i,co,year) = sum(scen_up, (fc_upload(i,co,year,scen_up)+ carb_cont(i)*co2_price_upload(scen_up,year))/eta_f(i,co,year))/3;
        EVP_vc_m(i,co,year)$eta_f(i,co,year) = sum(scen_up, (fc_upload(i,co,year,scen_up)+ carb_cont(i)*co2_price_upload(scen_up,year))/eta_m(i,co,year))/3;


*###############################################################################
* GAS MODEL - add gas network (endogenous) investmetns to avoid gas demand shedding
*###############################################################################

parameter  pipeinv_stoch_GasDem(n,m,year);
parameter  lnginv_stoch_GasDem(n,m,year);

*$gdxin %datadir%GasDemScen_Inv.gdx
*$Load  pipeinv_stoch_GasDem = grid_new.l
*$Load  lnginv_stoch_GasDem  = lng_new.l
*$gdxin

*execute_unload '%datadir%newgasgrid.gdx' pipeinv_stoch_GasDem,lnginv_stoch_GasDem;

$gdxin %datadir%newgasgrid.gdx
$Load  pipeinv_stoch_GasDem = pipeinv_stoch_GasDem
$Load  lnginv_stoch_GasDem  = lnginv_stoch_GasDem
$gdxin

*execute_unload '%datadir%check.gdx' pipeinv_stoch_GasDem,lnginv_stoch_GasDem;

*###############################################################################
* parameter to fix 1st stage decisions in ECIU - EEV problem
*###############################################################################

parameter  geninv_DET_EVP(i,co,year);
parameter  geninv_DET_EUCO(i,co,year);
parameter  geninv_DET_ST(i,co,year);
parameter  geninv_DET_DG(i,co,year);
