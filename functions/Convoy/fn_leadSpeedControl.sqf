private _groupVehicles = _this select 1;

private _leaderVeh = _groupVehicles select 0;
private _convoyLength = count _groupVehicles;

while {!(_leaderVeh getVariable["convoy_terminate",-1])} do
{
	private _logic = _this select 0;
	private _maxDefSpeed = _logic getVariable ["maxSpeed",-1];
	private _convSeparation = _logic getVariable ["convSeparation",-1];
	private _speedFrequecy = _logic getVariable ["speedFrequecy",-1];
	private _debugDraw = _logic getVariable ["debug",-1];
	private _dampingCoeff = _logic getVariable ["dampingCoeff",-1];
	private _curvatureCoeff = _logic getVariable ["curvatureCoeff",-1];
	private _stiffnessCoeff = _logic getVariable ["stiffnessCoeff",-1];
	private _followRoad = _logic getVariable ["followRoad",false];
	private _speedMode = _logic getVariable ["speedModeConv",-1];
	private _behaviour = _logic getVariable ["behaviourConv",-1];
	
	switch (_followRoad) do
	{
		case "UNCHANGED":	{ };
		case "NO": 			{ _leaderVeh forceFollowRoad false; };
		case "YES": 		{ _leaderVeh forceFollowRoad true; };
		default {};
	};
	(group _leaderVeh) setSpeedMode _speedMode;
	
	private _arrayDistances = [];
	private _arrayRotations = [];
	private _arraySpeeds = [];
	for [{ _i = 1 }, { _i < _convoyLength }, { _i = _i + 1 }] do
	{
		_vehicle = _groupVehicles select _i;
		_vehicleInFront = _groupVehicles select _i-1;
		_arrayDistances set [_i-1, _vehicle distance _vehicleInFront];
		_arrayRotations set [_i-1, abs( (getDir _vehicle) - (getDir _vehicleInFront) )];
		_arraySpeeds set [_i-1, abs( (speed _vehicle) - (speed _vehicleInFront) )];
	};
	
	private _avrDistance = 0;
	private _convoyRelaxation = 0;
	private _convoyCurvature = 0;
	private _convoyEntropy = 0;
	
	if (count _arrayDistances > 0) then
	{
		_avrDistance = _arrayDistances call BIS_fnc_arithmeticMean;
		_convoyRelaxation = [_avrDistance - _convSeparation, 0, 100000] call BIS_fnc_clamp;
		_convoyCurvature = _arrayRotations call BIS_fnc_arithmeticMean;
		_convoyEntropy = _arraySpeeds call BIS_fnc_arithmeticMean;
	};
	
	private _maxSpeed = 0;
	if (_maxDefSpeed > 0 ) then
	{
		_maxSpeed = _maxDefSpeed - ([_stiffnessCoeff*_convoyRelaxation^(1.5) + _curvatureCoeff*( [_convoyCurvature, 0, 45] call BIS_fnc_clamp ) + _dampingCoeff*_convoyEntropy,0, _maxDefSpeed-5] call BIS_fnc_clamp );
	};
	
	if (_maxDefSpeed > 0 && !(_leaderVeh getVariable["convoy_stopped",-1]) ) then
	{
		_leaderVeh forceSpeed -1;
		_leaderVeh limitSpeed _maxSpeed;
	}
	else
	{
		_leaderVeh forceSpeed 0;
	};
	
	if (_debugDraw) then
	{
		hint format["maxSpeed = %1 \n avrDistance = %2 \n _convoyCurvature = %3 \n _convoyEntropy = %4",_maxSpeed,_avrDistance,_convoyCurvature,_convoyEntropy];
	};

	sleep _speedFrequecy;
};
