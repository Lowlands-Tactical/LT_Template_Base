/*

File: BriefingDebug.sqf
Author: Brainless_Ben

Description:
Marks al the triggers on de map and intended for debug purpace

Example:
[] execVM "\lt_template_base\Scripts\BriefingDebug.sqf";

*/

_showTriggers = missionnameSpace getVariable "LT_Debug_Triggers";
if (isNil "_showTriggers") then 
{
    // DEBUG BRIEFING
    _briefing ="
        <br/><font color='#FFBA26' size='18'>DEBUG SECTION</font>
        <br/><font color='#D7DBD5'>This briefing section can only be seen when debug is enabled. </font>
        <br/><br/>
    ";

    // REVEAL ALL TRIGGERS
    private ["_allTriggers"];
    _allTriggers = allMissionObjects "EmptyDetector";

    _triggerArray = [];
    {
        if !("MAP" in (VehicleVarName _x)) then
        {
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

            _mkrCntVar = "BriefingDebug" + str _forEachIndex;
            _mkrCnt = if (isnil _mkrCntVar) then {_forEachIndex} else {missionNameSpace getVariable _mkrCntVar};
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

            _triggerArray pushBack _mkr;

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

                _triggerArray pushBack _mkrSize;
            };

            //ADD TRIGGER INFO TO BRIEFING SECTION
            _briefing = _briefing + format ["
                <br/><font color='#FFBA26'>Trigger: </font> %1
                <br/><font color='#D7DBD5'>Name: </font> %2
                <br/><font color='#D7DBD5'>Type: </font> %3
                <br/><font color='#D7DBD5'>Activation: </font> %4
                <br/><font color='#D7DBD5'>Condition: </font>
                <br/>%5
                <br/><font color='#D7DBD5'>OnActivation: </font>
                <br/>%6
                <br/><font color='#D7DBD5'>OnDeactivation: </font>
                <br/>%7
                <br/>
            ",
                "<marker name='"+_mkrName+"'>"+_mkrName+" (Klik)</marker>",
                _trigName,
                _trigType,
                _trigAct,
                _trigState select 0,
                _trigState select 1,
                _trigState select 2
            ];
        };
    }forEach _allTriggers;

    // CREATE DIARY Entry
    _debugBriefing = player createDiaryRecord ["LT Briefing", ["(Debug) Menu", _briefing]];

    // CREATE MissionnameSpace Variable
    missionNamespace setVariable ["LT_Debug_Triggers", _triggerArray, true];
    missionNamespace setVariable ["LT_Debug_Briefing", _debugBriefing, true];
}else 
{
    {
        deleteMarkerLocal _x;
    }forEach _showTriggers;

    _debugBrief = missionNamespace getVariable "LT_Debug_Briefing";
    player removeDiaryRecord ["LT Briefing", _debugBrief];

    missionNamespace setVariable ["LT_Debug_Triggers", nil, true];
    missionNamespace setVariable ["LT_Debug_Briefing", nil, true];
};

Diag_log "[LT] (BriefingDebug) Briefing TriggerReveal Finish";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
    systemChat "[LT] (BriefingDebug) Briefing TriggerReveal Finish";
};
