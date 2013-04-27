/*
	Exploding Zombies

	Kaboom! Zombies explode when they die. Not boomer explode, I mean really explode. So you might not want to use a melee.

	Made by Winded
*/

if(!IncludeScript("utils/zombietypes.nut"))
{
	throw "zombietypes.nut failed to load!!";
}

// Hand-built entity group for explosions
ZombieExplosionGroup <-
{
	function GetSpawnList()   { return [ EntityGroup.SpawnTables.zombie_explosion ] }
	function GetEntityGroup() { return EntityGroup }

	EntityGroup =
	{
		SpawnPointName = "zombie_explosion_spawn_*"
		SpawnTables = 
		{
			zombie_explosion =
			{
				initialSpawn = true
				SpawnInfo =
				{
					classname = "env_explosion"
					targetname = "zombie_explosion"
					iMagnitude = 10
					iRadiusOverride = 100
					vscripts = "zombie_explosion.nut"
				}
			}
		}
	}
}

MutationOptions <-
{
	CommonLimit  = 20

	BoomerLimit  = 0
 	ChargerLimit = 0
 	HunterLimit  = 0
	JockeyLimit  = 0
	SpitterLimit = 0
	SmokerLimit  = 0
	MaxSpecials  = 0
};

MutationState <-
{

};

function GetInfected(id)
{
	local ent = null;

	while((ent = Entities.FindByClassname("infected", ent)) != null)
	{
		if(ent.EntIndex() == id)
			return ent;
	}

	return null;
}

function OnGameEvent_zombie_death(params)
{
	
	local e = GetInfected(params.victim);
	if(e == null) return;

	local origin = e.GetOrigin();

	g_MapScript.SpawnSingleAt(ZombieExplosionGroup.GetEntityGroup(), origin, QAngle());

}