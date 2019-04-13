//Inputs
blastSourceRadius = 0.1; // m
domainDistance = 20 * blastSourceRadius; // m
floorDistance = 2 * blastSourceRadius; // m
wallDistance = 5 * blastSourceRadius; // m
wallThickness = 0.1; // m
wallHeight = 0.001; // m

blastSourceLc = 0.1 * blastSourceRadius;
wallLc = 2 * blastSourceLc;
farLc = wallLc;

wedgeAngle = 5*Pi/180;

ce = 0;

p = ce;
Point(ce++) = {0, 0, 0};
Point(ce++) = {0, -blastSourceRadius, 0, blastSourceLc};
Point(ce++) = {blastSourceRadius, 0, 0, blastSourceLc};
Point(ce++) = {0, blastSourceRadius, 0, blastSourceLc};

bottomarc = ce;
Circle(ce++) = {p + 1, p, p + 2};
toparc = ce;
Circle(ce++) = {p + 2, p, p + 3};
sourceline = ce;
Line(ce++) = {p + 1, p + 3};

p = ce;
Point(ce++) = {0, -floorDistance, 0, farLc};
Point(ce++) = {wallDistance, -floorDistance, 0, wallLc};
Point(ce++) = {wallDistance, -floorDistance + wallHeight, 0, wallLc};
Point(ce++) = {wallDistance + wallThickness, -floorDistance + wallHeight, 0, wallLc};
Point(ce++) = {wallDistance + wallThickness, -floorDistance, 0, wallLc};

Point(ce++) = {domainDistance, -floorDistance, 0, farLc};

Point(ce++) = {domainDistance, -floorDistance, 0, farLc};
Point(ce++) = {domainDistance, domainDistance, 0, farLc};
Point(ce++) = {0, domainDistance, 0, farLc};

l = ce;
Line(ce++) = {p - 6, p};
For k In {0:7}
    Line(ce++) = {p + k, p + k + 1};
EndFor
Line(ce++) = {p + 8, p - 4};

sourceloop = ce;
Line Loop(ce++) = {sourceline, -toparc, -bottomarc};
sourcesurface = ce;
Plane Surface(ce++) = {sourceloop};
domainloop = ce;
Line Loop(ce++) = {l : l + 9, -toparc, -bottomarc};
domainsurface = ce;
Plane Surface(ce++) = {domainloop};

Rotate {{0,1,0}, {0,0,0}, wedgeAngle/2}
{
  Surface{domainsurface, sourcesurface};
}
domainEntities[] = Extrude {{0,1,0}, {0,0,0}, -wedgeAngle}
{
  Surface{domainsurface, sourcesurface};
  Layers{1};
  Recombine;
};

Physical Surface("wedge0") = {domainsurface, sourcesurface};
Physical Surface("wedge1") = {domainEntities[{0, 12}]};
Physical Surface("walls") = {domainEntities[{2 : 9}]};

Physical Volume("blastSource") = {domainEntities[13]};
Physical Volume(1000) = {domainEntities[1]};

