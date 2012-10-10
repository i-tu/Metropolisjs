Place[] places;
Track[] railTracks;
Track[] tramTracks;
int[][] distanceMatrix;
Button geoButton;
Button timeButton;
Button plusButton;
Button minusButton;

float zoomAmount = 1;

int origo;
boolean origo_more;

float TIME_CONSTANT = 0.5;
float fr          = 24;

color bg1         = color(241, 239, 221);
color bg2         = color(223, 221, 217);
color transparent = color(255, 255, 255, 0);
color banner      = color(165, 191, 221);
color yellow      = color(255, 204, 0);

int movedFrames   = -1;
int mode;

PFont labelFont;
PFont titleFont;

PShape geoShape;
PShape timeShape;
PShape plusShape;
PShape minusShape;

void setup()
{
  background(255,0,0);
  size(1000, 800);

  // Load text data
  String[] railStops = loadStrings("data/stops_rail.txt");
  String[] tramStops = loadStrings("data/stops_tram.txt");
  
  String[] railTrackData = loadStrings("data/lines_rail.txt");
  String[] tramTrackData = loadStrings("data/lines_tram.txt");
  String[] distMatrix = loadStrings("data/distance_matrix.txt");
  int n_places = distMatrix.length;

  // Load Place data
  places = new Place[railStops.length + tramStops.length];

  // - Rails
  for (int i = 0; i < railStops.length; i++) {
    String[] pieces = split(railStops[i], ' ');
    places[i] = new Place(pieces[0], int(pieces[1]), int( pieces[2]), i, 0);
  }
  
  // - Trams
  for (int i = railStops.length; i < railStops.length + tramStops.length; i++) {
    String[] pieces = split(tramStops[i - railStops.length], '\t');
    places[i] = new Place(pieces[1], int(pieces[2]), int( pieces[3]), i, int(pieces[0]));
  }
  
  // Load distance data
  distanceMatrix = new int[n_places][n_places];
  
  for(int i = 0; i < n_places; i++) {
    String[] pieces = split(distMatrix[i], ' ');

    for(int j = 0;j < pieces.length;j++) {
      if(i == j)
        distanceMatrix[i][j] = 0;
      else
        distanceMatrix[i][j] = distanceMatrix[j][i] = int(pieces[j]);
    }
  }
      
  // Load tram data
  tramTracks = new Track[tramTrackData.length];
  
  for (int i = 0; i < tramTrackData.length; i++) {
    String[] pieces = split(tramTrackData[i], ' ');
    int[] stopNumbers = new int[pieces.length-4];
      
    for(int j = 4;j < pieces.length;j++)
      stopNumbers[j-4] = int(pieces[j])-1;
    
    tramTracks[i] = new Track(pieces[0], stopNumbers, color(int(pieces[1]), int(pieces[2]), int(pieces[3])),1);
  }
  
  // Load track data  
  railTracks = new Track[railTrackData.length];
   
  for (int i = 0; i < railTrackData.length; i++) {
    String[] pieces = split(railTrackData[i], ' ');
    int[] stopNumbers = new int[pieces.length-4];
      
    for(int j = 4;j < pieces.length;j++) {
      if(int(pieces[j])>0)
        stopNumbers[j-4] = int(pieces[j])-1;
      else
        stopNumbers[j-4] = int(pieces[j])+1;
    }

    railTracks[i] = new Track(pieces[0], stopNumbers, color(int(pieces[1]), int(pieces[2]), int(pieces[3])),0);
  }
  
  origo = 0;  
  for (int i = 0; i < places.length; i++)
    places[i].calculate_location();
  places[0].calculate_location();
    
  labelFont = createFont("Helvetica", 12);
  titleFont = createFont("Helvetica", 20);
  textFont(labelFont);

  timeShape = loadShape("svg/time.svg");
  geoShape = loadShape("svg/geo.svg");
  plusShape = loadShape("svg/plus.svg");
  minusShape = loadShape("svg/minus.svg");
  
  timeButton = new Button(50, height-50, 48, 48, timeShape, false);
  geoButton = new Button(115, height-50, 48, 48, geoShape, true);
  plusButton = new Button(width - 50, height - 50, 48, 48, plusShape, false);
  minusButton = new Button(width - 115, height - 50, 48, 48, minusShape, false);
  

  frameRate(fr);
  smooth();
  background(bg1);
}

float zoomX(float coordinate) {
  return ((coordinate-width /2) * zoomAmount) + width /2;
}

float zoomY(float coordinate) {
  return ((coordinate-height/2) * zoomAmount) + height/2;
}

void switch_origo(int new_origo) {
  origo = new_origo;
  places[origo].calculate_location();
  
  for (int i = 0; i < places.length; i++)
    if(i != origo)
      places[i].calculate_location();
      
  movedFrames = 1; // Start frame moving counter.
}

void mousePressed() {
  for (int i = 0; i < places.length; i++) {
    if(places[i].inside()) {
      switch_origo(i);
      break;
    }
  }

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



