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

// Array with players for the list inside the tablet
_allPlayers = call BIS_fnc_listPlayers;
playercrewArr = [];
{
	playercrewArr pushBack _x;
	_name = name _x;
	if (_name == "HC") exitWith {};
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
_sideArr = ["WEST","EAST","GUER"];
{
	lbAdd [722, _x];
	lbSetData [722, _forEachIndex, _x];
}forEach _sideArr;
lbSetCurSel [722, 0];

_loadArr = ["Empty","Custom","Crate Small","Crate Medium","Crate Large","Crate Explosives","Crate Mines","Crate Medical","Crate Weapons","Crate NVG","Crate Comms","Crate Air","Crate UAV"]; //every case in LT_fnc_vehicleLoadout
{
	lbAdd [723, _x];
	lbSetData [723, _forEachIndex, _x];
}forEach _loadArr;
lbSetCurSel [723,0];

_roleArr = ["com","sql","jtac","ftl","gren","comms","rifl","riflat","riflaa","dmr","ar","aar","medic","eng","hmg","hmga","vhco","vhgu","vhdr","pilot","crew","jet","lvdw"];
{
	lbAdd [752, _x];
	lbSetData [752, _forEachIndex, _x];
}forEach _roleArr;

_gearArr = ["No Gear","Yes Gear"];
{
	lbAdd [753, _x];
	lbSetData [753, _forEachIndex, _x];
}forEach _gearArr;

_itemArr = ["No Items","Yes Items"];
{
	lbAdd [754, _x];
	lbSetData [754, _forEachIndex, _x];
}forEach _itemArr;

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
	_player = playercrewArr select _index;
	_playerRole = _player getVariable ["LT_unit_role", "custom"];
	_playerGear = _player getVariable ["LT_unit_gear", 1];
	_playerItem = _player getVariable ["LT_unit_item", 1];
	_text = format["Side:%1 Role:%2 Gear:%3 Items:%4", side _player, _playerRole, _playerGear, _playerItem];
	_textCheck = ctrlText 751;

	if (_textCheck != _text) then 
	{
		ctrlSetText [751, _text];
		lbSetCurSel [752, _roleArr find _playerRole];
		if (_playerGear == 1) then {lbSetCurSel [753, 1]} else {lbSetCurSel [753, 0]};
		if (_playerItem == 1) then {lbSetCurSel [754, 1]} else {lbSetCurSel [754, 0]};
	};
	sleep 1;
};
