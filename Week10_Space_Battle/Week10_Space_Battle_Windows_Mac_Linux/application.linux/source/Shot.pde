class Shot {
  PVector location;
  PVector velocity;
  PVector mouse;
  PVector dir;
  Shot(float _locationx,float _locationy, float _mouseX, float _mouseY) {
    location = new PVector(_locationx, _locationy);
    mouse = new PVector(_mouseX, _mouseY);
    dir = PVector.sub(mouse, location);
    dir.normalize();
    dir.mult(.1);
    velocity = new PVector(0, 0);
  }
  //Displays shot on screen
  void display() {
    ellipseMode(CENTER);
    fill(255, 0, 0);
    ellipse(location.x, location.y, 10, 10);
  }
  //Moves the shot
  void walk() {
    velocity.add(dir);
    velocity.limit(10);
    location.add(velocity);
  }
  float x() {
    return location.x;
  }
  float y() {
    return location.y;
  }
  PVector location() {
    return location;
  }
}

