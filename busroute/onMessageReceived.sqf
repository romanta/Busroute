private ["_message","_bus"];

_data = _this select 1;
_bus = _data select 0;
_message = _data select 1;
if (_bus == (vehicle player)) then
{
	_bus vehicleChat _message;
};