// Both values use ATL. Enemy exclusion intentionally remains horizontal.
params ["_unit", "_position"];
(getPosATL _unit) vectorDistance _position <= 2
