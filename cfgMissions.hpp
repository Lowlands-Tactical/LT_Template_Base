class cfgWorlds
{
	initWorld="Altis";
	demoWorld="Altis";
	class DefaultWorld
	{
		cutscenes[]=
		{
			"LTKH_Scenes"
		};
		class Weather
		{
			class Overcast;
		};
	};
	class CAWorld;
	class Altis: CAWorld
	{
		cutscenes[]=
		{
			"LTKH_Scenes"
		};
	};
};

class CfgMissions
{
	class Cutscenes
	{
		class LTKH_Scenes
        {
            directory="lt_template_base\Scenes\LT_KampHolland_Scenes.Altis";
        };
	};
};

class cfgMainMenuSpotlight
{
	class JoinServer
	{
		text = """Lowtac Server""";
		picture = "LT_Template_Base\logos\lowtac-server-banner.paa";
		action = "connectToServer ['arma3.lowtac.nl', 2302, 'TacLow']";
		actionText = "Join the Lowtac Server";
		condition = "true";
	};
};