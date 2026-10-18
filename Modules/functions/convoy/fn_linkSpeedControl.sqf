/*
    File: fn_linkSpeedControl.sqf
    Original author: negas (external convoy module)
    Adapted by: Lowlands Tactical

    Description:
    Controls the speed of every following vehicle relative to the vehicle in
    front of it, so the convoy keeps its separation distance. Runs until
    convoy_terminate is set on the lead vehicle. Has to be spawned (uses sleep).

    Parameters:
    0: OBJECT - Convoy module logic (holds the module attributes)
    1: ARRAY  - Convoy vehicles, lead vehicle first

    Return:
    None
*/
private [
    "_leaderVeh","_convoyLength","_convSeparation","_speedFrequecy","_stiffnessLinkCoeff","_speedMode",
    "_vehicle","_vehicleInFront","_distLink","_linkRelaxation","_linkSign","_linkSpeed"
];
params [["_logic", objNull, [objNull]], ["_groupVehicles", [], [[]]]];

if (_groupVehicles isEqualTo []) exitWith {};

_leaderVeh = _groupVehicles select 0;
_convoyLength = count _groupVehicles;

while {!(_leaderVeh getVariable ["convoy_terminate", false])} do
{
    _convSeparation = _logic getVariable ["convSeparation", -1];
    _speedFrequecy = _logic getVariable ["speedFrequecy", -1];
    _stiffnessLinkCoeff = _logic getVariable ["stiffnessLinkCoeff", -1];
    _speedMode = _logic getVariable ["speedModeConv", "NORMAL"];

    for "_i" from 1 to (_convoyLength - 1) do
    {
        _vehicle = _groupVehicles select _i;
        _vehicleInFront = _groupVehicles select (_i - 1);
        (group _vehicle) setSpeedMode _speedMode;

        _distLink = (position _vehicle) distance (position _vehicleInFront);
        _linkRelaxation = _distLink - _convSeparation;

        // Sign of the relaxation without dividing by it (no division by zero when the distance equals the separation)
        _linkSign = [-1, 1] select (_linkRelaxation >= 0);
        _linkSpeed = [
            (speed _vehicleInFront) + (_stiffnessLinkCoeff * _linkSign * ((abs _linkRelaxation) ^ 1.5)),
            0,
            100000
        ] call BIS_fnc_clamp;

        if (!(_leaderVeh getVariable ["convoy_stopped", false])) then
        {
            _vehicle forceSpeed -1;
            _vehicle limitSpeed _linkSpeed;
        }
        else
        {
            _vehicle forceSpeed 0;
        };
        _vehicle forceFollowRoad false;
    };

    sleep _speedFrequecy;
};

["Convoy", "Link speed control stopped", 2] call LT_fnc_log;
