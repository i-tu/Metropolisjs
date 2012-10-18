class Sidebar {

	Sidebar() {
		timeShape = loadShape("svg/time.svg");
		geoShape = loadShape("svg/geo.svg");
		plusShape = loadShape("svg/plus.svg");
  		minusShape = loadShape("svg/minus.svg");

		timeButton = new Button(50, height-50, 48, 48, timeShape, true);
		geoButton = new Button(50, height-100, 48, 48, geoShape, false);
		plusButton = new Button(50, 50, 48, 48, plusShape, false);
		minusButton = new Button(50, 100, 48, 48, minusShape, false);
	}

	void display() {
		fill(0,0,0,30);
		rect(0,0,200,height*2);
  		timeButton.display();
  		geoButton.display();
  		minusButton.display();
  		plusButton.display();
	}

	void mousePress() {

	  if(timeButton.inside() && !timeButton.isToggled()) {
	    timeButton.toggle();
	    geoButton.toggle();
	    mode = 1;
	    switch_origo(origo); // Essentially, refresh.
	  }
	  else if(geoButton.inside() && !geoButton.isToggled())
	  {
	    timeButton.toggle();
	    geoButton.toggle();
	    mode = 0;
	    switch_origo(origo);
	  }
	  else if(plusButton.inside())
	  {
	    zoomAmount *= 1.5;
	    if(zoomAmount > 5)
	      zoomAmount = 5;
	  }
	  else if(minusButton.inside())
	  {
	    zoomAmount /= 1.5;
	    if(zoomAmount < 0.5)
	      zoomAmount = 0.5;
	  }

	}

}