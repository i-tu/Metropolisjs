void draw() {  
  textAlign(CENTER, CENTER);
  textFont(labelFont);

  background(0,0,255);

  drawScale(2400, color(0,0,80));
  drawScale(1800,  color(0,0,80));
  drawScale(1200, color(0,0,80));
  drawScale(600,  color(0,0,80));
  drawScale(300,  color(0,0,80));

//  for (int i = 0; i < places.length; i++)
//      places[i].displayText();

  if(trackMode == 1) {
    for (int i = 0; i < railTracks.length; i++)  
      railTracks[i].display();
      
    for (int i = 0; i < tramTracks.length; i++)  
      tramTracks[i].display();  
  }

  textFont(labelFont);
  
  for (int i = 0; i < places.length; i++)
      places[i].display();

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
  fill(0,0,0,5);
  stroke(c);

  if (dynamicMode == 0) { 
    return;
  }
  else if(dynamicMode == 1) {
    float scaled = d * (0.6667) * zoomAmount;

    textFont(scaleFont);

    ellipse(width/2, height/2, scaled, scaled);
    fill(0,0,0,50);
    text(str(round(d/60)) + "min.", width/2, height/2 - scaled/2 +50);
  }

  fill(0,0,0,0);
}


void drawStop(float x, float y, float w, float h) {
  x -= w/2;
  y -= h/2;
  w += 7;

  stroke(0,0,0);

  beginShape();
    vertex(-w/2, -h/2);
    vertex(-w/2+w, -h/2);
    bezierVertex(-w/2+w+h, -h/2, -w/2+w+h, -h/2+h, -w/2+w, -h/2+h);
    vertex(-w/2,-h/2+h);
    bezierVertex(-w/2-h, -h/2+h, -w/2-h, -h/2, -w/2, -h/2);
  endShape();

  noStroke();
}
