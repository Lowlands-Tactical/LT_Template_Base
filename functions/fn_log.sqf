/*

	File: fn_log.sqf
	Author: Lowlands Tactical

	Description:
	Central log function for the template. Writes a line to the RPT and, when the
	mission parameter lt_debug is on, also shows it in the system chat of the
	machine that runs it. Replaces the repeated diag_log + systemChat blocks.
	On a dedicated server there is no chat, so the line only ends up in the RPT.

	Parameters:
	_this select 0 = Tag, the part between brackets (String, for example "Safety")
	_this select 1 = Message (String) or an array for format ["text %1", _value]
	_this select 2 = Level (optional): 0 = empty, 1 = warning, 2 = info (default), 3 = error

	Example:
	["Safety", "Safety True"] call LT_fnc_log;
	["ZeusModule", ["ZEUS assigned to %1.", _staffName]] call LT_fnc_log;
	["Resupply", "Vehicle or Crate is Nil", 1] call LT_fnc_log;

	["","",2] call LT_fnc_log;
	["",format [],2] call LT_fnc_log;

	Returns:
	The log line that was written (String)

*/

params [
	["_tag", "General", [""]],
	["_message", "", ["", []]],
	["_level", 0, [0]]
];

// Build the message when a format array is given
if (_message isEqualType []) then {_message = format _message;};

_prefix = switch (_level) do
{
	case 1: {"WARNING: "};
	case 2: {"INFO "};
	case 3: {"ERROR: "};
	default {""};
};

_line = format ["[LT] (%1) %2%3", _tag, _prefix, _message];

Diag_log _line;

if (hasInterface && {("lt_debug" call bis_fnc_getParamValue) == 1}) then
{
	systemChat _line;
};

_line
