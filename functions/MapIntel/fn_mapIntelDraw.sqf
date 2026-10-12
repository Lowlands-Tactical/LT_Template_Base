/* Draw live leader positions. Only main icons are eligible for group tooltips. */
disableSerialization;
params ["_map"];
if (!visibleMap || {!LT_mapIntel_visible} || {isNull player}) exitWith {
    [_map, grpNull] call LT_fnc_mapIntelTooltip;
};
private _mouse = getMousePosition;
private _icons = [];
private _hover = -1;
private _nearest = 1;
{
    _x params ["_group", "_leader", "_ftl", "_icon", "_ftlIcon", "_color"];
    if (!isNull _group && {side _group isEqualTo side group player}) then {
        // Leadership may change between the one-second discovery updates.
        _leader = leader _group;
        {
            _x params ["_unit", "_texture", "_isFTL"];
            if (!isNull _unit && {alive _unit} && {group _unit isEqualTo _group} && {!_isFTL || {!(_unit isEqualTo _leader) && {(_unit getVariable ["LT_unit_role", ""]) isEqualTo "ftl"}}}) then {
                private _position = getPosWorldVisual (vehicle _unit);
                private _screen = _map ctrlMapWorldToScreen _position;
                private _label = groupId _group;
                // A solo FTL can also be the actual group leader. Keep one
                // main icon, but retain the role suffix on that icon's label.
                if (_isFTL || {(_unit getVariable ["LT_unit_role", ""]) isEqualTo "ftl"}) then {
                    _label = _label + " VTL";
                };
                _icons pushBack [_texture, _color, _position, _label, _group, _isFTL];
                // Hit test in screen pixels, independent of map zoom/aspect.
                if (count _screen isEqualTo 2) then {
                    private _dx = abs ((_screen select 0) - (_mouse select 0)) / (16 * pixelW);
                    private _dy = abs ((_screen select 1) - (_mouse select 1)) / (16 * pixelH);
                    private _distance = _dx max _dy;
                    // Later (FTL) icon wins a tie: it never reveals group info.
                    if (_distance <= _nearest) then {_nearest = _distance; _hover = count _icons - 1;};
                };
            };
        } forEach [[_leader, _icon, false], [_ftl, _ftlIcon, true]];
    };
} forEach LT_mapIntel_records;

private _hoverGroup = grpNull;
{
    _x params ["_texture", "_color", "_position", "_label", "_group", "_isFTL"];
    private _size = 24;
    if (_forEachIndex isEqualTo _hover && {!_isFTL}) then {
        _size = _size * 1.25;
        _hoverGroup = _group;
    };
    _map drawIcon [_texture, _color, _position, _size, _size, 0, _label, 0, 0.035, "PuristaMedium", "right"];
} forEach _icons;
[_map, _hoverGroup] call LT_fnc_mapIntelTooltip;
