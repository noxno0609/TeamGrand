stock ClearNails()
{
	for (new i = 0; i < MAX_NAILS; i++)
	{
		NailObject[i] = INVALID_OBJECT_ID;
	}

	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		InNails[i] = -1;
	}
	return 1;
}
stock GetClosestBehindPrisoner(playerid, Float:distancet = 2.0)
{
	new Float:mindistance = distancet;
	new ppri = -1;
	foreach(new pp: Player)
	{
		if (PlayerCuffed[pp] != 0)
		{
			new Float:pos[3];
			GetXYBehindPlayer(pp, pos[0], pos[1], pos[2]);
			new Float:pzdistance;
			pzdistance = GetDistanceToPointXY(playerid, pos[0], pos[1]);
			if (pzdistance < mindistance)
			{
				mindistance = pzdistance;
				ppri = pp;
			}
		}
	}
	return ppri;
}
stock CreateServerNails()
{
	ClearNails();
	for (new i = 0; i < LIMIT_NAILS; i++)
	{
		new rand = random(MAX_NAILS - 1);
		while (NailObject[rand] != INVALID_OBJECT_ID)
		{
			rand = random(MAX_NAILS - 1);
		}
		NailObject[rand] = CreateDynamicObject(19351, NailPos[rand][0], NailPos[rand][1], NailPos[rand][2] - 1.0025, -90, 0, NailPos[rand][3]);
		printf("Load Nails ID: %d Object ID: %d", rand, NailObject[rand]);
		CountNails++;
	}
	return 1;
}
stock CreateDailyNails()
{
	new countcreate = LIMIT_NAILS - CountNails;
	if (countcreate > 10) countcreate = 5;
	else if (countcreate <= 0) return 0;
	for (new i = 0; i < countcreate; i++)
	{
		new rand = random(MAX_NAILS - 1);
		while (NailObject[rand] != INVALID_OBJECT_ID)
		{
			rand = random(MAX_NAILS - 1);
		}
		NailObject[rand] = CreateDynamicObject(19351, NailPos[rand][0], NailPos[rand][1], NailPos[rand][2] - 1.0025, -90, 0, NailPos[rand][3]);
		printf("Daily Nails ID: %d Object ID: %d", rand, NailObject[rand]);
	}
	return 1;
}
stock CheckVehicleInNails(vehid)
{
	for (new i = 0; i < MAX_NAILS; i++)
	{
		//if (!IsVehicleConnected(i)) continue;
		if (NailObject[i] == INVALID_OBJECT_ID) continue;
		new tire = GetClosestTire(vehid, i);
		if (tire != -1 && i != InNails[vehid])
		{
			BreakTire(vehid, tire, i);
		}
	}
	return 1;
}
stock BreakTire(vehid, idtire, nailid)
{
	new Panels, Doors, Lights, Tires;
	GetVehicleDamageStatus(vehid, Panels, Doors, Lights, Tires);
	new idbinary = InputTireBinary(Tires, idtire);
	UpdateVehicleDamageStatus(vehid, Panels, Doors, Lights, idbinary);
	PlayerPlaySound(GetVehicleDriverID(vehid), 1009, 0.0, 0.0, 0.0);
	GetVehicleDamageStatus(vehid, CarRepairCheat[vehid][0], CarRepairCheat[vehid][1], CarRepairCheat[vehid][2], CarRepairCheat[vehid][3]);
	InNails[vehid] = nailid;
	return 1;
}
stock GetNearestNails(playerid, &Float:distance, &nailid)
{
	distance = 1000;
	for (new i = 0; i < MAX_NAILS; i++)
	{
		if (NailObject[i] == INVALID_OBJECT_ID) continue;

		new Float:objpos[3];
		GetDynamicObjectPos(NailObject[i], objpos[0], objpos[1], objpos[2]);
		new Float:distancez = GetDistanceToPoint(playerid, objpos[0], objpos[1], objpos[2]);
		if (distancez < distance)
		{
			nailid = i;
			distance = distancez;
		}
	}
	return 1;
}
stock InputTireBinary(tireb, idtire)
{
	new str[64];
	format(str, sizeof(str), "%s", TireBinary[tireb]);
	if (str[idtire] == '0')
		str[idtire] = '1';

	for (new i = 0; i < sizeof(TireBinary); i++)
	{
		if (!strcmp(str, TireBinary[i], true))
			return i;
	}
	return -1;
}
stock IsPointInRangeOfPoint(Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:range)
{
	x2 -= x;
	y2 -= y;
	z2 -= z;
	return ((x2 * x2) + (y2 * y2) + (z2 * z2)) < (range * range);
}
// Tire IDs: -1 (Not near a tire), 0 (Front-left), 1 (Back-left), 2 (Back-right), 3 (Front-right)
stock GetClosestTire(car, nailid)
{
	new Float:p[3], Float:c[3], Float:ang, Float:dist[2], tire;

	GetDynamicObjectPos(NailObject[nailid], p[0], p[1], p[2]);
	GetVehiclePos(car, c[0], c[1], c[2]);

	if (!IsPointInRangeOfPoint(c[0], c[1], c[2], p[0], p[1], p[2], 2)) return -1;

	GetVehicleZAngle(car, ang);

	tire = -1;
	dist[0] = Float:0xFFFFFFFF;
	ang += 45.0;
	for (new t = 0; t < 4; t++, ang += 90.0)
	{
		dist[1] = floatsqroot(
			((p[0] - (c[0] + floatsin(-ang, degrees))) * (p[0] - (c[0] + floatsin(-ang, degrees)))) +
			((p[1] - (c[1] + floatcos(-ang, degrees))) * (p[1] - (c[1] + floatcos(-ang, degrees)))));

		if (dist[1] < dist[0])
		{
			dist[0] = dist[1];
			tire = t;
		}
	}
	return tire;
}
stock DeleteNail(nailid)
{
	if (NailObject[nailid] != INVALID_OBJECT_ID)
	{
		DestroyDynamicObject(NailObject[nailid]);
		NailObject[nailid] = INVALID_OBJECT_ID;
		CountNails--;
	}
	return 1;
}
forward TazerKeyStateChange(playerid, newkeys, oldkeys);
public TazerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE && Tazering[playerid] == 1 && !IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		foreach(new i : Player)
		{
			if (PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pLeader] == 1 
				|| PlayerInfo[i][pMember] == 17 || PlayerInfo[i][pLeader] == 17) continue;
			if (IsPlayerNearPlayer(playerid, i, 2) && i != playerid && Tazered[i] == 0 && !IsPlayerInAnyVehicle(i))
			{
				Tazered[i] = 15;
				TogglePlayerControllable(i, 0);
				ApplyAnimation(i, "KNIFE", "knife_hit_3", 4.1, 0, 1, 1, 1, 0, 1);
				SetTimerEx("TazeredCollapse", 1000, 0, "i", i);
			}
		}
	}
	if (newkeys & KEY_HANDBRAKE && !IsPlayerInAnyVehicle(playerid) && GetPlayerWeapon(playerid) == 0)
	{
		if (WearTazer[playerid] == 1)
		{
			if (Tazering[playerid] == 0)
			{
				Tazering[playerid] = 1;
				SetPlayerAttachedObject(playerid, 5, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0);
			}
			else if (Tazering[playerid] == 1)
			{
				Tazering[playerid] = 0;
				SetPlayerAttachedObject(playerid, 5, 18642, 1, -0.197000, -0.071000, -0.109999, 2.399994, 80.400001, 18.399993, 1.000000, 1.000000, 1.000000, 0, 0);
			}
		}
	}
}
forward TazeredCollapse(playerid);
public TazeredCollapse(playerid)
{
	ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1);
	return 1;
}
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(targetid, x, y, z);
	if (IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	{
		return 1;
	}
	return 0;
}
forward OnPIDUpdate(playerid);
public OnPIDUpdate(playerid)
{
	//SCM(playerid, COLOR_GREEN, "ABCDXYZ");
}
stock SCM(playerid, color, message[])
{
	return SendClientMessage(playerid, color, message);
}
stock GLN(playerid)
{
    new name[40];
    GetPlayerName(playerid,name,sizeof(name));
    return name;
}
stock GN(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,sizeof(name));
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if(name[i] == '_') name[i] = ' ';
    }
    return name;
}
stock IsAdminVehicle(vid)
{
	for (new i = 0; i < MAXCUSTOMVEH; i++)
	{
		if (vid == aVeh[i])
			return i;
	}
	return -1;
}
stock IsAnyAdminInVehicle(vid)
{
	foreach(new i : Player)
	{
		if (PlayerInfo[i][pAdmin] > 0 && IsPlayerInVehicle(i, vid))
			return true;
	}
	return false;
}
stock RespawnCar(vid)
{
	new newvid = CreateVehicle2(CarInfo[vid][cModel], CarInfo[vid][cLocationx], CarInfo[vid][cLocationy], CarInfo[vid][cLocationz], CarInfo[vid][cAngle], CarInfo[vid][cColorOne], CarInfo[vid][cColorTwo], 60000);
	CarInfo[newvid][cID] = CarInfo[vid][cID];
	CarInfo[newvid][cModel] = CarInfo[vid][cModel];
	CarInfo[newvid][cLocationx] = CarInfo[vid][cLocationx];
	CarInfo[newvid][cLocationy] = CarInfo[vid][cLocationy];
	CarInfo[newvid][cLocationz] = CarInfo[vid][cLocationz];
	CarInfo[newvid][cAngle] = CarInfo[vid][cAngle];
	CarInfo[newvid][cColorOne] = CarInfo[vid][cColorOne];
	CarInfo[newvid][cColorTwo] = CarInfo[vid][cColorTwo];
	format(CarInfo[newvid][cOwner], 128, "%s", CarInfo[vid][cOwner]);
	format(CarInfo[newvid][cDescription], 128, "%s", CarInfo[vid][cDescription]);
	CarInfo[newvid][cValue] = CarInfo[vid][cValue];
	CarInfo[newvid][cLicense] = CarInfo[vid][cLicense];
	CarInfo[newvid][cRegistration] = CarInfo[vid][cRegistration];
	CarInfo[newvid][cOwned] = CarInfo[vid][cOwned];
	CarInfo[newvid][cLock] = CarInfo[vid][cLock];
	CarInfo[newvid][cType] = CarInfo[vid][cType];
	DestroyCar(vid);
	return 1;
}
stock GetVehicleByCarID(id)
{
	foreach(new i : Vehicle)
	{
		if (CarInfo[i][cID] == id)
		{
			return i;
		}
	}
	return -1;
}
stock DestroyCar(vid)
{
	CarInfo[vid][cID] = -1;
	CarInfo[vid][cModel] = 0;
	CarInfo[vid][cLocationx] = 0;
	CarInfo[vid][cLocationy] = 0;
	CarInfo[vid][cLocationz] = 0;
	CarInfo[vid][cAngle] = 0;
	CarInfo[vid][cColorOne] = 0;
	CarInfo[vid][cColorTwo] = 0;
	format(CarInfo[vid][cOwner], 128, "");
	format(CarInfo[vid][cDescription], 128, "");
	CarInfo[vid][cValue] = 0;
	CarInfo[vid][cLicense] = 0;
	CarInfo[vid][cRegistration] = 0;
	CarInfo[vid][cOwned] = 0;
	CarInfo[vid][cLock] = 0;
	CarInfo[vid][cType] = 0;
	DestroyVehicle2(vid);
	return 1;
}
stock GetVehicleIDFromKey(keyid)
{
	if (keyid == -1) return -1;
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		if (CarInfo[i][cID] == keyid)
			return i;
	}
	return -1;
}

stock GetWaitingTextDraw(playerid)
{
	for (new i = 0; i < sizeof(WaitGTString[]); i++)
	{
		if (isnull(WaitGTString[playerid][i]))
			return i;
	}
	return -1;
}

stock GameTextPlayer(playerid, str[], time, type, bool:wait = false)
{
	new textslot = GetWaitingTextDraw(playerid);
	if (textslot == -1) return 1;

	new deftime = 0, trealtime = time;
	switch (type)
	{
		case 0: deftime = 9000;
		case 1: deftime = 8000;
		case 5: deftime = 3000;
	}
	if (time < deftime)
		trealtime = deftime;

	if (NowGTTime[playerid] <= 0 || wait == false)
		GameTextForPlayer(playerid, str, time, type);
	else
	{
		format(WaitGTString[playerid][textslot], 128, "%s", str);
		SetTimerEx("TimerGameText", NowGTTime[playerid], false, "iiii", playerid, time, type, textslot);
	}
	
	NowGTTime[playerid] += trealtime;
	return 1;
}
forward TimerGameText(playerid, time, type, textslot);
public TimerGameText(playerid, time, type, textslot)
{
	GameTextForPlayer(playerid, WaitGTString[playerid][textslot], time, type);
	WaitGTString[playerid][textslot][0] = EOS;
	return 1;
}
CMD:testgt(playerid, params[])
{
		 GameTextPlayer(playerid, "TesT", 3000, 4);
			 return 1;
}
stock GetFirstParams(const string[], result[], len)
{
	new index;
	format(result, len, "%s", strtok(string, index));
	return 1;
}
stock CountParams(const string[])
{
	new count = 0;
	for (new i = 0; i < strlen(string); i++)
	{
		if (string[i] == ' ' && string[i + 1] != ' ')
			count++;
	}
	return count;
}
stock IsValidIP(string[])
{
	new dotCount;
	for (new i; string[i] != EOS; ++i)
	{
		if (('0' <= string[i] <= '9') || string[i] == '.')
		{
			if ((string[i] == '.') && (string[i + 1] != '.') && ('0' <= string[i - 1] <= '9'))
			{
				++dotCount;
			}
			continue;
		}
	}
	return (dotCount > 2) ? 1 : 0;
}
CMD:veh(playerid, params[])
{
		 if (PlayerInfo[playerid][pAdmin] == 0) return SCM(playerid, COLOR_GREY, "Khong co quyen han su dung cau lenh nay.");
		 new id, Float:pos[4], col[2], string[256];
		 if (sscanf(params, "iii", id, col[0], col[1])) return SCM(playerid, COLOR_GRAD2, "Su dung: /veh [vehicleid/destroy] [color1] [color2]");
		 if (id < 400 || id > 611) return SCM(playerid, COLOR_GREY, "ID tu 400 den 611.");
		 GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		 GetPlayerFacingAngle(playerid, pos[3]);
		 for (new i = 0; i<MAXCUSTOMVEH; i++)
		 {
			 if (!aVeh[i])
			 {
				 aVeh[i] = CreateVehicle2(id, pos[0], pos[1], pos[2], pos[3], col[0], col[1], 1200);
				 new str[128];
				 format(str, sizeof(str), "Xe He Thong\nID Veh: %d", i);
				 aVehLabel[i] = Create3DTextLabel(str, COLOR_YELLOW, 0, 0, 0, 30, 0, 0);
				 Attach3DTextLabelToVehicle(aVehLabel[i], aVeh[i], 0, 0, 0);
				 aColor[i][0] = col[0];
				 aColor[i][1] = col[1];
				 return 1;
			 }
		 }
		 format(string, sizeof(string), "AdmCMD: %s da tao mot Admin Vehicle ID %d.", GLN(playerid), id);
		 SendAdminMessage(COLOR_LIGHTRED, string);
		 return 1;
}
CMD:xoaveh(playerid, params[])
{
		 if (IsPlayerInAnyVehicle(playerid) && isnull(params))
		 {
			 new avid = IsAdminVehicle(GetPlayerVehicleID(playerid));
			 if (avid != -1)
				 DeleteAdminVeh(avid);
			 return 1;
		 }
		 new vidid[50];
		 if (sscanf(params, "s[50]", vidid))
		 {
			 SCM(playerid, COLOR_GRAD2, "Su dung: /xoaveh [lua chon]");
			 SCM(playerid, COLOR_GRAD2, "[Lua chon]: All, VehID");
			 return 1;
		 }
		 if (!(strcmp(vidid, "all", true)))
		 {
			 for(new i=0;i<MAXCUSTOMVEH;i++)
			 {
				 if (aVeh[i] != INVALID_VEHICLE_ID && !IsAnyAdminInVehicle(aVeh[i]))
					DeleteAdminVeh(i);
			 }
			 SendAdminMessage(COLOR_LIGHTRED, "AdmCMD: Da xoa tat ca Admin Vehicle!");
			 return 1;
		 }
		new avid = strval(vidid);
		if (avid != -1)
		{
			DeleteAdminVeh(avid);
			SCM(playerid, COLOR_LIGHTRED, "AdmCMD: Da xoa chiec Admin Vehicle nay thanh cong!");
			return 1;
		}
		else SCM(playerid, COLOR_GREY, "Id Admin Vehicle khong hop le.");
		//else SCM(playerid, COLOR_GREY, "Chiec xe nay khong ton tai.");
		 return 1;
}
CMD:spec(playerid, params[])
{
		if (PlayerInfo[playerid][pAdmin] == 0) return SCM(playerid, COLOR_GREY, "Khong du quyen han de su dung cau lenh nay.");
		if (strcmp(params, "off", true) == 0)
		{
			if (Spectating[playerid] == 1)
				TogglePlayerSpectating(playerid, 0);

			else SCM(playerid, COLOR_GREY, "Hien ban khong theo doi ai.");
		}
		else
		{
			new pspec;
			if (sscanf(params, "u", pspec)) return SCM(playerid, COLOR_GRAD2, "Su dung: /spec [Ten/ID Nguoi Choi]");
			if (pspec == INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY, "Nguoi choi nay khong ton tai.");
			if (Spectating[playerid] == 0)
			{
				GetPlayerPos(playerid, SpecPos[playerid][0], SpecPos[playerid][1], SpecPos[playerid][2]);
				SpecInt[playerid] = GetPlayerInterior(playerid);
				SpecVWorld[playerid] = GetPlayerVirtualWorld(playerid);
			}
			TogglePlayerSpectating(playerid, 1);
			if (IsPlayerInAnyVehicle(pspec))
			{
				new carid = GetPlayerVehicleID(pspec);
				PlayerSpectateVehicle(playerid, carid);
			}
			else PlayerSpectatePlayer(playerid, pspec, 0);
			SpecPlayer[playerid] = pspec;
			Spectating[playerid] = 1;
			Spectated[SpecPlayer[playerid]]++;
		}
		return 1;
}
stock DeleteAdminVeh(avid)
{
	Delete3DTextLabel(aVehLabel[avid]);
	new vid = aVeh[avid];
	DestroyVehicle2(vid);
	aVeh[avid] = 0;
}
stock ClearOffer(playerid)
{
	SetPVarInt(playerid, "OfferBy", 0);
	SetPVarInt(playerid, "OfferP", 0);
	SetPVarInt(playerid, "OfferA", 0);
	SetPVarInt(playerid, "OfferG", 0);
	SetPVarInt(playerid, "OfferM", 0);
	SetPVarInt(playerid, "OfferType", 0);
}
stock IsPlayerInBike(playerid)
{
	new vmd = GetVehicleModel(GetPlayerVehicleID(playerid));
	if (IsPlayerInAnyVehicle(playerid)
		&& (vmd == 448 || vmd == 461 || vmd == 462 || vmd == 463 || vmd == 468
			|| vmd == 471 || vmd == 481 || vmd == 509 || vmd == 510 || vmd == 521
			|| vmd == 522 || vmd == 523 || vmd == 581 || vmd == 586))
	{
		return 1;
	}
	return 0;
}
forward Float:GetVehicleSpeed(vehicleid, UseMPH);
public Float:GetVehicleSpeed(vehicleid, UseMPH)
{
    new Float:speed_x,Float:speed_y,Float:speed_z,Float:temp_speed;
    GetVehicleVelocity(vehicleid,speed_x,speed_y,speed_z);
    if(UseMPH == 0) temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*136.666667;
	else temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*85.4166672;
    floatround(temp_speed,floatround_round);
	return temp_speed;
}
stock ClearAllVehicle()
{
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		CarInfo[i][cID] = -1;
		Trucking[i] = 0;
		CarRepairCheat[i][0] = 0;
		CarHealthCheat[i] = 1000;
		PizzaVehicle[i] = 0;
	}
	return 1;
}
stock ClearAllBiz()
{
	for (new i = 0; i < MAX_BIZ; i++)
	{
		BizzInfo[i][bID] = -1;
	}
	for (new i = 0; i < MAX_SBIZ; i++)
	{
		SBizzInfo[i][sbID] = -1;
	}
}
stock ClearApGiai(playerid)
{
	if (Escorting[playerid] == 1)
	{
		Escorting[playerid] = 0;
		SCM(EscortedPlayer[playerid], COLOR_YELLOW, "Nguoi ap giai ban vua thoat khoi server.");
		Escorted[EscortedPlayer[playerid]] = 0;
		EscortedPlayer[playerid] = -1;
	}
	if (Escorted[playerid] == 1)
	{
		Escorted[playerid] = 0;
		foreach(new i : Player)
		{
			if (EscortedPlayer[i] == playerid)
			{
				SCM(i, COLOR_YELLOW, "Nguoi ban ap giai vua thoat khoi server.");
				Escorting[i] = 0;
				EscortedPlayer[i] = -1;
			}
		}
	}
	return 1;
}
stock GetIp(playerid)
{
	new ip[30];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}
stock IsAtATM(playerid)
{
	if (PlayerToPoint(1.5, playerid, 1346.5016, -1758.7649, 13.5156)
		|| PlayerToPoint(1.5, playerid, 1592.7152, -2335.3748, 13.5400)
		|| PlayerToPoint(1.5, playerid, 2308.4612, -1634.4176, 14.8270)
		|| PlayerToPoint(1.5, playerid, 2865.9014, -1415.4203, 11.0061)
		|| PlayerToPoint(1.5, playerid, 2404.5913, -1229.8973, 23.8301)
		|| PlayerToPoint(1.5, playerid, 1172.5912, -1328.4365, 15.4034))
		return 1;
	return 0;
}
CMD:buonlau(playerid, params[])
{
	if (countFaction(PD) < 3) return SCM(playerid, COLOR_GREY, "Phai co it nhat 3 canh sat onduty trong server moi co the thuc hien.");
	if (gTeam[playerid] == TEAMGOV || IsACop(playerid)) return SCM(playerid, COLOR_GREY, "Ban la nhan vien chinh phu, khong the di buon lau.");
	if (PlayerInfo[playerid][pLevel] < 5) return SCM(playerid, COLOR_GREY, "Ban phai dat cap 8 moi co the di buon.");
	if (!IsPlayerInRangeOfPoint(playerid, 3, -1111.4635, -1681.5151, 76.3739)) return SCM(playerid, COLOR_GREY, "Ban khong dung o khu vuc thuong luong de buon lau (/huongdan tim O Buon Lau");
	new drugs, str[128];
	if (sscanf(params, "i", drugs)) return SCM(playerid, COLOR_GRAD2, "Su dung: /buonlau [so luong thuoc]");
	if (drugs < 10 || drugs > 100) return SCM(playerid, COLOR_GREY, "Ban chi co the buon lau tu 50 den 200 thuoc mot phi vu.");
	if (PlayerInfo[playerid][pDrugs] < drugs) return SCM(playerid, COLOR_GREY, "Ban khong co du thuoc de buon lau.");

	new rand = random(sizeof(BuonLauTakeCP));

	format(str, sizeof(str), "Ban da thoa thuan %d thuoc de buon lau, hay toi cham do va mang theo mot chiec xe bon banh de chuan bi hang.", drugs);
	SCM(playerid, COLOR_YELLOW, str);
	SCM(playerid, COLOR_YELLOW, "Day la mot phi vu nguy hiem, xin hay chuan bi sung ong ky cang.");
	SetPlayerCheckpoint(playerid, BuonLauTakeCP[rand][0], BuonLauTakeCP[rand][1], BuonLauTakeCP[rand][2], 3);
	PlayerInfo[playerid][pDrugs] -= drugs;
	DrugDealer[playerid] = drugs;
	DrugDealing[playerid] = 1;
	OldDD[playerid] = rand;
	return 1;
}
CMD:doibuonlau(playerid, params[])
 {
		if (DrugDealing[playerid] != 3) return SCM(playerid, COLOR_GREY, "Ban hien tai khong buon lau hoac chua tien hanh buon lau.");
		if (CoopDD[playerid] >= 0) return SCM(playerid, COLOR_GREY, "Chi co truong nhom buon lau moi co the doi noi giao dich.");
		if (ChangeDD[playerid] == 1) return SCM(playerid, COLOR_GREY, "Ban chi co the doi diem giao dich 1 lan.");
		new rand = random(sizeof(BuonLauGiveCP));
		while (rand == OldDD[playerid])
		{
			rand = random(sizeof(BuonLauGiveCP));
		}
		SCM(playerid, COLOR_WHITE, "Dang lien lac de yeu cau doi dia diem giao dich...");
		SetTimerEx("ChangeDrugDealer", 5000, false, "ii", playerid, rand);
		return 1;
 }
CMD:tichthubuonlau(playerid, params[])
{
	if (PlayerInfo[playerid][pMember] != 1 && PlayerInfo[playerid][pLeader] != 1) return SCM(playerid, COLOR_GREY, "Ban khong phai canh sat.");
	new vid = GetClosestVehicle(playerid);
	if (vid == -1) return SCM(playerid, COLOR_GREY, "Ban khong dung gan chiec xe nao.");
	new Float:x, Float:y;
	GetXYBehindCar(vid, x, y, 4);
	if (GetDistanceToPointXY(playerid, x, y) > 4) return SCM(playerid, COLOR_GREY, "Ban can o thung xe de thuc hien.");
	if (trunkOn[vid] == 0) return SCM(playerid, COLOR_GREY, "Ban phai mo thung xe ra de thuc hien.");
	new ddvehicle = 0, sohang = 0;
	foreach(new pid : Player)
	{
		if (CarDD[pid] == vid)
		{
			sohang += DrugDealer[pid];

			DDTime[pid] = 0;
			DrugDealing[pid] = 0;
			DrugDealer[pid] = 0;
			CarDD[pid] = -1;
			OldDD[pid] = -1;
			ChangeDD[pid] = 0;
			CoopDD[pid] = -1;
			SCM(pid, COLOR_WHITE, "Hang tren xe buon da bi tich thu, phi vu buon lau that bai!");
			ddvehicle = 1;
			DisableCheckpoint(pid);
		}
	}
	if (ddvehicle == 0) return SCM(playerid, COLOR_GREY, "Chiec xe nay khong co hang buon lau.");
	else if (ddvehicle == 1)
	{
		new money = sohang * 7000;
		SafeGivePlayerMoney(playerid, money);
		new str[128];
		format(str, sizeof(str), "** [Tong dai]: Dong chi %s da lap cong va tich thu toan bo so hang buon lau (So tien: %s$) tren chiec xe %s! **", GN(playerid), AddCommas(money), GetVehicleName(vid));
		SendRadioMessage(1, TEAM_RADIO_COLOR, str);
		SendRadioMessage(1, TEAM_RADIO_COLOR, "** [Tong dai]: Cac dong chi hay mau chong truy bat cac doi tuong buon lau con lai! **");
	}
	return 1;
}
CMD:car(playerid, params[])
{
	//if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SCM(playerid, COLOR_GREY, "Ban khong ngoi tren xe.");
	if (sscanf(params, "s[16]", params))
	{
		SCM(playerid, COLOR_GRAD2, "Su dung: /car [Lua Chon]");
		SCM(playerid, COLOR_GRAD2, "light | trunk | hood");
		return 1;
	}
	new vid = GetPlayerVehicleID(playerid);
	if (IsABicycle(vid)) return SCM(playerid, COLOR_GREY, "Xe dap khong co nhung chuc nang nay.");
	if (!strcmp(params, "light", true))
	{
		if (lightOn[vid] == 0)
		{
			VehicleLight(vid, true);
			GameTextPlayer(playerid, "~w~Den Xe ~g~Mo", 1000, 4);
			lightOn[vid] = 1;
			return 1;
		}
		else
		{
			VehicleLight(vid, false);
			GameTextPlayer(playerid, "~w~Den Xe ~r~Tat", 1000, 4);
			lightOn[vid] = 0;
			return 1;
		}
	}
	// Geek 2
	if (!strcmp(params, "hood", true)) 
	{
		if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(IsABike(vid)) return SCM(playerid, COLOR_GREY, "Xe may khong co chuc nang nay.");
			if (hoodOn[vid] == 0)
			{
				VehicleHood(vid, true);
				GameTextPlayer(playerid, "~w~Mui Xe ~g~Mo", 1000, 4);
				hoodOn[vid] = 1;
				return 1;
			}
			else
			{
				VehicleHood(vid, false);
				GameTextPlayer(playerid, "~w~Mui Xe ~r~Dong", 1000, 4);
				hoodOn[vid] = 0;
				return 1;
			}
		}
		else
		{
			new newcar = GetClosestCar(playerid);
			if (newcar == -1) return SCM(playerid, COLOR_GREY, "Ban khong dung gan chiec xe nao.");
			if (IsABike(newcar)) return SCM(playerid, COLOR_GREY, "Xe may khong co chuc nang nay.");
			new Float:x, Float:y;
			GetXYFrontCar(newcar, x, y, 4);
			if (GetDistanceToPointXY(playerid, x, y) > 4) return SCM(playerid, COLOR_GREY, "Ban can o mui xe de thuc hien.");
			if (hoodOn[newcar] == 0)
			{
				VehicleHood(newcar, true);
				GameTextPlayer(playerid, "~w~Mui Xe ~g~Mo", 1000, 4);
				hoodOn[newcar] = 1;
				return 1;
			}
			else
			{
				VehicleHood(newcar, false);
				GameTextPlayer(playerid, "~w~Mui Xe ~r~Dong", 1000, 4);
				hoodOn[newcar] = 0;
				return 1;
			}
		}
	}
	if (!strcmp(params, "trunk", true))
	{
		if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if (IsABike(vid)) return SCM(playerid, COLOR_GREY, "Xe may khong co chuc nang nay.");
			if (trunkOn[vid] == 0)
			{
				VehicleTrunk(vid, true);
				GameTextPlayer(playerid, "~w~Thung Xe ~g~Mo", 1000, 4);
				trunkOn[vid] = 1;
				return 1;
			}
			else
			{
				VehicleTrunk(vid, false);
				GameTextPlayer(playerid, "~w~Thung Xe ~r~Dong", 1000, 4);
				trunkOn[vid] = 0;
				return 1;
			}
		}
		else
		{
			new newcar = GetClosestCar(playerid);
			if (newcar == -1) return SCM(playerid, COLOR_GREY, "Ban khong dung gan chiec xe nao.");
			if (IsABike(newcar)) return SCM(playerid, COLOR_GREY, "Xe may khong co chuc nang nay.");
			new Float:x, Float:y;
			GetXYBehindCar(newcar, x, y, 4);
			if (GetDistanceToPointXY(playerid, x, y) > 4) return SCM(playerid, COLOR_GREY, "Ban can o thung xe de thuc hien.");
			if (trunkOn[newcar] == 0)
			{
				VehicleTrunk(newcar, true);
				GameTextPlayer(playerid, "~w~Thung Xe ~g~Mo", 1000, 4);
				trunkOn[newcar] = 1;
				return 1;
			}
			else
			{
				VehicleTrunk(newcar, false);
				GameTextPlayer(playerid, "~w~Thung Xe ~r~Dong", 1000, 4);
				trunkOn[newcar] = 0;
				return 1;
			}
		}
	}
	// Geek 2
	return 1;
}
forward Float:GetXYBehindCar(vid, &Float:q, &Float:w, Float:distance);
Float:GetXYBehindCar(vid, &Float:q, &Float:w, Float:distance)
{
    new Float:a;
    GetVehiclePos(vid, q, w, a);
    GetVehicleZAngle(vid, a);
    q += (distance * -floatsin(-a, degrees));
    w += (distance * -floatcos(-a, degrees));
    return a;
}
forward Float:GetXYFrontCar(vehicleid, &Float:q, &Float:w, Float:distance);
Float:GetXYFrontCar(vehicleid, &Float:q, &Float:w, Float:distance)
{
	new Float:a;
	GetVehiclePos(vehicleid, q, w, a);
	GetVehicleZAngle(vehicleid, a);
	q += (distance * floatsin(-a, degrees));
	w += (distance * floatcos(-a, degrees));
}
CMD:dichvu(playerid, params[])
{
	if (sscanf(params, "s[30]", params)) return SCM(playerid, COLOR_GRAD2, "Su dung: /dichvu [luachon]");
	if (!strcmp(params, "capcuu", true))
	{
		if (countFaction(4) == 0) return SCM(playerid, COLOR_GREY, "Hien tai khong co nhan vien y te nao onduty.");
		if (Dying[playerid] == 0) return SCM(playerid, COLOR_GREY, "Ban khong bi thuong.");
		if (CallMedic[playerid] > 0)
		{
			SCM(playerid, COLOR_GREY, "Ban da goi cap cuu, hay cho cap cuu den.");
			SCM(playerid, COLOR_GREY, "Ban co the goi lai sau 30 giay.");
			return 1;
		}
		CallMedic[playerid] = 30;
		new str[128];
		new zone[40];
		format(str, sizeof(str), "** [Tong Dai]: Da nhan duoc cuoc goi, nhan vien y te se den do ngay...");
		SCM(playerid, COLOR_YELLOW, str);
		GetPlayer2DZone(playerid, zone, sizeof(zone));
		format(str, sizeof(str), "** [Tong Dai]: %s(%d) bi thuong nang tai %s, dang yeu cau mot chiec xe cap cuu. (/nhancapcuu [id]) **", GN(playerid), playerid, zone);
		SendRadioMessage(4, TEAM_RADIO_COLOR, str);
		printf("%s", str);
	}
	return 1;
}
 CMD:hoisinh(playerid, params[])
 {
		if (PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY, "Ban khong phai la Admin");
		new phs, str[128];
		if (sscanf(params, "u", phs)) return SCM(playerid, COLOR_GRAD2, "Su dung: /hoisinh [playerid]");
		if (IsLogOn(phs) && phs != INVALID_PLAYER_ID)
		{
			if (Dying[phs] != 1) return SCM(playerid, COLOR_GREY, "Nguoi choi nay khong chet.");
			printf("AdmCMD: %s hoi sinh %s", GN(playerid), GN(phs));
			format(str, sizeof(str), "AdmCMD: %s da duoc hoi sinh boi %s", GN(phs), GN(playerid));
			BroadCast(COLOR_LIGHTRED, str);
			Dying[phs] = 0;
			DyingTimeOut[phs] = 0;
			PlayerInfo[phs][pHospital] = 0;
			SetPlayerHealth(phs, 100);
			TogglePlayerControllable(phs, 1);
			ClearAnimations(phs);
		}
		return 1;
 }
 CMD:ncc(playerid, params[]) { return cmd_nhancapcuu(playerid, params); }
 CMD:nhancapcuu(playerid, params[])
 {
		if (PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pLeader] != 4) return SCM(playerid, COLOR_GREY, "Khong phai nhan vien cuu thuong.");
		new pncc, str[128];
		if (sscanf(params, "r", pncc)) return SCM(playerid, COLOR_GRAD2, "Su dung: /nhancapcuu [Ten/ID Nguoi Choi]");
		if (CallMedic[pncc] == 0) return SCM(playerid, COLOR_GREY, "Nguoi nay khong goi cap cuu");
		if (MedicCaller[playerid] != -1) return SCM(playerid, COLOR_GREY, "Ban da nhan mot dot cap cuu, xin hay giai quyet.");
		format(str, sizeof(str), "** [Tong Dai]: %s da nhan cuoc goi cap cuu cua %s (%d)", GN(playerid), GN(pncc), pncc);
		SendRadioMessage(4, TEAM_RADIO_COLOR, str);
		SCM(pncc, COLOR_YELLOW, "** [Tong Dai]: Benh vien dang cu nhan vien toi vi tri cua ban, xin hay co chiu dung.");
		MedicCaller[playerid] = pncc;
		new inter = GetPlayerInterior(pncc);
		if (inter == 0)
		{
			GetPlayerPos(pncc, MedicPos[pncc][0], MedicPos[pncc][1], MedicPos[pncc][2]);
			SetCheckpoint(playerid, MedicPos[pncc][0], MedicPos[pncc][1], MedicPos[pncc][2], 4);
		}
		else
		{
			if (LastEntrance[pncc][0] == 0)
			{
				SCM(playerid, COLOR_GREY, "Khong the lay duoc vi tri cua nguoi choi.");
				SCM(playerid, COLOR_YELLOW, "Hay /pm nguoi choi kia de tim vi tri.");
			}
			else
			{
				SCM(playerid, COLOR_GREY, "Nguoi choi kia hien tai dang trong mot noi that.");
				SCM(playerid, COLOR_GREY, "Hay vao do de tim nan nhan.");
				MedicPos[pncc][0] = LastEntrance[pncc][0];
				MedicPos[pncc][1] = LastEntrance[pncc][1];
				MedicPos[pncc][2] = LastEntrance[pncc][2];
				SetCheckpoint(playerid, MedicPos[pncc][0], MedicPos[pncc][1], MedicPos[pncc][2], 4);
			}
		}
		return 1;
 }
CMD:pint(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "Interior: %d", GetPlayerInterior(playerid));
	SCM(playerid, COLOR_WHITE, str);
	format(str, sizeof(str), "VWorld: %d", GetPlayerVirtualWorld(playerid));
	SCM(playerid, COLOR_WHITE, str);
	format(str, sizeof(str), "Last Entrance X: %f | Y: %f | Z: %f", LastEntrance[playerid][0],
		LastEntrance[playerid][1], LastEntrance[playerid][2]);
	SCM(playerid, COLOR_WHITE, str);
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	format(str, sizeof(str), "Now Position X: %f | Y: %f | Z: %f", pos[0], pos[1], pos[2]);
	SCM(playerid, COLOR_WHITE, str);
	return 1;
}
CMD:trithuong(playerid, params[])
{
	if (PlayerInfo[playerid][pBleeding] != 1) return SCM(playerid, COLOR_GREY, "Ban khong can tri thuong.");
	if (!IsPlayerInRangeOfPoint(playerid, 10, 1182.6879, -1317.7358, 1006.4028)) return SCM(playerid, COLOR_GREY, "Ban khong o benh vien de tri thuong.");
	SafeGivePlayerMoney(playerid, -5000);
	PlayerInfo[playerid][pBleeding] = 0;
	SCM(playerid, COLOR_LIGHTGREEN, "Ban da chua tri dut diem vet thuong! Chi phi: 5,000$");
	return 1;
}
CMD:xoamuctieu(playerid, params[])
{
	if (MedicCaller[playerid] != -1)
	{
		MedicCaller[playerid] = -1;
		SCM(playerid, COLOR_WHITE, "Xoa nhan benh nhan thanh cong.");
	}
	if (PizzaDistance[playerid] != 0)
	{
		SafeGivePlayerMoney(playerid, -30000);
		SCM(playerid, COLOR_GREY, "Ban bi tru 30,000$ vi khong giao banh cho nha.");
		PizzaPos[playerid][0] = 0;
		PizzaPos[playerid][1] = 0;
		PizzaPos[playerid][2] = 0;
		PizzaDistance[playerid] = 0;
	}
	if (PizzaGet[playerid] != 0)
	{
		PizzaGet[playerid] = 0;
		ClearAnimations(playerid);
		RemovePlayerAttachedObject(playerid, 0);
	}
	DisableCheckpoint(playerid);
	return 1;
}
CMD:dieutri(playerid, params[])
{
	if (PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pLeader] != 4) return SCM(playerid, COLOR_GREY, "Khong phai nhan vien cuu thuong.");
	if (!IsOnSavePosAmbulance(playerid)) return SCM(playerid, COLOR_GREY, "Ban khong ngoi tren xe cuu thuong hoac ngoi sai vi tri de cap cuu.");
	new patient = GetPatientAmbulance(GetPlayerVehicleID(playerid));
	if (patient == -1) return SCM(playerid, COLOR_GREY, "Khong co benh nhan nao o tren xe.");
	SCM(playerid, COLOR_LIGHTRED, "Tien hanh so cuu benh nhan, hay chac chan o yen tren xe trong 30 giay de cuu song benh nhan.");
	new str[128];
	format(str, sizeof(str), "Nhan vien y te %s dang tien hanh so cuu cho ban, trong 30 giay ban se duoc tri thuong.", GN(playerid));
	SCM(patient, COLOR_LIGHTRED, str);
	Saving[patient] = 30;
	Saver[patient] = playerid;
	SaveVehicle[patient] = GetPlayerVehicleID(playerid);
	TogglePlayerControllable(patient, 0);
	return 1;
}
CMD:pdfind(playerid, params[])
 {
		if (!IsACop(playerid)) return SCM(playerid, COLOR_GREY, "Ban khong phai nhan vien canh sat.");
		new pfind;
		if (sscanf(params, "u", pfind)) return SCM(playerid, COLOR_GRAD2, "Su dung: /pdfind [playerid]");
		if (pfind == INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY, "Nguoi choi nay khong ton tai.");
		if (PFind[playerid] != -1) return SCM(playerid, COLOR_GREY, "Ban hien dang tim kiem mot nguoi (/stopfind de dung tim kiem)");
		PFind[playerid] = pfind;
		new str[128];
		format(str, sizeof(str), "Tien hanh tim kiem %s! Cham do se xuat hien neu doi tuong trong thanh pho Los Santos.", GN(pfind));
		SCM(playerid, COLOR_LIGHTBLUE, str);
		return 1;
 }
CMD:stopfind(playerid, params[])
{
		if (PFind[playerid] != -1)
		{
			SetPlayerMarkerForPlayer(playerid, PFind[playerid], 0xFFFFFF00);
			PFind[playerid] = -1;
			SCM(playerid, COLOR_WHITE, "Xoa muc tieu tim kiem thanh cong.");
		}
		return 1;
}
stock DeleteTextLetter(string[])
{
	for (new i = 0; i < strlen(string); i++)
	{
		if (string[i] == '~' && IsTextLetter(string[i + 1]) && string[i+2] == '~')
			strdel(string, i, i + 3);
	}
}
stock IsTextLetter(cchar)
{
	if (cchar == 'n' || cchar == 'r' || cchar == 'g' ||
		cchar == 'b' || cchar == 'w' || cchar == 'y' ||
		cchar == 'p' || cchar == 'l' || cchar == 'h' ||
		cchar == 'u' || cchar == 'd' || cchar == '<' ||
		cchar == '>' || cchar == 'k')
		return 1;
	return 0;
}
stock GetRandomBiz()
{
	new rand = random(sizeof(BizzInfo));
	while (BizzInfo[rand][bID] == -1 || IsBizFullProduct(rand) || !IsBizCanBuyProduct(rand))
	{
		rand = random(sizeof(BizzInfo));
	}
	return rand;
}
stock LoadTruck(playerid)
{
	/*if (IsBizFullProduct(bizid) && BizzInfo[bizid][bID] != -1)
		return SCM(playerid, COLOR_GREY, "Cua hang nay da co du hang, khong can cung cap.");*/
	SCM(playerid, COLOR_WHITE, "Dat hang thanh cong. Phi dat hang: 10,000$!");
	SCM(playerid, COLOR_WHITE, "Giao hang thanh cong se tra lai tien");
	SCM(playerid, COLOR_WHITE, "Den cham do de giao hang.");
	SafeGivePlayerMoney(playerid, -10000);
	new vid = GetPlayerVehicleID(playerid);
	Trucking[vid] = 1;
	SCM(playerid, COLOR_YELLOW, "Dung lenh /timgiaohang de tim cua hang de giao hang.");
	SCM(playerid, COLOR_LIGHTGREEN, "Giao hang bang cach dung yen truoc cua hang trong 5 giay.");
	//SetCheckpoint(playerid, BizzInfo[bizid][bEntranceX], BizzInfo[bizid][bEntranceY], BizzInfo[bizid][bEntranceZ], 5);
	return 1;
}
stock AddCommas(so)
{
	new
		number,
		tStr[13]; // Up to 9,999,999,999,999

	if (so <0) number = so *-1;
	else number = so;
	format(tStr, sizeof(tStr), "%d", number);

	if (strlen(tStr) < 4)
		return tStr;

	new
		//rNumber = floatround((number+(number/3)),floatround_floor),
		iPos = strlen(tStr),
		iCount = 1;

	while (iPos > 0)
	{
		if (iCount == 4)
		{
			iCount = 0;
			strins(tStr, ",", iPos, 1);
			iPos++;
		}
		iCount++;
		iPos--;
	}
	if (so<0) strins(tStr, "-", 0);
	return tStr;
}
stock GetBizzDeliver(index, &type, &id)
{
	new idx = -1;
	for (new i = 0; i < MAX_BIZ; i++)
	{
		if (BizzInfo[i][bID] == -1) continue;
		if (++idx == index)
		{
			type = 1;
			id = i;
		}
	}
	for (new i = 0; i < MAX_SBIZ; i++)
	{
		if (SBizzInfo[i][sbID] == -1) continue;
		if (++idx == index)
		{
			type = 2;
			id = i;
		}
	}
}
stock CheckAllBizTruck()
{
	new havebiz = 0;
	for (new i = 0; i < MAX_BIZ; i++)
	{
		if (BizzInfo[i][bID] == -1) continue;
		if (!IsBizFullProduct(i) && IsBizCanBuyProduct(i))
			havebiz = 1;
	}
	for (new i = 0; i < MAX_SBIZ; i++)
	{
		if (SBizzInfo[i][sbID] == -1) continue;
		if (!IsSBizFullProduct(i) && IsSBizCanBuyProduct(i))
			havebiz = 1;
	}
	return havebiz;
}
stock GetBizLoadTruck()
{
	new str[500];
	format(str, sizeof(str), "Cua Hang\tTien\n");
	for (new i = 0; i < MAX_BIZ; i++)
	{
		if (BizzInfo[i][bID] == -1) continue;
		new title[300];
		format(title, sizeof(title), BizzInfo[i][bMessage]);
		DeleteTextLetter(title);
		if (!IsBizFullProduct(i) && IsBizCanBuyProduct(i))
			format(str, sizeof(str), "%s%s\t%d$\n", str, title, BizzInfo[i][bPriceProd]*10);
		else
		{
			if (IsBizFullProduct(i))
				format(str, sizeof(str), "%s%s (Day Hang)\t%d$\n", str, title, BizzInfo[i][bPriceProd]*10);
			else if (!IsBizCanBuyProduct(i))
				format(str, sizeof(str), "%s%s (Het Ngan Sach)\t%d$\n", str, title, BizzInfo[i][bPriceProd]*10);
		}
	}
	for (new i = 0; i < MAX_SBIZ; i++)
	{
		if (SBizzInfo[i][sbID] == -1) continue;
		new title[300];
		format(title, sizeof(title), SBizzInfo[i][sbMessage]);
		DeleteTextLetter(title);
		if (!IsSBizFullProduct(i) && IsSBizCanBuyProduct(i))
			format(str, sizeof(str), "%s%s\t%d$\n", str, title, SBizzInfo[i][sbPriceProd] * 10);
		else
		{
			if (IsSBizFullProduct(i))
				format(str, sizeof(str), "%s%s (Day Hang)\t%d$\n", str, title, SBizzInfo[i][sbPriceProd] * 10);
			else if (!IsSBizCanBuyProduct(i))
				format(str, sizeof(str), "%s%s (Het Ngan Sach)\t%d$\n", str, title, SBizzInfo[i][sbPriceProd] * 10);
		}
	}
	/*for (new i = 0; i < MAX_SBIZ; i++)
	{
		new title = SBizzInfo[i][sMessage];
		DeleteTextLetter(title);
		if (!IsBizFullProduct(i))
			format(str, sizeof(str), "%s\t%d$\n", title, SBizzInfo[i][sPriceProd]);
		else format(str, sizeof(str), "%s (Full Hang)\t%d$\n", title, SBizzInfo[i][sPriceProd]);
	}*/
	return str;
}
stock IsSBizFullProduct(bizid)
{
	if (SBizzInfo[bizid][sbProducts] < SBizzInfo[bizid][sbMaxProducts])
		return 0;
	return 1;
}
stock IsSBizCanBuyProduct(bizid)
{
	if (SBizzInfo[bizid][sbTill] <  (SBizzInfo[bizid][sbPriceProd] * 10))
		return 0;
	return 1;
}
stock IsBizFullProduct(bizid)
{
	if (BizzInfo[bizid][bProducts] < BizzInfo[bizid][bMaxProducts])
		return 0;
	return 1;
}
stock IsBizCanBuyProduct(bizid)
{
	if (BizzInfo[bizid][bTill] <  (BizzInfo[bizid][bPriceProd] * 10))
		return 0;
	return 1;
}
stock GetFreeSeatAmbulance(vid)
{
	new freeseat = 2;
	foreach(new i : Player)
	{
		if (IsPlayerInVehicle(i, vid))
		{
			if (GetPlayerVehicleSeat(i) == 2)
				freeseat = -1;
		}
	}
	if (freeseat == -1)
	{
			freeseat = 3;
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerInVehicle(i, vid))
			{
				if (GetPlayerVehicleSeat(i) == 3)
					freeseat = -1;
			}
		}
	}
	return freeseat;
}
stock ClearSaving(playerid)
{
	Saving[playerid] = 0;
	Saver[playerid] = -1;
	SaveVehicle[playerid] = -1;
}
stock GetPatientAmbulance(vid)
{
	foreach(new playerid : Player)
	{
		if (IsPlayerInVehicle(playerid, vid))
		{
			if (GetPlayerVehicleSeat(playerid) == 2 || GetPlayerVehicleSeat(playerid) == 3 && Dying[playerid] == 1)
				return playerid;
		}
	}
	return -1;
}
stock IsFD(playerid)
{
	if (IsLogOn(playerid))
	{
		new leader = PlayerInfo[playerid][pLeader];
		new member = PlayerInfo[playerid][pMember];
		if (member == 4)
		{
			return 1;
		}
		else if (leader == 4)
		{
			return 1;
		}
	}
	return 0;
}
stock IsOnSavePosAmbulance(playerid)
{
	new vid = GetPlayerVehicleID(playerid);
	if (IsAnAmbulance(vid))
	{
		new seat = GetPlayerVehicleSeat(playerid);
		if (seat == 2 || seat == 3)
			return 1;
	}
	return 0;
}
stock countFaction(idfac)
{
	new count = 0;
	foreach(new playerid : Player)
	{
		if ((PlayerInfo[playerid][pMember] == idfac || PlayerInfo[playerid][pLeader] == idfac) && (OnDuty[playerid] == 1 || JobDuty[playerid] == 1))
			count++;
	}
	return count;
}
forward ChangeDrugDealer(playerid, rand);
public ChangeDrugDealer(playerid, rand)
{
	SCM(playerid, COLOR_WHITE, "[Stranger]: Tao da gui cho may thong tin dia diem giao dich moi, nhanh toi day va de phong may thang com!");
	SCM(playerid, COLOR_YELLOW, "Dia diem giao dich da duoc doi, hay toi cham do moi de giao dich.");
	SetCheckpoint(playerid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);

	foreach(new ddid : Player)
	{
		if (CoopDD[ddid] == playerid)
		{
			SetCheckpoint(ddid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
			SCM(playerid, COLOR_YELLOW, "Truong nhom buon lau da doi dia diem giao dich, noi giao dich moi da duoc danh dau tren ban do.");
		}
	}
	return 1;
}
stock GetDriverVehicle(vid)
{
	foreach(new playerid : Player)
	{
		if (IsPlayerInVehicle(playerid, vid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			return playerid;
	}
	return -1;
}
stock CheckDrugDealerInVehicle(vid, ddcase)
{
	new count = 0;
	foreach(new playerid : Player)
	{
		if (DrugDealing[playerid] == ddcase && IsPlayerInVehicle(playerid, vid))
			count++;
	}
	return count;
}
stock IsPlayerDrugDealingCooperate(ddid, playerid, ddcase)
{
	new vid = GetPlayerVehicleID(playerid);
	if (DrugDealing[ddid] == ddcase && IsPlayerInVehicle(ddid, vid))
		return 1;
	return 0;
}
stock DisableCheckpoint(playerid)
{
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	DisablePlayerCheckpoint(playerid);
}
stock SetCheckpoint(playerid, Float:x, Float:y, Float:z, Float:range)
{
	PlayerPlaySound(playerid, 1002, 0.0, 0.0, 0.0);
	AntiCheckpoint[playerid] = 1;
	AntiCPDistance[playerid] = GetPlayerDistanceFromPoint(playerid, x, y, z);
	SetPlayerCheckpoint(playerid, x,y,z,range);
	return 1;
}
stock KickEx(playerid)
{
	SetTimerEx("KickTime", 1000, 0, "i", playerid);
	return 1;
}
forward KickTime(playerid);
public KickTime(playerid)
{
	Kick(playerid);
	return 1;
}
stock GetClosestDoCPlayer(playerid)
{
	new result = -1;
	new Float:mindistance = 5.0;
	foreach(new i : Player)
	{
		new Float:distance = GetDistanceBetweenPlayers(playerid, i);
		if ((PlayerInfo[i][pMember] == 17 || PlayerInfo[i][pLeader] == 17) && i != playerid)
		{
			if (distance < mindistance)
			{
				mindistance = distance;
				result = i;
			}
		}
	}
	return result;
}
stock GetClosestCell(playerid)
{
	for (new i = 0; i < 23; i++)
	{
		if (IsPlayerNearArrestOut(playerid, i))
			return i;
	}
	return -1;
}
stock IsPlayerNearArrestOut(playerid, id)
{
	if (IsPlayerInRangeOfPoint(playerid, 2, DocArrestOut[id][0], DocArrestOut[id][1], DocArrestOut[id][2]))
		return 1;
	return 0;
}
stock UpdateWantedLevel(playerid)
{
	new points = WantedPoints[playerid];
	switch (points)
	{
		case 3: WantedLevel[playerid] = 1;
		case 4, 5: WantedLevel[playerid] = 2;
		case 6, 7: WantedLevel[playerid] = 3;
		case 8, 9: WantedLevel[playerid] = 4;
		case 10, 11: WantedLevel[playerid] = 5;
		case 12, 13: WantedLevel[playerid] = 6;
	}
	if (points < 3) WantedLevel[playerid] = 0;
	else if (points >= 14) WantedLevel[playerid] = 10;
	return 1;
}
stock HitGate(playeridz, gateid, Float:health)
{
	GateInfo[gateid][gHealth] -= health;
	new str[128];
	format(str, sizeof(str), "~y~Mau Cua: ~r~%0.0f", GateInfo[gateid][gHealth]);
	GameTextPlayer(playeridz, str, 1000, 4);
	if (GateInfo[gateid][gHealth] <= 0)
	{
		if (GateInfo[gateid][gFactionType] == FACTYPE)
		{
			format(str, sizeof(str), "[Camera] Phat hien co doi tuong pha cua o HQ, vui long dieu tra.");
			SendRadioMessage(GateInfo[gateid][gFactionID], TEAM_RADIO_COLOR, str);
			printf("%s", str);
			foreach(new playerid : Player)
			{
				if (LastHitGate[playerid] == gateid)
				{
					if (WantedPoints[playerid] == 0) { WantedPoints[playerid] = 3; }
					else { WantedPoints[playerid] += 2; }
					SetPlayerCriminalEx(playerid, 255, "Pha Cua");
				}
			}
		}
		DestroyGate(gateid);
	}
	return 1;
}
stock IsGate(objectid)
{
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] == objectid)
			return i;
	}
	return -1;
}
stock CreateGate(model, Float:startx, Float:starty, Float:startz, Float:endx, Float:endy, Float:endz, Float:srotatex, Float:srotatey, Float:srotatez, Float:erotatex, Float:erotatey, Float:erotatez, type = GATE,  factype = -1, facid = -1, autotime = 0, Float:time = 5.0, Float:objecthealth = -1.0, Float:range = 3.0)
{
	new idgate = -1;
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] == INVALID_OBJECT_ID)
			idgate = i;
	}
	if (idgate == -1) return 1;

	new objid = CreateDynamicObject(model, startx, starty, startz, srotatex, srotatey, srotatez);
	GateInfo[idgate][gModel] = model;
	GateInfo[idgate][gObject] = objid;
	GateInfo[idgate][StartX] = startx;
	GateInfo[idgate][StartY] = starty;
	GateInfo[idgate][StartZ] = startz;
	GateInfo[idgate][EndX] = endx;
	GateInfo[idgate][EndY] = endy;
	GateInfo[idgate][EndZ] = endz;
	GateInfo[idgate][SRotateX] = srotatex;
	GateInfo[idgate][SRotateY] = srotatey;
	GateInfo[idgate][SRotateZ] = srotatez;
	GateInfo[idgate][ERotateX] = erotatex;
	GateInfo[idgate][ERotateY] = erotatey;
	GateInfo[idgate][ERotateZ] = erotatez;
	GateInfo[idgate][gHealth] = objecthealth;
	GateInfo[idgate][gMaxHealth] = objecthealth;
	GateInfo[idgate][gType] = type;
	GateInfo[idgate][gTime] = time;
	GateInfo[idgate][gAutoTime] = autotime;
	GateInfo[idgate][gRange] = range;
	GateInfo[idgate][gFactionID] = facid;
	GateInfo[idgate][gFactionType] = factype;
	return 1;
}
stock DestroyGate(gateid)
{
	DestroyDynamicObject(GateInfo[gateid][gObject]);
	GateInfo[gateid][gObject] = INVALID_OBJECT_ID;
	return 1;
}
stock RespawnGate()
{
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] == INVALID_OBJECT_ID && GateInfo[i][gModel] != 0)
		{
			new objid = CreateDynamicObject(GateInfo[i][gModel], GateInfo[i][StartX], GateInfo[i][StartY], GateInfo[i][StartZ],
														GateInfo[i][SRotateX], GateInfo[i][SRotateY], GateInfo[i][SRotateZ]);
			GateInfo[i][gObject] = objid;
		}
		GateInfo[i][gHealth] = GateInfo[i][gMaxHealth];
	}
	return 1;
}
stock GetClosestGate(playerid)
{
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] != -1 && GateInfo[i][gType] == GATE &&
			IsPlayerInRangeOfPoint(playerid, GateInfo[i][gRange], GateInfo[i][StartX], GateInfo[i][StartY], GateInfo[i][StartZ]))
			return i;
	}
	return -1;
}
stock GetClosestDoor(playerid)
{
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] != -1 && (GateInfo[i][gType] == DOOR || GateInfo[i][gType] == DOCCELL) &&
			IsPlayerInRangeOfPoint(playerid, GateInfo[i][gRange], GateInfo[i][StartX], GateInfo[i][StartY], GateInfo[i][StartZ]))
			return i;
	}
	return -1;
}
stock MoveGate(gateid, type = -1)
{
	// 1 OPEN 2 CLOSED
	if (type == -1)
	{
		if (GateInfo[gateid][gMoved] == 0)
		{
			MoveDynamicObject(GateInfo[gateid][gObject], GateInfo[gateid][EndX], GateInfo[gateid][EndY], GateInfo[gateid][EndZ], GateInfo[gateid][gTime], GateInfo[gateid][ERotateX], GateInfo[gateid][ERotateY], GateInfo[gateid][ERotateZ]);
			if (GateInfo[gateid][gAutoTime] > 0)
				GateWaitTime[gateid] = GateInfo[gateid][gAutoTime];
			GateInfo[gateid][gMoved] = 1;
		}
		else
		{
			MoveDynamicObject(GateInfo[gateid][gObject], GateInfo[gateid][StartX], GateInfo[gateid][StartY], GateInfo[gateid][StartZ], GateInfo[gateid][gTime], GateInfo[gateid][SRotateX], GateInfo[gateid][SRotateY], GateInfo[gateid][SRotateZ]);
			GateInfo[gateid][gMoved] = 0;
		}
	}
	else
	{
		if (type == 1)
		{
			MoveDynamicObject(GateInfo[gateid][gObject], GateInfo[gateid][EndX], GateInfo[gateid][EndY], GateInfo[gateid][EndZ], GateInfo[gateid][gTime], GateInfo[gateid][ERotateX], GateInfo[gateid][ERotateY], GateInfo[gateid][ERotateZ]);
			if (GateInfo[gateid][gAutoTime] > 0)
				GateWaitTime[gateid] = GateInfo[gateid][gAutoTime];
			GateInfo[gateid][gMoved] = 1;
		}
		else if (type == 2)
		{
			MoveDynamicObject(GateInfo[gateid][gObject], GateInfo[gateid][StartX], GateInfo[gateid][StartY], GateInfo[gateid][StartZ], GateInfo[gateid][gTime], GateInfo[gateid][SRotateX], GateInfo[gateid][SRotateY], GateInfo[gateid][SRotateZ]);
			GateInfo[gateid][gMoved] = 0;
		}
	}
	return 1;
}
