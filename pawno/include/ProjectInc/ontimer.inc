task ServerBeat[1000]()
{
	foreach(Player, playerid)
	{
		if (OnDuty[playerid] == 1 && (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1) && WearTazer[playerid] != 1)
		{
			Tazering[playerid] = 0;
			SetPlayerAttachedObject(playerid, 5, 18642, 1, -0.197000, -0.071000, -0.109999, 2.399994, 80.400001, 18.399993, 1.000000, 1.000000, 1.000000, 0, 0);
			WearTazer[playerid] = 1;
		}
		else if (OnDuty[playerid] == 0 && PlayerInfo[playerid][pMember] != 1 && PlayerInfo[playerid][pLeader] != 1 && WearTazer[playerid] == 1)
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
			for (new i = 0; i<MAX_PLAYERS; i++)
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
			SetPlayerVirtualWorld(EscortedPlayer[playerid], vir);
		}
		if (DDTime[playerid] > 0 && DrugDealing[playerid] == 2)
		{
			new str[128];
			format(str, sizeof(str), "~y~%d giay ~n~~g~de bat dau buon lau.", DDTime[playerid]);
			GameTextForPlayer(playerid, str, 1000, 4);
			DDTime[playerid]--;
		}
		if (DDTime[playerid] == 10 && DrugDealing[playerid] == 2)
		{
			new zone[MAX_ZONE_NAME];
			GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
			new str[128];
			format(str, sizeof(str), "[Duong day buon lau]: %s dang tien hanh buon lau o khu vuc %s tren chiec xe %s.", GN(playerid), zone, GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))));
			SendRadioMessage(1, TEAM_RADIO_COLOR, str);
		}
		if (DDTime[playerid] == 0 && DrugDealing[playerid] == 2)
		{
			TogglePlayerControllable(playerid, 1);
			if (WantedPoints[playerid] == 0) { WantedPoints[playerid] = 3; }
			else { WantedPoints[playerid] += 2; }
			SetPlayerCriminalEx(playerid, 255, "Buon lau");
			new str[128];
			format(str, sizeof(str), "Nhan hang da xong, bay gio hay toi diem do tren ban do de giao hang buon lau, hay can than voi canh sat.");
			SCM(playerid, COLOR_YELLOW, str);
			format(str, sizeof(str), "Ban co the yeu cau thay doi dia diem giao hang. (/doibuonlau)");
			SCM(playerid, COLOR_YELLOW, str);

			new rand = random(sizeof(BuonLauGiveCP));
			DrugDealing[playerid] = 3;
			ChangeDD[playerid] = 0;
			OldDD[playerid] = rand;
			new vid = GetPlayerVehicleID(playerid);
			CarDD[playerid] = vid;

			SetPlayerCheckpoint(playerid, BuonLauGiveCP[rand][0], BuonLauGiveCP[rand][1], BuonLauGiveCP[rand][2], 5);
		}
	}
	//printf("Called every second, but not at the same time as RepeatingFunction2.");
}
