/*

File: fn_teleportGroup.sqf
Author: Brainless_Ben

Description:
Function to start the supply drop.

Parameters:
_this select 0 = position

Example:
[_pos] call LT_fnc_teleportGroup

*/

// Teleport your group to a position on the map
private ["_count"];
params ["_pos", [0,0,0], [[0,0,0]]];

player setPos _pos;
_count = 0;
{
  if (_x != player) then {
    _x setPos ( [player, 4, (360/(count (units player)) * _count)] call BIS_fnc_relPos );
    _count = _count + 1;
  };
} foreach (units player);
