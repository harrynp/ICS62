class Enemy {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PImage ship2 = loadImage("Ship2.png");
  float topspeed;
  float angle = 0.0;
  boolean circle = false;
  float randomlocation = random(1);
  float t = millis()/1000.0f;
  float reload = 1;
  int shield = 100;
  //Creates a random location at the edge of the window for the enemy
  Enemy() {
    if (randomlocation <= .25) {
      location = new PVector(25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <= .50) {
      location = new PVector(width-25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <=.75) {
      location = new PVector(constrain(random(width), 25, width-25), 25);
    }
    else {
      location = new PVector(constrain(random(width), 25, width-25), height-25);
    }
    velocity = new PVector(0, 0);
    topspeed = 5;
  }
  //Moves the enemy
  void update() {
    PVector ship = new PVector(width/2, height/2);
    if (location.dist (ship)<200) {
      circle=true;
    }
    if (circle==false) {
      PVector dir = PVector.sub(ship, location);
      dir.normalize();
      dir.mult(.1);
      acceleration = dir;
      velocity.add(acceleration);
      location.add(velocity);
    }
    else {
      int cx = width/2;
      int cy = height/2;
      int r = 200;
      float t = millis()/1000.0f;
      location.x = (int)(cx+r*cos(t));
      location.y = (int)(cy+r*sin(t));
      angle = t-PI;
    }
  }
  //Shows the enemy on screen
  void display() {
    pushMatrix();
    //Sets the coordinate plane at ship's location
    translate(location.x, location.y);
    //Rotates the ship according to the angle found from the mouse's' location
    rotate(angle);
    //Makes the center of the image at points x and y
    imageMode(CENTER);
    //Displays the ship on screen
    image(ship2, 0, 0);
    ellipseMode(CENTER);
    fill(20, 20, 225, shield*1.25);
    ellipse(0, 0, 120, 120);
    popMatrix();
  }
  void checkhit(PVector _location) {
    if (location.dist(_location) <= 65) {
      shield-=10;
    }
  }
  //Limits the enemies shots
  void reload() {
    reload += .01;
  }
  //Enemy shoots at ship
  void shoot() {
    if (reload >= 1) {
      float mX;
      float mY;
      mX = width/2;
      mY = height/2;
      enemyshots.add(new Shot(location.x, location.y, mX, mY));
      reload = 0;
    }
  }
  //Returns the asteroid's location
  PVector location() {
    return location;
  }
  int shields(){
    return shield;
  }
}

