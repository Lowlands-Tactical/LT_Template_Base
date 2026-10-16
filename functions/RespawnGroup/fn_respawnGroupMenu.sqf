/*

File: fn_respawnGroupMenu.sqf
Author: Lowlands Tactical

Description:
Menu for "Deploy to group". Opens the dialog LT_RespawnGroup (idd 800), fills the list
with the targets from LT_fnc_respawnGroupTargets and sends the choice to the server.
Entries in yellow have an enemy close by (press Deploy twice to confirm), entries in red are blocked.

Modes:
"open"   = Open the dialog (used by the ACE action)
"fill"   = Fill the list (used by "open")
"deploy" = Deploy to the selected entry (used by the Deploy button and double click)

Parameters:
_this select 0 = Mode (String)

Example:
["open"] call LT_fnc_respawnGroupMenu;

Return value:
True (if handled)

*/

params [["_mode", "open", [""]]];

// Declare all local variables
private [
	"_display", "_list", "_info", "_targets",
	"_prefixes", "_text", "_index", "_how",
	"_left"
];

if (!hasInterface) exitWith {false};

if (_mode == "open") exitWith
{
	if (serverTime >= (player getVariable ["LT_respawnGroup_until", 0]) || {player getVariable ["LT_respawnGroup_used", false]}) then
	{
		hint "Deploy to group is not available.";
	} else
	{
		createDialog "LT_RespawnGroup";
		["fill"] call LT_fnc_respawnGroupMenu;
	};
	true
};

if (_mode == "fill") exitWith
{
	_display = findDisplay 800;
	_list = _display displayCtrl 801;
	_info = _display displayCtrl 804;
	_targets = [player] call LT_fnc_respawnGroupTargets;
	_prefixes = ["[GROUP] ", "[PLAYER] ", "[VEHICLE] "];

	uiNamespace setVariable ["LT_respawnGroup_targets", _targets];
	uiNamespace setVariable ["LT_respawnGroup_confirm", -1];
	lbClear _list;

	{
		_x params ["_cat", "_obj", "_label", "_status", "_note", "_dist"];
		_text = format ["%1%2  -  %3 m", _prefixes select _cat, _label, round _dist];
		if (_note != "") then {_text = _text + "  -  " + _note;};
		_index = _list lbAdd _text;
		_list lbSetColor [
			_index, switch (_status) do {
				case 1: {[1, 0.8, 0, 1]};
				case 2: {[0.75, 0, 0, 1]};
				default {[1, 1, 1, 1]};
			}];
	} forEach _targets;

	if (_targets isEqualTo []) then
	{
		_info ctrlSetText "There is no one to deploy to.";
	} else
	{
		_how = if (("lt_respawngroup_mode" call BIS_fnc_getParamValue) == 1) then {"You will parachute in from 100 m."} else {"You will be placed next to the target."};
		_left = round ((player getVariable ["LT_respawnGroup_until", 0]) - serverTime);
		_info ctrlSetText format ["%1\nYou have %2 seconds left.", _how, _left];
		_list lbSetCurSel 0;
	};
	true
};

if (_mode == "deploy") exitWith
{
	_list = (findDisplay 800) displayCtrl 801;
	_index = lbCurSel _list;
	_targets = uiNamespace getVariable ["LT_respawnGroup_targets", []];

	if (_index < 0 || {_index >= count _targets}) then
	{
		hint "Select a target first.";
	} else
	{
		(_targets select _index) params ["_cat", "_obj", "_label", "_status", "_note"];
		if (_status == 2) then
		{
			hint format ["You can't deploy to %1: %2.", _label, _note];
		} else
		{
			if (_status == 1 && {(uiNamespace getVariable ["LT_respawnGroup_confirm", -1]) != _index}) then
			{
				uiNamespace setVariable ["LT_respawnGroup_confirm", _index];
				hint format ["%1\nPress Deploy again to confirm.", _note];
			} else
			{
				closeDialog 0;
				[player, _obj] remoteExec ["LT_fnc_respawnGroupRequest", 2];
			};
		};
	};
	true
};

false
