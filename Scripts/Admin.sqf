/*

File: Admin.sqf
Author: Brainless_Ben

Description:
Defines a number of publicvariables and loads the custom ace addActions.
Admin.sqf is loaded in the postInit seen in Config.cpp

*/

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

// ACE3 Menu for Lowlands Tactical
private ["_lt_main","_action"];

// Version build up (year.month.day.dayversion)
lt_version = "V2023.09.20.001";
publicVariable "lt_version";

lt_staff = [
	"76561198042684200",	// Tybalty
	"76561198028914656",	// Lonesentinel
	"76561198014060493",	// R.Hoods
	"76561197992586763"		// Brainless_Ben
];
publicVariable "lt_staff";

lt_admin = (getPlayerUID player) in lt_staff;
lt_crew = serverCommandAvailable "#kick";
lt_group_teleport = 0;
lt_resupply = 0;
lt_playerCamoIsSet = 0;
lt_vehicleGearIsSet = 0;

Diag_Log format["[LT] (Admin) LT_Staff: %1", lt_staff];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (Admin) LT_Staff: %1", lt_staff];
};

// Adds ace options for admins and team leads when enabled
if (missionNamespace getVariable ["ace_common", false]) then 
{
	private ["_lt_main","_action"];

	_lt_main = ["lt_main", "Lowlands Tactical", "\lt_template_base\logos\lowtac.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _lt_main] call ace_interact_menu_fnc_addActionToObject;

	_action = ["lt_main_tablet", "Show Tablet", "\lt_template_base\logos\lowtac.paa", {execVM "\lt_template_base\LT_Tablet\openTablet.sqf"}, {lt_admin OR lt_crew}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","lt_main"], _action] call ace_interact_menu_fnc_addActionToObject;
	
	_action = ["lt_main_doGroupTP", "Teleport Group", "\lt_template_base\logos\lowtac.paa", {openMap[true,true]; onMapSingleClick "[_pos] call LT_fnc_teleportGroup; openMap[false,false]; onMapSingleClick '';"; lt_group_teleport = 0; }, {(lt_group_teleport == 1) AND (player == leader player)}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "lt_main"], _action] call ace_interact_menu_fnc_addActionToObject;

	Diag_log "[LT] (Admin) Ace SelfAction finished";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (Admin) ACE SelfAction finished";
	};
};

Diag_log "[LT] (Admin) PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (Admin) PreInit finished";
};
