// Use LT's explicit slot role, never rank or automatic group leadership.
params ["_unit"];
switch (toLower (_unit getVariable ["LT_unit_role", ""])) do {
	case "com": {"PC"};
	case "sql": {"GC"};
	case "ftl": {"VTL"};
	default {""};
}
