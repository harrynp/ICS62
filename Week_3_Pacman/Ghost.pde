class Ghost {
  PVector location;
  //Speed of ghost
  float speed = 2;
  //Random colors for ghost
  float r = random(255);
  float g = random(255);
  float b = random(255);
  //How far the ghost can detect pacman
  int detection_radius = 85;
  //Shows area ghost can detect if true
  boolean ghost_detection_circle = false;
  Ghost(float _x, float _y, boolean _ghost_detection_circle) {
    location = new PVector(_x, _y);
    ghost_detection_circle = _ghost_detection_circle;
  }
  void display() {
    //Detection Radius
    if (ghost_detection_circle == true) {
      stroke(255, 0, 0);
      strokeWeight(2);
      fill(255,255,255,0);
      ellipse(location.x, location.y, detection_radius*2, detection_radius*2);
    }
    //Body
    rectMode(CENTER);
    stroke(r, g, b);
    fill(r, g, b);
    rect(location.x, location.y, 20, 20);
    //Semicircle
    ellipseMode(CENTER);
    ellipse(location.x, location.y-10, 20, 20);
    //Eyes
    stroke(255);
    strokeWeight(5);
    point(location.x-5, location.y-10);
    point(location.x+5, location.y-10);
  }
  //Moves ghost
  void walk() {
    if (location.dist(pacman_location) < detection_radius) {
      if (pacman_location.x>location.x&&pacman_location.y>location.y) {
        location.x+=speed;
        location.y+=speed;
      }
      else if (pacman_location.x<location.x&&pacman_location.y<location.y) {
        location.x-=speed;
        location.y-=speed;
      }
      if (pacman_location.x>location.x&&pacman_location.y<location.y) {
        location.x+=speed;
        location.y-=speed;
      }
      else if (pacman_location.y<location.x&&pacman_location.y>location.y) {
        location.x-=speed;
        location.y+=speed;
      }
    }
    else {
      float walkx = random(-1, 1);
      float walky = random(-1, 1);
      float stepsize = montecarlo();
      walkx*=stepsize *10;
      walky*=stepsize *10;
      location.x+=walkx;
      location.y+=walky;
      location.x = constrain(location.x, 0, width-1);
      location.y = constrain(location.y, 0, height-1);
    }
  }
  float montecarlo() {
    while (true) {
      float r1 = random(1);
      float probability = r1;
      float r2 = random(1);
      if (r2 < probability) {
        return r1;
      }
    }
  }
  //Returns ghost location
  PVector locate() {
    return location;
  }
}  

