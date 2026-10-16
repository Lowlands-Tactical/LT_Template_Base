// Included by the standard LT mission parameter header, inside class Params.
// Different names from mission-bundled LTR keep existing missions loadable.
class LT_respawn_system
{
    title = "LT respawn system (requires LT command respawn template)";
    values[] = {0,1};
    texts[] = {"Standard Arma", "LTR command respawn"};
    default = 1;
};
class LT_respawn_arrival
{
    title = "LT arrival at a leader";
    values[] = {-1,0,1};
    texts[] = {"Use Eden setting", "On foot nearby", "Open parachute at 100 m"};
    default = -1;
};
