/* Map UI adapted from Team Map Intel: tooltip panels and visibility checkbox. */
disableSerialization;

private ["_oldMap","_display","_tooltip","_frame","_control","_panels","_panel","_checkbox"];
params ["_map"];

_oldMap = uiNamespace getVariable ["LT_mapIntel_map", controlNull];
if (!isNull _oldMap) then {
    _oldMap ctrlRemoveEventHandler ["Draw", _oldMap getVariable ["LT_mapIntel_drawEH", -1]];
    {ctrlDelete _x;} forEach (_oldMap getVariable ["LT_mapIntel_controls", []]);
};
uiNamespace setVariable ["LT_mapIntel_map", _map];
_display = ctrlParent _map;
_tooltip = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_tooltip ctrlSetPosition [0, 0, 0.4625, 0.34];
_tooltip ctrlCommit 0;
// Match Markersplus's palette locally, without requiring its addon.
// Create the frame first so the content controls draw above it.
_frame = [];
{
    _control = _display ctrlCreate ["RscText", -1, _tooltip];
    _control ctrlSetText "";
    _control ctrlSetBackgroundColor _x;
    _frame pushBack _control;
} forEach [
    [0.07, 0.08, 0.09, 0.98],
    [0.28, 0.30, 0.32, 1],
    [0.28, 0.30, 0.32, 1],
    [0.28, 0.30, 0.32, 1],
    [0.28, 0.30, 0.32, 1]
];
_map setVariable ["LT_mapIntel_frame", _frame];
_panels = [];
{
    _x params ["_position", "_background"];
    _panel = _display ctrlCreate ["RscStructuredText", -1, _tooltip];
    _panel ctrlSetPosition _position;
    _panel ctrlSetBackgroundColor _background;
    _panel ctrlCommit 0;
    _panels pushBack _panel;
} forEach [
    [[0.0125, 0.02, 0.4375, 0.04], [0.07, 0.08, 0.09, 0.98]],
    [[0.0125, 0.06, 0.4375, 0.1], [0.10, 0.11, 0.12, 1]],
    [[0.0125, 0.18, 0.4375, 0.04], [0.07, 0.08, 0.09, 0.98]],
    [[0.0125, 0.22, 0.4375, 0.1], [0.10, 0.11, 0.12, 1]]
];
_tooltip ctrlShow false;
_map setVariable ["LT_mapIntel_tooltip", _tooltip];
_map setVariable ["LT_mapIntel_panels", _panels];

_checkbox = _display ctrlCreate ["RscCheckbox", -1];
_checkbox ctrlSetPosition [0.965937 * safezoneW + safezoneX, 0.948 * safezoneH + safezoneY, 0.018125 * safezoneW, 0.0336666 * safezoneH];
_checkbox cbSetChecked LT_mapIntel_visible;
_checkbox ctrlSetTooltip (["Show Unit Markers: OFF", "Show Unit Markers: ON"] select LT_mapIntel_visible);
_checkbox ctrlSetBackgroundColor [0.07, 0.08, 0.09, 0.98];
_checkbox ctrlCommit 0;
_checkbox ctrlAddEventHandler ["CheckedChanged", {
    disableSerialization;
    params ["_control", "_checked"];
    LT_mapIntel_visible = _checked isEqualTo 1;
    _control ctrlSetTooltip (["Show Unit Markers: OFF", "Show Unit Markers: ON"] select LT_mapIntel_visible);
    if (LT_mapIntel_visible) then {
        [] call LT_fnc_mapIntelUpdate;
    } else {
        [uiNamespace getVariable ["LT_mapIntel_map", controlNull], grpNull] call LT_fnc_mapIntelTooltip;
    };
}];
_map setVariable ["LT_mapIntel_controls", [_tooltip, _checkbox]];
_map setVariable ["LT_mapIntel_drawEH", _map ctrlAddEventHandler ["Draw", {_this call LT_fnc_mapIntelDraw;}]];
