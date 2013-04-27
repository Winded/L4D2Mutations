/*
	The Special Hydra

	Yep, for every infected you kill, two will replace it. So for your own safety, don't kill them!

	Made by Winded
*/

if(!IncludeScript("utils/zombietypes.nut", this))
{
	throw "zombietypes.nut failed to load!";
}

MutationOptions <-
{
	CommonLimit = 0
	MegaMobSize = 0
	WanderingZombieDensityModifier = 0

	MaxSpecials		= 28 
	TankLimit		= 28 
	WitchLimit		= 28
	BoomerLimit		= 28
	HunterLimit		= 28
	JockeyLimit		= 28
	SpitterLimit	= 28
	SmokerLimit		= 28
	ChargerLimit	= 28

	ProhibitBosses = 1

	TotalBoomers = 0
	TotalHunters = 0
	TotalJockeys = 0
	TotalSpitters = 0
	TotalSmokers = 0
	TotalChargers = 0

	//SurvivorMaxIncapacitatedCount = 0

	DefaultItems =
	[
	"weapon_rifle",
	"weapon_machete",
	"weapon_molotov"
	]

	function GetDefaultItem(idx)
	{
	if(idx < DefaultItems.len())
	{
		return DefaultItems[idx];
	}
	return 0;
	}
}

MutationState <-
{
	SpawnRandMin = -5.0
	SpawnRandMax = 5.0
}

function GetEntityFromUserId(userid) 
{
	local e = null;

	while((e = Entities.FindByClassname(e, "player")) != null)
	{
		if(e.GetPlayerUserId() == userid)
			return e;
	}

	Msg("NULL");

	return null;
}

function HydraSpawn(zombie)
{
	local origin = zombie.GetOrigin();
	local rmax = SessionState.SpawnRandMax;
	local rmin = SessionState.SpawnRandMin;

	//Randomizing X and Y positions
	local z1posx = origin.x + RandomFloat(rmin, rmax);
	local z1posy = origin.y + RandomFloat(rmin, rmax);
	local z2posx = origin.x + RandomFloat(rmin, rmax);
	local z2posy = origin.y + RandomFloat(rmin, rmax);

	local z1pos = Vector(z1posx, z1posy, origin.z);
	local z2pos = Vector(z2posx, z2posy, origin.z);

	local spawnTable =
	{
		type = zombie.GetZombieType()
		pos = Vector()
		ang = QAngle(0, 0, 0)
	}

	Msg("SPAWNING")

	spawnTable.pos = z1pos;
	ZSpawn(spawnTable);
	spawnTable.pos = z2pos;
	ZSpawn(spawnTable);
}

function OnGameEvent_zombie_death(params)
{
	Msg("ZOMBIE DEATH!");

	local ent = GetEntityFromUserId(params.victim);
	if(ent == null) return;

	if(ent.GetZombieType() == ZOMBIE_SURVIVOR) return; //Shouldn't ever happen, but who knows..

	HydraSpawn(ent);
}