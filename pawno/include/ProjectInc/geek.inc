public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == mSkinList)
    {
        if(response)
        {
        	SetPlayerSkin(playerid, modelid);
			PlayerInfo[playerid][pModel] = modelid;
			SafeGivePlayerMoney(playerid, -SKINPRICE);
			PlayerPlaySound(playerid,5453,0.0,0.0,0.0);
   		}
        return 1;
    }
    return 1;
}

stock HP(playerid)
{
	new name[32];
	switch (PlayerInfo[playerid][pHelper])
	{
	case 1: format(name, sizeof(name), "[Helper]");
	case 2: format(name, sizeof(name), "[CA]");
	default: format(name, sizeof(name), "Khong");
	}
	return name;
}

stock IsPlayerNearSeed(playerid)
{
	for (new i = 0; i<MAXSEED; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2])) return 1;
	}
	return 0;
}
stock IsPlayerInRectangle(playerid, Float:x1, Float:y1, Float:x2, Float:y2)
{
	if (IsPlayerConnected(playerid))
	{
		new Float:xs, Float:ys, Float:zs;
		GetPlayerPos(playerid, xs, ys, zs);
		return IsPointInRectangle(xs, ys, x1, y1, x2, y2);
	}
	return 0;
}
stock IsPointInRectangle(Float:xs, Float:ys, Float:x1, Float:y1, Float:x2, Float:y2)
{
	if (IsBetweenFloats(xs, x1, x2) && IsBetweenFloats(ys, y1, y2))
	{
		return 1;
	}
	return 0;
}
stock IsBetweenFloats(Float:f, Float:f1, Float:f2)
{
	switch (floatcmp(f1, f2))
	{
	case 0: if (f == f1) { return 1; }
	case 1: if (f <= f1 && f >= f2) { return 1; }
	case -1: if (f >= f1 && f <= f2) { return 1; }
	}
	return 0;
}
stock IsPlayerInRangeofFarmer(playerid)
{
	if (IsPlayerInRectangle(playerid, -1028.2699, -1575.5719, -949.1511, -1626.2856)) return 1;
	return 0;
}

stock ClearSeedPos(i)
{
	SeedPos[i][0] = 0;
	SeedPos[i][1] = 0;
	SeedPos[i][2] = 0;
}

stock DestroySeed(i)
{
	SeedGatLua[i] = 0;
	SeedTuoiNuoc[i] = 0;
	DestroyDynamic3DTextLabel(SeedText[i]);
	SeedTime[i] = 0;
	SeedTotal[i] = 0;
	DestroyDynamicObject(SeedObject[i]);
	SeedObject[i] = 0;
	ClearSeedPos(i);
	for (new playerid = 0; playerid <= GetPlayerPoolSize(); playerid++)
	{
		if (strcmp(SeedOwner[i], GLN(playerid), true) == 0 && SeedOwner[i][0] != EOS) {
			SeedCount[playerid]--;
			break;
		}
	}
	SeedOwner[i][0] = EOS;
}

stock GetPlayerNearSeed(playerid)
{
	for (new i = 0; i<MAXSEED; i++)
	{
		if (IsValidDynamicObject(SeedObject[i]) && IsPlayerInRangeOfPoint(playerid, 3, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2])) return i;
	}
	return 0;
}

stock GetSlotSeed()
{
	for (new i = 0; i<MAXSEED; i++)
	{
		if (!SeedObject[i]) return i;
	}
	return -1;
}

stock SeedCheck(i) {
	new str[100];
	if (SeedGrowth[i] == 4) {
		format(str, sizeof(str), "Nguoi gieo hat: %s\n[Da Truong Thanh] Co the gat lua ({00FF00} An ALT{008080})", SeedOwner[i]);
		UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
	}
	if (SeedGrowth[i] == 5) {
		format(str, sizeof(str), "Nguoi gieo hat: %s\n[Thieu Nuoc] Hay tuoi nuoc cho cay ngay! ({00FF00} An ALT{008080})", SeedOwner[i]);
		UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
	}
	if (SeedGrowth[i] == 6) {
		format(str, sizeof(str), "Nguoi gieo hat: %s\n[Chet] Do thieu nuoc !", SeedOwner[i]);
		UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
	}
}
stock RiceGrowth(i, a) {
	SeedGrowth[i] = a;
	SeedTotal[i] = 0;
	SeedTime[i] = 0;
	switch (SeedGrowth[i]) {
		case 2: {
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObject(802, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] - 0.6, 0.0, 0.0, 0.0);
		}
		case 3: {
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObject(801, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] - 1.5, 0.0, 0.0, 0.0);
		}
		case 4: {
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObject(809, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] - 1.5, 0.0, 0.0, 0.0);
		}
		case 5: {
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObject(812, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] + 0.2, 0.0, 0.0, 0.0);
		}
		case 6: {
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObject(815, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] - 1.5, 0.0, 0.0, 0.0);
		}
	}
	SeedCheck(i);
}
stock GetLevelSkill(playerid, skill)
{
	new value = 0;
	switch (skill)
	{
	case PLANT: value = PlayerInfo[playerid][pPlantSkill];
	}
	if (value>0 && value <100) return 1;
	else if (value >= 100 && value <500) return 2;
	else if (value >= 500 && value <1000) return 3;
	else if (value >= 1000 && value <2000) return 4;
	else if (value >= 2000) return 5;
	return 0;
}

stock TangSkill(playerid, skill, soluong)
{
	new str[128];
	switch (skill)
	{
		case PLANT:
		{
			if (PlayerInfo[playerid][pPlantSkill] > 0) PlayerInfo[playerid][pPlantSkill] += soluong;
			format(str, sizeof(str), "[Trong trot]: Tang %d diem ki nang.", soluong);
		}
		default: return 0;
	}
	SendClientMessage(playerid, COLOR_YELLOW, str);
	return 1;
}

CMD:goto(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co quyen han su dung cau lenh nay.");
	if (sscanf(params, "s[32]", params))
	{
		SendClientMessage(playerid, COLOR_WHITE, "Su dung: /goto [Dia diem/PlayerId]");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: LS | LV | SF");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: XuongVuKhi | Truck | Dongo | Nongdan");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: Tosser | Nhamay | Binco | 247");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: AllSaints | County | Wangcar");
		SendClientMessage(playerid, COLOR_GREY, "Dia diem: DoC | TrongTrot");
		return 1;
	}
	new xe = GetPlayerVehicleID(playerid), str[255];
	if (!strcmp(params, "doc", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 777.9285, -1385.0005, 13.7251);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 777.9285, -1385.0005, 13.7251);
	}
	if (!strcmp(params, "trongtrot", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, -1092.1846, -1650.5377, 76.3739);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, -1092.1846, -1650.5377, 76.3739);
	}
	else if (!strcmp(params, "ls", true))
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
	}
	//else if (!strcmp(params, "dd", true))
	//{
	//	if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, DiemDenPos[playerid][0], DiemDenPos[playerid][1], DiemDenPos[playerid][2] + 3);
	//	SetPlayerPos(playerid, DiemDenPos[playerid][0], DiemDenPos[playerid][1], DiemDenPos[playerid][2] + 3);
	//}
	else if (!strcmp(params, "xuongvukhi", true))
	{
		if (IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(xe, 2187.2886, -2265.1406, 13.4754);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 2187.2886, -2265.1406, 13.4754);
	}
	else if (!strcmp(params, "truck", true))
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
		if (plo == INVALID_PLAYER_ID || !IsPlayerConnected(plo))
		{
			format(str, sizeof(str), "   %d , nguoi choi khong hop le.", plo);
			return SendClientMessage(playerid, COLOR_GRAD1, str);
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
		PlayerInfo[playerid][pVirWorld] = GetPlayerVirtualWorld(plo);
		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVirWorld]);
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
		SendClientMessage(playerid, COLOR_WHITE, "Su dung: /sendto [ID] [Dia diem]");
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

CMD:nonewb(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co quyen han su dung cau lenh nay.");
	if (NewbieChannelActive == 0) { NewbieChannelActive = 1; BroadCast(COLOR_NEWBIE, "Kenh chat Newbie da duoc mo khoa."); }
	else if (NewbieChannelActive == 1) { NewbieChannelActive = 0; BroadCast(COLOR_NEWBIE, "Kenh chat Newbie da duoc khoa."); }
	return 1;
}

CMD:newb(playerid, params[])
{
	new str[255], mess[255];
	if (sscanf(params, "s[255]", mess)) return SendClientMessage(playerid, COLOR_GREY, "Su dung: /newb [Noi Dung]");
	if (NewbieChannelActive == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Kenh newbie da bi khoa.");
	if (PlayerInfo[playerid][pAdmin] > 0) format(str, sizeof(str), "[Admin] %s(%d): %s", GN(playerid), playerid, mess);
	else if (PlayerInfo[playerid][pHelper] > 0) format(str, sizeof(str), "%s %s(%d): %s", HP(playerid), GN(playerid), playerid, mess);
	else
	{
		if (GetPVarInt(playerid, "InNewbieChannel") == 1) return SendClientMessage(playerid, COLOR_GRAD1, "Thoi gian giua hai cau hoi la 15s.");
		format(str, sizeof(str), "%s(%d): %s", GN(playerid), playerid, mess);
		SetPVarInt(playerid, "InNewbieChannel", 1);
		defer NewbieChannel[15000](playerid);
	}
	BroadCast(COLOR_NEWBIE, str);
	return 1;
}
CMD:yeucautrogiup(playerid, params[])
{
	if (CountAdvisor == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Hien gio khong co Advisor nao.");
	if (PlayerInfo[playerid][pLevel] >5) return SendClientMessage(playerid, COLOR_GRAD1, "Cap cua ban da qua cao.");
	if (GetPVarInt(playerid, "CanTroGiup") == 1) return SendClientMessage(playerid, COLOR_GRAD1, "Hay cho mot luc sau hay tiep tuc gui yeu cau.");
	new str[128];
	format(str, sizeof(str), "%s(%i) yeu cau su tro giup tu Advisor. (/chapnhangiupdo %i)", GN(playerid), playerid, playerid);
	CBroadCast(COLOR_LIGHTGREEN, str, 2);
	format(str, sizeof(str), "%s(%i) da gui yeu cau tro giup. Dang doi Advisor duyet...", GN(playerid), playerid);
	ABroadCast(COLOR_LIGHTGREEN, str, 1);
	SetPVarInt(playerid, "CanTroGiup", 1);
	defer RequestAdvisor[30000](playerid);
	return 1;
}
CMD:chapnhangiupdo(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] < 2) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong phai advisor.");
	/*if (CDuty[playerid] != 1) return SendClientMessage(playerid, COLOR_GRAD1, "Ban phai onduty Advisor truoc.");*/
	new pgd;
	if (sscanf(params, "u", pgd)) return SendClientMessage(playerid, COLOR_GRAD1, "/chapnhangiupdo [Ten/ID Nguoi Choi]");
	if (pgd == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi choi khong ton tai.");
	if (GetPVarInt(pgd, "CanTroGiup") != 1) return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi nay khong can tro giup.");
	new str[128];
	format(str, sizeof(str), "Ban da chap nhan giup do cho %s , khi da hoan thanh cong viec su dong /dagiup de tro lai vi tri cu.", GN(pgd));
	SendClientMessage(playerid, COLOR_GRAD1, str);
	format(str, sizeof(str), "%s %s da chap nhan yeu cau giup do cua ban.", HP(playerid), GN(playerid));
	SendClientMessage(pgd, COLOR_LIGHTGREEN, str);
	format(str, sizeof(str), "%s %s da chap nhan yeu cau tro giup cua %s.", HP(playerid), GN(playerid), GN(pgd));
	ABroadCast(COLOR_LIGHTGREEN, str, 1);
	CBroadCast(COLOR_LIGHTGREEN, str, 2);
	new Float: x, Float:y, Float:z, Float:r, i, vw;
	vw = GetPlayerVirtualWorld(playerid);
	i = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);
	SetPVarFloat(playerid, "AdvisorLastx", x);
	SetPVarFloat(playerid, "AdvisorLasty", y);
	SetPVarFloat(playerid, "AdvisorLastz", z);
	SetPVarFloat(playerid, "AdvisorLastr", r);
	SetPVarInt(playerid, "AdvisorLastInt", i);
	SetPVarInt(playerid, "AdvisorLastVW", vw);

	GetPlayerPos(pgd, x, y, z);
	vw = GetPlayerVirtualWorld(pgd);
	i = GetPlayerInterior(pgd);
	SetPlayerPos(playerid, x, y + 2, z);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerInterior(playerid, i);

	DanhHieu[playerid] = CreateDynamic3DTextLabel("Nguoi Tro Giup", COLOR_LIGHTGREEN, x, y, z + 6.0, 15.0, playerid);
	SetPVarInt(playerid, "DangHelp", 1);
	DeletePVar(pgd, "CanGiupDo");
	return 1;
}

CMD:dagiup(playerid, params[])
{
	if (GetPVarInt(playerid, "DangHelp") != 1) return SendClientMessage(playerid, COLOR_GRAD1, "Ban hien khong giup do ai.");
	new string[128];
	format(string, sizeof(string), "%s da hoan thanh yeu cau tro giup.", GN(playerid));
	CBroadCast(COLOR_LIGHTGREEN, string, 2);
	ABroadCast(COLOR_LIGHTGREEN, string, 1);
	DestroyDynamic3DTextLabel(DanhHieu[playerid]);
	SetPlayerPos(playerid, GetPVarFloat(playerid, "AdvisorLastx"), GetPVarFloat(playerid, "AdvisorLasty"), GetPVarFloat(playerid, "AdvisorLastz"));
	SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "AdvisorLastVW"));
	SetPlayerInterior(playerid, GetPVarInt(playerid, "AdvisorLastInt"));
	DeletePVar(playerid, "DangHelp");
	return 1;
}
CMD:c(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] < 2 && PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the dung lenh nay");
	new mess[255], str[255];
	if (sscanf(params, "s[255]", mess)) return SendClientMessage(playerid, COLOR_GRAD1, "/c [Noi Dung]");
	if(PlayerInfo[playerid][pAdmin] > 0) {
		format(str, sizeof(str), "[Admin] %s(%d): %s", GN(playerid), playerid, mess);
	}
	else {
		format(str, sizeof(str), "%s %s(%d): %s", HP(playerid), GN(playerid), playerid, mess);
	}
	CBroadCast(COLOR_LIGHT_BLUE, str, 2);
	ABroadCast(COLOR_LIGHT_BLUE, str, 1);
	return 1;
}
CMD:plant(playerid, params[]) { return cmd_gieohat(playerid, params); }
CMD:gieohat(playerid, params[])
{
	if (PlayerInfo[playerid][pJob] != 19) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong phai nguoi trong trot.");
	if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong theo gieo hat giong khi dang o trong xe!");
	if (!IsPlayerInRangeofFarmer(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong dung trong khu vuc co the gieo hat");
	if (IsPlayerNearSeed(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the trong gan cay khac!");
	//if (PInfo[playerid][HatGiong] <= 0) return SendMessage(playerid, COLOR_GRAD1, "Ban khong con hat giong de gieo");
	new str[128];
	if (SeedCount[playerid] >= MAX_SEED_PLAYER)
	{
		format(str, sizeof(str), "Ban da gieo hat den toi da [%d/%d] cay lua!", SeedCount[playerid], MAX_SEED_PLAYER);
		SendClientMessage(playerid, COLOR_GRAD1, str);
		return 1;
	}
	new i = GetSlotSeed();
	if (i == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Dat da het dinh duong.");
	GetPlayerPos(playerid, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2]);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
	SeedObject[i] = CreateDynamicObject(675, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2] - 1, 0.0, 0.0, 0.0);
	format(str, sizeof(str), "Nguoi gieo hat: %s\n[Can] Tuoi nuoc ({00FF00} An ALT{008080})", GN(playerid));
	SeedText[i] = CreateDynamic3DTextLabel(str, 0x008080FF, SeedPos[i][0], SeedPos[i][1], SeedPos[i][2], 5.0);
	SeedGrowth[i] = 1;
	SeedCount[playerid]++;
	SeedTime[i] = 0;
	SeedTotal[i] = 0;
	format(SeedOwner[i], 128, "%s", GLN(playerid));
	SendClientMessage(playerid, COLOR_WHITE, "Ban da gieo hat giong thanh cong!");
	SendClientMessage(playerid, COLOR_WHITE, "Hay chu y tuoi nuoc thuong xuyen de cay phat trien!");
	return 1;
}

CMD:muaquanao(playerid, params[])
{
	if(!IsAtClothShop(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Khong dung o shop quan ao.");
	new str[255];
	format(str, sizeof(str), "Ban can co it nhat $%d de mua trang phuc", SKINPRICE);
	if(GetPlayerMoney(playerid) < SKINPRICE) return SendClientMessage(playerid, COLOR_GRAD1, str);
	ShowModelSelectionMenu(playerid, mSkinList, "Mua Trang Phuc");
	return 1;
}

forward PlantKeyStateChange(playerid, newkeys, oldkeys);
public PlantKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PlayerInfo[playerid][pJob] == 19 && IsPlayerNearSeed(playerid) && newkeys == KEY_WALK)
	{
		if (IsPlayerInAnyVehicle(playerid)) return 1;
		new i = GetPlayerNearSeed(playerid), str[100], RandomTime[3][1] = { { TIME_SEEDGROWTH / 3 }, { TIME_SEEDGROWTH * 2 / 3 }, { TIME_SEEDGROWTH } }, rand = random(sizeof(RandomTime));
		if (SeedGrowth[i] < 4 && SeedTuoiNuoc[i] == 0 && !IsPlayerAttachedObjectSlotUsed(playerid, 9) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)
		{
			SeedTuoiNuoc[i] = 1;
			ApplyAnimation(playerid, "MISC", "CASE_PICKUP", 4.0, 1, 0, 0, 0, 5000, 1);
			defer TuoiCay[RandomTime[rand][0]](i, RandomTime[rand][0]);
			SendClientMessage(playerid, COLOR_WHITE, "Ban da tuoi nuoc cho cay lua!");
			format(str, sizeof(str), "Nguoi gieo hat: %s\nCay da tuoi nuoc", SeedOwner[i]);
			UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
		}
		else if (SeedGrowth[i] == 4 && SeedGatLua[i] == 0 && !IsPlayerAttachedObjectSlotUsed(playerid, 9) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)
		{
			if (strcmp(SeedOwner[i], GLN(playerid), true) != 0 && SeedOwner[i][0] != EOS) return SendClientMessage(playerid, COLOR_GRAD1, "Day la cay thuoc so huu cua nguoi khac!");
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Crouch_Out", 4.0, 0, 0, 0, 0, 0, 1);
			DestroyDynamicObject(SeedObject[i]);
			SeedObject[i] = CreateDynamicObjectEx(2901, SeedPos[i][0] + 1.2, SeedPos[i][1], SeedPos[i][2] - 1, 4, 0.00000000, 0.00000000, 0.00000000);
			SeedTime[i] = 0;
			SeedGatLua[i] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "Ban da gat lua tu cay lua!");
			format(str, sizeof(str), "Nguoi gieo hat: %s\nLua da gat, hay mang toi kho! ({00FF00} An ALT{008080})", SeedOwner[i]);
			UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
		}
		else if (SeedGatLua[i] == 1 && !IsPlayerAttachedObjectSlotUsed(playerid, 9))
		{
			if (strcmp(SeedOwner[i], GLN(playerid), true) != 0 && SeedOwner[i][0] != EOS) return SendClientMessage(playerid, COLOR_GRAD1, "Day la cay thuoc so huu cua nguoi khac!");
			SetPlayerAttachedObject(playerid, 9, 2901, 1, 0.25, 0.470760, 0.000000, 0.000000, 90.217391, 0.000000, 0.8, 0.8, 0.8);
			SetPlayerSpecialAction(playerid, 25);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1);
			SetPVarInt(playerid, "CantUseAnim", 1);
			SendClientMessage(playerid, COLOR_WHITE, "Ban da thu hoach lua, hay mang no toi kho!");
			SetPlayerCheckpoint(playerid, -1102.0814, -1636.1648, 76.3672, 4);
			DestroySeed(i);
		}
	}
	return 1;
}
forward mSkinOnGameModeInit();
public mSkinOnGameModeInit() {
	mSkinList = LoadModelSelectionMenu("mSelection/skin.txt");
}

forward DMVMapping();
public DMVMapping() {
	RemoveBuildingForPlayer(playerid, 1412, 1996.8281, -2227.3828, 13.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1991.5547, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1986.2813, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2002.1094, -2227.3438, 13.8281, 0.25);
	CreateDynamicObject(983, 2048.29834, -1922.27002, 13.23043,   0.00000, 0.00000, -89.99998);
	CreateDynamicObject(984, 2065.23560, -1922.28430, 13.18355,   0.00000, 0.00000, -89.99998);
	CreateDynamicObject(966, 2058.55420, -1922.07886, 12.54688,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(968, 2058.54712, -1922.12927, 13.60612,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 2071.61426, -1915.90137, 13.18355,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 2071.61035, -1903.10156, 13.18355,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10829, 2064.19629, -1917.64050, 12.51599,   0.00000, 0.00000, -89.99998);
	CreateDynamicObject(1256, 2067.63452, -1915.02600, 13.20633,   0.00000, 0.00000, -89.99998);
	CreateDynamicObject(1256, 2064.99756, -1915.02466, 13.20633,   0.00000, 0.00000, -89.99998);
	CreateDynamicObject(1432, 2063.57617, -1899.12219, 12.68560,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(617, 2070.28101, -1918.01184, 12.54071,   0.00000, 0.00000, 58.49986);
	CreateDynamicObject(617, 2069.44653, -1899.83569, 12.54763,   0.00000, 0.00000, -119.93877);
	CreateDynamicObject(617, 2047.46423, -1921.01440, 12.54071,   0.00000, 0.00000, -102.47797);
	CreateDynamicObject(910, 2042.60596, -1923.32996, 13.81603,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2051.41113, -1922.13940, 13.11120,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2059.10742, -1922.08118, 13.11120,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1216, 2045.43555, -1915.30200, 13.23888,   0.00000, 0.00000, 89.99998);
	CreateDynamicObject(1216, 2045.42908, -1916.39990, 13.23888,   0.00000, 0.00000, 89.99998);
	CreateDynamicObject(1478, 2050.50610, -1922.81079, 13.18305,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3860, 2054.56519, -1898.81616, 13.71921,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1514, 2055.49072, -1899.84668, 13.63017,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2485, 2053.62866, -1899.55640, 13.41080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2490, 2054.79468, -1899.90063, 13.49693,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2489, 2054.09277, -1899.90442, 13.49718,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1671, 2055.39697, -1897.78589, 13.01402,   0.00000, 0.00000, -11.25003);
	CreateDynamicObject(3448, 216.07875, 7669.84473, -610.18018,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3448, 1852.13745, -2419.64185, 12.72000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2435.63940, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2432.41479, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2438.86279, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2442.06372, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2451.65527, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2445.24316, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2448.45264, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2454.79272, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2457.91382, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2464.25220, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2461.14722, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2465.33276, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2468.20435, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2408.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.80176, -2405.16895, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79224, -2402.06787, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.77197, -2401.22021, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1885.15979, -2399.62598, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1882.05920, -2399.62842, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1878.87280, -2399.62769, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1875.67297, -2399.63965, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1872.42517, -2399.64771, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1869.21960, -2399.65234, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1866.05457, -2399.65479, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1862.82141, -2399.66553, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1859.57788, -2399.64844, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1856.37158, -2399.66309, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1853.20679, -2399.66919, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1849.98877, -2399.65552, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1846.79028, -2399.64111, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1843.57031, -2399.64429, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1837.19299, -2399.64014, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1840.41028, -2399.64648, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1833.98840, -2399.63037, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1830.80420, -2399.64795, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1827.93579, -2399.65625, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1825.33008, -2399.65527, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1823.79163, -2401.20557, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.79968, -2404.42871, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.78577, -2407.64868, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81250, -2410.86963, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.80493, -2417.24292, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81555, -2414.05054, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81860, -2420.46509, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81848, -2423.66699, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.84106, -2426.90820, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.83960, -2430.12109, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.83044, -2433.30176, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.83838, -2436.53174, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.82092, -2439.73267, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81299, -2442.91260, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.81848, -2446.11475, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.82288, -2449.29736, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.80005, -2452.52173, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.80396, -2455.74243, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.79822, -2458.90454, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.80774, -2462.13794, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.78467, -2465.34082, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1823.79163, -2468.19580, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1849.96741, -2456.70874, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1833.03320, -2469.74487, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1830.87097, -2469.72852, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1827.68579, -2469.71582, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1825.30164, -2469.72339, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1853.23572, -2456.70874, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1856.40210, -2456.70874, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1859.64343, -2456.70874, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1862.76404, -2456.72803, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1865.92798, -2456.72192, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1869.10925, -2456.69531, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1871.52393, -2456.73267, 14.23170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, 1873.08569, -2458.50635, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1873.06958, -2461.73877, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1873.09448, -2464.93921, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1873.09851, -2468.14575, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1870.16052, -2441.35132, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1870.15295, -2436.03906, 13.56030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1870.14197, -2424.72388, 13.56030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1870.16113, -2418.78882, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1852.52026, -2425.09717, 13.56030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1852.50305, -2419.47656, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1852.54126, -2435.91504, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1852.56592, -2441.24023, 13.56030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1834.66785, -2442.50342, 13.56050,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1834.65125, -2436.27832, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1834.64099, -2425.37549, 13.56050,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1834.64734, -2419.60571, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3852, 1825.83289, -2430.33496, 12.83980,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3852, 1828.91650, -2430.31909, 12.83940,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3852, 1831.57825, -2430.30127, 12.83900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2418.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.95203, -2418.90356, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1845.23962, -2418.90356, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1848.54712, -2418.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.60754, -241.21091, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.60754, -2413.21094, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.92505, -2413.21094, 12.62000,   0.00000, 0.00000, -0.06000);
	CreateDynamicObject(19425, 1845.21350, -2413.21094, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.52161, -2413.21094, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.51501, -2415.99658, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.20691, -2415.99658, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.91919, -2415.99658, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.60156, -2415.99658, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2421.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.95203, -2421.90356, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1845.23962, -2421.90356, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1848.54712, -2421.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2424.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.95203, -2424.90356, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1845.23962, -2424.90356, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1848.54712, -2424.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2427.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.95203, -2427.90356, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1845.23962, -2427.90356, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1848.54712, -2427.90356, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2430.76001, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1841.95203, -2430.76001, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1845.23962, -2430.76001, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1848.54712, -2430.76001, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1838.63477, -2433.76001, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.54712, -2433.76001, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2433.76001, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2433.76001, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1848.54712, -2436.64990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2436.64990, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2436.64990, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1838.63477, -2436.64990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.54712, -2439.64990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2439.64990, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2439.64990, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1838.63477, -2439.64990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.54712, -2442.55005, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2442.55005, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2442.55005, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1838.63477, -2442.55005, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.54712, -2445.55005, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2445.55005, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2445.55005, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1838.63477, -2445.55005, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1848.54712, -2448.39990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1845.23962, -2448.39990, 12.62000,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19425, 1841.95203, -2448.39990, 12.62000,   0.00000, 0.00000, 0.12000);
	CreateDynamicObject(19425, 1838.63477, -2448.39990, 12.62000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3852, 1831.57825, -2432.80127, 12.83900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3852, 1828.91650, -2432.81909, 12.83940,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3852, 1825.83289, -2432.83496, 12.83980,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2411.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2414.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2417.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2420.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2423.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2426.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, 1886.79260, -2429.34961, 14.23170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8843, 1879.71912, -2447.69141, 12.61000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8843, 1841.19275, -2463.11865, 12.61000,   0.00000, 0.00000, -134.00000);
	CreateDynamicObject(8843, 1829.09741, -2440.98413, 12.61000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3578, 1837.08923, -2448.46631, 13.06050,   0.00000, 0.00000, -65.00000);
	CreateDynamicObject(3578, 1843.79919, -2454.59009, 13.06050,   0.00000, 0.00000, -20.00000);
	CreateDynamicObject(19131, 1842.02991, -2435.22534, 13.10000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19131, 1844.94751, -2426.69263, 13.10000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19131, 1842.49963, -2414.75488, 13.10000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3578, 1852.52026, -2408.49634, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1852.52026, -2404.99634, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1870.16052, -2451.35132, 13.56000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8843, 1861.71912, -2432.19141, 12.61000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3578, 1882.44043, -2403.14185, 13.06050,   0.00000, 0.00000, -40.00000);
	CreateDynamicObject(973, 1846.48315, -2435.07910, 13.09680,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(973, 1840.48315, -2426.57910, 13.09680,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(973, 1846.98315, -2414.57910, 13.09680,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(4639, 1887.92175, -2420.34204, 14.33920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1828.54944, -2465.64258, 13.06050,   0.00000, 0.00000, -40.00000);
	CreateDynamicObject(973, 1855.89551, -2420.39160, 13.09680,   0.00000, 0.00000, -60.00000);
	CreateDynamicObject(973, 1862.30078, -2417.04883, 13.09680,   0.00000, 0.00000, -60.00000);
	CreateDynamicObject(973, 1859.05286, -2429.18213, 13.09680,   0.00000, 0.00000, -80.00000);
	CreateDynamicObject(973, 1865.49878, -2425.77075, 13.09680,   0.00000, 0.00000, -80.00000);
	CreateDynamicObject(973, 1859.11963, -2438.56763, 13.09680,   0.00000, 0.00000, -100.00000);
	CreateDynamicObject(973, 1865.86816, -2435.10059, 13.09680,   0.00000, 0.00000, -95.00000);
	CreateDynamicObject(973, 1864.20496, -2444.49780, 13.09680,   0.00000, 0.00000, -105.00000);
	CreateDynamicObject(973, 1854.75745, -2446.28809, 13.09680,   0.00000, 0.00000, -140.00000);
	CreateDynamicObject(973, 1859.16821, -2451.70093, 13.09680,   0.00000, 0.00000, -145.00000);
	CreateDynamicObject(973, 1864.88257, -2412.55688, 13.09680,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11711, 1834.19849, -2469.59790, 15.10512,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19957, 1871.89783, -2448.45679, 12.59191,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19961, 1863.39685, -2448.95679, 12.58160,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19961, 1864.96301, -2421.15942, 12.58160,   0.00000, 0.00000, 230.00000);
	CreateDynamicObject(19971, 1873.28137, -2455.56860, 12.59500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8843, 1829.09741, -2422.48413, 12.61000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19977, 1834.62366, -2412.84961, 12.83660,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19959, 1855.17810, -2454.51685, 12.59490,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19960, 1881.00342, -2402.18091, 13.83630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19960, 1835.77954, -2414.12866, 12.83630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1828.03638, -2403.29419, 13.06050,   0.00000, 0.00000, 40.00000);
}

task Plant[1000]()
{
	/////////////////////////////////////////Growth///////////////////
	for (new i = 0; i<MAXSEED; i++)
	{
		if (IsValidDynamicObject(SeedObject[i]))
		{
			SeedTime[i] += 1000;
			if (SeedGatLua[i] == 0 && SeedTime[i] == TIME_CAYHEO && (SeedGrowth[i] == 1 || SeedGrowth[i] == 2 || SeedGrowth[i] == 3 || SeedGrowth[i] == 4))
			{
				RiceGrowth(i, 5);
			}
			else if (SeedGatLua[i] == 0 && SeedTime[i] == TIME_CAYCHET && SeedGrowth[i] == 5)
			{
				RiceGrowth(i, 6);
			}
			else if (SeedGatLua[i] == 0 && SeedTime[i] == (TIME_CAYCHET / 2) && SeedGrowth[i] == 6)
			{
				DestroySeed(i);
			}
			else if (SeedTime[i] == TIME_CAYHEO && SeedGatLua[i] == 1) DestroySeed(i);
		}
	}
	return 1;
}
timer TuoiCay[15000](i, time)
{
	new str[100];
	SeedTuoiNuoc[i] = 0;
	SeedTime[i] = 0;
	SeedTotal[i] += time;
	format(str, sizeof(str), "Nguoi gieo hat: %s\n[Can] Tuoi nuoc ({00FF00} An ALT{008080})", SeedOwner[i]);
	UpdateDynamic3DTextLabelText(SeedText[i], 0x008080FF, str);
	if (SeedTotal[i] >= TIME_SEEDGROWTH)
	{
		if (SeedGrowth[i] == 5)  RiceGrowth(i, 2);
		RiceGrowth(i, SeedGrowth[i] + 1);
	}
	return 1;
}
timer NewbieChannel[1000](playerid)
{
	SetPVarInt(playerid, "InNewbieChannel", 0);
}
timer RequestAdvisor[1000](playerid)
{
	SetPVarInt(playerid, "CanTroGiup", 0);
}
