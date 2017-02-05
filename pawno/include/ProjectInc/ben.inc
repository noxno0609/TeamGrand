forward TazerKeyStateChange(playerid, newkeys, oldkeys);
public TazerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE && Tazering[playerid] == 1 && !IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		for (new i = 0; i<MAX_PLAYERS; i++)
		{
			if (PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pLeader] == 1) continue;
			if (IsPlayerNearPlayer(playerid, i, 2) && i != playerid && Tazered[i] == 0)
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
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (PlayerInfo[i][pAdmin] > 0 && IsPlayerInVehicle(i, vid))
			return true;
	}
	return false;
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
				 aVeh[i] = CreateVehicle(id, pos[0], pos[1], pos[2], pos[3], col[0], col[1], 1200);
				 new str[128];
				 format(str, sizeof(str), "Xe He Thong\nID Veh: %d", i);
				 aVehLabel[i] = Create3DTextLabel(str, COLOR_YELLOW, 0, 0, 0, 30, 0, 0);

				 Attach3DTextLabelToVehicle(aVehLabel[i], aVeh[i], 0, 0, 0);
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
			 for (new i = 0; i < MAX_VEHICLES; i++)
			 {
				 new avid = IsAdminVehicle(i);
				 if (avid != -1 && !IsAnyAdminInVehicle(i))
					 DeleteAdminVeh(avid);
			 }
			 SendAdminMessage(COLOR_LIGHTRED, "AdmCMD: Da xoa tat ca Admin Vehicle!");
			 return 1;
		 }
		new vid = strval(vidid);
		if (vid != INVALID_VEHICLE_ID)
		{
			new avid = IsAdminVehicle(vid);
			if (avid != -1)
			{
				DeleteAdminVeh(avid);
				SCM(playerid, COLOR_LIGHTRED, "AdmCMD: Da xoa chiec Admin Vehicle nay thanh cong!");
				return 1;
			}
			else SCM(playerid, COLOR_GREY, "Day khong phai Admin Vehicle.");
		}
		else SCM(playerid, COLOR_GREY, "Chiec xe nay khong ton tai.");
		 return 1;
}

stock DeleteAdminVeh(avid)
{
	Delete3DTextLabel(aVehLabel[avid]);
	new vid = aVeh[avid];
	DestroyVehicle(vid);
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
		for (new i = 0; i<MAX_PLAYERS; i++)
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
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

CMD:buonlau(playerid, params[])
{
	if (gTeam[playerid] == 2 || IsACop(playerid)) return SCM(playerid, COLOR_GREY, "Ban la nhan vien chinh phu, khong the di buon lau.");
	if (PlayerInfo[playerid][pLevel] < 5) return SCM(playerid, COLOR_GREY, "Ban phai dat cap 8 moi co the di buon.");
	if (!IsPlayerInRangeOfPoint(playerid, 3, -1111.4635, -1681.5151, 76.3739)) return SCM(playerid, COLOR_GREY, "Ban khong dung o khu vuc thuong luong de buon lau (/huongdan tim O Buon Lau");
	new drugs, str[128];
	if (sscanf(params, "i", drugs)) return SCM(playerid, COLOR_GRAD2, "Su dung: /buonlau [so luong thuoc]");
	if (drugs < 10 || drugs > 100) return SCM(playerid, COLOR_GREY, "Ban chi co the buon lau tu 10 den 100 thuoc mot phi vu.");
	if (PlayerInfo[playerid][pDrugs] < drugs) return SCM(playerid, COLOR_GREY, "Ban khong co du thuoc de buon lau.");

	new rand = random(sizeof(BuonLauTakeCP));

	format(str, sizeof(str), "Ban da thoa thuan %d thuoc de buon lau, hay toi cham do va mang theo mot chiec xe bon banh de chuan bi hang.", drugs);
	SCM(playerid, COLOR_YELLOW, str);
	SCM(playerid, COLOR_YELLOW, "Day la mot phi vu nguy hiem, xin hay chuan bi sung ong ky cang.");
	SetPlayerCheckpoint(playerid, BuonLauTakeCP[rand][0], BuonLauTakeCP[rand][1], BuonLauTakeCP[rand][2], 3);
	PlayerInfo[playerid][pDrugs] -= drugs;
	DrugDealer[playerid] = drugs;
	DrugDealing[playerid] = 1;
	return 1;
}

 CMD:doibuonlau(playerid, params[])
 {
		if (DrugDealing[playerid] != 3) return SCM(playerid, COLOR_GREY, "Ban hien tai khong buon lau hoac chua tien hanh buon lau.");
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

forward ChangeDrugDealer(playerid, rand);
public ChangeDrugDealer(playerid, rand)
{
	SCM(playerid, COLOR_YELLOW, "[Stranger]: Tao da gui cho may thong tin dia diem giao dich moi, nhanh toi day va de phong may thang com!");
	SCM(playerid, COLOR_WHITE, "Dia diem giao dich da duoc doi, hay toi cham do moi de giao dich.");
	SetPlayerCheckpoint(playerid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
	return 1;
}

