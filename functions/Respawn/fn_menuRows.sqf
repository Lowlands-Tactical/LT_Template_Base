// Server-only preview cache. Placement validation never reads this cache.
params ["_unit"];
if (!isServer) exitWith {[]};
if (LTR_menuSnapshot isEqualTo [] || {diag_tickTime - (LTR_menuSnapshot select 0) >= 1}) then {
	LTR_menuSnapshot = [diag_tickTime, allPlayers, allUnits + allUnitsUAV + (agents apply {agent _x}), createHashMap];
};
LTR_menuSnapshot params ["_stamp", "_players", "_enemies", "_reasons"];
private _side = side group _unit;
private _targets = _players select {_x isKindOf "CAManBase" && {alive _x} && {[_unit, _x] call LTRespawn_fnc_canTarget}};
_targets = (_targets select {group _x == group _unit}) + (_targets select {group _x != group _unit});
private _rows = [];
{
	// Relationship eligibility is checked above for each requester, before sharing safety results.
	private _id = netId _x;
	private _key = str _side + ":" + _id;
	private _state = _reasons getOrDefault [_key, []];
	if (_state isEqualTo []) then {
		private _reason = [_unit, _x, _enemies] call LTRespawn_fnc_targetReason;
		private _warning = "";
		if (_reason == "" && {[getPosATL _x, _side, LTR_warningRadius, _enemies] call LTRespawn_fnc_enemyNear}) then {
			_warning = format ["Waarschuwing: vijand binnen %1 m. Respawn is mogelijk.", LTR_warningRadius];
		};
		_state = [_reason, _warning];
		_reasons set [_key, _state];
	};
	_state params ["_reason", "_warning"];
	private _label = format ["[%1] %2", [_x] call LTRespawn_fnc_commandRole, name _x] + (if (group _x == group _unit) then {" (eigen groep)"} else {" — " + groupId group _x});
	if (_warning != "") then {_label = _label + " — vijand dichtbij"};
	_rows pushBack [_label, _id, _reason == "", _reason, _warning];
} forEach _targets;
{
	_x params ["_id", "_label"];
	_rows pushBack [_label, _id, true, "", ""];
} forEach ([_unit] call LTRespawn_fnc_fallbacks);
_rows
