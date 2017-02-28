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
//stock IsPlayerInRectangle(playerid, Float:x1, Float:y1, Float:x2, Float:y2)
//{
//	if (IsPlayerConnected(playerid))
//	{
//		new Float:xs, Float:ys, Float:zs;
//		GetPlayerPos(playerid, xs, ys, zs);
//		return IsPointInRectangle(xs, ys, x1, y1, x2, y2);
//	}
//	return 0;
//}
//stock IsPointInRectangle(Float:xs, Float:ys, Float:x1, Float:y1, Float:x2, Float:y2)
//{
//	if (IsBetweenFloats(xs, x1, x2) && IsBetweenFloats(ys, y1, y2))
//	{
//		return 1;
//	}
//	return 0;
//}
//stock IsBetweenFloats(Float:f, Float:f1, Float:f2)
//{
//	switch (floatcmp(f1, f2))
//	{
//	case 0: if (f == f1) { return 1; }
//	case 1: if (f <= f1 && f >= f2) { return 1; }
//	case -1: if (f >= f1 && f <= f2) { return 1; }
//	}
//	return 0;
//}
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
	else if (!strcmp(params, "trongtrot", true))
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

CMD:thibanglai(playerid, params[]){
	if(!PlayerToPoint(5,playerid,2063.0376,-1914.9541,13.5469))
		return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong dung tai dia diem thi bang lai");
	new str[255];
	format(str, sizeof(str), "Ban can co it nhat $%d dong le phi thi bang lai", DMVFEE);
	if(GetPlayerMoney(playerid) < DMVFEE) return SendClientMessage(playerid, COLOR_GRAD1, str);
	if(DriverLicenseCar[playerid] != INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GRAD1, "Vui long tap trung vao bai thi hien tai cua ban");

	SafeGivePlayerMoney(playerid, -DMVFEE);
	DisablePlayerRaceCheckpoint(playerid);
	SetPVarInt(playerid,"DriverLicenseTest", 1);
	SendClientMessage(playerid, COLOR_WHITE, "Len xe de bat dau bai thi bang lai.");
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

forward IncOnPlayerDisconnect(playerid, reason);
public IncOnPlayerDisconnect(playerid, reason) {
	SetPVarInt(playerid,"DMVSuccess", 0);
	SetPVarInt(playerid,"DriverLicenseTest", 0);
	DisablePlayerRaceCheckpoint(playerid);
	DestroyDriverLicenseTD(playerid);
	stop DriverLicenseLoop[playerid];
	if(DriverLicenseCar[playerid] != INVALID_VEHICLE_ID) {
		SetVehicleToRespawn(DriverLicenseCar[playerid]);
		DriverLicenseCar[playerid] = INVALID_VEHICLE_ID;
		SafeGivePlayerMoney(playerid, DMVFEE);
		for(new i=0; i < MAX_PLAYERS; i++) {
			SetVehicleParamsForPlayer(DriverLicenseCar[playerid],i,0,0);
		}
	}

}

forward DMVOnPlayerEnterRaceCP(playerid);
public DMVOnPlayerEnterRaceCP(playerid) {
	for	(new i = 0; i<8; ++i) {
		if (DriverLicenseCar[playerid] != INVALID_VEHICLE_ID && IsPlayerInRangeOfPoint(playerid, 5, DriverLicensePos[i][0], DriverLicensePos[i][1], DriverLicensePos[i][2])) {
			new raceType = 0;
			if(i == 4) {
				SetVehicleHealth(DriverLicenseCar[playerid], 1000);
				new str[500];
				str = "Khong duoc dung xe\nHealth phai tren 900";
				ShowPlayerDialog(playerid, DIALOG_DRIVERLICENSE_RULE, DIALOG_STYLE_MSGBOX, "Quy tac bai sat hach", str, "Bat dau", "");
				ShowDriverLicenseTD(playerid);
				DriverLicenseTime[playerid] = 0.0;
			}
			if(i == 7) raceType = 1;
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, raceType, DriverLicensePos[i+1][0], DriverLicensePos[i+1][1], DriverLicensePos[i+1][2], DriverLicensePos[i+2][0], DriverLicensePos[i+2][1], DriverLicensePos[i+2][2], 5);
		}

	}
	if (DriverLicenseCar[playerid] != INVALID_VEHICLE_ID && IsPlayerInRangeOfPoint(playerid, 5, DriverLicensePos[8][0], DriverLicensePos[8][1], DriverLicensePos[8][2])) {
		stop DriverLicenseLoop[playerid];
		new Float:health;
		GetVehicleHealth(DriverLicenseCar[playerid], health);
		if(health > 900) {
			GameTextForPlayer(playerid, "~w~Chuc mung ban hoan thanh bai sat hach lai xe~n~Tro lai DMV de nhan bang lai xe", 5000, 3);
			SetPVarInt(playerid,"DMVSuccess", 1);
		}
		else {
			GameTextForPlayer(playerid, "~w~Cam on ban da hoan thanh bai sat hach lai xe~n~Tro lai DMV de nhan ket qua", 5000, 3);
			SetPVarInt(playerid,"DMVSuccess", 0);
		}
		CreateDynamicCP(DriverLicensePos[9][0], DriverLicensePos[9][1], DriverLicensePos[9][2], 5);
	}
}

forward DMVOnPlayerEnterCP(playerid);
public DMVOnPlayerEnterCP(playerid) {
	if (DriverLicenseCar[playerid] != INVALID_VEHICLE_ID && IsPlayerInRangeOfPoint(playerid, 5, DriverLicensePos[9][0], DriverLicensePos[9][1], DriverLicensePos[9][2])) {
		if(GetPVarInt(playerid, "DMVSuccess") == 1) {
			PlayerInfo[playerid][pCarLic] = 1;
			GameTextForPlayer(playerid, "~w~Chuc mung ban da nhan duoc bang lai xe", 5000, 3);
		}
		else {
			SendClientMessage(playerid, COLOR_GRAD1, "Rat tiec nhung ban da rot trong bai thi sat hach bang lai xe");
		}
		RemovePlayerFromVehicle(playerid);
		SetVehicleToRespawn(DriverLicenseCar[playerid]);
		DriverLicenseCar[playerid] = INVALID_VEHICLE_ID;
	}
}

forward ShowDriverLicenseTD(playerid);
public ShowDriverLicenseTD(playerid) {
	for(new i=0; i<5; i++) {
		PlayerTextDrawShow(playerid,DriverLicenseTD[playerid][i]);
	}
}

forward DestroyDriverLicenseTD(playerid);
public DestroyDriverLicenseTD(playerid) {
	for(new i=0; i<5; i++) {
		PlayerTextDrawDestroy(playerid,DriverLicenseTD[playerid][i]);
	}
}

forward HideDriverLicenseTD(playerid);
public HideDriverLicenseTD(playerid) {
	for(new i=0; i<5; i++) {
		PlayerTextDrawHide(playerid,DriverLicenseTD[playerid][i]);
	}
}

forward InitDriverLicenseTD(playerid);
public InitDriverLicenseTD(playerid) {
	DriverLicenseTD[playerid][0] = CreatePlayerTextDraw(playerid, 627.916809, 340.889007, "A");
	PlayerTextDrawLetterSize(playerid, DriverLicenseTD[playerid][0], 0.529167, 6.572588);
	PlayerTextDrawTextSize(playerid, DriverLicenseTD[playerid][0], 488.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, DriverLicenseTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, DriverLicenseTD[playerid][0], -16777216);
	PlayerTextDrawUseBox(playerid, DriverLicenseTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, DriverLicenseTD[playerid][0], 120);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, DriverLicenseTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, DriverLicenseTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, DriverLicenseTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, DriverLicenseTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][0], 0);

	DriverLicenseTD[playerid][1] = CreatePlayerTextDraw(playerid, 500.000000, 350.000000, "Health");
	PlayerTextDrawLetterSize(playerid, DriverLicenseTD[playerid][1], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, DriverLicenseTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, DriverLicenseTD[playerid][1], -1378294017);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, DriverLicenseTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, DriverLicenseTD[playerid][1], 16777215);
	PlayerTextDrawFont(playerid, DriverLicenseTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, DriverLicenseTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][1], 0);

	DriverLicenseTD[playerid][2] = CreatePlayerTextDraw(playerid, 500.000000, 375.000000, "Time");
	PlayerTextDrawLetterSize(playerid, DriverLicenseTD[playerid][2], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, DriverLicenseTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, DriverLicenseTD[playerid][2], -1378294017);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, DriverLicenseTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, DriverLicenseTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, DriverLicenseTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, DriverLicenseTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][2], 0);

	DriverLicenseTD[playerid][3] = CreatePlayerTextDraw(playerid, 550.000000, 350.000000, "1000");
	PlayerTextDrawLetterSize(playerid, DriverLicenseTD[playerid][3], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, DriverLicenseTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, DriverLicenseTD[playerid][3], -2139062017);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, DriverLicenseTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, DriverLicenseTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, DriverLicenseTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, DriverLicenseTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][3], 0);

	DriverLicenseTD[playerid][4] = CreatePlayerTextDraw(playerid, 550.000000, 375.000000, "0.0");
	PlayerTextDrawLetterSize(playerid, DriverLicenseTD[playerid][4], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, DriverLicenseTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, DriverLicenseTD[playerid][4], -2139062017);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, DriverLicenseTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, DriverLicenseTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, DriverLicenseTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, DriverLicenseTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, DriverLicenseTD[playerid][4], 0);
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
timer DriverLicenseTimer[100](playerid) {
	new Float:health, str[12];
	DriverLicenseTime[playerid]+=0.1;
	GetVehicleHealth(DriverLicenseCar[playerid], health);
	format(str, sizeof(str), "%.1f", health );
	PlayerTextDrawSetString(playerid, DriverLicenseTD[playerid][3], str);
	format(str, sizeof(str), "%.1f", DriverLicenseTime[playerid] );
	PlayerTextDrawSetString(playerid, DriverLicenseTD[playerid][4], str);
}