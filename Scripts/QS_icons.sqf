/*
    Legacy entry point for missions that execute QS_icons.sqf from this PBO.
    Soldier Tracker has been replaced by LT Map Intel. The initializer also
    runs at addon postInit and guards against duplicate handlers.
*/
[] call LT_fnc_initMapIntel;
