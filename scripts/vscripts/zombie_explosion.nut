
if(!("g_ZombieExplosions" in getroottable()))
{
	::g_ZombieExplosions <- [];
}

::g_ZombieExplosions.push(this);

Explosion <- EntityGroup[0];
Sound <- EntityGroup[1];

function OnPostSpawn()
{
	EntFire(self.GetName(), "FireUser1");
}