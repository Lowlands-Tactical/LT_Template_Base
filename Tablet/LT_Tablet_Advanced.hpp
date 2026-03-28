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
			onButtonClick = "'Arsenal' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 604;
			x = 0.34;
			w = 0.20;
			text = "Open Debug console";
			tooltip = "Open Debug console";
			onButtonClick = "'Debug' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd1 : BB_ButtonBase1
		{
			idc = 610;
			x = 0.08;
			y = 0.27;
			text = "Missie geslaagd!";
			onButtonClick = "'End1' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd2 : BB_ButtonEnd1
		{
			idc = 611;
			y = 0.34;
			text = "Missie partial win";
			onButtonClick = "'End2' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonEnd3 : BB_ButtonEnd2
		{
			idc = 612;
			y = 0.41;
			text = "Missie gefaald";
			onButtonClick = "'End3' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnCrate : BB_ButtonEnd3
		{
			idc = 613;
			y = 0.48;
			text = "Spawn Crate";
			onButtonClick = "'CreateCrate' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnMed : BB_ButtonSpwnCrate
		{
			idc = 614;
			y = 0.55;
			text = "Spawn Medic pack";
			onButtonClick = "'MedicPack' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSpwnJTAC : BB_ButtonSpwnMed
		{
			idc = 615;
			y = 0.62;
			text = "Spawn JTAC pack";
			onButtonClick = "'JTACPack' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonReturn : BB_ButtonSpwnJTAC
		{
			idc = 616;
			y = 0.69;
			text = "Return";
			tooltip = "";
			onButtonClick = "'Switch' execVM '\lt_template_base\Tablet\Buttons.sqf'";
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
			onButtonClick = "'Loadout' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonAddRemoveDebug : BB_ButtonBase1
		{
			idc = 623;
			x = 0.34;
			y = 0.27;
			text = "Add/Remove Debug";
			tooltip = "Add or Remove Debug Triggers and Briefing";
			onButtonClick = "'DebugBriefing' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonBriefing : BB_ButtonAddRemoveDebug
		{
			idc = 624;
			y = 0.34;
			text = "Readd Admin Briefing";
			tooltip = "Add admin briefing";
			onButtonClick = "'Briefing' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonZeusMod : BB_ButtonBriefing
		{
			idc = 625;
			y = 0.41;
			text = "Readd Zeus Modules";
			tooltip = "Adds zeus module to staff again";
			onButtonClick = "'ZeusModule' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrep : BB_ButtonZeusMod
		{
			idc = 626;
			y = 0.48;
			text = "Prep AllPlayerloadout";
			tooltip = "Reruns preploadout for all players";
			onButtonClick = "'PrepAllPlayers' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepAll : BB_ButtonPrep
		{
			idc = 627;
			y = 0.55;
			text = "Prep Vehicleloadout";
			tooltip = "Reruns preploadout for everything vehicles and boxes";
			onButtonClick = "'PrepVehicle' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonDropReset : BB_ButtonPrepAll
		{
			idc = 628;
			y = 0.62;
			text = "Reset Supplydrop";
			tooltip = "Reset Supplydrop value in case of unexpected error";
			onButtonClick = "'DropReset' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_RemoveLVDWFlag : BB_ButtonDropReset
		{
			idc = 629;
			y = 0.69;
			text = "Remove LVDW Vlag";
			tooltip = "Remove the flag from slot LVDW";
			onButtonClick = "'lvdwFlag' execVM '\lt_template_base\Tablet\Buttons.sqf'";
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
			y = 0.71;
			w = 0.32;
		};
		class BB_ComboRole : BB_ComboBase 
		{
			idc = 631;
			x = 0.61;
			y = 0.75;
			w = 0.08;
			tooltip = "Select role to load";
		};
		class BB_ComboLink : BB_ComboRole 
		{
			idc = 632;
			x = 0.69;
			w = 0.12;
			tooltip = "Select nav yes/no";
		};
		class BB_ComboItem : BB_ComboLink 
		{
			idc = 633;
			x = 0.81;
			tooltip = "Select item yes/no";
		};
		class BB_ComboWeapon : BB_ComboLink 
		{
			idc = 634;
			x = 0.69;
			y = 0.79;
			tooltip = "Select weapon yes/no";
		};
		class BB_ComboGear : BB_ComboWeapon 
		{
			idc = 635;
			x = 0.81;
			tooltip = "Select gear yes/no";
		};
		class BB_ButtonSetValues : BB_ButtonCloseEnd
		{
			idc = 636;
			x = 0.61;
			w = 0.16;
			text = "Set Values";
			tooltip = "Set values from above to selected unit";
			onButtonClick = "'SetValues' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonPrepPlayer : BB_ButtonSetValues
		{
			idc = 637;
			x = 0.77;
			text = "Reset Loadout";
			tooltip = "Rerun prepLoadout for selected unit";
			onButtonClick = "'PrepPlayer' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
	};
};