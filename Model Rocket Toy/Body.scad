diameter = 30;
wallThickness = 1.5;
height = 80;
interlockHeight = 8;
interlockOD = diameter-3;

module mainShape(){
	
	cylinder (height, diameter/2, diameter/2, $fn=50);
	translate ([0,0,height]) cylinder (interlockHeight, interlockOD/2, interlockOD/2, $fn=50);
}

module cutout(){
	translate ([0,0,-1]) cylinder (height-4, diameter/2-wallThickness, diameter/2-wallThickness, $fn=50);
	translate ([0,0,height-6]) cylinder (interlockHeight+7, interlockOD/2-wallThickness, interlockOD/2-wallThickness, $fn=50);
}

difference (){
	mainShape();
	cutout();
}
