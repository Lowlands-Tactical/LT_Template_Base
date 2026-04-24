/*#include "\lt_template_base\script_mod.hpp"

class cfgPatches
{
	class lt_template_base_tablet
	{
		name="Lowtac - Tablet";
		author=LT_AUTHOR;
		authors[]={LT_AUTHORS};
		url="http://lowtac.nl/";
		requiredVersion=LT_REQVR;
		requiredAddons[]=
		{
			"lt_template_base"
		};
		units[]={};
		weapons[]={};

		//CBA versioning
		version = VERSION;
		versionStr = STR(VERSION_STR);
		versionAR[] = {VERSION_AR};
	};
};*/

// Defines all the base styles of the dialog
class BB_tablet
{
	type = 82;
	idc = 5000;
	model = "\A3\Props_F_Exp_A\Military\Equipment\Tablet_02_F.p3d";
	scale = 0.8;
	direction[] = {0,-1,0};
	up[] = {0,1,-1};
	x = 0.5;
	y = 0.46;
	z = 0.2;
	xBack = 0.5;
	yBack = 0.5;
	zBack = 1.2;
	inBack = 0;
	enableZoom = 1;
	zoomDuration = 0.001;
};
class BB_PictureBase
{
	deletable = 0;
	fade = 0;
	access = 0;
	type = CT_STATIC;
	idc = -1;
	style = ST_PICTURE;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "RobotoCondensed";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0.08;
	y = 0.08;
	w = 0.2;
	h = 0.2;
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
};
class BB_TextBase
{
	deletable = 0;
	fade = 0;
	access = 0;
	type = CT_STATIC;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.04;
	w = 0.3;
	style = ST_LEFT;
	shadow = 1;
	colorShadow[] = {0,0,0,0.5};
	font = "RobotoCondensed";
	SizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	linespacing = 1;
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
};
class BB_ButtonBase
{
	type = 16;
	idc = -1;
	x = -0.22;
	y = -0.05;
	w = 0.09;
	h = 0.04;
	style = 0;
	text = "";
	tooltip = "";
	animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureDisabled = "#(argb,8,8,3)color(0.2,0.2,0.2,1)";
	animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
	animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
	color[] = {1,1,1,1};
	color2[] = {1,1,1,1};
	colorBackground[] = {0.302,0.302,0.302,1};
	colorBackground2[] = {0.4,0.4,0.4,1};
	colorBackgroundFocused[] = {0.4,0.4,0.4,1};
	colorDisabled[] = {0.2,0.2,0.2,1};
	colorFocused[] = {1,1,1,1};
	font = "RobotoCondensed";
	size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1.0};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1.0};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1.0};
	soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1.0};
	textureNoShortcut = "";
	onButtonClick = "";
	class HitZone
	{
		top = 0;
		right = 0;
		bottom = 0;
		left = 0;
	};
	class ShortcutPos
	{
		top = 0;
		left = 0;
		w = 0;
		h = 0;
	};
	class TextPos
	{
		top = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2;
		right = 0.005;
		bottom = 0;
		left = 0.25 * (((safezoneW / safezoneH) min 1.2) / 40);
	};
};
class BB_ButtonBase1
{
	type = 1;
	idc = -1;
	x = -0.22;
	y = 0.31;
	w = 0.21;
	h = 0.06;
	style = 0;
	text = "";
	borderSize = 0.01;
	colorBackground[] = {0.302,0.302,0.302,1};
	colorBackgroundActive[] = {0.4,0.4,0.4,1};
	colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
	colorBorder[] = {0.502,0.502,0.502,1};
	colorDisabled[] = {0.2,0.2,0.2,1};
	colorFocused[] = {0.2,0.2,0.2,1};
	colorShadow[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	font = "RobotoCondensed";
	offsetPressedX = 0.01;
	offsetPressedY = 0.01;
	offsetX = 0.01;
	offsetY = 0.01;
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
	
};
class BB_ListBase
{
	type = 5;
	idc = -1;
	x = -0.21999971;
	y = 0.05000009;
	w = 0.20000003;
	h = 0.24000015;
	style = 16;
	colorBackground[] = {0.4,0.4,0.4,1};
	colorDisabled[] = {0.2,0.2,0.2,1};
	colorSelect[] = {0.9,0.9,0.9,1};
	colorText[] = {0.2,0.2,0.2,1};
	font = "RobotoCondensed";
	maxHistoryDelay = 0;
	rowHeight = 0;
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
	class ListScrollBar
	{
		color[] = {1,1,1,1};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};
class BB_ComboBase
{
	type = 4;
	idc = -1;
	x = -0.22;
	y = 0.00;
	w = 0.21;
	h = 0.03;
	style = 16;
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_active_ca.paa";
	colorBackground[] = {0.502,0.502,0.502,1};
	colorDisabled[] = {0.2,0.2,0.2,1};
	colorSelect[] = {1,0,0,1};
	colorSelectBackground[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	font = "RobotoCondensed";
	maxHistoryDelay = 0;
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1.0};
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1.0};
	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1.0};
	wholeHeight = 0.3;
	tooltip = "";
	class ComboScrollBar
	{
		color[] = {1,1,1,1};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};

#include "LT_Tablet.hpp"
#include "LT_Tablet_Advanced.hpp"
#include "LT_Tablet_Crew.hpp"