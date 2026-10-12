/* Reconcile current groups/roles once a second; positions are drawn live. */
disableSerialization;
if (isNull player) exitWith {};

// Keep display discovery running, but only reconcile groups while visible.
private _map = (findDisplay 12) displayCtrl 51;
private _trackedMap = uiNamespace getVariable ["LT_mapIntel_map", controlNull];
if (!isNull _map && {!(_map isEqualTo _trackedMap)}) then {
    [_map] call LT_fnc_mapIntelUI;
};
if (!visibleMap || {!LT_mapIntel_visible}) exitWith {
    if (!isNull _map) then {[_map, grpNull] call LT_fnc_mapIntelTooltip;};
};

private _groups = [];
{
    if (isPlayer _x && {!(_x isKindOf "HeadlessClient_F")}) then {
        private _group = group _x;
        if (!isNull _group && {side _group isEqualTo side group player}) then {
            _groups pushBackUnique _group;
        };
    };
} forEach allPlayers;
// allPlayers can be empty during single-player initialization.
if (isPlayer player) then {_groups pushBackUnique group player;};

private _previous = missionNamespace getVariable ["LT_mapIntel_records", []];
private _records = [];
{
    private _group = _x;
    private _members = (units _group) select {alive _x};
    if (!(_members isEqualTo [])) then {
        private _leader = leader _group;
        private _candidates = _members select {
            !(_x isEqualTo _leader) && {(_x getVariable ["LT_unit_role", ""]) isEqualTo "ftl"}
        };
        private _ftl = objNull;
        private _index = _previous findIf {(_x select 0) isEqualTo _group};
        if (_index >= 0) then {_ftl = (_previous select _index) select 2;};
        if (!(_ftl in _candidates)) then {_ftl = _candidates param [0, objNull];};
        private _icon = [_group, _members] call LT_fnc_mapIntelIcon;
        private _color = [side _group, false] call BIS_fnc_sideColor;
        // [group, leader, FTL, main texture, FTL texture, side color]
        private _ftlIcon = if (isNull _ftl) then {""} else {[_group, [_ftl]] call LT_fnc_mapIntelIcon};
        _records pushBack [_group, _leader, _ftl, _icon, _ftlIcon, _color];
    };
} forEach _groups;
LT_mapIntel_records = _records;
