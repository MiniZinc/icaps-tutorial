enum TASK;

array[TASK] of int: duration;
array[int,1..2] of TASK: pre;
set of int: PREC = index_set_1of2(pre);

int: e = sum(duration);
array[TASK] of var 0..e: start;

constraint forall(i in PREC) (
	start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]]
);

var 0..e: makespan =  max(t in TASK)(start[t] + duration[t]);
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
	[duration[t] | t in MUTEX],
);
