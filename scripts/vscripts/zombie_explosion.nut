
if(::g_ZombieExplosions == null)
{
	::g_ZombieExplosions <- [];
}

::g_ZombieExplosions.push(this);

self.Explode(); //TODO validate