/*

File: setLowtacFaces.sqf
Author: Brainless_Ben

Description:
Overrides faces of players with there custom face if set

Source:
https://community.bistudio.com/wiki/BIS_fnc_setIdentity

*/

if !(isServer) exitWith {};

_uids=
[
    "76561197992586763"     //Brainless_Ben
];
_faces=
[
    "Ben"
];
_glasses=
[
    nil
];

{
    _face = (_faces select _forEachIndex);
    _glas = (_glasses select _forEachIndex);
    _unit = (_x call BIS_fnc_getUnitByUID);

    [_x,_face,"","-1","",(name _unit),_glas] call BIS_fnc_setIdentity;
}forEach _uids;
