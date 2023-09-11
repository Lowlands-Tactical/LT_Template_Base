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
	
	#include "\lt_template_base\Modules\Intel.hpp"
	#include "\lt_template_base\Modules\Resupply.hpp"
	#include "\lt_template_base\Modules\Defense.hpp"
	#include "\lt_template_base\Modules\UnitSpawner.hpp"
};
