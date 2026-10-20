/*

File: fn_respawnGroupRequest.sqf
Author: Lowlands Tactical

Description:
Server side check of a "Deploy to group" request. Checks that the request comes from the
player itself, that the deploy window is open, that the player did not deploy yet and that
the target is still valid (same checks as the menu, enemies and free seats). If everything is
fine the player gets the order to move (LT_fnc_respawnGroupMove), otherwise a message.

Parameters:
_this select 0 = Player that wants to deploy (Object)
_this select 1 = Target: a unit or a vehicle (Object)

Example:
[player, _target] remoteExec ["LT_fnc_respawnGroupRequest", 2];

Return value:
True (if approved), false (if denied)

*/

params [
	["_unit", objNull, [objNull]],
	["_target", objNull, [objNull]]
];

// Declare all local variables
private [
	"_sender", "_deny", "_targets", "_index",
	"_deployMode"
];

if (!isServer) exitWith {false};

// remoteExecutedOwner is 0 when the server player calls this function itself
_sender = remoteExecutedOwner;
if (_sender == 0) then {_sender = 2;};

_deny =
{
	params ["_text"];
	[objNull, "DENY", _text] remoteExec ["LT_fnc_respawnGroupMove", _sender];
	["RespawnGroup", format ["Denied for %1: %2", name _unit, _text], 1] call LT_fnc_log;
	false
};

if ((isNull _unit) || (isNull _target)) exitWith {["Invalid request."] call _deny};
if ((owner _unit) != _sender) exitWith {["The request does not come from the player."] call _deny};
if (("lt_respawngroup" call BIS_fnc_getParamValue) != 1) exitWith {["Deploy to group is turned off."] call _deny};
if (!alive _unit) exitWith {["You are dead."] call _deny};
if (serverTime >= (_unit getVariable ["LT_respawnGroup_until", 0])) exitWith {["The deploy time is over."] call _deny};
if (_unit getVariable ["LT_respawnGroup_used", false]) exitWith {["You already deployed."] call _deny};

_targets = [_unit] call LT_fnc_respawnGroupTargets;
_index = _targets findIf {(_x select 1) == _target};
if (_index < 0) exitWith {["That target is no longer available."] call _deny};

(_targets select _index) params ["_cat", "_obj", "_label", "_status", "_note"];
if (_status == 2) exitWith {[format ["You can't deploy to %1: %2.", _label, _note]] call _deny};

_unit setVariable ["LT_respawnGroup_used", true, true];
_deployMode = if (("lt_respawngroup_mode" call BIS_fnc_getParamValue) == 1) then {"PARA"} else {"NEAR"};
[_target, _deployMode, _label] remoteExec ["LT_fnc_respawnGroupMove", _sender];
["RespawnGroup", format ["%1 deploys to %2 (%3)", name _unit, _label, _deployMode]] call LT_fnc_log;

true
