// Reject an obstructed vertical approach to the intended landing point.
params ["_unit", "_position"];
!lineIntersects [ATLToASL (_position vectorAdd [0,0,1]), ATLToASL (_position vectorAdd [0,0,100]), _unit, vehicle _unit]
