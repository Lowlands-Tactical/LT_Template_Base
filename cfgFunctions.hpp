// Functions for lt_template_base
class cfgFunctions
{
  class LT
  {
    class template_base
    {
      file="\lt_template_base\functions";
      class adminZeusModule {};
      class deleteUnits {};
      class setWeather {};
      class setTime {};
      class setFog {};
      class teleportGroup {};
      class safety {};
      class safeStartLoop {};
    };
	class Loadout_base
	{
		file="\lt_template_base\functions\Loadout";
		class prepPlayerLoadout {};
		class prepVehicleLoadout {};
		class vehicleLoadout {};
	};
	class Resupply
	{
		file="\lt_template_base\functions\Resupply";
		class resupplyRequest {};
      	class resupplyDrop {};
	};
	class Modules
	{
		file="\lt_template_base\functions\Modules";
		class CustomCompSpawner {};
		class Intel {};
		class Resupply {};
		class Defense {};
		class UnitSpawner {};
	};
	class Convoy
	{
		file="\lt_template_base\functions\Convoy";
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
		class LT_fnc_prepPlayerLoadout	{allowedTargets=0;};
		class LT_fnc_prepVehicleLoadout	{allowedTargets=2;};
		class LT_fnc_VehicleLoadout		{allowedTargets=0;};
		class LT_fnc_ResupplyRequest	{allowedTargets=2;};
		class LT_fnc_deleteUnits		{allowedTargets=2;};
	};
};
