class LT_Resupply_Module: Module_F 
{
    scope = 2;
    displayName = "Lowtac Resupply";
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
    category = "LT_missionModules";
    function = "LT_fnc_Resupply";
    functionPriority = 8;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;
    is3DEN = 0;
    class Attributes: AttributesBase
    {
        class Resupply_Side: Default
        {
            property = "LT_Module_Resupply_Side";
            displayName = "Side";
            tooltip = "Side of the loadout that will be dropped";
            control = "LT_veh_side";
            validate = "STRING";
        };
        class Resupply_Vehicle: Default
        {
            property = "LT_Module_Resupply_Vehicle";
            displayName = "Aircraft";
            tooltip = "Aircraft to drop the supplies";
            control = "Edit";
            validate = "STRING";
            defaultValue = "''";
        };
        class Resupply_Crate: Default
        {
            property = "LT_Module_Resupply_Crate";
            displayName = "Crate";
            tooltip = "Type of crate to drop (If load is a vehicle, vehicle will be dropped)";
            control = "Edit";
            validate = "STRING";
            defaultValue = "''";
        };
        class Resupply_Loadout_1: Default
        {
            property = "LT_Module_Resupply_Loadout_1";
            displayName = "Loadout";
            tooltip = "Type of loadout inside crate";
            control = "LT_Combo_Loadout";
            validate = "STRING";
        };
        class Resupply_Loadout_2: Resupply_Loadout_1
        {
            property = "LT_Module_Resupply_Loadout_2";
        };
        class Resupply_Loadout_3: Resupply_Loadout_1
        {
            property = "LT_Module_Resupply_Loadout_3";
        };
        class Resupply_EmptyLine0: Default
        {
            property = "LT_Module_Resupply_EmptyLine0";
            displayName = "Direction of flight";
            data = "AttributeSystemSubcategory";
            control = "SubCategoryDesc1";
            description = "No/No = S to N | No/Yes = N to S | Yes/No = W to E | Yes/Yes = E to W";
        };
        class Resupply_Shift: Default
        {
            property = "LT_Module_Resupply_Shift";
            displayName = "Direction 1";
            tooltip = "See above for more info";
            control = "Checkbox";
            validate = "BOOLEAN";
            defaultValue = "false";
        };
        class Resupply_Alt: Resupply_Shift
        {
            property = "LT_Module_Resupply_Alt";
            displayName = "Direction 2";
        };
        class ModuleDescription: ModuleDescription{};
    };
    class ModuleDescription: ModuleDescription
    {
        description[] = {"This module drops 1/2 or 3 crates around the module position, with selected loadout."};
        position = 1;
        direction = 0;
        optional = 1;
        duplicate = 0;
        synced[] = {"AnyStaticObject"};
    };
};
