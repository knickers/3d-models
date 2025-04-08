drawer_width_small = 150;  // 5 15/16
drawer_height_small = 58;  // 2  5/16
drawer_height_large = 141; // 5  9/16
door_width = 70; // 2 3/4
thickness = 5;
hole_distance = 95; // 3 3/4
hole_diameter = 3;
handle_overhang = 28.5;
part = "drawer base"; // ["drawer base", "drawer height spacer", "door"]

$fa = $preview ? 15 : 1;
$fs = $preview ? 3 : 0.5;

if (part == "drawer base") {
	drawer_base();
}
else if (part == "drawer height spacer") {
	drawer_height_spacer();
}
else if (part == "door") {
	door();
}

module drawer_base() {
	difference() {
		cube([drawer_width_small, drawer_height_small, thickness], center=true);
		cube([hole_diameter, drawer_height_small-thickness*2, thickness*2], center=true);
		translate([hole_distance/2, 0, 0])
			cylinder(d=hole_diameter, h=thickness+2, center=true);
		translate([-hole_distance/2, 0, 0])
			cylinder(d=hole_diameter, h=thickness+2, center=true);
	}
}

module drawer_height_spacer() {
	cube([
		drawer_width_small,
		(drawer_height_large-drawer_height_small)/2,
		thickness
	]);
}

module door() {
	height = hole_distance+door_width+handle_overhang*2;
	translate([0, 0, -thickness/2])
		linear_extrude(thickness)
			difference() {
				translate([0, -door_width/2, 0])
					square([door_width, height], center=true);
				translate([0, hole_distance/2, 0])
					circle(d=hole_diameter);
				translate([0, -hole_distance/2, 0])
					circle(d=hole_diameter);
			}
	translate([door_width/2+thickness/2, -door_width/2, 0])
		cube([thickness, height, thickness*5], center=true);
	translate([thickness/2, -height/2-door_width/2-thickness/2, 0])
		cube([door_width+thickness, thickness, thickness*5], center=true);
}
