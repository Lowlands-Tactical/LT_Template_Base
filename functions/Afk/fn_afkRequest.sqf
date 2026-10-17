/*

File: fn_afkRequest.sqf
Author: Lowlands Tactical

Description:
Client side of the AFK system. Used by the ACE actions and the keybinds.
Sends the request to the server, the server checks everything again.

Modes:
"go"   = Go AFK
"back" = Come back from AFK

Parameters:
_this select 0 = Mode (String)

Example:
["go"] call LT_fnc_afkRequest;

Return value:
True (if the request was sent), false (if not)

*/

params [["_mode", "go", [""]]];

// Declare all local variables
private [
	"_result", "_state"
];

if (!hasInterface) exitWith {false};

_result = false;
_state = player getVariable ["LT_afk_state", ""];

switch (_mode) do
{
	case "go":
	{
		if (_state == "") then
		{
			[player] remoteExec ["LT_fnc_afkStart", 2];
			_result = true;
		} else
		{
			hint "You are already AFK.";
		};
	};

	case "back":
	{
		if (_state in ["CLONE", "HOST", "WAIT"]) then
		{
			[player] remoteExec ["LT_fnc_afkEnd", 2];
			_result = true;
		} else
		{
			hint (if (_state == "BACK") then {"You are already coming back."} else {"You are not AFK."});
		};
	};

	default
	{
		["Afk", format ["afkRequest: unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
