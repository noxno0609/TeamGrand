CMD:w(playerid, params[])
{
	return cmd_whisper(playerid, params);
}
CMD:goto(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co quyen han su dung cau lenh nay.");
	if (sscanf(params, "s[32]", params))
	{
		SendClientMessage(playerid, COLOR_WHITE, "Su dung: /goto [Dia diem/PlayerId]");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: LS | LV | SF");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: Truck | Congnhan | Dongo | Nongdan");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: Tosser | Nhamay | Binco | 247");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: AllSaints | County | Wangcar");
		return 1;
	}
	new xe = GetPlayerVehicleID(playerid), str[255];
	if (!strcmp(params, "ls", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 1529.6, -1691.2, 13.3);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
	}
	else if (!strcmp(params, "lv", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 1699.2, 1435.1, 10.7);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1699.2, 1435.1, 10.7);
	}
	else if (!strcmp(params, "sf", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, -2015.261108, 154.379516, 27.687500);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, -2015.261108, 154.379516, 27.687500);
		SendClientMessage(playerid, COLOR_GRAD1, "   Da duoc dich chuyen !");
		return 1;
	}
	//else if (!strcmp(params, "dd", true))
	//{
	//	if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, DiemDenPos[playerid][0], DiemDenPos[playerid][1], DiemDenPos[playerid][2] + 3);
	//	SetPlayerPos(playerid, DiemDenPos[playerid][0], DiemDenPos[playerid][1], DiemDenPos[playerid][2] + 3);
	//}
	else if (!strcmp(params, "truck", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 2187.2886, -2265.1406, 13.4754);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 2187.2886, -2265.1406, 13.4754);
	}
	else if (!strcmp(params, "congnhan", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 2461.0278, -2115.2649, 13.5469);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 2461.0278, -2115.2649, 13.5469);
	}
	else if (!strcmp(params, "binco", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 2245.4258, -1662.2477, 15.4690);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 2245.4258, -1662.2477, 15.4690);
	}
	else if (!strcmp(params, "247", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 1932.0830, -1776.4635, 13.3828);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1932.0830, -1776.4635, 13.3828);
	}
	else if (!strcmp(params, "wangcar", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 1790.7096, -1739.4459, 13.5469);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1790.7096, -1739.4459, 13.5469);
	}
	else if (!strcmp(params, "county", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 2026.7938, -1422.0918, 16.9922);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 2026.7938, -1422.0918, 16.9922);
	}
	else if (!strcmp(params, "allsaints", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 1177.5790, -1323.5640, 14.0777);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1177.5790, -1323.5640, 14.0777);
	}
	else if (!strcmp(params, "nongdan", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, -374.0205, -1439.1160, 25.7266);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, -374.0205, -1439.1160, 25.7266);
	}
	else if (!strcmp(params, "dongo", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, -534.1697, -83.0436, 62.8426);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, -534.1697, -83.0436, 62.8426);
	}
	else if (!strcmp(params, "nhamay", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 39.5153, -287.3114, 2.0165);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 39.5153, -287.3114, 2.0165);
	}
	else if (!strcmp(params, "tosser", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 681.5443, -476.8310, 16.3359);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 681.5443, -476.8310, 16.3359);
	}
	else if (IsNumeric(params))
	{
		new plo = strval(params);
		if (!IsPlayerConnected(plo) && plo == INVALID_PLAYER_ID)
		{
			format(str, sizeof(str), "   %d , nguoi choi khong hop le.", plo);
			SendClientMessage(playerid, COLOR_GRAD1, str);
		}
		new Float:plocx, Float: plocy, Float: plocz;
		if (Spectate[playerid] != 255)
		{
			Spectate[playerid] = 256;
		}
		GetPlayerPos(plo, plocx, plocy, plocz);
		if (PlayerInfo[plo][pInt] > 0)
		{
			SetPlayerInterior(playerid, PlayerInfo[plo][pInt]);
			PlayerInfo[playerid][pInt] = PlayerInfo[plo][pInt];
			PlayerInfo[playerid][pLocal] = PlayerInfo[plo][pLocal];
		}
		if (PlayerInfo[playerid][pInt] == 0)
		{
			SetPlayerInterior(playerid, 0);
		}
		if (plocz > 530.0 && PlayerInfo[plo][pInt] == 0) //the highest land point in sa = 526.8
		{
			SetPlayerInterior(playerid, 1);
			PlayerInfo[playerid][pInt] = 1;
		}
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, plocx, plocy + 4, plocz);
			TelePos[playerid][0] = 0.0; TelePos[playerid][1] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, plocx, plocy + 2, plocz);
		}
	}
	else {
		return SendClientMessage(playerid, COLOR_GRAD1, "   Sai [Dia diem] hoac [Playerid] !");
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   Da duoc dich chuyen !");
	return 1;
}

CMD:sendto(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co quyen han su dung cau lenh nay.");
	new nguoichoi, location[32];
	if (sscanf(params, "us[32]", nguoichoi, location))
	{
		SendClientMessage(playerid, COLOR_WHITE, "Sun dung: /sendto [ID] [Dia diem]");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: LS | LV | SF");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: Truck | Congnhan | Dongo | Nongdan");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: Tosser | Nhamay | Binco | 247");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: AllSaints | County | Wangcar");
		return 1;
	}
	if (!IsPlayerConnected(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ID khong hop le.");
	new xe = GetPlayerVehicleID(nguoichoi), str[255];
	if (!strcmp(location, "ls", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 1529.6, -1691.2, 13.3);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 1529.6, -1691.2, 13.3);
	}
	else if (!strcmp(location, "lv", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 1699.2, 1435.1, 10.7);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 1699.2, 1435.1, 10.7);
		return 1;
	}
	else if (!strcmp(location, "sf", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, -2015.261108, 154.379516, 27.687500);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, -2015.261108, 154.379516, 27.687500);
	}
	else if (!strcmp(location, "truck", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 2187.2886, -2265.1406, 13.4754);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 2187.2886, -2265.1406, 13.4754);
	}
	else if (!strcmp(location, "congnhan", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 2461.0278, -2115.2649, 13.5469);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 2461.0278, -2115.2649, 13.5469);
	}
	else if (!strcmp(location, "binco", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 2245.4258, -1662.2477, 15.4690);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 2245.4258, -1662.2477, 15.4690);
	}
	else if (!strcmp(location, "247", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 1932.0830, -1776.4635, 13.3828);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 1932.0830, -1776.4635, 13.3828);
	}
	else if (!strcmp(location, "wangcar", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 1790.7096, -1739.4459, 13.5469);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 1790.7096, -1739.4459, 13.5469);
	}
	else if (!strcmp(location, "county", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 2026.7938, -1422.0918, 16.9922);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 2026.7938, -1422.0918, 16.9922);
	}
	else if (!strcmp(location, "allsaints", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 1177.5790, -1323.5640, 14.0777);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 1177.5790, -1323.5640, 14.0777);
	}
	else if (!strcmp(location, "nongdan", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, -374.0205, -1439.1160, 25.7266);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, -374.0205, -1439.1160, 25.7266);
	}
	else if (!strcmp(location, "dongo", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, -534.1697, -83.0436, 62.8426);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, -534.1697, -83.0436, 62.8426);
	}
	else if (!strcmp(location, "nhamay", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 39.5153, -287.3114, 2.0165);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 39.5153, -287.3114, 2.0165);
	}
	else if (!strcmp(location, "tosser", true))
	{
		if (IsPlayerInAnyVehicle(nguoichoi)) return SetVehiclePos(xe, 681.5443, -476.8310, 16.3359);
		SetPlayerInterior(nguoichoi, 0);
		SetPlayerVirtualWorld(nguoichoi, 0);
		SetPlayerPos(nguoichoi, 681.5443, -476.8310, 16.3359);
	}
	else {
		return SendClientMessage(playerid, COLOR_GRAD1, "Sai [Dia diem] !");
	}
	format(str, sizeof(str), " Ban da dich chuyen %s.", GN(nguoichoi));
	SendClientMessage(playerid, COLOR_GRAD1, str);
	format(str, sizeof(str), "[Admin] %s da dich chuyen ban.", GN(playerid));
	SendClientMessage(nguoichoi, COLOR_YELLOW, str);
	return 1;
}
CMD:gotopos(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co quyen han su dung cau lenh nay.");
	new Float:p[3], interior;
	if (sscanf(params, "fffd", p[0], p[1], p[2], interior)) return SendClientMessage(playerid, COLOR_GRAD1, "Su dung: /gotoco [ x ] [ y ] [ z ] [ int ]");
	new vid = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(vid, p[0], p[1], p[2] + 2);
		LinkVehicleToInterior(vid, interior);
		SetVehicleVirtualWorld(vid, 0);
		PutPlayerInVehicle(playerid, vid, 0);
		SetPlayerInterior(playerid, interior);
		SetPlayerVirtualWorld(playerid, 0);
	}
	else
	{
		SetPlayerPos(playerid, p[0], p[1], p[2] + 2);
		SetPlayerInterior(playerid, interior);
		SetPlayerVirtualWorld(playerid, 0);
	}
	SendClientMessage(playerid, COLOR_GRAD1, "Dich chuyen.");
	return 1;
}