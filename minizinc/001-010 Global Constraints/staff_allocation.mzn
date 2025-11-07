enum Staff;
enum Shift;

% Preferences (higher = better)
array[Shift,Staff] of int: preference;

% Decisions: who works which shift
array[Shift] of var Staff: allocation;

include "all_different.mzn";
constraint all_different(allocation);

solve minimize
    sum(s in Shift)
       (preference[s,allocation[s]]);
