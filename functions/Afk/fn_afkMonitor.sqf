/*

File: fn_afkMonitor.sqf
Author: Lowlands Tactical

Description:
Server side loop (started by LT_fnc_afkStart, spawn it) that keeps an AFK player with his team.
Every second: when the unit he is attached to (first the clone) is dead or down, the player is attached to the
nearest usable teammate of his group (no clones, no other AFK players). When there is no one, the player stays
where he is (state "WAIT") until a teammate is up again or respawned.
The loop stops when the player comes back (LT_fnc_afkEnd), dies or disconnects.

Parameters:
_this select 0 = The AFK player (Object)
_this select 1 = The clone (Object)

Example:
[_unit, _clone] spawn LT_fnc_afkMonitor;

Return value:
True (when the loop is done)

*/

params [
	["_unit", objNull, [objNull]],
	["_clone", objNull, [objNull]]
];

// Declare all local variables
private [
	"_usable", "_run", "_state", "_host",
	"_cands", "_new"
];

if (!isServer) exitWith {false};

// A unit is usable as host when it is alive and not down
_usable =
{
	params ["_obj"];
	((!isNull _obj) && (alive _obj) && ((lifeState _obj) != "INCAPACITATED") && (!(_obj getVariable ["ACE_isUnconscious", false])))
};

_run = true;
while {_run} do
{
	sleep 1;

	_state = "";
	if (!isNull _unit) then {_state = _unit getVariable ["LT_afk_state", ""]};

	if ((isNull _unit) || (!alive _unit) || (!isPlayer _unit)) then
	{
		// Player is dead or gone: clean up
		if (!isNull _clone) then {deleteVehicle _clone};
		if ((!isNull _unit) && (alive _unit)) then
		{
			detach _unit;
			_unit hideObjectGlobal false;
			_unit allowDamage true;
			_unit setCaptive false;
			_unit setVariable ["LT_afk_state", "", true];
		};
		["Afk", "AFK player gone or dead, clone removed"] call LT_fnc_log;
		_run = false;
	} else
	{
		if (!(_state in ["CLONE", "HOST", "WAIT"])) then
		{
			// Back or not AFK anymore
			_run = false;
		} else
		{
			_host = _unit getVariable ["LT_afk_host", objNull];

			// Read the state again right before changing anything, so a player who just came back is never attached again
			_state = _unit getVariable ["LT_afk_state", ""];
			if ((!([_host] call _usable)) && (_state in ["CLONE", "HOST", "WAIT"])) then
			{
				_cands = (units (group _unit)) select
				{
					((_x != _unit) && ([_x] call _usable) && (!(_x getVariable ["LT_afk_isClone", false])) && ((_x getVariable ["LT_afk_state", ""]) == ""))
				};

				if (_cands isEqualTo []) then
				{
					// Whole team is down: wait where we are
					if (_state != "WAIT") then
					{
						_unit setVariable ["LT_afk_state", "WAIT", true];
						_unit setVariable ["LT_afk_host", objNull, true];
						["free", _unit] remoteExec ["LT_fnc_afkLocal", _unit];
						["Afk", format ["%1 waits: the whole team is down", name _unit]] call LT_fnc_log;
					};
				} else
				{
					_cands = [_cands, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
					_new = _cands select 0;
					_unit setVariable ["LT_afk_state", "HOST", true];
					_unit setVariable ["LT_afk_host", _new, true];
					["attach", _unit, _new] remoteExec ["LT_fnc_afkLocal", _unit];
					["Afk", format ["%1 is attached to %2", name _unit, name _new]] call LT_fnc_log;
				};
			};
		};
	};
};

true
