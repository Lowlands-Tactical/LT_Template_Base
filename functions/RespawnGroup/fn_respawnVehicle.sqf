/*

File: fn_respawnVehicle.sqf
Author: Lowlands Tactical

Description:
Marks a vehicle as a respawn point for "Deploy to group" and for the normal respawn menu
(BIS_fnc_addRespawnPosition), or removes the mark again.
The Eden attributes "Respawn point for players" and "Respawn point name" set the same variables.
The vehicle respawn (FRED_fnc_vehicleMonitor) calls this function for the new vehicle, so a
vehicle that respawns stays a respawn point. Can also be used on vehicles that are spawned by a script.
The BIS respawn position is only added/removed on the server; the variables are set on every machine.

Parameters:
_this select 0 = Vehicle (Object)
_this select 1 = Is respawn point (Boolean, default true)
_this select 2 = Name in the deploy list (String, default "" = name of the vehicle)

Example:
[_vehicle, true, "Alpha MRAP"] call LT_fnc_respawnVehicle;

Return value:
True (if set), false (if there is no vehicle)

*/

params [
	["_vehicle", objNull, [objNull]],
	["_isPoint", true, [true, 0]],
	["_name", "", [""]]
];

// Declare all local variables
private [
	"_flag", "_side", "_id"
];

if (isNull _vehicle) exitWith {false};

_flag = (_isPoint isEqualTo true) || {_isPoint isEqualTo 1};

_vehicle setVariable ["LT_veh_respawnPoint", _flag, true];
_vehicle setVariable ["LT_veh_respawnName", _name, true];

if (isServer) then
{
	// Remove the old position first, so calling this twice does not give a double entry
	_id = _vehicle getVariable ["LT_veh_respawnId", []];
	if (_id isNotEqualTo []) then
	{
		_id call BIS_fnc_removeRespawnPosition;
		_vehicle setVariable ["LT_veh_respawnId", []];
	};

	if (_flag) then
	{
		_side = switch (_vehicle getVariable ["LT_veh_side", "WEST"]) do
		{
			case "EAST": {east};
			case "GUER": {resistance};
			default {west};
		};
		_id = [_side, _vehicle, _name] call BIS_fnc_addRespawnPosition;
		_vehicle setVariable ["LT_veh_respawnId", _id];
	};
};

["RespawnVehicle", format ["%1 respawn point = %2 (%3)", typeOf _vehicle, _flag, _name]] call LT_fnc_log;

true
