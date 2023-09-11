class LT_UnitSpawner_Module: Module_F
{
	scope = 2;
	displayName = "Lowtac Units Spawner";
	icon = "a3\ui_f\data\igui\cfg\mptable\infantry_ca.paa";
	category = "LT_missionModules";
	function = "LT_fnc_UnitSpawner";
	functionPriority = 8;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 0;
	is3DEN = 0;
    class Attributes: AttributesBase
    {
        class UnitSpawner_Faction: Default
        {
            property = "LT_Module_UnitSpawner_Faction";
            displayName = "Faction";
            tooltip = "Input the faction classname that will attack the site";
            control = "EditShort";
            validate = "STRING";
            defaultValue = "'OPF_F'";
		};
        class UnitSpawner_BlackList: Edit
        {
            property = "LT_Module_UnitSpawner_BlackList";
            displayName = "Blacklist";
            tooltip = "To blacklist a unit/vehicle input the classnames seperated bij a ,";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "[]";
		};
        class UnitSpawner_EmptyLine0: Default
        {
            property = "LT_Module_UnitSpawner_EmptyLine0";
            displayName = "WAYPOINT SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategory";
        };
        class UnitSpawner_SearchArea: Default
        {
            property = "LT_Module_UnitSpawner_SearchArea";
            displayName = "Area size";
            tooltip = "Size of area/radius to attack/defend/patrol in meters";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "50";
		};
        class UnitSpawner_Waypoints: Default
        {
            property = "LT_Module_UnitSpawner_Waypoints";
            displayName = "Waypoints";
            tooltip = "A path for the units/vehicles to follow names seperated bij a ,";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "[]";
        };
        class UnitSpawner_LastWaypoint: Combo
        {
            property = "LT_Module_UnitSpawner_LastWaypoint";
            displayName = "Last waypoint task";
            tooltip= "What the units will do when the last waypoint kicks in";
            defaultValue= "Patrol";
            class values 
            {
                class Nothing 
                {
                    name = "Do nothing";
                    value= "";
                };
                class Attack 
                {
                    name = "Units attack area";
                    value= "Attack";
                };
                class Defend 
                {
                    name = "Units defend area";
                    value = "Defend";
                };
                class Garrison 
                {
                    name = "Units garrison buildings";
                    value= "Garrison";
                };
                class Patrol 
                {
                    name = "Units patrol area";
                    value = "Patrol";
                    default = 1;
                };
                class Search 
                {
                    name = "Units search Buildings";
                    value= "Search";
                };
                class Delete 
                {
                    name = "Delete units on arrival";
                    value = "Delete";
                };
            };
        };
        class UnitSpawner_EmptyLine1: UnitSpawner_EmptyLine0
        {
            property = "LT_Module_UnitSpawner_EmptyLine1";
            displayName = "WAVE SETTINGS";
        };
        class UnitSpawner_Waves: Default
        {
            property = "LT_Module_UnitSpawner_Waves";
            displayName = "Amount of waves";
            tooltip = "To enter wave compositions below enter -1. You will need to enter all compositions below even if not used";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "3";
		};
        class UnitSpawner_UnitCap: Default
        {
            property = "LT_Module_UnitSpawner_UnitCap";
            displayName = "Unitcap";
            tooltip= "Unit maximum amount on any given time. Units will not spawn unless the total units are below this number";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "200";
		};
		class UnitSpawner_WaveDelay: Default
        {
            property = "LT_Module_UnitSpawner_WaveDelay";
            displayName = "Time between waves";
            tooltip= "Time in seconds. Selected randomly in a range from Min to Max, gravitating towards Mid.";
            control = "Timeout";
            validate = "ARRAY";
            defaultValue= "[30,60,90]";
		};
        class UnitSpawner_EmptyLine2: UnitSpawner_EmptyLine0
        {
            property = "LT_Module_UnitSpawner_EmptyLine2";
            displayName = "AMOUNT SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategoryDesc1";
            description = "Randomized = -1 (0 to 3). For waves compositions 1,0,3. (If composition wave amount must be -1)";
        };
		class UnitSpawner_InfantryAmount: Edit
        {
            property = "LT_Module_UnitSpawner_InfantryAmount";
            displayName = "Amount of infantry groups";
            tooltip = "";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "['1']";
		};
		class UnitSpawner_VehicleAmount: UnitSpawner_InfantryAmount
        {
            property = "LT_Module_UnitSpawner_VehicleAmount";
            displayName = "Amount of normal vehicles";
            defaultValue= "['0']";
		};
		class UnitSpawner_MechanizedAmount: UnitSpawner_VehicleAmount
        {
            property = "LT_Module_UnitSpawner_MechanizedAmount";
            displayName = "Amount of mechanized";
		};
		class UnitSpawner_ArmorAmount: UnitSpawner_VehicleAmount
        {
            property = "LT_Module_UnitSpawner_ArmorAmount";
            displayName = "Amount of armored vehicles";
		};
		class UnitSpawner_EmptyLine3: UnitSpawner_EmptyLine0
        {
            property = "LT_Module_UnitSpawner_EmptyLine3";
            displayName = "GROUP SETTINGS";
        };
		class UnitSpawner_InfantryGroupSize: Default
        {
            property = "LT_Module_UnitSpawner_InfantryGroupSize";
            displayName = "Infantry Groupsize";
            tooltip= "Infantry Groupsize";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "8";
		};
        class UnitSpawner_CombatMode: Combo
        {
            property = "LT_Module_UnitSpawner_CombatMode";
            displayName = "Combat Mode";
            tooltip= "Controls how and when the group will choose to engage enemy targets";
            control = "CombatModeGroup";
            defaultValue = "'YELLOW'";
		};
		class UnitSpawner_Behaviour: UnitSpawner_CombatMode
        {
            property = "LT_Module_UnitSpawner_Behaviour";
            displayName = "Combat Stance";
            tooltip= "Behavior pattern of the group";
            control = "BehaviourGroup";
            defaultValue= "'AWARE'";
		};
		class UnitSpawner_Formation: UnitSpawner_CombatMode
        {
            property = "LT_Module_UnitSpawner_Formation";
            displayName = "Formation";
            tooltip= "Default group formation. Based on the combat mode, group members may ignore the formation in 'Combat' and 'Stealth' modes.";
            control = "FormationGroup";
            defaultValue= "'WEDGE'";
		};
        class UnitSpawner_SpeedMode: UnitSpawner_CombatMode
        {
            property = "LT_Module_UnitSpawner_SpeedMode";
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
            "UnitSpawn module spawns units on the position of the module",
            "The units follow the waypoint markers and execute a set task on the last waypoint",
            "A custom faction can be selected and only the units not in the blacklist wil be spawned"
        };
        position = 1;
        direction = 1;
        optional = 1;
        duplicate = 0;
        synced[] = {"AnyBrain"};
    };
};
