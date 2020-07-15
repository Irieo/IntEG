*###############################################################################
*                                    VARIABLES
*###############################################################################

******************************** Global  MODEL  ********************************
VARIABLES
       Cost_GLobal       total cost of gas market combined with total costs of electricity market
;

POSITIVE VARIABLES
       Psector_gas(co,month,year,allscen)  gas demand from power sector in MWh per month
;
*********************************  ELECTRICITY  MODEL  *************************

    POSITIVE VARIABLES

        G(i,n,t_all,year,allscen)           generation of technology i at time t
        P_ON(i,n,t_all,year,allscen)        online capacity of technology i at time t
        SU(i,n,t_all,year,allscen)          start up variable
        CAP_new(i,n,year)                   installed capacity
        SHED(n,t_all,year,allscen)          load sheding at a VoLA
        P_PSP(i,n,t_all,year,allscen)       pumping of water back to the PSP reservoir
        StLevel(i,n,t_all,year,allscen)     level of the PSP storage at time t

        NTC_new(n,year,nn)                  invested NTC capacity in MW
        FLOW(n,nn,t_all,year,allscen)       transfered capacity in MW
        ;

    VARIABLES

        COST_EL            total cost of electricity production
        ;

*********************************  GAS  MODEL  *********************************

    #Disagregation for purchaises/imports/consumption is done in aftermath
    POSITIVE VARIABLES

        prod_vol(p,n,m,year,month,allscen)        gas produced by a producer P in a node N and sold to node M at a time S
        export_physical(p,n,m,year,month,allscen) physical gas flows from producer that correspond to exports
        whole_sale(w,n,co,year,month,allscen)     gas delivered by a wholesaler W located in a node N(consum) to node M(consum) at a time S

        totalflow(n,m,year,month,allscen)        total physical gas flows between nodes

        st_lev(co,year,month,allscen)           stock level of gas storages
        st_in(co,year,month,allscen)            storage injection variable
        st_out(co,year,month,allscen)           sotage withdrawal variable

        grid_new(n,m,year)
        LNG_new(n,m,year)

        gas_shed(co, year, month,allscen)
        ;

    VARIABLES

        COST_GAS                    LP - cost objective
        ;

*################################################################################################################
*                                                   EQUATIONS
*################################################################################################################

*#################################  INTEGRATED  MODEL #################################


EQUATIONS

        OBJECTIVE_GLOBAL                objective function combining GAS and ELECTRICITY
        gas_demand_Psector              new equation

;


OBJECTIVE_GLOBAL..
         Cost_GLobal =e= (COST_GAS + COST_EL)*inf_factor
         ;

gas_demand_Psector(coo,month,year,scen)..
         Psector_gas(coo,month,year,scen) =e= sum((GasT,t)$(Month_T(Month,t)), G(GasT,coo,t,year,scen)/eta_f(GasT,coo,year))*RHS
;


*#################################  GAS LINEAR  MODEL #################################

EQUATIONS

LP_OBJECTIVE_GAS                                 objective function (NEGATIVE WELFARE FUNCTION)

*** CAPACITY CONSTRAINTS

    LP_capCons(p,prall,year,month,allscen)          production capacity constraint
    LP_nodeTransMax(n,m,year,month,allscen)         transmission capacity constraint

    LP_keep_grid_new(n,m,year)
    LP_keep_LNG_new(n,m,year)

*** DEMAND CONSTRAINT

    LP_demand_cons(n,year,month,allscen)            supply + stor(out) = demand + stor (in)
    LP_demand_clearing(co,year,month,allscen)       define demand

*** BALANCES ON SUPPLIER AND WHOLESALER LEVELS

    LP_Supplier_balance(p,n,year,month,allscen)     exporter sale <-> physical flow balance
    LP_Gasflow(n,m,year,month,allscen)              physical gas flow definition over a pipeline

*** STORAGE

    LP_stor_cons_cap_equ(co,year,month,allscen)    storage capacity constraint
    LP_stor_cons_in_equ(co,year,month,allscen)     injection speed constraint
    LP_stor_cons_out_equ(co,year,month,allscen)    withdrawal speed constraint
    LP_stor_balance_endofM(co,year,month,allscen)
    LP_stor_balance_endofJan(co,year,allscen)
    LP_stor_balance_Jan2015(co,year,month,allscen)
    LP_stor_balance_Dec2030(co,year,month,allscen)

*** CONDITIONAL

%Inc_LTC%LP_ltc_oblig(n,m,year,month,allscen)     take-or-pay obligations
;


LP_OBJECTIVE_GAS..
            COST_GAS =e=
                    sum(scen,
                    sum((year,month),

                    sum((p,prall,trgen)$(prod_to_node(p,prall) AND exp_direction(p,trgen)),
                       prod_vol(p,prall,trgen,year,month,scen) * (LP_prod_costs_gas(p,prall)) ) * discountfactor(year)                     #production costs

                  + sum((p,n,m)$exp_pipelines(p,n,m),export_physical(p,n,m,year,month,scen)*transMC(n,m))* discountfactor(year)           #transport (pipe&LNG) costs

                  + sum((co)$ws_to_stor(co), (st_in(co,year,month,scen) * stor_cost_in
                                              + st_out(co,year,month,scen) * stor_cost_out))* discountfactor(year)                       #storage costs

                  + sum(co, gas_shed(co, year, month, scen)*volg)
                             ))
%Inc_Stoch%       /number_scenarios

%Invest_gas_grid% +  sum(year,

%Invest_gas_grid% + SUM( (n,m), ic_gas_grid * distance(n,m) * grid_new(n,m,year))*discountfactor(year)
%Invest_gas_LNG%  + SUM( (n,m), ic_LNG * LNG_new(n,m,year))* discountfactor(year))

;


***************************** CAPACITY CONSTRAINTS

LP_capCons(p,prall,year,month,scen)$prod_to_node(p,prall)..
                        sum(trgen,prod_vol(p,prall,trgen,year,month,scen)) =l= LP_prodCap(p,prall,year,month);

LP_nodeTransMax(n,m,year,month,scen)$(transCap(n,m)<>0)..
                        totalflow(n,m,year,month,scen) =l= transCap(n,m)
                                                                   + extra_cap(n,m,year,month)$extra_cap(n,m,year,month)
%Invest_gas_grid%                                                  + grid_new(n,m,year)$(not reg_to_trans(n,m) and not liqn(m))
%Invest_gas_LNG%                                                   + LNG_new(n,m,year)$(reg_to_trans(n,m))
                                                                   + pipeinv_stoch_GasDem(n,m,year)*1.2
                                                                   + lnginv_stoch_GasDem(n,m,year)*1.2
                                                                   ;


LP_keep_grid_new(n,m,year)$(transCap(n,m)<>0)..  grid_new(n,m,year) =G= grid_new(n,m,year-1);

LP_keep_LNG_new(n,m,year)$(transCap(n,m)<>0)..   LNG_new(n,m,year)  =G= LNG_new(n,m,year-1);


***************************** DEMAND CONSTRAINT

LP_demand_cons(n,year,month, scen)$trgen(n)..
                        sum((p,m)$(prod_to_node (p,m) and exp_direction(p,n)), prod_vol(p,m,n,year,month, scen))                   #SUPPLY

                        - sum((w,co), (whole_sale(w,n,co,year,month, scen)$ws_direction_cut(w,n,co))) =e= 0;                       #CONSUMPTION


LP_demand_clearing(co,year,month,scen)..

                         nonPowerDem(co,year,month, scen)  + Psector_gas(co,month,year, scen)
                        - gas_shed(co, year, month, scen)
                          =e=
                        sum((w,trgen)$(ws_to_home(w,trgen)), whole_sale(w,trgen,co,year,month, scen)$ws_direction_cut(w,trgen,co))
                        + st_out(co,year,month,scen)$ws_to_stor(co) - st_in(co,year,month,scen)$ws_to_stor(co);                        #STORAGE


***************************** BALANCES OF SUPPLIER-WHOLESALER GAS QUANTITIES

LP_Supplier_balance (p,n,year,month,scen)$(prod_to_node (p,n) or exp_direction(p,n))..

                          (sum(m, prod_vol(p,n,m,year,month, scen)$(prod_to_node (p,n) and exp_direction(p,m)))
                        -  sum(m, export_physical(p,n,m,year,month,scen)$exp_pipelines(p,n,m)))

                        + (sum(m, export_physical(p,m,n,year,month, scen)$exp_pipelines(p,m,n))
                        - sum(m, prod_vol(p,m,n,year,month, scen)$(prod_to_node (p,m) and exp_direction(p,n))))

                          =e= 0;

LP_Gasflow(n,m,year,month,scen)$transCap(n,m)..
                        totalflow(n,m,year,month,scen) - sum(p, export_physical(p,n,m,year,month,scen)$exp_pipelines(p,n,m)) =e= 0;

***************************** STORAGE

LP_stor_cons_cap_equ(co,year,month,scen)$ws_to_stor(co)..
                        st_lev(co,year,month,scen) =l= stor_cons_cap(co,year,month) * (1-stor_min_obl(co));

LP_stor_cons_in_equ(co,year,month,scen)$ws_to_stor(co)..
                        st_in(co,year,month,scen) =l= stor_cons_in(co,year,month);

LP_stor_cons_out_equ(co,year,month,scen)$ws_to_stor(co)..
                        st_out(co,year,month,scen) =l= stor_cons_out(co,year,month);


LP_stor_balance_endofM(co,year,month,scen)$(ws_to_stor(co) and not m_first(month))..
                        st_lev(co,year,month,scen) =l= st_lev(co,year,month-1,scen)
                                         + (1-stor_loss(co)) * st_in(co,year,month,scen) - st_out(co,year,month,scen);

LP_stor_balance_endofJan(co,year,scen)$(ws_to_stor(co) and not y_first(year))..
                         st_lev(co,year,'m1',scen) =l= st_lev(co,year-1,'m12',scen)
                                 + (1-stor_loss(co)) * st_in(co,year,'m1',scen) - st_out(co,year,'m1',scen);

LP_stor_balance_Jan2015(co,year,month,scen)$(ws_to_stor(co) and m_first_global(year,month))..
                         st_lev(co,year,month,scen) =l= st_lev_start(co)  + (1-stor_loss(co)) * st_in(co,year,month,scen) - st_out(co,year,month,scen);

LP_stor_balance_Dec2030(co,year,month,scen)$(ws_to_stor(co) and m_last_global(year, month))..
                         st_lev(co,year,month,scen) =g= st_lev_end(co);

***************************** CONDITIONAL

%Inc_LTC%LP_ltc_oblig(n,m,year,month,scen)$(LTC(n,m,year,month))..
%Inc_LTC%               sum(p,prod_vol(p,n,m,year,month,scen)$prod_to_node (p,n)) =g= TOP*LTC(n,m,year,month);


*################################# ELECTRICITY MODEL #################################

EQUATIONS

OBJECTIVE_EL                                      minimizing total costs
res_dem(t,co,year,allscen)                        energy balance (supply=demand)
res_start(i,co,t,year,allscen)                startup restriction
res_G_RES(i,co,t,year,allscen)                 maximum for RES generation depends on hourly pf anc cap_RES
res_min_gen(i,co,t,year,allscen)              minimum generation
res_max_gen(i,co,t,year,allscen)              maximum generation
res_max_online(i,co,t,year,allscen)           maximum online restriction
max_capacity(i,co,year)                           maximum potential capacity [MW]
storagelevel(t,i,co,year,allscen)             level of the PSP storage
PSPmax(t,i,co,year,allscen)                   PSP power limitation to installed turbine capacity
SHED_max(co,t,allscen,year)                       maximum shedding in a country
storagelevel(t,i,co,year,allscen)             storage level at time t
storagelevel_max(t,i,co,year,allscen)         max level of reservoir (upper basin)

reservoir_max_gen(i,co,t,year,allscen)
reservoir_year_cap(i,co,year,allscen)

Res_lineflow_1(co,coco,t,year,allscen)
Res_lineflow_2(coco,co,t,year,allscen)

res_new_cap(i,co,year)                   ensures that new cap has to be paid each year after construction
res_new_NTC(co,coco,year)                built connections exist for all following years (new cap has to be paid each year after construction )
RES_NTC_new_twoWay(co,coco,t,year)       the investment in a line affects both directions equally

CHP_restriction(co,t,year,allscen)       minimum production due to CHP
;

OBJECTIVE_EL..
            COST_EL    =E=
                SUM( scen, (
                  SUM( (noGas,co,t,year), vc_f(noGas,co,year,scen) * G(noGas,co,t,year,scen) * discountfactor(year)  ) *RHS
                + SUM( (GasT,co,t,year)$eta_f(GasT,co,year), (carb_cont(GasT)*co2_price(scen, year)/eta_f(GasT,co,year)) * G(GasT,co,t,year,scen)* discountfactor(year)) *RHS
                + SUM( (GasT,t,year)$eta_f(GasT,'cn_NO',year), fc(GasT,'cn_NO',year,scen)/eta_f(GasT,'cn_NO',year) * G(GasT,'cn_NO',t,year,scen)* discountfactor(year) ) *RHS

%startup%       + SUM( (convt,co,t,year), SU(convt,co,t,year,scen) * sc(convt) ) * discountfactor(year)  *RHS
%startup%       + SUM( (convt,co,t,year), (P_on(convt,co,t,year,scen)-G(convt,co,t,year,scen)) * (vc_m(convt,co)- vc_f(convt,co)) *g_min(convt) / (1-g_min(convt)) * discountfactor(year))  *RHS
%shed%          + SUM( (co,t,year), SHED(co,t,year,scen)*vola(co) * discountfactor(year)   )  *RHS
                ))
%Inc_Stoch%     /number_scenarios

%Invest_gen%    + SUM( (i,co,year), ic(i) * CAP_new(i,co,year) * discountfactor(year))
%Invest_NTC%    + SUM( (co,coco,year), ic_ntc * ntc_dist(co,coco) * NTC_new(co,year,coco) * discountfactor(year) )
 ;

res_dem(t,co,year,scen)..
            demand(co,t,year,scen) =E=
                  SUM( convt, G(convt,co,t,year,scen)) + SUM(rest, G(rest,co,t,year,scen) )
%store%         + SUM( stort,G(stort,co,t,year,scen) *eta_f(stort,co,year) - P_PSP(stort,co,t,year,scen) )
                + SUM( ReservT$cap_existing(ReservT,co,year,scen), G(ReservT,co,t,year,scen) )
%shed%          + SHED(co,t,year,scen)
%Trade%         + SUM( coco, FLOW(coco,co,t,year,scen) - FLOW(co,coco,t,year,scen) )
                ;

res_G_RES(rest,co,t,year,scen)..    G(rest,co,t,year,scen) =L= (cap_existing(rest,co,year,scen)) * pf(rest,co,t)
;

res_new_cap(i,co,year)..            CAP_new(i,co,year) =G= CAP_new(i,co,year-1)
;

res_start(convt,co,t,year,scen)..        SU(convt,co,t,year,scen) =G= P_on(convt,co,t,year,scen)-P_ON(convt,co,t-1,year,scen)
;

res_min_gen(convt,co,t,year,scen)..      P_on(convt,co,t,year,scen)*g_min(convt) =L= G(convt,co,t,year,scen)
;

res_max_gen(convt,co,t,year,scen)..
                                 G(convt,co,t,year,scen) =L=
%Exc_startup%                                    cap_existing(convt,co,year,scen) * af(convt,co)
%Exc_startup%                                  + CAP_new(convt,co,year) * af(convt,co)
%startup%                                        P_on(convt,co,t,year,scen)
;

res_max_online(convt,co,t,year,scen)..    P_on(convt,co,t,year,scen) =L= (cap_existing(convt,co,year,scen))  * af(convt,co)
%Invest_gen%                                      + CAP_new(convt,co,year) * af(convt,co)
;

max_capacity(i,co,year)..               CAP_new(i,co,year) =L= cap_max(i,co)
;

*A comment why it takes place
SHED_max(co,t,scen,year)..              SHED(co,t,year,scen) =L= demand(co,t,year,scen)*0.2
;

##########################    PSP and Reservoirs   ###########################################

storagelevel_max(t,stort,co,year,scen)..   StLevel(stort,co,t,year,scen) =l= (cap_existing(stort,co,year,scen))  * cpf
%Invest_gen%                                          + CAP_new(stort,co,year)*cpf
;

storagelevel(t,stort,co,year,scen)..       StLevel(stort,co,t,year,scen) =e=
                                            StLevel(stort,co,t-1,year,scen) - G(stort,co,t,year,scen) + P_PSP(stort,co,t,year,scen)
;

PSPmax(t,stort,co,year,scen)..             G(stort,co,t,year,scen)+P_PSP(stort,co,t,year,scen) =l= cap_existing(stort,co,year,scen)*af(stort,co)
%Invest_gen%                                                      + CAP_new(stort,co,year)*af(stort,co)
;

reservoir_max_gen(ReservT,co,t,year,scen)$cap_existing(ReservT,co,year,scen)..
                         G(ReservT,co,t,year,scen) =L= cap_existing(ReservT,co,year,scen)*af(ReservT,co)
;
reservoir_year_cap(ReservT,co,year,scen)$cap_existing(ReservT,co,year,scen)..
                         sum(t,G(ReservT,co,t,year,scen)) =L= cap_existing(ReservT,co,year,scen)*flh_Reservoir
;

***********       Network defintions and restrictions       ********************

Res_lineflow_1(co,coco,t,year,scen)..
                         FLOW(co,coco,t,year,scen) =L=
                                             ntc(co,year,coco)
%Invest_NTC%                               + NTC_new(co,year,coco)$ntc_dist(co,coco)
;

Res_lineflow_2(coco,co,t,year,scen)..
                         FLOW(coco,co,t,year,scen) =L=
                                             ntc(coco,year,co)
%Invest_NTC%                               + NTC_new(coco,year,co)$ntc_dist(coco,co)
;

RES_NTC_new_twoWay(co,coco,t,year)..       NTC_new(co,year,coco) =E= NTC_new(coco,year,co)
;

res_new_NTC(co,coco,year)..       NTC_new(co,year,coco) =G= NTC_new(co,year-1,coco)
;

CHP_restriction(co,t,year,scen)$CHP_factor(co,year)..
                                heat_factor(t,co)*CHP_factor(co,year) =L= sum(GasT, G(GasT,co,t,year,scen) )
;


*###############################################################################
*                          MODEL formulation
*###############################################################################

MODEL LSEWglobal /

    OBJECTIVE_GLOBAL
    gas_demand_Psector

**** GAS PART
    LP_OBJECTIVE_GAS

        LP_capCons
        LP_nodeTransMax
        LP_keep_grid_new
        LP_keep_LNG_new

        LP_demand_cons
        LP_demand_clearing
        LP_Supplier_balance
        LP_Gasflow

        LP_stor_cons_cap_equ
        LP_stor_cons_in_equ
        LP_stor_cons_out_equ
        LP_stor_balance_endofM
        LP_stor_balance_endofJan
        LP_stor_balance_Jan2015
        LP_stor_balance_Dec2030

%Inc_LTC%LP_ltc_oblig

**** EL PART
     OBJECTIVE_EL
                res_dem
                max_capacity
                res_max_gen
                res_G_RES

%startup%       res_max_online
%startup%       res_start
%startup%       res_min_gen
%store%         storagelevel_max
%store%         storagelevel
%store%         PSPmax
%shed%          SHED_max

%CHP%           CHP_restriction

                reservoir_max_gen
                reservoir_year_cap

%Trade%         Res_lineflow_1
%Trade%         Res_lineflow_2

%Invest_NTC%    res_new_NTC
%Invest_NTC%    RES_NTC_new_twoWay
%Invest_gen%    res_new_cap
                /;

