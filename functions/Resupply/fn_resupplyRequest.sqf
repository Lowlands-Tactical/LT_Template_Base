/*

File: fn_ResupplyRequest.sqf
Author: Brainless_Ben

Description:
Function to start the supply drop.

Parameters:
_this select 0 = Position from onMapSingleClick
_this select 1 = side 
_this select 2 = String Vehicle
_this select 3 = String Crate
_this select 4 = String Loadout
_this select 5 = String Loadout
_this select 6 = String Loadout
_this select 7 = boolean
_this select 8 = boolean

[[x,y,z], side, "Type Vehicle", "Type Crate", "Type Loadout 1", "Type Loadout 2", "Type Loadout 3", boolean, boolean] LT_fnc_ResupplyRequest.sqf

Example:
[[500,500,0], side Player, "C_Plane_Civil_01_F", "B_supplyCrate_F", "Crate Large", "King Quad", "None", false, true] LT_fnc_ResupplyRequest.sqf

Returns:
[_spnVeh,_spnGrp,_pos,_load1,_load2,_load3]

*/

if (!isServer) exitWith {Diag_log "[LT] (Resupply) You are not server";};

params [
	["_pos", [0,0,0], [[0,0,0]]],
	["_side", west, [west]],
	["_vehicle", "", [""]],
	["_crate", "", [""]],
	["_load1", "Empty", ["Empty"]],
	["_load2", "Empty", ["Empty"]],
	["_load3", "Empty", ["Empty"]],
	["_shift", false, [false]],
	["_alt", false, [false]]
];

// Check if vehicle and crate are defined
if (_vehicle == "" OR _crate == "") exitWith 
{
	Diag_log "[LT] (Resupply) Vehicle or Crate is Nil";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (Resupply) Vehicle or Crate is Nil";
	};
};

// Debug messages
Diag_log format["[LT] (Resupply) Loadoutside= %1", _side];
Diag_log format["[LT] (Resupply) Vehicle= %1 Crate= %2", _vehicle, _crate];
Diag_log format["[LT] (Resupply) Lo_1= %1 Lo_2= %2 Lo_3= %3", _load1, _load2, _load3];
Diag_log format["[LT] (Resupply) ShiftPress= %1 AltPress= %2", _shift, _alt];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (Resupply) Vehicle= %1 Crate= %2", _vehicle, _crate];
	systemChat format["[LT] (Resupply) Lo1= %1 Lo2= %2 Lo3= %3", _load1, _load2, _load3];
	systemChat format["[LT] (Resupply) ShiftPress= %1 AltPress= %2", _shift, _alt];
};

// Define waypoints
_wpHeight = 350;
_wpHeightVeh = 900;
_wpStart = [_pos select 0, _pos select 1, _wpHeightVeh];
_wpNear = [_pos select 0, _pos select 1, _wpHeight];
_wpDrop1 = [_pos select 0, _pos select 1, _wpHeight];
_wpDrop2 = [_pos select 0, _pos select 1, _wpHeight];
_wpDrop3 = [_pos select 0, _pos select 1, _wpHeight];
_wpAfter = [_pos select 0, _pos select 1, _wpHeight];
_wpReturn = [_pos select 0, _pos select 1, _wpHeight];
_wpEnd = [_pos select 0, _pos select 1, _wpHeight];

if (_shift) then 
{
	if (_alt) then 
	{
		// true-true
		Diag_log "[LT] (Resupply) East > West";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Resupply) East > West";
		};
		_wpStart = [(_pos select 0) + 4000, (_pos select 1), _wpHeightVeh];
		_wpNear = [(_pos select 0) + 100, (_pos select 1), _wpHeight];
		_wpDrop1 = [(_pos select 0) - 5, (_pos select 1), _wpHeight];
		_wpDrop2 = [(_pos select 0) - 15, (_pos select 1), _wpHeight];
		_wpDrop3 = [(_pos select 0) - 25, (_pos select 1), _wpHeight];
		_wpAfter = [(_pos select 0) - 500, (_pos select 1) - 50, _wpHeight];
		_wpReturn = [(_pos select 0) + 1000, (_pos select 1) - 50, _wpHeight];
		_wpEnd = [(_pos select 0) + 4000, (_pos select 1), _wpHeight];
	} else 
	{
		// true-false
		Diag_log "[LT] (Resupply) West > East";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Resupply) West > East";
		};
		_wpStart = [(_pos select 0) - 4000, (_pos select 1), _wpHeightVeh];
		_wpNear = [(_pos select 0) - 100, (_pos select 1), _wpHeight];
		_wpDrop1 = [(_pos select 0) + 5, (_pos select 1), _wpHeight];
		_wpDrop2 = [(_pos select 0) + 15, (_pos select 1), _wpHeight];
		_wpDrop3 = [(_pos select 0) + 25, (_pos select 1), _wpHeight];
		_wpAfter = [(_pos select 0) + 500, (_pos select 1) + 50, _wpHeight];
		_wpReturn = [(_pos select 0) - 1000, (_pos select 1) + 50, _wpHeight];
		_wpEnd = [(_pos select 0) - 4000, (_pos select 1), _wpHeight];
	};
} else 
{
	if (_alt) then 
	{
		// false-true
		Diag_log "[LT] (Resupply) North > South";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Resupply) North > South";
		};
		_wpStart = [(_pos select 0), (_pos select 1) + 4000, _wpHeightVeh];
		_wpNear = [(_pos select 0), (_pos select 1) + 100, _wpHeight];
		_wpDrop1 = [(_pos select 0), (_pos select 1) - 5, _wpHeight];
		_wpDrop2 = [(_pos select 0), (_pos select 1) - 15, _wpHeight];
		_wpDrop3 = [(_pos select 0), (_pos select 1) - 25, _wpHeight];
		_wpAfter = [(_pos select 0) - 50, (_pos select 1) - 500, _wpHeight];
		_wpReturn = [(_pos select 0) - 50, (_pos select 1) + 1000, _wpHeight];
		_wpEnd = [(_pos select 0), (_pos select 1) + 4000, _wpHeight];
	} else 
	{
		// false-false
		Diag_log "[LT] (Resupply) South > North";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Resupply) South > North";
		};
		_wpStart = [(_pos select 0), (_pos select 1) - 4000, _wpHeightVeh];
		_wpNear = [(_pos select 0), (_pos select 1) - 100, _wpHeight];
		_wpDrop1 = [(_pos select 0), (_pos select 1) + 5, _wpHeight];
		_wpDrop2 = [(_pos select 0), (_pos select 1) + 15, _wpHeight];
		_wpDrop3 = [(_pos select 0), (_pos select 1) + 25, _wpHeight];
		_wpAfter = [(_pos select 0) + 50, (_pos select 1) + 500, _wpHeight];
		_wpReturn = [(_pos select 0) + 50, (_pos select 1) - 1000, _wpHeight];
		_wpEnd = [(_pos select 0), (_pos select 1) - 4000, _wpHeight];
	};
};
_waypoints = [_wpNear, _wpDrop1, _wpDrop2, _wpDrop3, _wpAfter, _wpReturn, _wpEnd];

// Spawn Vehicle and set direction and AI settings
private _vehDir = _wpStart getDir _wpNear;
private _spnData = [_wpStart, _vehDir, _vehicle, civilian] call BIS_fnc_spawnVehicle;
_spnVeh = _spnData select 0;
_spnGrp = _spnData select 2;
_spnVeh setVehiclePosition [_wpStart, [], 0, "FLY"];
_spnVeh setPosATL _wpStart;
_spnGrp setFormDir _vehDir;
_spnVeh setDir _vehDir;
_spnVeh disableAI "TARGET";
_spnVeh disableAI "AUTOTARGET";
_spnVeh setCaptive true;
_spnVeh setVehicleAmmo 0;
{_x allowFleeing 0}forEach units _spnGrp;
_spnVeh lock false;
_spnVeh flyInHeight _wpHeight;
_spnGrp setVariable ["LT_Resupply_Crate", _crate];
_spnGrp setVariable ["LT_Resupply_Chute", "B_Parachute_02_F"];
_spnGrp setVariable ["LT_veh_side", _side];

// Add event handler to notifi if the respawn vehicle is destroyed
_spnVeh addMPEventHandler 
[
	"MPKilled", 
	{
		lt_resupply = 0;
		publicVariable "lt_resupply";
		Diag_log "[LT] (Resupply) Resupply vehicle has crashed";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Resupply) Resupply vehicle has crashed";
		};
		hint "Resupply vehicle has crashed";
	}
];

// Add waypoints and supplydrop script and delete script to some waypoints
for [{_idx = 0},{_idx < 7},{_idx = _idx + 1}] do
{
	_spnGrp addWaypoint [_waypoints select _idx, 0];
	[_spnGrp, _idx + 1] setWaypointType "MOVE";

	if (_idx == 1) then 
	{
		[_spnGrp, _idx + 1] setWaypointStatements ["true","[this,'"+_load3+"'] spawn LT_fnc_ResupplyDrop"];
		[_spnGrp, _idx + 1] setWaypointTimeout [0.5,0.5,0.5];
	};
	if (_idx == 2) then 
	{
		[_spnGrp, _idx + 1] setWaypointStatements ["true","[this,'"+_load2+"'] spawn LT_fnc_ResupplyDrop"];
		[_spnGrp, _idx + 1] setWaypointTimeout [0.5,0.5,0.5];
	};
	if (_idx == 3) then 
	{
		[_spnGrp, _idx + 1] setWaypointStatements ["true","[this,'"+_load1+"'] spawn LT_fnc_ResupplyDrop"];
		[_spnGrp, _idx + 1] setWaypointTimeout [0.5,0.5,0.5];
	};
	if (_idx == 6) then 
	{
		[_spnGrp, _idx + 1] setWaypointStatements ["true", "[(group this)] call LT_fnc_deleteUnits; lt_resupply = 0; publicVariable 'lt_resupply'"];
	};
};

[_spnVeh,_pos,_load1,_load2,_load3];
