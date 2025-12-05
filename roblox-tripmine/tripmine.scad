Cube_Size = 100;
Tolerance = 0.1;

Diamond_Size = Cube_Size * 2 / 5; // Derived from model: * 0.399943
Bar_Size = Cube_Size / 18;        // Derived from model: * 0.0565657
Bar_Offset = Diamond_Size / 9;


/*
scale(50)
	translate([1,1,1])
		translate([-9.625, -0.125, 14.875])
			import("subspace.stl", convexity=5);
*/


module bar() {
	rotate(45, [1,0,0])
		translate([Bar_Offset, -Bar_Size/2, -Bar_Size/2])
			cube([Cube_Size-Bar_Offset*2, Bar_Size, Bar_Size]);
}

module bar_hole() {
	w = Bar_Size + Tolerance;
	rotate(45, [1,0,0])
		translate([Bar_Offset, -w/2, -w/2])
			cube([Diamond_Size, w, w]);
}

module diamond() {
	cylinder(d1=Diamond_Size, d2=0, h=Diamond_Size/2, $fn=4);

	translate([0, 0, -Diamond_Size/2])
		cylinder(d1=0, d2=Diamond_Size, h=Diamond_Size/2, $fn=4);
}

module diamond_holes() {
	bar_hole();
	rotate(90, [0, 0, 1])
		bar_hole();
	rotate(-90, [0, 1, 0])
		bar_hole();
}

translate([Diamond_Size, 0, 0])
	bar();

difference() {
	diamond();
	diamond_holes();
}
