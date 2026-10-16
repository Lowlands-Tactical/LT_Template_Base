// Recheck after suspension and inside the unscheduled commit, including reconnects.
params ["_unit", "_token", "_owner"];
private _placement = _unit getVariable ["LTR_placement", []];
!isNull _unit && {alive _unit} && {isPlayer _unit} && {owner _unit == _owner}
&& {_unit getVariable ["LTR_waiting", false]} && {_unit getVariable ["LTR_registered", false]}
&& {count _placement >= 5} && {(_placement select 0) isEqualTo _token} && {(_placement select 4) == _owner}
