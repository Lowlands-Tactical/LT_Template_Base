/*

File: BriefingDebug.sqf
Author: Brainless_Ben

Description:
Marks al the triggers on de map and intended for debug purpace

Example:
[] execVM "\lt_template_base\Scripts\BriefingDebug.sqf";

*/

Diag_log "[LT] (BriefingDebug) Briefing TriggerReveal Start";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (BriefingDebug) Briefing TriggerReveal Start";
};
if ("lt_debug" call bis_fnc_getParamValue == 0) exitWith 
{
    Diag_log "[LT] (BriefingDebug) Debug OFF no trigger";
    Diag_log "[LT] (BriefingDebug) Briefing TriggerReveal Finish";
};

// DEBUG BRIEFING
_briefing ="<br/><font color='#FFBA26' size='18'>DEBUG SECTION</font><br/>This briefing section can only be seen when debug is enabled.<br/><br/>";

// REVEAL ALL TRIGGERS
private ["_allTriggers"];
_allTriggers = allMissionObjects "EmptyDetector";
{
    //SKIP MAP TRIGGER
    if (typeOf (synchronizedObjects _x select 0) isEqualTo "LocationArea_F") exitWith {};

    //SETUP FOR SCRIPT
    _trigName = VehicleVarName _x;
    _trigType = triggerType _x;
    _trigAct = triggerActivation _x;
    _trigState = triggerStatements _x;
    _trigArea = triggerArea _x;
    _trigSizeX = _trigArea select 0;
    _trigSizeY = _trigArea select 1;
    _trigDir = _trigArea select 2;
    _trigRectangle = _trigArea select 3;

    _mkrCntVar = "BriefingDebug" + "_counter";
    _mkrCnt = if (isnil _mkrCntVar) then {-1} else {missionNameSpace getVariable _mkrCntVar};
    _mkrCnt = _mkrCnt + 1;
    _mkrName = format["TrigMarker_%1", _mkrCnt];
    missionNameSpace setVariable [_mkrCntVar, _mkrCnt];

    //CREATE NAMED MARKERS
    _titel = format["%1 - %2",_mkrName, _trigName];
    _mkr = createMarkerLocal [_mkrName, getPos _x];
    _mkr setMarkerTypeLocal "EmptyIcon";
    _mkr setMarkerTextLocal _titel;
    _mkr setMarkerShapeLocal "ICON";
    _mkr setMarkerColorLocal "ColorBlue";
    _mkr;

    //CREATE AREA MARKERS SIZE OF TRIGGER
    if (_trigSizeX > 0 && _trigSizeY > 0) then 
    {
        _mkrSize = createMarkerLocal [_mkrName + "Size", getPos _x];
        _mkrSize setMarkerTypeLocal "Empty";
        _mkrSize setMarkerTextLocal _titel;
        if (_trigRectangle == true) then
        {
            _mkrSize setMarkerShapeLocal "RECTANGLE";
        } else {
            _mkrSize setMarkerShapeLocal "ELLIPSE";
        };
        _mkrSize setMarkerSizeLocal [_trigSizeX,_trigSizeY];
        _mkrSize setMarkerDirLocal (_trigDir);
        _mkrSize setMarkerBrushLocal "DiagGrid";
        _mkrSize setMarkerColorLocal "ColorBlue";
        _mkrSize;
    };

    //ADD TRIGGER INFO TO BRIEFING SECTION
    _briefing = _briefing + format
    [
        "<br/><font color='#FFBA26' size='14'>Trigger: %1</font><br/>
        Trigger Name:<br/>
        %2<br/>
        Trigger Type:<br/>
        %3<br/>
        Trigger Activation<br/>
        %4<br/><br/>
        Trigger Statements:<br/>
        Condition:<br/>
        %5<br/>
        OnActivation<br/>
        %6<br/>
        OnDeactivation<br/>
        %7<br/><br/>",
        _mkrName,_trigName,_trigType,_trigAct,_trigState select 0,_trigState select 1,_trigState select 2
    ];
}forEach _allTriggers;

// CREATE DIARY Entry
player createDiaryRecord ["Diary", ["H3 Debug Menu", _briefing]];

Diag_log "[LT] (BriefingDebug) Briefing TriggerReveal Finish";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (BriefingDebug) Briefing TriggerReveal Finish";
};
