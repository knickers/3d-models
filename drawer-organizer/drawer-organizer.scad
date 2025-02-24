Width = 250;
Length = 455;
Height = 60;
Wall_Thickness = 10;
Wall_Slope = 4;
Wall_Fillet = 4;
Floor_Thickness = 2;
Columns = 4;

column = (Width - Wall_Thickness*(Columns+1)) / Columns;
interior_length = Length - Wall_Thickness*4;
landscape_length = interior_length*1/5;
cutout_length = (interior_length*4/5) / 2;
cutout_height = Height - Floor_Thickness;
slope_o = sin(Wall_Slope) * 0;
slope_h = 0;

/* soh cah toa
|\
| \
|__\
sin(a) = w / hyp
sin(a)*hyp = w

tan(a) = slope_o / cutout_height
*/

$fa = $preview ? 15 : 1;
$fs = $preview ? 3 : 0.75;

tray();
//cutout(column, cutout_length);
//slice(column);

module tray() {
	difference() {
		cube([Width, Length, Height]);
		translate([Wall_Thickness, Wall_Thickness, Floor_Thickness])
			cutout(Width-Wall_Thickness*2, landscape_length);
		translate([0, landscape_length+Wall_Thickness, 0]) {
			row(cutout_length);
			translate([0, cutout_length+Wall_Thickness, 0])
				row(cutout_length);
		}
	}
}

module row(length) {
	translate([Wall_Thickness, Wall_Thickness, Floor_Thickness])
		for (i = [0:Columns-1]) {
			translate([Wall_Thickness*i + column*i, 0, 0])
				cutout(column, length);
		}
}

module cutout(width, length) {
	/* */
	cube([width, length, Height]);
	/* */
	/* * /
	if ($preview)
		#cube([width, length, Height]);
	/* */
	/* * /
	h = Height-Wall_Fillet;
	for (x = [0:1])
		for (y = [0:1])
			translate([
				x*(width-Wall_Fillet*2)+Wall_Fillet,
				y*(length-Wall_Fillet*2)+Wall_Fillet,
				h+Wall_Fillet
			])
				rotate(-(y*2-1)*Wall_Slope, [1,0,0])
					rotate((x*2-1)*Wall_Slope, [0,1,0])
						translate([0, 0, -h]) {
							cylinder(r=Wall_Fillet, h=h);
							sphere(r=Wall_Fillet);
						}
						//cylinder(r=Wall_Fillet, h=)
	/* */
	/* * /
	translate([0, Wall_Fillet, h+Wall_Fillet])
		rotate(-Wall_Slope, [0,1,0])
			translate([0, 0, -h])
				cube([width*0.6, length-Wall_Fillet*2, h]);
	intersection() {
		rotate(90, [1,0,0])
			translate([0, Height, -length])
				linear_extrude(length)
					slice(width);
		rotate(90, [0,0,1])
			rotate(90, [1,0,0])
				translate([0, Height, 0])
					linear_extrude(width)
						slice(length);
	}
	cutter();
	/* */
}

module slice(width) {
	hull() {
		translate([-Wall_Fillet, 0, 0])
			rotate(Wall_Slope, [0,0,1])
				translate([Wall_Fillet, Wall_Fillet-Height, 0]) {
					square([width*.6, Height-Wall_Fillet]);
					translate([Wall_Fillet, 0, 0])
						circle(r=Wall_Fillet);
				}
		translate([Wall_Fillet+width, 0, 0])
			rotate(-Wall_Slope, [0,0,1])
				translate([-Wall_Fillet, Wall_Fillet-Height, 0]) {
					translate([-width*.6, 0, 0])
						square([width*.6, Height-Wall_Fillet]);
					translate([-Wall_Fillet, 0, 0])
						circle(r=Wall_Fillet);
				}
	}
}

module cutter() {
	translate([0, 0, Height])
		rotate(Wall_Slope, [1,0,0])
			rotate(-Wall_Slope, [0,1,0])
				rotate(180, [0,0,1])
					translate([0, 0, -Height-Wall_Fillet])
						difference() {
							translate([0, 0, -Wall_Fillet])
							cube([Wall_Fillet+1, Wall_Fillet, Height+Wall_Fillet]);
							union() {
								cylinder(r=Wall_Fillet, h=Height);
								sphere(r=Wall_Fillet);
							}
						}
}
