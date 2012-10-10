void draw()
{
  background(bg1);
  fill(255,255,255,0);
  
  textAlign(CENTER, CENTER);
  textFont(labelFont);
  
  fill(0);
  text(int(frameRate),20,60);
  
  for (int i = 0; i < railTracks.length; i++)  
    railTracks[i].display();
    
  for (int i = 0; i < tramTracks.length; i++)  
    tramTracks[i].display();  
   
  for (int i = 0; i < places.length; i++)
    if(i != origo)
      places[i].display();
  places[origo].display();

  if(movedFrames >= 0) { // Asking if counter started
    for (int i = 0; i < places.length; i++) {
      if(movedFrames <= fr*TIME_CONSTANT/2)
        places[i].update(1);
      else if(movedFrames > fr*TIME_CONSTANT/2)
        places[i].update(-1);
    }
    movedFrames++;
    if(movedFrames > fr*TIME_CONSTANT)
      movedFrames = -1;
  }
    
  fill(255,255,255,0);
  stroke(100);

  timeButton.display();
  geoButton.display();
  minusButton.display();
  plusButton.display();
  fill(0);
  
  textFont(titleFont);
  textAlign(LEFT, CENTER);

  if(mode==0)
      text("Helsinki metropolitan area geographical distances", 175, height-55);
  else
      text("Helsinki metropolitan area travel times", 175, height-55);

}

void drawScale(float d) {
  textAlign(CENTER, CENTER);
  
  if (mode == 0) { 
    float scaled = (d/10) * zoomAmount;
    stroke(0);
    fill(transparent);
    ellipse(width/2, height/2, scaled, scaled);
    stroke(bg1);
    fill(bg2);
    rect(width/2, height/2 - scaled/2, 50, 10);
    fill(0);

    if(d > 2000)
      text(str(round(d/1000)) + " km", width/2, height/2 - scaled/2);
    else
      text(str(round(d)) + " m", width/2, height/2 - scaled/2);

   }
   else if(mode == 1)
   {
    float scaled = d * (0.6667) * zoomAmount;
    stroke(0);
    fill(transparent);
    ellipse(width/2, height/2, scaled, scaled);
    stroke(bg);
    fill(bg);
    rect(width/2, height/2 - scaled/2, 50, 10);
    fill(0);
    text(str(round(d/60)) + " min", width/2, height/2 - scaled/2);
  }
}


void drawStop(float x, float y, float w, float h, float angle) {
  fill(255);
  x -= w/2;
  y -= h/2;

  beginShape();
    vertex(-w/2, -h/2);
    vertex(-w/2+w, -h/2);
    bezierVertex(-w/2+w+h, -h/2, -w/2+w+h, -h/2+h, -w/2+w, -h/2+h);
    vertex(-w/2,-h/2+h);
    bezierVertex(-w/2-h, -h/2+h, -w/2-h, -h/2, -w/2, -h/2);
  endShape();
}


float globeScale(float x)
{
  float D = 10000; // We are watching the globe from 10km away
  float R = 5000; // The globe has a radius of 50000 km

  return (sin(x/R)*R*D)/(D+R+cos(x/R)*R);
}