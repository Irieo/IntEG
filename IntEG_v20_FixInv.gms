$gdxin %resultdir%%GlobalSCEN%_DET_Scen
$Load  geninv_DET  = CAP_new.l
$gdxin

CAP_new.fx(i,co,year)   = geninv_DET(i,co,year);

execute_unload '%resultdir%fixedcap.gdx' Cap_new;
