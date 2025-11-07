enum TASK;

array[TASK] of int: duration;
array[int,1..2] of TASK: pre;
set of int: PREC = index_set_1of2(pre);

int: e = sum(duration);
array[TASK] of var 0..e: start;

constraint forall(i in PREC) (
	start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]]
);

var 0..e: makespan;
constraint makespan =  max(t in TASK)(start[t] + duration[t]);
solve minimize makespan;
