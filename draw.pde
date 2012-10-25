void draw()
{  
  textAlign(CENTER, CENTER);
  textFont(labelFont);

  for(int i = 3600; i > 0; i -= 600) {
    drawScale(i, color(0, 0, i*10));
  }

  if(trackMode == 1) {
    for (int i = 0; i < railTracks.length; i++)  
      railTracks[i].display();
      
    for (int i = 0; i < tramTracks.length; i++)  
      tramTracks[i].display();  
  }

  textFont(labelFont);
  
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
  
  sidebar.display();
  
  textFont(titleFont);
  textAlign(LEFT, CENTER);
}

void drawScale(float d, color c) {

  textAlign(CENTER, CENTER);
  
  if (mode == 0) { 
    float scaled = (d) * zoomAmount;
    fill(c);
    ellipse(width/2, height/2, scaled, scaled);

    if(d > 2000)
      text(str(round(d/1000)) + " km", width/2, height/2 - scaled/2);
    else
      text(str(round(d)) + " m", width/2, height/2 - scaled/2);

   }

   else if(mode == 1) {
    float scaled = d * (0.6667) * zoomAmount;

    stroke(c);
    fill(c);
    textFont(scaleFont);

    ellipse(width/2, height/2, scaled, scaled);
    text(str(round(d/60)), width/2, height/2 - scaled/2 - 15);
  }
}


void drawStop(float x, float y, float w, float h) {
  x -= w/2;
  y -= h/2;
  w += 7;

noStroke();

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