/*
	Exploding Zombies

	Kaboom! Zombies explode when they die. Not boomer explode, I mean really explode. So you might not want to use a melee.

	Made by Winded
*/

if(!IncludeScript("utils/zombietypes.nut", this))
{
	throw "zombietypes.nut failed to load!!";
}

if(!IncludeScript("entitygroups/zombie_explosion_group.nut", this))
{
	throw "Failed to load zombie_explosion group!!";
}

MutationOptions <-
{
	CommonLimit  = 20

	BoomerLimit  = 4
 	ChargerLimit = 0
 	HunterLimit  = 0
	JockeyLimit  = 0
	SpitterLimit = 0
	SmokerLimit  = 0
	MaxSpecials  = 4
};

MutationState <-
{

};

EntIndexRegex <- regexp("\\d+");

function GetEntIndex(entity)
{
	local str = entity.tostring();

	local m = EntIndexRegex.capture(str);

	if(m.len() == 0) return -1;

	local begin = m[0].begin;
	local end = m[0].end;
	local id = str.slice(begin, end).tointeger();

	return id;
}

function GetInfected(id)
{
	local ent = null;

	while((ent = Entities.FindByClassname(ent, "infected")) != null)
	{
		if(GetEntIndex(ent) == id)
			return ent;
	}

	return null;
}

function OnGameEvent_zombie_death(params)
{

	local e = GetInfected(params.victim);
	if(e == null) return;

	local origin = e.GetOrigin();

	g_MapScript.SpawnSingleAt(ZombieExplosion.GetEntityGroup(), origin, QAngle());

}