params ["_unit", ["_corpse", objNull]];
if (!(missionNamespace getVariable ["LTR_addonOwned", false]) || {!LTR_selected}) exitWith {};
// The engine also calls respawn templates on initial entry. LT's other startup callbacks still run.
if (isNull _corpse && {!didJIP}) exitWith {};
if (!LTR_enabled) exitWith {
	if (hasInterface && {!LTR_permaDeath} && {local _unit} && {_unit == player}) then {
		_this call BIS_fnc_respawnMenuPosition;
	};
};
if (!LTR_enabled || {!hasInterface} || {!local _unit} || {_unit != player} || {!(_unit isKindOf "CAManBase")} || {_unit == missionNamespace getVariable ["LTR_waitingUnit", objNull]}) exitWith {};
if (!isNull _corpse && {isNil {_unit getVariable "LT_unit_role"}}) then {
	_unit setVariable ["LT_unit_role", _corpse getVariable ["LT_unit_role", ""], true];
};
LTR_waitingUnit = _unit;
_unit setVariable ["LTR_localWaiting", true];
_unit setVariable ["LTR_active", false, true];
_unit setVariable ["LTR_restoreDamage", if (missionNamespace getVariable ["LT_safetyActive", false]) then {true} else {isDamageAllowed _unit}];
_unit allowDamage false;
_unit enableSimulation false;
_unit hideObject true;
// The server registers holding before telling this client to move outside the playable area.
cutText ["", "BLACK FADED", 0];
LTR_requestPending = false;
LTR_rows = [];
LTR_listVersion = 0;
[_unit, "hold"] remoteExecCall ["LTRespawn_fnc_request", 2];
[_unit] spawn LTRespawn_fnc_menu;
