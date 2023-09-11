if !(isServer) exitWith {};
private ["_timeOfDay","_date","_now"];
_timeOfDay = param [0, 24, [24]];

if ( _timeOfDay == 24 ) exitWith {};

_date = date;
_date set [3,_timeOfDay];
_date set [4,0];

[_date,true,false] call BIS_fnc_setDate;
