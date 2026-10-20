/*

File: fn_respawnGroupMove.sqf
Author: Lowlands Tactical

Description:
Moves the player to the target (runs on the client of the player, started by the server).
"NEAR" places the player next to the target, or in a free seat when the target is a vehicle.
"PARA" places the player in a parachute 100 m above the ground at the target.
"DENY" only shows a message.
When the move fails the player can deploy again.

Parameters:
_this select 0 = Target (Object)
_this select 1 = Mode (String): "NEAR", "PARA" or "DENY"
_this select 2 = Name of the target, or the message for "DENY" (String)

Example:
[_target, "NEAR", "Alpha 1-1"] remoteExec ["LT_fnc_respawnGroupMove", _owner];

Return value:
True (if moved), false (if not)

*/

params [
	["_target", objNull, [objNull]],
	["_mode", "NEAR", [""]],
	["_text", "", [""]]
];

// Declare all local variables
private [
	"_unit", "_success", "_pos", "_chute"
];

if (!hasInterface) exitWith {false};

if (_mode == "DENY") exitWith
{
	hint _text;
	false
};

_unit = player;
_success = true;

if ((isNull _target) || (!alive _target)) then
{
	_success = false;
	hint "The target is no longer available. Choose another one.";
} else
{
	if (_mode == "PARA") then
	{
		_pos = getPosATL _target;
		_pos set [2, 100];
		_chute = createVehicle ["Steerable_Parachute_F", _pos, [], 0, "FLY"];
		_chute setPosATL _pos;
		_chute setDir (getDir _target);
		_unit allowDamage false;
		_unit moveInDriver _chute;

		// Damage is back on 3 seconds after landing
		[_unit, _chute] spawn
		{
			params ["_unit", "_chute"];
			waitUntil {sleep 0.5; ((isNull objectParent _unit) || (!alive _chute))};
			sleep 3;
			_unit allowDamage true;
		};
	} else
	{
		if (_target isKindOf "CAManBase") then
		{
			_pos = (getPosATL _target) findEmptyPosition [1, 15, typeOf _unit];
			if (_pos isEqualTo []) then {_pos = _target getPos [2, random 360];};
			_unit setPos _pos;
			_unit setDir (_unit getDir _target);
		} else
		{
			_unit moveInAny _target;
			sleep 0.5;
			if ((vehicle _unit) != _target) then
			{
				_success = false;
				hint "There is no free seat anymore. Choose another target.";
			};
		};
	};
};

if (_success) then
{
	hint format ["Deployed to %1.", _text];
	["RespawnGroup", format ["Deployed to %1 (%2)", _text, _mode]] call LT_fnc_log;
} else
{
	// Let the player try again
	_unit setVariable ["LT_respawnGroup_used", false, true];
};

_success
