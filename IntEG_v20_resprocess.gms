*###############################################################################
*                                  AFTERMATH
*###############################################################################

*********************************  GAS MODEL  *********************************
*$ontext

*   STRUCTURE STORAGE VALUES

        st_lev.l(co,year,month,scen)$(not st_lev.l(co,year,month,scen) and ws_to_stor(co)) = eps;
        st_in.l (co,year,month,scen)$(not  st_in.l(co,year,month,scen)  and ws_to_stor(co)) = eps;
        st_out.l(co,year,month,scen)$(not st_out.l(co,year,month,scen) and ws_to_stor(co)) = eps;

*   CONVERT TO BCM primal variables


        prod_vol_BCM(p,n,m,year,month,scen)        = prod_vol.l(p,n,m,year,month,scen)            * conversion_factor_gas;
        export_physical_BCM(p,n,m,year,month,scen) = export_physical.l(p,n,m,year,month,scen)     * conversion_factor_gas;
        whole_sale_BCM(w,n,co,year,month,scen)     = whole_sale.l(w,n,co,year,month,scen)         * conversion_factor_gas;
        totalflow_BCM(n,m,year,month,scen)         = totalflow.l(n,m,year,month,scen)             * conversion_factor_gas;

        st_lev_BCM(co,year,month,scen)            = st_lev.l(co,year,month,scen)                * conversion_factor_gas;
        st_in_BCM(co,year,month,scen)             = st_in.l(co,year,month,scen)                 * conversion_factor_gas;
        st_out_BCM(co,year,month,scen)            = st_out.l(co,year,month,scen)                * conversion_factor_gas;

        grid_new_cumul_BCM(n,m,year)               = grid_new.l(n,m,year)                    * conversion_factor_gas;
        LNG_new_cumul_BCM(n,m,year)                = LNG_new.l(n,m,year)                     * conversion_factor_gas;

        gas_shed_BCM(co, year, month, scen)        = gas_shed.l(co, year, month, scen)       * conversion_factor_gas;

*  CONVERT TO BCM input data

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
        ;

*-------------------------------------------------------------------------------------------

*       PARAMETERS IN MONTHLY RESOLUTION: calculation
            price_gas(n,year,month,scen)               = LP_demand_cons.m(n,year,month,scen)* number_scenarios;

            Production(n,year,month,scen)              = sum ((p,m), prod_vol_BCM(p,n,m,year,month,scen))                               ;
            salesLNG(liqn,year,month,scen)             = sum((p,regn),export_physical_BCM(p,liqn,regn,year,month,scen))                 ;
            Sales_to(n,m,year,month,scen)              = sum (p$prod_to_node(p,n), prod_vol_BCM(p,n,m,year,month,scen))                 ;

            purchases(n,year,month,scen)               = sum((p,prall)$prod_to_node(p,prall),prod_vol_BCM(p,prall,n,year,month,scen))   ;
            purchasesLNG(regn,year,month,scen)         = sum((p,liqn),export_physical_BCM(p,liqn,regn,year,month,scen))                 ;
            purchasesLNG2(trgen,year,month,scen)       = sum((p,lng_p),prod_vol_BCM(p,lng_p,trgen,year,month,scen))                     ;
            purchasesPIPE(n,year,month,scen)           = purchases(n,year,month,scen) - purchasesLNG2(n,year,month,scen)                ;

            imports(co,year,month,scen)                = sum((w,n), whole_sale_BCM(w,n,co,year,month,scen))                             ;
            consum(co,year,month,scen)                 = sum((w,n), whole_sale_BCM(w,n,co,year,month,scen))
                                                            + st_out_BCM(co,year,month,scen) - st_in_BCM(co,year,month,scen)            ;


            storage_level_full(co,year,month,scen)$ws_to_stor(co) = st_lev_BCM(co,year,month,scen)
                                                                    + stor_min_obl(co)* stor_cons_cap(co,year, month);


            CongAll(n,m,year,month,scen)$totalflow_BCM(n,m,year,month,scen)
                                                     = totalflow_BCM(n,m,year,month,scen)
                                                       /(transCap(n,m) + extra_cap(n,m,year,month) + grid_new_cumul_BCM(n,m,year))
            ;
            CongReg(regn,year,month,scen)            = sum((p,liqn),export_physical_BCM(p,liqn,regn,year,month,scen))
                                                        /sum(m,(transCap(regn,m) + extra_cap(regn,m,year,month) + LNG_new_cumul_BCM(regn,m,year)))
            ;
            CongLiq(liqn,year,month,scen)$(sum(n,transCap(n,liqn)) > 0)
                                                         = sum((p,regn),export_physical_BCM(p,liqn,regn,year,month,scen))
                                                         /sum(n,transCap(n,liqn))
            ;
            CongStor(co,year,month,scen)$(stor_cons_cap(co,year, month) > 0)
                                                     = storage_level_full(co,year,month,scen) / stor_cons_cap(co,year, month);

*       PARAMETERS IN ANNUAL RESOLUTION: calculation
            price_gas_YEAR(n,year,scen)               = sum(month$Year_M(year,month), LP_demand_cons.m(n,year,month,scen)/12)* number_scenarios;

            Production_Year (n,year,scen)             = sum(month$Year_M(year,month), sum((p,m), prod_vol_BCM(p,n,m,year,month,scen)));
            Prod_cong_Year(prall,year,scen)$(Production_Year (prall,year,scen) >0)
                                                      = Production_Year (prall,year,scen) / sum((p,month), LP_prodCap(p,prall,year,month));
            Sales_Year(n,m,year,scen)                 = sum(month$Year_M(year,month), sum(p, prod_vol_BCM(p,n,m,year,month,scen)));

            purchases_Year(n,year,scen)               = sum(month$Year_M(year,month), purchases(n,year,month,scen));
            purchasLNG_Year(regn,year,scen)           = sum(month$Year_M(year,month), purchasesLNG(regn,year,month,scen));
            imports_Year(co,year,scen)                = sum(month$Year_M(year,month), imports(co,year,month,scen));
            consum_Year(co,year,scen)                 = sum(month$Year_M(year,month), consum(co,year,month,scen));

            grid_invest(n,m,year)                 = grid_new_cumul_BCM(n,m,year) -  grid_new_cumul_BCM(n,m,year-1);
            LNG_invest(n,m,year)                  = LNG_new_cumul_BCM(n,m,year) -   LNG_new_cumul_BCM(n,m,year-1);


*********************************  ELECTRICITY MODEL ***************************

*$ontext
*       Electricity market parameters: calculation

                total_elec_costs                     = COST_EL.L                                     ;

                generation(t,year,co,i,scen)              = G.l(i,co,t,year,scen)                   ;
                generation_country_tech(year,co,i,scen)   = sum(t, generation(t,year,co,i,scen))*RHS ;
                generation_EU_tech(year,i,scen)           = sum(co, generation_country_tech(year,co,i,scen)) ;
                expected_gen_EU(year,i)                   = sum(scen, generation_EU_tech(year,i,scen))/number_scenarios     ;

%Exc_Stoch%       generation_EUCO(t,year,co,i,'EUCO')    = G.l(i,co,t,year,'EUCO')                  ;
%Exc_Stoch%       generation_ST(t,year,co,i,'ST')        = G.l(i,co,t,year,'ST')                    ;
%Exc_Stoch%       generation_DG(t,year,co,i,'DG')        = G.l(i,co,t,year,'DG')                    ;

* costs calculations on Electricity Market
                generation_costs_yearly_country(year,co,scen)  = (sum((noGas,t), G.l(noGas,co,t,year,scen)*vc_f(noGas,co,year,scen))
                                                            + sum( (GasT,t), G.l(GasT,co,t,year,scen)*(carb_cont(GasT)*co2_price(scen, year)/eta_f(GasT,co,year)))
                                                            + sum( (GasT,t), G.l(GasT,'cn_NO',t,year,scen)* fc(GasT,'cn_NO',year,scen)/eta_f(GasT,'cn_NO',year))
                                                            )* discountfactor(year) * RHS     ;
                generation_costs_yearly_EU(year,scen)   = sum(co, generation_costs_yearly_country(year,co,scen) )                 ;
                expected_gen_costs_yearly_EU(year)      = sum(scen, generation_costs_yearly_EU(year,scen) )/number_scenarios     ;
                expected_gen_costs_total                = sum(year, expected_gen_costs_yearly_EU(year) )        ;

                Shed_costs_yearly_country(year,scen,co)      = sum(t, SHED.l(co,t,year,scen) * vola(co) * discountfactor(year))  * RHS  ;
                expected_Shed_costs_yearly_EU(year)  = sum((scen,co), Shed_costs_yearly_country(year,scen,co) ) /number_scenarios      ;
                expected_Shed_costs_total            = sum(year, expected_Shed_costs_yearly_EU(year) )           ;

                Invest_costs_yearly_country(year,co) = SUM( i, ic(i) * CAP_new.l(i,co,year)) * discountfactor(year) ;
                Invest_costs_yearly_EU(year)         = SUM( co, Invest_costs_yearly_country(year,co))    ;
                Invest_costs_total                   = SUM( year, Invest_costs_yearly_EU(year))     ;

                price_EL(t,co,year,scen)             = (res_dem.M(t,co,year,scen)/RHS)* (-1) * number_scenarios              ;
                av_price_EL(co,year,scen)            = sum(t,(res_dem.M(t,co,year,scen)/RHS)* (-1)) * number_scenarios/t_number    ;
*                av_peak_price_EL(co,year,scen)       = sum(peak_T,(res_dem.M(peak_T,co,year,scen)/RHS)* (-1))* number_scenarios/ (0.5*t_number)  ;
*                av_base_price_EL(co,year,scen)       = sum(base_T,(res_dem.M(base_T,co,year,scen)/RHS)* (-1))* number_scenarios  / (0.5*t_number)  ;

                production_GasT_el(co,year,scen)           = sum((t,GasT), G.l(GasT,co,t,year,scen)*RHS)        ;
                production_GasT_th(co,year,scen)           = sum((t,GasT), G.l(GasT,co,t,year,scen)/eta_f(GasT,co,year)*RHS)   ;

%Invest_NTC%    invest_NTC(co,coco,year)        = NTC_new.l(co,year,coco)                       ;
%Invest_gen%    invest_gen(co,i,year)           = CAP_new.l(i,co,year)                          ;
%Invest_gen%    new_cap(co,i,year)              = CAP_new.l(i,co,year)-CAP_new.l(i,co,year-1)   ;
%Invest_gen%    invest_gen_cost_total(co,i,year)= ic(i)*CAP_new.l(i,co,year)                    ;

%Trade%     NTC_Flow(t,year,co,coco,scen)            = FLOW.l(co,coco,t,year,scen)                        ;
%Trade%%Exc_Stoch%       NTC_Flow_EUCO(t,year,co,coco,'EUCO')   = FLOW.l(co,coco,t,year,'EUCO')                        ;
%Trade%%Exc_Stoch%       NTC_Flow_ST(t,year,co,coco,'ST')   = FLOW.l(co,coco,t,year,'ST')                        ;
%Trade%%Exc_Stoch%       NTC_Flow_DG(t,year,co,coco,'DG')   = FLOW.l(co,coco,t,year,'DG')                        ;

%Trade%     Import(coco,year,scen)                   = sum((co,t),FLOW.l(co,coco,t,year,scen)) /1000      ;
%Trade%     Export(co,year,scen)                     = sum((coco,t),FLOW.l(co,coco,t,year,scen))/1000     ;

%Trade%     Import_scaled(coco,year,scen)            = sum((co,t),FLOW.l(co,coco,t,year,scen))*RHS/1000     ;
%Trade%%Exc_Stoch%       Import_scaled_EUCO(coco,year,'EUCO')     = sum((co,t),FLOW.l(co,coco,t,year,'EUCO'))*RHS/1000     ;
%Trade%%Exc_Stoch%       Import_scaled_ST(coco,year,'ST')     = sum((co,t),FLOW.l(co,coco,t,year,'ST'))*RHS/1000     ;
%Trade%%Exc_Stoch%       Import_scaled_DG(coco,year,'DG')     = sum((co,t),FLOW.l(co,coco,t,year,'DG'))*RHS/1000     ;
%Trade%     Export_scaled(co,year,scen)              = sum((coco,t),FLOW.l(co,coco,t,year,scen))*RHS/1000   ;
%Trade%%Exc_Stoch%       Export_scaled_EUCO(co,year,'EUCO')     = sum((coco,t),FLOW.l(co,coco,t,year,'EUCO'))*RHS/1000   ;
%Trade%%Exc_Stoch%       Export_scaled_ST(co,year,'ST')     = sum((coco,t),FLOW.l(co,coco,t,year,'ST'))*RHS/1000   ;
%Trade%%Exc_Stoch%       Export_scaled_DG(co,year,'DG')     = sum((coco,t),FLOW.l(co,coco,t,year,'DG'))*RHS/1000   ;

%Trade%     NTC_utilization(co,coco,year,scen)$( ntc(co,'y2020',coco)
%Trade%%Invest_NTC%                            OR NTC_new.l(co,year,coco)
                                                 )   =sum(t,FLOW.l(co,coco,t,year,scen)) / (ntc(co,'y2020',coco)*t_number
%Trade%%Invest_NTC%                                                         +NTC_new.l(co,year,coco)*t_number
                                                                             ) ;

%store%     storagelvl(t,co,i,year,scen)             = StLevel.L(i,co,t,year,scen)                        ;

            curt_RES(co,year,scen)                   = sum( (t,ResT),(cap_existing(rest,co,year,scen)* pf(rest,co,t)-G.l(ResT,co,t,year,scen))
                                                   + (cap_existing('ror',co,year,scen)*af('ror',co)-G.l('ror',co,t,year,scen)));

%startup%   startup(convt,co,t,year,scen)            = SU.L(convt,co,t,year,scen)                          ;

            FullLoadHours(co,year,i,scen)$(cap_existing(i,co,year,scen)
%Invest_gen%                              OR CAP_new.l(i,co,year)
                                           )
                                                 = sum(t, G.l(i,co,t,year,scen)*RHS) / (cap_existing(i,co,year,scen)
%Invest_gen%                                         +CAP_new.l(i,co,year)
                                                 );

%Exc_Stoch%   FullLoadHours_EUCO(co,year,i,'EUCO')$(cap_existing(i,co,year,'EUCO') OR CAP_new.l(i,co,year) )
%Exc_Stoch%                                      = sum(t, G.l(i,co,t,year,'EUCO')*RHS) / (cap_existing(i,co,year,'EUCO')+CAP_new.l(i,co,year));
%Exc_Stoch%   FullLoadHours_ST(co,year,i,'ST')$(cap_existing(i,co,year,'ST') OR CAP_new.l(i,co,year) )
%Exc_Stoch%                                      = sum(t, G.l(i,co,t,year,'ST')*RHS) / (cap_existing(i,co,year,'ST')+CAP_new.l(i,co,year));
%Exc_Stoch%   FullLoadHours_DG(co,year,i,'DG')$(cap_existing(i,co,year,'DG') OR CAP_new.l(i,co,year) )
%Exc_Stoch%                                      = sum(t, G.l(i,co,t,year,'DG')*RHS) / (cap_existing(i,co,year,'DG')+CAP_new.l(i,co,year));

*$offtext


