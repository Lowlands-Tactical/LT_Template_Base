/*
    File: fn_pathCreator.sqf
    Original author: negas (external convoy module)
    Adapted by: Lowlands Tactical

    Description:
    Records the path of the lead vehicle and gives every following vehicle the
    part of that path between itself and the vehicle in front (setDriveOnPath).
    When a vehicle stands still and is far behind, it gets a normal move order.
    Optionally draws the paths with arrow objects (module attribute "debug").
    Runs until convoy_terminate is set on the lead vehicle. Has to be spawned.

    Variables written on the lead vehicle (server local):
    lt_convoy_path, convoy_drawObjects

    Parameters:
    0: OBJECT - Convoy module logic (holds the module attributes)
    1: ARRAY  - Convoy vehicles, lead vehicle first

    Return:
    None
*/
private [
    "_leaderVeh","_convoyLength","_ltConvoyPath","_debugDraw","_drawObjects","_pathFrequecy","_vehicleInBack",
    "_itMax","_distBack2wp","_foundCandidate","_chopDistance","_vehiclePathChop","_vehicle","_vehicleInFront",
    "_foundLast","_foundFirst","_lastPoint","_firstPoint","_pathTemp","_wpPosition","_distFront2wp","_iconPos",
    "_arrowTypes"
];
params [["_logic", objNull, [objNull]], ["_groupVehicles", [], [[]]]];

if (_groupVehicles isEqualTo []) exitWith {};

_leaderVeh = _groupVehicles select 0;
_convoyLength = count _groupVehicles;
_chopDistance = 10;
_arrowTypes = ["Sign_Arrow_Blue_F", "Sign_Arrow_Cyan_F", "Sign_Arrow_Green_F", "Sign_Arrow_Pink_F", "Sign_Arrow_F", "Sign_Arrow_Yellow_F"];

// Only the server runs the convoy, so these variables do not have to be public.
_ltConvoyPath = [position _leaderVeh];
_leaderVeh setVariable ["lt_convoy_path", _ltConvoyPath, false];

// Initialize the debug draw objects: one list per following vehicle
_drawObjects = [];
for "_i" from 1 to (_convoyLength - 1) do
{
    _drawObjects pushBack [];
};
_leaderVeh setVariable ["convoy_drawObjects", _drawObjects, false];

while {!(_leaderVeh getVariable ["convoy_terminate", false])} do
{
    _pathFrequecy = _logic getVariable ["pathFrequecy", -1];
    _debugDraw = _logic getVariable ["debug", false];

    _ltConvoyPath = _leaderVeh getVariable ["lt_convoy_path", []];
    _ltConvoyPath pushBack (position _leaderVeh);

    // Delete unnecessary points
    _vehicleInBack = _groupVehicles select (_convoyLength - 1);
    _itMax = count _ltConvoyPath;
    _foundCandidate = false;
    for "_j" from (_itMax - 1) to 0 step -1 do
    {
        _distBack2wp = (_ltConvoyPath select _j) distance (position _vehicleInBack);
        if ((_distBack2wp < _chopDistance) && (!_foundCandidate)) then
        {
            _foundCandidate = true;
        };
        if ((_distBack2wp > _chopDistance) && _foundCandidate) then
        {
            _ltConvoyPath deleteAt _j;
        };
    };

    // Create vehicle path
    for "_i" from 1 to (_convoyLength - 1) do
    {
        _vehiclePathChop = [];
        _vehicle = _groupVehicles select _i;
        _vehicleInFront = _groupVehicles select (_i - 1);

        _foundCandidate = false;
        _foundLast = false;
        _foundFirst = false;
        _lastPoint = -1;
        _firstPoint = -1;
        _pathTemp = _ltConvoyPath;
        _itMax = count _pathTemp;
        for "_j" from (_itMax - 1) to 0 step -1 do
        {
            _wpPosition = _pathTemp select _j;
            _distFront2wp = _wpPosition distance (position _vehicleInFront);
            _distBack2wp = _wpPosition distance (position _vehicle);
            // find first point candidate
            if ((_distFront2wp < _chopDistance) && (!_foundCandidate) && (!_foundLast) && (!_foundFirst)) then
            {
                _foundCandidate = true;
            };
            // find last point
            if ((_distFront2wp > _chopDistance) && _foundCandidate && (!_foundLast) && (!_foundFirst)) then
            {
                _foundLast = true;
                _lastPoint = _j;
            };
            // find first point
            if (((_distBack2wp < _chopDistance) || (_j == 0)) && _foundCandidate && _foundLast && (!_foundFirst)) then
            {
                _foundFirst = true;
                _firstPoint = _j;
                if (_firstPoint < _lastPoint) then
                {
                    _vehiclePathChop = _pathTemp select [_firstPoint, (_lastPoint - _firstPoint + 1)];
                };
            };
        };

        _leaderVeh setVariable ["lt_convoy_path", _ltConvoyPath, false];

        if (((speed _vehicle) == 0) && (((position _vehicle) distance (position _vehicleInFront)) > 100)) then
        {
            (driver _vehicle) doMove (position _vehicleInFront);
        }
        else
        {
            _vehicle setDriveOnPath _vehiclePathChop;
        };

        // DEBUG: draw the path of this vehicle
        if (_debugDraw) then
        {
            _drawObjects = _leaderVeh getVariable ["convoy_drawObjects", []];

            {deleteVehicle _x} forEach (_drawObjects select (_i - 1));
            if (_i > 12) then
            {
                hint "too long to draw";
            }
            else
            {
                for "_j" from ((count _vehiclePathChop) - 1) to 0 step -1 do
                {
                    _iconPos = _vehiclePathChop select _j;
                    // same colour order as before: blue, cyan, green, pink, white, yellow, repeating
                    (_drawObjects select (_i - 1)) pushBack (createVehicle [_arrowTypes select ((_i - 1) mod 6), _iconPos, [], 0, "CAN_COLLIDE"]);
                };
            };
        };
    };

    sleep _pathFrequecy;
};

// exit script
{
    _x forceSpeed -1;
} forEach _groupVehicles;

["Convoy", "Path creator stopped", 2] call LT_fnc_log;
