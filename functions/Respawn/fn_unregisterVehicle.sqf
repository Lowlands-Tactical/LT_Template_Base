// Server-only removal. Retain a live object's record for native replacement events.
params ["_vehicle"];
if (!isServer) exitWith {};
{
    if ((_x select 0) == _vehicle && {(_x select 3) isNotEqualTo []}) then {
        (_x select 3) call BIS_fnc_removeRespawnPosition;
        _x set [3, []];
    };
} forEach LTR_vehicleRecords;
