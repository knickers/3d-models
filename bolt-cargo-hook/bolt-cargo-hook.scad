Tab_Thickness = 1.5; // 0.01
Tab_Width = 9.6; // 0.01
Tab_Outer_Diameter = 33.5; // 0.01
Socket_Inner_Diameter = 24.5; // 0.01
Socket_Inner_Radius = Socket_Inner_Diameter / 2;
Socket_Inner_Depth = 3.0; // 0.01
Flange_Thickness = 2.5; // 0.01
Flange_Outer_Diameter = 36.0; // 0.01
Flange_Inner_Diameter = 19.5; // 0.01
Hook_Thickness = 4.0; // 0.01
Hook_Chamfer = Hook_Thickness/3;
Total_Height = Tab_Thickness+Socket_Inner_Depth+Flange_Thickness;
Part = "Hook"; // [Tabs, Hook, Pin]

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 1;

if (Part == "Tabs") {
	tab_socket();
}
if (Part == "Hook") {
	difference() {
		union() {
			tab_socket();
			hook_positive();
		}
		hook_negative();
	}
}
if (Part == "Pin") {
}

module body() {
	// Tabs
	cylinder(d=Tab_Outer_Diameter, h=Tab_Thickness);

	// Socket
	cylinder(d=Socket_Inner_Diameter, h=Socket_Inner_Depth+Tab_Thickness);

	// Flange
	translate([0, 0, Socket_Inner_Depth+Tab_Thickness])
		cylinder(d=Flange_Outer_Diameter, h=Flange_Thickness);
}

module tab_socket() {
	translate([0, -Total_Height, Tab_Width/2])
		rotate(-90, [1,0,0])
			difference() {
				body();

				// Top
				translate([0, Flange_Outer_Diameter/2+Tab_Width/2, -1])
					cube(Flange_Outer_Diameter, center=true);

				// Bottom
				translate([0, -Flange_Outer_Diameter/2-Tab_Width/2, -1])
					cube(Flange_Outer_Diameter, center=true);
			}
}

module hook_positive() {
	// Outside
	translate([0, 0, Hook_Chamfer])
		cylinder(d=Socket_Inner_Diameter, h=Tab_Width-Hook_Chamfer*2);

	// Top chamfer
	translate([0, 0, Tab_Width-Hook_Chamfer])
		cylinder(
			d1=Socket_Inner_Diameter,
			d2=Socket_Inner_Diameter-Hook_Chamfer*2,
			h=Hook_Chamfer
		);

	// Bottom chamfer
	cylinder(
		d1=Socket_Inner_Diameter-Hook_Chamfer*2,
		d2=Socket_Inner_Diameter,
		h=Hook_Chamfer
	);
}

module hook_tip() {
	// Main round
	translate([0, 0, Hook_Chamfer])
		cylinder(d=Hook_Thickness, h=Tab_Width-Hook_Chamfer*2);

	// Top round chamfer
	translate([0, 0, Tab_Width-Hook_Chamfer])
		cylinder(
			d1=Hook_Thickness,
			d2=Hook_Thickness-Hook_Chamfer*2,
			h=Hook_Chamfer
		);

	// Bottom round chamfer
	cylinder(
		d1=Hook_Thickness-Hook_Chamfer*2,
		d2=Hook_Thickness,
		h=Hook_Chamfer
	);
}

module hook_negative() {
	// Center
	translate([0, 0, -1])
		cylinder(
			d=Socket_Inner_Diameter-Hook_Thickness*2,
			h=Tab_Width+2
		);

	// Top chamfer
	translate([0, 0, Tab_Width-Hook_Chamfer])
		cylinder(
			d1=Socket_Inner_Diameter-Hook_Thickness*2,
			d2=Socket_Inner_Diameter-Hook_Thickness*2+Hook_Chamfer*2+2,
			h=Hook_Chamfer+1
		);

	// Bottom chamfer
	translate([0, 0, -1])
		cylinder(
			d1=Socket_Inner_Diameter-Hook_Thickness*2+Hook_Chamfer*2+2,
			d2=Socket_Inner_Diameter-Hook_Thickness*2,
			h=Hook_Chamfer+1
		);

	r = Socket_Inner_Radius-Hook_Thickness/2;
	a = asin((Hook_Thickness/2) / r);
	rotate(-a, [0,0,1])
		translate([r, 0, 0]) {
			difference() {
				rotate(90, [0,0,1])
					difference() {
						cube([Hook_Thickness, Hook_Thickness, Tab_Width]);
						rotate(a-90, [0,0,1])
							cube([Hook_Thickness, Hook_Thickness, Tab_Width]);
					}
				cylinder(d=Hook_Thickness, h=Tab_Width);
			}
		}

	// Cutout
	difference() {
		// Corner
		translate([0, 0, -1])
			cube(Socket_Inner_Diameter);

		// Rounded hook tip
		translate([0, Socket_Inner_Radius-Hook_Thickness/2, 0])
			hook_tip();
	}
}
