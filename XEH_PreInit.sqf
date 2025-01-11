/*

File: XEH_PreInit.sqf
Author: Brainless_Ben

Description:
Defines a number of publicvariables

*/

lt_group_teleport = 0;
publicVariable "lt_group_teleport";
lt_resupply = 0;
publicVariable "lt_resupply";
lt_playerCamoIsSet = 0;
publicVariable "lt_playerCamoIsSet";
lt_vehicleGearIsSet = 0;
publicVariable "lt_vehicleGearIsSet";

Diag_log "[LT] (XEH) PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) PreInit finished";
};
