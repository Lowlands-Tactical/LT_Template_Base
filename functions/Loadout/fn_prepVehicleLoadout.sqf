/*

File: fn_prepVehicleLoadout.sqf
Author: Brainless_Ben

Description:
preps loadout voor every player with the parameters from the description.ext or keeps the mission template.

Parameters:
[] 
	Example:
	[] remoteExec ["LT_fnc_prepVehicleLoadout", 2]

*/

if (!isServer) exitWith {};

// Set vehicle gear if not already set
if (lt_vehicleGearIsSet == 1) then 
{
	Diag_log "[LT] (prepLoadout) vehicle loadouts already set";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (prepLoadout) vehicle loadouts already set";
	};
} else 
{
	{
		if (_x isKindOf "ReammoBox_F" OR _x isKindOf "Car" OR _x isKindOf "Tank" OR _x isKindOf "Air" OR _x isKindOf "Ship") then 
		{
			_vehLoadout = _x getVariable ["LT_veh_role", "Empty"];
			_vehside = _x getVariable ["LT_veh_side", "WEST"];
			Diag_Log format["[LT] (prepLoadout) Vehicle: %1 has Loadout: %2", _x, _vehLoadout];
			if (_vehLoadout != "Custom") then 
			{
				[_x, _vehside, _vehLoadout] remoteExec ["LT_fnc_VehicleLoadout"];
			};
		};

		if (getNumber (configFile >> "cfgvehicles" >> typeOf _x >> "isUAV") > 0 && count (crew _x) > 0) then 
		{
			_UAVSide = _x getVariable ["LT_drone_side", "WEST"];
			_side = switch (_UAVSide) do
			{
				case "WEST":{west};
				case "EAST":{east};
				case "GUER":{resistance};
				case "CIV":{civilian};
			};
			_grpSide = (createGroup _side);
			_grpSide copyWaypoints (group _x);
			[_x] joinSilent _grpSide;
			(crew _x) joinSilent _grpSide;
		};
		
		sleep 0.2;
	}forEach vehicles;

	lt_vehicleGearIsSet = 1;
	publicVariable "lt_vehicleGearIsSet";
};
