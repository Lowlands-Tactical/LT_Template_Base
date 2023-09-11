class LT_Defense_Module: Module_F
{
	scope = 2;
	displayName = "Lowtac Defense Module";
	icon = "a3\ui_f\data\igui\cfg\simpletasks\types\defend_ca.paa";
	category = "LT_missionModules";
	function = "LT_fnc_Defense";
	functionPriority = 6;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 0;
	is3DEN = 0;
	class Attributes: AttributesBase
	{
		class Defense_Marker: Default
        {
            property = "LT_Module_Defense_Marker";
            displayName = "MarkerName";
            tooltip = "The marker where the defense position should take place. If left empty module position will be defense position";
            control = "EditShort";
            validate = "STRING";
            defaultValue = "''";
		};
        class Defense_Faction: Default
        {
            property = "LT_Module_Defense_Faction";
            displayName = "Faction";
            tooltip = "Input the faction classname that will attack the site";
            control = "EditShort";
            validate = "STRING";
            defaultValue = "'OPF_F'";
		};
        class Defense_BlackList: Edit
        {
            property = "LT_Module_Defense_BlackList";
            displayName = "Blacklist";
            tooltip = "To blacklist a unit/vehicle input the classnames seperated bij a ,";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "[]";
		};
        class Defense_Direction: Combo
        {
            property = "LT_Module_Defense_Direction";
            displayName = "Direction of attack";
            tooltip= "Direction from which the attack will come.";
            defaultValue= "0";
            class values 
            {
                class ModuleDirection 
                {
                    name = "Module direction";
                    value= 0;
                    default = 1;
                };
                class RandomDirection 
                {
                    name = "Random directions (Surrounded)";
                    value= 1;
                };
                class SpawnMarkers 
                {
                    name = "Unit spawn Markers";
                    value = 2;
                };
            };
		};
        class Defense_EmptyLine0: Default
        {
            property = "LT_Module_Defense_EmptyLine0";
            displayName = "SPAWN SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategory";
        };
		class Defense_SearchAreaSize: Default
        {
            property = "LT_Module_Defense_SearchAreaSize";
            displayName = "Defense area size";
            tooltip = "Size of area enemies will search. If marker is rectangle or ellipse that size will be used.";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "100";
		};
		class Defense_MinSpawnDistance: Default
        {
            property = "LT_Module_Defense_MinSpawnDistance";
            displayName = "Minimum spawndistance";
            tooltip= "Minimum distance units will be spawned.";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "500";
		};
		class Defense_MaxSpawnDistance: Default
        {
            property = "LT_Module_Defense_MaxSpawnDistance";
            displayName = "Maximum spawndistance";
            tooltip= "Maximum distance units will be spawned";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "1500";
		};
		class Defense_MarkerInfantrySpawn: Default
        {
            property = "LT_Module_Defense_MarkerInfantrySpawn";
            displayName = "Infantry Spawn markers";
            tooltip= "Only used if markers is selected in direction of attack";
            control = "EditShort";
            validate = "STRING";
            defaultValue= "''";
		};
		class Defense_MarkerVehicleSpawn: Defense_MarkerInfantrySpawn
        {
            property = "LT_Module_Defense_MarkerVehicleSpawn";
            displayName = "Vehicle Spawn markers";
		};
        class Defense_MarkerMechSpawn: Defense_MarkerInfantrySpawn
        {
            property = "LT_Module_Defense_MarkerMechSpawn";
            displayName = "Mechanized Spawn markers";
		};
        class Defense_MarkerArmorSpawn: Defense_MarkerInfantrySpawn
        {
            property = "LT_Module_Defense_MarkerArmorSpawn";
            displayName = "Armor Spawn markers";
		};
        class Defense_EmptyLine1: Defense_EmptyLine0
        {
            property = "LT_Module_Defense_EmptyLine1";
            displayName = "WAVE SETTINGS";
        };
        class Defense_Waves: Default
        {
            property = "LT_Module_Defense_Waves";
            displayName = "Amount of waves";
            tooltip = "To enter wave compositions below enter -1. You will need to enter all compositions below even if not used";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "3";
		};
        class Defense_UnitCap: Default
        {
            property = "LT_Module_Defense_UnitCap";
            displayName = "Unitcap";
            tooltip= "Unit maximum amount on any given time. Units will not spawn unless the total units are below this number";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "200";
		};
		class Defense_WaveDelay: Default
        {
            property = "LT_Module_Defense_WaveDelay";
            displayName = "Time between waves";
            tooltip= "Time in seconds. Selected randomly in a range from Min to Max, gravitating towards Mid.";
            control = "Timeout";
            validate = "ARRAY";
            defaultValue= "[30,60,90]";
		};
        class Defense_EmptyLine2: Defense_EmptyLine0
        {
            property = "LT_Module_Defense_EmptyLine2";
            displayName = "AMOUNT SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategoryDesc1";
            description = "Randomized = -1 (0 to 3). For waves compositions 1,0,3. (If composition wave amount must be -1)";
        };
		class Defense_InfantryAmount: Edit
        {
            property = "LT_Module_Defense_InfantryAmount";
            displayName = "Amount of infantry groups";
            tooltip = "";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "['1']";
		};
		class Defense_VehicleAmount: Defense_InfantryAmount
        {
            property = "LT_Module_Defense_VehicleAmount";
            displayName = "Amount of normal vehicles";
            defaultValue= "['0']";
		};
		class Defense_MechanizedAmount: Defense_VehicleAmount
        {
            property = "LT_Module_Defense_MechanizedAmount";
            displayName = "Amount of mechanized";
		};
		class Defense_ArmorAmount: Defense_VehicleAmount
        {
            property = "LT_Module_Defense_ArmorAmount";
            displayName = "Amount of armored vehicles";
		};
		class Defense_EmptyLine3: Defense_EmptyLine0
        {
            property = "LT_Module_Defense_EmptyLine3";
            displayName = "GROUP SETTINGS";
        };
		class Defense_InfantryGroupSize: Default
        {
            property = "LT_Module_Defense_InfantryGroupSize";
            displayName = "Infantry Groupsize";
            tooltip= "Infantry Groupsize";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "8";
		};
        class Defense_CombatMode: Combo
        {
            property = "LT_Module_Defense_CombatMode";
            displayName = "Combat Mode";
            tooltip= "Controls how and when the group will choose to engage enemy targets";
            control = "CombatModeGroup";
            defaultValue = "'YELLOW'";
		};
		class Defense_Behaviour: Defense_CombatMode
        {
            property = "LT_Module_Defense_Behaviour";
            displayName = "Combat Stance";
            tooltip= "Behavior pattern of the group";
            control = "BehaviourGroup";
            defaultValue= "'AWARE'";
		};
		class Defense_Formation: Defense_CombatMode
        {
            property = "LT_Module_Defense_Formation";
            displayName = "Formation";
            tooltip= "Default group formation. Based on the combat mode, group members may ignore the formation in 'Combat' and 'Stealth' modes.";
            control = "FormationGroup";
            defaultValue= "'WEDGE'";
		};
        class Defense_SpeedMode: Defense_CombatMode
        {
            property = "LT_Module_Defense_SpeedMode";
            displayName = "SpeedMode";
            tooltip= "Default travel speed of the group. In Combat and Stealth behaviour modes, group members will try to prioritize this settings.";
            control = "SpeedModeGroup";
            defaultValue= "'Normal'";
        };
        class ModuleDescription: ModuleDescription{};
	};
	class ModuleDescription: ModuleDescription
    {
        description[] = {
            "Defence module spawns units a between Min and Max distance set in module",
            "A custom faction can be selected and only the units not in the blacklist wil be spawned",
            "If markerName is empty module position is selected",
            "Same for the direction"
        };
        position = 1;
        direction = 1;
        optional = 1;
        duplicate = 0;
        synced[] = {"AnyBrain"};
    };
};
