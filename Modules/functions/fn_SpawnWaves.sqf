/*

File: fn_spawnWaves.sqf
Author: Lowlands Tactical

Description:
Shared spawn logic for the UnitSpawner, Defense and CustomCompSpawner modules.
The module functions (LT_fnc_UnitSpawner, LT_fnc_Defense and LT_fnc_CustomCompSpawner)
only call this function with their mode. The module settings are read with the
mode as prefix, for example "UnitSpawner_Waves" or "Defense_Waves".

Modes:
"UnitSpawner"       = Units of a faction spawn at the module and walk the waypoint markers.
"Defense"           = Units of a faction spawn away from the defense position and attack it.
"CustomCompSpawner" = Same as UnitSpawner, but with your own side and class lists.

Parameters:
_this select 0 = Mode (String)
_this select 1 = Module logic (Object)

Example:
["UnitSpawner", _logic] call LT_fnc_spawnWaves;

Return value:
True (if all waves succesfully spawned), false (if a check failed)

Note:
This function uses sleep and waitUntil, so it has to run in the scheduled environment.

*/

params [
	["_mode", "", [""]],
	["_logic", objNull, [objNull]]
];

// Declare all local variables
private [
	"_prefix","_isDefense","_isCustom","_waves",
	"_unitCap","_waveDelay","_infSize","_combatMode",
	"_behaviour","_formation","_speedMode","_totalAmt",
	"_faction","_blackList","_searchArea","_waypointsLoc",
	"_lastWaypoint","_mrkDefPos","_direction","_minSpawnDis",
	"_maxSpawnDis","_spawnMarkers","_side","_classes",
	"_infArr","_vehArr","_mechArr","_armorArr",
	"_className","_displayName","_textSingular","_randomAmt",
	"_maxAmt","_waveAmt","_defensePos","_defenseMarker",
	"_searchMarker","_addMoveWaypoint","_unitTypes","_unitType",
	"_typeIndex","_groupAmt","_classArr","_spawnDir",
	"_spawnArea","_spawnDis","_markerList","_spawnPos",
	"_grp","_unit","_vehicle","_waypointCnt",
	"_wpPos","_wp"
];

if !(isServer) exitWith {false};

if !(_mode in ["UnitSpawner", "Defense", "CustomCompSpawner"]) exitWith
{
	["spawnWaves", format ["Unknown mode '%1'", _mode], 3] call LT_fnc_log;
	false
};
if (isNull _logic) exitWith
{
	[_mode, "No module logic given", 3] call LT_fnc_log;
	false
};

_prefix = _mode + "_";
_isDefense = (_mode == "Defense");
_isCustom = (_mode == "CustomCompSpawner");

// Wave settings
_waves = _logic getVariable [_prefix + "Waves", 3];
_unitCap = _logic getVariable [_prefix + "UnitCap", 200];
_waveDelay = _logic getVariable [_prefix + "WaveDelay", [30,60,90]];

// Group settings
_infSize = _logic getVariable [_prefix + "InfantryGroupSize", 8];
_combatMode = _logic getVariable [_prefix + "CombatMode", "YELLOW"];
_behaviour = _logic getVariable [_prefix + "Behaviour", "AWARE"];
_formation = _logic getVariable [_prefix + "Formation", "WEDGE"];
_speedMode = _logic getVariable [_prefix + "SpeedMode", "NORMAL"];

// Amount settings (infantry, vehicles, mechanized, armor)
_totalAmt = [
	["InfantryAmount", ["1"]],
	["VehicleAmount", ["0"]],
	["MechanizedAmount", ["0"]],
	["ArmorAmount", ["0"]]
] apply {
	_x params ["_name", "_default"];
	parseSimpleArray ((str (_logic getVariable [_prefix + _name, _default])) splitString """" joinString "")
};

// Settings that differ per mode
_faction = "";
_blackList = [];
_searchArea = 50;
_waypointsLoc = [];
_lastWaypoint = "Patrol";
_mrkDefPos = "";
_direction = 0;
_minSpawnDis = 500;
_maxSpawnDis = 1500;
_spawnMarkers = [[], [], [], []];

if (_isDefense) then
{
	_faction = _logic getVariable ["Defense_Faction", "OPF_F"];
	_blackList = _logic getVariable ["Defense_BlackList", []];
	_searchArea = _logic getVariable ["Defense_SearchAreaSize", 100];
	_mrkDefPos = _logic getVariable ["Defense_Marker", ""];
	_direction = parseNumber (_logic getVariable ["Defense_Direction", "0"]);
	_minSpawnDis = _logic getVariable ["Defense_MinSpawnDistance", 500];
	_maxSpawnDis = _logic getVariable ["Defense_MaxSpawnDistance", 1500];
	_spawnMarkers = [
		"Defense_MarkerInfantrySpawn",
		"Defense_MarkerVehicleSpawn",
		"Defense_MarkerMechSpawn",
		"Defense_MarkerArmorSpawn"
	] apply {(_logic getVariable [_x, ""]) splitString " ,'"};
} else
{
	if !(_isCustom) then
	{
		_faction = _logic getVariable [_prefix + "Faction", "OPF_F"];
		_blackList = _logic getVariable [_prefix + "BlackList", []];
	};
	_searchArea = _logic getVariable [_prefix + "SearchArea", 50];
	_lastWaypoint = _logic getVariable [_prefix + "LastWaypoint", "Patrol"];
	_waypointsLoc = (_logic getVariable [_prefix + "Waypoints", []]) apply {getMarkerPos _x};
};

[_mode, format ["Module:%1  Faction:%2  BlackList:%3", _logic, _faction, _blackList],2] call LT_fnc_log;
[_mode, format ["Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _totalAmt select 0, _totalAmt select 1, _totalAmt select 2, _totalAmt select 3],2] call LT_fnc_log;
[_mode, format ["Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay],2] call LT_fnc_log;
[_mode, format ["CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode],2] call LT_fnc_log;

// preChecks to ensure everything runs smoothly
if (!_isCustom && {_faction == "" || {!(_faction in ([] call bis_fnc_getFactions))}}) exitWith
{
	[_mode, "There is no faction selected or there is a typo", 3] call LT_fnc_log;
	false
};
if (_isDefense && {(_maxSpawnDis - _minSpawnDis) <= 0}) exitWith
{
	[_mode, "Max distance must be bigger than min distance", 3] call LT_fnc_log;
	false
};
if (_infSize <= 1) exitWith
{
	[_mode, "Infantry group size is too low", 3] call LT_fnc_log;
	false
};

// Define side and class arrays (infantry, vehicles, mechanized, armor)
_side = sideUnknown;
_classes = [[], [], [], []];

if (_isCustom) then
{
	_side = switch (_logic getVariable ["CustomCompSpawner_Side", "WEST"]) do
	{
		case "EAST": {east};
		case "GUER": {resistance};
		case "CIV": {civilian};
		default {west};
	};
	_classes = [
		_logic getVariable ["CustomCompSpawner_InfClasses", ["B_Soldier_F"]],
		_logic getVariable ["CustomCompSpawner_VehClasses", ["B_MRAP_01_F"]],
		_logic getVariable ["CustomCompSpawner_MechClasses", ["B_APC_Wheeled_01_cannon_v2_F"]],
		_logic getVariable ["CustomCompSpawner_ArmorClasses", ["B_MBT_01_cannon_F"]]
	];
} else
{
	_side = [[_faction]] call bis_fnc_getFactions;

	_infArr = [];
	_vehArr = [];
	_mechArr = [];
	_armorArr = [];
	{
		_className = configName _x;
		if !(_className in _blackList) then
		{
			_displayName = getText (_x >> "displayName");
			_textSingular = getText (_x >> "textSingular");
			if (_textSingular == "Infantry" && {!(["Uniform", _displayName] call bis_fnc_inString)}) then {_infArr pushBack _className;};
			if (_textSingular in ["MRAP", "Car"]) then {_vehArr pushBack _className;};
			if (_textSingular == "APC") then {_mechArr pushBack _className;};
			if (_textSingular == "Tank") then {_armorArr pushBack _className;};
		};
	} forEach ("(getText (_x >> 'faction') == _faction) && (getNumber (_x >> 'scope') == 2)" configClasses (configFile >> "CfgVehicles"));
	_classes = [_infArr, _vehArr, _mechArr, _armorArr];
};

[_mode, format ["Side:%1  Infantry:%2", _side, _classes select 0],2] call LT_fnc_log;
[_mode, format ["Vehicles:%1  Mechanized:%2  Armor:%3", _classes select 1, _classes select 2, _classes select 3],2] call LT_fnc_log;

// Define wave settings and amounts
_randomAmt = [0,1,2,3];
_maxAmt = selectMax (_totalAmt apply {count _x});
{
	// First value -1 means random amounts
	if ((_x select 0) == -1) then
	{
		_x resize 0;
		for "_i" from 1 to _maxAmt do {_x pushBack (selectRandom _randomAmt);};
	};
	if ((count _x) != _maxAmt) then {_x resize [_maxAmt, 0];};
	if (_waves != -1 && {(count _x) != _waves}) then {_x resize [_waves, (_x select 0)];};
} forEach _totalAmt;
_waveAmt = if (_waves != -1) then {_waves} else {_maxAmt};

[_mode, format ["Max amount:%1  Wave amount:%2  TotalAmount:%3", _maxAmt, _waveAmt, _totalAmt],2] call LT_fnc_log;

// Defense: position and area that the groups attack
_defensePos = [0,0,0];
_defenseMarker = "";
if (_isDefense) then
{
	_defensePos = if (_mrkDefPos == "") then {getPos _logic} else {getMarkerPos _mrkDefPos};
	if (_mrkDefPos == "" || {markerShape _mrkDefPos == "ICON"}) then
	{
		_defenseMarker = createMarker [format ["LT_DefenseArea_%1", netId _logic], _defensePos];
		_defenseMarker setMarkerShape "ELLIPSE";
		_defenseMarker setMarkerSize [_searchArea, _searchArea];
		_defenseMarker setMarkerAlpha 0;
	} else
	{
		// Rectangle or ellipse marker: use the size of that marker
		_defenseMarker = _mrkDefPos;
		_searchArea = selectMax (getMarkerSize _mrkDefPos);
	};
	[_mode, format ["Defense position:%1  Search area:%2", _defensePos, _searchArea],2] call LT_fnc_log;
};

// UnitSpawner and CustomCompSpawner: marker for the "Search" last waypoint
_searchMarker = "";
if (!_isDefense && {_lastWaypoint == "Search"} && {count _waypointsLoc > 0}) then
{
	_searchMarker = createMarker [format ["LT_SearchArea_%1", netId _logic], _waypointsLoc select (count _waypointsLoc - 1)];
	_searchMarker setMarkerShape "ELLIPSE";
	_searchMarker setMarkerSize [_searchArea, _searchArea];
	_searchMarker setMarkerAlpha 0;
};

// Add a MOVE waypoint (returns the waypoint)
_addMoveWaypoint =
{
	params ["_grp", "_pos"];
	[_grp, _pos, 5, "MOVE", _behaviour, _combatMode, _speedMode, _formation, "", [0.3, 0.6, 0.9]] call cba_fnc_addWaypoint
};

_unitTypes = ["Infantry", "Vehicles", "Mechanized", "Armored"];

// Initialise waves
for "_i" from 1 to _waveAmt do
{
	// Set variable and log wave number (Defense only stores the wave number)
	_logic setVariable [format ["LT_%1Wave", _mode], if (_isDefense) then {_i} else {[_i, _logic]}, true];
	[_mode, format ["Wave:%1/%2", _i, _waveAmt],2] call LT_fnc_log;

	{
		_unitType = _x;
		_typeIndex = _forEachIndex;
		_groupAmt = (_totalAmt select _typeIndex) select (_i - 1);
		_classArr = _classes select _typeIndex;

		if (_groupAmt > 0 && {_classArr isEqualTo []}) then
		{
			[_mode, format ["No classes found for %1, skipped", _unitType], 1] call LT_fnc_log;
		} else
		{
			for "_n" from 1 to _groupAmt do
			{
				// Wait until allUnits is below UnitCap
				if (_unitCap < (count allUnits)) then
				{
					waitUntil {sleep 5; _unitCap > (count allUnits)};
				};

				// Spawn position
				_spawnDir = random [(getDir _logic) - 10, getDir _logic, (getDir _logic) + 10];
				_spawnArea = _logic getPos [5, _spawnDir];
				if (_isDefense) then
				{
					_spawnDis = random [_minSpawnDis, (_maxSpawnDis + _minSpawnDis) / 2, _maxSpawnDis];
					_markerList = _spawnMarkers select _typeIndex;
					_spawnArea = switch (true) do
					{
						case (_direction == 1): {_defensePos getPos [_spawnDis, random 360]};
						case (_direction == 2 && {_markerList isNotEqualTo []}): {getMarkerPos (selectRandom _markerList)};
						default {_defensePos getPos [_spawnDis, _spawnDir]};
					};
				};
				_spawnPos = _spawnArea findEmptyPosition [0, 40];
				if (_spawnPos isEqualTo []) then {_spawnPos = _spawnArea;};

				// Spawn the group
				_grp = createGroup _side;
				if (_unitType == "Infantry") then
				{
					for "_u" from 1 to _infSize do
					{
						_unit = _grp createUnit [selectRandom _classArr, _spawnPos, [], 3, "NONE"];
						[_unit] joinSilent _grp;
						sleep 0.3;
					};
				} else
				{
					_vehicle = [_spawnPos, _spawnDir, selectRandom _classArr, _grp] call bis_fnc_spawnVehicle;

					// Fill the empty cargo seats with infantry (not for armor)
					if (_unitType != "Armored" && {(_classes select 0) isNotEqualTo []}) then
					{
						{
							if (isNull (_x select 0)) then
							{
								_unit = _grp createUnit [selectRandom (_classes select 0), _spawnPos, [], 3, "CARGO"];
								[_unit] joinSilent _grp;
							};
						} forEach (fullCrew [_vehicle select 0, "cargo", true]);
					};
				};

				// Orders
				if (_isDefense) then
				{
					_grp setCombatMode _combatMode;
					_grp setBehaviourStrong _behaviour;
					_grp setFormation _formation;
					_grp setSpeedMode _speedMode;

					if (_unitType == "Infantry" && {!isNil "lambs_wp_fnc_taskAssault"}) then
					{
						[_grp, getMarkerPos _defenseMarker] spawn lambs_wp_fnc_taskAssault;
					} else
					{
						[_grp, getMarkerPos _defenseMarker, _searchArea] call cba_fnc_taskAttack;
					};
				} else
				{
					_waypointCnt = count _waypointsLoc;
					for "_idx" from 0 to (_waypointCnt - 1) do
					{
						_wpPos = _waypointsLoc select _idx;
						if (_idx != (_waypointCnt - 1)) then
						{
							[_grp, _wpPos] call _addMoveWaypoint;
						} else
						{
							switch (_lastWaypoint) do
							{
								case "": {[_grp, _wpPos] call _addMoveWaypoint;};
								case "Attack": {[_grp, _wpPos, _searchArea] call cba_fnc_taskAttack;};
								case "Defend": {[_grp, _wpPos, _searchArea] call cba_fnc_taskDefend;};
								case "Garrison": {[_grp, _wpPos] execVM "\x\cba\addons\ai\fnc_waypointGarrison.sqf";};
								case "Patrol": {[_grp, _wpPos, _searchArea, 10, "MOVE", _behaviour, _combatMode, _speedMode, _formation, "", [0.3, 0.6, 0.9]] call cba_fnc_taskPatrol;};
								case "Search": {[_grp, _searchMarker] call cba_fnc_taskSearchArea;};
								case "Delete":
								{
									_wp = [_grp, _wpPos] call _addMoveWaypoint;
									_wp setWaypointStatements ["true", "[(group this)] call LT_fnc_deleteUnits;"];
								};
							};
						};
					};
				};
			};
		};
	} forEach _unitTypes;

	// Wait for the next wave (not after the last wave)
	if (_i < _waveAmt) then {sleep (random _waveDelay);};
};

true
