
if(!("g_ZombieExplosions" in getroottable()))
{
	::g_ZombieExplosions <- [];
}

::g_ZombieExplosions.push(this);

function OnPostSpawn()
{
	EntFire(self.GetName(), "explode");
}