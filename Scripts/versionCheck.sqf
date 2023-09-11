/*

File: versionCheck.sqf
Author: Brainless_Ben

Description:
Checks the LT template and LT mission template numbers

*/

private ["_versions"];
_versions = missionNameSpace getVariable ["lt_version",""];

// Version checker
if (isServer) then 
{
	LT_version = _versions;
	publicVariable "LT_version";
	Diag_log format["[LT] (versionCheck) LT version server: %1", LT_version];
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (versionCheck) LT version server: %1", LT_version];
	};
};

if (hasInterface) then
{
	if (LT_version == _versions) then 
	{
		Diag_log format["[LT] (versionCheck) Player: %1 has correct LT version: %2", name player, LT_version];
		if ("lt_debug" call bis_fnc_getParamValue == 1) then 
		{
			systemChat format["[LT] (versionCheck) Player: %1 has correct LT version: %2", name player, LT_version];
		};
	} else 
	{
		_errorMismatch = format["[LT] (versionCheck) Player: %1 has mismatch LT version: Correct: %2 Incorrect: %3", name player, LT_version, _versions];
		Diag_log _errorMismatch;
		systemChat _errorMismatch;
		[_errorMismatch] remoteExec ["globalChat", 0];
	};
};
