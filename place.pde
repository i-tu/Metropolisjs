
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
    "Screen coordinates: (" + str(x_actual) + ", " + str(y_actual) + "). angle: " + str(angle_ref) + '\n');
    return;
  }
  
  String getName () { return name; }
  int getX() { return x; }
  int getY() { return y; }
  
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
    
    if(x_ref==0 && y_ref==0) { //olen origo
      x_ref = width/2;
      y_ref = height/2;
    }
    else {
       angle_ref = atan2( (places[origo].getY()-getY()), (places[origo].getX()-getX()) );
       
       //angle_ref = circleBin(angle_ref,8);

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
    return zoomX(x_actual) + cos(railTrackDirection(n, ID))*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 10;
  }
  
  float stopCoordsY(String ID)
  {
    return zoomY(y_actual) + sin(railTrackDirection(n, ID))*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 10;
  }
  
  float tramStopCoordsX(String ID)
  {
    return zoomX(x_actual) + cos(tramTrackDirection(n, ID))*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 8;
  }
  
  float tramStopCoordsY(String ID)
  {
    return zoomY(y_actual) + sin(tramTrackDirection(n, ID))*(((float)tracks.indexOf(ID)+1)-((float)tracks.size()+1)/2) * 8;
  }
  
  void consolidate(){
    x_actual = x_ref;
    y_actual = y_ref;
  }
  
  // Display point in relation to selected origo.
  void display()
  {
    rectMode(CENTER);
    stroke(0);
    fill(transparent);

    if (tracks.size() == 0)
      return;
        
    float dir = 0;
      
    for(int i = 0;i<tracks.size();i++)
      dir += tramTrackDirection(n, (String)tracks.get(i));  
    dir = dir/tracks.size();
      
    pushMatrix();
      translate(zoomX(x_actual), zoomY(y_actual));
      rotate(dir);
      drawStop(0,0, 2 + (tracks.size()-1)*8, n<=68 ? 8 : 5, dir);  
    popMatrix();
    
    if(this.inside()){
      drawScale( mode == 1 ? timeToOrigo() * 3600 : distToOrigo() * 1000);
	}
    if(zoomAmount > 4 || n <= 68) {
      pushMatrix();

    fill(0);

    if(n != origo) {
      translate(zoomX(x_actual), zoomY(y_actual));

      if(PI/2 < angle_ref || angle_ref < -PI/2) {
        textAlign(LEFT, CENTER);
        text(name, 20, 0);
      }
      else {
        textAlign(RIGHT, CENTER);
        text(name, -20, 0);
      }
    }     
    else {
      textAlign(CENTER, BOTTOM); 
      text(name, 0, 30);
    }

    textAlign(RIGHT, CENTER);
    popMatrix();
    }
  }

  float railTrackDirection(int placeID, String trackID) {
    for(int i = 0; i < railTracks.length; i++)
      if(railTracks[i].label.equals(trackID))
        return railTracks[i].trackDirection(placeID);
    return 0;
  }

  float tramTrackDirection(int placeID, String trackID) {
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