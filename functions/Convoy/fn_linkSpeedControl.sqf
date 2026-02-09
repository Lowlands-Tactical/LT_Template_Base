private _groupVehicles = _this select 1;

private _leaderVeh = _groupVehicles select 0;
private _convoyLength = count _groupVehicles;
while {!(_leaderVeh getVariable["convoy_terminate",-1])} do
{
	private _logic = _this select 0;
	private _convSeparation = _logic getVariable ["convSeparation",-1];
	private _speedFrequecy = _logic getVariable ["speedFrequecy",-1];
	private _stiffnessLinkCoeff = _logic getVariable ["stiffnessLinkCoeff",-1];
	private _speedMode = _logic getVariable ["speedModeConv",-1];
	
	for [{ _i = 1 }, { _i < _convoyLength }, { _i = _i + 1 }] do {
		private _vehicle = _groupVehicles select _i;
		private _vehicleInFront = _groupVehicles select _i-1;
		(group _vehicle) setSpeedMode _speedMode;
		
		private _distLink = (position _vehicle) distance (position _vehicleInFront);
		private _speedLink = (speed _vehicle) - (speed _vehicleInFront);
		private _linkRelaxation = _distLink - _convSeparation;
		
		private _linkSpeed = [ (speed _vehicleInFront) +  _stiffnessLinkCoeff*(_linkRelaxation/abs(_linkRelaxation))*abs(_linkRelaxation)^(1.5) , 0, 100000 ] call BIS_fnc_clamp;
		
		if ( !(_leaderVeh getVariable["convoy_stopped",-1]) ) then
		{
			_vehicle forceSpeed -1;
			_vehicle limitSpeed _linkSpeed;
		}
		else
		{
			_vehicle forceSpeed 0;
		};
		_vehicle forceFollowRoad false;

	};
	sleep _speedFrequecy;
};
