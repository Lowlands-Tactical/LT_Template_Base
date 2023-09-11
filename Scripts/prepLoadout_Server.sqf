/*

File: prepLoadout_Server.sqf
Author: Brainless_Ben

Description:
preps each side loadout voor the server to be used in fn_vehicleLoadout

*/

Diag_log "[LT] (prepLoadout) prepLoadout server is loading";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (prepLoadout) prepLoadout server is loading";
};

if (!isServer) exitWith {};

_sides = [west,east,resistance];
{
	_aiSide = createCenter _x;
	_aiGroup = [[0,0], _aiSide, 1] call BIS_fnc_spawnGroup;
	_aiUnit = leader _aiGroup;
	_aiUnit setVariable ["LT_unit_role","lvdw"];
	_aiUnit disableAI "all";
	[_aiUnit] remoteExec ["LT_fnc_prepPlayerLoadout", 2];

	if (side _aiUnit == west) then 
	{
		waitUntil {sleep 1;!isNil "LT_Items_Blue";};
		waitUntil {sleep 1;!isNil "LT_Weapons_Blue";};
		[(group _aiUnit)] call LT_fnc_deleteUnits;
	};
	if (side _aiUnit == east) then 
	{
		waitUntil {sleep 1;!isNil "LT_Items_Red";};
		waitUntil {sleep 1;!isNil "LT_Weapons_Red";};
		[(group _aiUnit)] call LT_fnc_deleteUnits;
	};
	if (side _aiUnit == resistance) then 
	{
		waitUntil {sleep 1;!isNil "LT_Items_Green";};
		waitUntil {sleep 1;!isNil "LT_Weapons_Green";};
		[(group _aiUnit)] call LT_fnc_deleteUnits;
	};
}forEach _sides;

Diag_log "[LT] (prepLoadout) prepLoadout server is finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (prepLoadout) prepLoadout server is finished";
};
