/*

File: fn_buildinNVG.sqf
Author: Brainless_Ben

Description:
Checks if given helmet had build in night vision defined by our list of known helmets

*/

_helmet = param [0, "", [""]];

_helmetsBuildinNVG = [
	"H_HelmetO_ViperSP_oicamo_F",
	"H_HelmetO_ViperSP_ghex_F",
	"H_HelmetO_ViperSP_hex_F",
	"H_HelmetO_ViperSP_whex_F",
	"FIR_HGU56P_Skull",
	"FIR_HGU56P_Skull_Death",
	"H_PilotHelmetFighter_B",
	"H_PilotHelmetFighter_I_E",
	"H_PilotHelmetFighter_O",
	"H_PilotHelmetFighter_I",
	"H_PilotHelmetFighter_B_A",
	"H_PilotHelmetFighter_I_I",
	"FIR_JHMCS",
	"FIR_JHMCS_II",
	"FIR_JHMCS_Type2",
	"RHS_jetpilot_usaf",
	"rhsusf_ihadss"
];

_result = false;
if (_helmet == "") exitWith 
{
	Diag_log "[LT] (buildinNVG) helmet does not exist";
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemchat "[LT] (buildinNVG) helmet does not exist";
	};
};
if (_helmet IN _helmetsBuildinNVG) then 
{
	_result = true;
} else 
{
	_result = false;
};

_result;
