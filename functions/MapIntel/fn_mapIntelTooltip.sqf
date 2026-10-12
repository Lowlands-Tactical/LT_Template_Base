/* Whole-group infantry/vehicle information, only for the main marker. */
disableSerialization;

private ["_tooltip","_mouse","_tooltipPosition","_oldPosition","_footText","_memberCount","_vehicleText","_vehicles","_texture","_name","_color","_vehicle","_panels","_footHeight","_offset","_width","_height","_borderWidth","_borderHeight","_framePositions"];
params ["_map", "_group"];

_tooltip = _map getVariable ["LT_mapIntel_tooltip", controlNull];
if (isNull _tooltip) exitWith {};
if (isNull _group) exitWith {
    if (ctrlShown _tooltip) then {_tooltip ctrlShow false;};
    if (!isNull (_map getVariable ["LT_mapIntel_hoverGroup", grpNull])) then {
        _map setVariable ["LT_mapIntel_hoverGroup", grpNull];
    };
};
_mouse = getMousePosition;
_tooltipPosition = ctrlPosition _tooltip;
_oldPosition = +_tooltipPosition;
_tooltipPosition set [0, ((_mouse select 0) min (safezoneX + safezoneW - (_tooltipPosition select 2))) max safezoneX];
_tooltipPosition set [1, (((_mouse select 1) + 0.05) min (safezoneY + safezoneH - (_tooltipPosition select 3))) max safezoneY];
if (!(_tooltipPosition isEqualTo _oldPosition)) then {
    _tooltip ctrlSetPosition _tooltipPosition;
    _tooltip ctrlCommit 0;
};
if (_group isEqualTo (_map getVariable ["LT_mapIntel_hoverGroup", grpNull]) && {diag_tickTime < (_map getVariable ["LT_mapIntel_tooltipNext", 0])}) exitWith {};
// Showing a controls group also shows its children. Only do this when
// rebuilding the content, then hide empty sections below in the same call.
_tooltip ctrlShow true;
_map setVariable ["LT_mapIntel_hoverGroup", _group];
_map setVariable ["LT_mapIntel_tooltipNext", diag_tickTime + 1];

_footText = "";
_memberCount = 0;
_vehicleText = "";
_vehicles = [];
{
    if (alive _x) then {
        _memberCount = _memberCount + 1;
        // Honour custom ACE nametag icons; otherwise use ACE's unit-type
        // texture resolver. getName returns text safe for structured text.
        _texture = _x getVariable ["ace_nametags_rankIcon", ""];
        if (_texture isEqualTo "") then {_texture = [_x] call ace_common_fnc_getVehicleIcon;};

        _name = [_x] call ace_common_fnc_getName;
        if ((_x getVariable ["LT_unit_role",""]) == "ftl") then {_name = _name + " VTL"};
        _color = switch (assignedTeam _x) do {
            case "MAIN": {'#FFFFFF'};
            case "RED": {'#FFABAB'};
            case "GREEN": {'#ABFFAB'};
            case "YELLOW": {'#FFFFAB'};
            case "BLUE": {'#ABABFF'};
        };
        _footText = _footText + format ["<img image='%1' shadow='0' size='1.2' color='%2' valign='middle'/> %3<br/>", _texture, _color, _name];
        
        _vehicle = vehicle _x;
        if (!(_vehicle isEqualTo _x)) then {
            if (!(_vehicle in _vehicles)) then {
                _vehicles pushBack _vehicle;
                _texture = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "picture");
                _vehicleText = _vehicleText + format ["<img image='%1' shadow='0' size='1.33' valign='middle'/>", _texture];
            };
        };
    };
} forEach units _group;
_panels = _map getVariable ["LT_mapIntel_panels", []];
_panels params ["_footHeader", "_footBody", "_vehicleHeader", "_vehicleBody"];
_footHeader ctrlSetStructuredText parseText "<t font='RobotoCondensedBold' color='#FFBA26' size='1' shadow='0' align='left'>Group Members</t>";
_vehicleHeader ctrlSetStructuredText parseText "<t font='RobotoCondensedBold' color='#FFBA26' size='1' shadow='0' align='left'>Vehicle Intel</t>";
_footBody ctrlSetStructuredText parseText ("<t font='RobotoCondensed' color='#F0F0F0' shadow='0' align='left'><t size='0.1'>&#160;</t><br/>" + _footText + "</t>");
_vehicleBody ctrlSetStructuredText parseText ("<t font='RobotoCondensed' color='#F0F0F0' shadow='0' align='left'><t size='0.5'>&#160;</t><br/>" + _vehicleText + "</t>");
{_x ctrlShow (!(_footText isEqualTo ""));} forEach [_footHeader, _footBody];
{_x ctrlShow (!(_vehicleText isEqualTo ""));} forEach [_vehicleHeader, _vehicleBody];

// Reserve a full row for each icon/name, even if the text-height measurement
// does not include the taller inline icons. Long names can still add height.
_footHeight = (ctrlTextHeight _footBody + 0.02) max (0.04 * _memberCount + 0.02) max 0.1;
_footBody ctrlSetPosition [0.0125, 0.06, 0.4375, _footHeight];
_footBody ctrlCommit 0;
_offset = [0.08 + _footHeight, 0.02] select (_footText isEqualTo "");
_vehicleHeader ctrlSetPosition [0.0125, _offset, 0.4375, 0.04];
_vehicleBody ctrlSetPosition [0.0125, _offset + 0.04, 0.4375, 0.1];
_vehicleHeader ctrlCommit 0;
_vehicleBody ctrlCommit 0;
_tooltipPosition set [3, if (_vehicleText isEqualTo "") then {0.08 + _footHeight} else {_offset + 0.16}];

// Resize the background and thin border with the full, unscrolled roster.
_width = _tooltipPosition select 2;
_height = _tooltipPosition select 3;
_borderWidth = pixelW max 0.001;
_borderHeight = pixelH max 0.001;
_framePositions = [
    [0, 0, _width, _height],
    [0, 0, _width, _borderHeight],
    [0, _height - _borderHeight, _width, _borderHeight],
    [0, 0, _borderWidth, _height],
    [_width - _borderWidth, 0, _borderWidth, _height]
];
{
    _x ctrlSetPosition (_framePositions select _forEachIndex);
    _x ctrlCommit 0;
} forEach (_map getVariable ["LT_mapIntel_frame", []]);
_tooltipPosition set [1, (((_mouse select 1) + 0.05) min (safezoneY + safezoneH - (_tooltipPosition select 3))) max safezoneY];
if (!(_tooltipPosition isEqualTo ctrlPosition _tooltip)) then {
    _tooltip ctrlSetPosition _tooltipPosition;
    _tooltip ctrlCommit 0;
};
