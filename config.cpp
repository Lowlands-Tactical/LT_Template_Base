#include "script_mod.hpp"

class cfgPatches
{
	class lt_template_base
	{
		name="Lowtac - Template";
		author=LT_AUTHOR;
		authors[]={LT_AUTHORS};
		url="http://lowtac.nl/";
		requiredVersion=LT_REQVR;
		requiredAddons[]=
		{
			"A3_Characters_F_BLUFOR",
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

class cfgAddons
{
    class PreloadAddons
    {
        class NAF
        {
            list[]=
            {
                "lt_template_base",
                "lt_template_gear"
            };
        };
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

class CfgFunctions
{
	class LT
	{
		class template_base
		{
			file="\lt_template_base\functions";
			class adminZeusModule {};
			class deleteUnits {};
			class safeStartLoop {};
			class safety {};
			class setFog {};
			class setTime {};
			class setWeather {};
			class teleportGroup {};
		};
		class Resupply
		{
			file="\lt_template_base\functions\Resupply";
			class resupplyRequest {};
			class resupplyDrop {};
		};
		class Modules
        {
            file="\lt_template_base\Modules\functions";
            class CustomCompSpawner {};
            class Intel {};
            class Resupply {};
            class Defense {};
            class UnitSpawner {};
        };
		class Convoy
		{
			file="\lt_template_base\Modules\functions\Convoy";
			class initConvoy {};
		};
	};
	class FRED
	{
		class VehicleRespawn 
		{
			file="\lt_template_base\functions\VehicleRespawn";
			class vehicleLoadout {};
			class vehicleMonitor {};
			class vehicleRespawn {};
		};
	};
};
// Defines the functions that can we remote executed and for whom.
class cfgRemoteExec
{
    class Functions
    {
        // 0= all machines 1= only clients 2= only server
        mode=2;
        jip=1;
		class LT_fnc_safety				{allowedTargets=0;};
		class LT_fnc_safeStartLoop		{allowedTargets=0;};
		class LT_fnc_adminZeusModule	{allowedTargets=2;};
		class LT_fnv_initConvoy			{allowedTargets=2;};
		class LT_fnc_ResupplyRequest	{allowedTargets=2;};
		class LT_fnc_deleteUnits		{allowedTargets=2;};
    };
};

#include "cfg3DEN.hpp"

// Extended Eventhandlers
/*Game start
│
├─ PreStart
│
Mission loading
│
├─ PreInit
│
├─ Object Init
│   (Extended_Init_EventHandlers)
│
├─ init.sqf
│
├─ PostInit
│
└─ InitPost	*/

class Extended_PreInit_EventHandlers
{
	class LT_Template_Base_Pre
	{
		serverinit="call compile preprocessFileLineNumbers '\lt_template_base\XEH_PreInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class LT_Template_Base_Post
	{
		serverinit="call compile preprocessFileLineNumbers '\lt_template_base\XEH_PostInit.sqf'";
	};
};

#include "Tablet\LT_Tablet_Base.hpp"
#include "Modules\LT_modules.hpp"
#include "Faces\LT_Faces.hpp"

// Main menu 'join server' option
class cfgMainMenuSpotlight
{
	class JoinServer
	{
		text = """Lowtac Server""";
		picture = "LT_Template_Base\logos\lowtac-server-banner.paa";
		action = "connectToServer ['arma3.lowtac.nl', 2302, 'TacLow']";
		actionText = "Join the Lowtac Server";
		condition = "true";
	};
};

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
