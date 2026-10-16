/*

File: fn_initPostVeh.sqf
Author: Brainless_Ben

Description:
preps veh loadout with the parameters from the description.ext or keeps the mission template.

Parameters:
[] 
	Example:
	[] remoteExec ["LT_fnc_initPostVeh", 2]

*/

if (!isServer) exitWith {};

if (lt_vehicleGearIsSet == 1) then
{
	["initPostVeh","Vehicle loadouts already set",2] call LT_fnc_log;
}else
{
	{
		_spawnPoint = _x getVariable ["LT_veh_respawnPoint",false];
		if (_spawnPoint OR _spawnPoint isEqualTo 1) then
		{
			_name = _x getVariable ["LT_veh_respawnName", ""];
			_side = switch (_x getVariable ["LT_veh_side","WEST"]) do
			{
				case"EAST":{east};
				case"GUER":{resistance};
				default{west};
			};
			[_side,_x,_name] remoteExec ["BIS_fnc_addRespawnPosition",0];
		};
		if (_x isKindOf "ReammoBox_F" OR _x isKindOf "LandVehicle" OR _x isKindOf "Air" OR _x isKindOf "Ship") then 
		{
			_vehLoadout = _x getVariable ["LT_veh_role", "Custom"];
			_vehside = _x getVariable ["LT_veh_side", "CIV"];
			["initPostVeh",format ["Vehicle: %1 has Loadout: %2", _x, _vehLoadout],2] call LT_fnc_log;
			if (_vehLoadout != "Custom") then 
			{
				[_x, _vehside, _vehLoadout] spawn
				{
					params ["_vehicle","_vehside","_vehLoadout"];
					waitUntil {sleep 0.2;((((westWeapons get "Rifle") get "Weapon")#0) != "")};
					[_vehicle, _vehside, _vehLoadout] remoteExec ["LT_fnc_VehicleLoadout"];
				};
			}else
			{
				_vehRespawn = _x getVariable ["LT_veh_respawn", 0];
				["initPostVeh",format ["Vehicle: %1 has Respawn: %2", _x, _vehRespawn],2] call LT_fnc_log;
				if (_vehRespawn != 0) then 
				{
					_x setVariable ["LT_veh_setRepawn", 1];
					_delay = _x getVariable ["LT_veh_respawn_delay",15];
					if (_delay < 15) then {_delay = 15;};
					[_x, _delay] call FRED_fnc_vehicleRespawn;
				};
			};
		};
		if ((getNumber (configFile >> "cfgvehicles" >> typeOf _x >> "isUAV") > 0) && count (crew _x) > 0) then 
		{
			_UAVSide = _x getVariable ["LT_drone_side", "WEST"];
			_vehSide = switch (_UAVSide) do
			{
				case "WEST":{west};
				case "EAST":{east};
				case "GUER":{resistance};
				case "CIV":{civilian};
			};
			_grpSide = (createGroup _vehSide);
			_grpSide copyWaypoints (group _x);
			[_x] joinSilent _grpSide;
			(crew _x) joinSilent _grpSide;
		};
	}forEach vehicles;

	lt_vehicleGearIsSet = 1;
	publicVariable "lt_vehicleGearIsSet";
};