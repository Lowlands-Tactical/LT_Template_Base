/*

File: server_debug.sqf
Author: Brainless_Ben

Description:
Creates a marker that displays the numer of players and AI

*/

private ["_dbMRK","_dbPos"];

// Maybe we want to change this later on or make exceptions because of the maps.
_dbPos = [100,100];
_dbMRK = createMarkerLocal ["server_stats",_dbPos];
_dbMRK setMarkerTextLocal "...";
_dbMRK setMarkerTypeLocal "KIA";
_dbMRK setMarkerColorLocal "ColorOrange";

while {true} do {
  _allUnits = count (allUnits);
  _allPlayers = count (call BIS_fnc_listPlayers);
  _dbMRK setMarkerText format ["FPS:%1; allUnits:%2; Players:%3; AI_local:%4;", diag_fps, _allUnits, _allPlayers, (_allUnits - _allPlayers)];
  Diag_log format["[LT] (Debug) Server Debug Cycle| FPS:%1 allUnits:%2 Players:%3 AI:%4", diag_fps, _allUnits, _allPlayers, (_allUnits - _allPlayers)];
  if ("lt_debug" call bis_fnc_getParamValue == 1) then 
  {
    systemChat format["[LT] (Debug) Server Debug Cycle| FPS:%1 allUnits:%2 Players:%3 AI:%4", diag_fps, _allUnits, _allPlayers, (_allUnits - _allPlayers)];
  };
  uisleep 60;
};
