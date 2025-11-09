% power generation
int: T;                 % decades
array[1..T] of int: e;  % expected requirements
array[1..T] of int: a;  % current production

array[1..T] of var 0..infinity: N; % number of nuclear power plants built each decade
array[1..T] of var 0..infinity: C; % number of coal power plants built each decade
array[1..T] of var 0..infinity: S; % number of solar power plants built each decade

var 0..infinity: cost;  % costs of building all new power plants
solve minimize cost;
                           
