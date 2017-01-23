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
	aVehLabel[avid] = -1;
}
