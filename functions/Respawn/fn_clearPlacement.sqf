// Cancel only LTR-created drop canopies. Never delete a native fallback vehicle.
params ["_unit"];
if (!isServer || {isNull _unit}) exitWith {};
private _placement = _unit getVariable ["LTR_placement", []];
if (count _placement > 6 && {(_placement select 1) find "base:" != 0}) then {
	private _chute = _placement select 6;
	if (_chute isEqualType objNull && {!isNull _chute} && {_chute isKindOf "ParachuteBase"}) then {deleteVehicle _chute};
};
_unit setVariable ["LTR_placement", nil];
