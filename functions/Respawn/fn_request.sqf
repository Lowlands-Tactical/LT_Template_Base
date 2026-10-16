// Server endpoint. Accept only requests from the machine that owns the supplied player.
params [["_unit", objNull, [objNull]], ["_action", "", [""]], ["_selection", "", ["", 0]]];
if (!isServer || {!LTR_enabled} || {isNull _unit} || {!isPlayer _unit} || {!alive _unit} || {!(_unit isKindOf "CAManBase")}) exitWith {};
if (!isNil "remoteExecutedOwner" && {remoteExecutedOwner != owner _unit}) exitWith {};
private _reply = {
	params ["_kind", "_payload"];
	[_unit, _kind, _payload] remoteExecCall ["LTRespawn_fnc_reply", owner _unit];
};
if (_action == "register") exitWith {
	// Registration is allowed once; a waiting player cannot bypass the selector with it.
	if (isNil {_unit getVariable "LTR_waiting"}) then {
		_unit setVariable ["LTR_waiting", false];
		_unit setVariable ["LTR_registered", true];
		_unit setVariable ["LTR_active", true, true];
	};
};
if (_action == "hold") exitWith {
	if (_unit getVariable ["LTR_registered", false] && {!(_unit getVariable ["LTR_waiting", false])}) exitWith {};
	[_unit] call LTRespawn_fnc_clearPlacement;
	_unit setVariable ["LTR_waiting", true];
	_unit setVariable ["LTR_registered", true];
	_unit setVariable ["LTR_active", false, true];
	_unit hideObjectGlobal true;
	_unit enableSimulationGlobal false;
	["held", []] call _reply;
};
if (!(_unit getVariable ["LTR_waiting", false])) exitWith {};
if (_action == "list") exitWith {
	["list", [_unit] call LTRespawn_fnc_menuRows] call _reply;
};
if (_action == "spawn") exitWith {
	if (!(_selection isEqualType "")) exitWith {};
	// Accept one operation at a time. The endpoint is unscheduled, so token assignment is atomic.
	private _pending = _unit getVariable ["LTR_placement", []];
	if (_pending isNotEqualTo [] && {serverTime <= (_pending select 3)}) exitWith {};
	// An expired drop may still own a frozen canopy when a new request arrives.
	[_unit] call LTRespawn_fnc_clearPlacement;
	LTR_token = LTR_token + 1;
	private _token = LTR_token;
	private _owner = owner _unit;
	_unit setVariable ["LTR_placement", [_token, _selection, [], serverTime + 15, _owner, false]];
	[_unit, _selection, _token, _owner] spawn {
		params ["_unit", "_selection", "_token", "_owner"];
		if (!([_unit, _token, _owner] call LTRespawn_fnc_placementCurrent)) exitWith {};
		private _reason = "";
		private _centre = [];
		private _source = objNull;
		private _isBase = _selection find "base:" == 0;
		private _isPara = !_isBase && {LTR_parachute};
		if (!_isBase) then {
			private _target = objectFromNetId _selection;
			_reason = [_unit, _target] call LTRespawn_fnc_targetReason;
			if (_reason == "") then {_centre = getPosATL _target};
		} else {
			private _fallbacks = [_unit] call LTRespawn_fnc_fallbacks;
			private _index = _fallbacks findIf {(_x select 0) == _selection};
			if (_index < 0) then {_reason = "Respawnlocatie is niet meer beschikbaar."} else {_source = (_fallbacks select _index) select 2};
		};
		private _position = [];
		if (_reason == "" && {!_isBase}) then {
			_position = [_unit, _centre, 5, _isPara] call LTRespawn_fnc_findPosition;
			if (_position isEqualTo []) then {_reason = "Geen veilige plek gevonden. Kies een andere speler of probeer opnieuw."};
		};
		private _reserved = false;
		// Another search may have reserved our candidate while this scheduled script was paused.
		isNil {
			if ([_unit, _token, _owner] call LTRespawn_fnc_placementCurrent) then {
				if (_reason == "" && {!_isBase} && {!([_position, _unit] call LTRespawn_fnc_positionFree)}) then {_reason = "Plek is bezet. Probeer opnieuw."};
				if (_reason != "") then {
					[_unit] call LTRespawn_fnc_clearPlacement;
					[_unit, "retry", _reason] remoteExecCall ["LTRespawn_fnc_reply", _owner];
				} else {
					if (_isPara) then {
						_source = createVehicle ["Steerable_Parachute_F", _position vectorAdd [0,0,100], [], 0, "CAN_COLLIDE"];
						_source setVariable ["LTR_drop", true, true];
						_source enableSimulationGlobal false;
						_source hideObjectGlobal true;
						_source allowDamage false;
						_source setPosATL (_position vectorAdd [0,0,100]);
						_source setDir getDir _unit;
					};
					private _placement = [_token, _selection, _position, serverTime + 15, _owner, false];
					if (_isBase || {_isPara}) then {_placement pushBack _source};
					_unit setVariable ["LTR_placement", _placement];
					private _kind = if (_isBase) then {"base"} else {if (_isPara) then {"para"} else {"place"}};
					[_unit, _kind, [[_position, _source] select (_isBase || {_isPara}), _token]] remoteExecCall ["LTRespawn_fnc_reply", _owner];
					_reserved = true;
				};
			};
		};
		if (!_reserved) exitWith {};
		sleep 15;
		isNil {
			if ([_unit, _token, _owner] call LTRespawn_fnc_placementCurrent) then {
				[_unit] call LTRespawn_fnc_clearPlacement;
				[_unit, "retry", "Plaatsing verlopen. Probeer opnieuw."] remoteExecCall ["LTRespawn_fnc_reply", _owner];
			};
		};
	};
};
if (_action == "ack") exitWith {
	private _placement = _unit getVariable ["LTR_placement", []];
	if (count _placement < 6 || {_selection isNotEqualTo (_placement select 0)} || {(_placement select 1) find "base:" != 0 && {count (_placement select 2) != 3}} || {_placement select 5}) exitWith {};
	_placement set [5, true]; // duplicate acknowledgments cannot start another release worker
	_unit setVariable ["LTR_placement", _placement];
	// Position replication can arrive after the RPC. Wait briefly before deciding it failed.
	[_unit, +_placement] spawn {
		params ["_unit", "_placement"];
		_placement params ["_token", "_targetId", "_position", "_deadline", "_owner"];
		private _isBase = _targetId find "base:" == 0;
		private _source = _placement param [6, objNull];
		private _isPara = !_isBase && {count _placement > 6};
		private _confirmed = {
			if (_isBase) then {[_unit, _source] call LTRespawn_fnc_fallbackConfirmed} else {
				if (_isPara) then {[_unit, _position, _source] call LTRespawn_fnc_dropConfirmed} else {[_unit, _position] call LTRespawn_fnc_positionConfirmed}
			}
		};
		private _replicationDeadline = diag_tickTime + 2;
		waitUntil {sleep 0.05; !([_unit, _token, _owner] call LTRespawn_fnc_placementCurrent) || {call _confirmed} || {diag_tickTime >= _replicationDeadline}};
		// Keep validation and release together: no scheduled pause can make the checks stale.
		isNil {
			if (!([_unit, _token, _owner] call LTRespawn_fnc_placementCurrent)) exitWith {};
			// Fresh membership for this commit; reuse it for the target and the ground position.
			private _enemies = allUnits + allUnitsUAV + (agents apply {agent _x});
			private _reason = "";
			if (!_isBase) then {
				private _target = objectFromNetId _targetId;
				_reason = [_unit, _target, _enemies] call LTRespawn_fnc_targetReason;
				if (_reason == "" && {_target distance2D _position > 20}) then {_reason = "Teamgenoot is verplaatst. Probeer opnieuw."};
			} else {
				// Re-query native availability: a removed, disabled or captured module cannot release a player.
				if (([_unit] call LTRespawn_fnc_fallbacks) findIf {(_x select 0) == _targetId} < 0) then {_reason = "Respawnlocatie is niet meer beschikbaar."};
			};
			if (_reason == "" && {serverTime > _deadline || {!(call _confirmed)}}) then {_reason = "Plaatsing niet bevestigd. Probeer opnieuw."};
			if (_reason == "" && {!_isBase} && {[_position, side group _unit, LTR_enemyRadius, _enemies] call LTRespawn_fnc_enemyNear}) then {_reason = format ["Vijand binnen %1 m. Kies een andere plek.", LTR_enemyRadius]};
			if (_reason == "" && {!_isBase} && {!([_position, _unit] call LTRespawn_fnc_positionFree)}) then {_reason = "Plek is bezet. Probeer opnieuw."};
			if (_reason == "" && {_isPara} && {!([_unit, _position] call LTRespawn_fnc_airClear)}) then {_reason = "Landingsplek is geblokkeerd. Kies een andere plek."};
			if (_reason != "") exitWith {
				[_unit] call LTRespawn_fnc_clearPlacement;
				[_unit, "retry", _reason] remoteExecCall ["LTRespawn_fnc_reply", _owner];
			};
			_unit setVariable ["LTR_placement", nil];
			if (_isPara) then {
				_source allowDamage true;
				_source hideObjectGlobal false;
				_source enableSimulationGlobal true;
				// Server owns cleanup even when the arriving client disconnects.
				[_source] spawn {
					params ["_chute"];
					waitUntil {sleep 1; isNull _chute || {crew _chute isEqualTo []}};
					if (!isNull _chute) then {deleteVehicle _chute};
				};
			};
			_unit setVariable ["LTR_waiting", false];
			_unit hideObjectGlobal false;
			_unit enableSimulationGlobal true;
			_unit setVariable ["LTR_active", true, true];
			[_unit, "done", [[], [_source]] select _isPara] remoteExecCall ["LTRespawn_fnc_reply", _owner];
		};
	};
};
