/*

File: fn_afkMonitor.sqf
Author: Lowlands Tactical

Description:
Server side loop (started by LT_fnc_afkStart, spawn it) that keeps an AFK player with a player of his side. Every second:
- When the host is dead, down, AFK himself or gone, the player is attached to a new host: the nearest usable player of
  his side within range (see LT_fnc_afkFindHost). The group does not matter.
- When there is no such player the player stays where he is (state "WAIT") until one comes within range.
- When the player asked to come back but the host sits in a vehicle without a free seat (LT_afk_pending), it waits until the
  host has left the vehicle and then lets the player come back (LT_fnc_afkRelease). Not when a seat becomes free, because
  then the host has usually just arrived and gets out.
The loop stops when the player comes back, dies or disconnects.

Parameters:
_this select 0 = The AFK player (Object)

Example:
[_unit] spawn LT_fnc_afkMonitor;

Return value:
True (when the loop is done)

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_run", "_state", "_host", "_best",
	"_switch"
];

if (!isServer) exitWith {false};

_run = true;
while {_run} do
{
	sleep 1;

	_state = "";
	if (!isNull _unit) then {_state = _unit getVariable ["LT_afk_state", ""]};

	if ((isNull _unit) || (!alive _unit) || (!isPlayer _unit)) then
	{
		// Player is dead or gone: clean up
		if ((!isNull _unit) && (alive _unit)) then
		{
			detach _unit;
			_unit hideObjectGlobal false;
			_unit allowDamage true;
			_unit setCaptive false;
			_unit setVariable ["LT_afk_state", "", true];
			_unit setVariable ["LT_afk_pending", false, true];
		};
		["Afk", "AFK player gone or dead"] call LT_fnc_log;
		_run = false;
	} else
	{
		if (!(_state in ["HOST", "WAIT"])) then
		{
			// Back or not AFK anymore
			_run = false;
		} else
		{
			_host = _unit getVariable ["LT_afk_host", objNull];
			_best = objNull;

			// New host only when the current one is not usable anymore (also the case while waiting without a host)
			_switch = (!([_host] call LT_fnc_afkUsable));
			if (_switch) then {_best = [_unit] call LT_fnc_afkFindHost};

			// Read the state again right before changing anything, so a player who just came back is never attached again
			_state = _unit getVariable ["LT_afk_state", ""];
			if (_switch && (_state in ["HOST", "WAIT"])) then
			{
				if (isNull _best) then
				{
					// No usable player in range: wait where we are
					if (_state != "WAIT") then
					{
						_unit setVariable ["LT_afk_state", "WAIT", true];
						_unit setVariable ["LT_afk_host", objNull, true];
						["free", _unit] remoteExec ["LT_fnc_afkLocal", _unit];
						["Afk", format ["%1 waits: no usable player in range", name _unit]] call LT_fnc_log;
					};
				} else
				{
					_unit setVariable ["LT_afk_state", "HOST", true];
					_unit setVariable ["LT_afk_host", _best, true];
					["attach", _unit, _best] remoteExec ["LT_fnc_afkLocal", _unit];
					["Afk", format ["%1 is attached to %2", name _unit, name _best]] call LT_fnc_log;
				};
			};

			// Waiting for the host to leave his vehicle (or for no host at all)
			if (_unit getVariable ["LT_afk_pending", false]) then
			{
				_host = _unit getVariable ["LT_afk_host", objNull];
				if ((isNull _host) || (isNull objectParent _host)) then
				{
					[_unit, objNull] call LT_fnc_afkRelease;
					_run = false;
				};
			};
		};
	};
};

true
