

SanitizeTable <-
[
	{ targetname = "ferry_winch", input = "kill" },
	{ targetname = "ferry_sign", input = "kill" },
	{ targetname = "survival_ferry_button", input = "kill" },
	{ targetname = "ferry_button_proxy", input = "kill" },
	
	{ classname = "func_simpleladder", input = "kill" }, //Remove the func_ladder to the roof
	{ classname = "info_remarkable", input = "kill" } //Stop the survivors from bragging about useless stuff
];

MapSpawns <-
[
	["C3m1PlankcountryChargedodgersBarricades"]
];

MapOptions <-
{
	DefaultItems = 
	[
		"weapon_pistol_magnum"
	]
}

MapState <-
{
	StartDelay = 22
	
	NumRounds = 10
	
	Levels =
	[
		{ Round = 1, NumWaves = 5, WaveSize = 2, Interval = 5 },
		{ Round = 2, NumWaves = 5, WaveSize = 2, Interval = 3 },
		{ Round = 3, NumWaves = 5, WaveSize = 3, Interval = 5 },
		{ Round = 4, NumWaves = 5, WaveSize = 3, Interval = 3 },
		{ Round = 5, NumWaves = 10, WaveSize = 2, Interval = 2 },
		{ Round = 6, NumWaves = 10, WaveSize = 3, Interval = 3 },
		{ Round = 7, NumWaves = 2, WaveSize = 5, Interval = 1 },
		{ Round = 8, NumWaves = 5, WaveSize = 2, Interval = 1 },
		{ Round = 9, NumWaves = 5, WaveSize = 3, Interval = 1 },
		{ Round = 10, NumWaves = 5, WaveSize = 5, Interval = 5 },
	]
}