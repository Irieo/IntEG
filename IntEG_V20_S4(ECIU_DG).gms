*################################################################################################################################# 
*                                                       SCENARIO 2: ECIU - DG
*#################################################################################################################################

*Location of output files for this scenario   
$set resultdir  output_v20_DG\  

$include IntEG_v20_clear.gms

$if "%Inc_Stoch%" ==  "" $goto ScenMatrixEnd

    scen('EVP')  = no;
    scen('EUCO') = no;
    scen('ST')   = no;
    scen('DG')   = yes;

$Label ScenMatrixEnd

display scen;

number_scenarios   = card(scen);


###############################################################################
*                               Defining RESULTS parameters
*###############################################################################

$include IntEG_v20_declar_results.gms


*#############################        STEP 1:  DECLARING PARAMETERS         ####################

* DEFININING GAS PARAMETERS FOR SCENARIO

        nonPowerDem(co,year,month,scen) = cons_DG(co, year, month)*(1-PS_DG(co, year));

* Scaling quantities in Gas Model

        LP_prodCap(p,n,year,month)          =     LP_prodCap(p,n,year,month)     /conversion_factor_gas ;
        transCap(n,m)                       =     transCap(n,m)                  /conversion_factor_gas ;
        extra_cap(n,m, year, month)         =     extra_cap(n,m, year, month)    /conversion_factor_gas ;
        nonPowerDem(co,year,month,scen)     =     nonPowerDem(co,year,month,scen)/conversion_factor_gas ;
        stor_cons_cap(co,year, month)       =     stor_cons_cap(co,year, month)  /conversion_factor_gas ;
        stor_cons_in(co, year, month)       =     stor_cons_in(co,year, month)   /conversion_factor_gas ;
        stor_cons_out(co,year, month)       =     stor_cons_out(co,year, month)  /conversion_factor_gas ;
        st_lev_start(co)                    =     st_lev_start(co)               /conversion_factor_gas ;
        st_lev_end(co)                      =     st_lev_end(co)                 /conversion_factor_gas ;
        LTC(n,m,year, month)                =     LTC(n,m,year, month)           /conversion_factor_gas ;
        ;


* DEFININING EL PARAMETERS FOR SCENARIO

        demand(co,t,year,scen)              = demand_upload(co,t,year,"DG_up");
        cap_existing(i,n,year,scen)         = cap_existing_upload(i,n,year,"DG_up");
        fc(i,co,year,scen)                  = fc_upload(i,co,year,"DG_up") ;
        co2_price(scen,year)                = co2_price_upload("DG_up", year);
        vc_f(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_f(i,co,year);
        vc_m(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_m(i,co,year);


*#############################        STEP 2: SOLVING DP        #################################

$if %Inc_Det% ==  "*" $goto DetSolutionEnd

    SOLVE LSEWglobal using lp minimizing Cost_GLobal;

$include IntEG_v20_resprocess.gms

    execute_unload '%resultdir%%GlobalSCEN%_DET_Scen.gdx';

$label DetSolutionEnd

*#############################        STEP 3: SOLVING SCENARIOS - SP       ####################

$if %Inc_Stoch% ==  "*" $goto StochSolutionEnd

$include IntEG_v20_S4(ECIU_DG)_solve.gms

$include IntEG_v20_resprocess.gms

        put_utility 'gdxout' / 'output_v20_DG\v20_STOCH_Scen_' UncPar.tl:0;
        execute_unload  ;

*$include IntEG_v20_clear.gms

        nonPowerDem(co,year,month,scen) = cons_DG(co, year, month)*(1-PS_DG(co, year));
        nonPowerDem(co,year,month,scen) = nonPowerDem(co,year,month,scen)/conversion_factor_gas;

        LP_prodCap(p,n,year,month)          =     LP_prodCap(p,n,year,month)     /conversion_factor_gas ;
        transCap(n,m)                       =     transCap(n,m)                  /conversion_factor_gas ;
        extra_cap(n,m, year, month)         =     extra_cap(n,m, year, month)    /conversion_factor_gas ;
        stor_cons_cap(co,year, month)       =     stor_cons_cap(co,year, month)  /conversion_factor_gas ;
        stor_cons_in(co, year, month)       =     stor_cons_in(co,year, month)   /conversion_factor_gas ;
        stor_cons_out(co,year, month)       =     stor_cons_out(co,year, month)  /conversion_factor_gas ;
        st_lev_start(co)                    =     st_lev_start(co)               /conversion_factor_gas ;
        st_lev_end(co)                      =     st_lev_end(co)                 /conversion_factor_gas ;
        LTC(n,m,year, month)                =     LTC(n,m,year, month)           /conversion_factor_gas ;

        demand(co,t,year,scen)              = demand_upload(co,t,year,"DG_up");
        cap_existing(i,n,year,scen)         = cap_existing_upload(i,n,year,"DG_up");
        fc(i,co,year,scen)                  = fc_upload(i,co,year,"DG_up") ;
        co2_price(scen,year)                = co2_price_upload("DG_up", year);
        vc_f(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_f(i,co,year);
        vc_m(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_m(i,co,year);
        );

$label StochSolutionEnd

*#############################        STEP 4: saving 'naive' first stage decisions        ############

$if %Inc_StochFI% ==  "*" $goto StochFIEnd

*$Include IntEG_v20_FixInv.gms

$gdxin %resultdir%%GlobalSCEN%_DET_Scen
$Load  geninv_DET_DG  = CAP_new.l
$gdxin

CAP_new.fx(i,co,year)   = geninv_DET_DG(i,co,year);

execute_unload '%resultdir%fixedcap.gdx' Cap_new;

*#############################        STEP 5:  SOLVING SCENARIOS - EEV        #################

$include IntEG_v20_S4(ECIU_DG)_solve.gms

$include IntEG_v20_resprocess.gms

        put_utility 'gdxout' / 'output_v20_DG\v20_STOCH_FINV_Scen_' UncPar.tl:0;
        execute_unload  ;

*$include IntEG_v20_clear.gms

*       Setting default values

        nonPowerDem(co,year,month,scen) = cons_DG(co, year, month)*(1-PS_DG(co, year));
        nonPowerDem(co,year,month,scen) = nonPowerDem(co,year,month,scen)/conversion_factor_gas;

        LP_prodCap(p,n,year,month)          =     LP_prodCap(p,n,year,month)     /conversion_factor_gas ;
        transCap(n,m)                       =     transCap(n,m)                  /conversion_factor_gas ;
        extra_cap(n,m, year, month)         =     extra_cap(n,m, year, month)    /conversion_factor_gas ;
        stor_cons_cap(co,year, month)       =     stor_cons_cap(co,year, month)  /conversion_factor_gas ;
        stor_cons_in(co, year, month)       =     stor_cons_in(co,year, month)   /conversion_factor_gas ;
        stor_cons_out(co,year, month)       =     stor_cons_out(co,year, month)  /conversion_factor_gas ;
        st_lev_start(co)                    =     st_lev_start(co)               /conversion_factor_gas ;
        st_lev_end(co)                      =     st_lev_end(co)                 /conversion_factor_gas ;
        LTC(n,m,year, month)                =     LTC(n,m,year, month)           /conversion_factor_gas ;

        demand(co,t,year,scen)              = demand_upload(co,t,year,"DG_up");
        cap_existing(i,n,year,scen)         = cap_existing_upload(i,n,year,"DG_up");
        fc(i,co,year,scen)                  = fc_upload(i,co,year,"DG_up") ;
        co2_price(scen,year)                = co2_price_upload("DG_up", year);
        vc_f(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_f(i,co,year);
        vc_m(i,co,year,scen)                = (fc_upload(i,co,year,"DG_up")+ carb_cont(i)*co2_price_upload('DG_up',year))/ eta_m(i,co,year);
        );

* CONVERT TO BCM input data (to send correct GAS model's quantities for the next scenario)

        LP_prodCap(p,n,year,month)      =     LP_prodCap(p,n,year,month)      *conversion_factor_gas ;
        transCap(n,m)                   =     transCap(n,m)                   *conversion_factor_gas ;
        extra_cap(n,m, year, month)     =     extra_cap(n,m, year, month)     *conversion_factor_gas ;
        nonPowerDem(co,year,month,scen) =     nonPowerDem(co,year,month,scen) *conversion_factor_gas ;
        stor_cons_cap(co,year, month)   =     stor_cons_cap(co,year, month)   *conversion_factor_gas ;
        stor_cons_in(co, year, month)   =     stor_cons_in(co,year, month)    *conversion_factor_gas ;
        stor_cons_out(co, year, month)  =     stor_cons_out(co,year, month)   *conversion_factor_gas ;
        st_lev_start(co)                =     st_lev_start(co)                *conversion_factor_gas ;
        st_lev_end(co)                  =     st_lev_end(co)                  *conversion_factor_gas ;
        LTC(n,m,year, month)            =     LTC(n,m,year, month)            *conversion_factor_gas ;

$label StochFIEnd

*#############################        STEP 6:  Computing ECIU VALUES         ###################

%Inc_ECIUvalues%$include IntEG_v20_ECIU_compute.gms

*#############################        STEP 7:  GDX to EXCEL         ##################################

*$include IntEG_v20_GDXtoEXCEL.gms