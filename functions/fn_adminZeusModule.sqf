/*

File: fn_adminZeusModule.sqf
Author: Brainless_Ben

Description:
General Zeus module configurator for all staff members.
This function will check for each staff member if they have a staff module assigned.
If not a new module is created and assigned to said staff member.

Parameters:
[] 
	Example:
	[] remoteExec ["LT_fnc_adminZeusModule", 2]

*/

if (!isServer) exitWith {};

_staffArray = AdminCrew get "Staff";
{
    _staffObject = _x call BIS_fnc_getUnitByUID;
    _staffName = name _staffObject;
    
    if (isNull (getAssignedCuratorLogic _staffObject)) then 
    {
        // if staff member is not online exit function
        if (_staffName == "Error: No vehicle") exitWith
        {
            ["ZeusModule","this staffmember is not online",2] call LT_fnc_log;
        };

        // Check if not already created and assign it else create new module
        {
            if (name (getAssignedCuratorUnit _x) == _staffName) then 
            {
                _staffObject assignCurator _x;
                
                ["ZeusModule",format ["ZEUS assigned to %1.", _staffName],2] call LT_fnc_log;
            };
        }forEach allCurators;

        if (isNull (getAssignedCuratorLogic _staffObject)) then 
        {
            _curLogicGrp = creategroup sideLogic;
            _curModule = _curLogicGrp createunit ["ModuleCurator_F", [90, 90],[],0.5,"NONE"];
            _staffObject assignCurator _curModule;

            ["ZeusModule",format ["ZEUS assigned to %1.", _staffName],2] call LT_fnc_log;
        };
    } else 
    {
        ["ZeusModule",format ["ZEUS already assigned to %1.", _staffName],1] call LT_fnc_log;
        Diag_log format["[LT] (ZeusModule) ZEUS already assigned to %1.", _staffName];
        if ("lt_debug" call bis_fnc_getParamValue == 1) then 
        {
            systemChat format["[LT] (ZeusModule) ZEUS already assigned to %1.", _staffName];
        };
    };
    
    {
        _x addCuratorEditableObjects [allUnits, false];
        _x addCuratorEditableObjects [vehicles, true];
    }forEach allCurators;
}forEach _staffArray;
