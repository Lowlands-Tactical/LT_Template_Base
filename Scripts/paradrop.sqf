/*

File: Paradrop.sqf
Author: Lowlands Tactical

Description:
If conditions are met players wil be airdropped.

Example:
[] execVM "\lt_template_base\Scripts\paradrop.sqf";

*/

if (local player) then 
{
    if !(((vehicle player) isKindOf "Air") && (((position player) select 2) > 100) && (player != driver (vehicle player))) exitWith 
    {
        ["Paradrop",format ["%1 is not ready to paradrop", name player],1] call LT_fnc_log;
    };

    player allowdamage false;
    MoveOut player;
    
    waituntil {sleep 0.5; (getpos player select 2) < 200};
    _chute = createVehicle ["Steerable_Parachute_F", (getPos player), [], 0, "NONE"];
    _chute setVelocity (velocity player);
    _chute setPos (getPos player);
    _chute setDir (getDir player);
    player moveInDriver _chute;

    waituntil {sleep 0.5; isTouchingGround player};
    player allowDamage true;

    ["Paradrop",format ["%1 has landed", name player],2] call LT_fnc_log;
};
