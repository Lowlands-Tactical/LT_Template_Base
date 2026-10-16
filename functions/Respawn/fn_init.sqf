if (!(missionNamespace getVariable ["LTR_addonOwned", false]) || {!LTR_selected}) exitWith {};
if (missionNamespace getVariable ["LTR_started", false]) exitWith {};
LTR_started = true;
if (LTR_permaDeath) exitWith {
	// Keep LT's permadeath spectator flow: the custom template must not auto-recreate a living player.
	if (hasInterface) then {
		[] spawn {
			waitUntil {!isNull player};
			player addEventHandler ["Killed", {setPlayerRespawnTime 1e9}];
		};
	};
};
// Standard Arma mode never freezes players, creates holding markers or defers respawn.
if (!LTR_enabled) exitWith {};
if (isServer) then {
	{
		if (getMarkerColor _x == "") then {createMarker [_x, LTR_holdingPosition]};
		_x setMarkerPos LTR_holdingPosition;
		_x setMarkerAlpha 0;
	} forEach LTR_holdingMarkers;
	addMissionEventHandler ["EntityRespawned", {
		params ["_unit", "_corpse"];
		if (isPlayer _unit && {_unit isKindOf "CAManBase"}) then {
			[_corpse] call LTRespawn_fnc_clearPlacement;
			[_unit] call LTRespawn_fnc_clearPlacement;
			// LT's slot role is needed on the server, including on a player's second death.
			if (isNil {_unit getVariable "LT_unit_role"}) then {
				_unit setVariable ["LT_unit_role", _corpse getVariable ["LT_unit_role", ""], true];
			};
			_unit setVariable ["LTR_active", false, true];
			_unit setVariable ["LTR_waiting", true];
			_unit setVariable ["LTR_registered", true];
			_unit hideObjectGlobal true;
			_unit enableSimulationGlobal false;
		};
	}];
	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit"];
		// A reconnect may reuse the same playable object. It must be allowed back into holding.
		_unit setVariable ["LTR_active", false, true];
		_unit setVariable ["LTR_registered", false];
		[_unit] call LTRespawn_fnc_clearPlacement;
		false
	}];
};
if (hasInterface) then {
	[] spawn {
		waitUntil {!isNull player};
		if (!(player isKindOf "CAManBase")) exitWith {};
		if (didJIP) then {
			[player, objNull] call LTRespawn_fnc_begin;
		} else {
			[player, "register"] remoteExecCall ["LTRespawn_fnc_request", 2];
		};
	};
};
