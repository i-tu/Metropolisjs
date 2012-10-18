Place[] places;
Track[] railTracks;
Track[] tramTracks;
int[][] distanceMatrix;
Button geoButton;
Button timeButton;
Button plusButton;
Button minusButton;

Sidebar sidebar;

float zoomAmount = 1;

int origo = 1;
boolean origo_more;

float TIME_CONSTANT = 0.5;
float fr          = 24;

color bg1         = color(125, 125, 125);
color bg2         = color(223, 221, 217);
color transparent = color(255, 255, 255, 0);
color banner      = color(165, 191, 221);
color yellow      = color(255, 204, 0);

int movedFrames   = -1;
int mode = 1;

PFont labelFont;
PFont titleFont;
PFont scaleFont;

PShape geoShape;
PShape timeShape;
PShape plusShape;
PShape minusShape;

void setup() {

  size(1200, 1000);
  
  String[] railStops = loadStrings("data/stops_rail.txt");
  String[] tramStops = loadStrings("data/stops_tram.txt");
  String[] railTrackData = loadStrings("data/lines_rail.txt");
  String[] tramTrackData = loadStrings("data/lines_tram.txt");
  String[] distMatrix = loadStrings("data/distance_matrix.txt");

  int n_places = distMatrix.length;

  places = new Place[railStops.length + tramStops.length];

  for (int i = 0; i < railStops.length; i++) {
    String[] pieces = split(railStops[i], ' ');
    places[i] = new Place(pieces[0], int(pieces[1]), int( pieces[2]), i, 0);
  }
  
  for (int i = railStops.length; i < railStops.length + tramStops.length; i++) {
    String[] pieces = split(tramStops[i - railStops.length], '\t');
    places[i] = new Place(pieces[1], int(pieces[2]), int( pieces[3]), i, int(pieces[0]));
  }
  
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
      
  tramTracks = new Track[tramTrackData.length];
  
  for (int i = 0; i < tramTrackData.length; i++) {
    String[] pieces = split(tramTrackData[i], ' ');
    int[] stopNumbers = new int[pieces.length-4];
      
    for(int j = 4;j < pieces.length;j++)
      stopNumbers[j-4] = int(pieces[j])-1;
    
    tramTracks[i] = new Track(pieces[0], stopNumbers, color(int(pieces[1]), int(pieces[2]), int(pieces[3])),1);
  }
  
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
  
  
  for (int i = 0; i < places.length; i++)
    places[i].calculate_location();
  places[origo].calculate_location();
    
  labelFont = createFont("Helvetica", 12);
  titleFont = createFont("Helvetica", 20);
  scaleFont = createFont("Helvetica", 72);

  textFont(labelFont);

  sidebar = new Sidebar();

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

  sidebar.mousePress();
}

