enum ROBOT;
int: budget;

array[ROBOT] of int: available;
array[ROBOT] of int: cost;
array[ROBOT] of int: tph; % toys per hour

% how many robots to buy
array[ROBOT] of var 0..infinity: buy; 

constraint
    forall(r in ROBOT) (buy[r] <= available[r]);

constraint
    sum(r in ROBOT) (cost[r]*buy[r]) <= budget;

var int: objective = sum(r in ROBOT) (tph[r]*buy[r]);
solve maximize objective;
    

output [ "\(r):\t  \(buy[r])\n"
       | r in ROBOT ];
output [ "overall toys per hour: \(objective)\n" ];