/*

File: fn_Intel.sqf
Author: Brainless_Ben

Description:
Function for intel module, Sets module data on synced item to be picked up.

Return value:
zeus marker where intel is.

*/

private ["_logic","_objects","_intel","_side","_titel","_text","_picture","_mkrCntVar","_mkrCnt","_mkrName","_mkrPos","_mkr"];
_logic = param [0,objNull,[objNull]];

_objects = synchronizedObjects _logic;
_intel = _objects select 0;
removeAllActions _intel;

_actionName = _logic getVariable ["Intel_ActionName", "Take Intel"];
_titel = _logic getVariable ["Intel_Titel", "Titel"];
_text = _logic getVariable ["Intel_Text", ""];
_picture = _logic getVariable ["Intel_Picture", ""];

if (isServer) then 
{
    _intel setVariable ["RscAttributeOwners", [west,east,resistance,civilian], true];
    _intel setVariable ["RscAttributeDiaryRecord_texture", _picture, true];
    [_intel, "RscAttributeDiaryRecord", [_titel, _text]] call BIS_fnc_setServerVariable;
    [
        _intel, "IntelObjectFound", 
        {
            params ["_object", "_foundBy"];
            private _msg = format ["Intel found by %1", name _foundBy];
            _msg remoteExec ["systemChat", 0];
        }
    ] call BIS_fnc_addScriptedEventHandler;
};

if (hasInterface) then 
{
    _intel addAction [
        _actionName,
        {
            params ["_target","_caller"];
            _target setVariable ["recipients", (side _caller), true];
            [_this, "action"] spawn BIS_fnc_initIntelObject;
        },
        [], 10,true, true, "",
        "isPlayer _this && {_this distance _target < 2} &&
        {(side group _this) in (_target getvariable ['RscAttributeOwners',[west,east,resistance,civilian]])}"
    ];
};

// Create only curator visable marker with titelname on location
_mkrCntVar = _fnc_scriptName + "_counter";
_mkrCnt = if (isnil _mkrCntVar) then {-1} else {missionNameSpace getVariable _mkrCntVar};
_mkrCnt = _mkrCnt + 1;
_mkrName = format ["IntelMarker_%1", _mkrCnt];
missionNameSpace setVariable [_mkrCntVar, _mkrCnt];

_mkrPos = getPos _intel;
_mkr = createMarkerLocal [_mkrName, _mkrPos];
_mkr setMarkerTextLocal _titel;
_mkr setMarkerTypeLocal "Empty";
_mkr setMarkerColorLocal "ColorOrange";
_mkr;
