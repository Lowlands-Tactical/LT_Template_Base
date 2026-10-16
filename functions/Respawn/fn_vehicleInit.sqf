// Vehicle points work in native and LTR mode. Legacy mission copies own their lifecycle.
if (!(missionNamespace getVariable ["LTR_addonOwned", false]) || {!isServer} || {missionNamespace getVariable ["LTR_vehicleStarted", false]}) exitWith {};
LTR_vehicleStarted = true;
addMissionEventHandler ["EntityRespawned", {
    params ["_new", "_old"];
    if (_new isKindOf "CAManBase") exitWith {};
    private _known = !isNull _old && {LTR_vehicleRecords findIf {(_x select 0) == _old} >= 0};
    if (_known && {!(_old getVariable ["LTR_respawnVehicle", true])}) exitWith {
        _new setVariable ["LTR_respawnVehicle", false, true];
        [_old] call LTRespawn_fnc_unregisterVehicle;
    };
    if (_known) then {[_new, sideUnknown, "", _old] call LTRespawn_fnc_registerVehicle} else {
        if (_new getVariable ["LTR_respawnVehicle", false]) then {[_new] call LTRespawn_fnc_registerVehicle};
    };
}];
addMissionEventHandler ["EntityKilled", {
    params ["_vehicle"];
    [_vehicle] call LTRespawn_fnc_unregisterVehicle;
}];
addMissionEventHandler ["EntityDeleted", {
    params ["_vehicle"];
    [_vehicle] call LTRespawn_fnc_unregisterVehicle;
}];
[] spawn {
    // Eden attributes and mission object Init fields must have run before discovery.
    waitUntil {sleep 0.1; time > 0};
    {
        if (_x getVariable ["LTR_respawnVehicle", false]) then {[_x] call LTRespawn_fnc_registerVehicle};
    } forEach vehicles;
    while {true} do {[] call LTRespawn_fnc_vehicleUpdate; sleep 1};
};
