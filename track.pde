class Track
{
  String label;
  int[] stops;
  color c;
  boolean visible;
  int type;
  
  Track(String label_, int[] stops_, color c_, int type_) {
    this.label = label_;
    this.stops = stops_;
    this.c = c_;
    this.type = type_;
   
    for (int i = 0; i < stops.length; i++) {
      for(int j = 0;j < places.length; j++) {
        if(stops[i] == places[j].n) {
            places[j].tracks.add(label);
            places[j].colors.add(c);
        }
        if(this.stops[i] == -places[j].n)
          this.stops[i] = -this.stops[i];
      }  
    }
  }
  
  boolean isVisible() {
    return visible;
  }

  String getLabel() {
    return label;
  }
  
  color getColor() {
    return c;
  }
  
  void display()
  {
    boolean origoOnLine = false;
    boolean mouseOnLine = false;
     
    for (int i = 0; i < stops.length; i++) {
      if(stops[i] == places[origo].n) {
        origoOnLine = true;
        visible = true;
        break;
      }
      else visible = false;
    }

    for (int i = 0; i < stops.length;i++) {
      if (places[stops[i]].inside()) {
        mouseOnLine = true;
        break;
      }
    }
    if(!origoOnLine && !mouseOnLine) {
      return;
    }
    curveTightness(0.6);
    noFill();

    int i;
     

stroke(0,0,255);

    strokeWeight(8);
      beginShape();
        curveVertex(places[stops[0]].stopCoordsX(label), places[stops[0]].stopCoordsY(label) );
        for (i = 0; i < stops.length; i++)
          curveVertex(places[stops[i]].stopCoordsX(label), places[stops[i]].stopCoordsY(label) );
        curveVertex(places[stops[i-1]].stopCoordsX(label), places[stops[i-1]].stopCoordsY(label) );
      endShape();

    if(origoOnLine)
      stroke(c, 230);
    else 
      stroke(c, 50);

    strokeWeight(6);
      beginShape();
        curveVertex(places[stops[0]].stopCoordsX(label), places[stops[0]].stopCoordsY(label) );
        for (i = 0; i < stops.length; i++)
          curveVertex(places[stops[i]].stopCoordsX(label), places[stops[i]].stopCoordsY(label) );
        curveVertex(places[stops[i-1]].stopCoordsX(label), places[stops[i-1]].stopCoordsY(label) );
      endShape();
  
  strokeWeight(1);
  }

  // Returns direction of track through given place
  float trackDirection(int placeID) {
    int i;
    for(i = 0;i<stops.length-1;i++) {
      if(stops[i] == placeID)
        break;
    }    
    if(i == 0) {
      return atan((places[stops[0]].getX() - places[stops[1]].getX())/
                  (places[stops[0]].getY() - places[stops[1]].getY()));
    }
    else if(i == stops.length -1) {
      return atan((places[stops[stops.length-2]].getX() - places[stops[stops.length-1]].getX()) /
                  (places[stops[stops.length-2]].getY() - places[stops[stops.length-1]].getY()) );
    }
    else {
      return
             atan( (places[stops[i-1]].getX() - places[stops[i+1]].getX()) /
                   (places[stops[i-1]].getY() - places[stops[i+1]].getY() + 0.00001) );
    }
  }


  float getColor(int placeID, String trackID) {
    for(int i = 0; i < railTracks.length; i++)
      if(railTracks[i].label.equals(trackID))
        return railTracks[i].getColor();
    return 0;
  }

}
