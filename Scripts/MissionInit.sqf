/*

File: MissionInit.sqf
Author: Brainless_Ben

Description:
Runs a set of commands at the beginning of the mission and player respawn.
Also sets the briefing for everyone.

*/

// Stuff common to all our missions!
["Mission","init Loading",2] call LT_fnc_log;

// Eject headless client
if (!hasInterface && !isDedicated) exitWith {};

enableSentences false;
enableEnvironment [false, true];
ace_dragging_canMoveDead = false;

if (isServer) then 
{
    ["Mission","loading Server Debug",2] call LT_fnc_log;
    [] execVM "\lt_template_base\Scripts\server_debug.sqf";

    ["Mission","loading Zeus Modules",2] call LT_fnc_log;
    [] call LT_fnc_adminZeusModule;
    //[] execVM "\lt_template_base\Scripts\setLowtacFaces.sqf";
    ["Mission","loading vehicle gear",2] call LT_fnc_log;
    [] call LT_fnc_InitPostVeh;
};

if (hasinterface) then 
{
    waitUntil {!isNull player};

    // Because we want to start with the weapon lowered
    if (vehicle player == player) then {player switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSlowWrflDnon";};

    if (didJIP) then 
    {
        if ((getPlayerUID player) in (AdminCrew get "Staff")) then 
        {
            [] call LT_fnc_adminZeusModule;
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

        ["Mission","Fatigue off",2] call LT_fnc_log;
    };
    if (["lt_markers", 1] call bis_fnc_getParamValue == 1) then
    {
        [] call LT_fnc_initMapIntel;
        
        ["Mission","Player group markers are enabled",2] call LT_fnc_log;
    };
    ["Mission","Loading EvenHandlers"] call LT_fnc_log;
    player addAction 
    [
        "<t color='#FF0000'>Parachute</t>", 
        "\lt_template_base\Scripts\paradrop.sqf", 
        "", 1, false, true, "", 
        "((vehicle player) isKindOf 'Air') && (((position player) select 2) > 100) && (player != driver (vehicle player))"
    ];

    // Check PermaDeath and add respawn eventHandlers acordingly
    LT_PermaDeath = getMissionConfigValue ["LT_PermaDeath_ID", 0];
    ["Mission",format ["PermaDeath = %2 is pubvarred at %1", time, LT_PermaDeath],2] call LT_fnc_log;

    if (LT_PermaDeath == 1) then 
	{
		player addMPEventHandler 
		[
			"MPkilled",
			{
				params ["_unit", "_killer"];
                ["PremaDeath",format ["%1 died and now is spectating", name _unit],2] call LT_fnc_log;
				//Because MPEventHandler MPKilled is executed globaly AND on evey client this makes sure its only on the client that died
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
		if ((getPlayerUID player) in (AdminCrew get "Staff")) then 
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
                if (local _unit) then
                {
				    [_unit, _corpse] execVM "lt_template_base\Scripts\Respawn.sqf";
                };
			}
		];
        player addEventHandler 
		[
			"GetOutMan",
			{
				params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
                if (_vehicle isKindOf "ParachuteBase") then
                {
                    _unitRole = _unit getVariable "LT_unit_role";
                    _unitSide = str(side _unit);
                    _airRoles = RoleSettings get "wpnAir";
                    if (_unitRole IN _airRoles) then
                    {
                        _missionPeriod = MissionSettings get "Period";
                        _gear = switch (_unitSide) do {
                            case "WEST":{westGear};
                            case "EAST":{eastGear};
                            case "GUER":{guerGear};
                        };
                        _weapon = switch (_unitSide) do {
                            case "WEST":{westWeapons};
                            case "EAST":{eastWeapons};
                            case "GUER":{guerWeapons};
                        };
                        
                        _backpack = (_gear get "Backpack")#0;
                        _items = (ItemsGear get "pilot") get _missionPeriod;
                        _itemsAmt = (ItemsGear get "pilot") get "Amount";
                        _ammo = [((_weapon get "AIR") get "Ammo")#0,((_weapon get "HG") get "Ammo")#0];
                        _ammoAmt = [10,5];

                        _pack = _backpack createVehicle (position _unit);
                        {
                            _pack addItemCargoGlobal [_x, _itemsAmt select _forEachIndex];
                        }forEach _items;
                        {
                            _pack addItemCargoGlobal [_x, _ammoAmt select _forEachIndex];
                        }forEach _ammo;
                        
                        ["Parachute",["%1 landed backpack:%2 has been spawned", name _unit,_pack],2] call LT_fnc_log;
                    }else
                    {
                        ["Parachute",["%1 landed but gets no backpack", name _unit],2] call LT_fnc_log;
                    };
                };
			}
		];
	};

    ["Mission","Loading briefing"] call LT_fnc_log;
    
    player removeDiarySubject "Diary";
    _meBrief = [] execVM "\lt_template_base\Scripts\BriefingMeteo.sqf";
    waitUntil {uiSleep 0.5; scriptDone _meBrief};
    _chBrief = [] execVM "\lt_template_base\Scripts\Briefingchecklist.sqf";
    waitUntil {uiSleep 0.5; scriptDone _chBrief};
    _adBrief = [] execVM "\lt_template_base\Scripts\BriefingAdmin.sqf";
    waitUntil {uiSleep 0.5; scriptDone _adBrief};
    
    if ("lt_debug" call bis_fnc_getParamValue == 1) exitWith 
    {
        _dbBrief = [] execVM "\lt_template_base\Scripts\BriefingDebug.sqf";
        waitUntil {uiSleep 0.5; scriptDone _dbBrief};
    };
};

["Mission","init finished",2] call LT_fnc_log;
