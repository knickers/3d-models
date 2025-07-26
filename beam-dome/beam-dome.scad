Beam_Height = 6 * 25.4;
Beam_Depth = 12 * 25.4;
Diameter = (22*12 + 6) * 25.4;
radius = Diameter/2;
r2 = radius * radius;

$fa = $preview ? 15 : 0.1;
$fs = $preview ? 1.25 : 0.6;     // Curve resolution

module curve(d, h, or) {
	rotate_extrude(angle=360, convexity=5)
	translate([or-d, -h/2, 0])
		square([d, h]);
}

/*
soh cah toa
sin = opposite / hyp
cos = adjacent / hyp
tan = opposite / adjacent
        /|
radius / | Beam_height
      ----
        x
a^2 + b^2 = c^2
b^2 = c^2 - a^2
b  = sqrt(c^2 - a^2)
*/

//curve(Beam_Depth, Beam_Height, radius);

for (i = [0:22]) {
	h = Beam_Height * i;
	translate([0, 0, h])
		curve(Beam_Depth, Beam_Height, sqrt(r2 - h*h));
}
