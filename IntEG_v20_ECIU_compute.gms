parameters
    Fstoch_GasDem,
    Fstoch_ElDem,
    Fstoch_RESCap,
    Fstoch_FuelPrice,
    Fstoch_CO2Price,
    Fstoch_AllPar;

parameters
    Fstoch_finv_GasDem,
    Fstoch_finv_ElDem,
    Fstoch_finv_RESCap,
    Fstoch_finv_FuelPrice,
    Fstoch_finv_CO2Price,
    Fstoch_finv_AllPar;

*storing objectives from Stoch Solutions

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_GasDem
$Load  Fstoch_GasDem  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_ElDem
$Load  Fstoch_ElDem  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_RESCap
$Load  Fstoch_RESCap  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_FuelPrice
$Load  Fstoch_FuelPrice  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_CO2Price
$Load  Fstoch_CO2Price = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_Scen_AllPar
$Load  Fstoch_AllPar = Cost_GLobal.l
$gdxin

*storing objectives from Stoch Solutions with fixed investments

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_GasDem
$Load  Fstoch_finv_GasDem  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_ElDem
$Load  Fstoch_finv_ElDem  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_RESCap
$Load   Fstoch_finv_RESCap  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_FuelPrice
$Load   Fstoch_finv_FuelPrice  = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_CO2Price
$Load  Fstoch_finv_CO2Price = Cost_GLobal.l
$gdxin

$gdxin %resultdir%%GlobalSCEN%_STOCH_FINV_Scen_AllPar
$Load  Fstoch_finv_AllPar = Cost_GLobal.l
$gdxin

parameter report_VSS(*);

    report_VSS('VSS_GasDem [M Euro]')    = (Fstoch_finv_GasDem     - Fstoch_GasDem)     / 1000000 ;
    report_VSS('VSS_ElDem [M Euro]')     = (Fstoch_finv_ElDem      - Fstoch_ElDem)      / 1000000 ;
    report_VSS('VSS_RESCap [M Euro]')    = (Fstoch_finv_RESCap     - Fstoch_RESCap)     / 1000000 ;
    report_VSS('VSS_FuelPrice [M Euro]') = (Fstoch_finv_FuelPrice  - Fstoch_FuelPrice)  / 1000000 ;
    report_VSS('VSS_CO2Price [M Euro]')  = (Fstoch_finv_CO2Price   - Fstoch_CO2Price)   / 1000000 ;
    report_VSS('VSS_AllPar [M Euro]')    = (Fstoch_finv_AllPar     - Fstoch_AllPar)     / 1000000 ;

    report_VSS('VSS_GasDem [%]')    = (Fstoch_finv_GasDem     - Fstoch_GasDem)    / Fstoch_finv_GasDem      * 100;
    report_VSS('VSS_ElDem [%]')     = (Fstoch_finv_ElDem      - Fstoch_ElDem)     / Fstoch_finv_ElDem       * 100;
    report_VSS('VSS_RESCap [%]')    = (Fstoch_finv_RESCap     - Fstoch_RESCap)    / Fstoch_finv_RESCap      * 100;
    report_VSS('VSS_FuelPrice [%]') = (Fstoch_finv_FuelPrice  - Fstoch_FuelPrice) / Fstoch_finv_FuelPrice   * 100;
    report_VSS('VSS_CO2Price [%]')  = (Fstoch_finv_CO2Price   - Fstoch_CO2Price)  / Fstoch_finv_CO2Price    * 100;
    report_VSS('VSS_AllPar  [%]')  = (Fstoch_finv_AllPar      - Fstoch_AllPar)    / Fstoch_finv_AllPar      * 100;

execute_unload '%resultdir%%GlobalSCEN%Fstochs.gdx' Fstoch_GasDem, Fstoch_ElDem,  Fstoch_RESCap,  Fstoch_FuelPrice,  Fstoch_CO2Price, Fstoch_AllPar
                                        Fstoch_finv_GasDem, Fstoch_finv_ElDem,  Fstoch_finv_RESCap,  Fstoch_finv_FuelPrice,  Fstoch_finv_CO2Price, Fstoch_finv_AllPar,
                                        report_VSS;
