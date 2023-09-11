private ["_fog","_strength","_decay","_base"];
_fog = param [0, 4, [4]];

if (_fog == 4) exitWith {};
_transition = if (count _this > 1) then {_this select 1} else {0};
_strength = 0;
_decay = 0;
_base = 0;

switch (_fog) do
{
	case 0:
	{
		_strength = 0;
		_decay = 0;
		_base = 0;
	};
	case 1:
	{
		_strength = 0.2;
		_decay = 0;
		_base = 0;
	};
	case 2:
	{
		_strength = 0.4;
		_decay = 0;
		_base = 0;
	};
};

_transition setFog [_strength,_decay,_base];
