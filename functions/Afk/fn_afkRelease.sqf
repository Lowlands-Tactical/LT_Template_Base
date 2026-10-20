/*

File: fn_afkRelease.sqf
Author: Lowlands Tactical

Description:
Server side (internal, not remoteExec'd): the AFK player really comes back.
The player is visible again and placed next to his host, or in the vehicle when one is given. For a delay (default 5 seconds,
variable LT_afk_backDelay) he can walk around but is invulnerable, so he can orientate and move to cover (see LT_fnc_afkLocal).
After the delay the AFK state is cleared.

Parameters:
_this select 0 = The player (Object)
_this select 1 = Vehicle to put the player in (Object, objNull = next to the host)

Example:
[_unit, objNull] call LT_fnc_afkRelease;

Return value:
True (if done)

*/

params [
	["_unit", objNull, [objNull]],
	["_vehicle", objNull, [objNull]]
];

// Declare all local variables
private [
	"_delay", "_host"
];

if ((!isServer) || (isNull _unit)) exitWith {false};

_delay = missionNamespace getVariable ["LT_afk_backDelay", 5];
_host = _unit getVariable ["LT_afk_host", objNull];

_unit setVariable ["LT_afk_state", "BACK", true];
_unit setVariable ["LT_afk_pending", false, true];
_unit setVariable ["LT_afk_backUntil", serverTime + _delay, true];
_unit hideObjectGlobal false;
["release", _unit, _host, _vehicle] remoteExec ["LT_fnc_afkLocal", _unit];

// After the delay: clear the state
[_unit, _delay] spawn
{
	params ["_unit", "_delay"];
	sleep (_delay + 0.5);
	if (!isNull _unit) then
	{
		_unit setVariable ["LT_afk_state", "", true];
		_unit setVariable ["LT_afk_host", objNull, true];
	};
};

["Afk", format ["%1 is back from AFK", name _unit]] call LT_fnc_log;

true
