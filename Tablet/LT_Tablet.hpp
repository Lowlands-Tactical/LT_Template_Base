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
			onButtonClick = "'Arsenal' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonDebug : BB_ButtonArsenal
		{
			idc = 504;
			x = 0.34;
			w = 0.20;
			text = "Open Debug console";
			tooltip = "Open Debug console";
			onButtonClick = "'Debug' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonHeal : BB_ButtonDebug
		{
			idc = 505;
			x = 0.610;
			w = 0.08;
			text = "Heal";
			tooltip = "Heal player selected above";
			onButtonClick = "'Heal' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoMe : BB_ButtonHeal
		{
			idc = 506;
			x = 0.690;
			w = 0.12;
			text = "TP to Me";
			tooltip = "Teleport player selected above to you";
			onButtonClick = "'TPtoMe' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTPtoTarget : BB_ButtonTPtoMe
		{
			idc = 507;
			x = 0.810;
			text = "TP to Target";
			tooltip = "Teleport to player selected above";
			onButtonClick = "'TPtoTarget' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOff : BB_ButtonBase1
		{
			idc = 510;
			x = 0.08;
			y = 0.27;
			text = "Disable Safety";
			onButtonClick = "'SafetyOff' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonSafetyOn : BB_ButtonSafetyOff
		{
			idc = 511;
			text = "Enable Safety";
			onButtonClick = "'SafetyOn' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOff : BB_ButtonSafetyOn
		{
			idc = 512;
			y = 0.34;
			text = "Disable Fatigue";
			onButtonClick = "'FatigueOff' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonFatigueOn : BB_ButtonFatigueOff
		{
			idc = 513;
			text = "Enable Fatigue";
			onButtonClick = "'FatigueOn' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonHidePlayer : BB_ButtonFatigueOn
		{
			idc = 514;
			y = 0.41;
			text = "Hide Player";
			onButtonClick = "'Hide' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonUnhidePlayer : BB_ButtonHidePlayer
		{
			idc = 515;
			text = "Unhide Player";
			onButtonClick = "'Unhide' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTpOn : BB_ButtonHidePlayer
		{
			idc = 516;
			y = 0.48;
			text = "Group Teleport On";
			onButtonClick = "'GpTpOn' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonTpOff : BB_ButtonTpOn
		{
			idc = 517;
			text = "Group Teleport Off";
			onButtonClick = "'GpTpOff' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonZeus : BB_ButtonTpOn
		{
			idc = 518;
			y = 0.55;
			text = "Open Zeus";
			onButtonClick = "'Zeus' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonMarkUnits : BB_ButtonZeus
		{
			idc = 519;
			y = 0.62;
			text = "Mark Units";
			onButtonClick = "'MarkUnits' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonAdv : BB_ButtonMarkUnits
		{
			idc = 520;
			y = 0.69;
			text = "Advanced";
			onButtonClick = "'Switch' execVM '\lt_template_base\Tablet\Buttons.sqf'";
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
			onButtonClick = "'Drop' execVM '\lt_template_base\Tablet\Buttons.sqf'";
		};
		class BB_ButtonDroping : BB_ButtonDrop
		{
			idc = 539;
			text = "No Supplydrop";
			tooltip = "SupplyDrop in progress";
			onButtonClick = "'Droping' execVM '\lt_template_base\Tablet\Buttons.sqf'";
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