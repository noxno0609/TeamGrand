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
	}
	//printf("Called every second, but not at the same time as RepeatingFunction2.");
}
