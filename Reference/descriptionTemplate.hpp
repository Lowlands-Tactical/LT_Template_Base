/*

File: descriptionTemplate.hpp
Author: Brainless_Ben

Description:
to be included in description.ext for edit ease

*/

//Mission Information
onLoadIntroTime=0;

//Respawn/Revive
respawnVehicleDelay=10;
respawnOnStart=-1;
respawnTemplates[]=
{
	"Counter",
	"Wave"
};

//Player's UI
showHUD[]=
{
	1,	// Scripted HUD (same as showHUD command)
	1,	// Vehicle and unit info
	1,	// Vehicle radar
	1,	// Vehicle compass
	1,	// Tank direction indicator
	0,	// Commanding menu
	0,	// Group info bar
	1,	// HUD weapon cursors
	1,	// Vehicle display panels
	0,	// "x killed by y" systemChat messages
	0	// force show drawIcon3D icons
};
showCompass=1;
showGPS=1;
showMap=1;
showWatch=1;
showUAVFeed=1;

//Corpse and Wrack Management
corpseManagerMode=3;
coprseLimit=20;
corpseRemovalMinTime=30;
coprseRemovalMaxTime=300;
disposalCheckPeriod=20;
minPlayerDistance[]=
{
	75,		// corpsesMinDist
	100,	// wrecksMinDist
	50,		// weaponholdersMinDist
	300,	// corpsesOverrideTime
	500,	// wrecksOverrideTime
	300		// weaponholdersOverrideTime
};
weaponholderLimit=50;
weaponholderRemovalMinTime=60;
weaponholderRemovalMaxTime=600;
wrackManagerMode=0;

//Mission Settings
aiKills=0;
briefing=1;
debriefing=1;
class DifficultyOverride
{
	tacticalPing=0;
};
disableChannels[]=
{
	0,2,4,5
};
enableDebugConsole[]=
{
	"76561198042684200",	// Tybalty
	"76561198028914656",	// L0nesentinel
	"76561198014060493",	// R.Hoods
	"76561197992586763"		// Brainless_Ben
};
forceRotorLibSimulation=0;
saving=0;

//Server Security
allowFunctionsLog=1;
allowFunctionsRecompile=1;
