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

enum Action = { Move, PickUp, DropOff, None };
array[T] of var Action: action;
array[T] of var opt Workstation: action_move_from;
array[T] of var opt Workstation: action_move_to;
array[T] of var opt Packet: action_packet;
array[T] of var opt Workstation: action_workstation;

% PDDL predicates -> Boolean variables at each time point

array[Workstation, T] of var bool: at;
array[Workstation, T] of var bool: visited;

array[Packet, T] of var bool: carrying;
array[Packet, T] of var bool: delivered;

array[T] of var int: travel_distance;

% Initialisation

constraint forall (w in Workstation) (at[w,1] = (w=first));
constraint forall (w in Workstation) (visited[w,1] = (w=first));
constraint forall (p in Packet) (carrying[p,1] = false);
constraint forall (p in Packet) (delivered[p,1] = false);
constraint travel_distance[1] = 0;

% PDDL actions

constraint forall (t in 1..H-1) (
  if action[t] = Move then (
    occurs(action_move_from[t]) /\
    occurs(action_move_to[t]) /\
    % preconditions
    at[action_move_from[t],t] /\
    action_move_from[t] != action_move_to[t] /\
    % effects
    forall (w in Workstation) (at[w, t+1] = (w=action_move_to[t])) /\
    forall (w in Workstation) (visited[w, t+1] = visited[w, t] \/ (w=action_move_to[t])) /\
    travel_distance[t+1]=travel_distance[t]+abs(coord[action_move_to[t]]-coord[action_move_from[t]]) /\
    % no effects
    carrying[..,t] = carrying[..,t+1] /\
    delivered[..,t] = delivered[..,t+1] /\
    % no action parameters
    action_packet[t] = <> /\
    action_workstation[t] = <>
  )
  elseif action[t] = PickUp then (
    occurs(action_packet[t]) /\
    occurs(action_workstation[t]) /\
    % preconditions
    pickup[action_packet[t]] = action_workstation[t] /\
    at[action_workstation[t], t] /\
    (not delivered[action_packet[t], t]) /\
    % effects
    forall (p in Packet) (carrying[p, t+1] = if p=action_packet[t] then true else carrying[p, t] endif) /\
    travel_distance[t+1]=travel_distance[t] /\
    % no effects
    at[..,t] = at[..,t+1] /\
    visited[..,t] = visited[..,t+1] /\
    delivered[..,t] = delivered[..,t+1] /\
    % no action parameters
    action_move_from[t] = <> /\
    action_move_to[t] = <>
  )
  elseif action[t] = DropOff then (
    occurs(action_packet[t]) /\
    occurs(action_workstation[t]) /\
    % preconditions
    dropoff[action_packet[t]] = action_workstation[t] /\
    at[action_workstation[t], t] /\
    carrying[action_packet[t], t] /\
    % effects
    forall (p in Packet) (delivered[p, t+1] = delivered[p, t] \/ (p = action_packet[t])) /\
    forall (p in Packet) (carrying[p, t+1] = if p=action_packet[t] then false else carrying[p, t] endif) /\
    travel_distance[t+1]=travel_distance[t] /\    
    % no effects
    at[..,t] = at[..,t+1] /\
    visited[..,t] = visited[..,t+1] /\
    % no action parameters
    action_move_from[t] = <> /\
    action_move_to[t] = <>
  )
  else (
    action[t] = action[t+1] /\
    % no effects
    at[..,t] = at[..,t+1] /\
    visited[..,t] = visited[..,t+1] /\
    carrying[..,t] = carrying[..,t+1] /\
    delivered[..,t] = delivered[..,t+1] /\
    travel_distance[t+1]=travel_distance[t] /\
    % no action parameters
    action_move_from[t] = <> /\
    action_move_to[t] = <> /\
    action_packet[t] = <> /\
    action_workstation[t] = <>    
  )
  endif
);

% PDDL goals
constraint forall (p in Packet) (delivered[p,H]);
constraint forall (w in Workstation) (visited[w,H]);
constraint action[H] = None;
% Instance data

solve minimize travel_distance[H];

output [
  if fix(action[t])=Move then "Move \(action_move_from[t]) -> \(action_move_to[t])\n"
  elseif fix(action[t])=PickUp then "Pick up \(action_packet[t]) at \(action_workstation[t])\n"
  elseif fix(action[t])=DropOff then "DropOff \(action_packet[t]) at \(action_workstation[t])\n"
  else ""
  endif
| t in T
]++[
  "Distance travelled: \(travel_distance[H])\n"
];
