#include "macros.inc"

class ctrlEdit;
class ctrlCombo;
class Cfg3DEN
{
	class Object 
	{
		class AttributeCategories 
		{
			class LT_Category_Soldier
			{
				displayName = "Lowlands Tactical: Soldier settings";
				collapsed = 0;
				class Attributes 
				{
					class LT_unit_role
					{
						displayName = "Select role";
						tooltip = "Configure the role of this unit";
						property = "LT_unit_role_ID";
						control = "LT_unit_role";
						expression = "_this setVariable ['LT_unit_role',_value,true];";
						defaultValue = "custom";
						condition = "objectBrain + objectControllable"; 
						typeName = "STRING"; 
					};
					class LT_unit_gear
					{
						displayName = "Has weapon/consumables";
						tooltip = "Select if unit get weapon/consumables (grenade/smoke/medic)";
						property = "LT_unit_gear_ID";
						control = "CheckboxNumber";
						expression = "_this setVariable ['LT_unit_gear',_value,true];";
						validate = "number";
						defaultValue = 1;
						condition = "objectBrain + objectControllable"; 
						typeName = "NUMBER";
					};
					class LT_unit_item
					{
						displayName = "Has role items";
						tooltip = "Select if unit has role specific items (medic/supply engineer/toolkit)";
						property = "LT_unit_item_ID";
						control = "CheckboxNumber";
						expression = "_this setVariable ['LT_unit_item',_value,true];";
						validate = "number";
						defaultValue = 1;
						condition = "objectBrain + objectControllable"; 
						typeName = "NUMBER";
					};
				};
			};
			class LT_Category_Object
			{
				displayName = "Lowlands Tactical: Vehicle settings";
				collapsed = 0;
				class Attributes 
				{
					class LT_veh_side
					{
						displayName = "Select vehicle side";
						tooltip = "Configure the side of vehicle";
						property = "LT_veh_side_ID";
						control = "LT_veh_side";
						expression = "_this setVariable ['LT_veh_side',_value,true];";
						defaultValue = "Custom";
						condition = "objectVehicle + objectHasInventoryCargo";
						typeName = "STRING";
					};
					class LT_veh_role
					{
						displayName = "Select cargo type";
						tooltip = "Configure the type of cargo loaded";
						property = "LT_veh_role_ID";
						control = "LT_veh_role";
						expression = "_this setVariable ['LT_veh_role',_value,true];";
						defaultValue = "Custom";
						condition = "objectVehicle + objectHasInventoryCargo";
						typeName = "STRING";
					};
					class LT_veh_respawn
					{
						displayName = "Vehicle respawn";
						tooltip = "Select if the vehicle respawns";
						property = "LT_veh_respawn_ID";
						control = "CheckboxNumber";
						expression = "_this setVariable ['LT_veh_respawn',_value,true];";
						validate = "number";
						defaultValue = 0;
						condition = "objectVehicle";
						typeName = "NUMBER";
					};
					class LT_drone_side
					{
						displayName = "Select drone side";
						tooltip = "Configure the side of drone and AI (ONLY for drones/wil override default side)";
						property = "LT_drone_side_ID";
						control = "LT_drone_side";
						expression = "_this setVariable ['LT_drone_side',_value,true];";
						defaultValue = "Custom";
						condition = "objectVehicle + objectHasInventoryCargo";
						typeName = "STRING";
					};
				};
			};
		};
	};
	class Mission
	{
		class Scenario
		{
			class AttributeCategories
			{
				class LT_Category_Other
				{
					displayname = "Lowlands Tactical: Scenario Settings";
					collapsed 	= 0;
					class Attributes
					{
						class LT_Loadout;
						class LT_PermaDeath
						{
							displayName = "PermaDeath Scenario";
							tooltip = "Check if this is a PermaDeath scenario";
							property = "LT_PermaDeath_ID";
							control = "CheckboxNumber";
							validate = "number";
							defaultValue = "0";
							typeName = "NUMBER";
						};
					};
				};
			};
		};
	};
	class Attributes 
	{
		class Default;
		class Title: Default
		{
			class Controls
			{
				class Title;
			};
		};
		class LT_unit_role: Title
		{
			attributeLoad = "_ctrl = _this controlsGroupCtrl 100;_attCtrl = getText( _config >> 'control' );_staticItemsCfg = configFile >> 'Cfg3DEN' >> 'Attributes' >> _attCtrl >> 'Controls' >> 'Value' >> 'items';_fnc_setValues = {private [ '_index' ];params[ '_path', [ '_apply', true ] ];{_cfg = _x; if ( _apply ) then {	_index = _ctrl lbAdd getText( _cfg >> 'text' ); _ctrl lbSetData [ _index, getText( _cfg >> 'data' ) ];} else {_index = _foreachindex;}; if ( !( _value isEqualType '' ) ) then {if ( _index isEqualTo _value ) then {_ctrl lbSetCurSel _index;} ;} else {if ( _value == getText( _cfg >> 'data' ) ) then {_ctrl lbSetCurSel _index;};}; } forEach configProperties [_path,'isclass _x'];}; if ( isClass _staticItemsCfg ) then {[ _staticItemsCfg, false ] call _fnc_setValues;};";
			attributeSave =	"_ctrl = _this controlsGroupCtrl 100;_ctrl lbData lbCurSel _ctrl;";
			class Controls: Controls
			{
				class Title: Title{}; 
				class Value: ctrlCombo
				{
					idc = 100;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = SIZE_M * GRID_H;

					class Items
					{
						class LT_Role_CUSTOM 	{data = "custom";	text = "Custom (via Arsenal)"; default = 1;};
						class LT_Role_COM 		{data = "com";		text = "Commander";};
						class LT_Role_SQL 		{data = "sql";		text = "Squad leader";};
						class LT_Role_JTAC 		{data = "jtac";		text = "JTAC operator";};
						class LT_Role_FTL 		{data = "ftl";		text = "Fire team leader";};
						class LT_Role_GREN 		{data = "gren";		text = "Grenadier";};
						class LT_Role_COMMS		{data = "comms";	text = "Radioman (GM & VN)";};
						class LT_Role_RIFL 		{data = "rifl";		text = "Rifleman";};
						class LT_Role_RIFLAT 	{data = "riflat";	text = "Rifleman (AT)";};
						class LT_Role_DMR		{data = "dmr";		text = "Marksman (DMR)";}
						class LT_Role_AR 		{data = "ar";		text = "Automatic rifleman";};
						class LT_Role_AAR 		{data = "aar";		text = "Assistant automatic rifleman";};
						class LT_Role_MEDIC 	{data = "medic";	text = "Medic";};
						class LT_Role_ENG 		{data = "eng";		text = "Engineer";};
						class LT_Role_VHCO 		{data = "vhco";		text = "Vehicle commander";};
						class LT_Role_VHGU 		{data = "vhgu";		text = "Vehicle gunner";};
						class LT_Role_VHDR 		{data = "vhdr";		text = "Vehicle driver (repair)";};
						class LT_Role_PILOT 	{data = "pilot";	text = "Air vehicle pilot (repair)";};
						class LT_Role_CREW 		{data = "crew";		text = "Air vehicle crew";};
						class LT_Role_JET 		{data = "jet";		text = "Air vehicle jet";};
						class LT_Role_LVDW 		{data = "lvdw";		text = "Lul van de week";};
					};
				};
			};
		};
		class LT_drone_side: Title
		{
			attributeLoad = "_ctrl = _this controlsGroupCtrl 100;_attCtrl = getText( _config >> 'control' );_staticItemsCfg = configFile >> 'Cfg3DEN' >> 'Attributes' >> _attCtrl >> 'Controls' >> 'Value' >> 'items';_fnc_setValues = {private [ '_index' ];params[ '_path', [ '_apply', true ] ];{_cfg = _x; if ( _apply ) then {	_index = _ctrl lbAdd getText( _cfg >> 'text' ); _ctrl lbSetData [ _index, getText( _cfg >> 'data' ) ];} else {_index = _foreachindex;}; if ( !( _value isEqualType '' ) ) then {if ( _index isEqualTo _value ) then {_ctrl lbSetCurSel _index;} ;} else {if ( _value == getText( _cfg >> 'data' ) ) then {_ctrl lbSetCurSel _index;};}; } forEach configProperties [_path,'isclass _x'];}; if ( isClass _staticItemsCfg ) then {[ _staticItemsCfg, false ] call _fnc_setValues;};";
			attributeSave =	"_ctrl = _this controlsGroupCtrl 100;_ctrl lbData lbCurSel _ctrl;";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{
					idc = 100;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = SIZE_M * GRID_H;

					class Items
					{
						class LT_Drone_Side_Blue 	{data = "WEST";	text = "BLUEFOR"; default = 1;};
						class LT_Drone_Side_Red 	{data = "EAST";	text = "OPFOR";};
						class LT_Drone_Side_Green	{data = "GUER";	text = "INDEPENDENT";};
						class LT_Drone_Side_Purple  {data = "CIV";	text = "CIVILIAN";};
					};
				};
			};
		};
		class LT_veh_side: Title
		{
			attributeLoad = "_ctrl = _this controlsGroupCtrl 100;_attCtrl = getText( _config >> 'control' );_staticItemsCfg = configFile >> 'Cfg3DEN' >> 'Attributes' >> _attCtrl >> 'Controls' >> 'Value' >> 'items';_fnc_setValues = {private [ '_index' ];params[ '_path', [ '_apply', true ] ];{_cfg = _x; if ( _apply ) then {	_index = _ctrl lbAdd getText( _cfg >> 'text' ); _ctrl lbSetData [ _index, getText( _cfg >> 'data' ) ];} else {_index = _foreachindex;}; if ( !( _value isEqualType '' ) ) then {if ( _index isEqualTo _value ) then {_ctrl lbSetCurSel _index;} ;} else {if ( _value == getText( _cfg >> 'data' ) ) then {_ctrl lbSetCurSel _index;};}; } forEach configProperties [_path,'isclass _x'];}; if ( isClass _staticItemsCfg ) then {[ _staticItemsCfg, false ] call _fnc_setValues;};";
			attributeSave =	"_ctrl = _this controlsGroupCtrl 100;_ctrl lbData lbCurSel _ctrl;";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{
					idc = 100;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = SIZE_M * GRID_H;

					class Items
					{
						class LT_Side_Blue 	{data = "WEST";	text = "BLUEFOR"; default = 1;};
						class LT_Side_Red 	{data = "EAST";	text = "OPFOR";};
						class LT_Side_Green	{data = "GUER";	text = "INDEPENDENT";};
					};
				};
			};
		};
		class LT_veh_role: Title
		{
			attributeLoad = "_ctrl = _this controlsGroupCtrl 100;_attCtrl = getText( _config >> 'control' );_staticItemsCfg = configFile >> 'Cfg3DEN' >> 'Attributes' >> _attCtrl >> 'Controls' >> 'Value' >> 'items';_fnc_setValues = {private [ '_index' ];params[ '_path', [ '_apply', true ] ];{_cfg = _x; if ( _apply ) then {	_index = _ctrl lbAdd getText( _cfg >> 'text' ); _ctrl lbSetData [ _index, getText( _cfg >> 'data' ) ];} else {_index = _foreachindex;}; if ( !( _value isEqualType '' ) ) then {if ( _index isEqualTo _value ) then {_ctrl lbSetCurSel _index;} ;} else {if ( _value == getText( _cfg >> 'data' ) ) then {_ctrl lbSetCurSel _index;};}; } forEach configProperties [_path,'isclass _x'];}; if ( isClass _staticItemsCfg ) then {[ _staticItemsCfg, false ] call _fnc_setValues;};";
			attributeSave =	"_ctrl = _this controlsGroupCtrl 100;_ctrl lbData lbCurSel _ctrl;";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{
					idc = 100;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = SIZE_M * GRID_H;

					class Items
					{
						class LT_Role_Custom 	{data = "Custom";			text = "Custom (via arsenal)"; default = 1;};
						class LT_Role_Empty 	{data = "Empty";			text = "Empty";};
						class LT_Role_Cr_Small 	{data = "Crate Small";		text = "Small Ammocrate";};
						class LT_Role_Cr_Medium	{data = "Crate Medium";		text = "Medium Ammocrate";};
						class LT_Role_Cr_Large	{data = "Crate Large";		text = "Large Ammocrate";};
						class LT_Role_Cr_Explo	{data = "Crate Explosives";	text = "Explosives Crate";};
						class LT_Role_Cr_Mine	{data = "Crate Mines";		text = "Mine Crate";};
						class LT_Role_Cr_Medic	{data = "Crate Medical";	text = "Medical Crate";};
						class LT_Role_Cr_Weapon	{data = "Crate Weapons";	text = "Weapons Crate";};
						class LT_Role_Cr_NVG	{data = "Crate NVG";		text = "NVG Crate";};
						class LT_Role_Cr_Comms 	{data = "Crate Comms";		text = "Communication Crate";};
						class LT_Role_Cr_Air	{data = "Crate Air";		text = "Aircrew Ammocrate";};
					};
				};
			};
		};
		class LT_Combo_Loadout: LT_veh_role
		{
			attributeLoad = "_ctrl = _this controlsGroupCtrl 100;_attCtrl = getText( _config >> 'control' );_staticItemsCfg = configFile >> 'Cfg3DEN' >> 'Attributes' >> _attCtrl >> 'Controls' >> 'Value' >> 'items';_fnc_setValues = {private [ '_index' ];params[ '_path', [ '_apply', true ] ];{_cfg = _x; if ( _apply ) then {	_index = _ctrl lbAdd getText( _cfg >> 'text' ); _ctrl lbSetData [ _index, getText( _cfg >> 'data' ) ];} else {_index = _foreachindex;}; if ( !( _value isEqualType '' ) ) then {if ( _index isEqualTo _value ) then {_ctrl lbSetCurSel _index;} ;} else {if ( _value == getText( _cfg >> 'data' ) ) then {_ctrl lbSetCurSel _index;};}; } forEach configProperties [_path,'isclass _x'];}; if ( isClass _staticItemsCfg ) then {[ _staticItemsCfg, false ] call _fnc_setValues;};";
			attributeSave =	"_ctrl = _this controlsGroupCtrl 100;_ctrl lbData lbCurSel _ctrl;";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{
					idc = 100;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = SIZE_M * GRID_H;
					class Items
					{
						class LT_Load_Empty 	{data = "Empty";			text = "Empty"; default = 1;};
						class LT_Load_Cr_Small 	{data = "Crate Small";		text = "Small Ammocrate";};
						class LT_Load_Cr_Medium	{data = "Crate Medium";		text = "Medium Ammocrate";};
						class LT_Load_Cr_Large	{data = "Crate Large";		text = "Large Ammocrate";};
						class LT_Load_Cr_Explo	{data = "Crate Explosives";	text = "Explosives Crate";};
						class LT_Load_Cr_Medic	{data = "Crate Medical";	text = "Medical Crate";};
						class LT_Load_Cr_Weapon	{data = "Crate Weapons";	text = "Weapons Crate";};
						class LT_Load_Cr_NVG	{data = "Crate NVG";		text = "NVG Crate";};
						class LT_Load_Cr_Comms 	{data = "Crate Comms";		text = "Communication Crate";};
						class LT_Load_Cr_Air	{data = "Crate Air";		text = "Aircrew Ammocrate";};
					};
				};
			};
		};
	};
};
