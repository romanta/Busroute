private ["_driver","_message","_bus"];

_driver = _this select 0;
_message = _this select 1;
_bus = vehicle _driver;
_driver setBehaviour "STEALTH";
_driver action ["lightOff", _bus];
sleep 1;
BusLogic action ["useWeapon", _bus, _driver, 0];
_driver setBehaviour "CARELESS";
_driver action ["lightOn", _bus];
sleep 1;
BusLogic action ["useWeapon", _bus, _driver, 0];
_driver setBehaviour "STEALTH";
_driver action ["lightOff", _bus];
sleep 1;
BusLogic action ["useWeapon", _bus, _driver, 0];
_driver setBehaviour "CARELESS";
_driver action ["lightOn", _bus];
BusMessage = [_bus, _message];
publicVariable "BusMessage";
if (!isDedicated) then
{
	["BusMessage", BusMessage] execVM "busroute\onMessageReceived.sqf";
};