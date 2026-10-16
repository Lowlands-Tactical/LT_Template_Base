// Reconcile only registered points. No global vehicle scan or FRED array matching.
if (!isServer) exitWith {};
isNil {
    {
        private _vehicle = _x select 0;
        if (isNull _vehicle || {!alive _vehicle} || {!(_vehicle getVariable ["LTR_respawnVehicle", false])}) then {
            [_vehicle] call LTRespawn_fnc_unregisterVehicle;
        } else {
            [_vehicle] call LTRespawn_fnc_registerVehicle;
        };
    } forEach LTR_vehicleRecords;
    LTR_vehicleRecords = LTR_vehicleRecords select {!isNull (_x select 0)};
};
