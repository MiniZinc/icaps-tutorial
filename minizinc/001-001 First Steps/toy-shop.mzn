int: budget = 3000;

var 0..1000: A;
var 0..400:  B;
var 0..500:  C;
var 0..150:  D;

constraint 13*A + 21*B + 17*C + 100*D <= budget;

solve maximize 6*A + 10*B + 8*C + 40*D;  
