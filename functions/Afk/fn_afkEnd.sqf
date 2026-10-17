/*

File: fn_afkEnd.sqf
Author: Lowlands Tactical

Description:
Server side: a player comes back from AFK.
The player is visible again and placed next to the unit he was attached to. For a delay (default 5 seconds, variable
LT_afk_backDelay) he can walk around but is invulnerable, so he can orientate and move to cover.
After the delay the clone is removed and the player is a normal player again.
If the player was group leader before he goes AFK, he gets the lead back.

Parameters:
_this select 0 = The player (Object)

Example:
[player] remoteExec ["LT_fnc_afkEnd", 2];

Return value:
True (if done), false (if refused)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_sender", "_error", "_delay", "_host", "_clone"
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
	case (!alive _unit): {_error = "You are dead."};
	case (!((_unit getVariable ["LT_afk_state", ""]) in ["CLONE", "HOST", "WAIT"])): {_error = "You are not AFK."};
	default {};
};

if (_error != "") exitWith
{
	[_error] remoteExec ["LT_fnc_afkNotify", _sender];
	["Afk", format ["Back refused for %1: %2", name _unit, _error], 1] call LT_fnc_log;
	false
};

_delay = missionNamespace getVariable ["LT_afk_backDelay", 5];
_host = _unit getVariable ["LT_afk_host", objNull];
_clone = _unit getVariable ["LT_afk_clone", objNull];

_unit setVariable ["LT_afk_state", "BACK", true];
_unit setVariable ["LT_afk_backUntil", serverTime + _delay, true];
_unit hideObjectGlobal false;
["release", _unit, _host] remoteExec ["LT_fnc_afkLocal", _unit];

if ((_unit getVariable ["LT_afk_wasLeader", false]) && (!isNull _clone)) then
{
	["lead", group _unit, _unit] remoteExec ["LT_fnc_afkJoinGroup", groupOwner (group _unit)];
};

// After the delay: remove the clone and clear the state
[_unit, _clone, _delay] spawn
{
	params ["_unit", "_clone", "_delay"];
	sleep (_delay + 0.5);
	if (!isNull _clone) then {deleteVehicle _clone};
	if (!isNull _unit) then
	{
		_unit setVariable ["LT_afk_state", "", true];
		_unit setVariable ["LT_afk_host", objNull, true];
		_unit setVariable ["LT_afk_clone", objNull, true];
		_unit setVariable ["LT_afk_wasLeader", false, true];
	};
};

["Afk", format ["%1 is back from AFK", name _unit]] call LT_fnc_log;

true
