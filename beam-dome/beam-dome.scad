/*
a^2 + b^2 = c^2
b^2 = c^2 - a^2
b  = sqrt(c^2 - a^2)
*/

Base_Diameter = (20*12 + 6);// * 25.4;
Beam_Height = 6;// * 25.4;
Beam_Depth = 12;// * 25.4;
Dome_Height = 7 * 12;

// r = l^2 / 8h + h/2
radius = pow((Base_Diameter + Beam_Depth*2), 2) / 8 / Dome_Height + Dome_Height/2;
r2 = radius * radius;

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6;     // Curve resolution

module curve(d, h, or) {
	translate([0, 0, h/2])
		rotate_extrude(angle=360, convexity=5)
			translate([or-d, -h/2, 0])
				square([d, h]);
}

module dome() {
	offset = floor((radius-Dome_Height)/Beam_Height);
	//curve(Beam_Depth, Beam_Height*offset, radius);
	translate([0, 0, Dome_Height-radius+0.49]) {
		for (i = [offset:offset+12]) {
			h = Beam_Height * i;
			x = sqrt(r2 - h*h);
			x1 = sqrt(r2 - pow(Beam_Height*(i+1), 2));
			w = max((x - x1) * 2, Beam_Depth);
			echo("Beam #", i-offset+1, "ID", (x-w)*2, "Width", w, h);
			translate([0, 0, h])
				curve(w, Beam_Height, x);
		}
		i = offset+13;
		h = Beam_Height * i;
		x = sqrt(r2 - h*h);
		w = 26;
		echo("Beam #", i+1, "ID", (x-w)*2, "Width", w, h);
		translate([0, 0, h])
			curve(w, Beam_Height, x);
	}
}

//curve(Beam_Depth, Beam_Height, radius);
dome();
/** /
difference() {
	dome();
	translate([-Base_Diameter, 0, 0])
		cube([Base_Diameter*2, Base_Diameter, Base_Diameter]);
}
/**/
