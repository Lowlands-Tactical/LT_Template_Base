/*

File: LT_RespawnGroup.hpp
Author: Lowlands Tactical

Description:
Dialog for "Deploy to group" (see LT_fnc_respawnGroupMenu).
Uses the base classes of the tablet (BB_TextBase, BB_ListBase, BB_ButtonBase1), so include this
file in config.cpp AFTER #include "Tablet\LT_Tablet_Base.hpp".
The list is a listnbox (type 102) with 4 columns: prefix (side colour), name, distance, note.

*/

class LT_RespawnGroup
{
	idd = 800;
	name = "LT_RespawnGroup";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "";
	class controlsBackground
	{
		class LT_RG_Background : BB_TextBase
		{
			x = 0.25;
			y = 0.12;
			w = 0.50;
			h = 0.76;
			colorBackground[] = {0.12,0.12,0.12,0.95};
		};
	};
	class controls
	{
		class LT_RG_Title : BB_TextBase
		{
			x = 0.11;
			y = 0.13;
			w = 0.78;
			h = 0.05;
			text = "Deploy to group";
			SizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.3);
		};
		class LT_RG_Info : BB_TextBase
		{
			idc = 804;
			x = 0.11;
			y = 0.18;
			w = 0.78;
			h = 0.08;
			style = 16;
			text = "";
		};
		class LT_RG_List : BB_ListBase
		{
			idc = 801;
			type = 102;
			x = 0.11;
			y = 0.27;
			w = 0.78;
			h = 0.52;
			columns[] = {0.0, 0.17, 0.47, 0.58};
			drawSideArrows = 0;
			idcLeft = -1;
			idcRight = -1;
			colorBackground[] = {0.07,0.07,0.07,1};
			colorSelectBackground[] = {0.25,0.25,0.25,1};
			colorSelectBackground2[] = {0.30,0.30,0.30,1};
			colorSelect2[] = {1,1,1,1};
			colorShadow[] = {0,0,0,0.5};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8);
			onLBDblClick = "['deploy'] call LT_fnc_respawnGroupMenu;";
		};
		class LT_RG_Deploy : BB_ButtonBase1
		{
			idc = 802;
			x = 0.11;
			y = 0.81;
			w = 0.38;
			h = 0.05;
			text = "Deploy";
			onButtonClick = "['deploy'] call LT_fnc_respawnGroupMenu;";
		};
		class LT_RG_Close : BB_ButtonBase1
		{
			idc = 803;
			x = 0.51;
			y = 0.81;
			w = 0.38;
			h = 0.05;
			text = "Close";
			onButtonClick = "closeDialog 0;";
		};
	};
};
