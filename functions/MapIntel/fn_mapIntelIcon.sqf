/*
    NATO symbol classification adapted from teamMapIntel.sqf.
    Preserve its precedence: support, naval and air override ground symbols.
    Return the texture required by drawIcon, rather than a native group icon.
*/
params ["_group", "_members"];
private _prefix = switch (side _group) do {
    case west: {"b_"};
    case east: {"o_"};
    case independent: {"n_"};
    default {""};
};
private _type = "unknown";
private _vehicles = [];
private _types = [];
private _supportTypes = [];
{
    private _vehicle = vehicle _x;
    if (_vehicle isEqualTo _x) then {
        _types pushBackUnique "inf";
    } else {
        if (!(_vehicle in _vehicles) && {alive _vehicle}) then {
            _vehicles pushBack _vehicle;
            private _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
            if (_vehicle isKindOf "Car") then {_types pushBackUnique "motor_inf";};
            if (_vehicle isKindOf "Tank") then {_types pushBackUnique "armor";};
            if (_vehicle isKindOf "Wheeled_APC_F" || {_vehicle isKindOf "APC_Tracked_01_base_F"} || {_vehicle isKindOf "APC_Tracked_02_base_F"} || {_vehicle isKindOf "APC_Tracked_03_base_F"}) then {_types pushBackUnique "mech_inf";};
            if (getNumber (_config >> "radarType") > 0) then {_types pushBackUnique "antiair";};
            if (getNumber (_config >> "artilleryScanner") > 0 || {_vehicle isKindOf "StaticCannon"}) then {_types pushBackUnique "art";};
            if (_vehicle isKindOf "StaticMortar") then {_types pushBackUnique "mortar";};
            if (getNumber (_config >> "transportAmmo") > 0 || {getNumber (_config >> "transportFuel") > 0}) then {_supportTypes pushBackUnique "support";};
            if (getNumber (_config >> "transportRepair") > 0) then {_supportTypes pushBackUnique "maint";};
            if (getNumber (_config >> "attendant") > 0) then {_supportTypes pushBackUnique "med";};
            if (_vehicle isKindOf "Ship") then {_types pushBackUnique "naval";};
            if (_vehicle isKindOf "Helicopter") then {_types pushBackUnique "air";};
            if (_vehicle isKindOf "Plane") then {_types pushBackUnique "plane";};
            if (_vehicle in allUnitsUAV) then {_types pushBackUnique "uav";};
        };
    };
} forEach _members;
if (count _supportTypes > 1) then {_supportTypes = ["support"];};
_types append _supportTypes;
{
    if (_x in _types) then {_type = _x;};
} forEach ["inf", "motor_inf", "armor", "mech_inf", "antiair", "art", "mortar", "support", "maint", "med", "naval", "air", "plane", "uav"];
private _texture = getText (configFile >> "CfgMarkers" >> (_prefix + _type) >> "icon");
if (_texture isEqualTo "") then {
    _texture = getText (configFile >> "CfgMarkers" >> "mil_unknown" >> "icon");
};
_texture
