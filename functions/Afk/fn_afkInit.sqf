/*

File: fn_afkInit.sqf
Author: Lowlands Tactical

Description:
Sets up the AFK system on the client (call once, next to ["register"] call LT_fnc_respawnGroupInit).
Adds the ACE self interaction actions "Go AFK" and "Back from AFK" and the CBA keybinds
(Options > Controls > Configure Addons > Lowlands Tactical). The keybinds have no default key.
Nothing is added when the parameter lt_afk is off.

Modes:
"register" = Add the ACE actions and the keybinds

Parameters:
_this select 0 = Mode (String)

Example:
["register"] call LT_fnc_afkInit;

Return value:
True (if done), false (if not needed)

*/

params [["_mode", "register", [""]]];

// Declare all local variables
private [
	"_result", "_action"
];

if (!hasInterface) exitWith {false};

_result = false;

switch (_mode) do
{
	case "register":
	{
		if (("lt_afk" call BIS_fnc_getParamValue) == 1) then
		{
			_action = ["lt_afk_go", "Go AFK", "\lt_template_base\logos\lowtac.paa",
				{["go"] call LT_fnc_afkRequest},
				{
					params ["_target", "_player"];
					(((_player getVariable ["LT_afk_state", ""]) == "") && (alive _player) && (isNull objectParent _player))
				}
			] call ace_interact_menu_fnc_createAction;
			["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

			_action = ["lt_afk_back", "Back from AFK", "\lt_template_base\logos\lowtac.paa",
				{["back"] call LT_fnc_afkRequest},
				{
					params ["_target", "_player"];
					((_player getVariable ["LT_afk_state", ""]) in ["CLONE", "HOST", "WAIT"])
				}
			] call ace_interact_menu_fnc_createAction;
			["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

			if (!isNil "CBA_fnc_addKeybind") then
			{
				["Lowlands Tactical", "lt_afk_go", ["Go AFK", "Go AFK: you get a clone and you are hidden"],
					{["go"] call LT_fnc_afkRequest; true}, {}, [0, [false, false, false]]
				] call CBA_fnc_addKeybind;
				["Lowlands Tactical", "lt_afk_back", ["Back from AFK", "Come back from AFK (5 seconds protection)"],
					{["back"] call LT_fnc_afkRequest; true}, {}, [0, [false, false, false]]
				] call CBA_fnc_addKeybind;
			};
			_result = true;
		};
	};

	default
	{
		["Afk", format ["afkInit: unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
