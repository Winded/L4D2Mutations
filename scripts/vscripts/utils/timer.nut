
local root = getroottable();

root.Timer <- class
{
	constructor(interval, repeat, tickfunc, funcobject)
	{
		m_Interval = interval;
		m_Repeat = repeat;
		m_TickFunc = tickfunc;
		m_FuncObject = funcobject;
		
		Timers.append(this);
	}
	
	m_Interval = 0;
	
	m_StartTime = 0;
	
	m_Running = false;
	
	m_Repeat = false;
	
	m_TickFunc = null;
	m_FuncObject = null;
	
	function IsRunning()
	{
		return m_Running;
	}
	
	function GetInterval()
	{
		return m_Interval;
	}
	
	function GetTimeLeft()
	{
		return m_Interval - (Time() - m_StartTime);
	}
	
	function SetInterval(interval)
	{
		m_Interval = interval;
	}
	
	function IsRepeating()
	{
		return m_Repeat;
	}
	
	function SetRepeat(repeat)
	{
		m_Repeat = repeat;
	}
	
	function Start()
	{
		m_StartTime = Time();
		m_Running = true;
	}
	
	function Stop()
	{
		m_Running = false;
	}
	
	function Update()
	{
		if(!m_Running) return;
		
		if(Time() - m_StartTime >= m_Interval)
		{
			if(m_TickFunc != null) m_TickFunc.call(m_FuncObject);
			
			if(!m_Repeat)
			{
				m_Running = false;
				return;
			}
			else
			{
				m_StartTime = Time();
			}
		}
	}
}

root.Timers <- [];

root.UpdateTimers <- function()
{
	foreach(timer in Timers)
	{
		if(timer != null)
			timer.Update();
	}
}