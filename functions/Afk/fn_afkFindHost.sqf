/*

File: fn_afkFindHost.sqf
Author: Lowlands Tactical

Description:
Finds the unit an AFK player must be attached to: the nearest usable player of the same side (side of his group, so a captive
AFK player does not count as civilian) who is within the radius. The group does not matter.
Usable means: a living player who is not down and not AFK (see LT_fnc_afkUsable).
The default radius is 7 m, a mission can change it with the variable LT_afk_radius.

Parameters:
_this select 0 = The AFK player (Object)
_this select 1 = Radius in meters (Number, default LT_afk_radius or 7)

Example:
_host = [_unit] call LT_fnc_afkFindHost;

Return value:
The host (Object), objNull when there is no one

*/

params [
	["_unit", objNull, [objNull]],
	["_radius", (missionNamespace getVariable ["LT_afk_radius", 7]), [0]]
];

// Declare all local variables
private [
	"_result", "_side", "_cands"
];

_result = objNull;

if (!isNull _unit) then
{
	_side = side (group _unit);
	_cands = allPlayers select {((_x != _unit) && ((side (group _x)) == _side) && ((_unit distance _x) <= _radius) && ([_x] call LT_fnc_afkUsable))};
	if (_cands isNotEqualTo []) then
	{
		_cands = [_cands, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
		_result = _cands select 0;
	};
};

_result
