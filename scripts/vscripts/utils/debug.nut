
function Dbg(text)
{
	//For easy debug on/off :)
	//printl(text);
}

function DbgAssert(value, message)
{
	if(value == null)
		printl("ASSERT: " + message);
}