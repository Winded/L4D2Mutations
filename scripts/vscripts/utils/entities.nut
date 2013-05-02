
//Get the entity ID of an entity

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

//Find an entity by it's entity ID. Supply a classname to reduce search time.
function FindEntityById(id, klass = null) 
{
	local ents = [];
	local ent = null;

	if(klass != null)
	{
		while((ent = Entities.FindByClassname(ent, klass)) != null)
		{
			ents.push(ent);
		}
	}
	else
	{
		ent = Entities.First();
		while(ent != null)
		{
			ents.push(ent);
			ent = Entities.Next(ent);
		}
	}

	foreach (idx, ent in ents)
	{
		if(GetEntIndex(ent) == id)
			return ent;
	}

	return null;
}