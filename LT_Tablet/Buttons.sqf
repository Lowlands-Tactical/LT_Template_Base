/*

File: openTablet.sqf
Author: Brainless_Ben

Description:
Button code for buttons in the LT_Tablet

Parameters:
_code is defined in LT_Tablet.hpp

*/

//Set the paramater that is given when running the script.
private ["_code"];
_code = _this;

switch (_code) do 
{
    case "SafetyOff": 
    {
        lt_param_timer = -1;
        publicVariable "lt_param_timer";
        ["SafeStartMissionStarting",["Mission starting now!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [false] remoteExec ["LT_fnc_safety",allPlayers];
        ctrlShow [510, false];
        ctrlShow [511, true];
        hintsilent "Safe Start ended!";
    };
    case "SafetyOn": 
    {
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        ctrlShow [510, true];
        ctrlShow [511, false];
        hintSilent "Safe Start started!";
    };
    case "FatigueOff": 
    {
        lt_fatigue_onoff = 1;
        publicVariable "lt_fatigue_onoff";
        {_x enableFatigue false}forEach allPlayers;
        ctrlShow [512, false];
        ctrlShow [513, true];
        hintsilent "Fatigue is Off";
    };
    case "FatigueOn": 
    {
        lt_fatigue_onoff = 0;
        publicVariable "lt_fatigue_onoff";
        {_x enableFatigue true}forEach allPlayers;
        ctrlShow [512, true];
        ctrlShow [513, false];
        hintSilent "Fatigue is On";
    };
    case "Hide": 
    {
        [player,true] remoteExec ["hideObjectGlobal",2];
        ctrlShow [514, false];
        ctrlShow [515, true];
        hintsilent "You are hidden";
    };
    case "Unhide": 
    {
        [player,false] remoteExec ["hideObjectGlobal",2];
        ctrlShow [514, true];
        ctrlShow [515, false];
        hintsilent "You are visible";
    };
    case "GpTpOn": 
    {
        lt_group_teleport = 1;
        publicVariable "lt_group_teleport";
        ctrlShow [516, false];
        ctrlShow [517, true];
        hintsilent "Group teleport is On";
    };
    case "GpTpOff": 
    {
        lt_group_teleport = 0;
        publicVariable "lt_group_teleport";
        ctrlShow [516, true];
        ctrlShow [517, false];
        hintsilent "Group teleport is Off";
    };
    case "Zeus": 
    {
        closeDialog 0;
        openCuratorInterface;
        Diag_log format ["[LT] (Tablet) %1 Opened Zeus", name player];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format ["[LT] (Tablet) %1 Opened Zeus", name player];
        };
    };
    case "MarkUnits": 
    {
        [] call alive_fnc_markUnits;
        hintsilent "Units will be marked";
    };
    case "Arsenal": 
    {
        [player, player, true] call ace_arsenal_fnc_openBox;
        closedialog 0;
        Diag_log format["[LT] (Tablet) %1 Opened ACE Arsenal", name player];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format["[LT] (Tablet) %1 Opened ACE Arsenal", name player];
        };
    };
    case "Debug": 
    {
        closeDialog 0;
        createDialog "RscDisplayDebugPublic";
    };
    case "Heal": 
    {
        _index = lbCurSel 550;
        _unit = playerArr select _index; //playerArr is de array defined in openTablet.sqf
        [_unit] call ace_medical_treatment_fnc_fullHealLocal;
        [_unit, false] call ace_medical_status_fnc_setUnconsciousState;
        Diag_log format["[LT] (Tablet) %1 Healed %2", name player, name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 Healed %2", name player, name _unit];
        };
    };
    case "TPtoMe": 
    {
        _index = lbCurSel 550;
        _unit = playerArr select _index; //playerArr is de array defined in openTablet.sqf
        _vehUnit = vehicle _unit;
        if (_vehUnit != _unit) then 
        {
            if (_unit == driver _vehUnit OR _unit == gunner _vehUnit OR _unit == commander _vehUnit) exitWith
            {
                hintSilent format["%1 is an important crew can't teleport", name _unit];
            };
            moveOut _unit;
            _unit setVelocity [0,0,0];
            _pos = getPosATL player;
            _unit setPosATL _pos;
        } else 
        {
            _pos = getPosATL player;
            _unit setPosATL _pos;
        };
        Diag_log format ["[LT] (Tablet) %1 Teleported to %2", name _unit, name player];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format ["[LT] (Tablet) %1 Teleported to %2", name _unit, name player];
        };
        closeDialog 0;
    };
    case "TPtoTarget": 
    {
        _index = lbCurSel 550;
        _unit = playerArr select _index; //playerArr is de array defined in openTablet.sqf
        _vehUnit = vehicle _unit;
        if (_vehUnit != _unit) then 
        {
            _getInVeh = player moveInAny _vehUnit;
            if (!_getInVeh) then 
            {
                _pos = getPos _vehUnit;
                player setPosATL [_pos select 0, (_pos select 1) - 5, _pos select 2];
            };
        }else 
        {
            _pos = getPosATL _unit;
            player setPosATL _pos;
        };
        Diag_log format ["[LT] (Tablet) %1 Teleported to %2", name player, name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format ["[LT] (Tablet) %1 Teleported to %2", name player, name _unit];
        };
        closeDialog 0;
    };
    case "Drop": 
    {
        if (lt_resupply == 1) exitWith 
        {
            Diag_log "[LT] (Tablet) Supplydrop already in progress";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) Supplydrop already in progress";
            };
            hintsilent "Supplydrop already in progress";
        };
        
        veh = (lbData [531, lbCurSel 531]);
        cra = (lbData [533, lbCurSel 533]);
        lo1 = (lbData [535, lbCurSel 535]);
        lo2 = (lbData [536, lbCurSel 536]);
        lo3 = (lbData [537, lbCurSel 537]);
        if (lo1 == "None" && lo2 == "None" && lo3 == "None") exitWith 
        {
            Diag_log "[LT] (Tablet) All crate types are None";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) All crate types are None";
            };
            hintsilent "All crate types are None";
        };

        openMap [true, false];
        hintSilent parseText"
            <t size='10'><img image='\lt_template_base\logos\compass.paa'/></t><br/>
            <br/>
            <t size='1.2'>Direction Options</t><br/>
            <t size='1'>No Shift + No Alt = South To North</t><br/>
            <t size='1'>No Shift + Alt = North To South</t><br/>
            <t size='1'>Shift + No Alt = West To East</t><br/>
            <t size='1'>Shift + Alt = East To West</t><br/>
        ";
        onMapSingleClick '
            [_pos, side player, veh, cra, lo1, lo2, lo3, _shift, _alt] remoteExec ["LT_fnc_ResupplyRequest", 2];
            onMapSingleClick "";
            openMap [false, false];
            hintsilent "Resupply on the way";
        ';
        
        lt_resupply = 1;
        publicVariable "lt_resupply";
        closeDialog 0;
    };
    case "Droping": 
    {
        Diag_log "[LT] (Tablet) Supplydrop already in progress";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Supplydrop already in progress";
        };
        hintsilent "Supplydrop already in progress";
        closeDialog 0;
    };
    case "DropReset": 
    {
        if (lt_resupply == 1) then
        {
            lt_resupply = 0;
            publicVariable "lt_resupply";
            Diag_log "[LT] (Tablet) Supplydrop value has been reset";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) Supplydrop value has been reset";
            };
            hintsilent "Supplydrop value has been reset";
        }else 
        {
            Diag_log "[LT] (Tablet) Supplydrop doesn't need a reset";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) Supplydrop doesn't need a reset";
            };
            hintsilent "Supplydrop doesn't need a reset";
        };
    };
    case "Switch": 
    {
        if (!isNull findDisplay 500) then 
        {
            closeDialog 0;
            [] execVM "\lt_template_base\LT_Tablet\openTabletAdv.sqf";
        };
        if (!isNull findDisplay 600) then 
        {
            closeDialog 0;
            [] execVM "\lt_template_base\LT_Tablet\openTablet.sqf";
        };
    };
    case "Loadout": 
    {
        _object = ctrlText 619;
        if (_object == "No object detected") then 
        {
            Diag_log "[LT] (Tablet) nothing is found and could not be filled";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) nothing is found and could not be filled";
            };
        }else 
        {
            _vehicle = cursorObject;
            _side = (lbData [620, lbCurSel 620]);
            _load = (lbData [621, lbCurSel 621]);
            _vehicle setVariable ["LT_veh_side", _side, true];
            _vehicle setVariable ["LT_veh_role", _load, true];
            [_vehicle, _side, _load] remoteExec ["LT_fnc_VehicleLoadout"];

            Diag_log format["[LT] (Tablet) %1 is being filled with %2", _vehicle, _load];
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat format["[LT] (Tablet) %1 is being filled with %2", _vehicle, _load];
            };
        };
        closeDialog 0;
    };
    case "DebugBriefing":
    {
        Diag_log "[LT] (Tablet) Add/Remove Debug";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Add/Remove Debug";
        };
        [] execVM "\lt_template_base\Scripts\BriefingDebug.sqf";
        closeDialog 0;
    };
    case "Briefing": 
    {
        Diag_log "[LT] (Tablet) Reload admin briefing";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Reload admin briefing";
        };
        [] execVM "\lt_template_base\Scripts\BriefingAdmin.sqf";
        closeDialog 0;
    };
    case "ZeusModule": 
    {
        Diag_log "[LT] (Tablet) Reload zeus modules";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Reload zeus modules";
        };
        [] remoteExec ["LT_fnc_AdminZeusModule", 2];
        closeDialog 0;
    };
    case "PrepAllPlayers": 
    {
        {
            [_x] remoteExec ["LT_fnc_prepPlayerLoadout", _x];
        }forEach allPlayers;

        Diag_log "[LT] (Tablet) Reload prepPlayerloadout for every player";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Reload prepPlayerloadout for every player";
        };
        closeDialog 0;
    };
    case "PrepVehicle": 
    {
        LT_vehicleGearIsSet = 0;
        publicVariable "LT_vehicleGearIsSet";
        [] remoteExec ["LT_fnc_prepVehicleLoadout", 2];
        
        Diag_log "[LT] (Tablet) Reload prepVehicleloadout";
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat "[LT] (Tablet) Reload prepVehicleloadout";
        };
        closeDialog 0;
    };
    case "SetValues": 
    {
        _index = lbCurSel 650;
        _unit = playerAdvArr select _index; //playerArr is de array defined in openTablet.sqf
        _role = _unit getVariable ["LT_unit_role", "lvdw"];
        _gear = _unit getVariable ["LT_unit_gear", 1];
        _item = _unit getVariable ["LT_unit_item", 1];

        Diag_log format["[LT] (Tablet) %1 was role %2 consumables = %3 role items = %4", name _unit, _role, _gear, _item];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 was role %2 consumables = %3 role items = %4", name _unit, _role, _gear, _item];
        };

        _newRole = lbData [631, lbCurSel 631];
        _newGear = lbCurSel 632;
        _newItem = lbCurSel 633;
        if (_role != _newRole) then {_unit setVariable ["LT_unit_role", _newRole, true]};
        if (_gear != _newGear) then {_unit setVariable ["LT_unit_gear", _newGear, true]};
        if (_item != _newItem) then {_unit setVariable ["LT_unit_item", _newItem, true]};

        Diag_log format["[LT] (Tablet) %1 has role %2 consumables = %3 role items = %4", name _unit, _newRole, _newGear, _newItem];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 has role %2 consumables = %3 role items = %4", name _unit, _newRole, _newGear, _newItem];
        };
    };
    case "PrepPlayer": 
    {
        _index = lbCurSel 650;
        _unit = playerAdvArr select _index; //playerAdvArr is de array defined in openTablet.sqf
        [_unit] remoteExec ["LT_fnc_prepPlayerLoadout", _unit];
        
        Diag_log format["[LT] (Tablet) Reload prepPlayerloadout for Player:%1", name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) Reload prepPlayerloadout for Player:%1", name _unit];
        };
        closeDialog 0;
    };
    case "End1": // Missie geslaagd!
    {
        Diag_log "[LT] (Tablet) Mission ended (1)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end1" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "End2": // Missie partial win
    {
        Diag_log "[LT] (Tablet) Mission ended (2)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end2" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "End3": // Missie gefaald
    {
        Diag_log "[LT] (Tablet) Mission ended (3)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end3" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "End4": // BLUEFOR Wins
    {
        Diag_log "[LT] (Tablet) Mission ended (4)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end4" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "End5": // REDFOR Wins
    {
        Diag_log "[LT] (Tablet) Mission ended (5)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end5" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "End6": // GREENFOR Wins
    {
        Diag_log "[LT] (Tablet) Mission ended (6)";
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        hintSilent "Safe Start started!";
        "end6" remoteExecCall ["BIS_fnc_endMissionServer"];
        closeDialog 0; 
    };
    case "SafetyOffCrew": 
    {
        lt_param_timer = -1;
        publicVariable "lt_param_timer";
        ["SafeStartMissionStarting",["Mission starting now!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [false] remoteExec ["LT_fnc_safety",allPlayers];
        ctrlShow [710, false];
        ctrlShow [711, true];
        hintsilent "Safe Start ended!";
    };
    case "SafetyOnCrew": 
    {
        lt_param_timer = 10;
        publicVariable "lt_param_timer";
        ["SafeStartmissionStarting",["Mission safety is on!"]] remoteExecCall ["BIS_fnc_showNotification"];
        [true] remoteExec ["LT_fnc_safety",allPlayers];
        [] remoteExec ["LT_fnc_safeStartLoop"];
        ctrlShow [710, true];
        ctrlShow [711, false];
        hintSilent "Safe Start started!";
    };
    case "GpTpOnCrew": 
    {
        lt_group_teleport = 1;
        publicVariable "lt_group_teleport";
        ctrlShow [716, false];
        ctrlShow [717, true];
        hintsilent "Group teleport is On";
    };
    case "GpTpOffCrew": 
    {
        lt_group_teleport = 0;
        publicVariable "lt_group_teleport";
        ctrlShow [716, true];
        ctrlShow [717, false];
        hintsilent "Group teleport is Off";
    };
    case "HealCrew": 
    {
        _index = lbCurSel 750;
        _unit = playercrewArr select _index; //playercrewArr is de array defined in openTabletCrew.sqf
        [_unit] call ace_medical_treatment_fnc_fullHealLocal;
        [_unit, false] call ace_medical_status_fnc_setUnconsciousState;
        Diag_log format["[LT] (Tablet) %1 Healed %2", name player, name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 Healed %2", name player, name _unit];
        };
    };
    case "TPtoMeCrew": 
    {
        _index = lbCurSel 750;
        _unit = playercrewArr select _index; //playercrewArr is de array defined in openTabletCrew.sqf
        _vehUnit = vehicle _unit;
        if (_vehUnit != _unit) then 
        {
            if (_unit == driver _vehUnit OR _unit == gunner _vehUnit OR _unit == commander _vehUnit) exitWith
            {
                hintSilent format["%1 is an important crew can't teleport", name _unit];
            };
            moveOut _unit;
            _unit setVelocity [0,0,0];
            _pos = getPosATL player;
            _unit setPosATL _pos;
        } else 
        {
            _pos = getPosATL player;
            _unit setPosATL _pos;
        };
        Diag_log format ["[LT] (Tablet) %1 Teleported to %2", name _unit, name player];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format ["[LT] (Tablet) %1 Teleported to %2", name _unit, name player];
        };
        closeDialog 0;
    };
    case "TPtoTargetCrew": 
    {
        _index = lbCurSel 750;
        _unit = playercrewArr select _index; //playercrewArr is de array defined in openTabletCrew.sqf
        _vehUnit = vehicle _unit;
        if (_vehUnit != _unit) then 
        {
            _getInVeh = player moveInAny _vehUnit;
            if (!_getInVeh) then 
            {
                _pos = getPos _vehUnit;
                player setPosATL [_pos select 0, (_pos select 1) - 5, _pos select 2];
            };
        }else 
        {
            _pos = getPosATL _unit;
            player setPosATL _pos;
        };
        Diag_log format ["[LT] (Tablet) %1 Teleported to %2", name player, name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then
        {
            systemChat format ["[LT] (Tablet) %1 Teleported to %2", name player, name _unit];
        };
        closeDialog 0;
    };
    case "LoadoutCrew": 
    {
        _object = ctrlText 721;
        if (_object == "No object detected") then 
        {
            Diag_log "[LT] (Tablet) nothing is found and could not be filled";
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat "[LT] (Tablet) nothing is found and could not be filled";
            };
        }else 
        {
            _vehicle = cursorObject;
            _side = (lbData [722, lbCurSel 722]);
            _load = (lbData [723, lbCurSel 723]);
            _vehicle setVariable ["LT_veh_side", _side, true];
            _vehicle setVariable ["LT_veh_role", _load, true];
            [_vehicle, _side, _load] remoteExec ["LT_fnc_VehicleLoadout"];

            Diag_log format["[LT] (Tablet) %1 is being filled with %2", _vehicle, _load];
            if ("lt_debug" call bis_fnc_getParamValue == 1) then 
            {
                systemChat format["[LT] (Tablet) %1 is being filled with %2", _vehicle, _load];
            };
        };
        closeDialog 0;
    };
    case "SetValuesCrew": 
    {
        _index = lbCurSel 750;
        _unit = playercrewArr select _index; //playercrewArr is de array defined in openTablet.sqf
        _role = _unit getVariable ["LT_unit_role", "lvdw"];
        _gear = _unit getVariable ["LT_unit_gear", 1];
        _item = _unit getVariable ["LT_unit_item", 1];

        Diag_log format["[LT] (Tablet) %1 was role %2 consumables = %3 role items = %4", name _unit, _role, _gear, _item];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 was role %2 consumables = %3 role items = %4", name _unit, _role, _gear, _item];
        };

        _newRole = lbData [752, lbCurSel 752];
        _newGear = lbCurSel 753;
        _newItem = lbCurSel 754;
        if (_role != _newRole) then {_unit setVariable ["LT_unit_role", _newRole, true]};
        if (_gear != _newGear) then {_unit setVariable ["LT_unit_gear", _newGear, true]};
        if (_item != _newItem) then {_unit setVariable ["LT_unit_item", _newItem, true]};

        Diag_log format["[LT] (Tablet) %1 has role %2 consumables = %3 role items = %4", name _unit, _newRole, _newGear, _newItem];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) %1 has role %2 consumables = %3 role items = %4", name _unit, _newRole, _newGear, _newItem];
        };
    };
    case "PrepPlayerCrew": 
    {
        _index = lbCurSel 750;
        _unit = playercrewArr select _index; //playercrewArr is de array defined in openTablet.sqf
        [_unit] remoteExec ["LT_fnc_prepPlayerLoadout", _unit];
        
        Diag_log format["[LT] (Tablet) Reload prepPlayerloadout for Player:%1", name _unit];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (Tablet) Reload prepPlayerloadout for Player:%1", name _unit];
        };
        closeDialog 0;
    };
    case "CreateCrate": 
    {
        createVehicle ["NAF_Crate_Medium",(getPos Player)];
    };
    case "MedicPack": 
    {
        _lt_Loadout = getMissionConfigValue ["LT_Loadout_ID","BASE"];
        _loadout = switch (_lt_Loadout) do 
        {
            case "BASE":{0};
            case "GM":{1};
            case "VN":{2};
            case "40K":{3};
        };
        _itemsPackMedic = [_loadout, "Medic"] call LT_fnc_gearItems;
        _itemsPackMedicAmt = [_loadout, "MedicAmt"] call LT_fnc_gearItems;
        _backpack = createVehicle ["NAF_TacticalPack_blk",(getPos Player)];
        {
			_backpack addItemCargoGlobal [_x, _itemsPackMedicAmt select _forEachIndex];
		}forEach _itemsPackMedic;
    };
    case "JTACPack": 
    {
        _backpackJTAC = "";
        if (isClass(configFile >> "CfgPatches" >> "BB_RQ11B_Raven")) then 
        {
            _backpackJTAC = "BB_RQ11B_Backpack";
        }else
        {
            switch (side player) do 
            {
                case west: {_backpackJTAC = "B_UAV_01_backpack_F"};
                case east: {_backpackJTAC = "O_UAV_01_backpack_F"};
                case resistance: {_backpackJTAC = "I_UAV_01_backpack_F"};
            };
	    };
        createVehicle [_backpackJTAC,(getPos Player)];
    };
    case "lvdwFlag":
    {
        {
            _role = _x getVariable ["LT_unit_role", "custom"];
            if (_role == "lvdw") then 
            {
                _x ForceFlagTexture "";
            };
        }forEach allPlayers;
    };
};
