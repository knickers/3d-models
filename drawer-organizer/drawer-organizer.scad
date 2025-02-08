Width = 250;
Length = 455;
Height = 60;
Wall_Thickness = 10;
Wall_Slope = 2;
Wall_Fillet = 4;
Floor_Thickness = 2;
Columns = 4;

$fa = $preview ? 15 : 1;
$fs = $preview ? 3 : 0.75;
column = (Width - Wall_Thickness*(Columns+1)) / Columns;
interior_length = Length - Wall_Thickness*4;
landscape_length = interior_length*1/5;
cutout_length = (interior_length*4/5) / 2;

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

module row(length) {
	translate([Wall_Thickness, Wall_Thickness, Floor_Thickness])
		for (i = [0:Columns-1]) {
			translate([Wall_Thickness*i + column*i, 0, 0])
				cutout(column, length);
		}
}

module cutout(width, length) {
	cube([width, length, Height]);
}
