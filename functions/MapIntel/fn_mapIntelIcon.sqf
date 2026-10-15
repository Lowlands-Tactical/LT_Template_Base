/*
    NATO symbol classification adapted from teamMapIntel.sqf.
    Preserve its precedence: support, naval and air override ground symbols.
    Return the texture required by drawIcon, rather than a native group icon.
*/
private ["_prefix","_type","_vehicles","_types","_supportTypes","_vehicle","_config","_texture"];
params ["_group", "_members"];

_prefix = switch (side _group) do {
    case west: {"b_"};
    case east: {"o_"};
    case independent: {"n_"};
    default {""};
};
_type = "unknown";
_vehicles = [];
_types = [];
_supportTypes = [];
{
    _vehicle = vehicle _x;
    if (_vehicle isEqualTo _x) then {
        _types pushBackUnique "inf";
    } else {
        if (!(_vehicle in _vehicles) && {alive _vehicle}) then {
            _vehicles pushBack _vehicle;
            _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
            switch true do {
                case (_vehicle isKindOf "Car"): {_types pushBackUnique "motor_inf"};
                case (_vehicle isKindOf "Tank"): {_types pushBackUnique "armor"};
                case (_vehicle isKindOf "Wheeled_APC_F");
                case (_vehicle isKindOf "APC_Tracked_01_base_F");
                case (_vehicle isKindOf "APC_Tracked_02_base_F");
                case (_vehicle isKindOf "APC_Tracked_03_base_F"): {_types pushBackUnique "mech_inf"};
                case (_vehicle isKindOf "StaticMortar"): {_types pushBackUnique "mortar"};
                case (_vehicle isKindOf "Ship"): {_types pushBackUnique "naval"};
                case (_vehicle isKindOf "Helicopter"): {_types pushBackUnique "air"};
                case (_vehicle isKindOf "Plane"): {_types pushBackUnique "plane"};
                case (_vehicle in allUnitsUAV): {_types pushBackUnique "uav"};
                case (getNumber (_config >> "radarType") > 0): {_types pushBackUnique "antiair"};
                case (_vehicle isKindOf "StaticCannon");
                case (getNumber (_config >> "artilleryScanner") > 0): {_types pushBackUnique "art"};
                case (getNumber (_config >> "transportAmmo") > 0);
                case (getNumber (_config >> "transportFuel") > 0): {_supportTypes pushBackUnique "support"};
                case (getNumber (_config >> "transportRepair") > 0): {_supportTypes pushBackUnique "maint"};
                case (getNumber (_config >> "attendant") > 0): {_supportTypes pushBackUnique "med"};
                //controleer naam markerName
                default {
                    ["MapIntelIcon","Default marker applied",2] call LT_fnc_log;
                    _types pushBackUnique "unkown";
                };
            };
        };
    };
} forEach _members;

if (count _supportTypes > 1) then {_supportTypes = ["support"];};
_types append _supportTypes;
{
    if (_x in _types) then {_type = _x;};
} forEach ["inf", "motor_inf", "armor", "mech_inf", "antiair", "art", "mortar", "support", "maint", "med", "naval", "air", "plane", "uav"];

_texture = getText (configFile >> "CfgMarkers" >> (_prefix + _type) >> "icon");
if (_texture isEqualTo "") then {
    _texture = getText (configFile >> "CfgMarkers" >> "mil_unknown" >> "icon");
};
_texture
