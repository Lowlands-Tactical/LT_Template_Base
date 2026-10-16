// Addon controls inherit engine classes; no mission UI definitions are needed.
class RscText;
class RscTextMulti;
class RscListbox;
class RscButton;
class LTR_Text: RscText
{
    font = "RobotoCondensed";
    sizeEx = "0.018 * safeZoneH";
    shadow = 0;
    colorText[] = {0.94,0.94,0.94,1};
    colorBackground[] = {0,0,0,0};
};
class LTR_Message: RscTextMulti
{
    font = "RobotoCondensed";
    sizeEx = "0.018 * safeZoneH";
    shadow = 0;
    colorText[] = {0.63,0.65,0.62,1};
    colorBackground[] = {0,0,0,0};
};
class LTR_List: RscListbox
{
    font = "RobotoCondensed";
    sizeEx = "0.018 * safeZoneH";
    shadow = 0;
    colorBackground[] = {0.15,0.16,0.17,1};
    colorText[] = {0.94,0.94,0.94,1};
    colorSelect[] = {1,0.7294118,0.1490196,1};
    colorSelect2[] = {1,0.7294118,0.1490196,1};
    colorSelectBackground[] = {0.28,0.30,0.32,1};
    colorSelectBackground2[] = {0.28,0.30,0.32,1};
};
class LTR_Button: RscButton
{
    font = "RobotoCondensed";
    sizeEx = "0.018 * safeZoneH";
    shadow = 0;
    borderSize = 0;
    colorText[] = {0.94,0.94,0.94,1};
    colorDisabled[] = {0.63,0.65,0.62,1};
    colorBackground[] = {0.14,0.15,0.16,1};
    colorBackgroundDisabled[] = {0.14,0.15,0.16,1};
    colorBackgroundActive[] = {0.28,0.30,0.32,1};
    colorFocused[] = {0.28,0.30,0.32,1};
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
};
