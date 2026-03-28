/*#include "\lt_template_base\script_mod.hpp"

class cfgPatches
{
	class lt_template_base_faces
	{
		name="Lowtac - Faces";
		author=LT_AUTHOR;
		authors[]={LT_AUTHORS};
		url="http://lowtac.nl/";
		requiredVersion=LT_REQVR;
		requiredAddons[]=
		{
            "A3_Characters_F",
			"lt_template_base"
		};
		units[]={};
		weapons[]={};

		//CBA versioning
		version = VERSION;
		versionStr = STR(VERSION_STR);
		versionAR[] = {VERSION_AR};
	};
};*/

class cfgFaces
{
    class Default
	{
		class Custom;
	};
    class LowTac: Default
    {
        class Default
        {
            author="Lowlands Tactical";
            displayname="Default face";
			texture="\A3\Characters_F\Heads\Data\m_White_01_co.paa";
			head="NATOHead_A3";
			identityTypes[]=
            {
                "Head_NATO",
				"Head_Euro"
            };
			material="\A3\Characters_F\Heads\Data\m_White_01.rvmat";
			materialWounded1="A3\Characters_F\Heads\Data\m_White_01_injury.rvmat";
			materialWounded2="A3\Characters_F\Heads\Data\m_White_01_injury.rvmat";
			textureHL="\A3\Characters_F\Heads\Data\hl_White_bald_1_co.paa";
			textureHL2="\A3\Characters_F\Heads\Data\hl_White_bald_co.paa";
			materialHL="\A3\Characters_F\Heads\Data\hl_White_bald_muscular.rvmat";
			materialHL2="A3\Characters_F\Heads\Data\hl_White_bald_muscular.rvmat";
			disabled=0;
        };
        class Custom: Custom
        {
            author="Lowlands Tactical";
			displayname="Custom face";
			texture="#(argb,8,8,3)color(0.596,0.412,0.365,1)";
			head="DefaultHead_A3";
			identityTypes[]={};
			material="A3\Characters_F\Heads\Data\m_White_01.rvmat";
			materialWounded1="A3\Characters_F\Heads\Data\m_White_01_injury.rvmat";
			materialWounded2="A3\Characters_F\Heads\Data\m_White_01_injury.rvmat";
			textureHL="\A3\Characters_F\Heads\Data\hl_White_hairy_1_co.paa";
			materialHL="\A3\Characters_F\Heads\Data\hl_White_hairy_muscular.rvmat";
			textureHL2="\A3\Characters_F\Heads\Data\hl_White_hairy_1_co.paa";
			materialHL2="A3\Characters_F\Heads\Data\hl_White_hairy_muscular.rvmat";
        };
		/*
		class Ben: Default
        {
            displayname="Brainless_Ben";
			texture="\lt_template_base\Faces\data\Face_Ben_co.paa";
        };
		*/
    };
};