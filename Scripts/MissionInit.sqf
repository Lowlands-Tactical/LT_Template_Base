/*

File: MissionInit.sqf
Author: Brainless_Ben

Description:
Runs a set of commands at the beginning of the mission and player respawn.
Also sets the briefing for everyone.

*/

// Stuff common to all our missions!
Diag_log "[LT] (Mission) init Loading";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (Mission) init Loading";
};

// Eject headless client
if (!hasInterface && !isDedicated) exitWith {};

enableSaving [false, false];
enableSentences false;
enableEnvironment [false, true];

Diag_log "[LT] (Mission) loading Safety";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (Mission) loading Safety";
};
[] execVM "\lt_template_base\Scripts\safeStart.sqf";

if (isServer) then 
{
    Diag_log "[LT] (Mission) loading Server Debug";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat "[LT] (Mission) loading Server Debug";
    };
    [] execVM "\lt_template_base\Scripts\server_debug.sqf";

    Diag_log "[LT] (Mission) loading Zeus Modules";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat "[LT] (Mission) loading Zeus Modules";
    };
    [] remoteExec ["LT_fnc_adminZeusModule", 2];

    Diag_log "[LT] (Mission) loading Gear/Weapons";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat "[LT] (Mission) loading server Gear/Weapons";
    };
    [] execVM "\lt_template_base\Scripts\prepLoadout_Server.sqf";
    [] remoteExec ["LT_fnc_prepVehicleLoadout", 2];
};

if (hasinterface) then 
{
    waitUntil {!isNull player};

    // Because we want to start with the weapon lowered
    if (vehicle player == player) then {player switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSlowWrflDnon";};

    Diag_log "[LT] (Mission) loading player Gear/Weapons";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat "[LT] (Mission) loading Gear/Weapons";
    };
    [player] remoteExec ["LT_fnc_prepPlayerLoadout", player];
    
    _staffArray = missionNameSpace getVariable "lt_staff";
    _staffCheck = getPlayerUID player;
    if (didJIP) then 
    {
        if (_staffCheck IN _staffArray) then 
        {
            [] remoteExec ["LT_fnc_adminZeusModule", 2];
        };
    };

    _rankPlayer = rank player;
    switch (_rankPlayer) do 
    {
        case "PRIVATE": {player assignTeam "RED"};
        case "CORPORAL": {player assignTeam "BLUE"};
        case "SERGEANT": {player assignTeam "GREEN"};
        case "LIEUTENANT": {player assignTeam "YELLOW"};
        default {player assignTeam "MAIN"};
    };

    if ("lt_fatigue_onoff" call bis_fnc_getParamValue == 0) then 
    {
        player enableFatigue false;

        Diag_log "[LT] (Mission) Fatigue off";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Mission) Fatigue off";
        };
    };

    if ("lt_markers" call bis_fnc_getParamValue == 1) then 
    {
        [[],"\lt_template_base\Scripts\QS_icons.sqf"] remoteExec ["BIS_fnc_execVM", player];
        
        Diag_log "[LT] (Mission) QS markers are enabled";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Mission) QS markers are enabled";
        };
    };

    Diag_log "[LT] (Mission) Loading EvenHandlers";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat "[LT] (Mission) Loading EvenHandlers";
    };

    player addAction 
    [
        "<t color='#FF0000'>Parachute</t>", 
        "\lt_template_base\scripts\paradrop.sqf", 
        "", 1, false, true, "", 
        "((vehicle player) isKindOf 'Air') && (((position player) select 2) > 100) && (player != driver (vehicle player))"
    ];

    // Check PermaDeath and add respawn eventHandlers acordingly
    LT_PermaDeath = getMissionConfigValue ["LT_PermaDeath_ID", 0];
    Diag_log format ["[LT] (Mission) PermaDeath = %2 is pubvarred at %1", time, LT_PermaDeath];
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemChat format ["[LT] (Mission) PermaDeath = %2 is pubvarred at %1", time, LT_PermaDeath];
    };

    if (LT_PermaDeath == 1) then 
    {
        player addMPEventHandler 
        [
            "MPkilled",
            {
                params ["_unit", "_killer"];
                diag_log format ["[LT] (PermaDeath) %1 died and now is spectating", name _unit];
                if ("lt_debug" call bis_fnc_getParamValue == 1) then 
                {
                    systemChat format ["[LT] (PermaDeath) %1 died and now is spectating", name _unit];
                };
                if (local _unit) then 
                {
                    hintSilent format ["%1 died and now is spectating", name _unit];
                    ["west", "east", "resistance", "civ"] call acre_api_fnc_babelsetSpokenlanguages;
                    [true] call acre_api_fnc_setSpectator;
                    ["Initialize", [_unit, [], true]] call BIS_fnc_EGSpectator;
                };
            }
        ];
    } else 
    {
        if (_staffCheck IN _staffArray) then 
        {
            player addMPEventHandler 
            [
                "MPkilled",
                {
                    findDisplay 46 displayAddEventHandler 
                    [
                        "KeyDown",
                        {
                            if (inputAction "CuratorInterface" > 0) then 
                            {
                                closeDialog 0;
                            };
                        }
                    ]
                }
            ];
        };
        player addMPEventHandler 
        [
            "MPRespawn",
            {
                params ["_unit","_corpse"];
                [_unit, _corpse] execVM "lt_template_base\Scripts\Respawn.sqf";
            }
        ];
    };

    Diag_log "[LT] (Mission) Loading briefing";
    _adBrief = [] execVM "\lt_template_base\Scripts\BriefingAdmin.sqf";
    waitUntil {uiSleep 0.5; scriptDone _adBrief};
    _chBrief = [] execVM "\lt_template_base\Scripts\Briefingchecklist.sqf";
    waitUntil {uiSleep 0.5; scriptDone _chBrief};
    _dbBrief = [] execVM "\lt_template_base\Scripts\BriefingDebug.sqf";
    waitUntil {uiSleep 0.5; scriptDone _dbBrief};
};

Diag_log "[LT] (Mission) Mission init finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (Mission) init finished";
};
