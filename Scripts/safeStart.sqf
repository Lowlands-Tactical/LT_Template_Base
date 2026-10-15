/*
	
	File: safeStart.sqf
	Author: Brainless_Ben
	
	Description:
	Initial start of the LT safety + timer.
	
*/

// Setup the variables
if (isNil "lt_param_timer") then 
{
	lt_param_timer = "lt_param_timer" call BIS_fnc_getParamValue;
};

// if a value was set for the mission-timer, begin the safe-start loop and turn on invincibility
if (lt_param_timer > 0) then 
{
	if (isServer) then 
	{
		[] remoteExec ["LT_fnc_safeStartLoop"];
		["Safety","SafeStartLoop started",2] call LT_fnc_log;
	};
	
	if (!isDedicated) then 
	{
		[true] remoteExec ["LT_fnc_safety", allPlayers];
		["Safety","SafeStart started",2] call LT_fnc_log;
	};
};
