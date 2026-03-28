/*

File: openTabletCrew.sqf
Author: Brainless_Ben

Description:
Open the Crew Tablet for the lowtac community

Dependancy:
Define_LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
Buttons.sqf

*/

createDialog "BB_LT_Tablet_Crew";
_ctrl = (findDisplay 700) displayCtrl 750;

// Checks which button to show for the on/off state
lt_param_timer = missionNameSpace getVariable ["lt_param_timer", 10];
lt_group_teleport = missionNameSpace getVariable ["lt_group_teleport", 0];

if (lt_param_timer > 1) then {ctrlShow [711,false]} else {ctrlShow [710,false]};
if (lt_group_teleport == 1) then {ctrlShow [712,false]} else {ctrlShow [713,false]};

_sideArr = TabletSettings get "SIDES";
_loadArr = TabletSettings get "LOAD";
_roleArr = TabletSettings get "ROLES";
_linkArr = TabletSettings get "LINK";
_itemArr = TabletSettings get "ITEM";
_weaponArr = TabletSettings get "WEAPON";
_gearArr = TabletSettings get "GEAR";

// Array with players for the list inside the tablet
_allPlayers = call BIS_fnc_listPlayers;
playerArr = [];
{
	_name = name _x;
	if (_name == "HC") exitWith {};
	playerArr pushBack _x;
	lbAdd [750, _name];
	switch (side _x) do 
	{
		case west: {lbSetColor [750, _forEachIndex, [0,0.3,0.6,1]];};
		case east: {lbSetColor [750, _forEachIndex, [0.5,0,0,1]];};
		case resistance: {lbSetColor [750, _forEachIndex, [0,0.5,0,1]];};
	};
} forEach _allPlayers;
lbSetCurSel [750, 0];

// Array with crate loadout is selected for the supply drop
{
	lbAdd [722, _x];
	lbSetData [722, _forEachIndex, _x];
}forEach _sideArr;
lbSetCurSel [722, 0];

{
	lbAdd [723, _x];
	lbSetData [723, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [723,0];

{
	lbAdd [752, _x];
	lbSetData [752, _forEachIndex, _x];
}forEach _roleArr;

{
	lbAdd [753, _x];
	lbSetData [753, _forEachIndex, _x];
}forEach _linkArr;

{
	lbAdd [754, _x];
	lbSetData [754, _forEachIndex, _x];
}forEach _itemArr;

{
	lbAdd [755, _x];
	lbSetData [755, _forEachIndex, _x];
}forEach _weaponArr;

{
	lbAdd [756, _x];
	lbSetData [756, _forEachIndex, _x];
}forEach _gearArr;

//While tablet is over keep updating these fields
while {!isNull findDisplay 700} do 
{
	_object = cursorObject;
	if (_object isKindOf "ReammoBox_F" OR _object isKindOf "Car" OR _object isKindOf "Tank" OR _object isKindOf "Air" OR _object isKindOf "Ship") then 
	{
		_vehRole = _object getVariable ["LT_veh_role", "Empty"];
		_vehSide = _object getVariable ["LT_veh_side", "WEST"];
		_vehicle = getText (configFile >> "cfgVehicles" >> typeOf _object >> "displayName");
		_textChk = ctrlText 721;

		if (_textChk != _vehicle) then 
		{
			ctrlSetText [721, _vehicle];
			lbSetCurSel [722, _sideArr find _vehSide];
			lbSetCurSel [723, _loadArr find _vehRole];
		};
	}else 
	{
		_text = "No object detected";
		ctrlSetText [721, _text];
	};

	_index = lbCurSel 750;
	_player = playerArr select _index;
	_playerRole = _player getVariable ["LT_unit_role", "custom"];
	_playerLink = _player getVariable ["LT_unit_link", true];
	_playerItem = _player getVariable ["LT_unit_item", true];
	_playerWeap = _player getVariable ["LT_unit_weapon", true];
	_playerGear = _player getVariable ["LT_unit_gear", true];
	_text = format["Link:%1 Item:%2 Wpn:%3 Gear:%4", _playerLink, _playerItem, _playerWeap, _playerGear];
	_textCheck = ctrlText 751;

	if (_textCheck != _text) then 
	{
		ctrlSetText [751, _text];
		lbSetCurSel [752, _roleArr find _playerRole];
		if (_playerLink) then {lbSetCurSel [753, 1]} else {lbSetCurSel [753, 0]};
		if (_playerItem) then {lbSetCurSel [754, 1]} else {lbSetCurSel [754, 0]};
		if (_playerWeap) then {lbSetCurSel [755, 1]} else {lbSetCurSel [755, 0]};
		if (_playerGear) then {lbSetCurSel [756, 1]} else {lbSetCurSel [756, 0]};
	};
	sleep 1;
};