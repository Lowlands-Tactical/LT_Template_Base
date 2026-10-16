/*

File: LT_fnc_safety.sqf
Author: Brainless_Ben

Description:
Sets the safety eventhandelers for the mission.

Parameters:
Params are true or false (_this select 0)

*/

if (!hasInterface || {isNull player}) exitWith {};
LT_safetyActive = _this select 0;
// Safe Start ending must not make a player in LTR holding vulnerable.
if (player getVariable ["LTR_localWaiting", false]) then {player setVariable ["LTR_restoreDamage", true]};
switch (LT_safetyActive) do
{
	//Turn safety on
	case true:
	{
		if (isNil "LT_safetyMan") then 
		{
			LT_safetyMan = player addEventHandler["Fired", {deletevehicle (_this select 6); }];
		};

		if (vehicle player != player && {player in [gunner vehicle player,driver vehicle player,commander vehicle player]}) then 
		{
			player setVariable ["LT_var_safetyVeh",vehicle player];
			(player getVariable "LT_var_safetyVeh") allowDamage true;

			if (isNil "LT_safetyVeh") then 
			{
				LT_safetyVeh = (player getVariable "LT_var_safetyVeh") addEventHandler["Fired", {deletevehicle (_this select 6);}];
			};
		};
		player allowDamage false;

		Diag_log "[LT] (Safety) Safety True";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) Safety True";
		};
	};

	//Turn safety off
	case false: 
	{
		if !(isNil "LT_safetyMan") then 
		{
			player removeEventhandler ["Fired", LT_safetyMan];
			LT_safetyMan = nil;
		};

		if !(isNull(player getVariable ["LT_var_safetyVeh",objnull])) then 
		{
			(player getVariable "LT_var_safetyVeh") allowDamage true;

			if !(isNil "LT_safetyVeh") then 
			{
				(player getVariable "LT_var_safetyVeh") removeeventhandler ["Fired", LT_safetyVeh];
				LT_safetyVeh = nil;
			};
			player setVariable ["LT_var_safetyVeh",nil];
		};
		player allowDamage !(player getVariable ["LTR_localWaiting", false]);

		Diag_log "[LT] (Safety) Safety False";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) Safety False";
		};
	};
};
