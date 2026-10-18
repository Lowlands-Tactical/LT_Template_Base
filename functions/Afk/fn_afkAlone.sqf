/*

File: fn_afkAlone.sqf
Author: Lowlands Tactical

Description:
Checks if a unit is alone in his group (no other living unit, player or AI). Going AFK is not possible then,
because there is no one to attach to.

Parameters:
_this select 0 = Unit (Object)

Example:
_alone = [player] call LT_fnc_afkAlone;

Return value:
True (if alone), false (if not)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_result"
];

_result = ((units (group _unit)) select {((_x != _unit) && (alive _x))}) isEqualTo [];

_result
