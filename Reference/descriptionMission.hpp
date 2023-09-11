#ifndef MISSION_FATIGUE
    #define MISSION_FATIGUE 0
#endif
#ifndef MISSION_MARKERS
    #define MISSION_MARKERS 0
#endif
#ifndef MISSION_DEBUG
    #define MISSION_DEBUG 0
#endif
#ifndef MISSION_TIME
    #define MISSION_TIME 24
#endif
#ifndef MISSION_WEATHER
    #define MISSION_WEATHER 9
#endif
#ifndef MISSION_FOG
    #define MISSION_FOG 4
#endif
#ifndef MISSION_TIMER
    #define MISSION_TIMER 10
#endif

class lt_Empty_01 
{
    title = "========== Mission setting ==========";
    values[] = {0};
    texts[] = {"========== Mission setting =========="};
    default = 0;
};
class lt_fatigue_onoff
{
    title = "Fatigue";
    values[] = {0,1};
    texts[] = {"False","True"};
    default = MISSION_FATIGUE;
};
class lt_markers
{
    title = "Group markers";
    values[] = {0,1};
    texts[] = {"False","True"};
    default = MISSION_MARKERS;
};
class lt_debug
{
    title = "Enable Debug";
    values[] = {0,1};
    texts[] = {"False","True"};
    default = MISSION_DEBUG;
};
class lt_param_timeOfDay
{
    title = "Time of Day";
    values[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24};
    texts[] = {"0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","Use mission settings"};
    default = MISSION_TIME;
    function = "LT_fnc_setTime";
};
class lt_param_weather
{
    title = "Weather";
    values[] = {0,1,2,3,4,5,6,7,8,9};
    texts[] = {"Clear (Calm)","Clear (Light Winds)","Clear (Strong Winds)","Overcast (Calm)","Overcast (Light Winds)","Overcast (Strong Winds)","Rain (Light Winds)","Rain (Strong Winds)","Storm","Use mission settings"};
    default = MISSION_WEATHER;
    function = "LT_fnc_setWeather";
};
class lt_param_fog
{
    title = "Fog";
    values[] = {0,1,2,4};
    texts[] = {"None","Light","Heavy","Use mission settings"};
    default = MISSION_FOG;
    function = "LT_fnc_SetFog";
};
class lt_param_timer
{
    title = "Mission safety timer (Minutes)";
    values[] = {0,1,2,3,4,5,6,7,8,9,10,15,20};
    texts[] = {"No timer","1","2","3","4","5","6","7","8","9","10","15","20"};
    default = MISSION_TIMER;
};
