// Relationship rule only. Life state, player ownership and safety are checked separately.
params ["_unit", "_target"];
!isNull _unit && {!isNull _target} && {_unit != _target}
&& {side group _unit == side group _target}
&& {([_target] call LTRespawn_fnc_commandRole) != ""}
&& {group _unit == group _target || {([_unit] call LTRespawn_fnc_commandRole) != ""}}
