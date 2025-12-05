Cube_Size = 100;
Tolerance = 0.2;
Wall_Size = 1;
Brace_Width = 4;
Center_Punch_Size = 2;

Bar_Size = Cube_Size / 18;
Cutout_Offset = Bar_Size * 0.25;

module rotated_box(offsetXY = 0, offsetZ = 0) {
	translate([0, 0, Brace_Width/2])
		rotate(45, [0,0,1])
			cube([Bar_Size+offsetXY, Bar_Size+offsetXY, Brace_Width+offsetZ], center=true);
}

difference() {
	union() {
		rotated_box(offsetXY=Wall_Size*2+Tolerance); //  Left Clip body
		translate([Cube_Size-Tolerance, 0, 0])
			rotated_box(offsetXY=Wall_Size*2+Tolerance); // Right clip body
		translate([0, -Wall_Size-Cutout_Offset, 0])
			cube([Cube_Size-Tolerance, Wall_Size, Brace_Width]); // Main brace body
	}

	rotated_box(offsetXY=Tolerance, offsetZ=2); // Left hole
	translate([Wall_Size-Cutout_Offset, -Cutout_Offset-Wall_Size*3, 0])
		rotated_box(offsetXY=Wall_Size*2, offsetZ=1); // Left cutout

	translate([Cube_Size-Tolerance, 0, 0])
		rotated_box(offsetXY=Tolerance, offsetZ=1); // Right hole
	translate([Cube_Size+Cutout_Offset-Wall_Size-Tolerance, -Cutout_Offset-Wall_Size*3, 0])
		rotated_box(offsetXY=Wall_Size*2, offsetZ=1); // Right cutout

	translate([(Cube_Size-Tolerance)/2, -Cutout_Offset-Wall_Size-1, Brace_Width/2])
		rotate(-90, [1,0,0])
			cylinder(d=Center_Punch_Size, h=Wall_Size+2, $fn=4); // Center punch
}
