/* Server API: [vehicle, west, "Mobile base"] call LTRespawn_fnc_registerVehicle.
 * Eden checkboxes use the same API automatically. LT/Arma owns vehicle replacement.
 */
params [["_vehicle", objNull, [objNull]], ["_side", sideUnknown, [sideUnknown]], ["_name", "", [""]], ["_old", objNull, [objNull]]];
if (!isServer || {isNull _vehicle} || {_vehicle isKindOf "CAManBase"}) exitWith {[]};
private _registration = [];
isNil {
    private _index = LTR_vehicleRecords findIf {(_x select 0) == _vehicle || {!isNull _old && {(_x select 0) == _old}}};
    private _record = if (_index < 0) then {[_vehicle, sideUnknown, "", []]} else {LTR_vehicleRecords select _index};
    if (_side == sideUnknown && {!isNull _old}) then {_side = _record select 1};
    if (_name == "" && {!isNull _old}) then {_name = _record select 2};
    if (_side != sideUnknown) then {_vehicle setVariable ["LTR_respawnSide", _side, true]};
    if (_name != "") then {_vehicle setVariable ["LTR_respawnName", _name, true]};
    private _settings = [_vehicle] call LTRespawn_fnc_vehicleSettings;
    _settings params ["_enabled", "_resolvedSide", "_resolvedName"];
    private _id = _record select 3;
    if (_id isNotEqualTo [] && {(_record select 0) != _vehicle || {(_record select 1) != _resolvedSide} || {(_record select 2) != _resolvedName}}) then {
        _id call BIS_fnc_removeRespawnPosition;
        _id = [];
    };
    _vehicle setVariable ["LTR_respawnVehicle", true, true];
    _vehicle setVariable ["LTR_respawnName", _resolvedName, true];
    if (_id isEqualTo [] && {alive _vehicle}) then {_id = [_resolvedSide, _vehicle, _resolvedName] call BIS_fnc_addRespawnPosition};
    _record set [0, _vehicle];
    _record set [1, _resolvedSide];
    _record set [2, _resolvedName];
    _record set [3, _id];
    if (_index < 0) then {LTR_vehicleRecords pushBack _record};
    _registration = _id;
};
_registration
