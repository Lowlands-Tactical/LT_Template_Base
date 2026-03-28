/*#include "\lt_template_base\script_mod.hpp"

class cfgPatches
{
	class lt_template_base_modules
	{
		name="Lowtac - Modules";
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
};

class CfgFunctions
{
	class LT
	{
        class Modules
        {
            file="\lt_template_base\modules\functions";
            class CustomCompSpawner {};
            class Intel {};
            class Resupply {};
            class Defense {};
            class UnitSpawner {};
        };
		class Convoy
		{
			file="\lt_template_base\modules\functions\Convoy";
			class initConvoy {};
		};
	};
};*/

class cfgFactionClasses
{
	class NO_CATEGORY;
	class LT_missionModules : NO_CATEGORY
	{
		displayName = "Lowlands Tactical Modules";
	};
};

class CfgVehicles 
{
	class Logic;
	class Module_F: Logic
	{
		class ArgumentsBaseUnits 
		{
			class Units;
		};
		class AttributesBase
		{
			class Default;
			class Edit;
			class Combo;
			class Checkbox;
			class CheckboxNumber;
			class Toolbox;
			class ModuleDescription;
			class Units;
		};
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	
	#include "CustomCompSpawner.hpp"
	#include "Intel.hpp"
	#include "Resupply.hpp"
	#include "Defense.hpp"
	#include "UnitSpawner.hpp"
	#include "Convoy.hpp"
};