/*

File: BriefingMeteo.sqf
Author: Brainless_Ben

Description:
Adds the meteo data to the briefing section for all players.

*/

if !(hasInterface) exitWith {};

// ---- WEATHER HELPER FUNCTIONS ----
_getOvercastDesc = {
    params ["_value"];
    switch (true) do {
        case (_value < 0.2): {"Helder"};
        case (_value < 0.4): {"Licht bewolkt"};
        case (_value < 0.6): {"Bewolkt"};
        case (_value < 0.8): {"Zwaar bewolkt"};
        default              {"Dichte bewolking"};
    }
};

_getWindDirDesc = {
    params ["_deg"];
    switch (true) do {
        case (_deg < 22.5 || {_deg >= 337.5}): {"N"};
        case (_deg < 67.5):  {"NO"};
        case (_deg < 112.5): {"O"};
        case (_deg < 157.5): {"ZO"};
        case (_deg < 202.5): {"Z"};
        case (_deg < 247.5): {"ZW"};
        case (_deg < 292.5): {"W"};
        default              {"NW"};
    }
};
_getTrend = {
    params ["_new", "_old", "_better", "_worse"];
    if (_new > _old) then {_worse} else {_better}
};

// ---- GATHER WEATHER DATA ----
_overcast = [overcast] call _getOvercastDesc;
_fog = switch (true) do {
    case (fog < 0.1): {"Geen mist"};
    case (fog < 0.3): {"Lichte mist"};
    case (fog < 0.6): {"Mistig"};
    case (fog < 0.8): {"Dichte mist"};
    default           {"Zeer dichte mist"};
};
_rain = switch (true) do {
    case (rain < 0.1): {"Droog"};
    case (rain < 0.3): {"Lichte regen"};
    case (rain < 0.6): {"Regen"};
    case (rain < 0.8): {"Zware regen"};
    default            {"Stortbui"};
};
_windStr = windStr;
_gusts = gusts;
_waves = waves;

// Wind direction from vector
_wx = wind select 0;
_wy = wind select 1;
_windBearing = if (_wx == 0 && {_wy == 0}) then {0} else {(_wx atan2 _wy + 360) mod 360};
_windFrom = (_windBearing + 180) mod 360;
_windDirStr = [_windFrom] call _getWindDirDesc;

// Current time
_hour = date select 3;
_min  = date select 4;
_timeStr = format ["%1:%2",
    if (_hour < 10) then {format ["0%1", _hour]} else {str _hour},
    if (_min  < 10) then {format ["0%1", _min ]} else {str _min }
];
_dayNight = if (sunOrMoon > 0.5) then {"Dag"} else {"Nacht"};

// Pre-compute forecast strings (value + trend)
_fOvercastStr = format ["%1 (%2)",
    [overcastForeCast] call _getOvercastDesc,
    [overcastForeCast, overcast, "verbeterend", "Verslechterend"] call _getTrend
];
_fFogStr  = format["%1 (%2)",
    _fog,
    if ((fogParams select 1) > 0) then {"Verbeterend"} else {"Verslechterend"}
    ];

_briefMeteo = format['
    <br/><font color="#FFBA26" size="16">METEOROLOGIE</font>

    <br/><br/><font color="#FFBA26">Tijdstip:</font>
    <br/><font color="#D7DBD5">• Tijd:</font> %1 (%2)

    <br/><br/><font color="#FFBA26">Huidig Weer:</font>
    <br/><font color="#D7DBD5">• Luchtgesteldheid:</font> %3
    <br/><font color="#D7DBD5">• Neerslag:</font> %4
    <br/><font color="#D7DBD5">• Zicht:</font> %5
    <br/><font color="#D7DBD5">• Wind:</font> %6 km/h uit het %7
    <br/><font color="#D7DBD5">• Windstoten:</font> %8 km/h
    <br/><font color="#D7DBD5">• Golven:</font> %9 m
    <br/><font color="#D7DBD5">• Onweer:</font> %10

    <br/><br/><font color="#FFBA26">Weersverwachting</font>
    <br/><font color="#D7DBD5">• Luchtgesteldheid:</font> %11
    <br/><font color="#D7DBD5">• Zicht:</font> %12
',
    _timeStr,
    _dayNight,
    _overcast,
    _rain,
    _fog,
    round (_windStr * 3.6),
    _windDirStr,
    round (_gusts * 3.6),
    round (_waves * 10),
    if (lightnings > 0.5) then {"Aanwezig"} else {"Niet aanwezig"},
    _fOvercastStr,
    _fFogStr
];

player createDiaryRecord ["LT Briefing", ["Meteo", _briefMeteo]];
