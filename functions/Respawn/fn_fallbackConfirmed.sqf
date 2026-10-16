// Native placement supports marker areas and vehicle seats as well as precise ATL positions.
params ["_unit", "_source"];
if (_source isEqualType objNull) exitWith {
	!isNull _source && {alive _source} && {
		vehicle _unit == _source || {(getPosATL _unit) vectorDistance getPosATL _source <= 50}
	}
};
if (_source isEqualType "") exitWith {
	if (getMarkerColor _source == "") exitWith {false};
	private _size = markerSize _source;
	_unit distance2D getMarkerPos _source <= ((_size select 0) max (_size select 1)) + 50
};
if (_source isEqualType [] && {count _source >= 2}) exitWith {
	private _position = +_source;
	if (count _position == 2) then {_position pushBack 0};
	[_unit, _position] call LTRespawn_fnc_positionConfirmed
};
false
