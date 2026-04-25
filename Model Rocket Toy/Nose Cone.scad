baseDiameter = 30;
wallThickness = 1.5;
height = 60;
baseHeight = 10;

module mainShape(){
	translate ([0,0,baseHeight-0.1]) scale ([1,1,height/baseDiameter*2]) sphere (baseDiameter/2, $fn=50);
	cylinder (baseHeight,baseDiameter/2, baseDiameter/2, $fn=50);
}

module cutout(){
	difference(){
		scale ([1-wallThickness*2/baseDiameter,1-wallThickness*2/baseDiameter,height/baseDiameter*2]) sphere (baseDiameter/2, $fn=50);
		translate ([-baseDiameter/2-5,-baseDiameter/2-5,-(height+10)]) cube ([baseDiameter+10,baseDiameter+10,height+10]);
	}
translate ([-baseDiameter/2-5,-baseDiameter/2-5,-(height+10)]) cube ([baseDiameter+10,baseDiameter+10,height+10]);
	translate ([0,0,-1]) cylinder (baseHeight+2,baseDiameter/2-wallThickness, baseDiameter/2-wallThickness, $fn=50);
}

difference (){
	mainShape();
	cutout();
}
