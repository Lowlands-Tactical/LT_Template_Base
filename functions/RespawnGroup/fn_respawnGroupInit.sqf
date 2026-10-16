/*

File: fn_respawnGroupInit.sqf
Author: Lowlands Tactical

Description:
Sets up "Deploy to group".
"register" adds the ACE self interaction action "Deploy to group" for all units (call once on the client).
"unit" starts the deploy window for a unit that just respawned (call from Respawn.sqf).
The window ends when the time (parameter lt_respawngroup_time) is over or after one deploy.
Nothing happens when the parameter lt_respawngroup is off or when PermaDeath is on.

Parameters:
_this select 0 = Mode (String): "register" or "unit" (default)
_this select 1 = Unit that respawned (Object, only for "unit")

Example:
["register"] call LT_fnc_respawnGroupInit;
["unit", _unit] call LT_fnc_respawnGroupInit;

Return value:
True (if done), false (if not needed)

*/

params [
	["_mode", "unit", [""]],
	["_unit", objNull, [objNull]]
];

// Declare all local variables
private [
	"_action", "_time"
];

if (!hasInterface) exitWith {false};

if (_mode == "register") exitWith
{
	_action = ["lt_respawngroup_deploy", "Deploy to group", "\lt_template_base\logos\lowtac.paa",
		{["open"] call LT_fnc_respawnGroupMenu;},
		{
			params ["_target", "_player"];
			((alive _player) &&
			(isNull objectParent _player) &&
			(serverTime < (_player getVariable ["LT_respawnGroup_until", 0])) &&
			(!(_player getVariable ["LT_respawnGroup_used", false])))
		}
	] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
	true
};

if (isNull _unit) then {_unit = player;};
if (!local _unit) exitWith {false};
if (("lt_respawngroup" call BIS_fnc_getParamValue) != 1) exitWith {false};
if ((missionNamespace getVariable ["LT_PermaDeath", 0]) == 1) exitWith {false};

_time = "lt_respawngroup_time" call BIS_fnc_getParamValue;
if (_time < 1) then {_time = 120;};

_unit setVariable ["LT_respawnGroup_until", serverTime + _time, true];
_unit setVariable ["LT_respawnGroup_used", false, true];

hint format ["You can deploy to your group for %1 seconds.\nOpen the ACE self interaction menu and choose 'Deploy to group'.", _time];
["RespawnGroup", format ["%1 can deploy for %2 seconds", name _unit, _time]] call LT_fnc_log;

true
