class Ship {
  PVector location;
  //Loads image from data folder
  PImage ship = loadImage("Ship.png");
  float angle = 0.0;
  int shield = 100;
  float reload = 1.0;
  int rechargetimer=0;
  Ship(float _x, float _y) {
    location = new PVector(_x, _y);
  }
  //Shows the ship on the screen
  void display() {
    float mX;
    float mY;
    pushMatrix();
    mX = mouseX;
    mY = mouseY;
    //Checks what angle the mouse is at
    angle = atan2((mY - location.y)*-1, (mX - location.x)*-1) - HALF_PI;
    drawShip();
    popMatrix();
  }
  //Draws the ship
  void drawShip() {
    pushMatrix();
    //Sets the coordinate plane at ship's location
    translate(location.x, location.y);
    //Rotates the ship according to the angle found from the mouse's' location
    rotate(angle);
    //Makes the center of the image at points x and y
    imageMode(CENTER);
    //Displays the ship on screen
    image(ship, 0, 0);
    //Creates the shield for the ship; as the shield goes down, the shield becomes more transparent
    ellipseMode(CENTER);
    fill(20, 20, 225, shield*1.25);
    ellipse(0, 0, 120, 120);
    popMatrix();
  }
  //Checks to see if any asteroids hit the ship and subtracts from the shields if true
  void checkhit(PVector _asteroid) {
    if (location.dist(_asteroid) <= 85) {
      shield-=5;
    }
  }
  //Recharges the shield by 5 every 10 seconds
  void shieldrecharge() {
    if (shield < 100) {
      rechargetimer+=1;
      if (rechargetimer%300==0) {
        shield+=5;
        println("Shield Recharged!");
      }
    }
  }
  //Sets a delay between each shot fired
  void reload() {
    reload += .05;
  }
  //Shoots shots from the spaceship to destroy asteroids
  void shoot() {
    if (reload > 1) {
      if (mousePressed) {
        float mX;
        float mY;
        mX = mouseX;
        mY = mouseY;
        shots.add(new Shot(mX, mY));
        reload = 0;
      }
    }
  }
  //Returns shield
  int shield() {
    return shield;
  }
  //Returns location of ship
  PVector location() {
    return location;
  }
}

