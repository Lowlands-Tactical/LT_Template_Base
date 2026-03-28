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
			onButtonClick = "'Arsenal' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 704;
			x = 0.34;
			w = 0.20;
			text = "Lege knop";
			tooltip = "Dit doet niks";
			onButtonClick = "";
		};
		class BB_ButtonHeal : BB_ButtonDebug
		{
			idc = 705;
			x = 0.610;
			w = 0.08;
			text = "Heal";
			tooltip = "Heal player selected above";
			onButtonClick = "'HealCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoMe : BB_ButtonHeal
		{
			idc = 706;
			x = 0.690;
			w = 0.12;
			text = "TP to Me";
			tooltip = "Teleport player selected above to you";
			onButtonClick = "'TPtoMeCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoTarget : BB_ButtonTPtoMe
		{
			idc = 707;
			x = 0.810;
			text = "TP to Target";
			tooltip = "Teleport to player selected above";
			onButtonClick = "'TPtoTargetCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOff : BB_ButtonBase1
		{
			idc = 710;
			x = 0.08;
			y = 0.27;
			text = "Disable Safety";
			onButtonClick = "'SafetyOffCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOn : BB_ButtonSafetyOff
		{
			idc = 711;
			text = "Enable Safety";
			onButtonClick = "'SafetyOnCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOff : BB_ButtonSafetyOn
		{
			idc = 712;
			y = 0.34;
			text = "Group Teleport On";
			onButtonClick = "'GpTpOnCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOn : BB_ButtonFatigueOff
		{
			idc = 713;
			text = "Group Teleport Off";
			onButtonClick = "'GpTpOffCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnCrate : BB_ButtonFatigueOn
		{
			idc = 714;
			y = 0.41;
			text = "Spawn Crate";
			onButtonClick = "'CreateCrate' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnMed : BB_ButtonSpwnCrate
		{
			idc = 715;
			y = 0.48;
			text = "Spawn Medic pack";
			onButtonClick = "'MedicPack' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnDrone : BB_ButtonSpwnMed
		{
			idc = 716;
			y = 0.55;
			text = "Spawn JTAC pack";
			onButtonClick = "'JTACPack' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEmpty05 : BB_ButtonSpwnDrone
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
			onButtonClick = "'LoadoutCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd1 : BB_ButtonBase1
		{
			idc = 725;
			x = 0.34;
			y = 0.27;
			text = "Missie geslaagd!";
			onButtonClick = "'End1' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd2 : BB_ButtonEnd1
		{
			idc = 726;
			y = 0.34;
			text = "Missie partial win";
			onButtonClick = "'End2' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd3 : BB_ButtonEnd2
		{
			idc = 727;
			y = 0.41;
			text = "Missie gefaald";
			onButtonClick = "'End3' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd4 : BB_ButtonEnd3
		{
			idc = 728;
			y = 0.48;
			text = "BLUEFOR Wins";
			onButtonClick = "'End4' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd5 : BB_ButtonEnd4
		{
			idc = 729;
			y = 0.55;
			text = "REDFOR Wins";
			onButtonClick = "'End5' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd6 : BB_ButtonEnd5
		{
			idc = 730;
			y = 0.62;
			text = "GREENFOR Wins";
			onButtonClick = "'End6' execVM '\lt_template_base\Tablet\Buttons.sqf'";
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
			y = 0.71;
			w = 0.08;
			tooltip = "Select role to load";
		};
		class BB_ComboLink : BB_ComboRole 
		{
			idc = 753;
			x = 0.69;
			w = 0.12;
			tooltip = "Select nav yes/no";
		};
		class BB_ComboItem : BB_ComboLink 
		{
			idc = 754;
			x = 0.81;
			tooltip = "Select item yes/no";
		};
		class BB_ComboWeapon : BB_ComboLink 
		{
			idc = 755;
			x = 0.69;
			y = 0.75;
			tooltip = "Select weapon yes/no";
		};
		class BB_ComboGear : BB_ComboWeapon 
		{
			idc = 756;
			x = 0.81;
			tooltip = "Select gear yes/no";
		};
		class BB_ButtonSetValues : BB_ButtonCloseEnd
		{
			idc = 757;
			x = 0.61;
			y = 0.78;
			w = 0.16;
			text = "Set Values";
			tooltip = "Set values from above to selected unit";
			onButtonClick = "'SetValuesCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepPlayer : BB_ButtonSetValues
		{
			idc = 758;
			x = 0.77;
			text = "Reset Loadout";
			tooltip = "Rerun prepLoadout for selected unit";
			onButtonClick = "'PrepPlayerCrew' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
	};
};