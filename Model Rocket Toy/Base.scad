diameter = 30;
wallThickness = 2.5;
height = 60;
interlockHeight = 8;
interlockOD = diameter-3;
finMinHeight = 20;
finMaxHeight = 55;
finLength = 40;
finThickness = 4;
bottomThickness = 3;


module mainShape(){
	cylinder (height, diameter/2, diameter/2, $fn=50);
	translate ([0,0,height]) cylinder (interlockHeight, interlockOD/2, interlockOD/2, $fn=50);
}

module cutout(){
	translate ([0,0,-1+bottomThickness]) cylinder (height-1-bottomThickness, diameter/2-wallThickness, diameter/2-wallThickness, $fn=50);
	translate ([0,0,height-3]) cylinder (interlockHeight+14, interlockOD/2-wallThickness, interlockOD/2-wallThickness, $fn=50);
}

module fins(){
	for(i=[0:3]){
		rotate ([0,0,i*90]) translate ([diameter/2-1, finThickness/2]) rotate ([90,0]) linear_extrude(height = finThickness) polygon (points=[[0,0], [finLength,0], [finLength, finMinHeight], [0,finMaxHeight]], paths=[[0,1,2,3]]);
	}
}

rotate ([0,0,45]){
	difference (){
		mainShape();
		cutout();
	}
	fins();
}
