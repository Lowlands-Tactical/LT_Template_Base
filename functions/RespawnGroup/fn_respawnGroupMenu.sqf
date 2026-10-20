/*

File: fn_respawnGroupMenu.sqf
Author: Lowlands Tactical

Description:
Menu for "Deploy to group". Opens the dialog LT_RespawnGroup (idd 800) with a list of the targets from
LT_fnc_respawnGroupTargets and sends the choice to the server.
The dialog keeps updating while it is open: the time left counts down every second and the list is
refreshed every 2 seconds, so you can see when a target becomes dangerous (orange) or blocked (red).
The prefix ([GROUP], [PLAYER], [VEHICLE]) has the colour of your side.
Entries in orange have an enemy close by (press Deploy twice to confirm), entries in red are blocked.
The message about the selected entry (DANGER / BLOCKED) is shown in a coloured box at the top right.
The dialog closes by itself when the time is over.

Modes:
"open"   = Open the dialog and start the update loop (used by the ACE action)
"update" = Update the countdown and (optional, 2nd parameter true) the list (used by the loop)
"deploy" = Deploy to the selected entry (used by the Deploy button and double click)

Parameters:
_this select 0 = Mode (String)
_this select 1 = Refresh the list (Boolean, only for "update", default true)

Example:
["open"] call LT_fnc_respawnGroupMenu;

Return value:
True (if handled), false (if not)

*/

params [
	["_mode", "open", [""]],
	["_refresh", true, [true]]
];

// Declare all local variables
private [
	"_result", "_display", "_list", "_info",
	"_targets", "_prefixes", "_sideColour", "_statusColour",
	"_index", "_how", "_left", "_old",
	"_selObj", "_row", "_sameList", "_confirm",
	"_text", "_current", "_sec", "_obj",
	"_label", "_status", "_note", "_dist",
	"_cat", "_r", "_col", "_box", "_boxText", "_boxColour"
];

if (!hasInterface) exitWith {false};

_result = false;

switch (_mode) do
{
	case "open":
	{
		if ((serverTime >= (player getVariable ["LT_respawnGroup_until", 0])) || (player getVariable ["LT_respawnGroup_used", false])) then
		{
			hint "Deploy to group is not available.";
		} else
		{
			createDialog "LT_RespawnGroup";
			uiNamespace setVariable ["LT_respawnGroup_targets", []];
			uiNamespace setVariable ["LT_respawnGroup_confirm", [objNull, 0]];
			["update", true] call LT_fnc_respawnGroupMenu;

			// Update loop, stops by itself when the dialog is closed
			[] spawn
			{
				private ["_tick"];
				_tick = 1;
				while {!isNull (findDisplay 800)} do
				{
					uiSleep 1;
					["update", ((_tick % 2) == 0)] call LT_fnc_respawnGroupMenu;
					_tick = _tick + 1;
				};
			};
		};
		_result = true;
	};

	case "update":
	{
		_display = findDisplay 800;
		if (!isNull _display) then
		{
			_list = _display displayCtrl 801;
			_info = _display displayCtrl 804;
			_left = (player getVariable ["LT_respawnGroup_until", 0]) - serverTime;

			// Time over, already deployed or dead: close
			if ((_left <= 0) || (player getVariable ["LT_respawnGroup_used", false]) || (!alive player)) then
			{
				closeDialog 0;
				if (_left <= 0) then {hint "The deploy time is over."};
			} else
			{
				if (_refresh) then
				{
					_targets = [player] call LT_fnc_respawnGroupTargets;
					_old = uiNamespace getVariable ["LT_respawnGroup_targets", []];
					_prefixes = ["[GROUP]", "[PLAYER]", "[VEHICLE]"];
					_sideColour = switch (side group player) do
					{
						case west: {[0.35, 0.6, 1, 1]};
						case east: {[1, 0.35, 0.35, 1]};
						case resistance: {[0.4, 0.85, 0.4, 1]};
						default {[0.8, 0.8, 0.8, 1]};
					};

					// Remember the selected target
					_selObj = objNull;
					_row = lnbCurSelRow _list;
					if ((_row >= 0) && (_row < (count _old))) then {_selObj = (_old select _row) select 1};

					// Same targets in the same order: only update the cells, so selection and scrolling stay as they are
					_sameList = ((_old apply {_x select 1}) isEqualTo (_targets apply {_x select 1}));
					if (!_sameList) then
					{
						lnbClear _list;
						{_list lnbAddRow ["", "", "", ""]} forEach _targets;
					};

					{
						_x params ["_cat", "_obj", "_label", "_status", "_note", "_dist"];
						_statusColour = switch (_status) do
						{
							case 1: {[1, 0.55, 0, 1]};
							case 2: {[0.9, 0.15, 0.15, 1]};
							default {[1, 1, 1, 1]};
						};
						_r = _forEachIndex;
						_list lnbSetText [[_r, 0], _prefixes select _cat];
						_list lnbSetText [[_r, 1], _label];
						_list lnbSetText [[_r, 2], format ["%1 m", round _dist]];
						_list lnbSetText [[_r, 3], _note];

						// Colour of the cells, normal and when the row is selected (Right)
						_list lnbSetColor [[_r, 0], _sideColour];
						_list lnbSetColorRight [[_r, 0], _sideColour];
						for "_col" from 1 to 3 do
						{
							_list lnbSetColor [[_r, _col], _statusColour];
							_list lnbSetColorRight [[_r, _col], _statusColour];
						};
					} forEach _targets;

					// Put the selection back on the same target (or the first one)
					if (!_sameList) then
					{
						_index = _targets findIf {(_x select 1) == _selObj};
						if ((_index < 0) && (_targets isNotEqualTo [])) then {_index = 0};
						if (_index >= 0) then {_list lnbSetCurSelRow _index};
					};

					uiNamespace setVariable ["LT_respawnGroup_targets", _targets];

					// A confirmation is only valid as long as the status of that target did not change
					_confirm = uiNamespace getVariable ["LT_respawnGroup_confirm", [objNull, 0]];
					_index = _targets findIf {(_x select 1) == (_confirm select 0)};
					if (_index < 0) then
					{
						uiNamespace setVariable ["LT_respawnGroup_confirm", [objNull, 0]];
					} else
					{
						if (((_targets select _index) select 3) != (_confirm select 1)) then {uiNamespace setVariable ["LT_respawnGroup_confirm", [objNull, 0]]};
					};
				};

				// Info text with the time left (always visible)
				_targets = uiNamespace getVariable ["LT_respawnGroup_targets", []];
				if (_targets isEqualTo []) then
				{
					_text = "There is no one to deploy to.";
				} else
				{
					_text = if (("lt_respawngroup_mode" call BIS_fnc_getParamValue) == 1) then {"You will parachute in from 100 m."} else {"You will be placed next to the target."};
				};
				_sec = ceil _left;
				_info ctrlSetText format ["%1\nTime left: %2:%3%4", _text, floor (_sec / 60), ["", "0"] select ((_sec mod 60) < 10), _sec mod 60];
				_info ctrlSetTextColor ([[1, 1, 1, 1], [1, 0.3, 0.3, 1]] select (_left < 10));

				// Message box top right for the selected target: orange = danger, red = blocked, hidden when ok
				_box = _display displayCtrl 805;
				_current = [];
				_row = lnbCurSelRow _list;
				if ((_row >= 0) && (_row < (count _targets))) then {_current = _targets select _row};
				_status = 0;
				if (_current isNotEqualTo []) then {_status = _current select 3};
				if (_status == 0) then
				{
					_box ctrlShow false;
				} else
				{
					_confirm = uiNamespace getVariable ["LT_respawnGroup_confirm", [objNull, 0]];
					if (_status == 2) then
					{
						_boxColour = [0.75, 0.1, 0.1, 1];
						_boxText = format ["%1\nDeploy is blocked.", _current select 4];
					} else
					{
						_boxColour = [0.85, 0.45, 0, 1];
						_boxText = if ((_confirm select 0) == (_current select 1)) then {"Press Deploy again to confirm."} else {"Confirm Deploy to continue."};
						_boxText = format ["%1\n%2", _current select 4, _boxText];
					};
					_box ctrlSetBackgroundColor _boxColour;
					_box ctrlSetText _boxText;
					_box ctrlShow true;
				};
			};
			_result = true;
		};
	};

	case "deploy":
	{
		_list = (findDisplay 800) displayCtrl 801;
		_index = lnbCurSelRow _list;
		_targets = uiNamespace getVariable ["LT_respawnGroup_targets", []];

		if ((_index < 0) || (_index >= (count _targets))) then
		{
			hint "Select a target first.";
		} else
		{
			(_targets select _index) params ["_cat", "_obj", "_label", "_status", "_note"];
			_confirm = uiNamespace getVariable ["LT_respawnGroup_confirm", [objNull, 0]];

			// Blocked: nothing happens, the message box already says why
			if (_status != 2) then
			{
				if ((_status == 1) && ((_confirm select 0) != _obj)) then
				{
					uiNamespace setVariable ["LT_respawnGroup_confirm", [_obj, _status]];
					["update", false] call LT_fnc_respawnGroupMenu;
				} else
				{
					closeDialog 0;
					[player, _obj] remoteExec ["LT_fnc_respawnGroupRequest", 2];
				};
			};
		};
		_result = true;
	};

	default
	{
		["RespawnGroupMenu", format ["Unknown mode: %1", _mode], 1] call LT_fnc_log;
	};
};

_result
