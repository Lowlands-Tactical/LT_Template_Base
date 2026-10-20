# LT_Template_Base

Basis-mod van **Lowlands Tactical** voor het maken van missies en het beheren van sessies in Arma 3.
Bevat de missie-initialisatie, het admin- en crew-tablet, safe start, Zeus-koppeling voor staff, kaartmarkers voor groepen, voertuig-respawn, supply drops, een AFK-systeem, "Deploy to group" na een respawn, keybinds en een set Eden-modules.

Werkt samen met **[LT_Template_Gear](https://github.com/Lowlands-Tactical/LT_Template_Gear)**, dat de loadouts per tijdperk levert.

- PBO-prefix: `lt_template_base`
- Versie: zie `script_version.hpp` (`MAJOR.MINOR.BUILD`). LT_Template_Gear gebruikt dezelfde versie (zie [CBA-versioning](#cba-versioning)).
- Branches: `main` is de stabiele versie, `development` is waar actief aan gewerkt wordt.

## Vereisten

| Mod | Nodig voor |
| --- | --- |
| Arma 3 (min. versie 2.14) | basis |
| CBA_A3 | verplicht (`requiredAddons`, PerFrameHandler in MapIntel, keybinds, versiecontrole) |
| ACE3 | verplicht (ACE-menu "Lowlands Tactical", arsenal, dragging) |
| ACRE2 | verplicht (radio's, spectator bij PermaDeath) |
| LT_Template_Gear | loadouts, `RoleSettings`, `westGear` e.d. worden hier gebruikt |
| LAMBS Danger (optioneel) | Defense-module (`lambs_wp_fnc_taskAssault`) |
| ALiVE (optioneel) | tabletknop "MarkUnits" (`alive_fnc_markUnits`) |

## Mapstructuur

| Map / bestand | Inhoud |
| --- | --- |
| `config.cpp` | CfgPatches, CBA-versioning (CfgSettings), CfgFunctions, CfgRemoteExec, Extended Event Handlers, notificaties en debriefings |
| `XEH_preInit.sqf` | Globale variabelen: staff/crew-lijsten (`AdminCrew`), tablet-instellingen (`TabletSettings`) |
| `XEH_postInit.sqf` | Tablet-acties en -keybinds (via `LT_fnc_menuInit`), `MissionSettings`, start van safe start |
| `script_mod.hpp`, `script_version.hpp`, `macros.inc` | Auteurs, versie, UI-macro's en kleuren |
| `cfg3DEN.hpp` | Eden-attributen (rol, voertuigtype, respawn, PermaDeath) |
| `functions/` | `LT_fnc_*` functies: safety, tijd/weer/mist, Zeus-module, teleport groep, units verwijderen, `menuInit` (ACE-menu en keybinds) |
| `functions/Afk/` | AFK-systeem (`afkInit`, `afkRequest`, `afkStart`, `afkMonitor`, e.d.) |
| `functions/RespawnGroup/` | "Deploy to group" na een respawn; het dialoog staat in `RespawnGroup/LT_RespawnGroup.hpp` |
| `functions/Resupply/` | Supply drop (aanvraag en uitvoering) |
| `functions/MapIntel/` | Groepsmarkers op de kaart voor spelers (gestart vanuit `MissionInit.sqf`, niet via `postInit`) |
| `functions/VehicleRespawn/` | Voertuig-respawn (gebaseerd op het script van Fredrik Eriksson) |
| `Modules/` | Eden-modules: UnitSpawner, CustomCompSpawner, Defense, Intel, Resupply, Convoy (convoy-scripts oorspronkelijk van negas, `.fsm` bestanden in `Modules/functions/Convoy/`) |
| `Tablet/` | Dialogen en knopacties van het admin-, advanced- en crew-tablet |
| `Scripts/` | Missie-init (`MissionInit.sqf` registreert o.a. Deploy to group, AFK en MapIntel), respawn, briefings, safe start, parachute, server-debug |
| `skills.md` | Codestandaard en werkwijze van het team (ook voor Claude, zie [Werken met Claude](#werken-met-claude)) |
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
| `lt_respawngroup` | "Deploy to group" na een respawn aan/uit |
| `lt_respawngroup_mode` | Deploy-type: naast het team of met parachute (100 m) |
| `lt_respawngroup_time` | Tijd na een respawn waarin je kunt deployen (30 s tot 5 min) |
| `lt_afk` | AFK-systeem aan/uit |

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
Alle acties staan onder het hoofdmenu **Lowlands Tactical** (ACE self-interaction). Het zijn class-acties op `CAManBase`, dus ze blijven na een respawn bestaan. `LT_fnc_menuInit` maakt het hoofdmenu en de tablet-acties; AFK en Deploy to group voegen hun eigen acties toe.

| Actie | Voor wie | Icoon |
| --- | --- | --- |
| Show Tablet | staff en als server-admin ingelogde spelers | `intel_ca` |
| Show Crew Tablet | crew en ingelogde admins | `intel_ca` |
| Teleport Group | groepsleiders, zodra de teleport door een admin is ingeschakeld | `lowtac` |
| Go AFK | spelers die niet AFK zijn en binnen 7 m van een speler van hun eigen kant staan | `connectionqualitybad_ca` |
| Back from AFK | spelers die AFK zijn | `holdaction_connect_ca` |
| Deploy to group | spelers met een open deploy-venster na een respawn | `meet_ca` |

### Keybinds
Alle keybinds staan in CBA onder *Opties > Besturing > Configure Addons > Lowlands Tactical*. Ze hebben geen standaardtoets: iedereen kan ze instellen, maar ze werken alleen voor wie de actie ook mag gebruiken. Wie dat niet mag, krijgt geen melding.

| Keybind | Doet |
| --- | --- |
| Open Staff Tablet | opent het tablet (zelfde rechten als Show Tablet) |
| Open Crew Tablet | opent het crew-tablet (zelfde rechten als Show Crew Tablet) |
| Deploy to group | opent het deploy-menu tijdens het deploy-venster |
| Toggle AFK | gaat AFK of komt terug, afhankelijk van je status |

### AFK-systeem
Parameter `lt_afk`. Wie AFK gaat is verborgen, onkwetsbaar, kan niet schieten of gooien en hangt 1,5 m achter een andere speler (de host).

- Alleen mogelijk binnen 7 m van een andere speler van je eigen kant (west, east, resistance of civilian). De groep maakt niet uit. De actie is anders verborgen en de keybind doet niets. De server controleert dit opnieuw, dus afstand overbruggen via AFK kan niet. De afstand is aan te passen met de variabele `LT_afk_radius` (standaard 7).
- Niet mogelijk in een voertuig, als je dood of bewusteloos bent.
- Host: de dichtstbijzijnde bruikbare speler van je kant binnen die afstand. Bruikbaar is een levende speler die niet bewusteloos en niet zelf AFK is. AI-units zijn geen host. Valt de host uit, dan kiest de server automatisch de dichtstbijzijnde bruikbare speler binnen 7 m van waar je op dat moment staat.
- Is er niemand binnen bereik, dan blijf je staan waar je bent tot er iemand binnen 7 m komt.
- Bij het AFK gaan krijgen alle spelers van jouw kant een korte chatmelding met je naam ("Naam went AFK"). Het is een chatbericht en geen hint, zodat de melding binnen de eigen kant blijft.
- Terugkomen: je komt in het voertuig van de host als er een plek is, anders naast hem. Daarna ben je nog 5 seconden onkwetsbaar. Zit de host in een voertuig zonder vrije plek, dan kom je terug zodra hij uitstapt.
- Server-side: `LT_fnc_afkStart` en `LT_fnc_afkEnd` controleren alles opnieuw; de client vraagt alleen aan.

### Deploy to group
Parameters `lt_respawngroup`, `lt_respawngroup_mode` en `lt_respawngroup_time`. Na een respawn (niet bij PermaDeath) is er een venster waarin je naast je team of met een parachute (100 m) naar je groep kunt. Het venster sluit na de ingestelde tijd of na één keer deployen. `LT_fnc_respawnGroupInit` heeft de modes `register`, `usable` en `unit`.

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

## CBA-versioning

Base en Gear staan samen onder één regel in de CBA-versiecontrole. In `config.cpp` van Base staat daarvoor `CfgSettings >> CBA >> Versioning >> LT_Template` met `main_addon="lt_template_base"`. `main_addon` moet de naam van een CfgPatches-class zijn (die heet `lt_template_base`), de classnaam eromheen is de naam in de lijst. `version`, `versionStr` en `versionAR` in CfgPatches komen uit `script_mod.hpp` en `script_version.hpp`; Gear gebruikt dezelfde waarden. Zonder het CfgSettings-blok negeert CBA de mod. In het RPT staat na het opstarten een regel `VERSIONING:` met onder andere `lt_template=<versie>`.

## Werken met Claude

`skills.md` bevat de codestandaard en werkwijze van het team. Laat Claude dat bestand eerst lezen voor je aan de SQF begint.

## Versie en ontwikkeling

1. Werk in de `development` branch.
2. Verhoog het versienummer in `script_version.hpp`.
3. Test op een dedicated server, niet alleen lokaal.
4. Merge naar `main` als het getest is.

## Credits

- Lowlands Tactical, met name Brainless_Ben (auteur van de template).
- Voertuig-respawn gebaseerd op het script van Fredrik Eriksson.
- Convoy-scripts oorspronkelijk van negas (externe convoy-module), aangepast door Lowlands Tactical.
