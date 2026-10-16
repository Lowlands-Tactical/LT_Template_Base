// The server created this canopy and froze it until its occupant/position replicated.
params ["_unit", "_position", "_chute"];
!isNull _chute && {alive _chute} && {_chute isKindOf "ParachuteBase"}
&& {vehicle _unit == _chute} && {driver _chute == _unit}
&& {(getPosATL _chute) vectorDistance (_position vectorAdd [0,0,100]) <= 2}
