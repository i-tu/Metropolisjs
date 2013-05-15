class Button
{
  PShape sh;
  int x;
  int y;
  int buttonWidth;
  int buttonHeight;
  boolean toggled;
  color currentcolor = color(255,255,255,0);
  color highlightcolor = color(0,70,50);
  color basecolor = color(255,255,255,0);
  
  Button(int x_, int y_, int w_, int h_, PShape sh_, boolean toggled_) {
    this.x = x_;
    this.y = y_;
    this.buttonWidth = w_;
    this.buttonHeight = h_;
    this.sh = sh_;
    this.toggled = toggled_;
  }
    
  boolean inside() {
    if(((x-buttonWidth/2) < mouseX && mouseX < (x+buttonWidth/2)) &&
         ((y-buttonHeight/2) < mouseY && mouseY < (y+buttonHeight/2)) )
      return true;
    else
      return false;
  }
  
  boolean isToggled() {
    return toggled;
  }
  
  boolean toggle() {
    if(toggled) { toggled = false; return false; }
    else { toggled = true; return true; }
  }
  
  void display() {

    fill(0);
    if(toggled)
      rect(x-16,y+25,x+14,y+27);

    shapeMode(CENTER);
    shape(sh, x, y, buttonWidth - 5, buttonHeight - 5);
  }
}
