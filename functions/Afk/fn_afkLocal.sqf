/*

File: fn_afkLocal.sqf
Author: Lowlands Tactical

Description:
Runs on the machine of the AFK player (the unit must be local), started by the server.
"attach"  = Make the player invulnerable and captive and attach him to the target. Also starts the status text.
"free"    = Detach the player, he stays where he is (waiting for a teammate)
"release" = The player is back: detach him next to the target. He is hidden no more, can walk around but stays
            invulnerable until LT_afk_backUntil (default 5 seconds) so he can orientate and find cover.

Parameters:
_this select 0 = Mode (String)
_this select 1 = The AFK player (Object)
_this select 2 = Target (Object, for "attach" and "release")

Example:
["attach", _unit, _clone] remoteExec ["LT_fnc_afkLocal", _unit];

Return value:
True (if done), false (if not)

*/

params [
	["_mode", "attach", [""]],
	["_unit", objNull, [objNull]],
	["_target", objNull, [objNull]]
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
		_unit attachTo [_target, [0, 0, 0]];

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
						case "CLONE": {_text = "You are attached to your clone."};
						case "HOST": {_text = format ["You are with %1.", name _host]};
						case "WAIT": {_text = "Waiting: your whole team is down."};
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
		if ((!isNull _target) && (alive _target)) then {_unit setPos (_target getPos [1.5, random 360])};

		// Invulnerable and captive until the back delay is over, then everything is normal again
		[_unit] spawn
		{
			params ["_unit"];
			sleep (((_unit getVariable ["LT_afk_backUntil", serverTime]) - serverTime) max 0);
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
