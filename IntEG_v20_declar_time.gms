*###############################################################################
*                               DECLARING TIME SETS
*###############################################################################
$Setglobal  YEARS_inc  y2020, y2025, y2030
* is removed y2015

SETS
    t_all               all hours of a year                /t1*t8760/
    t(t_all)            all hours to be solved
;

SETS
    Year_all            all possible years              /y2013*y2027,y2030/        
    Year(Year_all)      year modelled                   /%YEARS_inc%/
    month               set of month                    /m1*m12/
    day                 days in a year                  /day1*day365/
    hourD               hours of a day                  /hour1*hour24/

    time(month,day,t_all,hourD)     aggregated time set for 1 year
    Year_T(Year,t_all)              Mapping
    Month_T(Month,t_all)            mapping
    hour_T(hourD,t_all)             mapping

    Day_T(Day,t_all)                mapping
    Year_M (year, month)            mapping

    m_first(month)                   first month    in year
    m_last(month)                    last month     in year
    y_first(year)                    first year     in model
    y_last(year)                     last year      in model
    m_first_global(year, month)      first month    in model
    m_last_global(year, month)       last month     in model
    ;

    alias (t_all,tt_all)
    alias (t,tt)


*###############################################################################
*                               READING and MAPPING 
*###############################################################################

*Don't write comments inside onecho file!
$onecho > Import_time.txt
        set=time rng=time!C1          rdim=4
        set=t    rng=time_periods!C2  rdim=1
$offecho

$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%Time.gdx cmerge=1 @Import_time.txt
$gdxin %datadir%Time.gdx
$LOAD time, t
$gdxin

*                               MAPPING TIME

loop(year,
    Loop(time(month,day,t_all,hourD),
        Month_T(Month,t_all)    = yes;
        Day_T(Day,t_all)        = yes;
        hour_T(hourD,t_all)     = yes;
        );
    Year_T(Year,t_all)      = yes;
    Year_M(year, month)     = yes;

    );

*                               TIME MANAGEMENT

    m_first(month) = yes$(ord(month) eq 1);
    m_last(month)  = yes$(ord(month) eq card(month));

    y_first(year) = yes$(ord(year) eq 1);
    y_last(year)  = yes$(ord(year) eq card(year));

    m_first_global(year, month) = yes$(m_first(month) and y_first(year));
    m_last_global(year, month) = yes$(m_last(month) and y_last(year));


*                               CHECK TIME INPUT
*execute_unload '%datadir%1_check_timeinput.gdx'
