Pipe_Diameter = 14; // 0.01
pipe_radius = Pipe_Diameter / 2;
Bend_Radius = 75;

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6;

difference() {
	union() {
		// Main body
		cylinder(r=Bend_Radius, Pipe_Diameter*2, center=true);

		// End grabber body
		translate([Bend_Radius, Pipe_Diameter, 0])
			rotate(90, [1,0,0])
				cylinder(r=Pipe_Diameter, h=Pipe_Diameter*2);
	}

	// Main slot
	rotate_extrude(angle=270, convexity=5)
		translate([Bend_Radius, 0])
			circle(r=pipe_radius, $fa=$fa*2, $fs=$fs*2);

	// Flatten the bottom
	translate([-Bend_Radius-1, -Bend_Radius-Pipe_Diameter-1, -Pipe_Diameter-1])
		cube([Bend_Radius*2+2, Bend_Radius+1, Pipe_Diameter*2+2]);

	// End grabber hole
	translate([Bend_Radius, Pipe_Diameter, 0])
		rotate(90, [1,0,0])
			cylinder(r=pipe_radius, h=Pipe_Diameter*2, $fa=$fa*2, $fs=$fs*2);

	// End grabber slot
	translate([Bend_Radius-pipe_radius, -Pipe_Diameter, 0])
		cube([Pipe_Diameter, Bend_Radius, Pipe_Diameter]);
}
