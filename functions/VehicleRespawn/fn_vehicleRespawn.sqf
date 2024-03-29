/*
	File:
		fn_vehicleRespawn.sqf
	
	Author:
		Fredrik Eriksson

	Description:
		Vehicle respawn, with init, name and loadout capabilities.

	Parameters:
		0 : OBJECT (REQUIRED)
				- Vehicle to be monitored for respawn.
		1 : NUMBER (OPTIONAL)
				- Respawn delay in seconds. +-5-10 seconds.
					(Default: 5)
		2 : CODE (OPTIONAL)
				- Initialization for vehicle. (To call vehicle use: _this)
		3 : NUMBER (OPTIONAL)
				- Respawn Limit. Number of lives a vehicle has.
					(Default: -1)
		4 : BOOLEAN (OPTIONAL)
				- Deletes wreck on respawn. Wrecks within 
				100m of respawn point is automatically deleted, regardless of setting.
					(Default: false)
		5 : BOOLEAN (OPTIONAL)
				- Use Custom Loadout. Saves inventory and loads it on respawn. 
					(Default: true)
		6 : BOOLEAN (OPTIONAL)
				- Custom Paintjob. Saves the current paint on the vehicle and applies it on respawn. 
					(Default: true)
		7 : BOOLEAN (OPTIONAL)
				- Custom Pylons. Saves the current pylon on the vehicle and applies it on respawn. 
					(Default: true)
	
	Example:
		[this, 5, {_this allowDamage false;}, false] call FRED_fnc_vehicleRespawn;
*/

if (!isServer) exitWith {};
private ["_inventory", "_paint", "_parts", "_vehicleData", "_pylons", "_pylonPaths","_ltDroneSide", "_ltVehSide", "_ltVehRole", "_UAVCrew", "_maxLoad"];
params [
	["_vehicle", objNull, [objNull]],
	["_delay", 5, [0]],
	["_init", {}, [{}]],
	["_respawnLimit", -1, [0]],
	["_deleteWreck", true, [true]],
	["_loadout", true, [true]],
	["_savePaint", true, [true]],
	["_savePylon", true, [true]]
];

_limitEnabled = false;
if (_respawnLimit != -1) then {
	_vehicle setVariable ["VRRespawnLimit", _respawnLimit, true];
	_limitEnabled = true;
};

_inventory = [];
if (_loadout) then {
	_items = getItemCargo _vehicle;
	_magazines = getMagazineCargo _vehicle;
	_weapons = getWeaponCargo _vehicle;
	_backpacks = getBackpackCargo _vehicle;
	_inventory = [_items, _magazines, _weapons, _backpacks];
};

_paint = "";
_parts = [];
if (_savePaint) then {
	_customization = [_vehicle] call BIS_fnc_getVehicleCustomization;
	_paint = (_customization select 0);
	_parts = _customization select 1;
};
if _savePylon then {
	_pylons = getPylonMagazines (_vehicle); 
	 _pylonPaths = [];
	 {_pylonPaths pushBack (_x select 2);} forEach (getAllPylonsInfo _vehicle);
};

_UAVCrew = false;
_ltDroneSide = _vehicle getVariable ["LT_drone_side", "WEST"];
_ltVehSide = _vehicle getVariable ["LT_veh_side", "WEST"];
_ltVehRole = _vehicle getVariable ["LT_veh_role", "Empty"];
if (getNumber (configFile >> "cfgvehicles" >> typeOf _vehicle >> "isUAV") > 0 && count (crew _vehicle) > 0) then {
	_UAVCrew = true;
};

_maxLoad = maxLoad _vehicle;

_vehicleData = [
	_delay, _init, _loadout, vehicleVarName _vehicle, getPosASL _vehicle, 
	getDir _vehicle, typeOf _vehicle, _inventory, _savePaint, _paint, _parts, 
	_deleteWreck, _limitEnabled,_savePylon, _pylons, _pylonPaths,
	_ltDroneSide, _ltVehSide, _ltVehRole, _UAVCrew, _maxLoad
];

if (isNil "VRMonitor") then {
	TotalVRArray = [];
	[] spawn FRED_fnc_vehicleMonitor;
	VRMonitor = 1;
};

TotalVRArray pushBack [_vehicle, _vehicleData];
