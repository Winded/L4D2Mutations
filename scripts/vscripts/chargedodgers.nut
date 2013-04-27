/*
	Charge Dodgers!
	
	You dodge the spawning chargers or you die. Plain and simple. Or is it?
	Complete sidemissions between round pauses to earn useful rewards such as adrenaline shots
	and chances to pounce chargers!
	
	Made by Winded
*/

if(!IncludeScript("utils/debug.nut", g_ModeScript))
{
	throw "debug.nut failed to be included!!!";
}

if(!IncludeScript("utils/zombietypes.nut", g_ModeScript))
{
	throw "ZombieTypes.nut failed to be included!!!";
}

if(!IncludeScript("utils/timer.nut", g_ModeScript))
{
	throw "Timer.nut failed to be included!!!";
}
	
//-----------------
//Mutation tables
//-----------------

MutationOptions <-
{
	CommonLimit = 0
 	MegaMobSize = 0
 	WanderingZombieDensityModifier = 0
 	MaxSpecials  = 28 
 	TankLimit    = 0 
 	WitchLimit   = 0
	BoomerLimit  = 0
 	HunterLimit  = 0
	JockeyLimit  = 0
	SpitterLimit = 0
	SmokerLimit  = 0
	
 	ChargerLimit = 28
 	TotalChargers = 1
 	
	SurvivorMaxIncapacitatedCount = 0
	
	DefaultItems =
	[
		"weapon_pistol"
	]
	
	function GetDefaultItem(idx)
	{
		if(idx < DefaultItems.len())
		{
			return DefaultItems[idx];
		}
		return 0;
	}

	function AllowWeaponSpawn(classname)
	{
		return false; //Oh shit no weapons!
	}
}

GameState <-
{
	NotStarted = 0
	Running = 1
	Paused = 2
	Starting = 3
	Stopping = 4
	MiniGame = 5
}

MutationState <-
{
	
	StartDelay = 1
	
	CurrentWave = 0
	CurrentRound = 0
	CurrentLevel = null
	
	ChargerCount = 0
	
	SpawnPoints = []
	
	GameState = GameState.NotStarted
	
	StageFunc = function(){ return this; }
	HUDFunc = function(){ return; }
	
	IsPaused = true
	
	PauseDuration = 10
	PauseStartTime = 0
	
}

RequiredMapVars <-
[
	"NumRounds",
	"Levels"
];

//-----------------
//Mutation functionality
//-----------------

function GetCurrentRoundLevel()
{
	local round = SessionState.CurrentRound;
	local levels = SessionState.Levels;
	
	for(local i = 0; i < levels.len(); i++)
	{
		local level1 = levels[i];
		
		if(i < levels.len() - 1)
		{
			local level2 = levels[i + 1];
			if(round >= level1.Round && round < level2.Round) return level1;
		}
		else
		{
			if(round >= level1.Round) return level1;
		}
	}
	
	return null;
}

function NextRound()
{
	SessionState.CurrentRound++;
	SessionState.CurrentWave = 0;
	SessionState.CurrentLevel = GetCurrentRoundLevel();
}

function SpawnWave()
{
	Dbg("Starting wave " + SessionState.CurrentWave + " of round " + SessionState.CurrentRound + ".");
	
	local level = SessionState.CurrentLevel;
	
	local spawnpoints = [];
	for(local i = 0; i < SessionState.CurrentLevel.WaveSize; i++)
	{
		local rnd = RandomInt(0, SessionState.SpawnPoints.len() - 1);
		
		spawnpoints.push(SessionState.SpawnPoints[rnd]);
	}
	
	local spawnTable =
	{
		type = ZOMBIE_CHARGER,
		pos = Vector(0, 0, 0),
		ang = QAngle(0, 0, 0),
	};
	
	for(local i = 0; i < spawnpoints.len(); i++)
	{
		local spawn = spawnpoints[i];
		
		spawnTable.pos = spawn.GetOrigin();
		spawnTable.ang = spawn.GetAngles();
		ZSpawn(spawnTable);
		SessionState.ChargerCount++;
	}
}

function HUDWaveCount()
{
	HUDLayout.Fields.info.dataval = "Waves left: " + (SessionState.CurrentLevel.NumWaves - SessionState.CurrentWave);
}

function HUDNextRound()
{
	HUDLayout.Fields.info.dataval = "Next round in: " + 
		(SessionState.PauseDuration - (Time() - SessionState.PauseStartTime)).tointeger().tostring();
}

function OnGameInit()
{
	SessionState.GameState = GameState.Starting;
	
	SessionOptions.ScriptedStageType = STAGE_SETUP;
	SessionOptions.ScriptedStageValue = SessionState.StartDelay;
	
	return OnGameStart;
}

function OnGameStart()
{
	Ticker_NewStr("Prepare for chargers!");
	TeleportPlayersToStartPoints("playerstart_*");
	
	SessionState.GameState = GameState.Running;
	
	//Kick up the first round
	NextRound();
	
	SessionState.PauseStartTime = Time();
	
	SessionOptions.ScriptedStageType = STAGE_DELAY;
	SessionOptions.ScriptedStageValue = SessionState.PauseDuration;
	
	SessionState.HUDFunc = HUDNextRound;
	return OnGameRunning;
}

function OnGameRunning()
{
	if(SessionState.IsPaused)
	{
		SessionState.IsPaused = false;
		SessionState.HUDFunc = HUDWaveCount;
	}
	
	SessionState.CurrentWave++;
	if(SessionState.CurrentWave > SessionState.CurrentLevel.NumWaves)
	{
		/*if(SessionState.ChargerCount > 0)
		{
			Dbg("Charger count not 0, waiting...");
			SessionOptions.ScriptedStageType = STAGE_DELAY;
			SessionOptions.ScriptedStageValue = 1;
			return OnGameRunning;
		}*/
		
		NextRound();
	
		if(SessionState.CurrentRound > SessionState.NumRounds)
		{
			SessionState.GameState = GameState.Stopping;
			SessionOptions.ScriptedStageType = STAGE_DELAY;
			SessionOptions.ScriptedStageValue = 1;
			
			HUDLayout.Fields.info.dataval = "Winner!";
			SessionState.HUDFunc = null;
			
			return OnGameFinish;
		}
		
		SessionState.PauseStartTime = Time();
		SessionState.IsPaused = true;
		
		Ticker_NewStr("Round " + SessionState.CurrentRound + " starts in " + SessionState.PauseDuration + " seconds!");
		
		SessionOptions.ScriptedStageType = STAGE_DELAY;
		SessionOptions.ScriptedStageValue = SessionState.PauseDuration;
		
		SessionState.HUDFunc = HUDNextRound;
		return OnGameRunning;
	}
	
	SpawnWave();
	
	SessionOptions.ScriptedStageType = STAGE_DELAY;
	SessionOptions.ScriptedStageValue = SessionState.CurrentLevel.Interval;
	
	return OnGameRunning;
}

function OnGameFinish()
{
	SessionOptions.ScriptedStageType = STAGE_RESULTS; //Goes to loser state, wtf??
	SessionOptions.ScriptedStageValue = 1;
	
	return null;
}

//-----------------
//Mutation callbacks
//-----------------

function OnGameplayStart()
{
	foreach(idx, val in RequiredMapVars)
	{
		if(!(val in SessionState))
			throw val + " not declared in MapState!";
	}
	
	//Make spawn point table
	local ent = null;
	while((ent = Entities.FindByName(ent, "charger_spawn_point_*")) != null)
	{
		SessionState.SpawnPoints.push(ent);
	}
	
	SessionState.StageFunc = OnGameInit;
}

function GetNextStage()
{
	if("StageFunc" in SessionState)
		SessionState.StageFunc = SessionState.StageFunc.call(g_ModeScript);
}

HUDLayout <- {};

function SetupModeHUD()
{
	HUDLayout =
	{
		Fields =
		{
			info = { name = "info", slot = HUD_MID_TOP, dataval = "Waiting..." }
		}
	};
	
	Ticker_AddToHud(HUDLayout, "");
	
	HUDSetLayout(HUDLayout);
}

function Update()
{
	if("HUDFunc" in SessionState)
		SessionState.HUDFunc.call(g_ModeScript);
}

function AllowTakeDamage(dt)
{
	if(dt.Victim == null || dt.Victim.GetClassname() != "player") return dt;
	
	if(dt.Victim.GetZombieType() == ZOMBIE_CHARGER)
	{
		Dbg("Instakilling charger..");
		dt.DamageDone = 600;
		return dt;
	}
	
	if(dt.Attacker == null || dt.Attacker.GetClassname() != "player") return dt;
	
	if(dt.Attacker.GetZombieType() == ZOMBIE_CHARGER && dt.Victim.IsSurvivor())
	{
		Dbg("Instakilling survivor...");
		dt.DamageDone = 100;
		return dt;
	}
	
	return dt;
}

function OnGameEvent_zombie_death(params)
{
	if(params.infected_id == ZOMBIE_CHARGER)
		SessionState.ChargerCount--;
}