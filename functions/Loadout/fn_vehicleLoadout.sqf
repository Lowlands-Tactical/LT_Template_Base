/*

File: fn_vehicleLoadout.sqf
Author: Brainless_Ben

Description:
Function to set vehicle loadout.

Parameters:
_this select 0 = vehicle
_this select 1 = side vehicle or variable LT_veh_side
_this select 2 = loadout type

Example:
[this, west, "Crate Medium"] call LT_fnc_vehicleLoadout

*/

if (!isServer) exitWith {};

_vehicle = param [0, objNull, [objNull]];
_side = switch (_this select 1) do
{
	case west;
	case "WEST":{west};
	case east;
	case "EAST":{east};
	case resistance;
	case "GUER":{resistance};
	case civilian;
	case "CIV":{civilian};
};
_loadout = param [2, "", [""]];

Diag_Log format["[LT] (Loadout) Vehicle %1 has side %2 and Loadout: %3",typeOf _vehicle, _side, _loadout];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (Loadout) Vehicle %1 has side %2 and Loadout: %3",typeOf _vehicle,  _side, _loadout];
};

if (_loadout == "None" OR _loadout == "Custom") exitWith {};
if (_loadout == "Empty") exitWith 
{
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearBackpackCargoGlobal _vehicle;
};

// Import variable attached to the group in fnc_ResupplyRequest
if (lt_playerCamoIsSet == 0) then 
{
	waitUntil {sleep 1; !isNil "LT_Items_Blue";};
	waitUntil {sleep 1; !isNil "LT_Weapons_Blue";};
	waitUntil {sleep 1; !isNil "LT_Items_Red";};
	waitUntil {sleep 1; !isNil "LT_Weapons_Red";};
	waitUntil {sleep 1; !isNil "LT_Items_Green";};
	waitUntil {sleep 1; !isNil "LT_Weapons_Green";};
	lt_playerCamoIsSet = 1;
	publicVariable "lt_playerCamoIsSet";
};

_items = switch (_side) do 
{
	case west: {LT_Items_Blue};
	case east: {LT_Items_Red};
	case resistance: {LT_Items_Green};
};
_wpns = switch (_side) do 
{
	case west: {LT_Weapons_Blue};
	case east: {LT_Weapons_Red};
	case resistance: {LT_Weapons_Green};
};

// Define item arrays and weapons
_itemTrow = _items select 0;			// _itemsTrow
_itemMedic = _items select 1;			// _itemsPackMedic
_itemMedicAmt = [50,50,25,20,20,30,30,10,10,10,4];
_itemRadio = _items select 2;			// _itemsRadio
_itemSpecial = _items select 3;			// _itemsSpecial
_itemsSpecialAmt = [2,2,2,5,5,40,40];
_itemRole = _items select 4;			// _itemsRole
_itemNVG = _items select 5;				// _itemsNVG
_itemNVGAmt = [20,20,40];
_itemExpl = _items select 5;			// _itemEngExpl
_itemExplAmt = [20,10];
_itemMine = _items select 6;			// _itemEngMine
_itemMineAmt = [20,10,10,10,5];

_wpnRifle = _wpns select 0;				// [_rifleGL,_rifle_Mags,_rifle_Mags_Tr]
_wpnRifleCr = _wpns select 1;			// [_rifleCrGL,_rifleCr_Mags,_rifleCr_Mags_Tr]
_wpnRifleMark = _wpns select 2;			// [_rifleMark, _rifleMark_Mags]
_wpnGLAmmo = _wpns select 3 select 0;	// [_itemsGL,_itemsGLNVG]
_wpnGLNVG = _wpns select 3 select 1;	// [_itemsGL,_itemsGLNVG]
_wpnRifleAir = _wpns select 4;			// [_rifleAir,_rifleAir_Mags]
_wpnAR = _wpns select 5;				// [_rifleAR,_rifleAR_Mags]
_wpnHG = _wpns select 6;				// [_handGun,_handGun_Mags]
_wpnLnchr = _wpns select 7;				// [_launcher,_launcher_MagAA,_launcher_MagAT]
_wpnBino = _wpns select 8;				// _binocular

_itemNVG = [_itemNVG select 0, _itemNVG select 1,_itemNVG select 2];
{
	_itemNVG pushback _x;
}forEach _wpnGLNVG;
_itemNVGAmt resize [(count _itemNVG), 40];

if ("lt_gear_nvg" call bis_fnc_getParamValue == 1) then {_wpnGLAmmo = _wpnGLNVG;};

// Clear crate
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

// Add loadout by size to crate
switch (_loadout) do 
{
	case "Crate Small": 
	{
		_vehicle addItemCargoGlobal [_wpnRifle select 1, 6];
		_vehicle addItemCargoGlobal [_wpnRifle select 2, 2];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 1, 6];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 2, 2];
		_vehicle addItemCargoGlobal [_wpnRifleMark select 1, 3];
		_vehicle addItemCargoGlobal [_wpnAR select 1, 3];
		_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 3];
		_vehicle addItemCargoGlobal [_wpnHG select 1, 2];
		_vehicle addItemCargoGlobal [_wpnLnchr select 0, 2];
		_vehicle addItemCargoGlobal [_wpnBino, 1];
		_vehicle addItemCargoGlobal [_itemSpecial select 0, 1];
		_vehicle addItemCargoGlobal [_itemRole select 2, 6];

		if ((_wpnLnchr select 1) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 1, 4];
		};
		if ((_wpnLnchr select 2) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 2, 4];
		};
		{
			_vehicle addItemCargoGlobal [_x, 5];
		}forEach _itemTrow;
		{
			_vehicle addItemCargoGlobal [_x, 10];
		}forEach _wpnGLAmmo;
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
	};
	case "Crate Medium": 
	{
		_vehicle addItemCargoGlobal [_wpnRifle select 1, 30];
		_vehicle addItemCargoGlobal [_wpnRifle select 2, 10];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 1, 30];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 2, 10];
		_vehicle addItemCargoGlobal [_wpnRifleMark select 1, 10];
		_vehicle addItemCargoGlobal [_wpnAR select 1, 6];
		_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 10];
		_vehicle addItemCargoGlobal [_wpnHG select 1, 4];
		_vehicle addItemCargoGlobal [_wpnLnchr select 0, 4];
		_vehicle addItemCargoGlobal [_wpnBino, 2];
		_vehicle addItemCargoGlobal [_itemSpecial select 0, 1];
		_vehicle addItemCargoGlobal [_itemRole select 2, 12];

		if ((_wpnLnchr select 1) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 1, 6];
		};
		if ((_wpnLnchr select 2) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 2, 6];
		};
		{
			_vehicle addItemCargoGlobal [_x, 10];
		}forEach _itemTrow;
		{
			_vehicle addItemCargoGlobal [_x, 15];
		}forEach _wpnGLAmmo;
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
	};
	case "Crate Large": 
	{
		_vehicle addItemCargoGlobal [_wpnRifle select 1, 60];
		_vehicle addItemCargoGlobal [_wpnRifle select 2, 20];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 1, 60];
		_vehicle addItemCargoGlobal [_wpnRifleCr select 2, 20];
		_vehicle addItemCargoGlobal [_wpnRifleMark select 1, 20];
		_vehicle addItemCargoGlobal [_wpnAR select 1, 10];
		_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 20];
		_vehicle addItemCargoGlobal [_wpnHG select 1, 10];
		_vehicle addItemCargoGlobal [_wpnLnchr select 0, 8];
		_vehicle addItemCargoGlobal [_wpnBino, 4];
		_vehicle addItemCargoGlobal [_itemSpecial select 0, 2];
		_vehicle addItemCargoGlobal [_itemRole select 2, 24];

		if ((_wpnLnchr select 1) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 1, 8];
		};
		if ((_wpnLnchr select 2) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 2, 8];
		};
		{
			_vehicle addItemCargoGlobal [_x, 20];
		}forEach _itemTrow;
		{
			_vehicle addItemCargoGlobal [_x, 20];
		}forEach _wpnGLAmmo;
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
	};
	case "Crate Explosives": 
	{
		{
			_vehicle addItemCargoGlobal [_x, _itemsSpecialAmt select _forEachIndex];
		}forEach _itemSpecial;
		{
			_vehicle addItemCargoGlobal [_x, _itemExplAmt select _forEachIndex];
		}forEach _itemExpl;
	};
	case "Crate Mines":
	{
		{
			_vehicle addItemCargoGlobal [_x, _itemsSpecialAmt select _forEachIndex];
		}forEach _itemSpecial;
		{
			_vehicle addItemCargoGlobal [_x, _itemMineAmt select _forEachIndex];
		}forEach _itemMine;
	};
	case "Crate Medical": 
	{
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
	};
	case "Crate Weapons": 
	{
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifle select 0, 4];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleCr select 0, 4];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleMark select 0, 2];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleAir select 0, 6];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnAR select 0, 2];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnHG select 0, 6];
		_vehicle addItemCargoGlobal [_wpnLnchr select 0, 8];
		_vehicle addItemCargoGlobal [_wpnBino, 6];
		if ((_wpnLnchr select 1) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 1, 8];
		};
		if ((_wpnLnchr select 2) != "") then 
		{
			_vehicle addItemCargoGlobal [_wpnLnchr select 2, 8];
		};
	};
	case "Crate Air": 
	{
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleAir select 0, 6];
		_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnHG select 0, 4];
		_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 20];
		_vehicle addItemCargoGlobal [_wpnHG select 1, 10];
		_vehicle addItemCargoGlobal [_wpnBino, 4];
		_vehicle addItemCargoGlobal [_itemRole select 0, 4];
		_vehicle addItemCargoGlobal [_itemRole select 2, 4];
		{
			_vehicle addItemCargoGlobal [_x, 5];
		}forEach _itemTrow;
		{
			_vehicle addItemCargoGlobal [_x, _itemMedicAmt select _forEachIndex];
		}forEach _itemMedic;
	};
	case "Crate Comms":
	{
		_vehicle addItemCargoGlobal [_itemRadio select 0, 10];
		_vehicle addItemCargoGlobal [_itemRadio select 1, 10];
		_vehicle addItemCargoGlobal [_itemRole select 0, 10];
		_vehicle addItemCargoGlobal [_itemRole select 1, 5];
	};
	case "Crate NVG": 
	{
		{
			_vehicle addItemCargoGlobal [_x, _itemNVGAmt select _forEachIndex];
		}forEach _itemNVG;
	};
};

sleep 0.2;

[_vehicle, ((ceil loadabs _vehicle) +1000)] remoteExec ["LT_fnc_resetMaxLoad"];

sleep 0.2;

_setRespawn = _vehicle getVariable ["LT_veh_setRepawn", 0];
if (_setRespawn == 0) then 
{
	if (_vehicle isKindOf "Car" OR _vehicle isKindOf "Tank" OR _vehicle isKindOf "Air" OR _vehicle isKindOf "Ship") then 
	{
		_vehRespawn = _vehicle getVariable ["LT_veh_respawn", 0];
		Diag_Log format["[LT] (prepLoadout) Vehicle: %1 has Respawn: %2", _vehicle, _vehRespawn];
		if (_vehRespawn != 0) then 
		{
			_vehicle setVariable ["LT_veh_setRepawn", 1];
			[_vehicle, 15] call FRED_fnc_vehicleRespawn;
		};
	};
};

true;
