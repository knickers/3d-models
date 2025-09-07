// Top Geopmetry
Top_Shape = "Flat"; // ["Flat", "Dome"]
// Diameter at the top of the diffuser
Top_Diameter = 14;
// Outside diameter of the diffuser body
Outside_Diameter = 22;
// Diameter around the flashlight
Inside_Diameter = 18;
// Diffuser height beyond the flashlight top
Height = 100;
// Diffuser sleeve length down flashlight body
Depth = 20;
// Lip just above threads to turn off light
Interior_Lip_Diameter = 12;
// Internal geometry
Interior = "Solid"; // ["Solid", "Hollow", "Cone", "Spike"]

Thread_ID = 15.9 + 0;
Thread_IR = Thread_ID/2;
Thread_OD = 17.7 + 0;
Thread_OR = Thread_OD/2;
// Length of the threads
Thread_Height = 10;
// Multiple start: 4 x 0.05" = 0.2"
Thread_Pitch = 5.08; // 0.01
Thread_Pitch_Ratio = 0.5 / 4;
// (15.9 + (17.7 - 15.9) / 2) / 2
Thread_Pitch_Radius = 8.40; // 0.01

// Clearance around flashlight body and threads
Tolerance = 0.1; // 0.01
Thickness = (Outside_Diameter - Inside_Diameter) / 2;

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6; // Curve resolution

use <Thread_Library.scad>

difference() {
	rotate_extrude(convexity=5)
		body_perimeter();
	if ($preview) {
		cylinder(r=Thread_Pitch_Radius, h=Thread_Pitch*4.8, center=true);
		translate([0, 0, -Height/2])
			cube([Outside_Diameter, Outside_Diameter, Height*2]);
	}
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
		translate([0, 0, Thread_Pitch/2+Thread_Height])
			cube([Thread_Pitch_Radius*3, Thread_Pitch_Radius*3, Thread_Pitch], center=true);
		translate([0, 0, -Thread_Pitch/2])
			cube([Thread_Pitch_Radius*3, Thread_Pitch_Radius*3, Thread_Pitch], center=true);
	}
}

module body_exterior() {
	translate([0, 0, Thread_Height])
		cylinder(d1=Outside_Diameter, r2=Outside_Diameter/3, h=Height); // Cone
	translate([0, 0, -Depth])
		cylinder(d=Outside_Diameter, h=Thread_Height+Depth); // Threads
}

module body_perimeter() {
	polygon(concat(
		[
			[Interior_Lip_Diameter/2, Thread_Height],
			[Interior_Lip_Diameter/2, 1],
			[Inside_Diameter/2 + Tolerance*2, 0],
			[Inside_Diameter/2 + Tolerance*2, -Depth],
			[Outside_Diameter/2, -Depth],
			[Outside_Diameter/2, Thread_Height],
			[Top_Diameter/2, Height+Thread_Height],
			[0, Height+Thread_Height]
		],
		Interior == "Solid" ? [
			[0, Thread_Height]
		] : [],
		Interior == "Hollow" ? [
			[0, Height+Thread_Height-Thickness],
			[Top_Diameter/2-Thickness, Height+Thread_Height-Thickness]
		] : [],
		Interior == "Cone" ? [
			[0, Height+Thread_Height-0.2],
		] : [],
		Interior == "Spike" ? [
			[0, Thread_Height+Thickness],
			[Top_Diameter/2-Thickness, Height+Thread_Height-Thickness]
		] : []
	));
}
