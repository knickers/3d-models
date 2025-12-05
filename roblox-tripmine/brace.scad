Tripmine_Cube_Size = 100; // 0.01
Tolerance = 0.2; // 0.01
Brace_Offset = 0; // 0.01
Brace_Thickness = 1; // 0.01
Brace_Width = 4; // 0.01
Center_Punch_Size = 2; // 0.01
Clip_Finger_Length = 1.5; // 0.01

SQRT2 = sqrt(2);
Finger_Cutout = (Brace_Thickness + Clip_Finger_Length) * SQRT2;
Bar_Size = Tripmine_Cube_Size / 18;
Bar_ID = Bar_Size + Tolerance;
Bar_OD = Bar_Size + Brace_Thickness*2 + Tolerance;
Brace_Extension = Brace_Offset + Brace_Thickness/2 > Bar_OD / 2 * SQRT2
	? Brace_Offset + Brace_Thickness/3 - Bar_ID/2 * SQRT2
	: 0;

module rotated_box(offsetXY = 0, offsetZ = 0) {
	translate([0, 0, Brace_Width/2])
		rotate(45, [0,0,1])
			cube([Bar_Size+offsetXY, Bar_Size+offsetXY, Brace_Width+offsetZ], center=true);
}

difference() {
	union() {
		rotated_box(offsetXY=Brace_Thickness*2+Tolerance); //  Left clip body
		translate([Tripmine_Cube_Size-Tolerance, 0, 0])
			rotated_box(offsetXY=Brace_Thickness*2+Tolerance); // Right clip body
		translate([0, Brace_Offset-Brace_Thickness/2, 0])
			cube([Tripmine_Cube_Size-Tolerance, Brace_Thickness, Brace_Width]); // Main brace body
		if (Brace_Extension > 0) {
			translate([0, Brace_Offset+Brace_Thickness/2-Brace_Extension, 0]) {
				cube([Brace_Thickness, Brace_Extension, Brace_Width]); // Left brace extension
				translate([Tripmine_Cube_Size-Tolerance-Brace_Thickness, 0, 0])
					cube([Brace_Thickness, Brace_Extension, Brace_Width]); // Right brace extension
			}
		}
	}

	rotated_box(offsetXY=Tolerance, offsetZ=2); // Left hole
	translate([0, -Finger_Cutout, 0])
		rotated_box(offsetXY=Brace_Thickness*2, offsetZ=1); // Left finger cutout

	translate([Tripmine_Cube_Size-Tolerance, 0, 0]) {
		rotated_box(offsetXY=Tolerance, offsetZ=1); // Right hole
		translate([0, -Finger_Cutout, 0])
			rotated_box(offsetXY=Brace_Thickness*2, offsetZ=1); // Right finger cutout
	}

	translate([(Tripmine_Cube_Size-Tolerance)/2, Brace_Offset-Brace_Thickness/2-1, Brace_Width/2])
		rotate(-90, [1,0,0])
			cylinder(d=Center_Punch_Size, h=Brace_Thickness+2, $fn=4); // Center punch
}
