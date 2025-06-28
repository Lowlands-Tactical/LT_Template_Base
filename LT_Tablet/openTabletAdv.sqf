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

// Array with players for the list inside the tablet
_allPlayers = call BIS_fnc_listPlayers;
playerAdvArr = [];
{
	playerAdvArr pushBack _x;
	_name = name _x;
	if (_name == "HC") exitWith {};
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
_sideArr = ["WEST","EAST","GUER"];
{
	lbAdd [620, _x];
	lbSetData [620, _forEachIndex, _x];
}forEach _sideArr;
lbSetCurSel [620, 0];

_loadArr = ["Empty","Custom","Crate Small","Crate Medium","Crate Large","Crate Explosives","Crate Mines","Crate Medical","Crate Weapons","Crate NVG","Crate Comms","Crate Air","Crate UAV"]; //every case in LT_fnc_vehicleLoadout
{
	lbAdd [621, _x];
	lbSetData [621, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [621,0];

_roleArr = ["com","sql","jtac","ftl","gren","comms","rifl","riflat","dmr","ar","aar","medic","eng","vhco","vhgu","vhdr","pilot","crew","jet","lvdw"];
{
	lbAdd [631, _x];
	lbSetData [631, _forEachIndex, _x];
}forEach _roleArr;

_gearArr = ["No Gear","Yes Gear"];
{
	lbAdd [632, _x];
	lbSetData [632, _forEachIndex, _x];
}forEach _gearArr;

_itemArr = ["No Items","Yes Items"];
{
	lbAdd [633, _x];
	lbSetData [633, _forEachIndex, _x];
}forEach _itemArr;

//While tablet is over keep updating these fields
while {!isNull findDisplay 600} do 
{
	_object = cursorObject;
	if (_object isKindOf "ReammoBox_F" OR _object isKindOf "Car" OR _object isKindOf "Tank" OR _object isKindOf "Air" OR _object isKindOf "Ship") then 
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
	_player = playerAdvArr select _index;
	_playerRole = _player getVariable ["LT_unit_role", "custom"];
	_playerGear = _player getVariable ["LT_unit_gear", 1];
	_playerItem = _player getVariable ["LT_unit_item", 1];
	_text = format["Side:%1 Role:%2 Gear:%3 Items:%4", side _player, _playerRole, _playerGear, _playerItem];
	_textCheck = ctrlText 630;

	if (_textCheck != _text) then 
	{
		ctrlSetText [630, _text];
		lbSetCurSel [631, _roleArr find _playerRole];
		if (_playerGear == 1) then {lbSetCurSel [632, 1]} else {lbSetCurSel [632, 0]};
		if (_playerItem == 1) then {lbSetCurSel [633, 1]} else {lbSetCurSel [633, 0]};
	};
	sleep 1;
};
