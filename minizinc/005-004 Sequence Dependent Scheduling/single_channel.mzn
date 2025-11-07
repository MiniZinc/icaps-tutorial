include "all_different.mzn";

int: len;
int: leeway;  % leeway between 2 ships
int: max_time;
set of int: Time = 0..max_time;

enum Ship;
array[Ship] of int: speed;   % 1000m time 
array[Ship] of int: desired; % desired time
enum Direction = { West, East };
array[Ship] of Direction: dirn;

enum Ship0 = {Dummy} ++ S(Ship); % add dummy
enum Direction0 = { Nowhere } ++ D(Direction);
array[Ship0] of Direction0: dirn0 = array1d(Ship0, [ Nowhere ] ++ [D(dirn[s]) | s in Ship]);
array[Ship0] of int: speed0 = array1d(Ship0, [0] ++ speed);

array[Ship0] of var Time: start ::add_to_output; 
array[Ship0] of var Time: end ::add_to_output = [start[s] + len*speed0[s] | s in Ship0];

array[Ship] of var Ship0: next ::add_to_output; % next ship

constraint start[Dummy] = max_time;

constraint all_different(next);

constraint forall(s in Ship)(
	start[S(s)] >= desired[s]
);

constraint forall(s in Ship) (
	if dirn0[S(s)] != dirn0[next[s]] then
		end[S(s)] <= start[next[s]]
	else
		start[S(s)] + speed[s]*leeway <= start[next[s]] /\
		end[S(s)] + speed0[next[s]]*leeway <= end[next[s]]
	endif
); 

solve minimize max(s in Ship)(end[S(s)]);
