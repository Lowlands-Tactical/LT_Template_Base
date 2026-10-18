/*

File: fn_afkStart.sqf
Author: Lowlands Tactical

Description:
Server side: a player goes AFK.
The player is hidden (hideObjectGlobal), invulnerable and captive and attached (a little behind) to the leader of his group
(see LT_fnc_afkFindHost and LT_fnc_afkLocal). LT_fnc_afkMonitor keeps him attached to someone who is up.
State of the player (variable LT_afk_state): "" = not AFK, "HOST" (attached), "WAIT" (the whole team is down, stays where he is),
"BACK" (the seconds after coming back). Variable LT_afk_pending is true while he waits for a seat in a vehicle.

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
	"_sender", "_error", "_host"
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
	case ([_unit] call LT_fnc_afkAlone): {_error = "You are alone in your group, there is no one to go AFK with."};
	default {};
};

if (_error != "") exitWith
{
	[_error] remoteExec ["LT_fnc_afkNotify", _sender];
	["Afk", format ["AFK refused for %1: %2", name _unit, _error], 1] call LT_fnc_log;
	false
};

_host = [_unit] call LT_fnc_afkFindHost;

_unit setVariable ["LT_afk_host", _host, true];
_unit setVariable ["LT_afk_pending", false, true];
_unit setVariable ["LT_afk_state", (if (isNull _host) then {"WAIT"} else {"HOST"}), true];
_unit hideObjectGlobal true;
["attach", _unit, _host] remoteExec ["LT_fnc_afkLocal", _unit];

[_unit] spawn LT_fnc_afkMonitor;

["Afk", format ["%1 is AFK, host: %2", name _unit, (if (isNull _host) then {"none"} else {name _host})]] call LT_fnc_log;

true
