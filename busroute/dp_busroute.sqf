// V1.0 
//Modified version of Bus route script from Andrew Gregory aka axeman axeman@thefreezer.co.uk
//got from opendayz.net
//Modifications made by www.die-philosoffen.com clan. Member: dp.wofu
//Changes: 
//No AI retaliation troop
//invulnerable bus and driver
//multiple buses possible
//working Horn (thx for codeexamples axeman)
//working messages (for a few people - dont work on our servers)

if (isServer) then
{
	private["_bussesToSpawn","_waitTime","_warnTime","_arriveTime","_tmp","_waypoints","_iX","_logicSide","_logicGroup"];
	
	// ------------------------------
	// ---- CONFIGURATION BEGIN -----
	// ------------------------------
	
	// How many busses to spawn.
	_bussesToSpawn = 3;
	// How long to wait on each waypoint.
	_waitTime = 30;
	// How many seconds before bus is leaving to sound a warning.
	_warnTime = 10;
	
	// ------------------------------
	// ---- CONFIGURATION END -------
	// ------------------------------
	
	TourBusses = [];
	BusMessage = [];
	BusLogic = objNull;
	
	if (_waitTime <= _warnTime) then
	{
		_warnTime = floor (_waitTime / 2);
	};
	
	_arriveTime = _waitTime - _warnTime;
	
	//_tmp = createCenter resistance;
	
	_waypoints = [
		[[1232.99,2400.28],94.2595,"Kamenka Endstation"],
		[[1849.65,2223.70],66.2114,"Kamenka"],
		[[3564.64,2445.08],70.9245,"Komarovo"],
		[[4537.86,2437.95],108.488,"Balota"],
		[[6354.16,2448.34],8.01707,"Chernogorsk West"],
		[[6414.79,2684.85],40.4489,"Chernogorsk Zentrum"],
		[[6578.11,2876.51],45.4382,"Chernogorsk Ost"],
		[[7973.03,3172.10],76.3331,"Prigorodki"],
		[[9983.58,2057.84],74.0263,"Elektrozavodsk West"],
		[[10316.1,2148.90],76.3229,"Elektrozavodsk Zentrum"],
		[[10416.3,2256.56],36.0067,"Elektrozavodsk Ost"],
		[[12025.2,3482.21],82.4902,"Kamyshovo"],
		[[13002.4,3806.99],56.1915,"Skalisty Island"],
		[[13386.8,5404.67],0.04653,"Three Valleys"],
		[[13464.0,6255.45],7.52361,"Solnichniy"],
		[[13279.4,6990.24],333.289,"Solnichniy Factory"],
		[[12982.8,8362.30],341.781,"Nizhnoye"],
		[[12963.1,9810.21],11.0892,"Berezino Hafen"],
		[[13111.0,10366.5],19.0125,"Berezino"],
		[[12965.2,10421.9],310.110,"Berezino Endstation"],
		[[13062.2,10243.8],198.371,"Berezino"],
		[[12957.5,9807.68],191.384,"Berezino Hafen"],
		[[12978.1,8358.54],161.904,"Nizhnoye"],
		[[13288.2,6959.98],152.906,"Solnichniy Factory"],
		[[13452.7,6212.68],187.972,"Solnichniy"],
		[[13382.0,5447.48],181.080,"Three Valleys"],
		[[12998.4,3811.38],236.962,"Skalisty Island"],
		[[12020.2,3487.01],262.555,"Kamyshovo"],
		[[10420.6,2269.69],225.978,"Elektrozavodsk Ost"],
		[[10314.6,2154.73],256.581,"Elektrozavodsk Zentrum"],
		[[10043.5,2080.38],256.954,"Elektrozavodsk West"],
		[[7964.28,3179.21],276.835,"Prigorodki"],
		[[6594.34,2897.61],231.890,"Chernogorsk Ost"],
		[[6408.92,2686.10],218.541,"Chernogorsk Zentrum"],
		[[6348.55,2448.82],190.014,"Chernogorsk West"],
		[[4551.05,2439.60],288.533,"Balota"],
		[[3560.80,2449.60],250.831,"Komarovo"],
		[[1832.82,2222.21],243.797,"Kamenka"]
	];
		
	
	for [{_iX = 0}, {_iX < _bussesToSpawn}, {_iX = _iX + 1}] do
	{
		private ["_tourBus","_tourBusDriver","_busGroup","_iWpStart","_pos","_dir","_iWp","_jX"];
		
		_tourBus = objNull;
		_tourBusDriver = objNull;
		_busGroup = createGroup resistance;
		
		// Get the index of the current bus' first waypoint.
		_iWpStart = floor ((((count _waypoints) - 1) / _bussesToSpawn) * _iX);
		// Use the first waypoint as the start-point.
		_pos = ((_waypoints select _iWpStart) select 0) + [0];
		_dir = ((_waypoints select _iWpStart) select 1);
		
		_tourBus = "Ikarus_TK_CIV_EP1" createVehicle _pos;
		_tourBus setDir _dir;
		
		_iWp = _iWpStart;
		for [{_jX = 0}, {_jX <= (count _waypoints)}, {_jX = _jX + 1}] do
		{
			private ["_wpArrive","_wpMid","_wpLeave"];
			
			_wpArrive = _busGroup addWayPoint [((_waypoints select _iWp) select 0), 0];
			if (_jX == (count _waypoints)) then
			{
				_wpArrive setWaypointType "CYCLE";
			}
			else
			{
				_wpArrive setWaypointType "MOVE";
			};
			_wpArrive setWaypointSpeed "FULL";
			_wpArrive setWaypointStatements ["true", format ["[this,""%1""] execVM ""busroute\onWaypointArrive.sqf"";", ((_waypoints select _iWp) select 2)]];
			
			_wpMid = _busGroup addWayPoint [((_waypoints select _iWp) select 0), 0];
			_wpMid setWaypointType "MOVE";
			_wpMid setWaypointTimeout [_arriveTime, _arriveTime, _arriveTime];
			_wpMid setWaypointStatements ["true", format ["[this] execVM ""busroute\onWaypointMid.sqf"";", ((_waypoints select _iWp) select 2)]];
			
			_wpLeave = _busGroup addWayPoint [((_waypoints select _iWp) select 0), 0];
			_wpLeave setWaypointType "MOVE";
			_wpLeave setWaypointTimeout [_warnTime, _warnTime, _warnTime];
			_iWp = (_iWp + 1) % (count _waypoints);
			_wpLeave setWaypointStatements ["true", format ["[this,""NAECHSTER HALT: %1""] execVM ""busroute\onWaypointLeave.sqf"";", ((_waypoints select _iWp) select 2)]];
		};
	
		// DayZ-Specific
		_tourBus setVariable ["ObjectID", [getDir _tourBus, getPos _tourBus] call dayz_objectUID2, true];
		_tourBus call fnc_vehicleEventHandler;
		// dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_tourBus];
		
		//Uncomment for normal dayZ
		//dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_tourBus];
		//For Epoch - Comment out for normal dayZ | Credit to Flenz
		PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_tourBus];
		[_tourBus,"Ikarus_TK_CIV_EP1"] spawn server_updateObject;
		

		"BAF_Soldier_L_DDPM" createUnit [getPos _tourBus, _busGroup, "_tourBusDriver=this;",1,"Private"];
		_tourBusDriver disableAI "TARGET";
		_tourBusDriver disableAI "AUTOTARGET";
		_tourBusDriver disableAI "FSM";
		_tourBusDriver setIdentity "TourBusDriver";
		
		_busGroup selectLeader _tourBusDriver;
		_busGroup setBehaviour "CARELESS";
		_tourBusDriver assignAsDriver _tourBus;
		_tourBusDriver moveInDriver _tourBus;
		
		_tourBus lockDriver true;
		_tourBus allowDamage false;
		_tourBusDriver allowDamage false;
		_tourBusDriver action ["lightOn", _tourBus];
		
		TourBusses = TourBusses + [[_tourBus, _tourBusDriver]];
	};	
	
	[] spawn { [] execVM "busroute\busMonitor.sqf"; };
	
	_logicSide = createCenter sideLogic;
	_logicGroup = createGroup sideLogic;
	"LOGIC" createUnit [[0,0,0], _logicGroup, "BusLogic=this;", 1, "PRIVATE"];
	onPlayerConnected "publicVariable ""TourBusses""";
	publicVariable "TourBusses";	
}
else
{
	private ["_bus", "_driver"];
	waitUntil {!(isNil "TourBusses")};
	{
		_bus = _x select 0;
		_driver = _x select 1;
		
		_bus allowDamage false;
		_driver allowDamage false;
	} foreach TourBusses;
	"BusMessage" addPublicVariableEventHandler { [_this select 1] execVM "busroute\onMessageReceived.sqf"; };
};