#include "script_version.hpp"

class cfgPatches
{
	class lt_template_base
	{
		name="lt_template_base";
		author="Lowlands Tactical";
		url="http://lowtac.nl/";
		requiredVersion=2.14;
		requiredAddons[]=
		{
			"A3_Characters_F_BLUFOR",
			"A3_Modules_F",
			"cba_main",
			"ace_main",
			"acre_main"
		};
		units[]={};
		weapons[]={};
		
		//CBA versioning
		version = VERSION;
		versionStr = STR(VERSION_STR);
		versionAR[] = {VERSION_AR};
	};
};

class CfgSettings 
{
	class CBA 
	{
		class Versioning 
		{
			class LT_Base
			{
				main_addon = "LT_Template_Base";
				class Dependancies 
				{
					LT_Base[] = {"LT_Template_Base", {VERSION_AR}, "true"};
				};
			};
		};
	};
};

#include "cfgFunctions.hpp"
#include "cfg3DEN.hpp"
#include "cfgVehicles.hpp"

// Our added notifications for the safestart function
class cfgNotifications
{
	class Alert
	{
		title = "ALERT";
		description = "%1";
		iconPicture = "\A3\ui_f\data\map\markers\military\warning_ca.paa";
		duration = 3;
		priority = 9;
	};
	class SafeStart
	{
		title = "SAFE START";
		description = "%1";
		iconPicture = "\A3\UI_F\data\IGUI\Cfg\Actions\settimer_ca.paa";
		duration = 10;
		priority = 0;
	};
	class SafeStartMissionStarting
	{
		title = "SAFE START";
		description = "%1";
		iconPicture = "\A3\UI_F\data\IGUI\Cfg\Actions\settimer_ca.paa";
		duration = 3;
		priority = 1;
	};
};

// Root folder for our own modules
class cfgFactionClasses
{
	class NO_CATEGORY;
	class LT_missionModules : NO_CATEGORY
	{
		displayName = "Lowlands Tactical Modules";
	};
};

// Pre/PostInit is loaded before the mission is loaded.
class Extended_PreInit_Eventhandlers
{
	class LT_menuPreInit
	{
		init = "call compile preprocessFileLineNumbers '\lt_template_base\XEH_PreInit.sqf'";
	};
};
class Extended_PostInit_Eventhandlers
{
	class LT_menuPostInit
	{
		init = "call compile preprocessFileLineNumbers '\lt_template_base\XEH_PostInit.sqf'";
	};
};

#include "Reference\Base_Define.hpp"

// Default mission debriefings
class cfgDebriefing
{
	class End1
	{
		title = "Missie geslaagd!";
		subtitle = "Goed werk!";
		description = "De tegenstander zal nu wel 2 keer nadenken voordat ze met ons sollen!";
	};
	class End2
	{
		title = "Goed begin is het halve werk..";
		subtitle = ".. Beetje jammer dat het maar de helft is!";
		description = "Volgende keer gaan we wel alle doelstellingen halen?";
	};
	class End3
	{
		title = "Missie gefaald";
		subtitle = "Jammer joh";
		description = "Terug naar Kamp Holland";
	};
	class End4
	{
		title = "BLUFOR wins!";
		subtitle = "Good job being total badasses BLUFOR!";
		description = "You can laugh at everyone else now.";
	};
	class End5
	{
		title = "REDFOR wins!";
		subtitle = "Good job being total badasses REDFOR!";
		description = "You can laugh at everyone else now.";
	};
	class End6
	{
		title = "GREENFOR wins!";
		subtitle = "Good job being total badasses GREENFOR!";
		description = "You can laugh at everyone else now.";
	};
};
