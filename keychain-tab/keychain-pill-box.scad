// Inside the fillet at the widest point
Body_Diameter = 30.0; // 0.1

// Thickness of the back plane
Body_Thickness = 1; // 0.1

// This plus thickness is the total height
Body_Fillet_Radius = 2.5; // 0.1

// Raised innser section
Inner_Plateau_Diameter = 18.5; // 0.1

// Raised innser section
Inner_Plateau_Height = 0.4; // 0.1

// To the center of the keyring
Ring_Diameter = 7; // 0.1

// Distance from body edge to ring center
Ring_Offset = 0; // 0.1

$fa = $preview ? 15 : 1;
$fs = $preview ? 2 : 0.75;

function octagon(r) = r / cos(22.5);

module cone() {
	difference() {
		translate([0, 0, Body_Fillet_Radius/2])
			cube([
				Body_Diameter + Body_Thickness*2 + 2,
				Body_Diameter + Body_Thickness*2 + 2,
				Body_Fillet_Radius
			], center=true);
		cylinder(
			d1 = Body_Diameter + Body_Thickness*2,
			d2 = 0,
			h = Body_Diameter/2 + Body_Thickness
		);
	}
}

difference() {
	union() {
		difference() {
			// Main body
			cylinder(
				d = Body_Diameter + Body_Thickness*2,
				h = Body_Fillet_Radius + Body_Thickness
			);

			// Top chamfer
			translate([0, 0, Body_Fillet_Radius+0.4])
				cone();

			// Bottom chamfer
			translate([0, 0, Body_Thickness])
				rotate(180, [0,1,0])
					cone();
		}

		// Keychain ring
		r = Body_Fillet_Radius/2 + Body_Thickness/2;
		translate([0, Body_Diameter/2 + Body_Thickness + Ring_Offset, r])
			rotate_extrude(angle=360, convexity=4)
				translate([Ring_Diameter/2 + r, 0, 0])
					rotate(22.5, [0,0,1])
						circle(r = octagon(r), $fn = 8);
	}

	translate([0, 0, Body_Thickness]) {
		// Inner volume
		cylinder(
			d = Body_Diameter - Body_Fillet_Radius * 2,
			h = Body_Fillet_Radius + 1
		);

		// Fillet
		translate([0, 0, Body_Fillet_Radius])
			rotate_extrude(angle=360, convexity=4)
				translate([Body_Diameter/2-Body_Fillet_Radius, 0, 0])
					circle(r=Body_Fillet_Radius, $fs=$fs*0.6);
	}
}

// Platequ circle
cylinder(d=Inner_Plateau_Diameter, h=Inner_Plateau_Height+Body_Thickness);
