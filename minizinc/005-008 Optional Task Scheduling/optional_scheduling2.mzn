enum TASK;

array[TASK] of int: duration;
array[int,1..2] of TASK: pre;
set of int: PREC = index_set_1of2(pre);

array[int] of set of TASK: options; 


int: e = sum(duration);
array[TASK] of var opt 0..e: start;

constraint forall(i in PREC) (
	start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]]
);

var 0..e: makespan =  max(t in TASK)(start[t] + duration[t]);
solve minimize makespan;

set of TASK: MUTEX;


% ---- Using Global ----
include "globals.mzn";
constraint disjunctive(
	[start[t] | t in MUTEX],
	[duration[t] | t in MUTEX],
);

% ---- Using Optionality ----
constraint forall(t in TASK diff array_union(options))(occurs(start[t]));
constraint forall(i in index_set(options))(exists(t in options[i])(occurs(start[t])));
