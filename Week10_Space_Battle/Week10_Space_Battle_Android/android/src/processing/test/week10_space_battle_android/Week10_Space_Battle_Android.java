package processing.test.week10_space_battle_android;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import apwidgets.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Week10_Space_Battle_Android extends PApplet {

//import ddf.minim.*;
//import ddf.minim.signals.*;
//import ddf.minim.analysis.*;
//import ddf.minim.effects.*;


//Harry Pham 79422112
Ship spaceship;
//An arraylist of asteroids
ArrayList asteroids;
//An arraylist of shots fired
ArrayList shots;
ArrayList enemies;
ArrayList enemyshots;
//Difficulty of the game, each difficulty increase adds more asteroids
int difficulty = 1;
//Current number of asteroids in the dificulty
int numberofasteroids = 0;
int numberofenemies = 0;
int enemyrespawn = 0;
PImage bg;
//Minim minim;
//AudioSample laser;
//AudioSample blast;
APMediaPlayer player;
SpriteSheet explode;
ArrayList explosionindex;
ArrayList explosions;
PFont font;
int mode = 0;

public void setup() {
 
  smooth();
  noStroke();
  frameRate(30);
  spaceship= new Ship(width/2, height/2);
  shots = new ArrayList();
  enemies = new ArrayList();
  enemyshots = new ArrayList();
  asteroids = new ArrayList();
  explosionindex = new ArrayList();
  explosions = new ArrayList();
  asteroids.add(new Asteroid());
  player = new APMediaPlayer(this);
  bg = loadImage("background.png");
  font = createFont("Halo3.ttf", 19);
  textFont(font);
  textAlign(CENTER);
}
public void draw() {
  if (mode==0) {
    background(bg);
    textAlign(CENTER);
    fill(255);
    textFont(font, 57);
    text("Space Battle", width/2, height/2);
    textFont(font);
    text("Click anywhere to begin game", width/2, (height/2) +57);
  }
  else if (mode==1) {
    //Keeps track of time to increase difficulty
    int m = millis();
    difficulty = m/10000;
    background(bg);
    textSize(20);
    fill(255);
    //Tells player how much shields they have left
    text("Shield: "+ spaceship.shield(), 100, 40);
    //Shoots shots from spaceship
    spaceship.shoot();
    //Reloads the shot after it has been fired
    spaceship.reload();
    //Recharges the spaceship's shields
    spaceship.shieldrecharge();
    //Checks if shots are still in window or not and moves the shots
    for (int i = shots.size()-1; i >= 0; i--) {
      Shot shot = (Shot) shots.get(i);
      if (shot.x() > width || shot.x() < 0 || shot.y() > height || shot.y() < 0) {
        shots.remove(i);
      }
      else {
        shot.walk();
        shot.display();
      }
    }
    for (int i = enemyshots.size()-1; i >= 0; i--) {
      Shot shot = (Shot) enemyshots.get(i);
      spaceship.checkhit(shot.location(), true);
      if (shot.x() > width || shot.x() < 0 || shot.y() > height || shot.y() < 0 || spaceship.location().dist(shot.location()) <= 65) {
        enemyshots.remove(i);
      }
      else {
        shot.walk();
        shot.display();
      }
    }
    //Checks to see if any shots hit any asteroids
    for (int i = shots.size()-1; i >= 0; i--) {
      for (int j = asteroids.size()-1; j >= 0; j--) {
        try {
          Shot shot = (Shot) shots.get(i);
          Asteroid asteroid = (Asteroid) asteroids.get(j);
          if (shot.location().dist(asteroid.location()) <= 30) {
            player.setMediaFile("Blast-SoundBible.com-2068539061.mp3");
            player.start();
            asteroids.remove(j);
            shots.remove(i);
            explosions.add(new SpriteSheet("explosion_transparent.png", 5, 5));
            explosionindex.add(new SpriteIndexAndLocation(asteroid.location()));
          }
        }
        catch (IndexOutOfBoundsException e) {
        }
      }
    }
    for (int i = explosionindex.size()-1; i >= 0; i--) {
      SpriteSheet explosion = (SpriteSheet) explosions.get(i);
      SpriteIndexAndLocation index = (SpriteIndexAndLocation) explosionindex.get(i);
      image(explosion.acq(index.currentint()), index.x(), index.y());
      index.addone();
      if (index.currentint() > 24) {
        explosions.remove(i);
        explosionindex.remove(i);
      }
    }
    for (int i = shots.size()-1; i >= 0; i--) {
      for (int j = enemies.size()-1; j >= 0; j--) {
        try {
          Shot shot = (Shot) shots.get(i);
          Enemy enemy = (Enemy) enemies.get(j);
          if (shot.location().dist(enemy.location()) <= 65) {
            enemy.hit();
            shots.remove(i);
          }
        }
        catch (IndexOutOfBoundsException e) {
        }
      }
    }
    //Creates more asteroids according to the difficulty
    if (numberofasteroids < difficulty) {
      for (int i = 0; i <= difficulty-1; i++) {
        asteroids.add(new Asteroid());
        numberofasteroids+=1;
      }
    }
    //Moves the asteroids and removes them if they hit the ship
    for (int i = asteroids.size()-1; i >= 0; i--) {
      Asteroid asteroid = (Asteroid) asteroids.get(i);
      asteroid.update();
      spaceship.checkhit(asteroid.location(), false);
      asteroid.display();
      if (spaceship.location().dist(asteroid.location()) <= 85) {
        asteroids.remove(i);
      }
    }
    if (numberofenemies==0 && enemyrespawn == 0) {
      enemies.add(new Enemy());
      numberofenemies+=1;
      enemyrespawn = 900;
    }
    else if (numberofenemies==0) {
      enemyrespawn-=1;
    }
    for (int i = enemies.size()-1; i >= 0; i--) {
      Enemy enemy= (Enemy) enemies.get(i);
      enemy.update();
      enemy.display();
      enemy.shoot();
      enemy.reload();
      if (enemy.shield<=0) {
        enemy.dead();
        numberofenemies-=1;
      }
    }
    // Ends the game if the spaceship's shields is 0
    if (spaceship.shield() <= 0) {
      textSize(30);
      fill(255, 0, 0);
      text("Spaceship has been destroyed!", 125, 320);
      noLoop();
    }
  }
}
public void mousePressed() {
  if (mode == 0) {
    mode = 1;
  }
}

//void stop(){
//  laser.close();
//  blast.close();
//  minim.stop();
//
//  super.stop();
//}
public void onDestroy() {

  super.onDestroy(); //call onDestroy on super class
  if(player!=null) { //must be checked because or else crash when return from landscape mode
    player.release(); //release the player

  }
}
class Asteroid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  //25% chance of being placed at one of the 4 sides of the window
  float randomlocation = random(1);
  //Creates a random location at the edge of the window for the asteroid
  Asteroid() {
    if (randomlocation <= .25f) {
      location = new PVector(25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <= .50f) {
      location = new PVector(width-25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <=.75f) {
      location = new PVector(constrain(random(width), 25, width-25), 25);
    }
    else {
      location = new PVector(constrain(random(width), 25, width-25), height-25);
    }
    velocity = new PVector(0, 0);
    topspeed = 5;
  }
  //Moves the asteroid
  public void update() {
    PVector ship = new PVector(width/2, height/2);
    PVector dir = PVector.sub(ship, location);
    dir.normalize();
    dir.mult(3);
    acceleration = dir;
    location.add(acceleration);
  }
  //Shows the asteroid on the screen
  public void display() {
    ellipseMode(CENTER);
    fill(142, 142, 142);
    ellipse(location.x, location.y, 50, 50);
  }
  //Returns the asteroid's location
  public PVector location() {
    return location;
  }
}

class Enemy {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PImage ship2 = loadImage("Ship2.png");
  float topspeed;
  float angle = 0.0f;
  boolean circle = false;
  float randomlocation = random(1);
  float t = millis()/1000.0f;
  float reload = 1;
  int shield = 100;
  boolean alive = true;
  //Creates a random location at the edge of the window for the enemy
  Enemy() {
    if (randomlocation <= .25f) {
      location = new PVector(25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <= .50f) {
      location = new PVector(width-25, constrain(random(height), 25, height-25));
    }
    else if (randomlocation <=.75f) {
      location = new PVector(constrain(random(width), 25, width-25), 25);
    }
    else {
      location = new PVector(constrain(random(width), 25, width-25), height-25);
    }
    velocity = new PVector(0, 0);
    topspeed = 5;
  }
  //Moves the enemy
  public void update() {
    PVector ship = new PVector(width/2, height/2);
    if (location.dist (ship)<200) {
      circle=true;
    }
    if (circle==false) {
      PVector dir = PVector.sub(ship, location);
      dir.normalize();
      dir.mult(.1f);
      acceleration = dir;
      velocity.add(acceleration);
      location.add(velocity);
    }
    else if (alive==true) {
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
  public void display() {
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
    fill(20, 20, 225, shield*1.25f);
    ellipse(0, 0, 120, 120);
    popMatrix();
  }
  public void hit() {
      shield-=25;
  }
  //Limits the enemies shots
  public void reload() {
    reload += .01f;
  }
  //Enemy shoots at ship
  public void shoot() {
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
  public PVector location() {
    return location;
  }
  public void dead(){
    alive = false;
  }
  public int shields(){
    return shield;
  }
}

class Ship {
  PVector location;
  //Loads image from data folder
  PImage ship = loadImage("Ship.png");
  float angle = 0.0f;
  int shield = 100;
  float reload = 1.0f;
  int rechargetimer=0;
  float mX;
  float mY;
  Ship(float _x, float _y) {
    location = new PVector(_x, _y);
  }
  //Draws the ship
  public void drawShip() {
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
    fill(20, 20, 225, shield*1.25f);
    ellipse(0, 0, 120, 120);
    popMatrix();
  }
  //Checks to see if any asteroids hit the ship and subtracts from the shields if true
  public void checkhit(PVector _location, boolean _type) {
    if (_type == false) {
      if (location.dist(_location) <= 85) {
        shield-=5;
      }
    }
    else if (_type == true) {
      if (location.dist(_location) <= 65) {
        shield-=1;
      }
    }
  }
  //Recharges the shield by 5 every 10 seconds
  public void shieldrecharge() {
    if (shield < 100) {
      rechargetimer+=1;
      if (rechargetimer%300==0) {
        shield+=5;
      }
    }
  }
  //Sets a delay between each shot fired
  public void reload() {
    reload += .05f;
  }
  //Shoots shots from the spaceship to destroy asteroids
  public void shoot() {
    pushMatrix();
    //Checks what angle the mouse is at
    angle = atan2((mY - location.y)*-1, (mX - location.x)*-1) - HALF_PI;
    drawShip();
    popMatrix();
    if (reload > 1) {
      if (mousePressed) {
        mX = mouseX;
        mY = mouseY;
        shots.add(new Shot(location.x, location.y, mX, mY));
        reload = 0;
        player.setMediaFile("Laser_Cannon-Mike_Koenig-797224747.mp3");
        player.start();
      }
    }
  }
  //Returns shield
  public int shield() {
    return shield;
  }
  //Returns location of ship
  public PVector location() {
    return location;
  }
}

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
    dir.mult(.1f);
    velocity = new PVector(0, 0);
  }
  //Displays shot on screen
  public void display() {
    ellipseMode(CENTER);
    fill(255, 0, 0);
    ellipse(location.x, location.y, 10, 10);
  }
  //Moves the shot
  public void walk() {
    velocity.add(dir);
    velocity.limit(10);
    location.add(velocity);
  }
  public float x() {
    return location.x;
  }
  public float y() {
    return location.y;
  }
  public PVector location() {
    return location;
  }
}

class SpriteIndexAndLocation {
  int number = 0;
  PVector location;
  SpriteIndexAndLocation(PVector _location){
    location = _location;
  }
  public int currentint() {
    return number;
  }
  public void addone() {
    number++;
  }
  public float x(){
    return location.x;
  }
  public float y(){
    return location.y;
  }
}

// This is the SpriteSheet class.

class SpriteSheet {
  
  PImage spritesheet;
  int row;
  int col;
  PImage[] sprites;
  
  SpriteSheet(String _path, int _row, int _col) { // The incoming data
    spritesheet = loadImage(_path);
    row = _row;
    col = _col;
    sprites = new PImage[row*col];
    imageMode(CENTER);
    int W = spritesheet.width/col;
    int H = spritesheet.height/row;
    for (int i=0; i<sprites.length; i++) {
      int x = i%col*W;
      int y = i/col*H;
      sprites[i] = spritesheet.get(x, y, W, H);
    }
  }
  
  public PImage acq(int _index) {
    return sprites[_index];
  }
}

  public int sketchWidth() { return 480; }
  public int sketchHeight() { return 800; }
}
