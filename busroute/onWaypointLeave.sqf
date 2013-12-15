private ["_driver","_message","_bus"];

_driver = _this select 0;
_message = _this select 1;
_bus = vehicle _driver;
BusMessage = [_bus, _message];
publicVariable "BusMessage";
if (!isDedicated) then
{
	["BusMessage", BusMessage] execVM "busroute\onMessageReceived.sqf";
};