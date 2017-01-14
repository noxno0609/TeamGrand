//*****************************************//
//		Brian_Furious - Streamer Objects
//*****************************************//
//  	
//================================================================[Config]===========================
#define MAX_STREAMED_OBJECTS 2000

new ObjectModel[MAX_STREAMED_OBJECTS]; 
new Float:ObjectPos[MAX_STREAMED_OBJECTS][3];
new Float:ObjectRotation[MAX_STREAMED_OBJECTS][3];
new Float:ObjectDistance[MAX_STREAMED_OBJECTS];
new ObjectIDS[MAX_PLAYERS][MAX_STREAMED_OBJECTS]; 
new ObjectStreamed[MAX_PLAYERS][MAX_STREAMED_OBJECTS];
new ObjectID = -1; //ObjectCount
new ObjectUsed[MAX_STREAMED_OBJECTS];
new bool:ObjectUpdatetRunning;

//====================================================[Enums]=========================================== 
//========================================================================================================

stock CreateObjectFor(ModelID, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:Dist = 250.0)
{
	if(ObjectUpdatetRunning == false)
	{
	    SetTimer("StartObjectUpdate", MAX_STREAMED_OBJECTS/2, 0);
	    ObjectUpdatetRunning = true;
    }
    ObjectID++; //ObjectID
    ObjectModel[ObjectID] = ModelID; //Model
    ObjectPos[ObjectID][0] = X; //XPos
    ObjectPos[ObjectID][1] = Y; //YPos
    ObjectPos[ObjectID][2] = Z; //ZPos
    ObjectRotation[ObjectID][0] = rX; //RotationX
    ObjectRotation[ObjectID][1] = rY;//RotationY
    ObjectRotation[ObjectID][2] = rZ; //RotationZ
    ObjectDistance[ObjectID] = Dist; //View Distance
    ObjectUsed[ObjectID] = 1;
}

forward StreamObjects();
public StreamObjects()
{
    for(new i; i<MAX_PLAYERS; i++)//Goes through all players
    {
    	if(IsPlayerConnected(i)) //All online players
      	{
        	for(new S; S<ObjectID+1; S++) //All active Checkpoints
        	{
	          	if(ObjectUsed[S] == 1) //Checks if the object is enabled
	          	{
					if(IsPlayerInRangeOfPoint(i, ObjectDistance[S], ObjectPos[S][0], ObjectPos[S][1], ObjectPos[S][2]) && ObjectStreamed[i][S] == 0)//Is the player close enough to the object
		            {
		               	ObjectIDS[i][S] = CreatePlayerObject(i, ObjectModel[S], ObjectPos[S][0], ObjectPos[S][1], ObjectPos[S][2], ObjectRotation[S][0], ObjectRotation[S][1], ObjectRotation[S][2]);//Create the object
				        ObjectStreamed[i][S] = 1; //Shows the object streamed for the player
				        continue;
		        	}
				}
                if(!IsPlayerInRangeOfPoint(i, ObjectDistance[S], ObjectPos[S][0], ObjectPos[S][1], ObjectPos[S][2]) && ObjectStreamed[i][S] == 1)
                {
                	ObjectStreamed[i][S] = 0;
                  	DestroyPlayerObject(i, ObjectIDS[i][S]);
                  	continue;
                }
            }
        }
    }
    return 1;
}

stock DestroyObjectFor(ObjectId) //Destroys the object
{
    ObjectUsed[ObjectId] = 0;
    for(new i; i<MAX_PLAYERS; i++)
    {
    	if(ObjectStreamed[i][ObjectId] == 1)
	    {
			ObjectStreamed[i][ObjectId] = 0;
	        DestroyPlayerObject(i, ObjectIDS[i][ObjectId]);
   		}
    }
}


stock SetObjectDistance(ObjectId, Float:Dist)
{
    ObjectDistance[ObjectId] = Dist;
}

forward StartObjectUpdate();
public StartObjectUpdate()
{
	SetTimer("StreamObjects", 250, true);
}	