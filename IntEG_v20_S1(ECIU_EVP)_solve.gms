Loop(UncPar,

if (ord(UncPar) = 1, #GasDem

        # assigning scenario-specific data

        nonPowerDem(co,year,month,'EUCO') = cons_EUCO(co, year, month) * (1 -  PS_EUCO(co, year));
        nonPowerDem(co,year,month,'ST') = cons_ST(co, year, month) * (1 - PS_ST(co,year));
        nonPowerDem(co,year,month,'DG') = cons_DG(co, year, month) * (1 - PS_DG(co,year));

        # matching quantities of Gas and El Model for scenario-specific data

        nonPowerDem(co,year,month,'EUCO') = nonPowerDem(co,year,month,'EUCO')/conversion_factor_gas ;
        nonPowerDem(co,year,month,'ST') = nonPowerDem(co,year,month,'ST')/conversion_factor_gas ;
        nonPowerDem(co,year,month,'DG') = nonPowerDem(co,year,month,'DG')/conversion_factor_gas ;

elseif ord(UncPar) = 2, #ElDem

         demand(co,t,year,'EUCO') = demand_upload(co,t,year,'EUCO_up');
         demand(co,t,year,'ST') = demand_upload(co,t,year,'ST_up');
         demand(co,t,year,'DG') = demand_upload(co,t,year,'DG_up');

elseif ord(UncPar) = 3, #RESCap

         cap_existing(i,n,year,'EUCO') = cap_existing_upload(i,n,year,'EUCO_up');
         cap_existing(i,n,year,'ST') = cap_existing_upload(i,n,year,'ST_up');
         cap_existing(i,n,year,'DG') = cap_existing_upload(i,n,year,'DG_up');

elseif ord(UncPar) = 4, #FuelPrice

         fc(i,co,year,'EUCO') = fc_upload(i,co,year,'EUCO_up') ;
         fc(i,co,year,'ST') = fc_upload(i,co,year,'ST_up') ;
         fc(i,co,year,'DG') = fc_upload(i,co,year,'DG_up') ;
         vc_f(i,co,year,scen) = (fc(i,co,year,scen) + carb_cont(i)*EVP_co2_price(year))/ eta_f(i,co,year);        
         vc_m(i,co,year,scen) = (fc(i,co,year,scen) + carb_cont(i)*EVP_co2_price(year))/ eta_m(i,co,year);

elseif ord(UncPar) = 5,                   #CO2Price

         co2_price('EUCO',year) = co2_price_upload('EUCO_up', year);
         co2_price('ST',year) = co2_price_upload('ST_up', year);
         co2_price('DG',year) = co2_price_upload('DG_up', year);
         vc_f(i,co,year,scen) = (EVP_fc(i,co,year) + carb_cont(i)*co2_price(scen,year))/ eta_f(i,co,year);       #
         vc_m(i,co,year,scen) = (EVP_fc(i,co,year) + carb_cont(i)*co2_price(scen,year))/ eta_m(i,co,year);

elseif ord(UncPar) = 6,                   #AllPar
       
        # assigning scenario-specific data

        nonPowerDem(co,year,month,'EUCO') = cons_EUCO(co, year, month) * (1 -  PS_EUCO(co, year));
        nonPowerDem(co,year,month,'ST') = cons_ST(co, year, month) * (1 - PS_ST(co,year));
        nonPowerDem(co,year,month,'DG') = cons_DG(co, year, month) * (1 - PS_DG(co,year));

        nonPowerDem(co,year,month,'EUCO') = nonPowerDem(co,year,month,'EUCO')/conversion_factor_gas ;
        nonPowerDem(co,year,month,'ST') = nonPowerDem(co,year,month,'ST')/conversion_factor_gas ;
        nonPowerDem(co,year,month,'DG') = nonPowerDem(co,year,month,'DG')/conversion_factor_gas ;


        demand(co,t,year,'EUCO') = demand_upload(co,t,year,'EUCO_up');
        demand(co,t,year,'ST') = demand_upload(co,t,year,'ST_up');
        demand(co,t,year,'DG') = demand_upload(co,t,year,'DG_up');

        cap_existing(i,n,year,'EUCO') = cap_existing_upload(i,n,year,'EUCO_up');
        cap_existing(i,n,year,'ST') = cap_existing_upload(i,n,year,'ST_up');
        cap_existing(i,n,year,'DG') = cap_existing_upload(i,n,year,'DG_up');

        fc(i,co,year,'EUCO') = fc_upload(i,co,year,'EUCO_up') ;
        fc(i,co,year,'ST') = fc_upload(i,co,year,'ST_up') ;
        fc(i,co,year,'DG') = fc_upload(i,co,year,'DG_up') ;

        co2_price('EUCO',year) = co2_price_upload('EUCO_up', year);
        co2_price('ST',year) = co2_price_upload('ST_up', year);
        co2_price('DG',year) = co2_price_upload('DG_up', year);

        vc_f(i,co,year,scen) = (fc(i,co,year,scen) + carb_cont(i)*co2_price(scen,year))/ eta_f(i,co,year);       
        vc_m(i,co,year,scen) = (fc(i,co,year,scen) + carb_cont(i)*co2_price(scen,year))/ eta_m(i,co,year);

    );

        SOLVE LSEWglobal using lp minimizing Cost_GLobal          ;