// Read Eden metadata before LT's potentially delayed cargo/respawn initialization.
params ["_vehicle"];
private _side = _vehicle getVariable ["LTR_respawnSide", _vehicle getVariable ["LT_veh_side", ""]];
if (_side isEqualType "") then {
    _side = switch (toUpper _side) do {
        case "WEST": {west}; case "EAST": {east}; case "GUER": {resistance}; case "CIV": {civilian}; default {sideUnknown};
    };
};
if (!(_side isEqualType sideUnknown) || {_side == sideUnknown}) then {
    _side = [east, west, resistance, civilian] param [getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "side"), civilian];
};
private _name = _vehicle getVariable ["LTR_respawnName", ""];
if (_name == "") then {_name = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName")};
[_vehicle getVariable ["LTR_respawnVehicle", false], _side, _name]
