// Mission-bundled versions own their initialization until that mission is migrated.
if (isClass (missionConfigFile >> "CfgFunctions" >> "LTR")) exitWith {};
LTR_addonOwned = true;
// Keep the documented mission API without colliding with bundled LTR CfgFunctions.
LTR_fnc_isActive = LTRespawn_fnc_isActive;
LTR_fnc_registerVehicle = LTRespawn_fnc_registerVehicle;
LTR_fnc_enemyNear = LTRespawn_fnc_enemyNear;
LTR_selected = "LTR_Teammate" in getMissionConfigValue ["respawnTemplates", []];
LTR_enemyRadius = getMissionConfigValue ["LT_RespawnEnemyRadius_ID", 50];
LTR_warningRadius = getMissionConfigValue ["LT_RespawnWarningRadius_ID", 100];
if (!(LTR_enemyRadius isEqualType 0) || {!finite LTR_enemyRadius} || {LTR_enemyRadius < 0}) then {LTR_enemyRadius = 50};
if (!(LTR_warningRadius isEqualType 0) || {!finite LTR_warningRadius} || {LTR_warningRadius < LTR_enemyRadius}) then {LTR_warningRadius = 100 max LTR_enemyRadius};
LTR_permaDeath = getMissionConfigValue ["LT_PermaDeath_ID", 0] != 0;
LTR_enabled = LTR_selected && {!LTR_permaDeath} && {(["LT_respawn_system", 1] call BIS_fnc_getParamValue) == 1};
private _arrival = ["LT_respawn_arrival", -1] call BIS_fnc_getParamValue;
if (_arrival == -1) then {_arrival = getMissionConfigValue ["LT_RespawnArrival_ID", 0]};
LTR_parachute = LTR_enabled && {_arrival == 1};
LTR_holdingPosition = [worldSize + 2000, worldSize + 2000, 1000];
LTR_holdingMarkers = ["west", "east", "guerrila", "civilian"] apply {"respawn_" + _x + "_LTR_holding"};
LTR_token = 0;
LTR_menuSnapshot = [];
LTR_vehicleRecords = [];
