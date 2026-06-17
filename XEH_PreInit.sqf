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
	"76561198047657052" 	// DM3002X
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
		"Amarok",
		"Amarok Comms",
		"Vector",
		"Vector XM312",
		"Vector Spike",
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
	["VEH", createHashMapFromArray[
		["BASE", (_tabletList #0) + (_extraBASE #0)],
		["GM", (_tabletList #0) + (_extraGM #0)],
		["VN", (_tabletList #0) + (_extraVN #0)],
		["40K", (_tabletList #0) + (_extra40K #0)]
	]],
	["CRATE", createHashMapFromArray[
		["BASE", (_tabletList #1) + (_extraBASE #1)],
		["GM", (_tabletList #1) + (_extraGM #1)],
		["VN", (_tabletList #1) + (_extraVN #1)],
		["40K", (_tabletList #1) + (_extra40K #1)]
	]],
	["LOADT", createHashMapFromArray[
		["BASE", (_tabletList #2) + (_extraBASE #2)],
		["GM", (_tabletList #2) + (_extraGM #2)],
		["VN", (_tabletList #2) + (_extraVN #2)],
		["40K", (_tabletList #2) + (_extra40K #2)]
	]],
	["LOAD", _tabletList #2],
	["SIDES",	["WEST","EAST","GUER"]],
	["LINK",	["No Nav","Yes Nav"]],
	["ITEM",	["No Items","Yes Items"]],
	["WEAPON",	["No Weapon","Yes Weapon"]],
	["GEAR",	["No Role","Yes Role"]],
	["ROLES",	["com","sql","jtac","ftl","gren","comms","rifl","riflat","riflaa","dmr","ar","aar","medic","eng","mmg","mat","vhco","vhgu","vhdr","pilot","crew","jet","lvdw"]]
//		 		[ 00  , 01  , 02   , 03  , 04   , 05    , 06   , 07     , 08     , 09  , 10 , 11  , 12    , 13  , 14  , 15  , 16   , 17   , 18   , 19    , 20   , 21  , 22   ];
];
publicVariable "TabletSettings";

Diag_log "[LT] (XEH) Template Base PreInit finished";
if ("lt_debug" call bis_fnc_getParamValue == 1) then 
{
	systemChat "[LT] (XEH) Template Base PreInit finished";
};