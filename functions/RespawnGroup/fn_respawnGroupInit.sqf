/*

File: fn_respawnGroupInit.sqf
Author: Lowlands Tactical

Description:
Sets up "Deploy to group".
"register" adds the ACE self interaction action "Deploy to group" (in the menu Lowlands Tactical) and the CBA keybind
(Options > Controls > Configure Addons > Lowlands Tactical, no default key). Call once on the client.
"usable" checks if the unit can deploy right now (used by the action and the keybind).
"unit" starts the deploy window for a unit that just respawned (call from Respawn.sqf).
The window ends when the time (parameter lt_respawngroup_time) is over or after one deploy.
Nothing happens when the parameter lt_respawngroup is off or when PermaDeath is on.

Parameters:
_this select 0 = Mode (String): "register", "usable" or "unit" (default)
_this select 1 = Unit (Object, for "unit" the unit that respawned, for "usable" the unit to check, default player)

Example:
["register"] call LT_fnc_respawnGroupInit;
["unit", _unit] call LT_fnc_respawnGroupInit;
_ok = ["usable"] call LT_fnc_respawnGroupInit;

Return value:
True (if done / usable), false (if not needed / not usable)

*/

params [
	["_mode", "unit", [""]],
	["_unit", objNull, [objNull]]
];

// Declare all local variables
private [
	"_result", "_action", "_time"
];

if (!hasInterface) exitWith {false};

if (isNull _unit) then {_unit = player;};

_result = false;

switch (_mode) do
{
	case "register":
	{
		["main"] call LT_fnc_menuInit;

		_action = ["lt_respawngroup_deploy", "Deploy to group", "\a3\ui_f\data\igui\cfg\simpletasks\types\meet_ca.paa",
			{["open"] call LT_fnc_respawnGroupMenu;},
			{
				params ["_target", "_player"];
				["usable", _player] call LT_fnc_respawnGroupInit
			}
		] call ace_interact_menu_fnc_createAction;
		["CAManBase", 1, ["ACE_SelfActions", "lt_main"], _action, true] call ace_interact_menu_fnc_addActionToClass;

		if (!isNil "CBA_fnc_addKeybind") then
		{
			["Lowlands Tactical", "lt_respawngroup_deploy", ["Deploy to group", "Open the Deploy to group menu (only while you can deploy)"],
				{
					private ["_handled"];
					_handled = false;
					if (["usable"] call LT_fnc_respawnGroupInit) then
					{
						["open"] call LT_fnc_respawnGroupMenu;
						_handled = true;
					};
					_handled
				}, {}, [0, [false, false, false]]
			] call CBA_fnc_addKeybind;
		};
		_result = true;
	};

	case "usable":
	{
		_result = ((alive _unit) &&
			(isNull objectParent _unit) &&
			(serverTime < (_unit getVariable ["LT_respawnGroup_until", 0])) &&
			(!(_unit getVariable ["LT_respawnGroup_used", false])));
	};

	case "unit":
	{
		if (local _unit) then
		{
			if ((("lt_respawngroup" call BIS_fnc_getParamValue) == 1) && ((missionNamespace getVariable ["LT_PermaDeath", 0]) != 1)) then
			{
				_time = "lt_respawngroup_time" call BIS_fnc_getParamValue;
				if (_time < 1) then {_time = 120;};

				_unit setVariable ["LT_respawnGroup_until", serverTime + _time, true];
				_unit setVariable ["LT_respawnGroup_used", false, true];

				hint format ["You can deploy to your group for %1 seconds.\nOpen the ACE self interaction menu > Lowlands Tactical > Deploy to group, or use your Deploy to group keybind.", _time];
				["RespawnGroup", format ["%1 can deploy for %2 seconds", name _unit, _time]] call LT_fnc_log;

				_result = true;
			};
		};
	};

	default
	{
		["RespawnGroup", format ["respawnGroupInit: unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
