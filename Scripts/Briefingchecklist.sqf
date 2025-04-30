/*

File: BriefingChecklist.sqf
Author: Brainless_Ben

Description:
Adds the checklist to the briefing section for all players.

*/

// Adds a checklist for everyone to see
player createDiaryRecord ["H3 Menu", ["Checklist","<br/>
<b>De PC/GC:</b><br/>
- Is er een 2ic?<br/>
- Is de intentie van de missie duidelijk?<br/>
- Zijn de stappen en de reis nodig duidelijk?<br/>
- Zijn de benodigde assets aanwezig<br/>
- Kunnen al deze assets benaderd worden<br/>
- Kan de reis van A naar B veilig gemaakt worden en wat zijn de gevaren?<br/>
- Is er een ERV?<br/>
- Is dit gecommuniceerd?<br/>
<br/>
<br/>
<b>De VTL:</b><br/>
- Doen de radios van de groepsleden het (Radio check)?<br/>
- Doet de long-range radio het?<br/>
"]];

Diag_log "[LT] (BriefingCheckList) briefing finished";
if (["lt_debug",0] call bis_fnc_getParamValue == 1) then 
{
    systemchat "[LT] (BriefingCheckList) briefing finished";
};
