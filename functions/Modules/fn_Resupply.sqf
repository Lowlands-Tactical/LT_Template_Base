/*

File: fn_Resupply.sqf
Author: Brainless_Ben

Description:
Function for resupply module, processes module data to spawn units/vehicles/apcs/tanks.

Return value:
True (if all waves succesfully spawned)

*/

_logic = param [0,objNull,[objNull]];
_units = param [1,[],[[]]];
_activated = param [2,true,[true]];

if (_activated) then 
{
	if !(isServer) exitWith {};
	_position = getPos _logic;
	_side = switch (_logic getVariable ["Resupply_Side", "WEST"]) do
	{
		case "WEST":{west};
		case "EAST":{east};
		case "GUER":{resistance};
	};
	_vehicle = _logic getVariable ["Resupply_Vehicle","C_Plane_Civil_01_F"];
	_crate = _logic getVariable ["Resupply_Crate", "B_supplyCrate_F"];
	_load1 = _logic getVariable ["Resupply_Loadout_1", "Empty"];
	_load2 = _logic getVariable ["Resupply_Loadout_2", "Empty"];
	_load3 = _logic getVariable ["Resupply_Loadout_3", "Empty"];
	_shift = _logic getVariable ["Resupply_Shift", false];
	_alt = _logic getVariable ["Resupply_Alt", false];
	
	Diag_Log format["[LT] (ResupplyModule) Loadoutside= %1", _side];
	Diag_Log format["[LT] (ResupplyModule) Vehicle= %1 Crate= %2", _vehicle, _crate];
	Diag_Log format["[LT] (ResupplyModule) Lo1= %1 Lo2= %2 Lo3= %3", _load1, _load2, _load3];
	Diag_Log format["[LT] (ResupplyModule) ShiftPress= %1 AltPress= %2", _shift, _alt];
	
	if ("lt_debug" call bis_fnc_getParamValue == 1) then {};
		systemChat format["[LT] (ResupplyModule) Loadoutside= %1", _side];
		systemChat format["[LT] (ResupplyModule) Vehicle= %1 Crate= %2", _vehicle, _crate];
		systemChat format["[LT] (ResupplyModule) Lo1= %1 Lo2= %2 Lo3= %3", _load1, _load2, _load3];
		systemChat format["[LT] (ResupplyModule) ShiftPress= %1 AltPress= %2", _shift, _alt];

	[_position, _side, _vehicle, _crate, _load1, _load2, _load3, _shift, _alt] remoteExec ["LT_fnc_ResupplyRequest", 2];
};
