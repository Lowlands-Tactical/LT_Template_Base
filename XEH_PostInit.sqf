/*

File: XEH_PostInit.sqf
Author: Brainless_Ben

Description:
Defines and loads the custom ace addActions.

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

//Staff array used for table ace action and admin briefing
lt_staff = [
	"76561198042684200",	// Tybalty
	"76561198028914656",	// Lonesentinel
	"76561198014060493",	// R.Hoods
	"76561197992586763"		// Brainless_Ben
];
missionNameSpace setVariable ["lt_staff",lt_staff,true];
lt_crew = [
	//"76561198010219180",	// PingWing
	"76561198047657052",	// DM3002X
	"76561198047491445" 	// Pekeru
];
missionNameSpace setVariable ["lt_crew",lt_crew,true];

lt_admin = (getPlayerUID player) in lt_staff;
lt_crewmin = (getPlayerUID player) in lt_crew;
lt_logged = serverCommandAvailable "#kick";

// Adds ace options for admins and team leads when enabled
if (missionNamespace getVariable ["ace_common", false]) then 
{
	private ["_lt_main","_action"];

	_lt_main = ["lt_main", "Lowlands Tactical", "\lt_template_base\logos\lowtac.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _lt_main] call ace_interact_menu_fnc_addActionToObject;

	_action = ["lt_main_tablet", "Show Tablet", "\lt_template_base\logos\lowtac.paa", {execVM "\lt_template_base\LT_Tablet\openTablet.sqf"}, {lt_admin OR lt_logged}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","lt_main"], _action] call ace_interact_menu_fnc_addActionToObject;

	_action = ["lt_main_tablet", "Show Crew Tablet", "\lt_template_base\logos\lowtac.paa", {execVM "\lt_template_base\LT_Tablet\openTabletCrew.sqf"}, {lt_admin OR lt_crewmin OR lt_logged}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","lt_main"], _action] call ace_interact_menu_fnc_addActionToObject;
	
	_action = ["lt_main_doGroupTP", "Teleport Group", "\lt_template_base\logos\lowtac.paa", {openMap[true,true]; onMapSingleClick "[_pos] call LT_fnc_teleportGroup; openMap[false,false]; onMapSingleClick '';"; lt_group_teleport = 0; }, {(lt_group_teleport == 1) AND (player == leader player)}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "lt_main"], _action] call ace_interact_menu_fnc_addActionToObject;

	Diag_log "[LT] (XEH) Ace SelfAction finished";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (XEH) ACE SelfAction finished";
	};
};

Diag_log "[LT] (XEH) PostInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) PostInit finished";
};
