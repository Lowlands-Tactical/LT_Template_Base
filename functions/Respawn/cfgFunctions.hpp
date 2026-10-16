class LTRespawn
{
	class respawn
	{
		file = "\lt_template_base\functions\Respawn";
		class preInit {preInit = 1;};
		class init {postInit = 1;};
		class isActive {};
		class enemyNear {};
		class targetReason {};
		class commandRole {};
		class canTarget {};
		class fallbacks {};
		class fallbackConfirmed {};
		class findPosition {};
		class positionFree {};
		class placementCurrent {};
		class positionConfirmed {};
		class airClear {};
		class dropConfirmed {};
		class clearPlacement {};
		class killed {};
		class vehicleInit {postInit = 1;};
		class vehicleUpdate {};
		class registerVehicle {};
		class unregisterVehicle {};
		class vehicleSettings {};
		class begin {};
		class menu {};
		class menuRows {};
		class menuStatus {};
		class request {};
		class reply {};
	};
};
