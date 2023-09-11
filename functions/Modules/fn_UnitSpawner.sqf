/*

File: fn_UnitSpawner.sqf
Author: Brainless_Ben

Description:
Function for unitspawner module, processes module data to spawn units/vehicles/apcs/tanks.

Return value:
True (if all waves succesfully spawned)

*/

_logic = param [0,objNull,[objNull]];
_units = param [1,[],[[]]];
_activated = param [2,true,[true]];

if (_activated) then 
{
	if !(isServer) exitWith {};
	_searchArea = _logic getVariable ["UnitSpawner_SearchArea", 50];
	_faction = _logic getVariable ["UnitSpawner_Faction", "OPF_F"];
	_blackList = _logic getVariable ["UnitSpawner_BlackList", []];

	// Waypoint settings
	_waypoints = _logic getVariable ["UnitSpawner_Waypoints", []];
	_lastWaypoint = _logic getVariable ["UnitSpawner_LastWaypoint", "Patrol"];

	// Wave settings
	_waves = _logic getVariable ["UnitSpawner_Waves", 3];
	_unitCap = _logic getVariable ["UnitSpawner_UnitCap", 200];
	_waveDelay = _logic getVariable ["UnitSpawner_WaveDelay", [30,60,90]];

	// Amount settings
	_infAmt = parseSimpleArray ((str(_logic getVariable ["UnitSpawner_InfantryAmount", ["1"]])) splitString """" joinString "");
	_vehAmt = parseSimpleArray ((str(_logic getVariable ["UnitSpawner_VehicleAmount", ["0"]])) splitString """" joinString "");
	_mechAmt = parseSimpleArray ((str(_logic getVariable ["UnitSpawner_MechanizedAmount", ["0"]])) splitString """" joinString "");
	_armorAmt = parseSimpleArray ((str(_logic getVariable ["UnitSpawner_ArmorAmount", ["0"]])) splitString """" joinString "");

	// Group settings
	_infSize = _logic getVariable ["UnitSpawner_InfantryGroupSize", 8];
	_combatMode = _logic getVariable ["UnitSpawner_CombatMode", "YELLOW"];
	_behaviour = _logic getVariable ["UnitSpawner_Behaviour", "AWARE"];
	_formation = _logic getVariable ["UnitSpawner_Formation", "WEDGE"];
	_speedMode = _logic getVariable ["UnitSpawner_SpeedMode", "NORMAL"];

	_allFactions = [] call BIS_fnc_getFactions;

	Diag_Log format["[LT] (UnitSpawner) UnitSpawner Module:%1  Faction:%2  BlackList:%3", _logic, _faction, _blackList];
	Diag_Log format["[LT] (UnitSpawner) Waypoints:%1  Lastwaypoint task:%2", _waypoints, _lastWaypoint];
	Diag_Log format["[LT] (UnitSpawner) AllFactions: %1", _allFactions];
	Diag_Log format["[LT] (UnitSpawner) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
	Diag_Log format["[LT] (UnitSpawner) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
	Diag_Log format["[LT] (UnitSpawner) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (UnitSpawner) UnitSpawner Module:%1  Faction:%2  BlackList:%3", _logic, _faction, _blackList];
		systemChat format["[LT] (UnitSpawner) Waypoints:%1  Lastwaypoint task:%2", _waypoints, _lastWaypoint];
		systemChat format["[LT] (UnitSpawner) AllFactions: %1", _allFactions];
		systemChat format["[LT] (UnitSpawner) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
		systemChat format["[LT] (UnitSpawner) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
		systemChat format["[LT] (UnitSpawner) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	};

	// preChecks to ensure everything runs smoothly
	if (_faction == "" OR !(_faction in _allFactions)) exitWith 
	{
		Diag_Log "[LT] (UnitSpawner) There is no faction selected or there is a typo";
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (UnitSpawner) There is no faction selected or there is a typo";
		};
	};
	if (_infSize <= 1) exitWith 
	{
		Diag_Log "[LT] (UnitSpawner) Infantry amount is to low";
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (UnitSpawner) Infantry amount is to low";
		};
	};

	// Waypoint postions
	_waypointsLoc = [];
	{
		_position = getMarkerPos _x;
		_waypointsLoc pushBack _position;
	}forEach _waypoints;

	// Define Faction arrays
	_factionSide = [[_faction]] call BIS_fnc_getFactions;
	_factionInfArr = [];
	_factionVehArr = [];
	_factionMechArr = [];
	_factionArmorArr = [];
	{
		_className = configName _x;
		if !(_className in _blackList) then 
		{
			_vehicleClass = getText (configFile >> "CfgVehicles" >> _className >> "vehicleClass");
			_textSingular = getText (configFile >> "CfgVehicles" >> _className >> "textSingular");
			if (_textSingular == "Infantry") then 
			{
				_factionInfArr pushback _className;
			};
			if (_vehicleClass == "Car" AND _textSingular == "MRAP" OR _textSingular == "Car") then 
			{
				_factionVehArr pushback _className;
				};
			if (_vehicleClass == "Armored") then 
			{
				if (_textSingular == "APC") then 
				{
					_factionMechArr pushback _className;
				};
				if (_textSingular == "Tank") then 
				{
					_factionArmorArr pushback _className;
				};
			};
		};
	}forEach ("(getText (_x >> 'faction') == _faction)" configClasses (configfile >> "CfgVehicles"));

	// Define wave settings and amounts
	_randomAmt = [0,1,2,3];
	_maxAmt = selectMax [count _infAmt, count _vehAmt, count _mechAmt, count _armorAmt];
	_totalAmt = [_infAmt, _vehAmt, _mechAmt, _armorAmt];
	{
		_maxAmt = _maxAmt;
		if ((_x select 0) != -1) then {_x} else 
		{
			_x resize 0;
			for "_i" from 1 to _maxAmt do 
			{
				_x set [(_i - 1),(selectRandom _randomAmt)];
			};
		};
		if ((count _x) != _maxAmt) then 
		{
			_x resize [_maxAmt, 0];
		};
	}forEach _totalAmt;
	_waveAmt = if (_waves != -1) then {_waves} else {_maxAmt;};

	Diag_Log format["[LT] (UnitSpawner) Faction:%1 FactionSide:%2 BlackList:%3",_faction, _factionSide, _blackList];
	Diag_Log format["[LT] (UnitSpawner) InfantryClassArray:'%1' VehicleClassArray:'%2' MechanizedClassArray:'%3' ArmorClassArray:'%4'",_factionInfArr, _factionVehArr, _factionMechArr, _factionArmorArr];
	Diag_Log format["[LT] (UnitSpawner) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
	Diag_Log format["[LT] (UnitSpawner) TotalAmount:%1", _totalAmt];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (UnitSpawner) Faction:%1 FactionSide:%2 BlackList:%3",_faction, _factionSide, _blackList];
		systemChat format["[LT] (UnitSpawner) InfantryClassArray:'%1' VehicleClassArray:'%2' MechanizedClassArray:'%3' ArmorClassArray:'%4'",_factionInfArr, _factionVehArr, _factionMechArr, _factionArmorArr];
		systemChat format["[LT] (UnitSpawner) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
		systemChat format["[LT] (UnitSpawner) TotalAmount:%1", _totalAmt];
	};

	// Initialise waves
	for "_i" from 1 to _waveAmt do 
	{
		// Set variable and log wave number
		_logic setVariable ["LT_UnitSpawnerWave", [_i, _logic], true];

		Diag_Log format["[LT] (UnitSpawnerWave) Wave:%1/%2", _i, _waveAmt];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (UnitSpawnerWave) Wave:%1/%2", _i, _waveAmt];
		};
		hintSilent format["UnitSpawner Wave %1/%2 started", _i, _waveAmt];

		// Array of spawn amounts
		_indexNumber = _i - 1;
		_spawnAmount = [
			[_totalAmt select 0 select _indexNumber, "Infantry", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 1 select _indexNumber, "Vehicles", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 2 select _indexNumber, "Mechanized", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 3 select _indexNumber, "Armored", _waypointsLoc, [_infSize, _lastWaypoint]]
		];

		Diag_Log format["[LT] (UnitSpawnerWave) SpawnAmount:%1", _spawnAmount];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (UnitSpawnerWave) SpawnAmount:%1", _spawnAmount];
		};

		{
			_groupAmt = _x select 0;
			_unitType = _x select 1;
			_waypoints = _x select 2;
			_infSize = _x select 3 select 0;
			_lastWaypoint = _x select 3 select 1;

			for "_n" from 1 to _groupAmt do 
			{
				// Wait untill allUnits is below UnitCap
				waitUntil {(_unitCap > (count allUnits))};

				_infSize = _infSize -1;
				_spawnDir = random[(getDir _logic) - 10, getDir _logic, (getDir _logic) + 10];
				_spawnArea = _logic getPos [5, _spawnDir];
				_spawnPos = _spawnArea findEmptyPosition [0, 40];

				_grp = createGroup _factionSide;
				switch (_unitType) do 
				{
					case "Infantry": 
					{
						for "_u" from 0 to _infSize do 
						{
							_unit = selectRandom _factionInfArr;
							_unit createUnit [_spawnPos, _grp];
							sleep 0.3;
						};
					};
					case "Vehicles": 
					{
						_vehCar = selectRandom _factionVehArr;
						[_spawnPos, _spawnDir, _vehCar, _grp] call BIS_fnc_spawnVehicle;
					};
					case "Mechanized": 
					{
						_vehMech = selectRandom _factionMechArr;
						[_spawnPos, _spawnDir, _vehMech, _grp] call BIS_fnc_spawnVehicle;
					};
					case "Armored": 
					{
						_vehArmor = selectRandom _factionArmorArr;
						[_spawnPos, _spawnDir, _vehArmor, _grp] call BIS_fnc_spawnVehicle;
					};
				};

				// Waypoint
				_waypointCnt = count _waypoints;
				for [{_idx = 0},{_idx < _waypointCnt},{_idx = _idx + 1}] do
				{
					if (_idx != (_waypointCnt - 1)) then 
					{
						[_grp, (_waypoints select _idx), 5, "MOVE", _behaviour, _combatMode, _speedMode, _formation, "", [0.3, 0.6, 0.9]] call CBA_fnc_addWaypoint;
					} else
					{
						switch (_lastWaypoint) do 
						{
							case "": 
							{
								[_grp, (_waypoints select _idx), 5, "MOVE", _behaviour, _combatMode, _speedMode, _formation, "", [0.3, 0.6, 0.9]] call CBA_fnc_addWaypoint;
							};
							case "Attack": 
							{
								[_grp, (_waypoints select _idx), _searchArea] call CBA_fnc_taskAttack;
							};
							case "Defend": 
							{
								[_grp, (_waypoints select _idx), _searchArea] call CBA_fnc_taskDefend;
							};
							case "Garrison": 
							{
								[_grp, (_waypoints select _idx)] execVM "\x\cba\addons\ai\fnc_waypointGarrison.sqf";
							};
							case "Patrol": 
							{
								[_grp, (_waypoints select _idx), _searchArea, 10, "MOVE", _behaviour, _combatMode, _speedMode, _formation, "", [0.3, 0.6, 0.9]] call CBA_fnc_taskPatrol;
							};
							case "Search": 
							{
								[_grp, _searchArea] call CBA_fnc_taskSearchArea;
							};
							case "Delete": 
							{
								[_grp, _idx + 1] setWaypointStatements ["true", "[(group this)] call LT_fnc_deleteUnits;"];
							};
						};
					};
				};
			};
		}forEach _spawnAmount;

		_waveSleep = random _waveDelay;
		sleep _waveSleep;
	};
};

true;
