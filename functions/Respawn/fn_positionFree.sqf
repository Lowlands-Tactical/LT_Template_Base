// Server check shared by search, reservation and final release. Ignore our own reservation.
params ["_position", "_unit", ["_players", allPlayers]];
_players findIf {
	private _other = _x;
	private _placement = _other getVariable ["LTR_placement", []];
	_other != _unit && {alive _other} && {
		([_other] call LTRespawn_fnc_isActive && {_other distance2D _position < 1.5}) || {
			count _placement >= 5 && {count (_placement select 2) == 3}
			&& {serverTime <= (_placement select 3)} && {owner _other == (_placement select 4)}
			&& {_other getVariable ["LTR_waiting", false]}
			&& {(_placement select 2) distance2D _position < 1.5}
		}
	}
} == -1
