new pdistance = 1;
forward NameTimer();
Float:GetPointDistanceToPointExMorph(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
new Float:xz, Float:yz, Float:zz;
xz = x1-x2;
yz = y1-y2;
zz = z1-z2;
return floatsqroot(xz*xz+yz*yz+zz*zz);
}
stock SetPDistance(dista)
{
pdistance = dista;
}
stock GetPDistance()
{
return pdistance;
}
stock EnableDistancedNameTag(delay)
{
SetTimer("NameTimer",delay,1);
}
forward NameTimer();