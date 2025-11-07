% products 
enum PRODUCT;  
% Profit per unit for each product
array[PRODUCT] of float: profit; 

% resources
enum RESOURCE; 
% Amount of each resource available
array[RESOURCE] of float: capacity; 

% Units of each resource required to produce 
%       1 unit of product
array[RESOURCE,PRODUCT] of float: consumption; 

% Variables: how much should we make of each product
array[PRODUCT] of var 0..infinity: produce;

% Production can only use the available resources:
constraint forall(r in RESOURCE)(
   sum (p in PRODUCT)
      (consumption[r, p] * produce[p]) <= capacity[r]
); 

% Maximize profit
var int: objective;
constraint objective= sum(p in PRODUCT)   
   (profit[p]*produce[p]);
solve maximize objective;