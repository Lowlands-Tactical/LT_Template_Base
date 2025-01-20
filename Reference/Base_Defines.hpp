// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_HITZONES         17
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_ITEMSLOT         103
#define CT_CHECKBOX         77

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0
#define ST_UPPERCASE      0xC0
#define ST_LOWERCASE      0xD0
#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800
#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400
#define SL_TEXTURES       0x10

// Progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4
#define MB_ERROR_DIALOG   8

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
