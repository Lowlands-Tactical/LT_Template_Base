/*

File: XEH_PreInit.sqf
Author: Brainless_Ben

Description:
Defines a number of publicvariables

*/

lt_group_teleport = 0;
lt_resupply = 0;
lt_playerCamoIsSet = 0;
lt_vehicleGearIsSet = 0;

Diag_log "[LT] (XEH) PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) PreInit finished";
};
