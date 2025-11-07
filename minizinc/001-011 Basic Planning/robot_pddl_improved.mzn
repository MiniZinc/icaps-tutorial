% A simple robot planning problem

int: H = card(Workstation)+2*card(Packet);    % time horizon

enum Workstation;
enum Packet;

array[Packet] of Workstation: pickup;
array[Packet] of Workstation: dropoff;

array[Workstation] of int: coord;

Workstation: first;

set of int: T = 1..H;

% PDDL actions

enum Action = { Move, PickUp, DropOff };
array[T] of var Action: action;
array[T] of var opt Packet: action_packet;
array[T] of var opt Workstation: action_workstation;

% PDDL predicates -> Boolean variables at each time point

array[T] of var Workstation: at;

array[Packet, T] of var bool: carrying;
array[Packet, T] of var bool: delivered;

array[T] of var int: travel_distance;

% Initialisation

constraint at[1] = first;
constraint forall (p in Packet) (carrying[p,1] = false);
constraint forall (p in Packet) (delivered[p,1] = false);
constraint travel_distance[1] = 0;

% PDDL actions

constraint forall (t in 1..H-1) (
  if action[t] = Move then (
    occurs(action_workstation[t]) /\
    % preconditions
    at[t] != action_workstation[t] /\
    % effects
    at[t+1] = action_workstation[t] /\
    travel_distance[t+1]=travel_distance[t]+abs(coord[action_workstation[t]]-coord[at[t]]) /\
    % no effects
    carrying[..,t] = carrying[..,t+1] /\
    delivered[..,t] = delivered[..,t+1] /\
    % no action parameters
    action_packet[t] = <>
  )
  elseif action[t] = PickUp then (
    occurs(action_packet[t]) /\
    absent(action_workstation[t]) /\
    % preconditions
    pickup[action_packet[t]] = at[t] /\
    (not delivered[action_packet[t], t]) /\
    % effects
    forall (p in Packet) (carrying[p, t+1] = if p=action_packet[t] then true else carrying[p, t] endif) /\
    travel_distance[t+1]=travel_distance[t] /\
    % no effects
    at[t] = at[t+1] /\
    delivered[..,t] = delivered[..,t+1] /\
    action_workstation[t] = <>
  )
  else (% action[t] = DropOff then (
    occurs(action_packet[t]) /\
    absent(action_workstation[t]) /\
    % preconditions
    dropoff[action_packet[t]] = at[t] /\
    carrying[action_packet[t], t] /\
    % effects
    forall (p in Packet) (delivered[p, t+1] = delivered[p, t] \/ (p = action_packet[t])) /\
    forall (p in Packet) (carrying[p, t+1] = if p=action_packet[t] then false else carrying[p, t] endif) /\
    travel_distance[t+1]=travel_distance[t] /\    
    % no effects
    at[t] = at[t+1] /\
    action_workstation[t] = <>
  )
  endif
);

% PDDL goals
constraint forall (p in Packet) (delivered[p,H]);
constraint forall (w in Workstation) (exists (t in T) (at[t]=w));

solve minimize travel_distance[H];

output [
  if fix(action[t])=Move then "Move \(at[t]) -> \(action_workstation[t])\n"
  elseif fix(action[t])=PickUp then "Pick up \(action_packet[t]) at \(at[t])\n"
  elseif fix(action[t])=DropOff then "DropOff \(action_packet[t]) at \(at[t])\n"
  else ""
  endif
| t in T
]++[
  "Distance travelled: \(travel_distance[H])\n"
];
