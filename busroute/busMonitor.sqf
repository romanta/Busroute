private ["_updateTime"];

_updateTime = 60;

while {true} do
{
	sleep _updateTime;
	
	private ["_iX"];
	for [{_iX = 0}, {_iX < count TourBusses}, {_iX = _iX + 1}] do
	{
		private ["_tourBus"];
		_tourBus = ((TourBusses select _iX) select 0);
		_tourBus setFuel 1;
	};
};