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
		Diag_log "[LT] (Safety) SafetyLoop";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) SafetyLoop";
		};
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
		Diag_log "[LT] (Safety) SafetyLoop ended";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) SafetyLoop ended";
		};
	};
};
