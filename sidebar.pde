class Sidebar {
	Button geoButton;
	Button timeButton;
	Button plusButton;
	Button minusButton;
	Button trackButton;

	PShape geoShape;
	PShape timeShape;
	PShape plusShape;
	PShape minusShape;
	PShape trackShape;

	Sidebar() {
		timeShape = loadShape("svg/time.svg");
		geoShape = loadShape("svg/geo.svg");
		plusShape = loadShape("svg/plus.svg");
  		minusShape = loadShape("svg/minus.svg");
  		trackShape = loadShape("svg/track.svg");

		timeButton = new Button(50, height-35, 55, 55, timeShape, true);
		geoButton = new Button(150, height-35, 48, 48, geoShape, false);
		plusButton = new Button(width-150, height-35, 48, 48, plusShape, false);
		minusButton = new Button(width-50, height-35, 48, 48, minusShape, false);
		trackButton = new Button(250, height-35, 48, 48, trackShape, true);
	}

	void display() {

		rectMode(CENTER);
		fill(0);

		if(trackMode == 1) {
			String last = "";
			int skipped = 0;
			for(int i = 0; i < places[origo].tracks.size(); i++) {
				if(last.equals((String) places[origo].tracks.get(i))){
					skipped++;
					continue;
				}

				fill(0,0,0,30);
				fill((Integer) places[origo].colors.get(i));
				ellipse(100, 150 + (i-skipped)*60, 50, 50);
				fill(0,0,100);
				textFont(lineFont);
				textAlign(CENTER, CENTER);
				text((String) places[origo].tracks.get(i), 100, 142 + (i-skipped)*60);
				last = (String) places[origo].tracks.get(i);
				textFont(titleFont);
			}
		}


		fill(0,0,100,200);
		rectMode(CORNERS);
		rect(0,height-70,width,height);
		stroke(0,0,0);
		line(20, height-70, width-20, height-70);
		noStroke();

  		timeButton.display();
  		geoButton.display();
  		minusButton.display();
  		plusButton.display();
  		trackButton.display();
  		fill(0);

    textFont(titleFont);
    textAlign(CENTER,CENTER);
    if(dynamicMode == 1)
      text("Temporaalinen raideliikennekartta: " + places[origo].name, width/2+50, height-38);
    else text("Spatiaalinen raideliikennekartta: " + places[origo].name, width/2+50, height-38);
    
	}

	void mousePress() {

	  if(timeButton.inside() && !timeButton.isToggled()) {
	    timeButton.toggle();
	    geoButton.toggle();
	    dynamicMode = 1;
	    switch_origo(origo); // Essentially, refresh.
	  }
	  else if(geoButton.inside() && !geoButton.isToggled()) {
	    timeButton.toggle();
	    geoButton.toggle();
	    dynamicMode = 0;
	    switch_origo(origo);
	  }
	  if(trackButton.inside()) {
	    trackButton.toggle();
	    
	    if(trackMode == 1)
	    	trackMode = 0;
	   	else
	   		trackMode = 1;
	  }
	  else if(plusButton.inside()) {
	    zoomAmount *= 1.5;
	    if(zoomAmount > 5)
	      zoomAmount = 5;
	  }
	  else if(minusButton.inside()) {
	    zoomAmount /= 1.5;
	    if(zoomAmount < 0.5)
	      zoomAmount = 0.5;
	  }
	}
}
