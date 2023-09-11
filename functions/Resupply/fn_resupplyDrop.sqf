/*

File: fn_ResupplyDrop.sqf
Author: Brainless_Ben

Description:
Function to drop the supplys.

Parameters:
_this select 0 = pilot
_this select 1 = loadoutType

*/

private ["_crate","_chute","_side","_nvg","_veh","_locVeh","_dropObj","_spnChut"];
params [
	["_pilot", objNull, [objNull]],
	["_loadoutType", "", [""]]
];

// Make sure only the pilot spawns the loadout
if !(local _pilot) exitWith {};
if (isNull _pilot) exitWith {};
if (_loadoutType == "None") exitWith {};

// Import variable attached to the group in fnc_ResupplyRequest
_crate = (group _pilot) getVariable "LT_Resupply_Crate";
_chute = (group _pilot) getVariable "LT_Resupply_Chute";
_side = (group _pilot) getVariable "LT_veh_side";
_nvg = "lt_gear_nvg" call bis_fnc_getParamValue;

// Extra crate check in case of special demand
_crate = switch (_loadoutType) do 
{
	case "Crate Explosives": {"NLD_Ammo_Crate_Explosieven"};
	case "Crate Medical": {"NLD_Ammo_Crate_Medisch"};
	case "Crate Weapons": {"NLD_Ammo_Crate_Wapens"};
	case "M2 HMG": {"B_G_HMG_02_high_F"};
	case "Mk6 Morter": {"B_T_Mortar_01_F"};
	case "Remote Designator": {"B_W_Static_Designator_01_F"};
	case "King Quad": {"NLD_Quad"};
	case "VW Amarok": {"NLD_Amarok"};
	case "MB G280 CDI": {"NLD_WLD_MB_SF"};
	case "Assault Boat": {"B_Boat_Transport_01_F"};
	case "NLD RHIB": {"NLD_RHIB"};
	case "FRISC Motorboat": {"NLD_FRISC"};
	default {_crate};
};
_loadoutType = switch (_loadoutType) do 
{
	case "King Quad": {"Crate Small"};
	case "VW Amarok": {"Crate Medium"};
	case "MB G280 CDI": {"Crate Medium"};
	case "Assault Boat": {"Crate Small"};
	case "NLD RHIB": {"Crate Medium"};
	case "FRISC Motorboat": {"Crate Medium"};
	default {_loadoutType};
};

// Debug messages
Diag_log format["[LT] (Resupply) Crate=%1 Chute=%2 LoadoutTypes=%3", _crate, _chute, _loadoutType];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (Resupply) Crate=%1 Chute=%2 LoadoutTypes=%3", _crate, _chute, _loadoutType];
};

_veh = vehicle _pilot;
_locVeh = [(position _veh) select 0, (position _veh) select 1, ((position _veh) select 2) -25];

// Define dropped object
private _dropObj = createVehicle [_crate, _locVeh, [], 0, "CAN_COLLIDE"];
_dropObj setVelocity (velocity _veh);
_dropObj setDir (direction _veh);
_dropObj allowDamage false;
uiSleep 0.3;

// Define chute
private _spnChut = createVehicle [_chute, position _dropObj, [], 0, "NONE"];
_spnChut setVelocity (velocity _dropObj);
_spnChut setDir (direction _dropObj);
_dropObj attachTo [_spnChut, [0,0,-1]];
_dropObjAtt = [];

// Checks if mission is in day or night and attaches the right smoke/light
if (sunOrMoon == 1) then 
{
	_smoke = createVehicle ["SmokeShellOrange", [0,0,0], [], 0, ""];
	_smoke attachTo [_dropObj, [0,0,0]];
	_dropObjAtt pushback _smoke;
} else 
{
	if (_nvg == 0) then 
	{
		private _light = "#lightpoint" createVehicleLocal (position _dropObj);
		_light attachTo [_dropObj, [0,0,0]];
		_light setLightColor [0.85,0.4,0.1];
		_light setLightAmbient [0.85,0.4,0.1];
		_light setLightUseFlare true;
		_light setLightFlareSize 10;
		_light setLightFlareMaxDistance 100000;
		_light setLightIntensity 100000;
		_dropObjAtt pushback _light;
	} else 
	{
		private _light = "#lightpoint" createVehicleLocal (position _dropObj);
		_light attachTo [_dropObj, [0,0,0]];
		_light setLightColor [0.85,0.4,0.1];
		_light setLightIR true;
		_light setLightIntensity 10000;
		_dropObjAtt pushback _light;
	};
};

// Wait for the crate fo be on the ground
waitUntil 
{
	sleep 3;
	(((position _dropObj select 2) < 1) OR (velocity _dropObj select 2) == 0);
};

[_dropObj, _dropObjAtt, _crate, _spnChut, _loadoutType, _nvg, _side] spawn 
{
	params ["_dropObj","_dropObjAtt","_crate","_spnChut","_loadoutType","_nvg","_side"];
	
	private _dropPos = position _dropObj;
	private _dropDir = direction _dropObj;
	deleteVehicle _dropObj;
	deleteVehicle (_dropObjAtt select 0);

	_spnObj = createVehicle [_crate, [(_dropPos select 0), (_dropPos select 1), 0.1], [], 0, "CAN_COLLIDE"];
	_spnObj setDir _dropDir;
	deleteVehicle _spnChut;
	[_spnObj, _side, _loadoutType] remoteExec ["LT_fnc_VehicleLoadout", 2];

	// if createdvehicle is a remote designator add ai
	if (_crate == "B_W_Static_Designator_01_F") then 
	{
		createVehicleCrew _spnObj;
		[_spnObj] joinSilent (createGroup _side);
	};

	// Checks if mission is in day or night and attaches the right smoke/light
	if (sunOrMoon == 1) then 
	{
		_smoke = createVehicle ["SmokeShellOrange", [0,0,0], [], 0, ""];
		_smoke attachTo [_spnObj, [0,0,0]];
		uiSleep 10;
		deleteVehicle _smoke;
	} else 
	{
		if (_nvg == 0) then 
		{
			private _light = "#lightpoint" createVehicleLocal (position _dropObj);
			_light attachTo [_dropObj, [0,0,0]];
			_light setLightColor [0.85,0.4,0.1];
			_light setLightAmbient [0.85,0.4,0.1];
			_light setLightUseFlare true;
			_light setLightFlareSize 10;
			_light setLightFlareMaxDistance 10000;
			_light setLightIntensity 10000;
			for "_i" from 0 to 50 do 
			{
				_light setLightIntensity 10000;
				uiSleep 2;
				_light setLightIntensity 1000;
				uiSleep 2;
			};
			deleteVehicle _light;
		} else 
		{
			private _light = "#lightpoint" createVehicleLocal (position _dropObj);
			_light attachTo [_dropObj, [0,0,0]];
			_light setLightColor [0.85,0.4,0.1];
			_light setLightIR true;
			_light setLightIntensity 10000;
			for "_i" from 0 to 50 do 
			{
				_light setLightIntensity 10000;
				uiSleep 2;
				_light setLightIntensity 1000;
				uiSleep 2;
			};
			deleteVehicle _light;
		};
	};
};
