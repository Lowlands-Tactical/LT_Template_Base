/*

File: fn_afkFindHost.sqf
Author: Lowlands Tactical

Description:
Finds the unit an AFK player must be attached to: the leader of his group when the leader is usable (and not the
AFK player himself), otherwise the nearest usable teammate of his group.

Parameters:
_this select 0 = The AFK player (Object)

Example:
_host = [_unit] call LT_fnc_afkFindHost;

Return value:
The host (Object), objNull when there is no one

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_result", "_leader", "_cands"
];

_result = objNull;
_leader = leader (group _unit);

if ((_leader != _unit) && ([_leader] call LT_fnc_afkUsable)) then
{
	_result = _leader;
} else
{
	_cands = (units (group _unit)) select {((_x != _unit) && ([_x] call LT_fnc_afkUsable))};
	if (_cands isNotEqualTo []) then
	{
		_cands = [_cands, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
		_result = _cands select 0;
	};
};

_result
