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
		Diag_log "[LT] (Safety) SafeStartLoop started";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) SafeStartLoop started";
		};
	};
	
	if (!isDedicated) then 
	{
		[true] remoteExec ["LT_fnc_safety", allPlayers];
		Diag_log "[LT] (Safety) SafeStart started";
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat "[LT] (Safety) SafeStart started";
		};
	};
};
