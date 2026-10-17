/*
    File: fn_leadSpeedControl.sqf
    Original author: negas (external convoy module)
    Adapted by: Lowlands Tactical

    Description:
    Controls the speed of the lead vehicle. The lead vehicle slows down when the
    convoy is stretched, when it takes curves and when the speed differences
    inside the convoy are large. Runs until convoy_terminate is set on the lead
    vehicle. Has to be spawned (uses sleep).

    Parameters:
    0: OBJECT - Convoy module logic (holds the module attributes)
    1: ARRAY  - Convoy vehicles, lead vehicle first

    Return:
    None
*/
private [
    "_leaderVeh","_convoyLength","_maxDefSpeed","_convSeparation","_speedFrequecy","_debugDraw",
    "_dampingCoeff","_curvatureCoeff","_stiffnessCoeff","_followRoad","_speedMode","_arrayDistances",
    "_arrayRotations","_arraySpeeds","_avrDistance","_convoyRelaxation","_convoyCurvature","_convoyEntropy",
    "_maxSpeed","_vehicle","_vehicleInFront"
];
params [["_logic", objNull, [objNull]], ["_groupVehicles", [], [[]]]];

if (_groupVehicles isEqualTo []) exitWith {};

_leaderVeh = _groupVehicles select 0;
_convoyLength = count _groupVehicles;

while {!(_leaderVeh getVariable ["convoy_terminate", false])} do
{
    _maxDefSpeed = _logic getVariable ["maxSpeed", -1];
    _convSeparation = _logic getVariable ["convSeparation", -1];
    _speedFrequecy = _logic getVariable ["speedFrequecy", -1];
    _debugDraw = _logic getVariable ["debug", false];
    _dampingCoeff = _logic getVariable ["dampingCoeff", -1];
    _curvatureCoeff = _logic getVariable ["curvatureCoeff", -1];
    _stiffnessCoeff = _logic getVariable ["stiffnessCoeff", -1];
    _followRoad = _logic getVariable ["followRoad", "UNCHANGED"];
    _speedMode = _logic getVariable ["speedModeConv", "NORMAL"];

    switch (_followRoad) do
    {
        case "NO":  { _leaderVeh forceFollowRoad false; };
        case "YES": { _leaderVeh forceFollowRoad true; };
        default {};
    };
    (group _leaderVeh) setSpeedMode _speedMode;

    _arrayDistances = [];
    _arrayRotations = [];
    _arraySpeeds = [];
    for "_i" from 1 to (_convoyLength - 1) do
    {
        _vehicle = _groupVehicles select _i;
        _vehicleInFront = _groupVehicles select (_i - 1);
        _arrayDistances set [(_i - 1), (_vehicle distance _vehicleInFront)];
        _arrayRotations set [(_i - 1), (abs ((getDir _vehicle) - (getDir _vehicleInFront)))];
        _arraySpeeds set [(_i - 1), (abs ((speed _vehicle) - (speed _vehicleInFront)))];
    };

    _avrDistance = 0;
    _convoyRelaxation = 0;
    _convoyCurvature = 0;
    _convoyEntropy = 0;

    if ((count _arrayDistances) > 0) then
    {
        _avrDistance = _arrayDistances call BIS_fnc_arithmeticMean;
        _convoyRelaxation = [_avrDistance - _convSeparation, 0, 100000] call BIS_fnc_clamp;
        _convoyCurvature = _arrayRotations call BIS_fnc_arithmeticMean;
        _convoyEntropy = _arraySpeeds call BIS_fnc_arithmeticMean;
    };

    _maxSpeed = 0;
    if (_maxDefSpeed > 0) then
    {
        _maxSpeed = _maxDefSpeed - ([
            (_stiffnessCoeff * (_convoyRelaxation ^ 1.5))
            + (_curvatureCoeff * ([_convoyCurvature, 0, 45] call BIS_fnc_clamp))
            + (_dampingCoeff * _convoyEntropy),
            0,
            (_maxDefSpeed - 5)
        ] call BIS_fnc_clamp);
    };

    if ((_maxDefSpeed > 0) && (!(_leaderVeh getVariable ["convoy_stopped", false]))) then
    {
        _leaderVeh forceSpeed -1;
        _leaderVeh limitSpeed _maxSpeed;
    }
    else
    {
        _leaderVeh forceSpeed 0;
    };

    if (_debugDraw) then
    {
        hint format ["maxSpeed = %1 \n avrDistance = %2 \n _convoyCurvature = %3 \n _convoyEntropy = %4", _maxSpeed, _avrDistance, _convoyCurvature, _convoyEntropy];
    };

    sleep _speedFrequecy;
};

["Convoy", "Lead speed control stopped", 2] call LT_fnc_log;
