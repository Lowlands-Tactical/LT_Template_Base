/*

File: fn_respawnGroupTargets.sqf
Author: Lowlands Tactical

Description:
Builds the list of places a player can deploy to after a respawn.
Own group first, then other players of the same side, then vehicles that are marked
as respawn point in Eden (LT_veh_respawnPoint). Every entry gets a status:
enemy within the block distance or no free seat = blocked, enemy within the warn distance = warning.
Used by the menu (client) and by the server to validate a request.

Settings (optional, set them in the mission with missionNamespace setVariable):
LT_respawnGroup_blockDist = distance to enemies where deploying is blocked (default 50)
LT_respawnGroup_warnDist = distance to enemies where a warning is shown (default 100)

Parameters:
_this select 0 = Unit that wants to deploy (Object)

Example:
_targets = [player] call LT_fnc_respawnGroupTargets;

Return value:
Array of entries: [category, object, label, status, note, distance]
category: 0 = own group, 1 = other player, 2 = respawn vehicle
status: 0 = ok, 1 = warning, 2 = blocked
Sorted on category and distance.

*/

params [["_unit", objNull, [objNull]]];

// Declare all local variables
private [
	"_side", "_sideStr", "_blockDist", "_warnDist",
	"_paraMode", "_ownGroup", "_isHostile", "_crew",
	"_map", "_headless", "_man", "_vehicle",
	"_cat", "_key", "_previous", "_veh",
	"_vehSide", "_result", "_isMan", "_flagged",
	"_label", "_customName", "_players", "_status",
	"_note", "_dist", "_enemyDist", "_freeSeats"
];

if (isNull _unit) exitWith {[]};

_side = side group _unit;
_sideStr = switch (_side) do
{
	case west: {"WEST"};
	case east: {"EAST"};
	case resistance: {"GUER"};
	default {"CIV"};
};
_blockDist = missionNamespace getVariable ["LT_respawnGroup_blockDist", 50];
_warnDist = missionNamespace getVariable ["LT_respawnGroup_warnDist", 100];
_paraMode = ("lt_respawngroup_mode" call BIS_fnc_getParamValue) == 1;
_ownGroup = group _unit;

// Check if an entity (man or vehicle with crew) is hostile to the given side
_isHostile =
{
	params ["_entity", "_mySide"];
	_crew = if (_entity isKindOf "CAManBase") then {[_entity]} else {crew _entity};
	(_crew findIf {alive _x && {side group _x != civilian} && {_mySide getFriend (side group _x) < 0.6}}) >= 0
};

// Collect players and own group, if a man sits in a vehicle the vehicle is the target
_map = createHashMap;
_headless = entities "HeadlessClient_F";
{
	_man = _x;
	if (_man != _unit && {alive _man} && {!(_man in _headless)} && {side group _man == _side} && {lifeState _man != "INCAPACITATED"} && {!(_man getVariable ["ACE_isUnconscious", false])}) then
	{
		_vehicle = vehicle _man;
		if (_vehicle != vehicle _unit) then
		{
			_cat = if (group _man == _ownGroup) then {0} else {1};
			_key = netId _vehicle;
			_previous = _map getOrDefault [_key, [9, objNull]];
			if (_cat < (_previous select 0)) then {_map set [_key, [_cat, _vehicle]];};
		};
	};
} forEach ((units _ownGroup) + allPlayers);

// Add the vehicles that are a respawn point
{
	_veh = _x;
	if (alive _veh && {(_veh getVariable ["LT_veh_respawnPoint", false]) isEqualTo true}) then
	{
		_vehSide = _veh getVariable ["LT_veh_side", "Custom"];
		if (!(_vehSide in ["WEST", "EAST", "GUER"]) || {_vehSide == _sideStr}) then
		{
			_key = netId _veh;
			_previous = _map getOrDefault [_key, [9, objNull]];
			if (2 < (_previous select 0)) then {_map set [_key, [2, _veh]];};
		};
	};
} forEach vehicles;

// Build the entries
_result = [];
{
	_x params ["_cat", "_obj"];
	_isMan = _obj isKindOf "CAManBase";
	_flagged = (_obj getVariable ["LT_veh_respawnPoint", false]) isEqualTo true;

	// Label
	_label = "";
	if (_isMan) then
	{
		_label = name _obj;
	} else
	{
		_customName = _obj getVariable ["LT_veh_respawnName", ""];
		if (_customName == "") then {_customName = getText (configOf _obj >> "displayName");};
		_label = _customName;
		_players = (crew _obj) select {isPlayer _x};
		if (!_flagged && {_players isNotEqualTo []}) then {_label = format ["%1 (%2)", name (_players select 0), _customName];};
	};

	_status = 0;
	_note = "";
	_dist = _unit distance _obj;

	// Closest enemy
	_enemyDist = 1e6;
	{
		if ([_x, _side] call _isHostile) then {_enemyDist = _enemyDist min (_obj distance _x);};
	} forEach (_obj nearEntities [["CAManBase", "LandVehicle", "Air", "Ship"], _warnDist]);

	if (_enemyDist <= _blockDist) then
	{
		_status = 2;
		_note = format ["enemy within %1 m", _blockDist];
	} else
	{
		if (_enemyDist <= _warnDist) then
		{
			_status = 1;
			_note = format ["WARNING: enemy within %1 m", _warnDist];
		};
	};

	// Vehicles need a free seat, except when deploying by parachute
	if (!_isMan && {!_paraMode} && {_status < 2}) then
	{
		_freeSeats = count ((fullCrew [_obj, "", true]) select {isNull (_x select 0)});
		if ((locked _obj) > 1) then
		{
			_status = 2;
			_note = "vehicle is locked";
		} else
		{
			if (_freeSeats == 0) then
			{
				_status = 2;
				_note = "no free seat";
			} else
			{
				if (_note == "") then {_note = format ["%1 free seats", _freeSeats];};
			};
		};
	};

	_result pushBack [(_cat * 1000000) + _dist + (_forEachIndex / 1000), [_cat, _obj, _label, _status, _note, _dist]];
} forEach (values _map);

_result sort true;
_result apply {_x select 1}
