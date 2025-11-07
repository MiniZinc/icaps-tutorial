enum Colour = { Green, Blue, Yellow };

var Colour: WA;
var Colour: NT;
var Colour: SA;
var Colour: VIC;
var Colour: NSW;
var Colour: QLD;
var Colour: TAS;

constraint WA ≠ NT;
constraint WA ≠ SA;
constraint NT ≠ SA;
constraint NT ≠ QLD;
constraint SA ≠ QLD;
constraint SA ≠ NSW;
constraint SA ≠ VIC;
constraint NSW ≠ QLD;
constraint NSW ≠ VIC;
