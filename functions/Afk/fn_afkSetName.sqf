/*

File: fn_afkSetName.sqf
Author: Lowlands Tactical

Description:
Sets the name of the clone on this machine. The server runs this on every machine, also for JIP.
The clone is given by netId, because a new object is often not known yet on the clients when the message arrives.
The function waits until the object exists and sets the name twice (the second time after the group locality change).

Parameters:
_this select 0 = NetId of the unit (String)
_this select 1 = Name (String)

Example:
[netId _clone, "CLONE Jack Davis"] remoteExec ["LT_fnc_afkSetName", 0, _clone];

Return value:
True (if set)

*/

params [
	["_netId", "", [""]],
	["_name", "", [""]]
];

// Declare all local variables
private [
	"_unit", "_timeout"
];

_unit = objectFromNetId _netId;
_timeout = time + 15;
waitUntil {sleep 0.5; _unit = objectFromNetId _netId; ((!isNull _unit) || (time > _timeout))};

if (isNull _unit) exitWith {false};

_unit setName [_name,"CLONE",name _unit];
sleep 3;
if (!isNull _unit) then {_unit setName [_name,"CLONE",name _unit]};

true
