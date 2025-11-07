enum Workstation;
Workstation: first;
int: n = card(Workstation);
set of int: Pos = 1..n;
array[Workstation] of int: coord;

enum Packet;
array[Packet] of Workstation: pickup;
array[Packet] of Workstation: dropoff;

array[Workstation] of var Pos: order;
array[Pos] of var Workstation: route;

constraint route[1] = first;

include "inverse.mzn";
constraint inverse(order, route);

constraint forall (pk in Packet) (
  order[pickup[pk]] < order[dropoff[pk]]
);

var int: totalDistance;
constraint totalDistance =
  sum (p in 1..n-1)
      (abs(coord[route[p]] - coord[route[p+1]]));

solve minimize totalDistance;

output ["order = [",join(", ", [show(o) | o in order]),"];\n"];
output ["route = [",join(", ", [show(r) | r in route]),"];\n"];
output ["totalDistance = \(totalDistance);\n"];