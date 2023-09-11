/*

File: BriefingAdmin.sqf
Author: Brainless_Ben

Description:
Uses the publicvariables in Admin.sqf for the admin section of the briefing.
See Admin.sqf for the list.

*/

lt_admin = missionNameSpace getVariable ["lt_admin", false];
waitUntil {sleep 0.5; !isNil "lt_admin"};

if (lt_admin) then 
{
    // ADMIN BRIEFING
    _briefing ="<br/><font size='18'>ADMIN SECTION</font><br/>This briefing section can only be seen by the current admin.<br/><br/>";

    // Create array of tasks
    _tasks = player call BIS_fnc_tasksUnit;
    diag_log format["[LT] (BriefingAdmin) Taskarray: %1", _tasks];
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemchat format["[LT] (BriefingAdmin) Taskarray: %1", _tasks];
    };

    // Get side of player so taskState will be remoteExec only to that side.
    _side = side player;
    LT_fnc_setTaskState = {
        private ["_taskindex", "_state", "_side", "_taskArray", "_task"];
        _taskindex = _this select 0;
        _state = _this select 1;
        _side = _this select 2;
        _taskArray = player call BIS_fnc_tasksUnit;
        _task = _taskArray select _taskindex;
        [_task, _state, true] remoteExec ['BIS_fnc_tasksetState', _side, true];
    };
    
    // forEach through _tasks and add description of task and the expressions for succeeded and failed in _briefing
    _briefing = _briefing + "<font size='18'>Tasks</font><br/>";
    if (count _tasks > 0) then 
    {
        {
            _taskID = _x;
            _taskindex = (player call BIS_fnc_tasksUnit) find _x;
            _taskDescriptionArray = _taskID call BIS_fnc_taskDescription;
            _taskDescription = _taskDescriptionArray select 1;
            _briefing = _briefing + format 
            [
                "<br/><font size='14'>Task: %2</font><br/>
                Set state to: <executeClose expression=""[%1, 'Succeeded', %3] call LT_fnc_setTaskState;"">'Succeeded'</executeClose> 
                or <executeClose expression=""[%1, 'Failed', %3] call LT_fnc_setTaskState;"">'Failed'</executeClose>
                <br/><br/>",
                _taskindex, _taskDescription, _side
            ];
        } forEach _tasks;
    } else 
    {
        _briefing = _briefing + "   No tasks specified at beginning<br/><br/>";
    };

    // SAFE START SECTION
    _briefing = _briefing + "
    <font size='18'>SAFE START CONTROL</font><br/>
    |- <execute expression=""lt_param_timer = lt_param_timer + 1; publicVariable 'lt_param_timer'; hintSilent format ['Mission timer: %1', lt_param_timer];"">Increase Safe Start timer by 1 minute</execute><br/>
    
    |- <execute expression=""lt_param_timer = lt_param_timer - 1; publicVariable 'lt_param_timer'; hintSilent format ['Mission timer: %1', lt_param_timer];"">Decrease Safe Start timer by 1 minute</execute><br/>
    
    |- <execute expression=""lt_param_timer = 10; publicVariable 'lt_param_timer';['SafeStartmissionStarting',['Mission safety is on!']] call BIS_fnc_showNotification;[true] remoteExec ['LT_fnc_safety',allPlayers];[] remoteExec ['LT_fnc_safeStartLoop'];hintSilent 'Safe Start started!';"">Enable Safe Start timer</execute><br/>
    
    |- <execute expression=""lt_param_timer = -1; publicVariable 'lt_param_timer';['SafeStartmissionStarting',['Mission starting now!']] call BIS_fnc_showNotification;[false] remoteExec ['LT_fnc_safety',allPlayers];hintSilent 'Safe Start ended!';"">Disable Safe Start timer</execute><br/>
    
    <br/>
    ";

    // CREATE DIARY Entry
    player createDiaryRecord ["Diary", ["H3 Admin Menu", _briefing]];
    
    Diag_log "[LT] (BriefingAdmin) briefing finished";
    if ("lt_debug" call bis_fnc_getParamValue == 1) then 
    {
        systemchat "[LT] (BriefingAdmin) briefing finished";
    };
};
