class LT_Convoy: Module_F
{
    scope = 2;
    displayName = "Lowtac Convoy Module";
    icon = "\a3\ui_f\data\igui\cfg\simpletasks\types\truck_ca.paa";
    category = "LT_missionModules";
    function = "LT_fnc_initConvoy";
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 0;
    isDisposable = 1;
    is3DEN = 0;
    class Attributes: AttributesBase
    {
        class maxSpeed: Edit
        {
            property = "LT_Module_Convoy_maxSpeed";
            displayName = "Max Speed";
            tooltip = "Maximum speed of the convoy, in km/h.";
            typeName = "NUMBER";
            defaultValue = "40";
        };
        class convSeparation: Edit
        {
            property = "LT_Module_Convoy_convSeparation";
            displayName = "Convoy Separation";
            tooltip = "Convoy separation distance, in meters.";
            typeName = "NUMBER";
            defaultValue = "35";
        };
        class stiffnessCoeff: Edit
        {
            property = "LT_Module_Convoy_stiffnessCoeff";
            displayName = "Convoy Stiffness";
            tooltip = "How much should the lead vehicle brake, in order to establish the desired convoy separation.";
            typeName = "NUMBER";
            defaultValue = "0.2";
        };
        class dampingCoeff: Edit
        {
            property = "LT_Module_Convoy_dampingCoeff";
            displayName = "Convoy Damping";
            tooltip = "How much should the lead vehicle brake, in order to minimize the relative speeds between the vehicles.";
            typeName = "NUMBER";
            defaultValue = "0.6";
        };
        class curvatureCoeff: Edit
        {
            property = "LT_Module_Convoy_curvatureCoeff";
            displayName = "Curvature Coefficient";
            tooltip = "How much should the lead vehicle brake, when traversing winding roads.";
            typeName = "NUMBER";
            defaultValue = "0.3";
        };
        class stiffnessLinkCoeff: Edit
        {
            property = "LT_Module_Convoy_stiffnessLinkCoeff";
            displayName = "Link Stiffness";
            tooltip = "How much should a follower vehicle accelerate and break, in order to establish the desired convoy separation with the vehicle in front.";
            typeName = "NUMBER";
            defaultValue = "0.1";
        };
        class pathFrequecy: Edit
        {
            property = "LT_Module_Convoy_pathFrequecy";
            displayName = "Path Frequency";
            tooltip = "Path update frequency, in seconds (adjust for performance).";
            typeName = "NUMBER";
            defaultValue = "0.05";
        };
        class speedFrequecy: Edit
        {
            property = "LT_Module_Convoy_speedFrequecy";
            displayName = "Speed Control Frequency";
            tooltip = "Speed control update frequency, in seconds (adjust for performance).";
            typeName = "NUMBER";
            defaultValue = "0.2";
        };
        class speedModeConv: Combo
        {
            property = "LT_Module_Convoy_speedMode";
            displayName = "Convoy Speed Mode";
            tooltip = "Change the Speed Mode for all the convoy's groups.";
            typeName = "STRING";
            defaultValue = """Normal""";
            class Values
            {
                class 0	{name = "Unchanged";	value = "UNCHANGED";};
                class 1	{name = "Limited"; 		value = "LIMITED";};
                class 2	{name = "Normal"; 		value = "NORMAL";};
                class 3	{name = "Full"; 		value = "FULL";};
            };
        };
        class behaviourConv: Combo
        {
            property = "LT_Module_Convoy_behaviourConv";
            displayName = "Behaviour";
            tooltip = "Forces convoy vehicles to push through enemy contact.";
            typeName = "STRING";
            defaultValue = """pushThroughContact""";
            class Values
            {
                class 0	{name = "Aware";				value = "AWARE";};
                class 1	{name = "Push Through Contact"; value = "pushThroughContact";};
            };
        };
        class debug: Checkbox
        {
            property = "LT_Module_Convoy_debug";
            displayName = "Debug";
            tooltip = "Draw paths.";
            typeName = "BOOL";
            defaultValue = "false";
        };
        class ModuleDescription: ModuleDescription{};
    };
    class ModuleDescription: ModuleDescription
    {
        description[]=
        { 
            "This module is used to compose a vehicle convoy.", 
            "First, place the vehicles in distinct groups. Then, sync the vehicles with this module.",
            "The sync order dictates the order of the convoy."
        };
        position = 0;
        direction = 0;
        optional = 1;
        duplicate = 0;
        synced[] = {"AnyBrain"};
    };
};