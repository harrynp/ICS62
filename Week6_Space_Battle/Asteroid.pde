class Asteroid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  //25% chance of being placed at one of the 4 sides of the window
  float randomlocation = random(1);
  //Creates a random location at the edge of the window for the asteroid
  Asteroid() {
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
  //Moves the asteroid
  void update() {
    PVector ship = new PVector(width/2, height/2);
    PVector dir = PVector.sub(ship, location);
    dir.normalize();
    dir.mult(3);
    acceleration = dir;
    location.add(acceleration);
  }
  //Shows the asteroid on the screen
  void display() {
    ellipseMode(CENTER);
    fill(142, 142, 142);
    ellipse(location.x, location.y, 50, 50);
  }
  //Returns the asteroid's location
  PVector location() {
    return location;
  }
}

