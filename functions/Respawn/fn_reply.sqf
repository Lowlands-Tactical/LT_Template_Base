params ["_unit", "_kind", "_payload"];
if (!hasInterface || {_unit != player} || {!(_unit getVariable ["LTR_localWaiting", false])}) exitWith {};
if (!isNil "remoteExecutedOwner" && {remoteExecutedOwner != 2}) exitWith {};
switch (_kind) do {
	case "held": {moveOut _unit; _unit setPosATL LTR_holdingPosition};
	case "list": {
		LTR_lastList = diag_tickTime;
		if (LTR_rows isNotEqualTo _payload) then {
			LTR_rows = _payload;
			LTR_listVersion = LTR_listVersion + 1;
		};
	};
	case "retry": {
		// Native respawn modules may have placed us in a vehicle before validation failed.
		moveOut _unit;
		_unit setPosATL LTR_holdingPosition;
		LTR_requestPending = false;
		LTR_message = _payload;
	};
	case "place": {
		_payload params ["_position", "_token"];
		_unit setPosATL _position;
		[_unit, "ack", _token] remoteExecCall ["LTRespawn_fnc_request", 2];
	};
	case "base": {
		_payload params ["_source", "_token"];
		[_unit, _source, false] call BIS_fnc_moveToRespawnPosition;
		[_unit, "ack", _token] remoteExecCall ["LTRespawn_fnc_request", 2];
	};
	case "para": {
		_payload params ["_chute", "_token"];
		// An open canopy avoids replacing the backpack or touching ACRE radio inventories.
		moveOut _unit;
		_unit moveInDriver _chute;
		[_unit, "ack", _token] remoteExecCall ["LTRespawn_fnc_request", 2];
	};
	case "done": {
		private _chute = _payload param [0, objNull];
		_unit setVariable ["LTR_localWaiting", false];
		_unit hideObject false;
		_unit enableSimulation true;
		_unit allowDamage ((_unit getVariable ["LTR_restoreDamage", true]) && {!(missionNamespace getVariable ["LT_safetyActive", false])});
		if (!isNull _chute) then {
			_chute allowDamage true;
		};
		cutText ["", "BLACK IN", 0.5];
	};
};
