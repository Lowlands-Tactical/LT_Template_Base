/*

File: fn_CustomCompSpawner.sqf
Author: Brainless_Ben

Description:
Function for CustomCompSpawner module, processes module data to spawn custom units/vehicles/apcs/tanks.

Return value:
True (if all waves succesfully spawned)

*/

_logic = param [0,objNull,[objNull]];
_units = param [1,[],[[]]];
_activated = param [2,true,[true]];

if (_activated) then 
{
	if !(isServer) exitWith {};
	_side = switch (_logic getVariable ["CustomCompSpawner_Side", "WEST"]) do
	{
		case "WEST":{west};
		case "EAST":{east};
		case "GUER":{resistance};
		case "CIV":{civilian};
	};
	_InfArr = _logic getVariable ["CustomCompSpawner_InfClasses", ['B_Soldier_F']];
	_VehArr = _logic getVariable ["CustomCompSpawner_VehClasses", ['B_MRAP_01_F']];
	_MechArr = _logic getVariable ["CustomCompSpawner_MechClasses", ['B_APC_Wheeled_01_cannon_v2_F']];
	_ArmorArr = _logic getVariable ["CustomCompSpawner_ArmorClasses", ['B_MBT_01_cannon_F']];

	// Waypoint settings
	_searchArea = _logic getVariable ["CustomCompSpawner_SearchArea", 50];
	_waypoints = _logic getVariable ["CustomCompSpawner_Waypoints", []];
	_lastWaypoint = _logic getVariable ["CustomCompSpawner_LastWaypoint", "Patrol"];

	// Wave settings
	_waves = _logic getVariable ["CustomCompSpawner_Waves", 3];
	_unitCap = _logic getVariable ["CustomCompSpawner_UnitCap", 200];
	_waveDelay = _logic getVariable ["CustomCompSpawner_WaveDelay", [30,60,90]];

	// Amount settings
	_infAmt = parseSimpleArray ((str(_logic getVariable ["CustomCompSpawner_InfantryAmount", ["1"]])) splitString """" joinString "");
	_vehAmt = parseSimpleArray ((str(_logic getVariable ["CustomCompSpawner_VehicleAmount", ["0"]])) splitString """" joinString "");
	_mechAmt = parseSimpleArray ((str(_logic getVariable ["CustomCompSpawner_MechanizedAmount", ["0"]])) splitString """" joinString "");
	_armorAmt = parseSimpleArray ((str(_logic getVariable ["CustomCompSpawner_ArmorAmount", ["0"]])) splitString """" joinString "");

	// Group settings
	_infSize = _logic getVariable ["CustomCompSpawner_InfantryGroupSize", 8];
	_combatMode = _logic getVariable ["CustomCompSpawner_CombatMode", "YELLOW"];
	_behaviour = _logic getVariable ["CustomCompSpawner_Behaviour", "AWARE"];
	_formation = _logic getVariable ["CustomCompSpawner_Formation", "WEDGE"];
	_speedMode = _logic getVariable ["CustomCompSpawner_SpeedMode", "NORMAL"];

	_allFactions = [] call BIS_fnc_getFactions;

	Diag_Log format["[LT] (CustomCompSpawner) CustomCompSpawner Module:%1 Waypoints:%2  Lastwaypoint task:%3", _logic, _waypoints, _lastWaypoint];
	Diag_Log format["[LT] (CustomCompSpawner) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
	Diag_Log format["[LT] (CustomCompSpawner) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
	Diag_Log format["[LT] (CustomCompSpawner) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (CustomCompSpawner) CustomCompSpawner Module:%1 Waypoints:%2  Lastwaypoint task:%3", _logic, _waypoints, _lastWaypoint];
		systemChat format["[LT] (CustomCompSpawner) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
		systemChat format["[LT] (CustomCompSpawner) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
		systemChat format["[LT] (CustomCompSpawner) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	};

	// preChecks to ensure everything runs smoothly
	if (_infSize <= 1) exitWith 
	{
		Diag_Log "[LT] (CustomCompSpawner) Infantry amount is to low";
		systemChat "[LT] (CustomCompSpawner) Infantry amount is to low";
	};

	// Waypoint postions
	_waypointsLoc = [];
	{
		_position = getMarkerPos _x;
		_waypointsLoc pushBack _position;
	}forEach _waypoints;

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
		if (_waves != -1 && (count _x) != _waves) then
		{
			_x resize [_waves,(_x select 0)];
		};
	}forEach _totalAmt;
	_waveAmt = if (_waves != -1) then {_waves} else {_maxAmt;};

	Diag_Log format["[LT] (CustomCompSpawner) InfantryClassArray:%1",_InfArr];
	Diag_Log format["[LT] (CustomCompSpawner) VehicleClassArray:%1",_VehArr];
	Diag_Log format["[LT] (CustomCompSpawner) MechanizedClassArray:%1",_MechArr];
	Diag_Log format["[LT] (CustomCompSpawner) ArmorClassArray:%1",_ArmorArr];
	Diag_Log format["[LT] (CustomCompSpawner) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
	Diag_Log format["[LT] (CustomCompSpawner) TotalAmount:%1", _totalAmt];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (CustomCompSpawner) InfantryClassArray:%1",_InfArr];
		systemChat format["[LT] (CustomCompSpawner) VehicleClassArray:%1",_VehArr];
		systemChat format["[LT] (CustomCompSpawner) MechanizedClassArray:%1",_MechArr];
		systemChat format["[LT] (CustomCompSpawner) ArmorClassArray:%1",_ArmorArr];
		systemChat format["[LT] (CustomCompSpawner) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
		systemChat format["[LT] (CustomCompSpawner) TotalAmount:%1", _totalAmt];
	};

	// Initialise waves
	for "_i" from 1 to _waveAmt do 
	{
		// Set variable and log wave number
		_logic setVariable ["LT_CustomCompSpawnerWave", [_i, _logic], true];

		Diag_Log format["[LT] (CustomCompSpawnerWave) Wave:%1/%2", _i, _waveAmt];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (CustomCompSpawnerWave) Wave:%1/%2", _i, _waveAmt];
		};
		hintSilent format["CustomCompSpawner Wave %1/%2 started", _i, _waveAmt];

		// Array of spawn amounts
		_indexNumber = _i - 1;
		_spawnAmount = [
			[_totalAmt select 0 select _indexNumber, "Infantry", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 1 select _indexNumber, "Vehicles", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 2 select _indexNumber, "Mechanized", _waypointsLoc, [_infSize, _lastWaypoint]],
			[_totalAmt select 3 select _indexNumber, "Armored", _waypointsLoc, [_infSize, _lastWaypoint]]
		];

		Diag_Log format["[LT] (CustomCompSpawnerWave) SpawnAmount:%1", _spawnAmount];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (CustomCompSpawnerWave) SpawnAmount:%1", _spawnAmount];
		};

		{
			_groupAmt = _x select 0;
			_unitType = _x select 1;
			_waypoints = _x select 2;
			_infSize = _x select 3 select 0;
			_lastWaypoint = _x select 3 select 1;

			for "_n" from 1 to _groupAmt do 
			{
				_infSize = _infSize -1;
				_spawnDir = random[(getDir _logic) - 10, getDir _logic, (getDir _logic) + 10];
				_spawnArea = _logic getPos [5, _spawnDir];
				_spawnPos = _spawnArea findEmptyPosition [0, 40];

				_grp = (createGroup _side);
				switch (_unitType) do 
				{
					case "Infantry": 
					{
						for "_u" from 0 to _infSize do 
						{
							_unitClass = _InfArr call BIS_fnc_selectRandom;
							_unit = _grp createUnit [_unitClass, _spawnPos,[],3,"NONE"];
							[_unit] joinSilent _grp;
							sleep 0.3;
						};
					};
					case "Vehicles": 
					{
						_vehCar = _VehArr call BIS_fnc_selectRandom;
						private _vehicleCar = [_spawnPos, _spawnDir, _vehCar, _grp] call BIS_fnc_spawnVehicle;
						private _hasCargo = fullCrew[(_vehicleCar select 0),"cargo",true];
						{
							if (isNull (_x select 0)) then 
							{
								_unitClass = _InfArr call BIS_fnc_selectRandom;
								_unit = _grp createUnit [_unitClass,_spawnPos,[],3,"CARGO"];
								[_unit] joinSilent _grp;
							};
						}forEach _hasCargo;
					};
					case "Mechanized": 
					{
						_vehMech = _MechArr call BIS_fnc_selectRandom;
						private _vehicleMech = [_spawnPos, _spawnDir, _vehMech, _grp] call BIS_fnc_spawnVehicle;
						private _hasCargo = fullCrew[(_vehicleMech select 0),"cargo",true];
						{
							if (isNull (_x select 0)) then 
							{
								_unitClass = _InfArr call BIS_fnc_selectRandom;
								_unit = _grp createUnit [_unitClass,_spawnPos,[],3,"CARGO"];
								[_unit] joinSilent _grp;
							};
						}forEach _hasCargo;
					};
					case "Armored": 
					{
						_vehArmor = _ArmorArr call BIS_fnc_selectRandom;
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
