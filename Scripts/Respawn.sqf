/*

File: onPlayerRespawn.sqf
Author: Brainless_Ben

Description:
On respawn of player reassigns team colour and radio settings

Parameters:
Params as shown in (https://community.bistudio.com/wiki/Event_Scripts)
params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

*/

params ["_unit", "_corpse"];
waitUntil {sleep 1; !isNull player;};

// Reset Insignia
private _insignia = [_corpse] call BIS_fnc_getUnitInsignia;
[_unit, _insignia] spawn 
{
	params ["_unit", "_insignia"];
	sleep 1;
	_unit setVariable ["BIS_fnc_setUnitInsignia_class", nil];
	[_unit, _insignia] call BIS_fnc_setUnitInsignia;
};

// Wait until player is loaded
if (vehicle player == player) then {
	player switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSlowWrflDnon";
};
_team = assignedTeam _corpse;
player assignTeam _team;

// reapply fatige and addactions
if ("lt_fatigue_onoff" call bis_fnc_getParamValue == 0) then 
{
	player enableFatigue false;
};
player addAction [
	"<t color='#FF0000'>Parachute</t>", 
	"\lt_template_base\scripts\paradrop.sqf", 
	"", 1, false, true, "", 
	"((vehicle player) isKindOf ""Air"") && (((position player) select 2) > 100) && (player != driver (vehicle player))"
];

// Readd zeus module
Diag_log "[LT] (Respawn) Reload zeus modules";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (Respawn) Reload zeus modules";
};
[] remoteExec ["LT_fnc_AdminZeusModule", 2];

// After respawn reassign all radios and channels
waitUntil {([] call acre_api_fnc_isInitialized)};

_hasRadio = [player] call acre_api_fnc_hasRadio;
if (_hasRadio) then 
{
	_allRadios = ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC77","ACRE_SEM52SL","ACRE_SEM70"];
	{
		_radio = _allRadios select _forEachIndex;
		_oldRadios = [_radio, _corpse] call acre_api_fnc_getAllRadiosByType;
		_newRadios = [_radio, _unit] call acre_api_fnc_getAllRadiosByType;
		{
			_oldRadio = _oldRadios select _foreachindex;
			_newRadio = _newRadios select _foreachindex;

			_oldPreset = [_oldRadio] call acre_api_fnc_getPreset;
			_oldEar = [_oldRadio] call acre_api_fnc_getRadioSpatial;
			_oldChannel = [_oldRadio] call acre_api_fnc_getRadioChannel;
			_oldVolume = [_oldRadio] call acre_api_fnc_getRadioVolume;
			
			[_newRadio, _oldPreset] call acre_api_fnc_setPreset;
			[_newRadio, _oldEar] call acre_api_fnc_setRadioSpatial;
			[_newRadio, _oldChannel] call acre_api_fnc_setRadioChannel;
			[_newRadio, _oldVolume] call acre_api_fnc_setRadioVolume;
		} forEach _oldRadios;
	}forEach _allRadios;

	diag_log "[LT] (Respawn) player radio('s) have been reset";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (Respawn) player radio('s) have been reset";
	};
}else
{
	diag_log "[LT] (Respawn) player has no radio";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat "[LT] (Respawn) player has no radio";
	};
};

_unit setUnitTrait ["audibleCoef", 0.2];
_unit setUnitTrait ["camouflageCoef", 0.2];
_unit setUnitTrait ["loadCoef", 0.5];

_role = _unit getVariable ["LT_unit_role", "custom"];
[uniformContainer _unit, 50] remoteExec ["LT_fnc_resetMaxLoad"];
[vestContainer _unit, 200] remoteExec ["LT_fnc_resetMaxLoad"];
if (_role == "eng" OR _role == "medic") then 
{
	[backpackContainer _unit, 400] remoteExec ["LT_fnc_resetMaxLoad"];
} else 
{
	[backpackContainer _unit, 300] remoteExec ["LT_fnc_resetMaxLoad"];
};

// Remove inventory from corpse
removeAllWeapons _corpse;
removeAllAssignedItems _corpse;
deleteVehicle (nearestObject [_corpse, "WeaponHolderSimulated"]);
