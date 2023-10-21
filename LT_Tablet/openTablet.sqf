/*

File: openTablet.sqf
Author: Brainless_Ben

Description:
Open the Admin Tablet for the lowtac community

Dependancy:
Define_LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
Buttons.sqf

*/

createDialog "BB_LT_Tablet";

// Checks which button to show for the on/off state
lt_param_timer = missionNameSpace getVariable ["lt_param_timer", 10];
lt_fatigue_onoff = missionNameSpace getVariable ["lt_fatigue_onoff", 0];
lt_group_teleport = missionNameSpace getVariable ["lt_group_teleport", 0];
lt_resupply = missionNameSpace getVariable ["lt_resupply", 0];

if (lt_param_timer > 1) then {ctrlShow [511,false]} else {ctrlShow [510,false]};
if (lt_fatigue_onoff == 1) then {ctrlShow [512,false]} else {ctrlShow [513,false]};
if (isObjectHidden player) then {ctrlShow [514,false]} else {ctrlShow [515,false]};
if (lt_group_teleport == 1) then {ctrlShow [516,false]} else {ctrlShow [517,false]};
if (lt_resupply == 1) then {ctrlShow [538,false]} else {ctrlShow [539,false]};

// Array with players for the list inside the tablet
_allPlayers = call BIS_fnc_listPlayers;
playerArr = [];
{
	playerArr pushBack _x;
	_name = name _x;
	if (_name == "HC") exitWith {};
	lbAdd [550, _name];
	switch (side _x) do 
	{
		case west: {lbSetColor [550, _forEachIndex, [0,0.3,0.6,1]];};
		case east: {lbSetColor [550, _forEachIndex, [0.5,0,0,1]];};
		case resistance: {lbSetColor [550, _forEachIndex, [0,0.5,0,1]];};
	};
} forEach _allPlayers;
lbSetCurSel [550,0];

// Array with vehicles that can be chosen to spawn
_vehArr = [
	"NLD_C130H_VIV",
	"NLD_CH47F_ViV",
	"NLD_NH90",
	"B_T_VTOL_01_vehicle_F",
	"C_Plane_Civil_01_F",
	"CUP_O_C47_SLA",
	"CUP_C_AN2_AEROSCHROT_TK_CIV",
	"CUP_C_MI6A_RU"
];
{
	_vehName = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
	lbAdd [531, _vehName];
	lbSetData [531, _forEachIndex, _x];
}forEach _vehArr;
lbSetCurSel [531,0];

// Array with types of crates that wil be spawned
_crateArr = [
	"CUP_BOX_US_ARMY_Ammo_F",
	"B_supplyCrate_F",
	"I_E_CargoNet_01_ammo_F",
	"C_IDAP_supplyCrate_F",
	"NLD_Ammo_Crate_Munitie"
];
{
	_crateName = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
	lbAdd [533, _crateName];
	lbSetData [533, _forEachIndex, _x];
}forEach _crateArr;
lbSetCurSel [533,0];

// Array with crate loadout is selected for the supply drop
_loadArr = [
// Nothing
	"None",
// Default crates
	"Crate Small",
	"Crate Medium",
	"Crate Large",
// Specific crates
	"Crate Explosives",
	"Crate Mines",
	"Crate Medical",
	"Crate Weapons",
	"Crate Air",
	"Crate Comms",
	"Crate NVG",
// Static weapons
	"M2 HMG",
	"Mk6 Morter",
	"Remote Designator",
// Land vehicles
	"VW Amarok",
	"MB G280 CDI",
	"King Quad",
// Water vehicles
	"Assault Boat",
	"NLD RHIB",
	"FRISC Motorboat"
];
{
	_loadOutName = _x;
	lbAdd [535, _loadOutName];
	lbSetData [535, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [535,1];
{
	_loadOutName = _x;
	lbAdd [536, _loadOutName];
	lbSetData [536, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [536,0];
{
	_loadOutName = _x;
	lbAdd [537, _loadOutName];
	lbSetData [537, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [537,0];

while {!isNull findDisplay 500} do 
{
	_vehIndex = lbCurSel 531;
	_veh = lbData [531, _vehIndex];
	_vehPicture = getText (configFile>>"cfgVehicles">> _veh >>"editorPreview");
	ctrlSetText [532,_vehPicture];
	_crateIndex = lbCurSel 533;
	_crate = lbData [533, _crateIndex];
	_cratePicture = getText (configFile>>"cfgVehicles">> _crate >>"editorPreview");
	ctrlSetText [534,_cratePicture];
	sleep 1;
};
