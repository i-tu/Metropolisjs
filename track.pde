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
        break;
      }
    }

    for (int i = 0; i < stops.length;i++) {
      if (places[stops[i]].inside()) {
        mouseOnLine = true;
        break;
      }
    }

    if(!origoOnLine && !mouseOnLine)
      return;

    if(origoOnLine)
      stroke(0);
    else
      stroke(0, 50);
  
    curveTightness(0.2);
    noFill();

    int i;
    if(type == 0)
    {
      strokeWeight(6);

      beginShape();
        curveVertex(places[stops[0]].stopCoordsX(label), places[stops[0]].stopCoordsY(label) );
        for (i = 0; i < stops.length; i++)
          curveVertex(places[stops[i]].stopCoordsX(label) , places[stops[i]].stopCoordsY(label) );
        curveVertex(places[stops[i-1]].stopCoordsX(label) , places[stops[i-1]].stopCoordsY(label) );
      endShape();
      
      if(origoOnLine)
        stroke(c);
      else
        stroke(c, 50);
        
      strokeWeight(4);
          
      beginShape();
        curveVertex(places[stops[0]].stopCoordsX(label), places[stops[0]].stopCoordsY(label) );
        for (i = 0; i < stops.length; i++)
          curveVertex(places[stops[i]].stopCoordsX(label), places[stops[i]].stopCoordsY(label) );
        curveVertex(places[stops[i-1]].stopCoordsX(label), places[stops[i-1]].stopCoordsY(label) );
      endShape();
    
  } 
  else if (type == 1)
  {
    strokeWeight(4);

    beginShape();
      curveVertex(places[stops[0]].tramStopCoordsX(label), places[stops[0]].tramStopCoordsY(label) );
      for (i = 0; i < stops.length; i++)
        curveVertex(places[stops[i]].tramStopCoordsX(label) , places[stops[i]].tramStopCoordsY(label) );
      curveVertex(places[stops[i-1]].tramStopCoordsX(label) , places[stops[i-1]].tramStopCoordsY(label) );
    endShape();
      
    if(origoOnLine)
      stroke(c);
    else 
      stroke(c, 50);
      
    strokeWeight(3);
          
    beginShape();
      curveVertex(places[stops[0]].tramStopCoordsX(label), places[stops[0]].tramStopCoordsY(label) );
      for (i = 0; i < stops.length; i++)
        curveVertex(places[stops[i]].tramStopCoordsX(label), places[stops[i]].tramStopCoordsY(label) );
      curveVertex(places[stops[i-1]].tramStopCoordsX(label), places[stops[i-1]].tramStopCoordsY(label) );
    endShape();
  }
  
  strokeWeight(1);
  }


  // Returns direction of track through given place
  float trackDirection(int placeID) {

    int i;
    for(i = 0;i<stops.length-1;i++) {
      if(stops[i] == placeID)
        break;
    }    
    if(i==0) {
      return atan((places[stops[0]].getX() - places[stops[1]].getX())/
                  (places[stops[0]].getY() - places[stops[1]].getY()));
    }
    else if(i == stops.length -1) {
      return atan((places[stops[stops.length-2]].getX() - places[stops[stops.length-1]].getX()) /
                  (places[stops[stops.length-2]].getY() - places[stops[stops.length-1]].getY() + 0.1) );
    }
    else {
      return (
             atan( (places[stops[i]].getX() - places[stops[i+1]].getX()) /
                   (places[stops[i]].getY() - places[stops[i+1]].getY()) )
             +
             atan( (places[stops[i]].getX() - places[stops[i-1]].getX()) /
                   (places[stops[i]].getY() - places[stops[i-1]].getY()) )
             ) / 2;
    }
  }


  float getColor(int placeID, String trackID) {
    for(int i = 0; i < railTracks.length; i++)
      if(railTracks[i].label.equals(trackID))
        return railTracks[i].getColor();
    return 0;
  }

}