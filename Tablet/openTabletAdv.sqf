/*

File: openTabletAdv.sqf
Author: Brainless_Ben

Description:
Open the Advanced Admin Tablet for the lowtac community

Dependancy:
Define_LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
LT_Tablet.hpp (Also need to be included in description.ext or config.cpp)
Buttons.sqf

*/

createDialog "BB_LT_Tablet_Advanced";
_ctrl = (findDisplay 600) displayCtrl 650;

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
	lbAdd [650, _name];
	switch (side _x) do 
	{
		case west: {lbSetColor [650, _forEachIndex, [0,0.3,0.6,1]];};
		case east: {lbSetColor [650, _forEachIndex, [0.5,0,0,1]];};
		case resistance: {lbSetColor [650, _forEachIndex, [0,0.5,0,1]];};
	};
} forEach _allPlayers;
lbSetCurSel [650, 0];

// Array with crate loadout is selected for the supply drop
{
	lbAdd [620, _x];
	lbSetData [620, _forEachIndex, _x];
}forEach _sideArr;
lbSetCurSel [620, 0];

{
	lbAdd [621, _x];
	lbSetData [621, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [621,0];

{
	lbAdd [631, _x];
	lbSetData [631, _forEachIndex, _x];
}forEach _roleArr;

{
	lbAdd [632, _x];
	lbSetData [632, _forEachIndex, _x];
}forEach _linkArr;

{
	lbAdd [633, _x];
	lbSetData [633, _forEachIndex, _x];
}forEach _itemArr;

{
	lbAdd [634, _x];
	lbSetData [634, _forEachIndex, _x];
}forEach _weaponArr;

{
	lbAdd [635, _x];
	lbSetData [635, _forEachIndex, _x];
}forEach _gearArr;

//While tablet is over keep updating these fields
while {!isNull findDisplay 600} do 
{
	_object = cursorObject;
	if (_object isKindOf "ReammoBox_F" OR _object isKindOf "LandVehicle" OR _object isKindOf "Air" OR _object isKindOf "Ship") then 
	{
		_vehRole = _object getVariable ["LT_veh_role", "Empty"];
		_vehSide = _object getVariable ["LT_veh_side", "WEST"];
		_vehicle = getText (configFile >> "cfgVehicles" >> typeOf _object >> "displayName");
		_textChk = ctrlText 619;

		if (_textChk != _vehicle) then 
		{
			ctrlSetText [619, _vehicle];
			lbSetCurSel [620, _sideArr find _vehSide];
			lbSetCurSel [621, _loadArr find _vehRole];
		};
	}else 
	{
		_text = "No object detected";
		ctrlSetText [619, _text];
	};

	_index = lbCurSel 650;
	_player = playerArr select _index;
	_playerRole = _player getVariable ["LT_unit_role", "custom"];
	_playerLink = _player getVariable ["LT_unit_link", true];
	_playerItem = _player getVariable ["LT_unit_item", true];
	_playerWeap = _player getVariable ["LT_unit_weapon", true];
	_playerGear = _player getVariable ["LT_unit_gear", true];
	_text = format["Link:%1 Item:%2 Wpn:%3 Gear:%4", _playerLink, _playerItem, _playerWeap, _playerGear];
	_textCheck = ctrlText 630;

	if (_textCheck != _text) then 
	{
		ctrlSetText [630, _text];
		lbSetCurSel [631, _roleArr find _playerRole];
		if (_playerLink) then {lbSetCurSel [632, 1]} else {lbSetCurSel [632, 0]};
		if (_playerItem) then {lbSetCurSel [633, 1]} else {lbSetCurSel [633, 0]};
		if (_playerWeap) then {lbSetCurSel [634, 1]} else {lbSetCurSel [634, 0]};
		if (_playerGear) then {lbSetCurSel [635, 1]} else {lbSetCurSel [635, 0]};
	};
	sleep 1;
};