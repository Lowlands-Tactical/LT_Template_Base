class LT_Intel_Module: Module_F 
{
    scope = 2;
    displayName = "Lowtac Intel";
    icon = "a3\ui_f\data\igui\cfg\simpletasks\types\intel_ca.paa";
    category = "LT_missionModules";
    function = "lt_fnc_Intel";
    functionPriority = 8;
    isGlobal = 1;
    isDisposable = 1;
    is3DEN = 0;
    class Attributes: AttributesBase
    {
        class Intel_ActionName: Default
        {
            property = "LT_Module_Intel_ActionName";
            displayName = "Action Name";
            tooltip = "Name of the addaction";
            control = "EditShort";
            validate = "STRING";
            defaultValue = "'Take Intel'"
        };
        class Intel_Titel: Default
        {
            property = "LT_Module_Intel_Titel";
            displayName = "Titel";
            tooltip = "Titelname of the intel";
            control = "EditShort";
            validate = "STRING";
            defaultValue = "''";
        };
        class Intel_Picture: Default
        {
            property = "LT_Module_Intel_Picture";
            displayName = "Picture";
            tooltip = "Location of the intel picture (MissionFolder)";
            control = "Edit";
            validate = "STRING";
            defaultValue = "''";
        };
        
        class Intel_Text: Default
        {
            property = "LT_Module_Intel_Text";
            displayName = "Text";
            tooltip = "Text for the intel";
            control = "EditMulti5";
            validate = "STRING";
            defaultValue = "''";
        };
        class ModuleDescription: ModuleDescription{};
    };
    class ModuleDescription: ModuleDescription
    {
        description[] = {"Sync with any intel that can be picked up"};
        position = 0;
        direction = 0;
        optional = 1;
        duplicate = 0;
        synced[] = {"AnyStaticObject"};
    };
};
