if (isServer) then
{
	private _logic = _this param [0,objNull,[objNull]];
	private _groupVehicles = _this param [1,[],[[]]];

	private _leaderVeh = _groupVehicles select 0;
	_leaderVeh setVariable ["convoy_stopped", false, true];
	_leaderVeh setVariable ["convoy_terminate", false, true];
	_leaderVeh setVariable ["convoy_behaviourChanged", false, true];	// Note: used to fix some unknown bug with the module (can be set to true on script execution)

	// call the "driver changes system" for each vehicle
	// writes --> On Each Vehicle: 	{"driverIncapacitated", "vehicleIncapacitated","terminate_driverTransitions"}
	// reads -->  On Each Vehicle: 	{"terminate_driverTransitions"}
	for [{ _i = 0 }, { _i < count _groupVehicles }, { _i = _i + 1 }] do
	{
		call{ null = [_groupVehicles select _i] execFSM "\lt_template_base\functions\Convoy\fn_driverTransitions.fsm" };
	};

	call { null = [_logic,_groupVehicles] execFSM "\lt_template_base\functions\Convoy\fn_dynamicConvoyElements.fsm" };
	call { null = [_logic,_groupVehicles] execFSM "\lt_template_base\functions\Convoy\fn_behaviorManager.fsm" };
	call { null = [_logic,_groupVehicles] execVM "\lt_template_base\functions\Convoy\fn_leadSpeedControl.sqf" };
	call { null = [_logic,_groupVehicles] execVM "\lt_template_base\functions\Convoy\fn_linkSpeedControl.sqf" };
	call { null = [_logic,_groupVehicles] execVM "\lt_template_base\functions\Convoy\fn_pathCreator.sqf" };
};

true