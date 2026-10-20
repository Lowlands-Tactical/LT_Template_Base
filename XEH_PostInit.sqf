/*

File: XEH_PostInit.sqf
Author: Brainless_Ben

Description:
Defines more global variables and hashmaps used in the template.

*/

_ltMission = getMissionConfigValue "LT_Loadout_ID";
if (isNil "_ltMission") exitWith
{
	Diag_log format ["[LT] (XEH) %1 Eject is not mission template", __FILE__];
};

// Compulsary missions start banner
diag_log "   /$$                               /$$                           /$$                        ";
diag_log "  | $$                              | $$                          | $$                        ";
diag_log "  | $$        /$$$$$$  /$$  /$$  /$$| $$  /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$$              ";
diag_log "  | $$       /$$__  $$| $$ | $$ | $$| $$ |____  $$| $$__  $$ /$$__  $$ /$$_____/              ";
diag_log "  | $$      | $$  \ $$| $$ | $$ | $$| $$  /$$$$$$$| $$  \ $$| $$  | $$|  $$$$$$               ";
diag_log "  | $$      | $$  | $$| $$ | $$ | $$| $$ /$$__  $$| $$  | $$| $$  | $$ \____  $$              ";
diag_log "  | $$$$$$$$|  $$$$$$/|  $$$$$/$$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/              ";
diag_log "  |________/ \______/  \_____/\___/ |__/ \_______/|__/  |__/ \_______/|_______/               ";
diag_log "                                                                                              ";
diag_log "                            /$$$$$$$$                    /$$     /$$                     /$$  ";
diag_log "                           |__  $$__/                   | $$    |__/                    | $$  ";
diag_log "                              | $$  /$$$$$$   /$$$$$$$ /$$$$$$   /$$  /$$$$$$$  /$$$$$$ | $$  ";
diag_log "                              | $$ |____  $$ /$$_____/|_  $$_/  | $$ /$$_____/ |____  $$| $$  ";
diag_log "                              | $$  /$$$$$$$| $$        | $$    | $$| $$        /$$$$$$$| $$  ";
diag_log "                              | $$ /$$__  $$| $$        | $$ /$$| $$| $$       /$$__  $$| $$  ";
diag_log "                              | $$|  $$$$$$$|  $$$$$$$  |  $$$$/| $$|  $$$$$$$|  $$$$$$$| $$  ";
diag_log "                              |__/ \_______/ \_______/   \___/  |__/ \_______/ \_______/|__/  ";

//Staff array used for table ace action and admin briefing
_lt_staff = AdminCrew get "Staff";
_lt_crew = AdminCrew get "Crew";

lt_admin = (getPlayerUID player) in _lt_staff;
lt_crewmin = (getPlayerUID player) in _lt_crew;
lt_logged = serverCommandAvailable "#kick";

// Adds the Lowlands Tactical ace menu (tablets, group teleport) and the tablet keybinds when enabled
// AFK and Deploy to group add their own actions to the same menu (see LT_fnc_menuInit)
if (missionNamespace getVariable ["ace_common", false]) then 
{
	["tablet"] call LT_fnc_menuInit;

	["XEH","Ace SelfAction finished"] call LT_fnc_log;
};

//missionsParamSettings
_radioShort = if (("lt_gear_SR" call bis_fnc_getParamValue) == 0) then {false} else {true};
_radioLong = switch ("lt_gear_radiopack" call bis_fnc_getParamValue) do
{
    case 0: {false}; // Nobody get LongRange
	case 1: {"comms"};
	case 2: {true};
	default {true}; // Default if none selected
};
_gearNVG = if (("lt_gear_nvg" call bis_fnc_getParamValue) == 0) then {false} else {true};
_wpnScope = if (("lt_gear_weapon_scope" call bis_fnc_getParamValue) == 0) then {false} else {true};

_sides = TabletSettings get "SIDES";
MissionSettings = createHashMapFromArray [
    ["Period", getMissionConfigValue ["LT_Loadout_ID","BASE"]],
    ["RadioShort", _radioShort],
    ["RadioLong", _radioLong],
	["NVG", _gearNVG],
	["ATT", "lt_gear_weapon_att" call bis_fnc_getParamValue],
	["SCOPE", _wpnScope],
	["GEAR", createHashMapFromArray[
		[_sides #0, "lt_gear_camo_blue" call bis_fnc_getParamValue],
		[_sides #1, "lt_gear_camo_red" call bis_fnc_getParamValue],
		[_sides #2, "lt_gear_camo_green" call bis_fnc_getParamValue]
	]],
	["WEAPON",createHashMapFromArray[
		[_sides #0, "lt_gear_weapon_blue" call bis_fnc_getParamValue],
		[_sides #1, "lt_gear_weapon_red" call bis_fnc_getParamValue],
		[_sides #2, "lt_gear_weapon_green" call bis_fnc_getParamValue]
	]]
];
publicVariable "MissionSettings";

["Mission","loading Safety"] call LT_fnc_log;
[] execVM "\lt_template_base\Scripts\safeStart.sqf";

["XEH_Base","Template Base PostInit finished"] call LT_fnc_log;
