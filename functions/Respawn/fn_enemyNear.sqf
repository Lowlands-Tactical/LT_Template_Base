// Public: [position, friendlySide, optionalRadius] call LTRespawn_fnc_enemyNear.
// Run on the server for an authoritative answer; visibility/knowledge does not affect this check.
// Internal callers may reuse membership within one request; positions and state remain live.
params ["_position", "_side", ["_radius", LTR_enemyRadius], ["_enemies", objNull]];
if (_enemies isEqualType objNull) then {_enemies = allUnits + allUnitsUAV + (agents apply {agent _x})};
_enemies findIf {
	alive _x && {!captive _x} && {
		private _enemySide = if (_x isKindOf "CAManBase") then {side group _x} else {side _x};
		(_side getFriend _enemySide < 0.6 || {_enemySide getFriend _side < 0.6})
	} && {vehicle _x distance2D _position <= _radius}
} > -1
