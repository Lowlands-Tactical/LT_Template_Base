/*

File: fn_afkEnd.sqf
Author: Lowlands Tactical

Description:
Server side: a player wants to come back from AFK.
- Host on foot (or no host): the player comes back right away (LT_fnc_afkRelease).
- Host in a vehicle with a free seat: the player is put in the vehicle.
- Host in a vehicle without a free seat (or locked): the player keeps waiting. LT_fnc_afkMonitor lets him come back as soon
  as the host has left the vehicle.

Parameters:
_this select 0 = The player (Object)

Example:
[player] remoteExec ["LT_fnc_afkEnd", 2];

Return value:
True (if handled), false (if refused)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_sender", "_error", "_host", "_vehicle",
	"_seat"
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
	case (!((_unit getVariable ["LT_afk_state", ""]) in ["HOST", "WAIT"])): {_error = "You are not AFK."};
	case (_unit getVariable ["LT_afk_pending", false]): {_error = "You are waiting until your host leaves the vehicle."};
	default {};
};

if (_error != "") exitWith
{
	[_error] remoteExec ["LT_fnc_afkNotify", _sender];
	["Afk", format ["Back refused for %1: %2", name _unit, _error], 1] call LT_fnc_log;
	false
};

_host = _unit getVariable ["LT_afk_host", objNull];
_vehicle = objNull;
if ((!isNull _host) && (!isNull objectParent _host)) then {_vehicle = objectParent _host};

if (isNull _vehicle) then
{
	[_unit, objNull] call LT_fnc_afkRelease;
} else
{
	_seat = (((count ((fullCrew [_vehicle, "", true]) select {isNull (_x select 0)})) > 0) && ((locked _vehicle) < 2));
	if (_seat) then
	{
		[_unit, _vehicle] call LT_fnc_afkRelease;
	} else
	{
		_unit setVariable ["LT_afk_pending", true, true];
		["No free seat in the vehicle. You come back when your host leaves it."] remoteExec ["LT_fnc_afkNotify", _sender];
		["Afk", format ["%1 waits for the vehicle of %2", name _unit, name _host]] call LT_fnc_log;
	};
};

true
