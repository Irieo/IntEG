
********************************  Global MODEL TOPOLOGY ***************************
SETS
    n                all nodes
    co(n)            consumption nodes for gas and all nodes for electricity
    coo(co)          co without Norway
    ;

********************************  GAS MODEL TOPOLOGY ***************************

SETS

        prall(n)     only gas production nodes
        trgen(n)     only trading nodes             #without LNG terminals
        lng_p(n)     lng suppliers cut              #for separation of LNG and pipeline deliveries in postprocessing

        regn(n)      only regasificatino terminals
        liqn(n)      only liquifation terminals
        storall(n)   only storage nodes

    P   gas producers
        eu_p(p)      European-only producers

    W   gas wholesalers                             #players
    ;

    alias(n,m);
    alias(n,nn);
    alias(co,coco);
    alias(trgen,jtrgen);

*****************************  ELECTRICITY MODEL TOPOLOGY *********************

SETS
    i                      all electricity generation technologiess
        ResT(i)            only RES generation technologies
        ConvT(i)           only conventional technologies
        StorT(i)           only storage technologies
        GasT(i)            only gas fuel technologies
        ReservT(i)         only Reservoirs
        noGas(i)           conventional technologies without Gas technologies

    scen_up         scenarios which are used to upload all scenario data
                    /EUCO_up, ST_up, DG_up/
    ;