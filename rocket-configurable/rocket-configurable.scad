Diameter = 30;
Radius = Diameter / 2;
Height = 200;
Nose_Cone_Height = 60;
Straight_Body = true;
Fin_Thickness = 4;
Fin_Width = 40;
Fin_Height_Inner = 55;
Fin_Height_Outer = 20;
Fin_Offset_Inner = 0;
Fin_Offset_Outer = 0;

$fa = $preview ? 10 : 0.1;
$fs = $preview ? 4 : 1.5;

module nose() {
	x = Nose_Cone_Height * 2 / Diameter;
	translate([0, 0, Height-Nose_Cone_Height])
		rotate(180, [0,0,1])
			scale([1, 1, x])
				rotate_extrude()
					intersection() {
						circle(Radius, $fa=$fa/x, $fs=$fs/x);
						translate([0, -Radius, 0])
							square(Diameter);
					}
}

module body() {
	cylinder(Height-Nose_Cone_Height, Radius, Radius);
}

module fins() {
	for (i=[0:3])
		rotate([0, 0, i*90])
			translate([0, Fin_Thickness/2])
				rotate([90, 0])
					linear_extrude(height=Fin_Thickness)
						polygon(points=[
							[0,                Fin_Offset_Inner],
							[Radius,           Fin_Offset_Inner],
							[Radius+Fin_Width, Fin_Offset_Outer],
							[Radius+Fin_Width, Fin_Offset_Outer+Fin_Height_Outer],
							[Radius,           Fin_Offset_Inner+Fin_Height_Inner],
							[0,                Fin_Offset_Inner+Fin_Height_Inner]
						]);
}

difference() {
	nose();
	if (Nose_Cone_Height*2 > Height) {
		h = Nose_Cone_Height*2 - Height;
		translate([-Radius, -Radius, -h])
			cube([Diameter, Diameter, h]);
	}
}

if (Straight_Body)
	body();

fins();
