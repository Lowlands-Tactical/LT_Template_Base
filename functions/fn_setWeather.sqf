private ["_weather","_missionOvercast","_MissionRain","_MissionRainbow","_MissionLightnings","_MissionWindStr","_MissionWindGusts","_MissionWaves","_MissionHumidity"];
_weather = param [0, 9, [9]];

if ( _weather == 9 ) exitWith {};
_transition = if (count _this > 1) then {_this select 1} else {false};
_MissionOvercast = 0;
_MissionRain = 0;
_MissionRainbow = 0;
_MissionLightnings = 0;
_MissionWindStr = 0;
_MissionWindGusts = 0;
_MissionWaves = 0;
_MissionHumidity = 0;

switch (_weather) do
{
	// Clear (Calm)
	case 0:
	{
		_MissionOvercast = 0;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0;
		_MissionWindGusts = 0;
		_MissionWaves = 0;
		_MissionHumidity = 0;
	};
	// Clear (Light Winds)
	case 1:
	{
		_MissionOvercast = 0.01;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.5;
		_MissionWaves = 0.25;
		_MissionHumidity = 0.2;
	};
	// Clear (Strong Winds)
	case 2:
	{
		_MissionOvercast = 0.01;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.75;
		_MissionWindGusts = 1;
		_MissionWaves = 0.75;
		_MissionHumidity = 0.2;
	};
	// Overcast (Calm)
	case 3:
	{
		_MissionOvercast = 0.55;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0;
		_MissionWindGusts = 0;
		_MissionWaves = 0.1;
		_MissionHumidity = 0.2;
	};
	// Overcast (Light Winds)
	case 4:
	{
		_MissionOvercast = 0.55;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.5;
		_MissionWaves = 0.25;
		_MissionHumidity = 0.2;
	};
	// Overcast (Strong Winds)
	case 5:
	{
		_MissionOvercast = 0.55;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.75;
		_MissionWindGusts = 1;
		_MissionWaves = 0.75;
		_MissionHumidity = 0.2;
	};
	// Rain (Light Winds)
	case 6:
	{
		_MissionOvercast = 1;
		_MissionRain = 1;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.5;
		_MissionWaves = 0.75;
		_MissionHumidity = 0.9;
	};
	// Rain (Strong Winds)
	case 7:
	{
		_MissionOvercast = 1;
		_MissionRain = 1;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.75;
		_MissionWindGusts = 1;
		_MissionWaves = 0.75;
		_MissionHumidity = 0.9;
	};
	// Storm
	case 8:
	{
		_MissionOvercast = 1;
		_MissionRain = 1;
		_MissionRainbow = 0;
		_MissionLightnings = 1;
		_MissionWindStr = 1;
		_MissionWindGusts = 1;
		_MissionWaves = 1;
		_MissionHumidity = 1;
	};
};

if (typeName _transition == typeName 0) then 
{
	_transition setOvercast  _MissionOvercast;
	_transition setRain _MissionRain;
	_transition setRainbow _MissionRainbow;
	_transition setWindStr  _MissionWindStr;
	_transition setWindForce _MissionWindGusts;
	_transition setWaves _MissionWaves;
	_transition setLightnings _MissionLightnings;
} else 
{
	0 setOvercast  _MissionOvercast;
	0 setRain _MissionRain;
	0 setRainbow _MissionRainbow;
	0 setWindStr  _MissionWindStr;
	0 setWindForce _MissionWindGusts;
	0 setWaves _MissionWaves;
	0 setLightnings _MissionLightnings;
	forceWeatherChange;
};
