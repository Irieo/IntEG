    PARAMETERS

        prod_vol_BCM(p,n,m,year,month,allscen)
        export_physical_BCM(p,n,m,year,month,allscen)
        whole_sale_BCM(w,n,co,year,month,allscen)
        totalflow_BCM(n,m,year,month,allscen)
        st_lev_BCM(co,year,month,allscen)
        st_in_BCM(co,year,month,allscen)
        st_out_BCM(co,year,month,allscen)
        grid_new_cumul_BCM(n,m,year)
        LNG_new_cumul_BCM(n,m,year)
        gas_shed_BCM(co, year, month, allscen)
        ;


    PARAMETERS

*       PARAMETERS IN MONTHLY RESOLUTION
            price_gas(n,year,month,allscen)              price for gas per node          (euro_MWh)       per month

            Production(n,year,month,allscen)             production and sales per node   (bcm)            per month
            salesLNG(liqn,year,month,allscen)            LNG sales                       (bcm)            per month
            Sales_to(n,m,year,month,allscen)             sales per node to destination   (bcm)            per month

            purchases(n,year,month,allscen)              full imports (before storage)   (bcm)            per month
            purchasesLNG(regn,year,month,allscen)        LNG imports                     (bcm)            per month
            purchasesLNG2(n,year,month,allscen)          PIPELINE imports                  (bcm)            per month
            purchasesPIPE(n,year,month,allscen)          PIPELINE imports                  (bcm)            per month

            imports(co,year,month,allscen)               imports (after storage)         (bcm)            per month
            consum(co,year,month,allscen)                full consumption (+inner prod)  (bcm)            per month

            storage_level_full(co,year,month,allscen)   (invludes fixed storage volume) (bcm)            per month

            Congall(n,m,year,month,allscen)              congestion of all infr. elements (%)
            CongReg(regn,year,month,allscen)             congestion of all REG terminals  (%)
            CongLiq(liqn,year,month,allscen)             congestion of all LIQ terminals  (%)
            CongStor(co,year,month,allscen)              congestions of storages          (%)


*       PARAMETERS IN ANNUAL RESOLUTION: definition

            price_gas_YEAR(n,year,allscen)               average price for gas per node  (euro_MWh)      per year

            Production_Year(n,year,allscen)              production per node             (bcm)           per year
            Prod_cong_Year(n,year,allscen)               congestion of prod cap          (bcm)           per year
            Sales_Year(n,m,year,allscen)                 export sales per node           (bcm)           per year

            purchases_Year(n,year,allscen)               full imports (before storage)   (bcm)           per year
            purchasLNG_Year(regn,year,allscen)           LNG imports                     (bcm)           per year
            imports_Year(co,year,allscen)                imports (after storage)         (bcm)           per year
            consum_Year(co,year,allscen)                 full consumption (+inner prod)  (bcm)           per year

            grid_invest(n,m,year)                     invest (not cumulative) in grid (bcm)           per year
            LNG_invest(n,m,year)                      invest (not cumulative) in LNG  (bcm)           per year
            ;

    PARAMETERS
    
           total_elec_costs                              total costs of the electricity sector in EUR
           generation(t,year,co,i,allscen)                  houry production of each technology in each country in MWh for all scenarios
                 generation_EUCO(t,year,co,i,allscen)   houry production of each technology in each country in MWh for scenario 1
                 generation_ST(t,year,co,i,allscen)     houry production of each technology in each country in MWh for scenario 2
                 generation_DG(t,year,co,i,allscen)     houry production of each technology in each country in MWh for scenario 3
            generation_country_tech(year,co,i,allscen)  country specific production of each technology in each scen
            generation_EU_tech(year,i,allscen)          EU wide production of each technology in each scen
            expected_gen_EU(year,i)                  ecpected EU wide production

            generation_costs_yearly_country(year,co,allscen)   yearly generation costs in each country and scen
            generation_costs_yearly_EU(year,allscen)           EU wide yearly generation costs in each scen
            expected_gen_costs_yearly_EU(year)          EU wide expected yearly generation costs
            expected_gen_costs_total                    total expected generation costs

            Shed_costs_yearly_country(year,allscen,co)     yearly Shedding costs in each country and scen
            expected_Shed_costs_yearly_EU(year)         expected EU wide yearly Shedding costs
            expected_Shed_costs_total                   total expected Shedding costs

            Invest_costs_yearly_country(year,co)        yearly invest costs in each country
            Invest_costs_yearly_EU(year)                EU wide yearly invest costs
            Invest_costs_total                          total expected invest costs

           invest_NTC(co,coco,year)                      cummulated NTC investments over the years in MW
           invest_gen(co,i,year)                         cummulated capacity investments over the years in MW
           new_cap(co,i,year)                            newly installed capacity in each year for each country and technology in MW
           invest_gen_cost_total(co,i,year)              total investment costs per year, country and technology in EUR
           NTC_Flow(t,year,co,coco,allscen)                 hourly line flows in MWh
                 NTC_Flow_EUCO(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 1
                 NTC_Flow_ST(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 2
                 NTC_Flow_DG(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 3

           Import(co,year,allscen)                          Import t_number hours per year in GWh
           Export(co,year,allscen)                          Import t_number hours per year in GWh
           Import_scaled(co,year,allscen)                   Import scaled to 8760 hours per year in GWh
                 Import_scaled_EUCO(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 1
                 Import_scaled_ST(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 2
                 Import_scaled_DG(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 3
           Export_scaled(co,year,allscen)                   Export scaled to 8760 hours per year in GWh
                 Export_scaled_EUCO(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 1
                 Export_scaled_ST(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 2
                 Export_scaled_DG(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 3

           NTC_utilization(co,coco,year,allscen)            utilization rate of a transport capacity

           price_EL(t,co,year,allscen)                      hourly electricity price in EUR per MWh
           av_price_EL(co,year,allscen)                     yearly average price in EUR per MWh
           av_peak_price_EL(co,year,allscen)                yearly average peak price in EUR per MWh
           av_base_price_EL(co,year,allscen)                yearly average base price in EUR per MWh

           curt_RES(co,year,allscen)                        sum of RES curtailment during one year
           FullLoadHours(co,year,i,allscen)                 full load hours for each technology
                 FullLoadHours_EUCO(co,year,i,allscen)        full load hours for each technology
                 FullLoadHours_ST(co,year,i,allscen)        full load hours for each technology
                 FullLoadHours_DG(co,year,i,allscen)        full load hours for each technology
           production_GasT_el(co,year,allscen)              production by gas fired power plants in MWh_el
           production_GasT_th(co,year,allscen)              production by gas fired power plants in MWh_th

%startup%   startup(i,co,t,year,allscen)
%store%     storagelvl(t,co,i,year,allscen)
 ;
