Pen_Diameter = 6.7; // 0.1
pen_radius = Pen_Diameter / 2;
Pen_Thickness = 5.7; // 0.1
Pen_Length = 133; // 0.1
Pen_Tip_Length = 6; // 0.1
Holder_Thickness = 0.7; // 0.1
Holder_Grasp_Angle = 30; // [0:0.1:45]

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6;

module holder_2_body() {
	// Back
	translate([0, -Holder_Thickness, 0])
		cube([Pen_Diameter+Holder_Thickness*2, Holder_Thickness, Pen_Length]);

	// Left
	cube([Holder_Thickness, Pen_Thickness/2, Pen_Length]);

	// Right
	translate([Pen_Diameter+Holder_Thickness, 0, 0])
		cube([Holder_Thickness, Pen_Thickness/2, Pen_Length]);

	// Arc
	translate([pen_radius+Holder_Thickness, Pen_Thickness/2, 0])
		rotate_extrude(angle=180, convexity=5)
			translate([pen_radius, 0, 0])
				square([Holder_Thickness, Pen_Length]);
}

module holder_2_back() {
	t = 0.2;
	translate([Holder_Thickness+t, 0, 0]) {
		difference() {
			// Plate
			translate([pen_radius-t, Pen_Thickness/2, 0])
				cylinder(r=pen_radius-t, h=Holder_Thickness+pen_radius);
			// Quarter pipe
			translate([pen_radius-t, Pen_Thickness/2, Holder_Thickness+pen_radius])
				rotate(90, [0,1,0])
					cylinder(r=pen_radius, h=Pen_Diameter-t*2, center=true);
			// Flat face
			translate([0, Pen_Thickness/2, Holder_Thickness])
				cube([Pen_Diameter, Pen_Thickness, Holder_Thickness+pen_radius]);
			// Flat top
			translate([0, Pen_Thickness-t, 0])
				cube([Pen_Diameter, Pen_Thickness, Holder_Thickness]);
		}
	}
}

//holder_2_body();
//holder_2_back();
difference() {
	translate([-pen_radius-Holder_Thickness, -Pen_Thickness/2, 0])
		holder_2_body();
	holder_negative();
}
translate([-pen_radius-Holder_Thickness, -Pen_Thickness/2, 0])
	holder_2_back();
/*
*/

module pen() {
	intersection() {
		translate([0, 0, pen_radius])
			union() {
				translate([0, 0, Pen_Length-Pen_Tip_Length-pen_radius])
					cylinder(d1=Pen_Diameter, d2=0, h=Pen_Tip_Length);
				cylinder(d=Pen_Diameter, h=Pen_Length-Pen_Tip_Length-pen_radius);
				sphere(r=pen_radius);
			}
		translate([-pen_radius, -Pen_Thickness/2, 0])
			cube([Pen_Diameter, Pen_Thickness, Pen_Length]);
	}
}

module holder_body() {
	radius = pen_radius + Holder_Thickness;
	length = Pen_Length-2;
	thickness = Pen_Thickness + Holder_Thickness*2;
	intersection() {
		cylinder(r=radius, h=Pen_Length);
		translate([-radius, -thickness/2, 0])
			cube([radius*2, thickness, Pen_Length]);
	}
	translate([-radius, -thickness/2, 0])
		cube([radius*2, thickness/2, Pen_Length]);
}

module holder_negative() {
	radius = pen_radius + Holder_Thickness;
	// Right side
	rotate(Holder_Grasp_Angle, [0,0,1])
		difference() {
			cube([Pen_Diameter, Pen_Diameter, Pen_Length]);
			translate([radius-Holder_Thickness/2, 0, 0])
				cylinder(d=Holder_Thickness, h=Pen_Length, $fa=$fa/2, $fs=$fs/2);
		}
	// Left side
	rotate(90-Holder_Grasp_Angle, [0,0,1])
		difference() {
			cube([Pen_Diameter, Pen_Diameter, Pen_Length]);
			translate([0, radius-Holder_Thickness/2, 0])
				cylinder(d=Holder_Thickness, h=Pen_Length, $fa=$fa/2, $fs=$fs/2);
		}
}

/*
pen();
rotate(90, [1,0,0])
translate([0, Pen_Thickness/2+Holder_Thickness, -Pen_Length/2])
difference() {
	holder_body();
	holder_negative();
	color("Azure")
	pen();
}
*/
