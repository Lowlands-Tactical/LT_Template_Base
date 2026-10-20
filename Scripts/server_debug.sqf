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
  
  ["Debug",format ["Server Debug Cycle| FPS:%1 allUnits:%2 Players:%3 AI:%4", diag_fps, _allUnits, _allPlayers, (_allUnits - _allPlayers)],2] call LT_fnc_log;
  uisleep 60;
};
