forward TazerKeyStateChange(playerid, newkeys, oldkeys);
public TazerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE && Tazering[playerid] == 1 && !IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		for (new i = 0; i<MAX_PLAYERS; i++)
		{
			if (PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pLeader] == 1) continue;
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
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (PlayerInfo[i][pAdmin] > 0 && IsPlayerInVehicle(i, vid))
			return true;
	}
	return false;
}
stock RespawnCar(vid)
{
	new newvid = CreateVehicle(CarInfo[vid][cModel], CarInfo[vid][cLocationx], CarInfo[vid][cLocationy], CarInfo[vid][cLocationz], CarInfo[vid][cAngle], CarInfo[vid][cColorOne], CarInfo[vid][cColorTwo], 60000);
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
	DestroyCar(vid);
	return 1;
}
stock GetVehicleByCarID(id)
{
	for (new i = 0; i < MAX_VEHICLES; i++)
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
	CarInfo[vid][cValue] = CarInfo[vid][cValue];
	CarInfo[vid][cLicense] = CarInfo[vid][cLicense];
	CarInfo[vid][cRegistration] = CarInfo[vid][cRegistration];
	CarInfo[vid][cOwned] = CarInfo[vid][cOwned];
	CarInfo[vid][cLock] = CarInfo[vid][cLock];
	DestroyVehicle(vid);
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
				new Float:Pos[3];
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				SetPVarFloat(playerid, "SX", Pos[0]);
				SetPVarFloat(playerid, "SY", Pos[1]);
				SetPVarFloat(playerid, "SZ", Pos[2]);
				SetPVarInt(playerid, "SInt", GetPlayerInterior(playerid));
				SetPVarInt(playerid, "SWorld", GetPlayerVirtualWorld(playerid));
			}
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, pspec, 0);
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

stock ClearAllVehicle()
{
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		CarInfo[i][cID] = -1;
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
	if (countFaction(1) < 3) return SCM(playerid, COLOR_GREY, "Phai co it nhat 3 canh sat onduty trong server moi co the thuc hien.");
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
		if (IsPlayerConnected(phs) && phs != INVALID_PLAYER_ID)
		{
			if (Dying[phs] != 1) return SCM(playerid, COLOR_GREY, "Nguoi choi nay khong chet.");
			printf("AdmCMD: %s hoi sinh %s", GN(playerid), GN(phs));
			format(str, sizeof(str), "AdmCMD: %s da duoc hoi sinh boi %s", GN(phs), GN(playerid));
			BroadCast(COLOR_LIGHTRED, str);
			Dying[phs] = 0;
			DyingTimeOut[phs] = 0;
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
		SCM(pncc, COLOR_YELLOW, "** [Tong Dai]: Benh vien dang dua xe toi vi tri cua ban, xin hay co chiu dung.");
		GetPlayerPos(pncc, MedicPos[pncc][0], MedicPos[pncc][1], MedicPos[pncc][2]);
		SetPlayerCheckpoint(playerid, MedicPos[pncc][0], MedicPos[pncc][1], MedicPos[pncc][2], 4);
		MedicCaller[playerid] = pncc;
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
stock GetFreeSeatAmbulance(vid)
{
	new freeseat = 2;
	for (new i = 0; i<MAX_PLAYERS; i++)
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
	foreach(Player, playerid)
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
	if (IsPlayerConnected(playerid))
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
	foreach(Player, playerid)
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
	SetPlayerCheckpoint(playerid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);

	foreach(Player, ddid)
	{
		if (CoopDD[ddid] == playerid)
		{
			SetPlayerCheckpoint(ddid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
			SCM(playerid, COLOR_YELLOW, "Truong nhom buon lau da doi dia diem giao dich, noi giao dich moi da duoc danh dau tren ban do.");
		}
	}
	return 1;
}

stock GetDriverVehicle(vid)
{
	foreach(Player, playerid)
	{
		if (IsPlayerInVehicle(playerid, vid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			return playerid;
	}
	return -1;
}

stock CheckDrugDealerInVehicle(vid, ddcase)
{
	new count = 0;
	foreach(Player, playerid)
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
