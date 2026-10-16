params ["_unit", "_centre", ["_minimum", 5], ["_airborne", false]];
private _position = [];
private _enemies = allUnits + allUnitsUAV + (agents apply {agent _x});
private _players = allPlayers;
for "_attempt" from 1 to 12 do {
	private _candidate = [_centre, _minimum, 15, 1.5, 0, 0.35, 0, [], [[], []]] call BIS_fnc_findSafePos;
	if (count _candidate >= 2 && {_candidate distance2D _centre <= 15} && {_candidate distance2D _centre >= _minimum}) then {
		_candidate = _candidate findEmptyPosition [0, 2, typeOf _unit];
		if (count _candidate == 3 && {_candidate distance2D _centre <= 15} && {_candidate distance2D _centre >= _minimum} && {!surfaceIsWater _candidate}
			&& {!([_candidate, side group _unit, LTR_enemyRadius, _enemies] call LTRespawn_fnc_enemyNear)}
			&& {!_airborne || {[_unit, _candidate] call LTRespawn_fnc_airClear}}
			&& {[_candidate, _unit, _players] call LTRespawn_fnc_positionFree}) then {
			_position = _candidate;
		};
	};
	// Exit the loop's scope, rather than the nested candidate block.
	if (_position isNotEqualTo []) exitWith {};
	if (canSuspend) then {sleep 0.001};
};
_position
