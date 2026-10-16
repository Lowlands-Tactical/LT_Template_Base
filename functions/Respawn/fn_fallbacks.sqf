// Query native availability live. Stable IDs survive additions/removals elsewhere in the list.
params ["_unit"];
private _sources = +(_unit call BIS_fnc_getRespawnPositions);
{_sources pushBackUnique _x} forEach ([side group _unit, false] call BIS_fnc_getRespawnMarkers);
private _rows = [];
private _ids = [];
{
	private _source = _x;
	private _id = "";
	private _label = "";
	if (_source isEqualType "" && {_source != ""} && {getMarkerColor _source != ""} && {!(_source in LTR_holdingMarkers)}) then {
		_id = "base:marker:" + _source;
		_label = markerText _source;
		if (_label == "") then {_label = "Respawnpunt " + mapGridPosition getMarkerPos _source};
	};
	if (_source isEqualType [] && {count _source >= 2}) then {
		_id = "base:position:" + str _source;
		_label = "Respawnpunt " + mapGridPosition _source;
	};
	if (_source isEqualType objNull && {!isNull _source} && {alive _source}) then {
		_id = "base:object:" + netId _source;
		_label = _source getVariable ["LTR_respawnName", _source getVariable ["BIS_fnc_respawnMenuPosition_name", _source getVariable ["Name", ""]]];
		if (_label == "") then {_label = getText (configFile >> "CfgVehicles" >> typeOf _source >> "displayName")};
	};
	if (_id != "" && {!(_id in _ids)}) then {
		_ids pushBack _id;
		_rows pushBack [_id, "Basis — " + _label, _source];
	};
} forEach _sources;
_rows
