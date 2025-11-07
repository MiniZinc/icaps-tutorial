enum TASK;

array[TASK] of int: duration;
array[int,1..2] of TASK: pre;
set of int: PREC = index_set_1of2(pre);

array[int] of set of TASK: options; 


int: e = sum(duration);
array[TASK] of var 0..e: start;
array[TASK] of var bool: runs;
array[TASK] of var 0..max(duration): aduration;


constraint forall(i in PREC) (
	start[pre[i,1]] + aduration[pre[i,1]] <= start[pre[i,2]]
);

var 0..e: makespan =  max(t in TASK)(start[t] + aduration[t]);
solve minimize makespan;

set of TASK: MUTEX;

% ---- Initial design ----
predicate nonoverlap(var int:s1, var int:d1,
                     var int:s2, var int:d2) =
          s1 + d1 <= s2 \/ s2 + d2 <= s1;

constraint forall(t1, t2 in MUTEX where t1 < t2)
      (nonoverlap(start[t1],duration[t1],
                  start[t2],duration[t2]));

% ---- Using Global ----
include "disjunctive.mzn";
constraint disjunctive(
	[start[t] | t in MUTEX],
	[aduration[t] | t in MUTEX],
);

% ---- Using Optionality ----
% task duration is zero if it does not run
constraint forall(t in TASK)(aduration[t] = runs[t]*duration[t]);
constraint forall(t in TASK diff array_union(options))(runs[t]);
constraint forall(i in index_set(options))(exists(t in options[i])(runs[t]));
