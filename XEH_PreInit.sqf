/*

File: XEH_PreInit.sqf
Author: Brainless_Ben

Description:
Defines global variables and hashmaps used in the template.

*/

//Missions global variables
lt_group_teleport = 0;
lt_resupply = 0;

//Staff array used for table ace action and admin briefing
_lt_staff=[
	"76561198042684200",	// Tybalty
	"76561198014060493",	// R.Hoods
	"76561197992586763"		// Brainless_Ben
];
_lt_crew=[
	"76561198010219180",	// PingWing
	"76561198047657052",	// DM3002X
	"76561198047491445" 	// Pekeru
];
AdminCrew = createHashMapFromArray [
	["Staff", _lt_staff],
	["Crew", _lt_crew]
];
publicVariable "AdminCrew";

//TabletSettings
_tabletList=[
	[
    	"C_Plane_Civil_01_F",
		"B_T_VTOL_01_vehicle_F"
	],
	[
		"B_supplyCrate_F",
		"I_E_CargoNet_01_ammo_F",
		"C_IDAP_supplyCrate_F",
		"NAF_Crate_Medium",
		"NAF_Crate_Small_Bwn",
		"NAF_Crate_Small_Grn",
		"NAF_Crate_Small_Gry",
		"NAF_Crate_Small_Oli",
		"NAF_Crate_Small_Tan"
	],
	[
		"None",
		"Crate Squad",
		"Crate Peleton",
		"Crate Small",
		"Crate Medium",
		"Crate Large",
		"Crate Explosives",
		"Crate Mines",
		"Crate Medical",
		"Crate Weapons",
		"Crate Air",
		"Crate Comms",
		"Crate NVG",
		"Crate UAV"
	]
];
_extraBASE=[
	[
		"B_Heli_Transport_03_unarmed_F",
		"B_Heli_Transport_01_F",
		"B_A_Plane_Transport_01_infantry_tna_F",
		"Aegis_C_Heli_Transport_02_VIP_F",
		"O_T_Heli_Transport_04_box_F"
	],
	[
		"NAF_Crate_Medium_Expl",
		"NAF_Crate_Medium_Medi",
		"NAF_Crate_Medium_Ammo",
		"NAF_Crate_Veh_Expl",
		"NAF_Crate_Veh_Medi",
		"NAF_Crate_Veh_Ammo"
	],
	[
		"M2 HMG",
		"Mk6 Morter",
		"Remote Designator",
		"Anti Tank",
		"Artillery",
		"King Quad",
		"Amarok Green",
		"Amarok Tan",
		"Assault Boat",
		"FRISC Motorboat"
	]
];
_extraGM=[
	[
		"gm_ge_army_ch53g",
		"gm_ge_army_ch53gs",
		"gm_gc_airforce_mi2t",
		"gm_ge_army_bo105m_vbh",
		"gm_ge_airforce_do28d2",
		"gm_gc_airforce_l410t"
	],
	[
		"gm_ammobox_aluminium_01_empty",
		"gm_fortification_crate_05",
		"gm_ammobox_aluminium_04_empty",
		"gm_fortification_crate_03",
		"gm_ammobox_aluminium_02_empty",
		"gm_fortification_crate_01"
	],
	[
		"K125 Motor",
		"Pkw 2 Beatle",
		"Pkw 8 VW",
		"Jeep Cargo",
		"Jeep MG3",
		"Jeep LATGM"
	]
];
_extraVN=[
	[
		"vnx_b_air_ac119_03_01",
		"vn_b_air_ch47_03_01",
		"vn_i_air_ch34_01_02",
		"vn_o_air_mi2_01_01",
		"vn_b_air_uh1b_01_01"
	],
	[
		"vn_b_ammobox_kit_anzac",
		"vn_o_ammobox_full_10",
		"vn_b_ammobox_full_33",
		"vn_o_ammobox_full_02",
		"vn_b_ammobox_supply_12",
		"vn_b_ammobox_full_10"
	],
	[
		"Anti Tank TOW",
		"Howitser",
		"Mortar",
		"Jeep",
		"Jeep MG",
		"Gun Boat"
	]
];
_extra40K=[
	[],
	[],
	[]
];

TabletSettings = createHashMapFromArray [
    ["VEH",		_tabletList #0],
	["CRATE",	_tabletList #1],
	["LOAD",	_tabletList #2],
	["EXTRA", createHashMapFromArray[
		["BASE", createHashMapFromArray[
			["VEH", _extraBASE #0],
			["CRATE", _extraBASE #1],
			["LOAD", _extraBASE #2]
		]],
		["GM", createHashMapFromArray[
			["VEH", _extraGM #0],
			["CRATE", _extraGM #1],
			["LOAD", _extraGM #2]
		]],
		["VN", createHashMapFromArray[
			["VEH", _extraVN #0],
			["CRATE", _extraVN #1],
			["LOAD", _extraVN #2]
		]],
		["40K", createHashMapFromArray[
			["VEH", _extra40K #0],
			["CRATE", _extra40K #1],
			["LOAD", _extra40K #2]
		]]
	]],
	["SIDES",	["WEST","EAST","GUER"]],
	["LINK",	["No Nav","Yes Nav"]],
	["ITEM",	["No Items","Yes Items"]],
	["WEAPON",	["No Weapon","Yes Weapon"]],
	["GEAR",	["No Role","Yes Role"]],
	["ROLES",	["com","sql","jtac","ftl","gren","comms","rifl","riflat","riflaa","dmr","ar","aar","medic","eng","mmg","mat","vhco","vhgu","vhdr","pilot","crew","jet","lvdw"]]
//		 		[ 00  , 01  ,  02  , 03  ,  04  ,  05   ,  06  ,   07   ,   08   , 09  , 10 , 11  ,  12   , 13  , 14  ,  15 ,  16  ,  17  ,  18  ,  19   ,  20  ,  21 ,  22  ];
];
publicVariable "TabletSettings";

Diag_log "[LT] (XEH) Template Base PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) Template Base PreInit finished";
};