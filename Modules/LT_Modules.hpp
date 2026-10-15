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