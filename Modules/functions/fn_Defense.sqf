/*

File: fn_Defense.sqf
Author: Brainless_Ben

Description:
Function for the Defense module. Spawns waves of units/vehicles/apcs/tanks of a faction that attack a defense position.
All spawn logic is in LT_fnc_spawnWaves, this function only passes the module on.

Return value:
True (if all waves succesfully spawned)

*/

params [
	["_logic", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if !(_activated) exitWith {false};

["Defense", _logic] call LT_fnc_spawnWaves
