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

_lt_Loadout = getMissionConfigValue ["LT_Loadout_ID","BASE"];

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
_vehArr = 
[
	"C_Plane_Civil_01_F",
	"B_T_VTOL_01_vehicle_F"
];

// Array with types of crates that wil be spawned
_crateArr = [
	"B_supplyCrate_F",
	"I_E_CargoNet_01_ammo_F",
	"C_IDAP_supplyCrate_F"
];

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
	"Crate UAV"
];

switch (_lt_Loadout) do
{
	case "BASE":
	{
		_vehArr pushback "CUP_O_C47_SLA";
		_vehArr pushback "CUP_C_AN2_AEROSCHROT_TK_CIV";
		_vehArr pushback "CUP_C_MI6A_RU";
		_vehArr pushback "NLD_C130H_VIV";
		_vehArr pushback "NLD_CH47F_ViV";
		_vehArr pushback "NLD_NH90";

		_crateArr pushback "CUP_BOX_US_ARMY_Ammo_F";
		_crateArr pushback "NLD_Ammo_Crate_Munitie";
		_crateArr pushback "NLD_Ammo_Crate_Explosieven";
		_crateArr pushback "NLD_Ammo_Crate_Medisch";
		_crateArr pushback "NLD_Ammo_Crate_Wapens";

		_loadArr pushback "M2 HMG";
		_loadArr pushback "Mk6 Morter";
		_loadArr pushback "Remote Designator";
		_loadArr pushback "King Quad";
		_loadArr pushback "VW Amarok";
		_loadArr pushback "MB G280 CDI";
		_loadArr pushback "Assault Boat";
		_loadArr pushback "FRISC Motorboat";
	};
	case "GM":
	{
		_vehArr pushback "gm_ge_army_ch53g";
		_vehArr pushback "gm_ge_army_ch53gs";
		_vehArr pushback "gm_gc_airforce_mi2t";
		_vehArr pushback "gm_ge_army_bo105m_vbh";
		_vehArr pushback "gm_ge_airforce_do28d2";
		_vehArr pushback "gm_gc_airforce_l410t";

		_crateArr pushback "gm_ammobox_aluminium_01_empty";
		_crateArr pushback "gm_fortification_crate_05";
		_crateArr pushback "gm_ammobox_aluminium_04_empty";
		_crateArr pushback "gm_fortification_crate_03";
		_crateArr pushback "gm_ammobox_aluminium_02_empty";
		_crateArr pushback "gm_fortification_crate_01";

		_loadArr pushback "K125 Motor";
		_loadArr pushback "Pkw 2 Beatle";
		_loadArr pushback "Pkw 8 VW";
		_loadArr pushback "Jeep Cargo";
		_loadArr pushback "Jeep MG3";
		_loadArr pushback "Jeep LATGM";
	};
	case "VN":
	{
		_vehArr pushback "vnx_b_air_ac119_03_01";
		_vehArr pushback "vn_b_air_ch47_03_01";
		_vehArr pushback "vn_i_air_ch34_01_02";
		_vehArr pushback "vn_o_air_mi2_01_01";
		_vehArr pushback "vn_b_air_uh1b_01_01";

		_crateArr pushback "vn_b_ammobox_kit_anzac";
		_crateArr pushback "vn_o_ammobox_full_10";
		_crateArr pushback "vn_b_ammobox_full_33";
		_crateArr pushback "vn_o_ammobox_full_02";
		_crateArr pushback "vn_b_ammobox_supply_12";
		_crateArr pushback "vn_b_ammobox_full_10";

		_loadArr pushback "Anti Tank TOW";
		_loadArr pushback "Howitser";
		_loadArr pushback "Mortar";
		_loadArr pushback "Jeep";
		_loadArr pushback "Jeep MG";
		_loadArr pushback "Gun Boat";
	};
};

{
	_vehName = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
	lbAdd [531, _vehName];
	lbSetData [531, _forEachIndex, _x];
}forEach _vehArr;
lbSetCurSel [531,0];

{
	_crateName = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
	lbAdd [533, _crateName];
	lbSetData [533, _forEachIndex, _x];
}forEach _crateArr;
lbSetCurSel [533,0];

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
