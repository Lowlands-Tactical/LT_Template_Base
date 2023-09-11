/*

File: fn_resetMaxLoad.sqf
Author: Brainless_Ben

Description:
Reset loadout with desired load

*/

if !(isServer) exitWith {};

_objectContainer = param [0, objNull, [objNull]];
_loadAmount = param [1, 300, [300]];

_objectContainer setMaxLoad _loadAmount;
