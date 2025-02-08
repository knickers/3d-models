Inner_diameter = 10; // 0.1
Outer_diameter = 50; // 0.1
Width = 25; // 0.1
Bearing_type = "Thrust"; // ["Thrust", "Roller"]
Interior_thickness = 2; // 0.1
// Space between bearing races
Gap = 2; // 0.1
Display_part = "Thrust race"; // ["All separated", "All combined", "Roller", "Race cutout", "Thrust race", "Outer race", "Inner race"]
Cut = false; // [false, true]

$fa = $preview ? 15 : 1;
$fs = $preview ? 4 : 0.75;
root2 = sqrt(2);
inner_r = Inner_diameter / 2;
outer_r = Outer_diameter / 2;
interior = outer_r - inner_r;
diagonal = (Width < interior ? Width : interior) - Interior_thickness*2;
roller_d = diagonal / root2;
roller_r = roller_d / 2;
roller_h = roller_d - (roller_d > 6 ? 2 : 0);
echo(Roller=roller_d);

if (Cut) {
	difference() {
		draw();
		color("Red")
		translate([-Outer_diameter/2-1, -Outer_diameter/2 - 1, -1])
			cube([Outer_diameter+2, Outer_diameter/2 + 1, Width+2]);
	}
}
else {
	draw();
}

module draw() {
	if (Display_part == "All separated") {
		if (Bearing_type == "Thrust") {
			thrust_race();
			translate([Outer_diameter+10, 0, 0])
				thrust_race();
			translate([0, Outer_diameter, 0])
				simple_roller();
		}
		else if (Bearing_type == "Roller") {
			outer_race();
			translate([Outer_diameter, 0, 0])
				inner_race();
			translate([-Outer_diameter, 0, 0])
				inner_race();
			translate([0, Outer_diameter, 0])
				simple_roller();
		}
	}
	else if (Display_part == "All combined") {
		if (Bearing_type == "Thrust") {
			thrust_race();
			translate([0, 0, Width])
				rotate(180, [0,1,0])
					thrust_race();
			opposite_rollers();
		}
		else if (Bearing_type == "Roller") {
			outer_race();
			inner_race();
			translate([0, 0, Width])
				rotate(180, [0,1,0])
					inner_race();
			opposite_rollers();
		}
	}
	else if (Display_part == "Roller") {
		simple_roller();
		//roller_profile();
		//roller();
		//echo(arc(roller_r, -15, 15));
		//echo(fragments(roller_d*2, 10));
	}
	else if (Display_part == "Race cutout") { race_cutout(); }
	else if (Display_part == "Thrust race") { thrust_race(); }
	else if (Display_part == "Outer race") { outer_race(); }
	else if (Display_part == "Inner race") { inner_race(); }
}

function fragments(r, a=360) = $fn > 0
	? ($fn >= 3 ? $fn : 3)
	: ceil(max(min(a/$fa, r*2*PI/$fs), 5));

function arc(r, a1, a2) = [
	for (a = [a1:(a2-a1)/fragments(roller_d*2, (a2-a1)):a2])
		[cos(a)*r - r+roller_r, sin(a)*r]
];

module race_cutout() {
	rotate_extrude(angle=360)
		translate([inner_r + interior/2, (Width-diagonal)/2, 0])
			rotate(45, [0,0,1])
				square(roller_d);
}

module thrust_race() {
	difference() {
		cylinder(d=Outer_diameter, h=Width/2-Gap/2);
		translate([0, 0, -1])
			cylinder(d=Inner_diameter, h=Width/2+2);
		race_cutout();
	}
}

module outer_race() {
	difference() {
		cylinder(d=Outer_diameter, h=Width);
		translate([0, 0, -1])
			cylinder(d=Inner_diameter + interior + Gap/2, h=Width+2);
		race_cutout();
	}
}

module inner_race() {
	difference() {
		cylinder(d=Inner_diameter + interior - Gap/2, h=Width/2);
		translate([0, 0, -1])
			cylinder(d=Inner_diameter, h=Width+2);
		race_cutout();
	}
}

module roller_profile(chamfer=false) {
	r = roller_d * 2;
	a1 = -15;
	a2 = 15;
	begin = [];
	end = [];
	if (chamfer) {
		begin = [
			[0, 0],
			[roller_r-1, 0],
			[roller_r, 1]
		];
		end = [
			[roller_r, roller_h-1],
			[roller_r-1, roller_h],
			[0, roller_h]
		];
	}
	points = [
		for (a = [a1:(a2-a1)/fragments(roller_d*2, a2-a1):a2])
			[cos(a)*r - r+roller_r, sin(a)*r]
	];
	polygon(concat(begin, points, end));
	/*
	polygon([
		[0, 0],
		[roller_r-1, 0],
		[roller_r, 1],
		[roller_r, roller_h-1],
		[roller_r-1, roller_h],
		[0, roller_h]
	]);
	/* */
}

module roller() {
	rotate_extrude(angle=360)
		roller_profile();
}

module simple_roller(chamfer) {
	if (chamfer) {
		rotate_extrude(angle=360)
			polygon([
				[0, 0],
				[roller_r-1, 0],
				[roller_r, 1],
				[roller_r, roller_h-1],
				[roller_r-1, roller_h],
				[0, roller_h]
			]);
	}
	else {
		cylinder(d=roller_d, h=roller_h);
	}
}

module opposite_rollers() {
	z = (roller_d - roller_h)/2;
	translate([-inner_r-interior/2, 0, (Width-diagonal)/2])
		rotate(45, [0,1,0])
			translate([-roller_r, 0, z])
				simple_roller();
	translate([inner_r+interior/2, 0, (Width-diagonal)/2])
		rotate(45, [0,1,0])
			translate([-roller_r, 0, z])
				simple_roller();
}
