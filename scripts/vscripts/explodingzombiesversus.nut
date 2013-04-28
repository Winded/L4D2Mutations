/*
	Exploding Zombies Versus
	Made by Winded
*/

//Based off the coop version
IncludeScript("explodingzombies.nut", this);

//Change options
MutationOptions.ConvertZombieClass <- function(klass)
{
	return ZOMBIE_BOOMER;
}

MutationOptions.SpecialRespawnInterval <- 10;