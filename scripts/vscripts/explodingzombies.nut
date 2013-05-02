/*
	Exploding Zombies

	Kaboom! Zombies explode when they die. Not boomer explode, I mean really explode. So you might not want to use a melee.

	Made by Winded
*/

if(!IncludeScript("utils/zombietypes.nut", this))
{
	throw "zombietypes.nut failed to load!!";
}

if(!IncludeScript("utils/entities.nut", this))
{
	throw "entities.nut failed to load!!";
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

function GetInfected(id)
{
	return FindEntityById(id, "infected");
}

function OnGameEvent_zombie_death(params)
{

	local e = GetInfected(params.victim);
	if(e == null) return;

	local origin = e.GetOrigin();

	g_MapScript.SpawnSingleAt(ZombieExplosion.GetEntityGroup(), origin, QAngle());

}