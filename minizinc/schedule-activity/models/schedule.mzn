
enum TASK; % set of tasks to schedule

array[TASK] of int: duration;                % duration of each task
array[int] of tuple(TASK,TASK): precedences; % precedences between tasks
int: code;                                   % ignore (for checking)

int: timelimit = sum(duration); % number  of timesteps available;
set of int:  TIME = 0..timelimit;

array[TASK] of var TIME: start; % start time for each task
