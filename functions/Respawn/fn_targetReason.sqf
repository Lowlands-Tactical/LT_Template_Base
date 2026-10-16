// An empty reason means this teammate is eligible. Rechecked at selection and placement.
params ["_unit", "_target", ["_enemies", objNull]];
if (isNull _target || {!isPlayer _target} || {_target == _unit} || {!(_target isKindOf "CAManBase")}) exitWith {"Geen geldige teamgenoot"};
if (!([_target] call LTRespawn_fnc_isActive)) exitWith {"Niet actief"};
if (lifeState _target == "INCAPACITATED" || {_target getVariable ["ACE_isUnconscious", false]}) exitWith {"Bewusteloos"};
private _side = side group _unit;
private _targetSide = side group _target;
if (_side != _targetSide) exitWith {"Andere zijde"};
if (!([_unit, _target] call LTRespawn_fnc_canTarget)) exitWith {"Geen toegestane PC/GC/VTL"};
if (!isNull objectParent _target) exitWith {"In een voertuig"};
if ([getPosATL _target, _side, LTR_enemyRadius, _enemies] call LTRespawn_fnc_enemyNear) exitWith {format ["Vijand binnen %1 m", LTR_enemyRadius]};
""
