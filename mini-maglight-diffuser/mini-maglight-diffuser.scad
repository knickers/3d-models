/*
Multiple start, 4 threads per revolution.
4x multiple of 0.05" pitch = 0.2" = 5.08mm
*/
Inside_Diameter = 15.9;
Inside_Radius = Inside_Diameter/2;
Outside_Diameter = 17.7;
Outside_Radius = Outside_Diameter/2;
Pitch = 5.08;
Pitch_Radius = Inside_Radius+(Outside_Radius-Inside_Radius);
echo(Pitch_Radius=Pitch_Radius);

use <Thread_Library.scad>

difference() {
	cylinder(r=Outside_Radius+2, h=10);
	translate([0, 0, -Pitch/4])
		if ($preview)
			cylinder(r=Inside_Radius, h=Pitch*2);
		else
			threads();
}

module threads() {
	translate([0, 0, Pitch])
		for (i = [0:3])
			rotate([0, 0, i*90])
				trapezoidThreadNegativeSpace(
					length=Pitch*2, 
					pitch=Pitch,
					pitchRadius=Pitch_Radius,
					threadHeightToPitch=0.5/4,
					clearance=0,
					backlash=0
				);
}
