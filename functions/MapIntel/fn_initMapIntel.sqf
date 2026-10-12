/*
    Client-only player group markers. Also called by the legacy QS entry point.
    No mission attributes or unit init lines are required. Missing FTL metadata
    simply means the group has one marker. CBA is already a mod dependency.
*/
if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["LT_mapIntel_started", false]) exitWith {};
if (["lt_markers", 1] call BIS_fnc_getParamValue != 1) exitWith {};
disableSerialization;

LT_mapIntel_started = true;
LT_mapIntel_visible = true;
LT_mapIntel_records = [];
uiNamespace setVariable ["LT_mapIntel_map", controlNull];

// Eden variables are not explicitly copied by the existing respawn script.
// Preserve the role only on the new unit's owner, without overriding a role
// another loadout/respawn system has already supplied.
LT_mapIntel_respawnEH = addMissionEventHandler ["EntityRespawned", {
    params ["_unit", "_corpse"];
    if (!local _unit || {!(_unit isKindOf "CAManBase")}) exitWith {};
    if (isNil {_unit getVariable "LT_unit_role"}) then {
        private _role = _corpse getVariable ["LT_unit_role", "custom"];
        _unit setVariable ["LT_unit_role", _role, true];
    };
}];

// No briefing-state wait: this also works for JIP and single player.
// Refresh on opening rather than waiting for the next one-second update.
LT_mapIntel_mapEH = addMissionEventHandler ["Map", {
    [] call LT_fnc_mapIntelUpdate;
}];
LT_mapIntel_updatePFH = [{[] call LT_fnc_mapIntelUpdate;}, 1] call CBA_fnc_addPerFrameHandler;
diag_log "[LT] (MapIntel) Player group marker system initialized";
