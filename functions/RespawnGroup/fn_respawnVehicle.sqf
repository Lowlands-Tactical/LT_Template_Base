/*

File: fn_respawnVehicle.sqf
Author: Lowlands Tactical

Description:
Marks a vehicle as a respawn point for "Deploy to group" (or removes the mark).
The Eden attributes "Respawn point for players" and "Respawn point name" set the same variables.
The vehicle respawn (FRED_fnc_vehicleMonitor) calls this function for the new vehicle, so a
vehicle that respawns stays a respawn point. Can also be used on vehicles that are spawned by a script.

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
	"_flag"
];

if (isNull _vehicle) exitWith {false};

_flag = (_isPoint isEqualTo true) || {_isPoint isEqualTo 1};

_vehicle setVariable ["LT_veh_respawnPoint", _flag, true];
_vehicle setVariable ["LT_veh_respawnName", _name, true];
_side = switch (_vehicle getVariable ["LT_veh_side","WEST"]) do
{
	case"EAST":{east};
	case"GUER":{resistance};
	default{west};
};

[_side,_vehicle,_name] remoteExec ["BIS_fnc_addRespawnPosition",0];

["RespawnVehicle", format ["%1 respawn point = %2 (%3)", typeOf _vehicle, _flag, _name]] call LT_fnc_log;

true
