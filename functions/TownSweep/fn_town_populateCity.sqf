diag_log ("ts_patrols_multipl" call BIS_fnc_getParamValue);
diag_log ("ts_faction" call BIS_fnc_getParamValue);

private ["_faction","_marker_size","_marker_name","_marker","_ts_factions"];

diag_log "Start populating city.";

_ts_factions = ["OPF_F","OPF_G_F","IND_F","IND_G_F","OPF_T_F","IND_C_F","NLDO_RU_VDV_76","NLDO_RU_VDV_31","NLDO_UA_UAF_95","CUP_O_TK_INS","CUP_O_TK","CUP_O_CHDKZ","CUP_O_SLA","CUP_O_RU_EMR","CUP_O_RU_FLORA","CUP_I_NAPA","CUP_I_RACS","CUP_I_TK_GUE","LT_CUP_I_PMC","LT_CUP_AFR_REB","LT_CUP_AFR_ARMY","LT_CUP_AFR_M_REB","LT_CUP_AFR_UN","LT_CUP_ARMY_ASIA","LT_CUP_INS_ASIA"];
sleep 1;
_faction = _ts_factions select ("ts_faction" call BIS_fnc_getParamValue);

diag_log format["TS Debug -- Chosen faction: %1",_faction];
diag_log format["TS Debug -- Multiplier: %1","ts_patrols_multipl" call BIS_fnc_getParamValue];

_marker_size = markerSize "ao";

diag_log _marker_size;

_marker_name = format["marker_%1",round random[1000,5000,9999]];
_marker = createMarker [_marker_name,getMarkerPos "ao"];
_marker setMarkerColor "ColorRed";
_marker setMarkerAlpha 0;
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [(_marker_size select 0),(_marker_size select 1)];

_multiplierArray = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2,3,4];
_multiplier = _multiplierArray select ("ts_patrols_multipl" call BIS_fnc_getParamValue);

null = [_marker, _faction, 250, ((count allPlayers) * _multiplier ),6,2,2,0,0,0,20,20] call lt_fnc_autozone;

// sleep 60;
// "ao" setMarkerAlpha 0.5;
