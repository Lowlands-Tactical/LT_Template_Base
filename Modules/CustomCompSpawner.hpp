class LT_CustomCompSpawner_Module: Module_F
{
	scope = 2;
	displayName = "Lowtac Composition Spawner";
	icon = "a3\ui_f\data\igui\cfg\mptable\infantry_ca.paa";
	category = "LT_missionModules";
	function = "LT_fnc_CustomCompSpawner";
	functionPriority = 8;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 0;
	is3DEN = 0;
    class Attributes: AttributesBase
    {
        class CustomCompSpawner_Side: Default
        {
            property = "LT_Module_CustomCompSpawner_Side";
            displayName = "Side";
            tooltip = "Side of the units that will be spawned";
            control = "LT_drone_side";
            validate = "STRING";
        };
        class CustomCompSpawner_InfClasses: Edit
        {
            property = "LT_Module_CustomCompSpawner_InfClasses";
            displayName = "Infantry Classes";
            tooltip = "Unit classnames seperated bij a ,";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "['B_Soldier_F']";
        };
        class CustomCompSpawner_VehClasses: CustomCompSpawner_InfClasses
        {
            property = "LT_Module_CustomCompSpawner_VehClasses";
            displayName = "Vehicles Classes";
            defaultValue= "['B_MRAP_01_F']";
        };
        class CustomCompSpawner_MechClasses: CustomCompSpawner_InfClasses
        {
            property = "LT_Module_CustomCompSpawner_MechClasses";
            displayName = "Mech Classes";
            defaultValue= "['B_APC_Wheeled_01_cannon_v2_F']";
        };
        class CustomCompSpawner_ArmorClasses: CustomCompSpawner_InfClasses
        {
            property = "LT_Module_CustomCompSpawner_ArmorClasses";
            displayName = "Armor Classes";
            defaultValue= "['B_MBT_01_cannon_F']";
        };
        class CustomCompSpawner_EmptyLine0: Default
        {
            property = "LT_Module_CustomCompSpawner_EmptyLine0";
            displayName = "WAYPOINT SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategory";
        };
        class CustomCompSpawner_SearchArea: Default
        {
            property = "LT_Module_CustomCompSpawner_SearchArea";
            displayName = "Area size";
            tooltip = "Size of area/radius to attack/defend/patrol in meters";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "50";
		};
        class CustomCompSpawner_Waypoints: Default
        {
            property = "LT_Module_CustomCompSpawner_Waypoints";
            displayName = "Waypoints";
            tooltip = "A path for the units/vehicles to follow names seperated bij a ,";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "[]";
        };
        class CustomCompSpawner_LastWaypoint: Combo
        {
            property = "LT_Module_CustomCompSpawner_LastWaypoint";
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
        class CustomCompSpawner_EmptyLine1: CustomCompSpawner_EmptyLine0
        {
            property = "LT_Module_CustomCompSpawner_EmptyLine1";
            displayName = "WAVE SETTINGS";
        };
        class CustomCompSpawner_Waves: Default
        {
            property = "LT_Module_CustomCompSpawner_Waves";
            displayName = "Amount of waves";
            tooltip = "To enter wave compositions below enter -1. You will need to enter all compositions below even if not used";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "3";
		};
        class CustomCompSpawner_UnitCap: Default
        {
            property = "LT_Module_CustomCompSpawner_UnitCap";
            displayName = "Unitcap";
            tooltip= "Unit maximum amount on any given time. Units will not spawn unless the total units are below this number";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "200";
		};
		class CustomCompSpawner_WaveDelay: Default
        {
            property = "LT_Module_CustomCompSpawner_WaveDelay";
            displayName = "Time between waves";
            tooltip= "Time in seconds. Selected randomly in a range from Min to Max, gravitating towards Mid.";
            control = "Timeout";
            validate = "ARRAY";
            defaultValue= "[30,60,90]";
		};
        class CustomCompSpawner_EmptyLine2: CustomCompSpawner_EmptyLine0
        {
            property = "LT_Module_CustomCompSpawner_EmptyLine2";
            displayName = "AMOUNT SETTINGS";
            data = "AttributeSystemSubcategory";
            control = "SubCategoryDesc1";
            description = "Randomized = -1 (0 to 3). For waves compositions 1,0,3. (If composition wave amount must be -1)";
        };
		class CustomCompSpawner_InfantryAmount: Edit
        {
            property = "LT_Module_CustomCompSpawner_InfantryAmount";
            displayName = "Amount of infantry groups";
            tooltip = "";
            control = "EditArray";
            validate = "ARRAY";
            defaultValue= "['1']";
		};
		class CustomCompSpawner_VehicleAmount: CustomCompSpawner_InfantryAmount
        {
            property = "LT_Module_CustomCompSpawner_VehicleAmount";
            displayName = "Amount of normal vehicles";
            defaultValue= "['0']";
		};
		class CustomCompSpawner_MechanizedAmount: CustomCompSpawner_VehicleAmount
        {
            property = "LT_Module_CustomCompSpawner_MechanizedAmount";
            displayName = "Amount of mechanized";
		};
		class CustomCompSpawner_ArmorAmount: CustomCompSpawner_VehicleAmount
        {
            property = "LT_Module_CustomCompSpawner_ArmorAmount";
            displayName = "Amount of armored vehicles";
		};
		class CustomCompSpawner_EmptyLine3: CustomCompSpawner_EmptyLine0
        {
            property = "LT_Module_CustomCompSpawner_EmptyLine3";
            displayName = "GROUP SETTINGS";
        };
		class CustomCompSpawner_InfantryGroupSize: Default
        {
            property = "LT_Module_CustomCompSpawner_InfantryGroupSize";
            displayName = "Infantry Groupsize";
            tooltip= "Infantry Groupsize";
            control = "EditShort";
            validate = "NUMBER";
            defaultValue= "8";
		};
        class CustomCompSpawner_CombatMode: Combo
        {
            property = "LT_Module_CustomCompSpawner_CombatMode";
            displayName = "Combat Mode";
            tooltip= "Controls how and when the group will choose to engage enemy targets";
            control = "CombatModeGroup";
            defaultValue = "'YELLOW'";
		};
		class CustomCompSpawner_Behaviour: CustomCompSpawner_CombatMode
        {
            property = "LT_Module_CustomCompSpawner_Behaviour";
            displayName = "Combat Stance";
            tooltip= "Behavior pattern of the group";
            control = "BehaviourGroup";
            defaultValue= "'AWARE'";
		};
		class CustomCompSpawner_Formation: CustomCompSpawner_CombatMode
        {
            property = "LT_Module_CustomCompSpawner_Formation";
            displayName = "Formation";
            tooltip= "Default group formation. Based on the combat mode, group members may ignore the formation in 'Combat' and 'Stealth' modes.";
            control = "FormationGroup";
            defaultValue= "'WEDGE'";
		};
        class CustomCompSpawner_SpeedMode: CustomCompSpawner_CombatMode
        {
            property = "LT_Module_CustomCompSpawner_SpeedMode";
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
