// Public helper for mission triggers. Missing registration is inactive only while LTR is enabled.
params ["_unit"];
alive _unit && {_unit getVariable ["LTR_active", !(missionNamespace getVariable ["LTR_enabled", false])]}
