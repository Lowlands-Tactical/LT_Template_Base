// UI text only. A stale preview never enables spawning, even when a placement is pending.
params ["_lastList", "_pending", "_message", "_reason", "_hasSelection", ["_now", diag_tickTime], ["_hasOptions", true]];
if (_lastList < 0) exitWith {"Wachten op server: opties worden opgehaald…"};
if (_now - _lastList >= 5) exitWith {"Geen recente serverreactie. Opties worden vernieuwd…"};
if (_pending) exitWith {"Veilige plek wordt gecontroleerd…"};
if (_message != "") exitWith {_message};
if (_reason != "") exitWith {_reason};
if (_hasSelection) exitWith {"Deze locatie is beschikbaar. Klik op Spawn om terug te keren."};
if (!_hasOptions) exitWith {"Geen PC/GC/VTL of respawnlocatie beschikbaar. Wacht op nieuwe opties."};
"Kies je PC/GC/VTL of een basislocatie. Leiding kan ook andere leiding kiezen."
