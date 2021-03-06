timer CheckHitGate[350](playerid)
{
	new Float:x, Float:y, Float:z, Float:distance;
	GetPlayerPos(playerid, x, y, z);
	GetXYInFrontOfPlayer(playerid, x, y, 0.5);
	//SetPlayerCheckpoint(playerid, x, y, z, 0.5);
	//SetPVarInt(playerid, "FORTESTING", 1);
	for (new i = 0; i < MAX_GATES; i++)
	{
		if (GateInfo[i][gObject] == INVALID_PLAYER_ID) continue;
		if (GateInfo[i][gMoved] == 0)
			distance = GetDistanceBetweenPointsXY(x, y, GateInfo[i][StartX], GateInfo[i][StartY]);
		else distance = GetDistanceBetweenPointsXY(x, y, GateInfo[i][EndX], GateInfo[i][EndY]);
		//printf("distance: %f", distance);
		if (distance < 1.5 && IsHitObjectWeaponID(GetPlayerWeapon(playerid)))
		{
			OnPlayerHitGate(playerid, GetPlayerWeapon(playerid), i);
			break;
		}
	}
	defer ClearHitGate(playerid);
	return 1;
}
timer ClearHitGate[380](playerid)
{
	SetPVarInt(playerid, "DelayHitAnim", 0);
	return 1;
}
task AntiCheat[100]()
{
	foreach(new vehid : Vehicle)
	{
		new Float:newhealth;
		GetVehicleHealth(vehid, newhealth);
		if (newhealth > CarHealthCheat[vehid])
		{
			SetVehicleHealth(vehid, CarHealthCheat[vehid]);
			new driverid = GetVehicleDriverID(vehid);
			if (driverid != -1 && PlayerInfo[driverid][pAdmin] == 0)
				CarCheatAttemping[driverid]++;
		}
		else if (newhealth < CarHealthCheat[vehid])
		{
			GetVehicleHealth(vehid, CarHealthCheat[vehid]);
			GetVehicleDamageStatus(vehid, CarRepairCheat[vehid][0], CarRepairCheat[vehid][1], CarRepairCheat[vehid][2], CarRepairCheat[vehid][3]);
		}

		if (CarRepairCheat[vehid][0] != 0)
			CheckHackRepairCar(vehid);

		if (engineOn[vehid] == 1)
			CheckVehicleInNails(vehid);
	}
	foreach(new i: Player)
	{
		new delaytime = GetPVarInt(i, "DelayHackMoney");
		if (delaytime > 0)
		{
			delaytime--;
			SetPVarInt(i, "DelayHackMoney", delaytime);
		}
		if (IsLogOn(i) && PlayerInfo[i][pAdmin] < 1)
		{
			//Check Hack Money
			new pmoney = GetPlayerMoney(i);
			if (pmoney > ScriptMoney[i] && pmoney > 0)
			{
				/*printf("--===--");
				printf("[%d] Now Money: %s$", i, AddCommas(pmoney));
				printf("[%d] Script Money: %s$", i, AddCommas(ScriptMoney[i]));*/
				new fuckmoney = pmoney - ScriptMoney[i];
				new finemoney = (ScriptMoney[i] / 2);
				new finebmoney = (PlayerInfo[i][pAccount] / 2);
				if (ScriptMoney[i] <= 1)
				{
					finemoney = 0;
					ResetPlayerMoney(i);
					if (ScriptMoney[i] == 1) ScriptMoney[i] = 0;
					GivePlayerMoney(i, ScriptMoney[i]);
				}
				else
				{
					GivePlayerMoney(i, -fuckmoney);
					SafeGivePlayerMoney(i, -finemoney, 1, false);
				}

				if (PlayerInfo[i][pAccount] <= 1)
					PlayerInfo[i][pAccount] = 0;
				else SafeGivePlayerMoney(i, -finebmoney, 2, false);

				if (GetPVarInt(i, "DelayHackMoney") == 0)
				{
					new strz[128];
					format(strz, sizeof(strz), "AdmCMD: %s hack tien va bi phat mat nua tai san boi SERVER!", GN(i));
					BroadCast(COLOR_LIGHTRED, strz);
					SetPVarInt(i, "DelayHackMoney", 30);
				}
				/*printf("[%d] Fine Money: %s$", i, AddCommas(finemoney));
				printf("[%d] After Script Money: %s$", i, AddCommas(ScriptMoney[i]));*/
			}

			//Check Hack Weapon
			new weaponid, ammo;
			for (new wid = 0; wid < 13; wid++)
			{
				GetPlayerWeaponData(i, wid, weaponid, ammo);
				if (weaponid != ScriptWeapons[i][wid])
				{
					SetPlayerArmedWeapon(i, 0);
					SafeReGivePlayerWeapon(i);
					break;
				}
			}
		}
	}
	return 1;
}

task SoundZone[1000]()
{
	if (DOCAlarm > 0 && --DOCAlarm == 0)
	{
		foreach(new playerid : Player)
		{
			PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
			SetPVarInt(playerid, "AlarmPlayed", 0);
		}
	}
}
task ServerBeat[1000]()
{
	foreach(new vehid : Vehicle)
	{
		if (IsAdminVehicle(vehid) == -1 && IsVehicleDamaged(vehid))
		{
			SetVehicleHealthEx(vehid, 390);
			if (engineOn[vehid] != 0)
			{
				VehicleEngine(vehid, false);
				engineOn[vehid] = 0;
			}
		}
	}
	for (new gateid = 0; gateid < MAX_GATES; gateid++)
	{
		if (GateWaitTime[gateid] > 0 && --GateWaitTime[gateid] == 0)
		{
			if(GateInfo[gateid][gMoved] == 1) MoveGate(gateid);
		}
	}
	foreach(new playerid : Player)
	{
		if (TaxiAccepted[playerid] != -1 && IsPlayerNearPlayer(playerid, TaxiAccepted[playerid], 5))
		{
			new taxicaller = TaxiAccepted[playerid];
			TaxiCall[taxicaller] = 0;
			TaxiCallTime[taxicaller] = 0;
			UnSetMarkerPlayer(playerid, taxicaller);
			TaxiAccepted[playerid] = -1;
		}
		//if (!IsLogOn(playerid)) continue;
		if (PizzaCallTime[playerid] > 0) 
			PizzaCallTime[playerid]--;

		if (MechanicCallTime[playerid] > 0)
		{
			MechanicCallTime[playerid]--;
			if (MechanicCallTime[playerid] == 0)
				MechanicCall[playerid] = 0;
		}

		if (TaxiCallTime[playerid] > 0)
		{
			TaxiCallTime[playerid]--;
			if (TaxiCallTime[playerid] == 0)
				TaxiCall[playerid] = 0;
		}

		if (NowGTTime[playerid] > 0)
		{
			NowGTTime[playerid] -= 1000;
			if (NowGTTime[playerid] < 0)
				NowGTTime[playerid] = 0;
		}

		if (GetPVarInt(playerid, "TimeReleaseCuffed") > 0)
		{
			new rtime = GetPVarInt(playerid, "TimeReleaseCuffed");
			rtime--;
			new str[128];
			format(str, sizeof(str), "~r~%d giay~n~~y~de pha cong tay!", rtime);
			GameTextPlayer(playerid, str, 1000, 4);
			if (rtime == 0)
			{
				new prid = GetPVarInt(playerid, "RCPID");
				format(str, sizeof(str), "* Ban da duoc be tay boi %s.", GN(playerid));
				SendClientMessage(prid, COLOR_WHITE, str);
				format(str, sizeof(str), "* Ban da be cong tay cho %s.", GN(prid));
				SendClientMessage(playerid, COLOR_WHITE, str);
				GameTextPlayer(prid, "~g~Be cong", 2500, 3);
				TogglePlayerControllable(prid, 1);
				PlayerCuffed[prid] = 0;
				ClearAnimations(playerid);
				ClearAnimations(prid);
				rtime = -1;
				SetPVarInt(playerid, "RCPID", -1);
			}
			SetPVarInt(playerid, "TimeReleaseCuffed", rtime);
		}
		if (GetPVarInt(playerid, "LastHitTime") > 0)
		{
			new hittime = GetPVarInt(playerid, "LastHitTime");
			hittime--;
			if (hittime == 0)
				LastHitGate[playerid] = 0;
			SetPVarInt(playerid, "LastHitTime", hittime);
		}
		if (SearchNails[playerid] == 1)
		{
			new vid = GetPlayerVehicleID(playerid);
			if (!IsPlayerInAnyVehicle(playerid) || !IsASweeper(vid))
			{
				SearchNails[playerid] = 0;
				GameTextPlayer(playerid, "~r~Che do ra dinh ket thuc", 5000, 4);
				continue;
			}
			new Float:distance, nailid;
			GetNearestNails(playerid, distance, nailid);
			if (distance <= 2)
			{
				if (TimeNails[playerid] == -1)
					TimeNails[playerid] = 6;

				TimeNails[playerid]--;
				new str[128];
				if (TimeNails[playerid] == 0)
				{
					DeleteNail(nailid);
					TimeNails[playerid] = -1;
					format(str, sizeof(str), "~y~Hut Dinh Thanh Cong", TimeNails[playerid]);
					GameTextPlayer(playerid, str, 1000, 4);
					PlayerInfo[playerid][pMechSkill]++;
					GiveJobReward(playerid, MECHANIC);
				}
				else
				{
					format(str, sizeof(str), "~g~Hut Dinh~n~~y~Thoi Gian: ~b~%d Giay", TimeNails[playerid]);
					GameTextPlayer(playerid, str, 1000, 4);
				}
			}
			else if (distance <= (50 + (GetLevelJob(playerid, MECHANIC)*5)))
			{
				new str[128];
				format(str, sizeof(str), "~g~Phat Hien Dinh~n~~y~Khoang Cach: ~b~%0.0fm", distance);
				GameTextPlayer(playerid, str, 1000, 4);
				TimeNails[playerid] = -1;
			}
		}
		if (DriverLicenseCar[playerid] != INVALID_VEHICLE_ID && DriverLicenseTime[playerid] != 0)
		{
			new Float:health;
			GetVehicleHealth(DriverLicenseCar[playerid], health);
			if (health < 995 || DriverLicenseTime[playerid] > 30 || (GetVehicleSpeed(DriverLicenseCar[playerid], 0) < 5 && DriverLicenseTime[playerid] > 2))
				FailDrivingTest(playerid);
		}
		if (CarCheatAttemping[playerid] > 0 && --CarCheatAttemping[playerid])
		{
			if (CarCheatAttemping[playerid] >= 3)
			{
				new str[128];
				format(str, sizeof(str), "[Hack/Cheat]: %s co tinh su dung hack fix xe va da bi kick.", GN(playerid));
				SendAdminMessage(COLOR_RED, str);
				SCM(playerid, COLOR_LIGHTRED, "Ban da bi kicked vi co tinh su dung hack fix car.");
				KickEx(playerid);
			}
		}
		if (DOCAlarm > 0)
		{
			if (GetPVarInt(playerid, "AlarmPlayed") == 0 && IsPlayerInRangeOfPoint(playerid, 100, 732.5316, -1359.1908, 18.8203))
			{
				PlayerPlaySound(playerid, 3401, 0, 0, 0);
				SetPVarInt(playerid, "AlarmPlayed", 1);
			}
			else if (GetPVarInt(playerid, "AlarmPlayed") == 1 && !IsPlayerInRangeOfPoint(playerid, 100, 732.5316, -1359.1908, 18.8203))
			{
				PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
				SetPVarInt(playerid, "AlarmPlayed", 0);
			}
		}
		if (WantedLevel[playerid] > 0 && GetPlayerWantedLevel(playerid) != WantedLevel[playerid] && FirstSpawn[playerid] == 0)
		{
			UpdateWantedLevel(playerid);
			SetPlayerWantedLevel(playerid, WantedLevel[playerid]);
		}
		else if (WantedLevel[playerid] == 0 && GetPlayerWantedLevel(playerid) != 0 && FirstSpawn[playerid] == 0)
		{
			UpdateWantedLevel(playerid);
			SetPlayerWantedLevel(playerid, 0);
		}

		if (DOCDelay[playerid] > 0)
			DOCDelay[playerid]--;

		if (DOCCheck[playerid] == 1 && IsPlayerInDynamicArea(playerid, DOCArea))
		{
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			if (pos[2] < DOCAIR)
			{
				new str[128];
				format(str, sizeof(str), "[DoC Camera] Doi tuong %s vua dot nhap vao DoC, cac nhan vien hay mau bat giu doi tuong.", GN(playerid));
				SendRadioMessage(17, COLOR_LIGHTRED, str);
				if (WantedPoints[playerid] == 0) { WantedPoints[playerid] = 3; }
				else { WantedPoints[playerid] += 2; }
				SetPlayerCriminalEx(playerid, 255, "Dot Nhap DoC.");
				DOCAlarm = 1;
				DOCCheck[playerid] = 0;
			}
		}
		if (gPlayerLogged[playerid] == 1)
		{
			format(tdbank, sizeof(tdbank), "Bank$ %s", AddCommas(PlayerInfo[playerid][pAccount]));
			TextDrawSetString(TDPBank[playerid], tdbank);
			TextDrawShowForPlayer(playerid, TDPBank[playerid]);
		}
		if (GetPVarInt(playerid, "DelayWalkingTeleportTime") > 0)
		{
			new time = GetPVarInt(playerid, "DelayWalkingTeleportTime");
			SetPVarInt(playerid, "DelayWalkingTeleportTime", --time);
		}
		if (Trucking[GetPlayerVehicleID(playerid)] == 1 && TruckPos[playerid][0] != 0)
		{
			if (!IsPlayerInRangeOfPoint(playerid, 5, TruckPos[playerid][0], TruckPos[playerid][1], TruckPos[playerid][2]))
				TruckTime[playerid] = 6;
			else
			{
				if (TruckTime[playerid] > 0)
				{
					TruckTime[playerid]--;
					new str[128];
					format(str, sizeof(str), "~y~Giao hang trong ~g~%d~g~ ~y~giay~y~", TruckTime[playerid]);
					GameTextPlayer(playerid, str, 1000, 4);
					if (TruckTime[playerid] == 0)
					{
						Trucking[GetPlayerVehicleID(playerid)] = 2;
						SetCheckpoint(playerid, 2458.2568, -2077.1592, 13.5469, 5);
						GameTextPlayer(playerid, "Quay ve de nhan tien!", 4000, 4);
					}
				}
			}
		}
		if (PFind[playerid] != -1)
		{
			if (IsPlayerInDynamicArea(PFind[playerid], LSArea))
				SetPlayerMarkerForPlayer(playerid, PFind[playerid], 0xFF0000FF);
			else
				SetPlayerMarkerForPlayer(playerid, PFind[playerid], 0xFFFFFF00);
		}
		if (AntiCheckpoint[playerid] == 1) 
			AntiCPTime[playerid]++;

		if (CallMedic[playerid] > 0)
			CallMedic[playerid]--;

		if (DyingTimeOut[playerid] > 0)
			DyingTimeOut[playerid]--;

		if (Dying[playerid] == 1 && !IsOnSavePosAmbulance(playerid))
		{
			new AnimLib[32], AnimName[32];
			//if (!IsPlayerInRangeOfPoint(playerid, 3, BTPos[playerid][0], BTPos[playerid][1], BTPos[playerid][2])) NamVien(playerid);
			GetAnimationName(GetPlayerAnimationIndex(playerid), AnimLib, 32, AnimName, 32);
			if (strcmp(AnimName, "KILL_Knife_Ped_Die", true) != 0) ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
			if (DyingTimeOut[playerid] != 0) GameTextPlayer(playerid, "~r~Ban da bi thuong ~n~~y~Go /dichvu capcuu de goi cuu thuong", 1000, 4);
			else GameTextPlayer(playerid, "~r~Ban da bi thuong ~n~~y~Go /dichvu capcuu de goi cuu thuong~n~~r~/chapnhan chet ~y~de tu sat", 1000, 4);
		}
		if (Dying[playerid] == 1 && Saving[playerid] > 0)
		{
			new vid = SaveVehicle[playerid];
			if (!IsPlayerInVehicle(Saver[playerid], vid) ||
				!IsPlayerInVehicle(playerid, vid))
			{
				SCM(playerid, COLOR_GREY, "Dieu tri that bai.");
				SCM(Saver[playerid], COLOR_GREY, "Dieu tri that bai.");
				ClearSaving(playerid);
			}
			Saving[playerid]--;
			new str[128];
			format(str, sizeof(str), "~g~Thoi gian dieu tri con~n~~y~%d ~y~giay~y~!", Saving[playerid]);
			GameTextPlayer(playerid, str, 1000, 4);
			GameTextPlayer(Saver[playerid], str, 1000, 4);
			if (Saving[playerid] == 0)
			{
				format(str, sizeof(str), "Ban da dieu tri cho %s thanh cong.", GN(playerid));
				SCM(Saver[playerid], COLOR_LIGHTGREEN, str);
				SCM(playerid, COLOR_LIGHTGREEN, "Vet thuong cua ban da duoc dieu tri tam thoi, hay den benh vien de binh phuc hoan toan.");
				SCM(playerid, COLOR_LIGHTRED, "Ban se bi mat mau moi 10 giay.");
				SCM(playerid, COLOR_WHITE, "MEO: Hay den benh vien va /trithuong.");
				Dying[playerid] = 0;
				ClearSaving(playerid);
				TogglePlayerControllable(playerid, 1);
				RemovePlayerFromVehicle(playerid);
				PlayerInfo[playerid][pBleeding] = 1;
				PlayerInfo[playerid][pHospital] = 0;
			}
		}
		if (OnDuty[playerid] == 1 && (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 ||  
			PlayerInfo[playerid][pMember] == 17 || PlayerInfo[playerid][pLeader] == 17) && WearTazer[playerid] != 1)
		{
			Tazering[playerid] = 0;
			SetPlayerAttachedObject(playerid, 5, 18642, 1, -0.197000, -0.071000, -0.109999, 2.399994, 80.400001, 18.399993, 1.000000, 1.000000, 1.000000, 0, 0);
			WearTazer[playerid] = 1;
		}
		else if (OnDuty[playerid] == 0 || (PlayerInfo[playerid][pMember] != 1 && PlayerInfo[playerid][pLeader] != 1 &&
			PlayerInfo[playerid][pMember] != 17 && PlayerInfo[playerid][pLeader] != 17) && WearTazer[playerid] == 1)
		{
			Tazering[playerid] = 0;
			RemovePlayerAttachedObject(playerid, 5);
			WearTazer[playerid] = 0;
		}
		if (Tazering[playerid] == 1) SetPlayerArmedWeapon(playerid, 0);

		if (Tazered[playerid] > 0 && --Tazered[playerid] == 0)
		{
			TogglePlayerControllable(playerid, 1);
			ClearAnimations(playerid);
		}

		if (HitTimes[playerid] > 0)
			HitTimes[playerid]--;

		if (HitTimes[playerid] >= 3)
		{
			new Float:Pos[3], Float:speed = GetVehicleSpeed(GetPlayerVehicleID(playerid), 0);
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2] + 0.1);
			if (speed <= 10) ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 0, 1500, 1);
			else ApplyAnimation(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 0, 1500, 1);
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if (IsPlayerInVehicle(i, GetPlayerVehicleID(playerid)))
				{
					GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
					SetPlayerPos(i, Pos[0], Pos[1], Pos[2] + 0.1);
					if (speed <= 10) ApplyAnimation(i, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 0, 1500, 1);
					else ApplyAnimation(i, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 0, 1500, 1);
				}
			}
			HitTimes[playerid] = 0;
		}
		if (Escorting[playerid] == 1)
		{
			new Float:Pos[3];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			if (!IsPlayerInRangeOfPoint(EscortedPlayer[playerid], 4, Pos[0], Pos[1], Pos[2]))
				SetPlayerPos(EscortedPlayer[playerid], Pos[0] + 0.5, Pos[1] + 0.5, Pos[2]);

			new vir = GetPlayerVirtualWorld(playerid);
			new intid = GetPlayerInterior(playerid);
			PlayerInfo[EscortedPlayer[playerid]][pInt] = PlayerInfo[playerid][pInt];
			PlayerInfo[EscortedPlayer[playerid]][pLocal] = PlayerInfo[playerid][pLocal];

			SetPlayerInterior(EscortedPlayer[playerid], intid);
			SetVirtualWorld(EscortedPlayer[playerid], vir);
		}
		if (DDTime[playerid] > 0 && DrugDealing[playerid] == 2)
		{
			new str[128];
			format(str, sizeof(str), "~y~%d giay ~n~~g~de bat dau buon lau.", DDTime[playerid]);
			GameTextPlayer(playerid, str, 1000, 4);
			DDTime[playerid]--;
		}
		if (DDTime[playerid] == 10 && DrugDealing[playerid] == 2 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new zone[MAX_ZONE_NAME];
			GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
			new str[256];

			new vid = GetPlayerVehicleID(playerid);
			format(str, sizeof(str), "** [Duong day buon lau]: %s cung cac doi tuong ", GN(playerid));
			if (CheckDrugDealerInVehicle(vid, 2) > 1)
			{
				foreach(new ddid : Player)
				{
					if (IsPlayerDrugDealingCooperate(ddid, playerid, 2))
					{
						format(str, sizeof(str), "%s %s, ", str, GN(ddid));
					}
				}
				format(str, sizeof(str), "%s dang tien hanh buon lau o khu vuc %s tren chiec xe %s. **", str, zone, GetVehicleName(vid));
			}
			else format(str, sizeof(str), "** [Duong day buon lau]: %s dang tien hanh buon lau o khu vuc %s tren chiec xe %s. **", GN(playerid), zone, GetVehicleName(GetPlayerVehicleID(playerid)));
			SendRadioMessage(1, TEAM_RADIO_COLOR, str);
		}
		if (DDTime[playerid] == 0 && DrugDealing[playerid] == 2 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			TogglePlayerControllable(playerid, 1);
			if (WantedPoints[playerid] == 0) { WantedPoints[playerid] = 3; }
			else { WantedPoints[playerid] += 2; }
			SetPlayerCriminalEx(playerid, 255, "Buon Lau");
			new str[128];
			format(str, sizeof(str), "Nhan hang da xong, bay gio hay toi diem do tren ban do de giao hang buon lau, hay can than voi canh sat.");
			SCM(playerid, COLOR_YELLOW, str);
			format(str, sizeof(str), "Ban co the yeu cau thay doi dia diem giao hang. (/doibuonlau)");
			SCM(playerid, COLOR_YELLOW, str);

			new rand = random(sizeof(BuonLauGiveCP));

			new vid = GetPlayerVehicleID(playerid);
			if (CheckDrugDealerInVehicle(vid, 2) > 1)
			{
				foreach(new ddid : Player)
				{
					if (IsPlayerDrugDealingCooperate(ddid, playerid, 2))
					{
						if (WantedPoints[ddid] == 0) { WantedPoints[ddid] = 3; }
						else { WantedPoints[ddid] += 2; }
						SetPlayerCriminalEx(ddid, 255, "Buon lau");
						DrugDealing[ddid] = 3;
						ChangeDD[ddid] = 1;
						OldDD[ddid] = rand;
						new viddd = GetPlayerVehicleID(ddid);
						CarDD[ddid] = viddd;
						SetPlayerCheckpoint(ddid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
						CoopDD[ddid] = playerid;
						format(str, sizeof(str), "Nhan hang da xong, %s se la truong nhom buon lau cua ban.", GN(playerid));
						SCM(ddid, COLOR_YELLOW, str);
						SCM(ddid, COLOR_YELLOW, "Hay dam bao rang chiec xe nay se toi duoc noi giao hang.");
						SCM(ddid, COLOR_GREEN, "Meo: Ban chi can mot nguoi giao xe toi dia diem buon lau la phi vu se thanh cong!");
					}
				}
			}
			DrugDealing[playerid] = 3;
			ChangeDD[playerid] = 0;
			OldDD[playerid] = rand;
			CarDD[playerid] = vid;

			SetCheckpoint(playerid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
		}
	}
}

task VehicleLastShot[10000]()
{
	foreach(new i : Vehicle)
	{
		if (LastShot[i] != -1)
			LastShot[i] = -1;
	}
}

task DyingTime[5000]()
{
	foreach(new playerid : Player)
	{
		if (Dying[playerid] == 1 && !IsOnSavePosAmbulance(playerid))
		{
			new Float:zxc;
			GetPlayerHealth(playerid, zxc);
			SetPlayerHealth(playerid, zxc - 1);
		}
	}
}

task Bleeding[10000]()
{
	foreach(new playerid : Player)
	{
		if (PlayerInfo[playerid][pBleeding] == 1)
		{
			new Float:health;
			GetPlayerHealth(playerid, health);
			SetPlayerHealth(playerid, health - 1);
		}
	}
}
