/*

File: XEH_PreInit.sqf
Author: Brainless_Ben

Description:
Defines a number of publicvariables

*/

lt_staff = [
	"76561198042684200",	// Tybalty
	"76561198028914656",	// Lonesentinel
	"76561198014060493",	// R.Hoods
	"76561197992586763",	// Brainless_Ben
	"76561198047491445" 	// Pekeru
];
publicVariable "lt_staff";

lt_admin = (getPlayerUID player) in lt_staff;
publicVariable "lt_admin";
lt_crew = serverCommandAvailable "#kick";
publicVariable "lt_crew";
lt_group_teleport = 0;
publicVariable "lt_group_teleport";
lt_resupply = 0;
publicVariable "lt_resupply";
lt_playerCamoIsSet = 0;
publicVariable "lt_playerCamoIsSet";
lt_vehicleGearIsSet = 0;
publicVariable "lt_vehicleGearIsSet";

Diag_Log format["[LT] (XEH) LT_Staff: %1", lt_staff];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (XEH) LT_Staff: %1", lt_staff];
};

Diag_log "[LT] (XEH) PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) PreInit finished";
};
