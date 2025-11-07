enum TASK; % set of tasks to schedule

array[TASK] of int: duration;                % duration of each task
array[TASK] of int: due;                     % due date for each task
array[int] of tuple(TASK,TASK): precedences; % precedences between tasks
array[int] of set of TASK: nonoverlapping;   % sets of task that should not overlap
int: code; % internal data for checker ignore!

int: timelimit = max(max(due),sum(duration)); % number  of timesteps available;
set of int:  TIME = 0..timelimit;

array[TASK] of var TIME: start; % start time for each task
