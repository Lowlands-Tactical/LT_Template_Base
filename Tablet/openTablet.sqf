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

_missionPeriod = MissionSettings get "Period";
_vehArr = TabletSettings get "VEH";
_crateArr = TabletSettings get "CRATE";
_loadArr = TabletSettings get "LOAD";
_extraArr = ((TabletSettings get "EXTRA") get _missionPeriod);

// Array with players for the list inside the tablet
_allPlayers = call BIS_fnc_listPlayers;
playerArr = [];
_pIndex = 0;
{
	_name = name _x;
	if (_name == "HC") exitWith {};
	playerArr pushBack _x;
	lbAdd [550, _name];
	switch (side _x) do 
	{
		case west: {lbSetColor [550, _forEachIndex, [0,0.3,0.6,1]];};
		case east: {lbSetColor [550, _forEachIndex, [0.5,0,0,1]];};
		case resistance: {lbSetColor [550, _forEachIndex, [0,0.5,0,1]];};
	};
	if (_name == name player) then {_pIndex = _forEachindex};
}forEach _allPlayers;
lbSetCurSel [550,_pIndex];

// Add period appropriate vehicles/crates/loadouts
_vehExtrArr = _extraArr get "VEH";
{
	_vehArr pushback _x;
}forEach _vehExtrArr;
_crateExtrArr = _extraArr get "CRATE";
{
	_crateArr pushback _x;
}forEach _crateExtrArr;
_loadExtrArr = _extraArr get "LOAD";
{
	_loadArr pushback _x;
}forEach _loadExtrArr;

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
	_loadName = _x;
	lbAdd [535, _loadName];
	lbSetData [535, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [535,1];
{
	_loadName = _x;
	lbAdd [536, _loadName];
	lbSetData [536, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [536,0];
{
	_loadName = _x;
	lbAdd [537, _loadName];
	lbSetData [537, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [537,0];

//While tablet is over keep updating these fields
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
