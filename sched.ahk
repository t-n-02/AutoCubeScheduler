file := FileOpen("out.txt", "r")
if !IsObject(file)
{
    MsgBox Can't open file for reading.
    return
}

onum := file.ReadLine()
snum := file.ReadLine()
vnum := file.ReadLine()

;MsgBox %vnum%

onum := SubStr(onum, 1 , 1)
snum := SubStr(snum, 1 , 1)
vnum := SubStr(vnum, 1 , 1)

;MsgBox %vnum%

;convert to integers 
o := 0
s := 0
v := 0
loop 10 
{
	if(onum = o)
	{
		break
	}
	o := o + 1
}
loop 10 
{
	if(snum = s)
	{
		break
	}
	s := s + 1
}
loop 10 
{
	if(vnum = v)
	{
		break
	}
	v := v + 1
}
hto := ""
vto := ""
c2 := 0
loop %o% {
	c := 0
	line := file.ReadLine()
	Loop, parse, line, `, 
	{
		if(c = 0)
		{
			if(c2 = 0)
			{
				vto = %A_LoopField%
			}
			else
			{
				vto = %vto%,%A_LoopField%
			}
		}
		if(c = 1)
		{
			if(c2 = 0)
			{
				hto = %A_LoopField%
			}
			else
			{
				hto = %hto%,%A_LoopField%
			}
		}
		if(c = 2)
		{
			break
		}
		c := c + 1
	}
	c2 += 1
}
c2 := 0
line := file.ReadLine()
hts := ""
vts := ""
c2 := 0
loop %s% {
	c := 0
	line := file.ReadLine()
	Loop, parse, line, `, 
	{
		if(c = 0)
		{
			if(c2 = 0)
			{
				vts = %A_LoopField%
			}
			else
			{
				vts = %vts%,%A_LoopField%
			}
		}
		if(c = 1)
		{
			if(c2 = 0)
			{
				hts = %A_LoopField%
			}
			else
			{
				hts = %hts%,%A_LoopField%
			}
		}
		if(c = 2)
		{
			break
		}
		c := c + 1
	}
	c2 += 1
}
c2 := 0
line := file.ReadLine()
htv := ""
vtv := ""
c2 := 0
loop %v% {
	c := 0
	line := file.ReadLine()
	Loop, parse, line, `, 
	{
		if(c = 0)
		{
			if(c2 = 0)
			{
				vtv = %A_LoopField%
			}
			else
			{
				vtv = %vtv%,%A_LoopField%
			}
		}
		if(c = 1)
		{
			if(c2 = 0)
			{
				htv = %A_LoopField%
			}
			else
			{
				htv = %htv%,%A_LoopField%
			}
		}
		if(c = 2)
		{
			break
		}
		c := c + 1
	}
	c2 += 1
}
c2 := 0

;Arrays are complete



GetElement(x, data) ;num , string
{
		c := 1
		Loop, parse, data, `,
		{
			if(c = x)
			{
				return A_LoopField
			}
			c += 1
		}
}

selEvent(x, y) ;event number, total events
{
	MouseMove 751, 533
	MouseClick
	Loop 15
	{
		Send {Down}
	}
	MouseClick
	temp := y - x
	Loop %temp%
	{
		Send {Up}
		Sleep 50
	}
}

assignLR(home, visit)
{
	MouseMove 728, 619
	MouseClick
	Sleep 50
	MouseMove 697, 725
	MouseClick
	Sleep 50
	Send %visit%
	Sleep 50
	MouseMove 747, 641
	MouseClick
	Sleep 50
	MouseMove 697, 725
	MouseClick
	Sleep 50
	Send %home%
	Sleep 50
}

selFacility(x) ;1-o, 2-s, 3-v
{
	MouseMove 624, 349
	MouseClick
	Sleep 50
	Loop 4
	{
		Send {Up}
		Sleep 50
	}
	if(x = 1)
	{
		Send {Enter}
	}
	if(x = 2)
	{
		Send {Down}
		Send {Enter}
	}
	if(x = 3)
	{
		Send {Down}
		Sleep 50
		Send {Down}
		Send {Enter}
	}
}

file.Close()


;fill in schedule
^+i::
	;olympic
	selFacility(1)
	Sleep 1000
	count := 1
	Loop %o%
	{
		selEvent(count, o)
		assignLR(GetElement(count, hto), GetElement(count, vto) )
		count += 1
	}
	
	;stadium
	selFacility(2)
	Sleep 1000
	count := 1
	Loop %s%
	{
		selEvent(count, s)
		assignLR(GetElement(count, hts), GetElement(count, vts) )
		count += 1
	}
	
	;varsity
	selFacility(3)
	Sleep 1000
	count := 1
	Loop %v%
	{
		selEvent(count, v)
		assignLR(GetElement(count, vtv), GetElement(count, htv) )
		count += 1
	}
	
	ExitApp
	
	return





;;mouse pos hotkey
;^+i::
;	MouseGetPos,x,y,,,
;	MsgBox POS: %x% , %y%
;	return 