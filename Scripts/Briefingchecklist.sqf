/*

File: BriefingChecklist.sqf
Author: Brainless_Ben

Description:
Adds the checklist to the briefing section for all players.

*/

if !(hasInterface) exitWith {};

// Adds a checklist for everyone to see
player createDiaryRecord ["LT Briefing", ["Checklist", '
    <br/><font color="#FFBA26" size="18">CHECKLIST</font>

    <br/><br/><font color="#FFBA26" size="16">VOORBEREIDINGS FASE</font>
    <br/><font color="#FFBA26">Peletonscommandant met groepscommandanten - Algemeen</font>
    <br/><font color="#D7DBD5">• Teams, kleurcoderingen en callsigns intekenen op de kaart (Blueforce tracker). </font>
    <br/><font color="#D7DBD5">• Stem communicatie op de short- en longrange met elkaar af en test de longrange. </font>
    <br/><font color="#D7DBD5">• Stel een algemene 2IC aan. Bepaal daarnaast per team wie de 2IC is. </font>
    <br/><font color="#D7DBD5">• Bespreek aandachtspunten, bijvoorbeeld; contact uitroepen op longrange, reageren op AMCAS/SITREPS, geclearde huizen markeren met punt, aandachtspunten uit trainingen, etc. </font>
    <br/><font color="#D7DBD5">• Bespreek de missiedoelen en bijzonderheden. </font>
    <br/><font color="#D7DBD5">• Bepaal welke missie specifieke gereedschappen en wapensystemen meegenomen moeten worden. </font>
    <br/><font color="#D7DBD5">• Bespreek rearm, repair en respawn mogelijkheden. </font>
    <br/><font color="#D7DBD5">• Bepaal welke eventuele voertuigen er per team meegenomen worden, wat de konvooisnelheid is, wat de tussenafstand is en wat de route is. </font>

    <br/><br/><font color="#FFBA26">Peletonscommandant met groepscommandanten - Aanvalsplan:</font>
    <br/><font color="#D7DBD5">• Bepaal beweeg- en aanvalsroutes. Houdt rekening met het terrein. </font>
    <br/><font color="#D7DBD5">• Bepaal mogelijke dreigingen en ‘killing zones’. </font>
    <br/><font color="#D7DBD5">• Bepaal Release Points (RP), Linkup Points (LU), Rally Points (RLY), etc. </font>
    <br/><font color="#D7DBD5">• Controleer of de GC`s het plan begrijpen. </font>
    <br/><font color="#D7DBD5">• Laat de GC`s het plan briefen aan hun vuurteam. </font>
    <br/><font color="#D7DBD5">• Laat de GC`s omroepen als ze klaar zijn voor vertrek.  </font>

    <br/><br/><font color="#FFBA26">Groepscommandant met team:</font>
    <br/><font color="#D7DBD5">• Als GC teken je, in jouw afgesproken kleur, jouw missiespecifieke orders meer gedetailleerd in voor jouw vuurteam. </font>
    <br/><font color="#D7DBD5">• Deel de hoofd objectives, de specifieke taken, beschikbare middelen en de manier van verplaatsing van jouw vuurteam met de leden. </font>
    <br/><font color="#D7DBD5">• Maak buddyparen, geeft ze via team management gekoppelde kleuren en stel een 2IC voor het vuurteam aan (geef die extra longrange waar mogelijk). </font>
    <br/><font color="#D7DBD5">• Deel jouw verwachtingen en aandachtspunten met de leden. </font>
    <br/><font color="#D7DBD5">• Doe een short-range radiocheck en laat iedereen in (vertrek)positie komen. </font>
    <br/><font color="#D7DBD5">• Geef het door aan de Pelotonscommandant als jouw vuurteam klaar voor vertrek is. </font>

    <br/><br/><font color="#FFBA26" size="16">UITVOERINGS FASE</font>
    <br/><font color="#D7DBD5">• Verplaatsing; Bepaal de vorm van verplaatsing tussen de objectives en voer dit met de teams uit. </font>
    <br/><font color="#D7DBD5">• Contact; Geef contact door tussen de leiding en speel adequaat in op het contact. </font>
    <br/><font color="#D7DBD5">• Behoud Situational Awareness; Stem regelmatig af tussen leiding via SITREP en AMCAS. </font>
    <br/><font color="#D7DBD5">• Plan vooruit; Zorg dat de plannen voor de teams en binnen het team tijdig op de kaart staan. </font>
    <br/><font color="#D7DBD5">• Gevechtspauze; Leg 360 graden beveiliging aan, lap gewonden op, bevoorraad de teams en brief het nieuwe plannen door. </font>
    <br/><font color="#D7DBD5">• Start opnieuw met een verplaatsing of start met de afrondingsfase. </font>

    <br/><br/><font color="#FFBA26" size="16">AFRONDENDE FASE</font>
    <br/><font color="#FFBA26">Debriefing: </font>
    <br/><font color="#D7DBD5">• Er wordt teruggeblikt: Wat ging goed? Waar was er ruimte voor verbetering? Hoe kunnen we hier op inspelen? </font>
    <br/><font color="#D7DBD5">• Peletonscommandant blikt terug vanuit beleving PC. </font>
    <br/><font color="#D7DBD5">• Groepscommandanten blikken terug vanuit beleving vuurteams. </font>
    <br/><font color="#D7DBD5">• Speciale eenheden blikken terug vanuit hun beleving. </font>
    <br/><font color="#D7DBD5">• Bepaal waar nodig focuspunten voor de volgende sessie met elkaar. </font>
    <br/><font color="#D7DBD5">• De missie wordt gecalld. </font>
']];

["BriefingCheckList","Briefing finished",2] call LT_fnc_log;
