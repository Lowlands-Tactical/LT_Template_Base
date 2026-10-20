/*

File: fn_afkLocal.sqf
Author: Lowlands Tactical

Description:
Runs on the machine of the AFK player (the unit must be local), started by the server.
"attach"  = Make the player invulnerable and captive and attach him a little behind the target (no target = stay where he is).
            Also blocks shooting and throwing (the projectile is deleted and the round is given back; ACE blockThrow) and starts the status text.
"free"    = Detach the player, he stays where he is (waiting for a teammate)
"release" = The player is back: detach him and put him in the vehicle (when given) or next to the target. He is visible, can walk
            around but stays invulnerable until LT_afk_backUntil (default 5 seconds) so he can orientate and find cover.

Parameters:
_this select 0 = Mode (String)
_this select 1 = The AFK player (Object)
_this select 2 = Target (Object, for "attach" and "release")
_this select 3 = Vehicle (Object, only for "release")

Example:
["attach", _unit, _leader] remoteExec ["LT_fnc_afkLocal", _unit];

Return value:
True (if done), false (if not)

*/

params [
	["_mode", "attach", [""]],
	["_unit", objNull, [objNull]],
	["_target", objNull, [objNull]],
	["_vehicle", objNull, [objNull]]
];

// Declare all local variables
private [
	"_result"
];

if ((isNull _unit) || (!local _unit)) exitWith {false};

_result = false;

switch (_mode) do
{
	case "attach":
	{
		_unit allowDamage false;
		_unit setVariable ["ace_medical_allowDamage", false];
		_unit setCaptive true;
		detach _unit;
		if (!isNull _target) then {_unit attachTo [_target, [0, -1.5, 0]]};

		// Block shooting and throwing while AFK (ACE has no blockFire effect, so the projectile is deleted in a Fired event handler)
		if ((_unit getVariable ["LT_afk_firedEH", -1]) < 0) then
		{
			_unit action ["SwitchWeapon", _unit, _unit, 100];
			_unit setVariable ["LT_afk_firedEH", _unit addEventHandler ["FiredMan",
			{
				params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
				deleteVehicle _projectile;
				if (_weapon in (weapons _unit)) then {_unit setAmmo [_weapon, ((_unit ammo _weapon) + 1)]};
			}]];
			if (!isNil "ace_common_fnc_statusEffect_set") then {[_unit, "blockThrow", "LT_afk", true] call ace_common_fnc_statusEffect_set};
		};

		// Status text while AFK
		if (scriptDone (missionNamespace getVariable ["LT_afk_statusLoop", scriptNull])) then
		{
			LT_afk_statusLoop = [] spawn
			{
				private ["_state", "_host", "_text", "_extra"];
				while {((player getVariable ["LT_afk_state", ""]) != "")} do
				{
					_state = player getVariable ["LT_afk_state", ""];
					_host = player getVariable ["LT_afk_host", objNull];
					_extra = "Use the ACE self interaction menu or your keybind to come back.";
					_text = "";
					switch (_state) do
					{
						case "HOST":
						{
							_text = format ["You are with %1.", name _host];
							if (player getVariable ["LT_afk_pending", false]) then
							{
								_text = format ["%1 You come back when he leaves the vehicle.", _text];
								_extra = "";
							};
						};
						case "WAIT": {_text = "Waiting: no player of your side is close."};
						case "BACK":
						{
							_text = format ["Welcome back! Protected for %1 more seconds.", ((ceil ((player getVariable ["LT_afk_backUntil", 0]) - serverTime)) max 0)];
							_extra = "";
						};
						default {};
					};
					hintSilent parseText format ["<t size='1.3' color='#ffcc00'>AFK</t><br/>%1<br/><t size='0.8'>%2</t>", _text, _extra];
					sleep 1;
				};
				hintSilent "";
			};
		};
		_result = true;
	};

	case "free":
	{
		detach _unit;
		_result = true;
	};

	case "release":
	{
		detach _unit;
		if (!isNull _vehicle) then
		{
			_unit moveInAny _vehicle;
			sleep 0.5;
		};

		// No vehicle, or no seat anymore: next to the host
		if ((isNull objectParent _unit) && (!isNull _target) && (alive _target)) then {_unit setPos (_target getPos [1.5, random 360])};

		// Invulnerable and captive until the back delay is over, then everything is normal again
		[_unit] spawn
		{
			params ["_unit"];
			sleep (((_unit getVariable ["LT_afk_backUntil", serverTime]) - serverTime) max 0);
			if ((_unit getVariable ["LT_afk_firedEH", -1]) >= 0) then
			{
				_unit removeEventHandler ["FiredMan", (_unit getVariable ["LT_afk_firedEH", -1])];
				_unit setVariable ["LT_afk_firedEH", -1];
			};
			if (!isNil "ace_common_fnc_statusEffect_set") then {[_unit, "blockThrow", "LT_afk", false] call ace_common_fnc_statusEffect_set};
			_unit allowDamage true;
			_unit setVariable ["ace_medical_allowDamage", true];
			_unit setCaptive false;
		};
		_result = true;
	};

	default
	{
		["Afk", format ["afkLocal: unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
