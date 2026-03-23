Plug_Diameter = 18.8; // 0.01
Plug_Depth    = 15.0; // 0.01
Knob_Diameter = 25.0; // 0.01
Knob_Height   = 15.0; // 0.01

plug_radius = Plug_Diameter / 2;
knob_radius = Knob_Diameter / 2;
knob_offset = cos(45) * knob_radius;

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6;

function fragments(r, a=360) = $fn > 0
	? ($fn >= 3 ? $fn : 3)
	: ceil(max(min(a/$fa, r*2*PI/$fs), 5));

function arc(r, x, y, a1, a2) = [
	for (a = [a1:(a2-a1)/fragments(r, abs(a2-a1)):a2])
		[cos(a)*r+x, sin(a)*r+y]
];

module outline() {
	h = Knob_Diameter/2 - plug_radius;
	polygon(concat(
		[
			[0, 0],
			[plug_radius, 0],
			[plug_radius, Plug_Depth],
			[plug_radius+h, Plug_Depth+h],
			[plug_radius+h, Plug_Depth+h+Knob_Height],
			[0, Plug_Depth+h+Knob_Height],
		]
		//arc(knob_radius, plug_radius+knob_radius, Plug_Depth, 180, 135),
		//arc(knob_radius, 0, Plug_Depth+h+knob_offset, 335, 360),
		//arc(knob_radius, 0, Plug_Depth+h+knob_offset, 0, 45)
	));
}

//polygon(arc(knob_radius, plug_radius+knob_radius, Plug_Depth, 180, 135));
//polygon(arc(knob_radius, plug_radius+knob_radius, 180, 135));

//outline();

rotate_extrude(angle=360, convexity=5)
	outline();
