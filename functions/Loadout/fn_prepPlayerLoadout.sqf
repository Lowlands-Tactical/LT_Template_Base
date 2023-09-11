/*

File: fn_prepPlayerLoadout.sqf
Author: Brainless_Ben

Description:
preps loadout voor every player with the parameters from the description.ext or keeps the mission template.

Parameters:
[Player Object] 
	Example:
	[player] remoteExec ["LT_fnc_prepPlayerLoadout", player]
*/

// Checks
_unit = param [0, objNull, [objNull]];
if !(local _unit) exitWith {};
_side = side _unit;
_role = _unit getVariable ["LT_unit_role", "custom"];

if (_role == "custom") exitWith 
{
	Diag_log format["[LT] (prepLoadout) %1 has role %2 so no gear is set", name _unit, _role];
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (prepLoadout) %1 has role %2 so no gear is set", name _unit, _role];
	};
};
if (_side == civilian) exitWith 
{
	Diag_log format["[LT] (prepLoadout) %1 is a civilian, so no gear is set", name _unit];
	if ("lt_debug" call bis_fnc_getParamValue == 1) then 
	{
		systemChat format["[LT] (prepLoadout) %1 is a civilian, so no gear is set", name _unit];
	};
};

// Define all numbers from description.ext
_lt_Loadout = getMissionConfigValue ["LT_Loadout_ID","BASE"];

_lt_camo_blue = "lt_gear_camo_blue" call bis_fnc_getParamValue;
_lt_wpn_blue = "lt_gear_weapon_blue" call bis_fnc_getParamValue;

_lt_camo_red = "lt_gear_camo_red" call bis_fnc_getParamValue;
_lt_wpn_red = "lt_gear_weapon_red" call bis_fnc_getParamValue;

_lt_camo_green = "lt_gear_camo_green" call bis_fnc_getParamValue;
_lt_wpn_green = "lt_gear_weapon_green" call bis_fnc_getParamValue;

_lt_srTMP = "lt_gear_SR" call bis_fnc_getParamValue;
_lt_radioTMP = "lt_gear_radiopack" call bis_fnc_getParamValue;
_lt_nvgTMP = "lt_gear_nvg" call bis_fnc_getParamValue;
_lt_wpn_attTMP = "lt_gear_weapon_att" call bis_fnc_getParamValue;
_lt_wpn_scopeTMP = "lt_gear_weapon_scope" call bis_fnc_getParamValue;

Diag_log format["[LT] (preploadout) Loadout timeperiod %1 | %2 has role %3 on side %4", _lt_Loadout, name _unit, _role, _side];
Diag_log format["[LT] (prepLoadout) Bluefor-Camo:%1 Redfor-Camo:%2 Greenfor-Camo:%3", _lt_camo_blue, _lt_camo_red, _lt_camo_green];
Diag_log format["[LT] (prepLoadout) Bluefor-Weapon:%1 Redfor-Weapon:%2 Greenfor-Weapon:%3", _lt_wpn_blue, _lt_wpn_red, _lt_wpn_green];
Diag_log format["[LT] (prepLoadout) ShortRadio:%1 LongRadio:%2 NVG:%3 Weapon Att:%4 Scope:%5", _lt_srTMP, _lt_radioTMP, _lt_nvgTMP, _lt_wpn_attTMP, _lt_wpn_scopeTMP];
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemchat format["[LT] (preploadout) Loadout timeperiod %1 | %2 has role %3 on side %4", _lt_Loadout, name _unit, _role, _side];
	systemChat format["[LT] (prepLoadout) Bluefor-Camo:%1 Redfor-Camo:%2 Greenfor-Camo:%3", _lt_camo_blue, _lt_camo_red, _lt_camo_green];
	systemChat format["[LT] (prepLoadout) Bluefor-Weapon:%1 Redfor-Weapon:%2 Greenfor-Weapon:%3", _lt_wpn_blue, _lt_wpn_red, _lt_wpn_green];
	systemChat format["[LT] (prepLoadout) ShortRadio:%1 LongRadio:%2 NVG:%3 Weapon Att:%4 Scope:%5", _lt_srTMP, _lt_radioTMP, _lt_nvgTMP, _lt_wpn_attTMP, _lt_wpn_scopeTMP];
};

// Define numers to string if needed
_lt_sr_radio = switch (_lt_SrTMP) do 
{
	case 0: {["NONE"]}; //Nobody get ShortRange
	case 1: {["com","sql","jtac","ftl","gren","comms","rifl","riflat","dmr","ar","aar","medic","eng","vhco","vhgu","vhdr","pilot","crew","jet","lvdw"]};
	case 2: {["com","sql"]};
	case 3: {["com","sql","ftl"]};
	case 4: {["com","sql","ftl","medic"]};
	case 5: {["com","sql","ftl","gren"]};
	case 6: {["com","sql","ftl","dmr"]};
	case 7: {["com","sql","ftl","comms"]};
};

_lt_radiopack = switch (_lt_radioTMP) do 
{
	case 0: {["NONE"]}; //Nobody get LongRange and radiobackpack
	case 1: {["comms"]};
	case 2: {["com","sql"]};
	case 3: {["com","sql","ftl"]};
	case 4: {["com","sql","ftl","medic"]};
	case 5: {["com","sql","ftl","gren"]};
	case 6: {["com","sql","ftl","dmr"]};
	case 7: {["com","sql","ftl","eng"]};
};

_lt_nvg = switch (_lt_nvgTMP) do 
{
	case 0: {"False"};
	case 1: {"True"};
};

_lt_wpn_att = str _lt_wpn_attTMP;
_lt_wpn_scope = switch (_lt_wpn_scopeTMP) do 
{
	case 0: {"False"};
	case 1: {"True"};
};

// Define parameters to send with gear/weapon script
_lt_camoTMP = switch (_side) do 
{
	case west: {_lt_camo_blue};
	case east: {_lt_camo_red};
	case resistance: {_lt_camo_green};
};

_lt_wpnTMP = switch (_side) do 
{
	case west: {_lt_wpn_blue};
	case east: {_lt_wpn_red};
	case resistance: {_lt_wpn_green};
};

_lt_camo_params = [_unit,_lt_nvg,_lt_sr_radio,_lt_radiopack,_lt_camoTMP];
_lt_wpn_params = [_unit,_lt_nvg,_lt_wpn_att,_lt_wpn_scope,_lt_wpnTMP];

_camo = "";
_weapon = "";

switch (_lt_Loadout) do 
{
	case "BASE":
	{
		_camo = "\lt_template_gear\Loadout_BASE\prepLoadout_Gear.sqf";
		_weapon = "\lt_template_gear\Loadout_BASE\prepLoadout_Weapon.sqf";
	};
	case "GM":
	{
		_camo = "\lt_template_gear\Loadout_GM\prepLoadout_Gear.sqf";
		_weapon = "\lt_template_gear\Loadout_GM\prepLoadout_Weapon.sqf";
	};
	case "VN":
	{
		_camo = "\lt_template_gear_vn\Loadout_VN\prepLoadout_Gear.sqf";
		_weapon = "\lt_template_gear_vn\Loadout_VN\prepLoadout_Weapon.sqf";
	};
};

_camoHandle = _lt_camo_params execVM _camo;
waitUntil {uiSleep 0.3; scriptDone _camoHandle};

_wpnHandle = _lt_wpn_params execVM _weapon;
waitUntil {uiSleep 0.3; scriptDone _wpnHandle};
