// Outside diameter of the diffuser body
Outside_Diameter = 22;
// Inside diameter of the diffuser body
Inside_Diameter = 18;
// Diffuser height beyond the flashlight top
Height = 50;
// Diffuser sleeve length down flashlight body
Depth = 20;
// Clearance around flashlight body and threads
Tolerance = 0.05;

Thread_ID = 15.9 + 0;
Thread_IR = Thread_ID/2;
Thread_OD = 17.7 + 0;
Thread_OR = Thread_OD/2;
// Length of the threads
Thread_Height = 10;
// Multiple start: 4 x 0.05" = 0.2"
Thread_Pitch = 5.08;
Thread_Pitch_Ratio = 0.5 / 4;
// (15.9 + (17.7 - 15.9) / 2) / 2
Thread_Pitch_Radius = 8.40; // Thread_IR+(Thread_OR-Thread_IR)/2;

use <Thread_Library.scad>

difference() {
	body_exterior();
	translate([0, 0, -Depth-1])
		cylinder(d=Inside_Diameter, h=Depth+1); // Socket
	if ($preview)
		cylinder(r=Thread_Pitch_Radius, h=Thread_Pitch*4, center=true);
	else
		threads();
}

module threads() {
	difference() {
		translate([0, 0, Thread_Pitch*.7])
			for (i = [0:3])
				rotate([0, 0, i*90])
					trapezoidThreadNegativeSpace(
						length=Thread_Height, 
						pitch=Thread_Pitch,
						pitchRadius=Thread_Pitch_Radius,
						threadHeightToPitch=Thread_Pitch_Ratio,
						clearance=Tolerance,
						backlash=Tolerance
					);
		translate([0, 0, Thread_Height+Thread_Pitch/2])
			cube([Thread_Pitch_Radius*3, Thread_Pitch_Radius*3, Thread_Pitch], center=true);
		/*
		translate([0, 0, -Thread_Pitch/2])
			cube([Thread_Pitch_Radius*3, Thread_Pitch_Radius*3, Thread_Pitch], center=true);
		*/
	}
}

module body_exterior() {
	/*
	translate([0, 0, 10])
		cylinder(d1=Outside_Diameter, r2=Outside_Diameter/3, h=Height); // Cone
	*/
	translate([0, 0, -Depth])
		cylinder(d=Outside_Diameter, h=Height+Depth); // Threads
	/*
	translate([0, 0, -Depth])
		cylinder(d1=Inside_Diameter, d2=Outside_Diameter, h=Depth); // Cone
	*/
}
