use <spiral_extrude.scad>

Rod_Diameter = 25.5;

// Radius to center of rod
Curve_Radius = 15;

// Distance between peak and trough
Thread_Depth = 1.0; // 0.01

// Radius halfway between peak and trough
Thread_Pitch = 5; // 0.01

// (23 + Thread_Depth) / 2;
Thread_Pitch_Radius = 12; // 0.01
Thread_Inner_Radius = Thread_Pitch_Radius-Thread_Depth/2;

// Spiral vase mode wall thickness
Coupler_Wall_Thickness = 0.8; // 0.01

// Distance between mating parts
Clearance = 0.25; // 0.01

Part = "Connector"; // ["Connector", "Coupler", "Thread", "Tooth"]

$fa = $preview ? 15 : 2;
$fs = $preview ? 1.25 : 0.6; // Curve resolution

if (Part == "Connector") {
	rotate(90, [1,0,0]) {
		translate([0, 0, 10])
			thread(revolutions=4, radius_offset=-Clearance);
		cylinder(
			r=Thread_Inner_Radius-Clearance,
			h=Thread_Pitch*5 + 10 + 10
		);
	}
	translate([-Curve_Radius, 0])
		rotate_extrude(angle=90, convexity=5)
			translate([Curve_Radius, 0])
				circle(d=Rod_Diameter);

	translate([-Curve_Radius, Curve_Radius, 0])
	rotate(-90, [0,0,1])
		rotate(90, [1,0,0]) {
			thread(revolutions=4, radius_offset=-Clearance);
			cylinder(
				r=Thread_Inner_Radius-Clearance,
				h=Thread_Pitch*5
			);
		}
}
else if (Part == "Coupler") {
	revs = 4 + (40/Thread_Pitch);
	s = Thread_Pitch_Radius * 3;
	difference() {
		translate([0, 0, -Thread_Pitch])
			thread(revolutions=revs+1, radius_offset=Coupler_Wall_Thickness);
		// Top
		translate([-s/2, -s/2, Thread_Pitch*revs])
			cube([s, s, Thread_Pitch+1]);
		// Bottom
		translate([-s/2, -s/2, -Thread_Pitch-1])
			cube([s, s, Thread_Pitch+1]);
	}
	cylinder(r=Thread_Inner_Radius+Coupler_Wall_Thickness, h=Thread_Pitch*revs);
}
else if (Part == "Thread") {
	translate([0, 0, 10])
		thread(revolutions=4, radius_offset=-Clearance);
	cylinder(
		r=Thread_Inner_Radius-Clearance,
		h=Thread_Pitch*5 + 10 + 10
	);
}
else if (Part == "Tooth") {
	tooth();
}

module thread(revolutions=1, radius_offset=0) {
	translate([0, 0, Thread_Pitch/2])
		extrude_spiral(
			StartRadius=Thread_Pitch_Radius+radius_offset,
			Angle=360*revolutions,
			ZPitch=Thread_Pitch,
			StepsPerRev=fragments(Thread_Pitch_Radius)
		)
			tooth();
}

module tooth(clip=0.2) {
	x = Thread_Depth / 2;
	y = Thread_Pitch / 2;
	slope = y / Thread_Depth;
	x_offset = clip / slope;
	y_offset = clip * slope;
	polygon([
		[x-x_offset, -y_offset],
		[x-x_offset, y_offset],
		[-x, y],
		[-x, -y]
	]);
}

function fragments(r,a=360)=$fn>0?($fn>3?$fn:3):ceil(max(min(a/$fa,r*2*PI/$fs),5));
