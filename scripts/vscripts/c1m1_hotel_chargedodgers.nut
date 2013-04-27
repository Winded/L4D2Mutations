

SanitizeTable <-
[
	{ classname = "func_door_rotating", input = "kill" }, //Remove the usable door
	{ classname = "info_remarkable", input = "kill" } //Stop the survivors from bragging about useless stuff
];

MapSpawns <-
[
	["ChargedodgersBarricadeDoor", "barricade_*", "chargedodgers_barricade_door_group", SPAWN_FLAGS.TARGETSPAWN, 1]
];

MapOptions <-
{
	DefaultItems =
	[
		"weapon_pistol",
		"weapon_pistol"
	]
}

MapState <-
{
	StartDelay = 18
	
	NumRounds = 10
	
	Levels =
	[
		{ Round = 1, NumWaves = 5, WaveSize = 1, Interval = 5 },
		{ Round = 2, NumWaves = 5, WaveSize = 1, Interval = 4 },
		{ Round = 3, NumWaves = 5, WaveSize = 1, Interval = 3 },
		{ Round = 4, NumWaves = 5, WaveSize = 1, Interval = 2 },
		{ Round = 5, NumWaves = 5, WaveSize = 1, Interval = 1 },
		{ Round = 6, NumWaves = 5, WaveSize = 2, Interval = 3 },
		{ Round = 7, NumWaves = 5, WaveSize = 2, Interval = 2 },
		{ Round = 8, NumWaves = 5, WaveSize = 2, Interval = 1 },
		{ Round = 9, NumWaves = 1, WaveSize = 3, Interval = 1 },
		{ Round = 10, NumWaves = 3, WaveSize = 3, Interval = 1 },
	]
}