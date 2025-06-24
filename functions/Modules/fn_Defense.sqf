/*

File: fn_Intel.sqf
Author: Brainless_Ben

Description:
Function for defense module, processes module data to spawn units/vehicles/apcs/tanks.

Return value:
True (if all waves succesfully spawned)

*/

_logic = param [0,objNull,[objNull]];
_units = param [1,[],[[]]];
_activated = param [2,true,[true]];

if (_activated) then 
{
	if !(isServer) exitWith {};
	// Spawn settings
	_mrkDefPos = _logic getVariable ["Defense_Marker", ""];
	_faction = _logic getVariable ["Defense_Faction", "OPF_F"];
	_blackList = _logic getVariable ["Defense_BlackList", []];
	_direction = parseNumber (_logic getVariable ["Defense_Direction", "0"]);
	_searchAreaSize = _logic getVariable ["Defense_SearchAreaSize", 100];
	_minSpawnDis = _logic getVariable ["Defense_MinSpawnDistance", 500];
	_maxSpawnDis = _logic getVariable ["Defense_MaxSpawnDistance", 1500];

	// Custom spawn locations
	_infSpawnArr = (_logic getVariable ["Defense_MarkerInfantrySpawn", ""]) splitString " ,'";
	_vehSpawnArr = (_logic getVariable ["Defense_MarkerVehicleSpawn", ""]) splitString " ,'";
	_mechSpawnArr = (_logic getVariable ["Defense_MarkerMechSpawn", ""]) splitString " ,'";
	_armorSpawnArr = (_logic getVariable ["Defense_MarkerArmorSpawn", ""]) splitString " ,'";

	// Wave settings
	_waves = _logic getVariable ["Defense_Waves", 3];
	_unitCap = _logic getVariable ["Defense_UnitCap", 200];
	_waveDelay = _logic getVariable ["Defense_WaveDelay", [30,60,90]];

	// Amount settings
	_infAmt = parseSimpleArray ((str(_logic getVariable ["Defense_InfantryAmount", ["1"]])) splitString """" joinString "");
	_vehAmt = parseSimpleArray ((str(_logic getVariable ["Defense_VehicleAmount", ["0"]])) splitString """" joinString "");
	_mechAmt = parseSimpleArray ((str(_logic getVariable ["Defense_MechanizedAmount", ["0"]])) splitString """" joinString "");
	_armorAmt = parseSimpleArray ((str(_logic getVariable ["Defense_ArmorAmount", ["0"]])) splitString """" joinString "");

	// Group settings
	_infSize = _logic getVariable ["Defense_InfantryGroupSize", 8];
	_combatMode = _logic getVariable ["Defense_CombatMode", "YELLOW"];
	_behaviour = _logic getVariable ["Defense_Behaviour", "AWARE"];
	_formation = _logic getVariable ["Defense_Formation", "WEDGE"];
	_speedMode = _logic getVariable ["Defense_SpeedMode", "NORMAL"];

	_allFactions = [] call BIS_fnc_getFactions;

	Diag_Log format["[LT] (Defense) Defense Module:%1  Defense Marker:%2  Faction:%3  BlackList:%4", _logic, _mrkDefPos, _faction, _blackList];
	Diag_Log format["[LT] (Defense) AllFactions: %1", _allFactions];
	Diag_Log format["[LT] (Defense) Direction:%1  SearchArea:%2  Minimum Distance:%3  Maximum Distance:%4",_direction, _searchAreaSize, _minSpawnDis, _maxSpawnDis];
	Diag_Log format["[LT] (Defense) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
	Diag_Log format["[LT] (Defense) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
	Diag_Log format["[LT] (Defense) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (Defense) Defense Module:%1  Defense Marker:%2  Faction:%3  BlackList:%4", _logic, _mrkDefPos, _faction, _blackList];
		systemChat format["[LT] (Defense) Direction:%1  SearchArea:%2  Minimum Distance:%3  Maximum Distance:%4",_direction, _searchAreaSize, _minSpawnDis, _maxSpawnDis];
		systemChat format["[LT] (Defense) Inf Amount:%1  Veh Amount:%2  Mech Amount:%3  Armor Amount:%4", _infAmt, _vehAmt, _mechAmt, _armorAmt];
		systemChat format["[LT] (Defense) Inf Size:%1  Wave Amount:%2  Unit Cap:%3  Wave Delay:%4", _infSize, _waves, _unitCap, _waveDelay];
		systemChat format["[LT] (Defense) CombatMode:%1  Behaviour:%2  Formation:%3  SpeedMode:%4", _combatMode, _behaviour, _formation, _speedMode];
	};

	// preChecks to ensure everything runs smoothly
	if (_faction == "" OR !(_faction in _allFactions)) exitWith 
	{
		Diag_Log "[LT] (Defense) There is no faction selected or there is a typo";
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Defense) There is no faction selected or there is a typo";
		};
	};
	if ((_maxSpawnDis - _minSpawnDis) <= 0) exitWith 
	{
		Diag_Log "[LT] (Defense) Min distance is smaller that Max distance";
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Defense) Min distance is smaller that Max distance";
		};
	};
	if (_infSize <= 1) exitWith 
	{
		Diag_Log "[LT] (Defense) Wave/Infantry amount is to low";
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Defense) Wave/Infantry amount is to low";
		};
	};

	// Define Markers and positions
	_defensePos = if (_mrkDefPos == "") then {getPos _logic} else {getMarkerPos _mrkDefPos};
	_searchArea = "";
	if (_mrkDefPos == "" OR markerShape _mrkDefPos == "ICON") then 
	{
		_searchArea = createMarker ["Search Area", _defensePos];
		_searchArea setMarkerShape "ELLIPSE";
		_searchArea setMarkerSize [_searchAreaSize, _searchAreaSize];
		_searchArea setMarkerAlpha 0;
	} else 
	{
		_searchArea = _mrkDefPos;
		_shape = markerShape _mrkDefPos;
		_size = getMarkerSize _mrkDefPos;
		_searchArea setMarkerShape _shape;
		_searchArea setMarkerSize [(_size select 0), (_size select 1)];
	};
	
	Diag_Log format["[LT] (Defense) Defense position:%1",_defensePos];
	Diag_Log format["[LT] (Defense) InfantryMarkerArray:%1  VehicleMarkerArray:%2  MechanizedMarkerArray:%3  ArmorMarkerArray:%4",_infSpawnArr, _vehSpawnArr, _mechSpawnArr, _armorSpawnArr];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (Defense) Defense position:%1",_defensePos];
		systemChat format["[LT] (Defense) InfantryMarkerArray:%1  VehicleMarkerArray:%2  MechanizedMarker:%3  ArmorMarkerArray:%4",_infSpawnArr, _vehSpawnArr, _mechSpawnArr, _armorSpawnArr];
	};

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
			_displayName = getText (configFile >> "CfgVehicles" >> _className >> "displayName");
			_vehicleClass = getText (configFile >> "CfgVehicles" >> _className >> "vehicleClass");
			_textSingular = getText (configFile >> "CfgVehicles" >> _className >> "textSingular");
			if (_textSingular == "Infantry" AND !(["Uniform", _displayName] call BIS_fnc_inString)) then 
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
		if (_waves != -1 && (count _x) != _waves) then
		{
			_x resize [_waves,(_x select 0)];
		};
	}forEach _totalAmt;
	_waveAmt = if (_waves != -1) then {_waves} else {_maxAmt;};

	Diag_Log format["[LT] (Defense) Faction:%1 FactionSide:%2 BlackList:%3",_faction, _factionSide, _blackList];
	Diag_Log format["[LT] (Defense) InfantryClassArray:'%1' VehicleClassArray:'%2' MechanizedClassArray:'%3' ArmorClassArray:'%4'",_factionInfArr, _factionVehArr, _factionMechArr, _factionArmorArr];
	Diag_Log format["[LT] (Defense) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
	Diag_Log format["[LT] (Defense) TotalAmount:%1", _totalAmt];
	if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (Defense) Faction:%1 FactionSide:%2 BlackList:%3",_faction, _factionSide, _blackList];
		systemChat format["[LT] (Defense) InfantryClassArray:'%1' VehicleClassArray:'%2' MechanizedClassArray:'%3' ArmorClassArray:'%4'",_factionInfArr, _factionVehArr, _factionMechArr, _factionArmorArr];
		systemChat format["[LT] (Defense) Max amount:%1  Wave amount:%2", _maxAmt, _waveAmt];
		systemChat format["[LT] (Defense) TotalAmount:%1", _totalAmt];
	};

	// Initialise waves
	for "_i" from 1 to _waveAmt do 
	{
		// Set variable and log wave number
		_logic setVariable ["LT_DefenseWave", _i, true];

		Diag_Log format["[LT] (DefenseWave) Wave:%1/%2", _i, _waveAmt];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (DefenseWave) Wave:%1/%2", _i, _waveAmt];
		};
		hintSilent format["Defense Wave %1/%2 started", _i, _waveAmt];

		// Array of spawn amounts
		_indexNumber = _i - 1;
		_spawnAmount = [
			[_totalAmt select 0 select _indexNumber, "Infantry", _infSpawnArr,[_infSize, _direction]],
			[_totalAmt select 1 select _indexNumber, "Vehicles", _vehSpawnArr,[_infSize, _direction]],
			[_totalAmt select 2 select _indexNumber, "Mechanized", _mechSpawnArr,[_infSize, _direction]],
			[_totalAmt select 3 select _indexNumber, "Armored", _armorSpawnArr,[_infSize, _direction]]
		];

		Diag_Log format["[LT] (DefenseWave) SpawnAmount:%1", _spawnAmount];
		if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (DefenseWave) SpawnAmount:%1", _spawnAmount];
		};

		{
			// Wait untill allUnits is below UnitCap
			if (_unitCap < (count allUnits)) then 
			{
				waitUntil {sleep 5;(_unitCap > (count allUnits));};
			};
			
			_groupAmt = _x select 0;
			_unitType = _x select 1;
			_customPosArr = _x select 2;
			_infSize = _x select 3 select 0;
			_direction = _x select 3 select 1;
			
			for "_n" from 1 to _groupAmt do 
			{
				_infSize = _infSize - 1;
				_midSpawnDis = ((_maxSpawnDis + _minSpawnDis) / 2);
				_spawnDis = random[_minSpawnDis, _midSpawnDis, _maxSpawnDis];
				_spawnDir = random[(getDir _logic) - 10, getDir _logic, (getDir _logic) + 10];

				_grp = createGroup _factionSide;
				private _spawnArea = switch (_direction) do 
				{
					case 0: {_defensePos getPos [_spawnDis, _spawnDir] };
					case 1: {_defensePos getPos [_spawnDis, random 360];};
					case 2: {_customPosArr call BIS_fnc_selectRandom;};
				};

				_spawnPos = _spawnArea findEmptyPosition [0, 40];
				switch (_unitType) do 
				{
					case "Infantry": 
					{
						for "_u" from 0 to _infSize do 
						{
							_unitClass = _factionInfArr call BIS_fnc_selectRandom;
							_unit = _grp createUnit [_unitClass, _spawnPos,[],3,"NONE"];
							sleep 0.3;
						};
					};
					case "Vehicles": 
					{
						_vehCar = selectRandom _factionVehArr;
						private _vehicleCar = [_spawnPos, _spawnDir, _vehCar, _grp] call BIS_fnc_spawnVehicle;
						private _hasCargo = fullCrew[(_vehicleCar select 0),"cargo",true];
						{
							if (isNull (_x select 0)) then 
							{
								_unitClass = _factionInfArr call BIS_fnc_selectRandom;
								_grp createUnit [_unitClass,_spawnPos,[],3,"CARGO"];
							};
						}forEach _hasCargo;
					};
					case "Mechanized": 
					{
						_vehMech = _factionMechArr call BIS_fnc_selectRandom;
						private _vehicleMech = [_spawnPos, _spawnDir, _vehMech, _grp] call BIS_fnc_spawnVehicle;
						private _hasCargo = fullCrew[(_vehicleMech select 0),"cargo",true];
						{
							if (isNull (_x select 0)) then 
							{
								_unitClass = _factionInfArr call BIS_fnc_selectRandom;
								_grp createUnit [_unitClass,_spawnPos,[],3,"CARGO"];
							};
						}forEach _hasCargo;
					};
					case "Armored": 
					{
						_vehArmor = _factionArmorArr call BIS_fnc_selectRandom;
						[_spawnPos, _spawnDir, _vehArmor, _grp] call BIS_fnc_spawnVehicle;
					};
				};
				_grp setCombatMode _combatMode;
				_grp setBehaviourStrong _behaviour;
				_grp setFormation _formation;
				_grp setSpeedMode _speedMode;

				[_grp, _searchArea, _searchAreaSize] call CBA_fnc_taskAttack;
			};
		}forEach _spawnAmount;

		_waveSleep = random _waveDelay;
		sleep _waveSleep;
	};
};

true;
