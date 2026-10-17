/*

File: LT_fnc_safety.sqf
Author: Brainless_Ben

Description:
Sets the safety eventhandelers for the mission.

Parameters:
Params are true or false (_this select 0)

*/

switch (_this select 0) do
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

		// ACE: no throwing of grenades and other throwables during the safety time
		if (!isNil "ace_common_fnc_statusEffect_set") then {[player, "blockThrow", "LT_safety", true] call ace_common_fnc_statusEffect_set};

		["Safety","Safety True"] call LT_fnc_log;
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
		player allowDamage true;

		if (!isNil "ace_common_fnc_statusEffect_set") then {[player, "blockThrow", "LT_safety", false] call ace_common_fnc_statusEffect_set};

		["Safety","Safety False"] call LT_fnc_log;
	};
};
