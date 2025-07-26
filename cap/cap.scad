T = 1.6;
H = 20;
ID = 34;
OD = ID + T*2;
$fn = 80;

difference() {
	cylinder(d=OD, h=H);
	translate([0, 0, T])
		cylinder(d=ID, h=H);
}