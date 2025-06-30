//Include base defines
#include "..\Reference\Base_Defines.hpp"

//Build up of the dialog with every button/list/etc.
class BB_LT_Tablet 
{
	idd = 500;
	name = "BB_Dialog v1.0";
	movingEnable = true;
	enableSimulation = true;
	onLoad = "";
	class Objects 
	{
		class BB_tabletBB : BB_tablet
		{
			idc = 599;
			moving = 1;
			onLoad = "(_this # 0) ctrlEnable false;";
		};
	};
	class controls 
	{
		class BB_Logo : BB_PictureBase
		{
			idc = 501;
			x = 0.06;
			y = 0.00;
			w = 0.24;
			h = 0.24;
			text = "\lt_template_base\logos\lowtac.paa";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class BB_ButtonClose : BB_ButtonBase
		{
			idc = 502;
			x = 0.07;
			y = 0.83;
			w = 0.11;
			h = 0.04;
			text = "Close";
			tooltip = "";
			onButtonClick = "closeDialog 0;";
		};
		class BB_ButtonArsenal : BB_ButtonClose
		{
			idc = 503;
			x = 0.18;
			text = "Arsenal";
			tooltip = "Open Arsenal";
			onButtonClick = "'Arsenal' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 504;
			x = 0.34;
			w = 0.20;
			text = "Open Debug console";
			tooltip = "Open Debug console";
			onButtonClick = "'Debug' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonHeal : BB_ButtonDebug
		{
			idc = 505;
			x = 0.610;
			w = 0.08;
			text = "Heal";
			tooltip = "Heal player selected above";
			onButtonClick = "'Heal' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoMe : BB_ButtonHeal
		{
			idc = 506;
			x = 0.690;
			w = 0.12;
			text = "TP to Me";
			tooltip = "Teleport player selected above to you";
			onButtonClick = "'TPtoMe' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoTarget : BB_ButtonTPtoMe
		{
			idc = 507;
			x = 0.810;
			text = "TP to Target";
			tooltip = "Teleport to player selected above";
			onButtonClick = "'TPtoTarget' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOff : BB_ButtonBase1
		{
			idc = 510;
			x = 0.08;
			y = 0.27;
			text = "Disable Safety";
			onButtonClick = "'SafetyOff' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOn : BB_ButtonSafetyOff
		{
			idc = 511;
			text = "Enable Safety";
			onButtonClick = "'SafetyOn' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOff : BB_ButtonSafetyOn
		{
			idc = 512;
			y = 0.34;
			text = "Disable Fatigue";
			onButtonClick = "'FatigueOff' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOn : BB_ButtonFatigueOff
		{
			idc = 513;
			text = "Enable Fatigue";
			onButtonClick = "'FatigueOn' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonHidePlayer : BB_ButtonFatigueOn
		{
			idc = 514;
			y = 0.41;
			text = "Hide Player";
			onButtonClick = "'Hide' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonUnhidePlayer : BB_ButtonHidePlayer
		{
			idc = 515;
			text = "Unhide Player";
			onButtonClick = "'Unhide' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTpOn : BB_ButtonHidePlayer
		{
			idc = 516;
			y = 0.48;
			text = "Group Teleport On";
			onButtonClick = "'GpTpOn' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTpOff : BB_ButtonTpOn
		{
			idc = 517;
			text = "Group Teleport Off";
			onButtonClick = "'GpTpOff' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonZeus : BB_ButtonTpOn
		{
			idc = 518;
			y = 0.55;
			text = "Open Zeus";
			onButtonClick = "'Zeus' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonMarkUnits : BB_ButtonZeus
		{
			idc = 519;
			y = 0.62;
			text = "Mark Units";
			onButtonClick = "'MarkUnits' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonAdv : BB_ButtonMarkUnits
		{
			idc = 520;
			y = 0.69;
			text = "Advanced";
			onButtonClick = "'Switch' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ComboTypeVeh : BB_ComboBase 
		{
			idc = 531;
			x = 0.34;
			y = 0.07;
			tooltip = "Dropdown select vehicle type";
		};
		class BB_vehPic : BB_PictureBase
		{
			idc = 532;
			x = 0.345;
			y = 0.10;
			w = 0.20;
			h = 0.20;
			text = "";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class BB_ComboTypeCrate : BB_ComboTypeVeh
		{
			idc = 533;
			y = 0.32;
			tooltip = "Dropdown select crate type";
		};
		class BB_cratePic : BB_vehPic
		{
			idc = 534;
			y = 0.35;
		};
		class BB_ComboTypeLoadout_1 : BB_ComboTypeCrate
		{
			idc = 535;
			y = 0.57;
			tooltip = "Dropdown select loadout";
		};
		class BB_ComboTypeLoadout_2 : BB_ComboTypeLoadout_1
		{
			idc = 536;
			y = 0.61;
			tooltip = "Dropdown select loadout (Optional)";
		};
		class BB_ComboTypeLoadout_3 : BB_ComboTypeLoadout_2
		{
			idc = 537;
			y = 0.65;
		};
		class BB_ButtonDrop : BB_ButtonBase1
		{
			idc = 538;
			x = 0.34;
			y = 0.69;
			text = "Supplydrop";
			tooltip = "Go to map and select airdrop point";
			onButtonClick = "'Drop' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonDroping : BB_ButtonDrop
		{
			idc = 539;
			text = "No Supplydrop";
			tooltip = "SupplyDrop in progress";
			onButtonClick = "'Droping' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ListUnits : BB_ListBase
		{
			idc = 550;
			x = 0.610;
			y = 0.01;
			w = 0.32;
			h = 0.75;
		};
	};
};

class BB_LT_Tablet_Advanced 
{
	idd = 600;
	name = "BB_Dialog v1.0";
	movingEnable = true;
	enableSimulation = true;
	onLoad = "";
	class Objects 
	{
		class BB_tabletBB : BB_tablet
		{
			idc = 699;
			moving = 1;
			onLoad = "(_this # 0) ctrlEnable false;";
		};
	};
	class controls 
	{
		class BB_Logo : BB_PictureBase
		{
			idc = 601;
			x = 0.06;
			y = 0.00;
			w = 0.24;
			h = 0.24;
			text = "\lt_template_base\logos\lowtac.paa";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class BB_ButtonCloseEnd : BB_ButtonBase
		{
			idc = 602;
			x = 0.07;
			y = 0.83;
			w = 0.11;
			h = 0.04;
			text = "Close";
			tooltip = "";
			onButtonClick = "closeDialog 0;";
		};
		class BB_ButtonArsenal : BB_ButtonCloseEnd
		{
			idc = 603;
			x = 0.18;
			text = "Arsenal";
			tooltip = "Open Arsenal";
			onButtonClick = "'Arsenal' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 604;
			x = 0.34;
			w = 0.20;
			text = "Open Debug console";
			tooltip = "Open Debug console";
			onButtonClick = "'Debug' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd1 : BB_ButtonBase1
		{
			idc = 610;
			x = 0.08;
			y = 0.27;
			text = "Missie geslaagd!";
			onButtonClick = "'End1' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd2 : BB_ButtonEnd1
		{
			idc = 611;
			y = 0.34;
			text = "Missie partial win";
			onButtonClick = "'End2' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd3 : BB_ButtonEnd2
		{
			idc = 612;
			y = 0.41;
			text = "Missie gefaald";
			onButtonClick = "'End3' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd4 : BB_ButtonEnd3
		{
			idc = 613;
			y = 0.48;
			text = "BLUEFOR Wins";
			onButtonClick = "'End4' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd5 : BB_ButtonEnd4
		{
			idc = 614;
			y = 0.55;
			text = "REDFOR Wins";
			onButtonClick = "'End5' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd6 : BB_ButtonEnd5
		{
			idc = 615;
			y = 0.62;
			text = "GREENFOR Wins";
			onButtonClick = "'End6' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonReturn : BB_ButtonEnd6
		{
			idc = 616;
			y = 0.69;
			text = "Return";
			tooltip = "";
			onButtonClick = "'Switch' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_TextCrate : BB_TextBase 
		{
			idc = 619;
			x = 0.34;
			y = 0.05;
			w = 0.21;
			h = 0.04;
		};
		class BB_ComboSide : BB_ComboBase 
		{
			idc = 620;
			x = 0.34;
			y = 0.10;
			w = 0.21;
			h = 0.04;
			tooltip = "Select side to load";
		};
		class BB_ComboCrate : BB_ComboSide 
		{
			idc = 621;
			y = 0.15;
			tooltip = "Select loadout to load";
		};
		class BB_ButtonCrate : BB_ButtonBase
		{
			idc = 622;
			x = 0.34;
			y = 0.20;
			w = 0.21;
			text = "Load Object";
			tooltip = "Load Object selected above";
			onButtonClick = "'Loadout' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonAddRemoveDebug : BB_ButtonBase1
		{
			idc = 623;
			x = 0.34;
			y = 0.27;
			text = "Add/Remove Debug";
			tooltip = "Add or Remove Debug Triggers and Briefing";
			onButtonClick = "'DebugBriefing' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonBriefing : BB_ButtonAddRemoveDebug
		{
			idc = 624;
			y = 0.34;
			text = "Readd Admin Briefing";
			tooltip = "Add admin briefing";
			onButtonClick = "'Briefing' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonZeusMod : BB_ButtonBriefing
		{
			idc = 625;
			y = 0.41;
			text = "Readd Zeus Modules";
			tooltip = "Adds zeus module to staff again";
			onButtonClick = "'ZeusModule' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrep : BB_ButtonZeusMod
		{
			idc = 626;
			y = 0.48;
			text = "Prep AllPlayerloadout";
			tooltip = "Reruns preploadout for all players";
			onButtonClick = "'PrepAllPlayers' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepAll : BB_ButtonPrep
		{
			idc = 627;
			y = 0.55;
			text = "Prep Vehicleloadout";
			tooltip = "Reruns preploadout for everything vehicles and boxes";
			onButtonClick = "'PrepVehicle' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonDropReset : BB_ButtonPrepAll
		{
			idc = 628;
			y = 0.62;
			text = "Reset Supplydrop";
			tooltip = "Reset Supplydrop value in case of unexpected error";
			onButtonClick = "'DropReset' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEmpty01 : BB_ButtonDropReset
		{
			idc = 629;
			y = 0.69;
			text = "Empty";
			tooltip = "";
			onButtonClick = "";
		};
		class BB_ListAdvUnits : BB_ListBase
		{
			idc = 650;
			x = 0.610;
			y = 0.01;
			w = 0.32;
			h = 0.70;
		};
		class BB_TextPlayer : BB_TextBase 
		{
			idc = 630;
			x = 0.61;
			y = 0.72;
			w = 0.32;
		};
		class BB_ComboRole : BB_ComboBase 
		{
			idc = 631;
			x = 0.61;
			y = 0.77;
			w = 0.08;
			tooltip = "Select role to load";
		};
		class BB_ComboGear : BB_ComboRole 
		{
			idc = 632;
			x = 0.69;
			w = 0.12;
			tooltip = "Select gear yes/no";
		};
		class BB_ComboItem : BB_ComboGear 
		{
			idc = 633;
			x = 0.81;
			tooltip = "Select item yes/no";
		};
		class BB_ButtonSetValues : BB_ButtonCloseEnd
		{
			idc = 634;
			x = 0.61;
			w = 0.16;
			text = "Set Values";
			tooltip = "Set values from above to selected unit";
			onButtonClick = "'SetValues' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepPlayer : BB_ButtonSetValues
		{
			idc = 635;
			x = 0.77;
			text = "Reset Loadout";
			tooltip = "Rerun prepLoadout for selected unit";
			onButtonClick = "'PrepPlayer' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
	};
};

class BB_LT_Tablet_Crew 
{
	idd = 700;
	name = "BB_Dialog v1.0";
	movingEnable = true;
	enableSimulation = true;
	onLoad = "";
	class Objects 
	{
		class BB_tabletBB : BB_tablet
		{
			idc = 799;
			moving = 1;
			onLoad = "(_this # 0) ctrlEnable false;";
		};
	};
	class controls 
	{
		class BB_Logo : BB_PictureBase
		{
			idc = 701;
			x = 0.06;
			y = 0.00;
			w = 0.24;
			h = 0.24;
			text = "\lt_template_base\logos\lowtac.paa";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class BB_ButtonCloseEnd : BB_ButtonBase
		{
			idc = 702;
			x = 0.07;
			y = 0.83;
			w = 0.11;
			h = 0.04;
			text = "Close";
			tooltip = "";
			onButtonClick = "closeDialog 0;";
		};
		class BB_ButtonArsenal : BB_ButtonCloseEnd
		{
			idc = 703;
			x = 0.18;
			text = "Arsenal";
			tooltip = "Open Arsenal";
			onButtonClick = "'Arsenal' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 704;
			x = 0.34;
			w = 0.20;
			text = "Open Debug console";
			tooltip = "Open Debug console";
			onButtonClick = "'Debug' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonHeal : BB_ButtonDebug
		{
			idc = 705;
			x = 0.610;
			w = 0.08;
			text = "Heal";
			tooltip = "Heal player selected above";
			onButtonClick = "'HealCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoMe : BB_ButtonHeal
		{
			idc = 706;
			x = 0.690;
			w = 0.12;
			text = "TP to Me";
			tooltip = "Teleport player selected above to you";
			onButtonClick = "'TPtoMeCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoTarget : BB_ButtonTPtoMe
		{
			idc = 707;
			x = 0.810;
			text = "TP to Target";
			tooltip = "Teleport to player selected above";
			onButtonClick = "'TPtoTargetCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOff : BB_ButtonBase1
		{
			idc = 710;
			x = 0.08;
			y = 0.27;
			text = "Disable Safety";
			onButtonClick = "'SafetyOffCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOn : BB_ButtonSafetyOff
		{
			idc = 711;
			text = "Enable Safety";
			onButtonClick = "'SafetyOnCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOff : BB_ButtonSafetyOn
		{
			idc = 712;
			y = 0.34;
			text = "Group Teleport On";
			onButtonClick = "'GpTpOnCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOn : BB_ButtonFatigueOff
		{
			idc = 713;
			text = "Group Teleport Off";
			onButtonClick = "'GpTpOffCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEmpty02 : BB_ButtonFatigueOn
		{
			idc = 714;
			y = 0.41;
			text = "Spawn Crate";
			onButtonClick = "'CreateCrateCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEmpty03 : BB_ButtonEmpty02
		{
			idc = 715;
			y = 0.48;
			text = "Empty";
			onButtonClick = "";
		};
		class BB_ButtonEmpty04 : BB_ButtonEmpty03
		{
			idc = 716;
			y = 0.55;
			text = "Empty";
			onButtonClick = "";
		};
		class BB_ButtonEmpty05 : BB_ButtonEmpty04
		{
			idc = 717;
			y = 0.62;
			text = "Empty";
			onButtonClick = "";
		};
		class BB_ButtonEmpty06 : BB_ButtonEmpty05
		{
			idc = 718;
			y = 0.69;
			text = "Empty";
			onButtonClick = "";
		};
		class BB_TextCrateCrew : BB_TextBase 
		{
			idc = 721;
			x = 0.34;
			y = 0.05;
			w = 0.21;
			h = 0.04;
		};
		class BB_ComboSide : BB_ComboBase 
		{
			idc = 722;
			x = 0.34;
			y = 0.10;
			w = 0.21;
			h = 0.04;
			tooltip = "Select side to load";
		};
		class BB_ComboCrate : BB_ComboSide 
		{
			idc = 723;
			y = 0.15;
			tooltip = "Select loadout to load";
		};
		class BB_ButtonCrate : BB_ButtonBase
		{
			idc = 724;
			x = 0.34;
			y = 0.20;
			w = 0.21;
			text = "Load Object";
			tooltip = "Load Object selected above";
			onButtonClick = "'LoadoutCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd1 : BB_ButtonBase1
		{
			idc = 725;
			x = 0.34;
			y = 0.27;
			text = "Missie geslaagd!";
			onButtonClick = "'End1' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd2 : BB_ButtonEnd1
		{
			idc = 726;
			y = 0.34;
			text = "Missie partial win";
			onButtonClick = "'End2' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd3 : BB_ButtonEnd2
		{
			idc = 727;
			y = 0.41;
			text = "Missie gefaald";
			onButtonClick = "'End3' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd4 : BB_ButtonEnd3
		{
			idc = 728;
			y = 0.48;
			text = "BLUEFOR Wins";
			onButtonClick = "'End4' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd5 : BB_ButtonEnd4
		{
			idc = 729;
			y = 0.55;
			text = "REDFOR Wins";
			onButtonClick = "'End5' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd6 : BB_ButtonEnd5
		{
			idc = 730;
			y = 0.62;
			text = "GREENFOR Wins";
			onButtonClick = "'End6' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonEmpty07 : BB_ButtonEnd6
		{
			idc = 731;
			y = 0.69;
			text = "Empty";
			tooltip = "";
			onButtonClick = "";
		};
		class BB_ListCrewUnits : BB_ListBase
		{
			idc = 750;
			x = 0.610;
			y = 0.01;
			w = 0.32;
			h = 0.65;
		};
		class BB_TextPlayer : BB_TextBase 
		{
			idc = 751;
			x = 0.61;
			y = 0.67;
			w = 0.32;
		};
		class BB_ComboRole : BB_ComboBase 
		{
			idc = 752;
			x = 0.61;
			y = 0.72;
			w = 0.08;
			tooltip = "Select role to load";
		};
		class BB_ComboGear : BB_ComboRole 
		{
			idc = 753;
			x = 0.69;
			w = 0.12;
			tooltip = "Select gear yes/no";
		};
		class BB_ComboItem : BB_ComboGear 
		{
			idc = 754;
			x = 0.81;
			tooltip = "Select item yes/no";
		};
		class BB_ButtonSetValues : BB_ButtonCloseEnd
		{
			idc = 755;
			x = 0.61;
			y = 0.77;
			w = 0.16;
			text = "Set Values";
			tooltip = "Set values from above to selected unit";
			onButtonClick = "'SetValuesCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepPlayer : BB_ButtonSetValues
		{
			idc = 756;
			x = 0.77;
			text = "Reset Loadout";
			tooltip = "Rerun prepLoadout for selected unit";
			onButtonClick = "'PrepPlayerCrew' execVM '\lt_template_base\LT_Tablet\Buttons.sqf'";
		};
	};
};
