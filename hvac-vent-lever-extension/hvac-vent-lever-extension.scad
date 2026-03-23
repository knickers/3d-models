Arm_Length = 6.5; // 0.1
Arm_Width = 10; // 0.1
Arm_Thickness = 1; // 0.1
Tab_Length = 4.0; // 0.1
Tab_Angle = 20; // 0.1
Extension_Length = 25; // 0.1
Extension_Width = 15; // 0.1
Extension_Thickness = 3; // 0.1

$fa = $preview ? 10 : 2;
$fs = $preview ? 0.5 : 0.1;

module line(start, end, thickness = 1) {
	hull() {
		translate(start)
			if ($children > 0)
				children(0);
			else
				square(thickness, center=true);
		translate(end)
			if ($children > 1)
				children(1);
			else if ($children > 0)
				children(0);
			else
				square(thickness, center=true);
	}
}

translate([0, 0, Extension_Width])
	rotate(180, [1, 0, 0])
		difference() {
			linear_extrude(Extension_Width) {
				line([0,0], [Arm_Length, 0]) {
					square(Extension_Thickness, center=true);
					circle(d=Extension_Thickness);
				}

				translate([Arm_Length, 0, 0])
					rotate(-Tab_Angle, [0,0,1])
						line([0,0], [Extension_Length, 0]) {
							circle(d=Extension_Thickness);
							square(Extension_Thickness, center=true);
						}
			}
			translate([0, 0, -1])
				linear_extrude(Arm_Width+1) {
					line([0,0], [Arm_Length, 0]) {
						square(Arm_Thickness, center=true);
						circle(d=Arm_Thickness);
					}

					translate([Arm_Length, 0, 0])
						rotate(-Tab_Angle, [0,0,1])
							line([0,0], [Tab_Length, 0]) {
								circle(d=Arm_Thickness);
								square(Arm_Thickness, center=true);
							}
				}
		}
