CMD:w(playerid, params[]) 
{
	if (IsPlayerConnected(playerid) && PlayerInfo[playerid][pAdmin] > 0)
	{
		new playa, mess[255];
		if (sscanf(params, "us", playa, mess)) {
			return SCM(playerid, COLOR_GRAD2, "Su dung: /w [playerid/Name] [Noi dung]");
		}
		SCM(playa, COLOR_YELLOW, mess);
		return 1;
	}
}