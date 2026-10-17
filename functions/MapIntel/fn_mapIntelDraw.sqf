/*
    File: fn_mapIntelDraw.sqf
    Author: Lowlands Tactical

    Description:
    Draw live leader positions. Only main icons are eligible for group tooltips.
    Runs every frame from the map Draw event handler, so it does not log.

    Parameters:
    0: CONTROL - Map control

    Return:
    None
*/
disableSerialization;

private ["_mouse","_icons","_hover","_nearest","_position","_screen","_label","_dx","_dy","_distance","_hoverGroup","_size","_isFtlUnit"];
params ["_map"];

if ((!visibleMap) || (!LT_mapIntel_visible) || (isNull player)) exitWith {
    [_map, grpNull] call LT_fnc_mapIntelTooltip;
};
_mouse = getMousePosition;
_icons = [];
_hover = -1;
_nearest = 1;
{
    _x params ["_group", "_leader", "_ftl", "_icon", "_ftlIcon", "_color"];
    if ((!isNull _group) && ((side _group) isEqualTo (side (group player)))) then {
        // Leadership may change between the one-second discovery updates.
        _leader = leader _group;
        {
            _x params ["_unit", "_texture", "_isFTL"];
            _isFtlUnit = ((_unit getVariable ["LT_unit_role", ""]) isEqualTo "ftl");
            if ((!isNull _unit) && (alive _unit) && ((group _unit) isEqualTo _group) && ((!_isFTL) || ((!(_unit isEqualTo _leader)) && _isFtlUnit))) then {
                _position = getPosWorldVisual (vehicle _unit);
                _screen = _map ctrlMapWorldToScreen _position;
                _label = groupId _group;
                // A solo FTL can also be the actual group leader. Keep one
                // main icon, but retain the role suffix on that icon's label.
                if (_isFTL || _isFtlUnit) then {
                    _label = _label + " VTL";
                };
                _icons pushBack [_texture, _color, _position, _label, _group, _isFTL];
                // Hit test in screen pixels, independent of map zoom/aspect.
                if (count _screen isEqualTo 2) then {
                    _dx = abs ((_screen select 0) - (_mouse select 0)) / (16 * pixelW);
                    _dy = abs ((_screen select 1) - (_mouse select 1)) / (16 * pixelH);
                    _distance = _dx max _dy;
                    // Later (FTL) icon wins a tie: it never reveals group info.
                    if (_distance <= _nearest) then {_nearest = _distance; _hover = count _icons - 1;};
                };
            };
        } forEach [[_leader, _icon, false], [_ftl, _ftlIcon, true]];
    };
} forEach LT_mapIntel_records;

_hoverGroup = grpNull;
{
    _x params ["_texture", "_color", "_position", "_label", "_group", "_isFTL"];
    _size = 24;
    if ((_forEachIndex isEqualTo _hover) && (!_isFTL)) then {
        _size = _size * 1.25;
        _hoverGroup = _group;
    };
    _map drawIcon [_texture, _color, _position, _size, _size, 0, _label, 0, 0.035, "PuristaMedium", "right"];
} forEach _icons;
[_map, _hoverGroup] call LT_fnc_mapIntelTooltip;
