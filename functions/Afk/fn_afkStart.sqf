/*

File: fn_afkStart.sqf
Author: Lowlands Tactical

Description:
Server side: a player goes AFK.
- An AI clone with the same loadout (without ACRE radios) and the name "CLONE <name>" is created in the group of the player.
- The player is hidden and attached to the clone (see LT_fnc_afkLocal).
- LT_fnc_afkMonitor watches the clone. When the clone is down or dead the player is attached to the nearest
  teammate of his group. When the whole team is down the player waits until someone is up or respawned.
State of the player (variable LT_afk_state): "" = not AFK, "CLONE", "HOST" (with a teammate), "WAIT", "BACK" (the 5 seconds after coming back).

Parameters:
_this select 0 = The player (Object)

Example:
[player] remoteExec ["LT_fnc_afkStart", 2];

Return value:
True (if started), false (if refused)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_sender", "_error", "_group", "_wasLeader",
	"_cloneGroup", "_clone", "_name", "_loadout"
];

if (!isServer) exitWith {false};

// remoteExecutedOwner is 0 when the server player calls this function itself
_sender = remoteExecutedOwner;
if (_sender == 0) then {_sender = 2};

_error = "";
switch (true) do
{
	case (isNull _unit): {_error = "Invalid request."};
	case ((owner _unit) != _sender): {_error = "The request does not come from the player."};
	case (("lt_afk" call BIS_fnc_getParamValue) != 1): {_error = "AFK is turned off."};
	case (!alive _unit): {_error = "You are dead."};
	case ((_unit getVariable ["LT_afk_state", ""]) != ""): {_error = "You are already AFK."};
	case (!isNull objectParent _unit): {_error = "Leave the vehicle first."};
	case (((lifeState _unit) == "INCAPACITATED") || (_unit getVariable ["ACE_isUnconscious", false])): {_error = "You can't go AFK while you are unconscious."};
	default {};
};

if (_error != "") exitWith
{
	[_error] remoteExec ["LT_fnc_afkNotify", _sender];
	["Afk", format ["AFK refused for %1: %2", name _unit, _error], 1] call LT_fnc_log;
	false
};

_group = group _unit;
_wasLeader = ((leader _group) == _unit);

// The clone is created in its own group on the server and joins the group of the player where that group is local
_cloneGroup = createGroup [side _group, true];
_clone = _cloneGroup createUnit [typeOf _unit, getPosATL _unit, [], 0, "NONE"];
_clone setDir (getDir _unit);
_loadout = getUnitLoadout _unit;
_clone setUnitLoadout _loadout;

// ACRE radios have a unique id, so the clone does not get them
{_clone removeItem _x} forEach ((items _clone) select {((_x select [0, 5]) == "ACRE_")});

_clone setFace (face _unit);
_clone setRank (rank _unit);
_name = format ["CLONE %1", name _unit];
[netId _clone, _name] remoteExec ["LT_fnc_afkSetName", 0, _clone];

_clone setVariable ["LT_afk_isClone", true, true];
_clone setVariable ["LT_afk_owner", _unit, true];
["join", _group, _unit, _clone] remoteExec ["LT_fnc_afkJoinGroup", groupOwner _group];

_unit setVariable ["LT_afk_clone", _clone, true];
_unit setVariable ["LT_afk_host", _clone, true];
_unit setVariable ["LT_afk_wasLeader", _wasLeader, true];
_unit setVariable ["LT_afk_state", "CLONE", true];
_unit hideObjectGlobal true;
["attach", _unit, _clone] remoteExec ["LT_fnc_afkLocal", _unit];

[_unit, _clone] spawn LT_fnc_afkMonitor;

["Afk", format ["%1 is AFK, clone: %2", name _unit, _name]] call LT_fnc_log;

true
