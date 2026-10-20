/*

File: fn_afkUsable.sqf
Author: Lowlands Tactical

Description:
Checks if a unit can be the host of an AFK player: it exists, is a player, is alive, is not down (unconscious) and is not AFK itself.

Parameters:
_this select 0 = Unit (Object)

Example:
_ok = [_unit] call LT_fnc_afkUsable;

Return value:
True (if usable), false (if not)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_result"
];

_result = false;

if (!isNull _unit) then
{
	_result = ((isPlayer _unit) && (alive _unit) && ((lifeState _unit) != "INCAPACITATED") && (!(_unit getVariable ["ACE_isUnconscious", false])) && ((_unit getVariable ["LT_afk_state", ""]) == ""));
};

_result
