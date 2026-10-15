# LT_Template_Base

Basis-mod van **Lowlands Tactical** voor het maken van missies en het beheren van sessies in Arma 3.
Bevat de missie-initialisatie, het admin- en crew-tablet, safe start, Zeus-koppeling voor staff, kaartmarkers voor groepen, voertuig-respawn, supply drops en een set Eden-modules.

Werkt samen met **[LT_Template_Gear](https://github.com/Lowlands-Tactical/LT_Template_Gear)**, dat de loadouts per tijdperk levert.

- PBO-prefix: `lt_template_base`
- Versie: zie `script_version.hpp` (`MAJOR.MINOR.BUILD`)
- Branches: `main` is de stabiele versie, `development` is waar actief aan gewerkt wordt.

## Vereisten

| Mod | Nodig voor |
| --- | --- |
| Arma 3 (min. versie 2.14) | basis |
| CBA_A3 | verplicht (`requiredAddons`, PerFrameHandler in MapIntel) |
| ACE3 | verplicht (ACE-menu, arsenal, dragging) |
| ACRE2 | verplicht (radio's, spectator bij PermaDeath) |
| LT_Template_Gear | loadouts, `RoleSettings`, `westGear` e.d. worden hier gebruikt |
| LAMBS Danger (optioneel) | Defense-module (`lambs_wp_fnc_taskAssault`) |
| ALiVE (optioneel) | tabletknop "MarkUnits" (`alive_fnc_markUnits`) |

## Mapstructuur

| Map / bestand | Inhoud |
| --- | --- |
| `config.cpp` | CfgPatches, CfgFunctions, CfgRemoteExec, Extended Event Handlers, notificaties en debriefings |
| `XEH_preInit.sqf` | Globale variabelen: staff/crew-lijsten (`AdminCrew`), tablet-instellingen (`TabletSettings`) |
| `XEH_postInit.sqf` | ACE-menu "Lowlands Tactical", `MissionSettings`, start van safe start |
| `script_mod.hpp`, `script_version.hpp`, `macros.inc` | Auteurs, versie, UI-macro's en kleuren |
| `cfg3DEN.hpp` | Eden-attributen (rol, voertuigtype, respawn, PermaDeath) |
| `functions/` | `LT_fnc_*` functies: safety, tijd/weer/mist, Zeus-module, teleport groep, units verwijderen |
| `functions/Resupply/` | Supply drop (aanvraag en uitvoering) |
| `functions/MapIntel/` | Groepsmarkers op de kaart voor spelers |
| `functions/VehicleRespawn/` | Voertuig-respawn (gebaseerd op het script van Fredrik Eriksson) |
| `Modules/` | Eden-modules: UnitSpawner, CustomCompSpawner, Defense, Intel, Resupply, Convoy |
| `Tablet/` | Dialogen en knopacties van het admin-, advanced- en crew-tablet |
| `Scripts/` | Missie-init, respawn, briefings, safe start, parachute, server-debug |
| `Reference/` | Voorbeeldbestanden voor `description.ext` van een missie |
| `Faces/`, `logos/` | Gezichten en afbeeldingen |

## Gebruik in een missie

### description.ext
In `Reference/` staan twee bestanden om in de `description.ext` van een missie op te nemen:

- `descriptionTemplate.hpp`: algemene missie-instellingen (HUD, corpse manager, kanalen, debug console).
- `descriptionMission.hpp`: de missieparameters (zie hieronder). De standaardwaarden zijn aan te passen met `#define` voordat je het bestand includet, bijvoorbeeld `MISSION_TIMER`, `MISSION_WEATHER`, `MISSION_FOG`.

### Missieparameters

| Parameter | Betekenis |
| --- | --- |
| `lt_fatigue_onoff` | Vermoeidheid aan/uit |
| `lt_markers` | Groepsmarkers (MapIntel) aan/uit |
| `lt_debug` | Debugberichten in de chat en RPT |
| `lt_param_timeOfDay` | Tijdstip (24 = missie-instelling) |
| `lt_param_weather` | Weer (9 = missie-instelling) |
| `lt_param_fog` | Mist |
| `lt_param_timer` | Safe-start timer in minuten (0 = geen timer) |

De gear-parameters (camouflage, wapens, radio's, NVG, attachments) komen uit LT_Template_Gear.

### Eden-attributen
Na het laden van de mod zijn er extra attributen in Eden:

- **Soldier settings** (per unit): rol, navigatie (kaart/GPS/kijker), consumables, rolspecifieke items en wapens/munitie.
- **Vehicle settings** (per voertuig): kant, type lading, respawn en respawn-vertraging, kant van drone-bemanning.
- **Scenario**: tijdperk (uit LT_Template_Gear) en PermaDeath.

### Eden-modules
Onder de categorie *Lowlands Tactical Modules*: UnitSpawner, CustomCompSpawner, Defense, Intel, Resupply en Convoy.

## Beheer tijdens sessies

### ACE-selfmenu "Lowlands Tactical"
- **Show Tablet**: voor staff en voor spelers die als server-admin zijn ingelogd.
- **Show Crew Tablet**: voor crew en ingelogde admins.
- **Teleport Group**: voor groepsleiders, zodra de teleport door een admin is ingeschakeld.

### Tablet
Het tablet bevat onder meer safe start aan/uit, vermoeidheid, verbergen, groepsteleport, Zeus openen, ACE-arsenal, genezen, supply drops, voertuig- en cratelading en het beëindigen van de missie met een einde naar keuze.

### Safe start
Bij een ingestelde timer zijn spelers onkwetsbaar en worden afgevuurde projectielen verwijderd. De server telt de timer per minuut af, waarna de safe start eindigt. Admins kunnen de timer via het tablet of de briefing verlengen, verkorten, starten of stoppen.

### Zeus
`LT_fnc_adminZeusModule` maakt voor elk staff-lid een curator-module aan en koppelt die zodra het staff-lid online is.

## Staff en crew instellen

De lijsten met Steam64-ID's staan in `XEH_preInit.sqf` (`_lt_staff` en `_lt_crew`). Voeg een ID toe met een commentaar met de naam erachter. De debug console in `descriptionTemplate.hpp` heeft een eigen lijst.

## Debuggen

Zet de parameter `lt_debug` op `True`. Alle berichten beginnen met `[LT]` en staan ook in het RPT-bestand. De server toont met een marker FPS en aantal units.

## Versie en ontwikkeling

1. Werk in de `development` branch.
2. Verhoog het versienummer in `script_version.hpp`.
3. Test op een dedicated server, niet alleen lokaal.
4. Merge naar `main` als het getest is.

## Credits

- Lowlands Tactical, met name Brainless_Ben (auteur van de template).
- Voertuig-respawn gebaseerd op het script van Fredrik Eriksson.
