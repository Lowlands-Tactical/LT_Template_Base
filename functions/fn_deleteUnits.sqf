/*

File: fn_deleteUnits.sqf
Author: Brainless_Ben

Description:
Function to start the supply drop.

Parameters:
_this select 0 = Group to be deleted

Example:
[(group this)] call LT_fnc_deleteUnits

*/

private ["_grpId"];
_grpId = param [0, grpNull, [grpNull]];

if !(local (leader _grpId)) exitWith {};
// Loop through all the units in the group
{
  if (vehicle _x != _x) then {deleteVehicle (vehicle _x);};  
  deleteVehicle _x;
} forEach units _grpId;

Diag_log "[LT] (deleteUnits) group/unit deleted";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
  systemChat "[LT] (deleteUnits) group/unit deleted";
};

true;
