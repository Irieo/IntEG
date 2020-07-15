execute_unload          '%resultdir%%result%.gdx'
execute "XLSTALK -c      %resultdir%%GlobalSCEN%_GAS.xlsx"
execute "XLSTALK -c      %resultdir%%GlobalSCEN%_EL.xlsx"


******************************  GAS MODEL EXCEL OUTPUT *************************

$onecho >out_gas.tmp
            par=price_gas               rng=price!C3            cdim=3 rdim=1
            par=price_gas_YEAR          rng=priceY!C3           cdim=2 rdim=1

            par=Sales                   rng=prod!C3             cdim=3 rdim=1
            par=Production_Year         rng=prodY!C3            cdim=2 rdim=1
            par=Prod_cong_Year          rng=prodY!C15           cdim=2 rdim=1

            par=prod_vol_BCM            rng=sales!C3            cdim=3 rdim=3
            par=Sales_Year              rng=salesY!C3           cdim=3 rdim=1

            par=purchases               rng=purch!C3            cdim=3 rdim=1
            par=purchases_Year          rng=purchY!C3           cdim=2 rdim=1

            par=consum                  rng=consum!C3           cdim=3 rdim=1
            par=consum_Year             rng=consumY!C3          cdim=2 rdim=1

            par=storage_level_full      rng=all_storage!c3       cdim=3 rdim=2
            par=st_in_BCM               rng=all_storage!c26      cdim=3 rdim=2
            par=st_out_BCM              rng=all_storage!c49      cdim=3 rdim=2
            par=CongStor                rng=all_storage!c73      cdim=3 rdim=2

            par=grid_new_cumul_BCM      rng=all_invest!c3         cdim=2 rdim=1
            par=LNG_new_cumul_BCM       rng=all_invest!c15        cdim=2 rdim=1
            par=grid_invest             rng=all_invest!c20        cdim=2 rdim=1
            par=grid_invest             rng=all_invest!c20        cdim=2 rdim=1
            par=LNG_invest              rng=all_invest!c33        cdim=2 rdim=1
            par=grid_invest             rng=all_invest!c41        cdim=1 rdim=2

$offecho

****************************** ELECTRICITY MODEL EXCEL OUTPUT *******************

$onecho >out_el.tmp
                 Par=total_elec_costs     Rng=TotalCosts!A2   Cdim=0 Rdim=0
                 Par=generation           Rng=generation!A2   Cdim=4 Rdim=1
%Exc_Stoch%                 Par=generation_scen1           Rng=gen_s1!A2   Cdim=4 Rdim=1
%Exc_Stoch%                 Par=generation_scen2           Rng=gen_s2!A2   Cdim=4 Rdim=1
%Exc_Stoch%                 Par=generation_scen3           Rng=gen_s3!A2   Cdim=4 Rdim=1

%Invest_gen%     Par=new_cap              Rng=newGen!A2       Cdim=2 rdim=1
%Invest_gen%     Par=invest_gen_cost_total Rng=TotalCosts!A5  Cdim=2 rdim=1

                 Par=price_EL             Rng=Price_EL!A2     Cdim=3 Rdim=1
                 Par=av_price_EL          Rng=Price_EL_av!A2:N25  Cdim=2 Rdim=1
                 Par=av_peak_price_EL     Rng=Price_EL_av!O2:AA25  Cdim=2 Rdim=1
                 Par=av_base_price_EL     Rng=Price_EL_av!AB2:AO25  Cdim=2 Rdim=1

                 Par=curt_RES             Rng=CurtRES!A2      Cdim=2 Rdim=1

%startup%        Par=startup              Rng=StartUp!B2      Cdim=2 Rdim=2
%store%          Par=storagelvl           Rng=PSP!A2          Cdim=2 Rdim=2

%Invest_gen%     par=invest_gen           rng=inv_G_el!C3        cdim=2 rdim=1
%Trade%          par=NTC_Flow             rng=FLOW_el!C3         cdim=4 rdim=1
%Trade%          par=Import               rng=Exp_Imp!A3         cdim=2 rdim=1
%Trade%          par=Export               rng=Exp_Imp!P3         cdim=2 rdim=1
%Trade%          par=Import_scaled        rng=Exp_Imp!A28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Import_scaled_scen1        rng=Exp_Imp_s1!A28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Import_scaled_scen2        rng=Exp_Imp_s2!A28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Import_scaled_scen3        rng=Exp_Imp_s3!A28        cdim=2 rdim=1
%Trade%          par=Export_scaled        rng=Exp_Imp!P28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Export_scaled_scen1        rng=Exp_Imp_s1!P28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Export_scaled_scen2        rng=Exp_Imp_s2!P28        cdim=2 rdim=1
*%Trade%%Exc_Stoch%          par=Export_scaled_scen3        rng=Exp_Imp_s3!P28        cdim=2 rdim=1
%Trade%          par=NTC_utilization      rng=NTC_usage!A2        cdim=2 rdim=2

%Invest_NTC%     par=invest_NTC           rng=inv_NTC!C3         cdim=2 rdim=1

                 par=FullLoadHours        rng=FLH!A2             cdim=3 rdim=1
%Exc_Stoch%      par=FullLoadHours_scen1        rng=FLH_s1!A2             cdim=3 rdim=1
%Exc_Stoch%      par=FullLoadHours_scen2        rng=FLH_s2!A2             cdim=3 rdim=1
%Exc_Stoch%      par=FullLoadHours_scen3        rng=FLH_s3!A2             cdim=3 rdim=1

                 par=production_GasT_el   rng=prod_gasfired!A2   cdim=2 rdim=1
                 par=production_GasT_th   rng=prod_gasfired!A30  cdim=2 rdim=1

                 par=price_gas               rng=price_gas!C3          cdim=3 rdim=1
                 par=price_gas_YEAR          rng=priceY_gas!C3         cdim=2 rdim=1
                 par=grid_new_cumul_BCM      rng=invest_gas!c3         cdim=2 rdim=1
                 par=LNG_new_cumul_BCM       rng=invest_gas!c15        cdim=2 rdim=1
                 par=grid_invest             rng=invest_gas!c20        cdim=2 rdim=1
                 par=LNG_invest              rng=invest_gas!c33        cdim=2 rdim=1
$offecho

execute 'gdxxrw %resultdir%%result%.gdx o=%resultdir%%GlobalSCEN%_GAS.xlsx @out_gas.tmp';
execute 'gdxxrw %resultdir%%result%.gdx o=%resultdir%%GlobalSCEN%_EL.xlsx @out_el.tmp';
