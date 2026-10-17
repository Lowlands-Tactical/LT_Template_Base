/*

File: fn_afkNotify.sqf
Author: Lowlands Tactical

Description:
Shows a message to the player (started by the server).

Parameters:
_this select 0 = Message (String)

Example:
["You are already AFK."] remoteExec ["LT_fnc_afkNotify", _owner];

Return value:
True (if shown)

*/

params [["_text", "", [""]]];

if (!hasInterface) exitWith {false};

hint _text;

true
