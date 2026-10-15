/*

File: LT_fnc_safeStartLoop.sqf
Author: Brainless_Ben

Description:
Loops every 60 seconds and shows a notification then mission safety if off.

*/

// Run the loop only on the server
if (isServer) then 
{
	// Redundant sleep to give everything a second to settle
	uisleep 2;
	while {lt_param_timer > 0} do
	{
		["SafeStart",[format["Time Remaining: %1 min",lt_param_timer]]] remoteExecCall ["BIS_fnc_showNotification"];
		["Safety","SafetyLoop cycle"] call LT_fnc_log;
		uisleep 60;

		if (lt_param_timer < 0) exitWith {};

		lt_param_timer = lt_param_timer - 1;
		publicVariable "lt_param_timer";
	};

	//Once the mission timer has reached 0, disable the safeties
	if (lt_param_timer == 0) then 
	{
		["SafeStartMissionStarting",["Mission starting now!"]] remoteExecCall ["BIS_fnc_showNotification"];
		[false] remoteExec ["LT_fnc_safety",allPlayers];
		["Safety","SafetyLoop ended"] call LT_fnc_log;
	};
};
