Width = 100;
Length = 200;
Thickness = 10;
r = Thickness / 2;
Outer_Leg_Depth = 40;
Inner_Leg_Depth = 75;
Leg_Separation = 20;
Chamfer_Size = 0;

$fa = $preview ? 15 : 1;
$fs = $preview ? 3 : 0.75;

translate([0, 0, Chamfer_Size])
	linear_extrude(Length-Chamfer_Size*2)
		outline();

module outline() {
	// Top plate
	translate([-r, r, 0])
		circle(d=Thickness);
	translate([-r, 0, 0])
		square([Width-Thickness, Thickness]);
	translate([Width-Thickness-r, r, 0])
		circle(d=Thickness);

	// Outer leg
	translate([-Thickness, r-Outer_Leg_Depth, 0])
		square([Thickness, Outer_Leg_Depth]);
	translate([-r, r-Outer_Leg_Depth, 0])
		circle(d=Thickness);

	// Inner leg
	translate([Leg_Separation, r-Inner_Leg_Depth, 0])
		square([Thickness, Inner_Leg_Depth]);
	translate([Leg_Separation+r, r-Inner_Leg_Depth, 0])
		circle(d=Thickness);
}
