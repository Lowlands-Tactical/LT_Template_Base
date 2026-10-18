/*

File: fn_menuInit.sqf
Author: Lowlands Tactical

Description:
Builds the "Lowlands Tactical" ACE self interaction menu and the tablet keybinds.
The actions are class actions on CAManBase (inherited), so they are still there after a respawn.
The AFK system and the respawn group system add their own actions below this menu
(parent path ["ACE_SelfActions", "lt_main"]) and call the "main" mode first.
The keybinds are in the CBA keybind menu (Options > Controls > Configure Addons > Lowlands Tactical)
and have no default key. A keybind only works for people who may use the action, there is no message for the others.

Modes:
"main"   = Add the main menu "Lowlands Tactical" (only once, safe to call more than once)
"tablet" = Add the staff tablet, crew tablet and group teleport actions and the tablet keybinds

Parameters:
_this select 0 = Mode (String)

Example:
["tablet"] call LT_fnc_menuInit;

Return value:
True (if done), false (if not needed)

*/

params [["_mode", "main", [""]]];

// Declare all local variables
private [
	"_result", "_action"
];

if (!hasInterface) exitWith {false};

_result = false;

switch (_mode) do
{
	case "main":
	{
		if (!(missionNamespace getVariable ["LT_menu_mainReady", false])) then
		{
			_action = ["lt_main", "Lowlands Tactical", "\lt_template_base\logos\lowtac.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
			["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
			LT_menu_mainReady = true;
		};
		_result = true;
	};

	case "tablet":
	{
		["main"] call LT_fnc_menuInit;

		_action = ["lt_staff_tablet", "Show Tablet", "\a3\ui_f\data\igui\cfg\simpletasks\types\intel_ca.paa",
			{execVM "\lt_template_base\Tablet\openTablet.sqf"},
			{((missionNamespace getVariable ["lt_admin", false]) || (missionNamespace getVariable ["lt_logged", false]))}
		] call ace_interact_menu_fnc_createAction;
		["CAManBase", 1, ["ACE_SelfActions", "lt_main"], _action, true] call ace_interact_menu_fnc_addActionToClass;

		_action = ["lt_crew_tablet", "Show Crew Tablet", "\a3\ui_f\data\igui\cfg\simpletasks\types\intel_ca.paa",
			{execVM "\lt_template_base\Tablet\openTabletCrew.sqf"},
			{((missionNamespace getVariable ["lt_crewmin", false]) || (missionNamespace getVariable ["lt_logged", false]))}
		] call ace_interact_menu_fnc_createAction;
		["CAManBase", 1, ["ACE_SelfActions", "lt_main"], _action, true] call ace_interact_menu_fnc_addActionToClass;

		_action = ["lt_groupTP", "Teleport Group", "\lt_template_base\logos\lowtac.paa",
			{
				openMap [true, true];
				onMapSingleClick "[_pos] call LT_fnc_teleportGroup; openMap[false,false]; onMapSingleClick '';";
				lt_group_teleport = 0;
			},
			{((lt_group_teleport == 1) && (player == (leader player)))}
		] call ace_interact_menu_fnc_createAction;
		["CAManBase", 1, ["ACE_SelfActions", "lt_main"], _action, true] call ace_interact_menu_fnc_addActionToClass;

		if (!isNil "CBA_fnc_addKeybind") then
		{
			["Lowlands Tactical", "lt_tablet_staff", ["Open Staff Tablet", "Open the staff tablet (staff only)"],
				{
					private ["_handled"];
					_handled = false;
					if ((!dialog) && ((missionNamespace getVariable ["lt_admin", false]) || (missionNamespace getVariable ["lt_logged", false]))) then
					{
						execVM "\lt_template_base\Tablet\openTablet.sqf";
						_handled = true;
					};
					_handled
				}, {}, [0, [false, false, false]]
			] call CBA_fnc_addKeybind;

			["Lowlands Tactical", "lt_tablet_crew", ["Open Crew Tablet", "Open the crew tablet (crew only)"],
				{
					private ["_handled"];
					_handled = false;
					if ((!dialog) && ((missionNamespace getVariable ["lt_crewmin", false]) || (missionNamespace getVariable ["lt_logged", false]))) then
					{
						execVM "\lt_template_base\Tablet\openTabletCrew.sqf";
						_handled = true;
					};
					_handled
				}, {}, [0, [false, false, false]]
			] call CBA_fnc_addKeybind;
		};
		_result = true;
	};

	default
	{
		["Menu", format ["menuInit: unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
