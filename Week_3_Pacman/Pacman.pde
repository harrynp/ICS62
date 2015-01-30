class Pacman {
  PVector location;
  //Speed of pacman
  float speed = 4;
  //Changes direction pacman is facing
  String direction = "right";
  Pacman(float _x, float _y) {
    location = new PVector(_x, _y);
  }
  int number_of_powerups;
  int powerup_time = 0;
  PVector powerup_location;
  //Displays Pacman
  void display() {
    ellipseMode(CENTER);
    stroke(255, 246, 67);
    fill(255, 246, 67);
    ellipse(location.x, location.y, 25, 25);
    stroke(255);
    fill(255);
    //Facing Right
    if (direction == "right") {
      triangle(location.x, location.y, location.x+12, location.y-6, location.x+12, location.y+6);
    }
    if (direction == "up") {
      triangle(location.x, location.y, location.x-6, location.y-13, location.x+6, location.y-13);
    }
    if (direction == "left") {
      triangle(location.x, location.y, location.x-13, location.y-6, location.x-13, location.y+6);
    }
    if (direction == "down") {
      triangle(location.x, location.y, location.x-6, location.y+12, location.x+6, location.y+12);
    }
    if (number_of_powerups != 0) {
      stroke(0, 0, 255);
      fill(0, 0, 255);
      rect(powerup_location.x, powerup_location.y, 25, 25);
    }
  }
  //changes direction of pacman
  void userinput() {
    if (keyPressed) {
      if (key == 'w' || key == 'W') {
        direction="up";
      }
      if (key == 's' || key == 'S') {
        direction="down";
      }
      if (key == 'a' || key == 'A') {
        direction="left";
      }
      if (key == 'd' || key == 'D') {
        direction="right";
      }
    }
  }
  //Moves pacman
  void walk() {
    if (direction=="up") {
      location.y-=speed;
    }
    else if (direction=="down") {
      location.y+=speed;
    }
    else if (direction=="left") {
      location.x-=speed;
    }
    else if (direction=="right") {
      location.x+=speed;
    }
    location.x = constrain(location.x, 0, width-1);
    location.y = constrain(location.y, 0, height-1);
  }
  //Create powerup with a 1% chance on the screen
  void createpowerup() {
    float chance=random(1);
    if (chance >= .99) {
      if (number_of_powerups==0) {
        powerup_location=new PVector(random(width), random(height));
        number_of_powerups+=1;
      }
    }
  }
  //Uses powerup if obtained
  void powerup() {
    if (number_of_powerups != 0) {
      if (location.dist(powerup_location) <= 15) {
        powerup_time+=300;
        number_of_powerups =0;
      }
    }
    //Decreases powerup time by 1 and doubles speed
    if (powerup_time != 0){
      speed = 8;
      powerup_time-=1;
    }
    //Resets speed to 4
    else if (powerup_time==0){
      speed = 4;
    }
  }
  PVector locate() {
    return location;
  }
}

