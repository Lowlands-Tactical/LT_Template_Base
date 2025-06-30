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
_sideCheck = param [1];
_side = switch (_sideCheck) do
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

if !(_loadout isEqualType "") exitWith 
{
	Diag_Log format["[LT] (Loadout) Loadout is not STRING: %1 for Vehicle: %2", _loadout,name _vehicle];
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (Loadout) Loadout is not STRING: %1 for Vehicle: %2", _loadout,name _vehicle];
	};
};

Diag_Log format["[LT] (Loadout) Vehicle %1 has side %2 and Loadout: %3",typeOf _vehicle, _side, _loadout];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat format["[LT] (Loadout) Vehicle %1 has side %2 and Loadout: %3",typeOf _vehicle,  _side, _loadout];
};

_check = true;
if (_loadout == "None" OR _loadout == "Empty") then 
{
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearBackpackCargoGlobal _vehicle;
	_check = false;
};
if (_loadout == "Custom") then
{
	_check = false;
};

// Add loadout by size to crate
if (_check) then
{
	// Import variable attached to the group in fnc_ResupplyRequest
	if (lt_playerCamoIsSet == 0) then 
	{
		waitUntil {sleep 1; !isNil "LT_Items_Blue";};
		LT_Items_Blue = missionNameSpace getVariable "LT_Items_Blue";
		waitUntil {sleep 1; !isNil "LT_Weapons_Blue";};
		LT_Weapons_Blue = missionNameSpace getVariable "LT_Weapons_Blue";
		waitUntil {sleep 1; !isNil "LT_Items_Red";};
		LT_Items_Red = missionNameSpace getVariable "LT_Items_Red";
		waitUntil {sleep 1; !isNil "LT_Weapons_Red";};
		LT_Weapons_Red = missionNameSpace getVariable "LT_Weapons_Red";
		waitUntil {sleep 1; !isNil "LT_Items_Green";};
		LT_Items_Green = missionNameSpace getVariable "LT_Items_Green";
		waitUntil {sleep 1; !isNil "LT_Weapons_Green";};
		LT_Weapons_Green = missionNameSpace getVariable "LT_Weapons_Green";
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

	// Select gear textures
	LT_Loadout = getMissionConfigValue ["LT_Loadout_ID","BASE"];
	_loadoutNr = 0;
	switch (LT_Loadout) do 
	{
		case "BASE":
		{
			_loadoutNr = 0;
			//#include "\lt_template_gear\Loadout_BASE\SwitchGearBASE.sqf"
			//#include "\lt_template_gear\Loadout_BASE\SwitchWeaponBASE.sqf"
		};
		case "GM":
		{
			_loadoutNr = 1;
			//#include "\lt_template_gear\Loadout_GM\SwitchGearGM.sqf"
			//#include "\lt_template_gear\Loadout_GM\SwitchWeaponGM.sqf"
		};
		case "VN":
		{
			_loadoutNr = 2;
			//#include "\lt_template_gear\Loadout_VN\SwitchGearVN.sqf"
			//#include "\lt_template_gear\Loadout_VN\SwitchWeaponVN.sqf"
		};
	};

	// Define item arrays and weapons
	_itemsTrow = [_loadoutNr, "Trow"] call LT_fnc_gearItems;
	_itemsMedic = [_loadoutNr, "Medic"] call LT_fnc_gearItems;
	_itemsMedicAmt = [_loadoutNr, "MedicAmt"] call LT_fnc_gearItems;
	_itemsRadio = [_loadoutNr, "Radio"] call LT_fnc_gearItems;
	_itemsSpecial =	[_loadoutNr, "Special"] call LT_fnc_gearItems;
	_itemsSpecialAmt = [_loadoutNr, "SpecialAmt"] call LT_fnc_gearItems;
	_itemsNVG = _items select 0;			// _itemsNVG
	_itemsNVGAmt = _items select 1;			// _itemsNVGAmt
	_itemsRole = _items select 2;			// _itemsRole
	_itemEngExpl = [_loadoutNr, "Expl"] call LT_fnc_gearItems;
	_itemEngExplAmt = [_loadoutNr, "ExplAmt"] call LT_fnc_gearItems;
	_itemEngMine = [_loadoutNr, "Mine"] call LT_fnc_gearItems;
	_itemEngMineAmt = [_loadoutNr, "MineAmt"] call LT_fnc_gearItems;

	_wpnRifle = _wpns select 0;				// [_rifleGL,_rifle_Mags,_rifle_Mags_Tr]
	_wpnRifleCr = _wpns select 1;			// [_rifleCrGL,_rifleCr_Mags,_rifleCr_Mags_Tr]
	_wpnRifleMark = _wpns select 2;			// [_rifleMark, _rifleMark_Mags]
	_wpnGLAmmo = _wpns select 3 select 0;	// _itemsGL
	_wpnGLNVG = _wpns select 3 select 1;	// _itemsGLNVG
	_wpnRifleAir = _wpns select 4;			// [_rifleAir,_rifleAir_Mags]
	_wpnAR = _wpns select 5;				// [_rifleAR,_rifleAR_Mags]
	_wpnHG = _wpns select 6;				// [_handGun,_handGun_Mags]
	_wpnLnchr = _wpns select 7 select 0;	// _launcher
	_wpnLnchrAmmo = _wpns select 7 select 1;// [_launcherAmmo1,_launcherAmmo2, etc]
	_wpnBino = _wpns select 8;				// _binocular
	_wpnAA = _wpns select 9 select 0;		// _launcherAA ""
	_wpnAAAmmo = _wpns select 9 select 1;	// _launcherAA_Mags []
	_wpnHeavy = _wpns select 10 select 0;	// [_heavyAR]
	_wpnHeavyAmmo = _wpns select 10 select 1;// _heavyAR_Mags

	_itemsNVG = [_itemsNVG select 0, _itemsNVG select 1,_itemsNVG select 2];
	{
		_itemsNVG pushback _x;
	}forEach _wpnGLNVG;
	_itemsNVGAmt resize [(count _itemsNVG), 40];

	//Check if AA Launcher is expendable or can be Reloaded
	_AAAmmo = true;
	_AAWeapon = 2;
	if (_wpnAAAmmo isEqualTypeArray []) then 
	{
		Diag_Log format["[LT] (prepLoadout) AA Launcher:%1 is expendable", _wpnAA];
		_AAAmmo = false;
		_AAWeapon = 1;
	};

	if ("lt_gear_nvg" call bis_fnc_getParamValue == 1) then {_wpnGLAmmo = _wpnGLNVG;};

	// Clear crate
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearBackpackCargoGlobal _vehicle;

	switch (_loadout) do 
	{
		case "Crate Small": 
		{
			_vehicle addItemCargoGlobal [_wpnRifle select 1, 8];
			_vehicle addItemCargoGlobal [_wpnRifleCr select 1, 8];
			_vehicle addItemCargoGlobal [_wpnRifleMark select 1, 4];
			_vehicle addItemCargoGlobal [_wpnAR select 1, 3];
			_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 3];
			_vehicle addItemCargoGlobal [_wpnHG select 1, 2];
			_vehicle addItemCargoGlobal [_wpnAA, ceil(_AAWeapon /2)];
			_vehicle addItemCargoGlobal [_itemsSpecial select 0, 1];
			_vehicle addItemCargoGlobal [_itemsRole select 2, 6];
			_vehicle addItemCargoGlobal [_wpnAAAmmo select 0, 1];
			_vehicle addItemCargoGlobal [_wpnAAAmmo select 1, 1];
			_vehicle addItemCargoGlobal [_wpnHeavyAmmo, 6];
			_vehicle addBackpackCargoGlobal [_itemsRole select 4, 1];

			if (_AAAmmo) then 
			{
				{
					_vehicle addItemCargoGlobal [_x, ceil(_AAWeapon /2)];
				}forEach _wpnAAAmmo;
			};
			{
				_vehicle addItemCargoGlobal [_x, 5];
			}forEach _itemsTrow;
			{
				_vehicle addItemCargoGlobal [_x, 5];
			}forEach _wpnGLAmmo;
			{
				_vehicle addItemCargoGlobal [_x, (ceil (_itemsMedicAmt select _forEachIndex) /4)];
			}forEach _itemsMedic;
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
			_vehicle addItemCargoGlobal [_wpnLnchr, 4];
			_vehicle addItemCargoGlobal [_wpnAA, _AAWeapon];
			_vehicle addItemCargoGlobal [_wpnBino, 2];
			_vehicle addItemCargoGlobal [_itemsSpecial select 0, 1];
			_vehicle addItemCargoGlobal [_itemsRole select 2, 12];
			_vehicle addItemCargoGlobal [_itemsRole select 3, 2];
			_vehicle addBackpackCargoGlobal [_itemsRole select 4, 2];
			_vehicle addItemCargoGlobal [_wpnHeavy select 0, 1];
			_vehicle addItemCargoGlobal [_wpnHeavyAmmo, 7];

			if (_AAAmmo) then 
			{
				{
					_vehicle addItemCargoGlobal [_x, _AAWeapon];
				}forEach _wpnAAAmmo;
			};
			{
				_vehicle addItemCargoGlobal [_x,4];
			}forEach _wpnLnchrAmmo;
			{
				_vehicle addItemCargoGlobal [_x, 10];
			}forEach _itemsTrow;
			{
				_vehicle addItemCargoGlobal [_x, 10];
			}forEach _wpnGLAmmo;
			{
				_vehicle addItemCargoGlobal [_x, (ceil (_itemsMedicAmt select _forEachIndex) /2)];
			}forEach _itemsMedic;
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
			_vehicle addItemCargoGlobal [_wpnLnchr, 8];
			_vehicle addItemCargoGlobal [_wpnAA, ceil(_AAWeapon *2)];
			_vehicle addItemCargoGlobal [_wpnBino, 4];
			_vehicle addItemCargoGlobal [_itemsSpecial select 0, 2];
			_vehicle addItemCargoGlobal [_itemsRole select 2, 24];
			_vehicle addItemCargoGlobal [_itemsRole select 3, 4];
			_vehicle addBackpackCargoGlobal [_itemsRole select 4, 4];
			_vehicle addItemCargoGlobal [_wpnHeavy select 0, 2];
			_vehicle addItemCargoGlobal [_wpnHeavyAmmo, 14];

			if (_AAAmmo) then 
			{
				{
					_vehicle addItemCargoGlobal [_x, ceil(_AAWeapon *2)];
				}forEach _wpnAAAmmo;
			};
			{
				_vehicle addItemCargoGlobal [_x,8];
			}forEach _wpnLnchrAmmo;
			{
				_vehicle addItemCargoGlobal [_x, 20];
			}forEach _itemsTrow;
			{
				_vehicle addItemCargoGlobal [_x, 20];
			}forEach _wpnGLAmmo;
			{
				_vehicle addItemCargoGlobal [_x, _itemsMedicAmt select _forEachIndex];
			}forEach _itemsMedic;
		};
		case "Crate Explosives": 
		{
			{
				_vehicle addItemCargoGlobal [_x, _itemsSpecialAmt select _forEachIndex];
			}forEach _itemsSpecial;
			{
				_vehicle addItemCargoGlobal [_x, _itemEngExplAmt select _forEachIndex];
			}forEach _itemEngExpl;
		};
		case "Crate Mines":
		{
			{
				_vehicle addItemCargoGlobal [_x, _itemsSpecialAmt select _forEachIndex];
			}forEach _itemsSpecial;
			{
				_vehicle addItemCargoGlobal [_x, _itemEngMineAmt select _forEachIndex];
			}forEach _itemEngMine;
		};
		case "Crate Medical": 
		{
			{
				_vehicle addItemCargoGlobal [_x, _itemsMedicAmt select _forEachIndex];
			}forEach _itemsMedic;
			{
				_vehicle addItemCargoGlobal [_x, _itemsMedicAmt select _forEachIndex];
			}forEach _itemsMedic;
		};
		case "Crate Weapons": 
		{
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifle select 0, 4];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleCr select 0, 4];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleMark select 0, 2];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleAir select 0, 6];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnAR select 0, 2];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnHG select 0, 6];
			_vehicle addItemCargoGlobal [_wpnLnchr, 8];
			_vehicle addItemCargoGlobal [_wpnAA, ceil(_AAWeapon *2)];
			_vehicle addItemCargoGlobal [_wpnBino, 6];
			_vehicle addItemCargoGlobal [_wpnHeavy select 0, 2];
		};
		case "Crate Air": 
		{
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnRifleAir select 0, 6];
			_vehicle addWeaponWithAttachmentsCargoGlobal [_wpnHG select 0, 4];
			_vehicle addItemCargoGlobal [_wpnRifleAir select 1, 20];
			_vehicle addItemCargoGlobal [_wpnHG select 1, 10];
			_vehicle addItemCargoGlobal [_wpnBino, 4];
			_vehicle addItemCargoGlobal [_itemsRole select 0, 4];
			_vehicle addItemCargoGlobal [_itemsRole select 2, 4];

			{
				_vehicle addItemCargoGlobal [_x, 5];
			}forEach _itemsTrow;
			{
				_vehicle addItemCargoGlobal [_x, _itemsMedicAmt select _forEachIndex];
			}forEach _itemsMedic;
		};
		case "Crate Comms":
		{
			_vehicle addItemCargoGlobal [_itemsRadio select 0, 10];
			_vehicle addItemCargoGlobal [_itemsRadio select 1, 10];
			_vehicle addItemCargoGlobal [_itemsRole select 0, 10];
			_vehicle addItemCargoGlobal [_itemsRole select 1, 5];
		};
		case "Crate NVG": 
		{
			{
				_vehicle addItemCargoGlobal [_x, _itemsNVGAmt select _forEachIndex];
			}forEach _itemsNVG;
		};
		case "Crate UAV":
		{
			_vehicle addItemCargoGlobal [_itemsRole select 1, 4];
			_vehicle addItemCargoGlobal [_itemsRole select 3, 8];
			_vehicle addBackpackCargoGlobal [_itemsRole select 4, 4];
		};
	};
};

sleep 0.2;

[_vehicle, ((ceil(loadabs _vehicle)) +1000)] remoteExec ["LT_fnc_resetMaxLoad"];

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
			_delay = _vehicle getVariable ["LT_veh_respawn_delay",15];
			if (_delay < 15) then {_delay = 15;};
			[_vehicle, _delay] call FRED_fnc_vehicleRespawn;
		};
	};
};

_check;
