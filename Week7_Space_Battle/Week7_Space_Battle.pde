import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

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
Minim minim;
AudioSample laser;
AudioSample blast;

void setup() {
  size(700, 700);
  smooth();
  frameRate(30);
  spaceship= new Ship(width/2, height/2);
  shots = new ArrayList();
  enemies = new ArrayList();
  enemyshots = new ArrayList();
  asteroids = new ArrayList();
  asteroids.add(new Asteroid());
  bg = loadImage("background.png");
  minim = new Minim(this);
  laser = minim.loadSample("Laser_Cannon-Mike_Koenig-797224747.mp3",512);
  blast = minim.loadSample("Blast-SoundBible.com-2068539061.mp3",512);
}
void draw() {
  //Keeps track of time to increase difficulty
  int m = millis();
  difficulty = m/10000;
  background(bg);
  textSize(20);
  fill(255);
  //Tells player how much shields they have left
  text("Shield: "+ spaceship.shield(), 10, 40);
  //Shows the spaceship
  spaceship.display();
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
          blast.trigger();
          asteroids.remove(j);
          shots.remove(i);
        }
      }
      catch (IndexOutOfBoundsException e) {
      }
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
void stop()
{
  // always close Minim audio classes when you are done with them
  laser.close();
  blast.close();
  minim.stop();

  super.stop();
}

