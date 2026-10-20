/*
    File: fn_initConvoy.sqf
    Author: Lowlands Tactical
    Based on: external convoy module (original author/licence: to be added by LT)

    Description:
    Starts the convoy system for a group of vehicles. Server only.
    Starts the driver transition FSM for every vehicle, the dynamic convoy and
    behaviour FSMs, and the speed/path scripts. Also called by the FSM when a
    new convoy has to be created after a vehicle was lost.

    Variables written on the lead vehicle:
    convoy_stopped, convoy_terminate, convoy_behaviourChanged

    Parameters:
    0: OBJECT - Convoy module logic (holds the module attributes)
    1: ARRAY  - Convoy vehicles, lead vehicle first

    Return:
    BOOL - true when the convoy was started
*/
private ["_leaderVeh","_fsmPath"];
params [["_logic", objNull, [objNull]], ["_groupVehicles", [], [[]]]];

if (!isServer) exitWith {false};
if (_groupVehicles isEqualTo []) exitWith {
    ["Convoy", "No vehicles given, convoy not started", 2] call LT_fnc_log;
    false
};

_leaderVeh = _groupVehicles select 0;
_leaderVeh setVariable ["convoy_stopped", false, true];
_leaderVeh setVariable ["convoy_terminate", false, true];
// Note: used to fix some unknown bug with the module (can be set to true on script execution)
_leaderVeh setVariable ["convoy_behaviourChanged", false, true];

_fsmPath = "\lt_template_base\Modules\functions\Convoy\";

// Driver changes system, one FSM per vehicle.
// Writes on each vehicle: driverIncapacitated, vehicleIncapacitated, terminate_driverTransitions
// Reads on each vehicle: terminate_driverTransitions
{
    [_x] execFSM (_fsmPath + "fn_driverTransitions.fsm");
} forEach _groupVehicles;

[_logic, _groupVehicles] execFSM (_fsmPath + "fn_dynamicConvoyElements.fsm");
[_logic, _groupVehicles] execFSM (_fsmPath + "fn_behaviorManager.fsm");

// These loops use sleep, so they have to run scheduled.
[_logic, _groupVehicles] spawn LT_fnc_leadSpeedControl;
[_logic, _groupVehicles] spawn LT_fnc_linkSpeedControl;
[_logic, _groupVehicles] spawn LT_fnc_pathCreator;

["Convoy", format ["Convoy started with %1 vehicles", count _groupVehicles], 2] call LT_fnc_log;

true
