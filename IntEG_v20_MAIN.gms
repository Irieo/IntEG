$Title IntEG version 20 (09 March 2020)

$ontext
Integrated energy dispatch & investment model
LSEW BTU

    UPPERCASE      - parameter
    lowercase      - variable
$offtext


*###############################################################################
*                                  DEFAULT OPTIONS
*###############################################################################

file fx2;
put fx2;

$eolcom #

*###############################################################################
*                            DIRECTORIRY and FILE MANAGEMENT
*###############################################################################

*Location of input files
$set datadir    data\

*  Currently all data is in one file
$Set DataIn     Input_v2

* version
$setglobal GlobalSCEN v20

*Assigning to output file a model's version
$set       result     Integ_%GlobalSCEN%

*   Choose time resolution of GAS model [year, month, day]
*   $setglobal Month

*###############################################################################
*                                MODEL SPECIFICATIONS
*###############################################################################

                        #SELECT "" TO ACTIVATE / '*' TO DISACTIVATE

$setglobal only_report      ""  # if '*' report not active, if '' report and stop after report active

                                #RELATED TO PARAMETRIC UNCERTAINTY

$setglobal Inc_Det          "*"
$setglobal Inc_Stoch        ""
$setglobal Inc_StochFI      ""
$setglobal Inc_ECIUvalues   "*"

$ifthen "%Inc_Stoch%" ==    ""   $set Exc_Stoch ""
                                 set  allscen       /EUCO, ST, DG/
                                      scen(allscen) /EUCO, ST, DG/;
$else                            $set Exc_Stoch "*"
                                 set  allscen /EVP, EUCO, ST, DG/
                                      scen(allscen);
$endif

set UncPar /GasDem, ElDem, RESCap, FuelPrice, CO2Price, AllPar/;

                                #RELATED TO GAS MODEL

$setglobal Inc_LTC      "*"
$ifthen "%Inc_LTC%" ==  ""   $setglobal Exc_LTC "*"
$else                        $setglobal Exc_LTC ""
$endif

$setglobal Invest_gas_grid   "*"  #Investments in gas infrastructure
$setglobal Invest_gas_LNG    "*"  #Investments in LNG infrastructure

                              #RELATED TO ELECTRICITY  MODEL

$setglobal Store        ""         #Storage
$setglobal Shed         ""         #Load shedding
$setglobal Trade        ""         #Trade between markets
$setglobal Startup      "*"        #Startups
$setglobal Invest_gen   ""         #Investment in generation capacity
$setglobal Invest_NTC   "*"        #Investment in NTC capacity
$setglobal CHP          ""         #considering minim production due to CHP

$ifthen "%Startup%" == ""   $setglobal Exc_startup "*"
$else                       $setglobal Exc_startup ""
$endif


*###############################################################################
*                               DECLARING & MAPPING TIME
*###############################################################################

$include IntEG_v20_declar_time.gms

*###############################################################################
*                               DECLARING & MAPPING TOPOLOGY
*###############################################################################

$include IntEG_v20_declar_topology.gms

*###############################################################################
*                               DECLARING PARAMETERS
*###############################################################################

$include IntEG_v20_declar_parameters.gms

*execute_unload "check.gdx"
*$stop

*###############################################################################
*                               Running Checks
*###############################################################################

%only_report%$include IntEG_V20_report.gms
%only_report%$stop

*###############################################################################
*                        MODEL (variables, equations, model form)
*###############################################################################

$include IntEG_v20_model.gms

*###############################################################################
*                        FIXING VARIABLES & SOLVE OPTIONS
*###############################################################################

$include IntEG_v20_SolveOptions.gms

*#################################################################################################################################
*                                                       SCENARIO 1: ECIU - EVP
*#################################################################################################################################

$include IntEG_V20_S1(ECIU_EVP).gms

*#################################################################################################################################
*                                                       SCENARIO 2: ECIU - EUCO
*#################################################################################################################################

$include IntEG_V20_S2(ECIU_EUCO).gms

*#################################################################################################################################
*                                                       SCENARIO 3: ECIU - ST
*#################################################################################################################################

$include IntEG_V20_S3(ECIU_ST).gms

*#################################################################################################################################
*                                                       SCENARIO 4: ECIU - DG
*#################################################################################################################################

$include IntEG_V20_S4(ECIU_DG).gms
