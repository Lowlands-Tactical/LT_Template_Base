/*

File: fn_afkJoinGroup.sqf
Author: Lowlands Tactical

Description:
Group changes for the AFK system. Must run where the group is local, so the server sends it
to the owner of the group (groupOwner).

Modes:
"join" = Put the clone in the group and make it run (forceSpeed on fast, so it keeps up with the group).
         If the AFK player is the leader, a player (or the clone) takes over the lead
"lead" = Give the lead back to the player (used when he comes back and was leader before)

Parameters:
_this select 0 = Mode (String)
_this select 1 = Group (Group)
_this select 2 = The AFK player (Object)
_this select 3 = The clone (Object, only for "join")

Example:
["join", _group, _unit, _clone] remoteExec ["LT_fnc_afkJoinGroup", groupOwner _group];

Return value:
True (if done), false (if not)

*/

params [
	["_mode", "join", [""]],
	["_group", grpNull, [grpNull]],
	["_unit", objNull, [objNull]],
	["_clone", objNull, [objNull]]
];

// Declare all local variables
private [
	"_result", "_others", "_players"
];

_result = false;

if ((!isNull _group) && (local _group)) then
{
	switch (_mode) do
	{
		case "join":
		{
			[_clone] joinSilent _group;

			// The clone becomes local to the owner of the group: wait for that, then make it run
			[_clone] spawn
			{
				params ["_clone"];
				private ["_timeout"];
				_timeout = time + 10;
				waitUntil {sleep 0.2; ((local _clone) || (time > _timeout))};
				if (local _clone) then
				{
					if (isForcedWalk _clone) then {_clone forceWalk false};
					_clone forceSpeed (_clone getSpeed "FAST");
				};
			};

			if ((leader _group) == _unit) then
			{
				_others = (units _group) select {((alive _x) && (_x != _unit) && (_x != _clone))};
				_players = _others select {isPlayer _x};
				if (_players isNotEqualTo []) then
				{
					_group selectLeader (_players select 0);
				} else
				{
					_group selectLeader _clone;
				};
			};
			_result = true;
		};

		case "lead":
		{
			if ((alive _unit) && ((leader _group) != _unit)) then {_group selectLeader _unit};
			_result = true;
		};

		default
		{
			["Afk", format ["afkJoinGroup: unknown mode: %1", _mode], 1] call LT_fnc_log;
		};
	};
};

_result
