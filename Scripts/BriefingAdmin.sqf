/*

File: BriefingAdmin.sqf
Author: Brainless_Ben

Description:
Uses the publicvariables in Admin.sqf for the admin section of the briefing.
See Admin.sqf for the list.

*/

if !(hasInterface) exitWith {};

_admin = (getPlayerUID player) in (AdminCrew get "Staff");
if !(_admin OR serverCommandAvailable "kick") exitWith {};

// ADMIN BRIEFING
//Gear/Weapon sets
_side = switch (side player) do
{
    case west:{"blue"};
    case east:{"red"};
    case resistance:{"green"};
};
_camo = "lt_gear_camo_"+_side;
_weap = "lt_gear_weapon_"+_side;

_briefing = "
    <br/><font color='#FFBA26' size='18'>ADMIN SECTION</font>
    <br/>This briefing section can only be seen by the current admin.
";

_briefing = _briefing + format['
    <br/><br/><font color="#FFBA26" size="16">MISSIE PARAMETERS:</font>
    <br/><font color="#D7DBD5">• Periode:</font> %1
    <br/><font color="#D7DBD5">• Fatige:</font> %2
    <br/><font color="#D7DBD5">• Markers:</font> %3
    <br/><font color="#D7DBD5">• Debug:</font> %4
    <br/><font color="#D7DBD5">• Camoflage:</font> %5
    <br/><font color="#D7DBD5">• Weapons:</font> %6
    <br/><font color="#D7DBD5">• Radio Short:</font> %7
    <br/><font color="#D7DBD5">• Radio Long:</font> %8
    <br/><font color="#D7DBD5">• Nightvision:</font> %9
    <br/><font color="#D7DBD5">• Weapon attachments:</font> %10
    <br/><font color="#D7DBD5">• Weapon scope:</font> %11
    <br/><font color="#D7DBD5">• Safety timer:</font> %12
',
    (getMissionConfigValue ["LT_Loadout_ID","BASE"]),
    (getArray (missionConfigFile >> "Params" >> "lt_fatigue_onoff" >> "texts")) select ("lt_fatigue_onoff" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> "lt_markers" >> "texts")) select ("lt_markers" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> "lt_debug" >> "texts")) select ("lt_debug" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> _camo >> "texts")) select (_camo call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> _weap >> "texts")) select (_weap call bis_fnc_getParamValue),
    (if (("lt_gear_SR" call bis_fnc_getParamValue) == 0) then {"Nobody"} else {"Everyone"}),
    (if (("lt_gear_radiopack" call bis_fnc_getParamValue) == 0) then {"Nobody"} else {"Role Specific"}),
    (getArray (missionConfigFile >> "Params" >> "lt_gear_nvg" >> "texts")) select ("lt_gear_nvg" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> "lt_gear_weapon_att" >> "texts")) select ("lt_gear_weapon_att" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> "lt_gear_weapon_scope" >> "texts")) select ("lt_gear_weapon_scope" call bis_fnc_getParamValue),
    (getArray (missionConfigFile >> "Params" >> "lt_param_timer" >> "texts")) select ("lt_param_timer" call bis_fnc_getParamValue)
];


// Create array of tasks
_tasks = player call bis_fnc_tasksUnit;
["BriefingAdmin",format ["Taskarray: %1", _tasks],2] call LT_fnc_log;

// Get side of player so taskState will be remoteExec only to that side.
_side = side player;
LT_fnc_setTaskState = {
    private ["_taskindex", "_state", "_side", "_taskArray", "_task"];
    _taskindex = _this select 0;
    _state = _this select 1;
    _side = _this select 2;
    _taskArray = player call bis_fnc_tasksUnit;
    _task = _taskArray select _taskindex;
    [_task, _state, true] remoteExec ['BIS_fnc_tasksetState', _side, true];
};

// forEach through _tasks and add description of task and the expressions for succeeded and failed in _briefing
_briefing = _briefing + "<br/><br/><font color='#FFBA26' size='18'>TASKS</font>";
if (count _tasks > 0) then 
{
    {
        _taskID = _x;
        _taskindex = (player call bis_fnc_tasksUnit) find _x;
        _taskDescriptionArray = _taskID call bis_fnc_taskDescription;
        _taskDescription = _taskDescriptionArray select 1;
        _briefing = _briefing + format 
        ["
            <br/><font color='#FFBA26' size='14'>Task: %2</font>
            <br/>Set state to: <executeClose expression=""[%1, 'Succeeded', %3] call LT_fnc_setTaskState;"">'Succeeded'</executeClose> 
            or <executeClose expression=""[%1, 'Failed', %3] call LT_fnc_setTaskState;"">'Failed'</executeClose>
        ",
            _taskindex,
            _taskDescription,
            _side
        ];
    } forEach _tasks;
} else 
{
    _briefing = _briefing + "<br/>   No tasks specified at beginning<br/><br/>";
};

// SAFE START SECTION
_briefing = _briefing + "
    <br/><font color='#FFBA26' size='18'>SAFE START CONTROL</font>
    <br/>|- <execute expression=""lt_param_timer = lt_param_timer + 1; publicVariable 'lt_param_timer'; hintSilent format ['Mission timer: %1', lt_param_timer];"">Increase Safe Start timer by 1 minute</execute>
    <br/>|- <execute expression=""lt_param_timer = lt_param_timer - 1; publicVariable 'lt_param_timer'; hintSilent format ['Mission timer: %1', lt_param_timer];"">Decrease Safe Start timer by 1 minute</execute>
    <br/>|- <execute expression=""lt_param_timer = 10; publicVariable 'lt_param_timer';['SafeStartmissionStarting',['Mission safety is on!']] call BIS_fnc_showNotification;[true] remoteExec ['LT_fnc_safety',allPlayers];[] remoteExec ['LT_fnc_safeStartLoop'];hintSilent 'Safe Start started!';"">Enable Safe Start timer</execute>
    <br/>|- <execute expression=""lt_param_timer = -1; publicVariable 'lt_param_timer';['SafeStartmissionStarting',['Mission starting now!']] call BIS_fnc_showNotification;[false] remoteExec ['LT_fnc_safety',allPlayers];hintSilent 'Safe Start ended!';"">Disable Safe Start timer</execute>
    <br/>
";

// CREATE DIARY Entry
player createDiaryRecord ["LT Briefing", ["(Admin) Menu", _briefing]];

["BriefingAdmin","Briefing finished",2] call LT_fnc_log;

_briefing