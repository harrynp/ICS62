//Harry Pham 79422112
ArrayList ghosts;
Pacman pacman;
//Pacman's location
PVector pacman_location = new PVector(width/2,height/2);
//Number of ghosts
int numofghosts = 4;
void setup() {
  size(600, 400);
  smooth();
  frameRate(30);
  ghosts = new ArrayList();
  for (int i = 0; i < numofghosts; i++) {
    float chance = random(1);
    int randomx;
    if (chance < 0.5){
      randomx=width/4-10;
    }
    else{
      randomx=3*(width/4)-10;
    }
    PVector randomspawn= new PVector(randomx,random(height-10));
    ghosts.add(new Ghost(randomspawn.x, randomspawn.y, true));
  }
  pacman = new Pacman(width/2, height/2);
}
void draw() {
  float m = millis();
  float score = m/1000;
  background(255);
  //Locates pacman
  pacman_location=pacman.locate();
  //draws ghosts
  for (int i = ghosts.size()-1; i >= 0; i--) {
    Ghost ghost = (Ghost) ghosts.get(i);
    //draws ghost
    ghost.display();
    //moves ghost
    ghost.walk();
    }
  //Powerups
  pacman.createpowerup();
  pacman.powerup();
  //Moves pacman
  pacman.userinput();
  pacman.walk();
  //draws pacman
  pacman.display();
  //Checks to see if any ghosts have touched pacman
  for (int i = ghosts.size()-1; i >= 0; i--) {
    Ghost ghost = (Ghost) ghosts.get(i);
    PVector ghost_location=ghost.locate();
    if (ghost_location.dist(pacman_location) < 15){
      println("Pacman has died");
      println("You have survived " + score + " seconds.");
      noLoop();
    }
  }
}

