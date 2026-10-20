/*

File: fn_afkNotify.sqf
Author: Lowlands Tactical

Description:
Shows a message to the player (started by the server). Use the channel "chat" for messages that must stay within a side:
send it with remoteExec only to the players of that side.

Parameters:
_this select 0 = Message (String)
_this select 1 = Channel (String): "hint" (default) or "chat" (systemChat)

Example:
["You are already AFK."] remoteExec ["LT_fnc_afkNotify", _owner];
["Ben went AFK", "chat"] remoteExec ["LT_fnc_afkNotify", _sidePlayers];

Return value:
True (if shown)

*/

params [
	["_text", "", [""]],
	["_channel", "hint", [""]]
];

if (!hasInterface) exitWith {false};

if (_channel == "chat") then
{
	systemChat _text;
} else
{
	hint _text;
};

true
