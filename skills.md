# Lowlands Tactical Arma 3 template: standard and working method

The team maintains an Arma 3 mod pair, LT_Template_Base and LT_Template_Gear, plus mission templates. Dependencies: CBA, ACE, ACRE. Talk to the user in Dutch unless they write in another language. Code and code comments are always English.

## Coding standard (SQF)

1. **One function per file**, named `fn_<name>.sqf`, registered in `config.cpp` under `CfgFunctions` (class `LT`). Called as `LT_fnc_<name>`. Do not use `execVM` on files: register a function and `call` it (unscheduled) or `spawn` it (when it needs `sleep`/`waitUntil`).
2. **Header comment** in every function: File, Author (plus `Original author` when the code comes from someone else, never drop their credit), Description, Parameters, Return.
3. **Variables:** one single `private ["_a","_b"];` array at the top of the function, before `params`. No inline `private _x = ...`. Loop variables of `for "_i" from ... to ...` do not need to be listed.
4. **Parameters:** `params` with defaults and type checks, for example `params [["_logic", objNull, [objNull]]]`. Never `_this select n`.
5. **Conditions:** use full parentheses instead of lazy `{}`: `if ((_a) && (_b)) then {...}`, `_restricted = ((_x in _a) || (_x in _b));`. Only use a nested `if` where eager evaluation would raise an error (for example `alive _veh` on a variable that may be nil).
6. **Several modes:** use `switch (_mode) do` that fills a `_result` variable, with a `default` that logs. Not a chain of `if ... exitWith`.
7. **Logging:** `["Name", "message", 2] call LT_fnc_log;` instead of `diag_log`/`systemChat`. Do not log in per-frame or per-second loops.
8. **getVariable defaults** match the type that is expected (`false` for booleans, not `-1`).
9. **Networking:** only use the broadcast flag of `setVariable` when other machines read it. Custom functions that are `remoteExec`'d must be in `CfgRemoteExec` (mode 1 whitelist) with the right `allowedTargets`; `BIS_fnc_*` and commands need no entry.
10. **Do not use `postInit=1`** in `CfgFunctions` for things that belong in the mission. Mission setup is done from `MissionInit.sqf` (guarded by the mission parameters) so the mod does nothing in missions that do not use the template.
11. Mission options go through `description.ext` params (`Reference/descriptionMission.hpp`) and are read with `BIS_fnc_getParamValue`.
12. **ACE actions and keybinds:** every player action goes under the ACE self-interaction menu "Lowlands Tactical" (parent path `["ACE_SelfActions", "lt_main"]`). Call `["main"] call LT_fnc_menuInit` first (idempotent) so the parent exists. Add them as class actions with `ace_interact_menu_fnc_addActionToClass ["CAManBase", 1, ...]`, not `addActionToObject` on `player` (that is lost after a respawn). Use a fitting vanilla icon from the unpacked game data (`\a3\ui_f\data\...`), check that the .paa exists before using it, and keep `lowtac.paa` for the main menu. Every action also gets a CBA keybind via `CBA_fnc_addKeybind` in the category "Lowlands Tactical", without a default key (`[0, [false, false, false]]`), with the same condition as the action and silent when the player is not allowed. Two opposite actions (go AFK / back from AFK) share one toggle keybind: the same key on two keybinds gives a warning in CBA.
13. **CBA versioning:** a mod only shows up in the CBA version check with a block `CfgSettings >> CBA >> Versioning >> <Name> {main_addon = "<CfgPatches class>"; removed[] = {};}` next to `version`, `versionStr` and `versionAR` in CfgPatches. `main_addon` must be the name of a CfgPatches class. Base and Gear share one version, so only Base has the block (`LT_Template`).
14. Keep CRLF line endings and tabs/spaces as the file already has them.

## Arma/ACE/CBA facts that bit us

- `hideObjectGlobal` is binary and server-side: `_unit hideObjectGlobal true`.
- ACE has no `blockFire` status effect. Registered effects include forceWalk, blockSprint, setCaptive, blockDamage, blockEngine, blockThrow, setHidden, blockRadio, blockSpeaking, disableWeaponAssembly, lockInventory, disableCollision. Block shooting with a `FiredMan` event handler (delete the projectile, give the round back) and use `blockThrow` for grenades.
- Inside `forEach` loops, `_forEachIndex` is shadowed by an inner `forEach`; copy it to a variable first.
- In `listnbox` controls, set `colorText` (white) and `colorSelect` in the config, then colour cells with `lnbSetColor`/`lnbSetColorRight`.
- Code that uses `sleep` must be scheduled (`spawn`). FSM code is unscheduled: wait with a time condition, never `sleep`.
- Check ACE/CBA claims against the source before stating them.
- `sgn` does not exist in SQF. Use `[-1, 1] select (_x >= 0)`.
- A client with a different mod version than the server is caught by CBA versioning only when the mod has the Versioning block (rule 13).

## Working method

- Read the real repo files before changing them. Do not rebuild a file from memory or from a truncated earlier output.
- When the user asks for suggestions or a review, answer with findings first and wait for agreement before editing the repo.
- Make small, reviewable changes and keep the existing behaviour unless the user asks otherwise. Mention behaviour that looks like a bug but leave it unless asked.
- When files are written to the repo directly, tell the user which files changed so they can review the diff in GitHub Desktop. When the repo is not reachable, send only the changed files.
- For a new feature also give: config snippets (`CfgFunctions`, `CfgRemoteExec`, params), a short test plan (single player, dedicated server, JIP, respawn) and known risks.
- Credit the original author of external code (for example the convoy scripts are by negas) and keep the licence information.
- Never invent features of Arma, ACE or CBA: verify, or say that it is untested.
- After writing a file to the user's drive through the device bridge, check the result: list the folder and compare the size and modification time with what was written. A "written" reply is not proof, and the user may have the file open in an editor (tell them to reload it). Before overwriting, use the modification time of the last read as a guard, and read the file again first when the user may have changed it.
- When an RPT is attached, search it for script errors and for the lines that show whether a feature loaded (for example `VERSIONING:`), instead of reading it whole.
- Test plan after a change: single player, dedicated server, JIP and respawn; say plainly what was not tested in the game.
