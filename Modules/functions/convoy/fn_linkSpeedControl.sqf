private ["_groupVehicles","_leaderVeh","_convoyLength","_logic","_convSeparation","_speedFrequecy","_stiffnessLinkCoeff","_speedMode","_vehicle","_vehicleInFront","_distLink","_speedLink","_linkRelaxation","_linkSpeed"];

_groupVehicles = _this select 1;

_leaderVeh = _groupVehicles select 0;
_convoyLength = count _groupVehicles;
while {!(_leaderVeh getVariable["convoy_terminate",-1])} do
{
	_logic = _this select 0;
	_convSeparation = _logic getVariable ["convSeparation",-1];
	_speedFrequecy = _logic getVariable ["speedFrequecy",-1];
	_stiffnessLinkCoeff = _logic getVariable ["stiffnessLinkCoeff",-1];
	_speedMode = _logic getVariable ["speedModeConv",-1];
	
	for [{ _i = 1 }, { _i < _convoyLength }, { _i = _i + 1 }] do {
		_vehicle = _groupVehicles select _i;
		_vehicleInFront = _groupVehicles select _i-1;
		(group _vehicle) setSpeedMode _speedMode;
		
		_distLink = (position _vehicle) distance (position _vehicleInFront);
		_speedLink = (speed _vehicle) - (speed _vehicleInFront);
		_linkRelaxation = _distLink - _convSeparation;
		
		_linkSpeed = [ (speed _vehicleInFront) +  _stiffnessLinkCoeff*(_linkRelaxation/abs(_linkRelaxation))*abs(_linkRelaxation)^(1.5) , 0, 100000 ] call BIS_fnc_clamp;
		
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
