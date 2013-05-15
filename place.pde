class Place
{
  String name;
  int n;
  int stopNumber;
  
  int city;
  
  ArrayList tracks;
  ArrayList colors;
  
  int x;
  int y;
  
  float x_actual;
  float y_actual;
  
  float dir;

  float x_ref;
  float y_ref;
  float angle_ref;
    
  float v_x;
  float v_y;
  
  float a_x;
  float a_y;
  
  // The Constructor
  Place(String name_, int x_, int y_, int n_, int stopNumber_)  {
    this.name = name_;
    this.x = x_;
    this.y = y_;
    this.n = n_;
    this.stopNumber = stopNumber_;
    this.tracks = new ArrayList<String>();
    this.colors = new ArrayList<Integer>();
  }
  
  void print() {
    println(
    "I am " + getName() + " at coords (" + str(getX()) + ", " + str(getY()) + "). "+ '\n' +
    "Screen coordinates: (" + str(x_actual) + ", " + str(y_actual) + "). angle: " + str(angle_ref) + '\n' +
    "My ID is: " + str(n) + '\n'
    );
    return;
  }
  
  String getName () { return name; }
  int getX() { return x; }
  int getY() { return y; }
  float getAX() { return x_actual; }
  float getAY() { return y_actual; }
  
  boolean inside() {
    if(dist(zoomX(x_actual),zoomY(y_actual),mouseX,mouseY)<15) return true;
    else return false;
  }

  boolean onScreen() {
    if(zoomX(x_actual) > width || (zoomY(y_actual) > height) || zoomX(x_actual) < 0 || zoomY(y_actual) < 0)
      return false;
    return true;

  }
  
  void update(int accel_direction) { // -1, 0, tai 1
    v_x += accel_direction*a_x;
    v_y += accel_direction*a_y;  
    x_actual += v_x;
    y_actual += v_y;
  }
  
  void calculate_location() {
    x_ref = x - places[origo].getX();
    y_ref = y - places[origo].getY();
    if(x_ref==0 && y_ref==0) {
      x_ref = width/2;
      y_ref = height/2;
    }
    else {
      angle_ref = atan2( (places[origo].getY()-getY()), (places[origo].getX()-getX()) );
      
      float radius = sqrt(x_ref*x_ref+y_ref*y_ref);

      if(mode == 0) {
        x_ref = width/2  - cos(angle_ref) * radius / 20;
        y_ref = height/2 + sin(angle_ref) * radius / 20;
      }
      else if (mode==1)
      {
        x_ref = width/2  - cos(angle_ref) * distanceMatrix[n][origo] / 3;
        y_ref = height/2 + sin(angle_ref) * distanceMatrix[n][origo] / 3;
      }
      if(x_actual == 0 && y_actual == 0) {
        x_actual = x_ref;
        y_actual = y_ref;
      }
    }
    
    a_x = 4 * (x_ref - x_actual ) / ((fr*TIME_CONSTANT)*(fr*TIME_CONSTANT));
    a_y = 4 * (y_ref - y_actual ) / ((fr*TIME_CONSTANT)*(fr*TIME_CONSTANT));
    v_x=0;
    v_y=0;
    dir = 0;

    for(int i = 0; i<tracks.size(); i++)
      dir += trackDirection(n, (String)tracks.get(i));
    dir = dir/tracks.size();
  }
  
  float timeToOrigo() // s -> h
  {
   return sqrt( (cos(angle_ref) * distanceMatrix[n][origo]) * (cos(angle_ref) * distanceMatrix[n][origo]) + 
                (sin(angle_ref) * distanceMatrix[n][origo]) * (sin(angle_ref) * distanceMatrix[n][origo])) / 3600;
  }
  
  float distToOrigo()
  {
    return sqrt((x - places[origo].getX())*(x - places[origo].getX())+(y - places[origo].getY())*(y - places[origo].getY()))/1000;
  }
  
  float stopCoordsX(String ID)
  {
    return zoomX(x_actual) + cos(dir)*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 10;
  }
  
  float stopCoordsY(String ID)
  {
    return zoomY(y_actual) + sin(dir)*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 10;
  }
  
  void consolidate(){
    x_actual = x_ref;
    y_actual = y_ref;
  }
  
  // Display point in relation to selected origo.
  void display()
  {
    rectMode(CENTER);

    if(trackMode==0){
      pushMatrix();
        translate(zoomX(x_actual), zoomY(y_actual));
      fill(0,0,255);
      ellipse(0,0,10,10);
      
      popMatrix();
      return;
    }

    if (tracks.size() == 0)
      return;

    boolean onLine = false;

    for(int i = 0; i < tracks.size(); i++) {
      pushMatrix();
        translate(zoomX(x_actual), zoomY(y_actual));
        rotate(dir);
        fill((Integer) colors.get(i));
        ellipse( (i+1-((float)tracks.size()+1)/2) * 10, 0, 10, 10);
        fill(0,0,255);
        ellipse( (i+1-((float)tracks.size()+1)/2) * 10, 0, 6, 6);
      popMatrix();
    }

        fill(0,0,0);
        noStroke();
  }

  void displayText()  {
      pushMatrix();
      translate(zoomX(x_actual), zoomY(y_actual));
      fill(0,0,0);
      textAlign(LEFT, CENTER);
      textFont(labelFont);
      text(name, 3 + tracks.size()*9, 0);
      popMatrix();
  }

  float trackDirection(int placeID, String trackID) {
    for(int i = 0; i < railTracks.length; i++)
      if(railTracks[i].label.equals(trackID))
        return railTracks[i].trackDirection(placeID);

    for(int i = 0; i < tramTracks.length; i++)
      if(tramTracks[i].label.equals(trackID))
        return tramTracks[i].trackDirection(placeID);

    return 0;
  }

  float circleBin(float ang, int n) {
    ang+=PI;
    
    for(int i = 1; i <= n; i++)
      if(ang < 2 * PI * (i/n))
        return 2 * PI * (i/n - 1);
    return 1;
  }
  
}
