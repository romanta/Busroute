private ["_driver","_bus"];

_driver = _this select 0;
_bus = vehicle _driver;
BusLogic action ["useWeapon", _bus, _driver, 0];
sleep 1;
BusLogic action ["useWeapon", _bus, _driver, 0];