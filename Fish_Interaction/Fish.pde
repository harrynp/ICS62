class Fish {
  //Global
  //Creates PVector for Coordinates
  //Noise walk adapted from Nature of Code
  PVector location;
  PVector noff;
  //Coordinates of food that fish will head towards
  int foodx, foody;
  //List of area where food are, true if food is there and false otherwise
  boolean foodlist[][] = new boolean[width][height];
  //Amount of food
  int amount;
  //Hunger level of fish. If below 0, fish starts losing health.
  float hungerlevel=100;
  //Health level of fish.  If below 100, fish is dead.
  float health = 100;
  //Constructor
  Fish(float _x, float _y){
    location = new PVector(_x, _y);
    noff = new PVector(0,10000);
  }
  //Functions
  //Runs the Fish class when called
  void run(){
    starving();
    placefood();
    foodnumber();
    walk();
    eat();
    display();
  }
  void display() {
    ellipseMode(CENTER);
    rectMode(CENTER);
    //Body
    stroke(255,246,67);
    fill(255,246,67);
    ellipse(location.x,location.y,66,50);
    //Fin
    stroke(255,246,67);
    fill(255,246,67);
    triangle(location.x-33,location.y,location.x-55,location.y-25,location.x-55,location.y+25);
    //Eyes
    if(health>0){
      stroke(0);
      strokeWeight(5);
      point(location.x+25,location.y-7);
      point(location.x+25,location.y+3);
    }
    //Stops Fish from Moving once dead
    else{
      stroke(0);
      strokeWeight(3);
      line(location.x+15,location.y-10,location.x+20,location.y-4);
      line(location.x+20,location.y-10,location.x+15,location.y-4);
      line(location.x+15,location.y+6,location.x+20,location.y);
      line(location.x+20,location.y+6,location.x+15,location.y);
      println("Fish is dead x.x");
      noLoop();
    }
  }
  //Moves Fish
  void walk() {
    if (health>0){
      //Every movement increases hunger by a random amount
      float hungerincrease = random(0.5);
      hungerlevel -= hungerincrease;
      //If fish is hungry, checks for food and heads in that direction
      if (hungerlevel < 50){
        if (amount>0){
          if (foodlist[foodx][foody]==false){
            for (int i = 0; i < width; i++){
              for (int j = 0; j < height; j++){
                if (foodlist[i][j]==true){
                  foodx = i;
                  foody = j;
                }
              }
            }
          }
          if (foodx>location.x && foody>location.y){
            location.x += 5;
            location.y += 5;
          }
          else if(foodx<location.x && foody<location.y){
            location.x -= 5;
            location.y -= 5;
          }
          if (foodx>location.x && foody<location.y){
            location.x += 5;
            location.y -= 5;
          }
          else if(foodx<location.x && foody>location.y){
            location.x -= 5;
            location.y += 5;
          }
        }
        //If fish is hungry and there is no food around moves faster
        else{
          location.x = map(noise(noff.x),0,1,0,width);
          location.y = map(noise(noff.y),0,1,0,height);
          noff.add(0.05,0.05,0);
        }
      }
      //If fish isn't hungry, moves normally in a noise walk
      else if (hungerlevel>=50){
        location.x = map(noise(noff.x),0,1,0,width);
        location.y = map(noise(noff.y),0,1,0,height);
        noff.add(0.01,0.01,0);
      }
      //Constrains the fish to the window
      location.x = constrain(location.x,0,width-33);
      location.y = constrain(location.y,0,height-25);
    }
  }
  //Checks for mouse input to place food
  void placefood(){
    if (mousePressed == true){
      int xmouse = mouseX;
      int ymouse = mouseY;
      foodlist[xmouse][ymouse]=true;
    }
    //Displays food
    for (int i = 0; i < width; i++){
      for (int j = 0; j < height; j++){
        if (foodlist[i][j]==true){
          fill(201,123,20);
          stroke(201,123,20);
          ellipse(i,j,5,5);
        }
      } 
    }
  }
  //Checks if there is any food around
  void foodnumber(){
    amount=0;
    for(int i = 0; i<width;i++){
      for(int j = 0; j<height;j++){
        if (foodlist[i][j]==true){
          amount+=1;
        }
      }
    }
  }
  //Makes the fish eat if hungry, decreases hunger by a number between 5 and 25
  void eat(){
    if (dist(location.x,location.y,foodx,foody)<=25){
      hungerlevel += random(5,25);
      int area=25;
      for(int i = 0; i<area;i++){
        foodlist[foodx+i][foody+i]=false;
        foodlist[foodx-i][foody-i]=false;
      }
    }
  }
  //If fish's hunger is below 100 makes fish start to lose health.  If health is 0 or below, fish is dead.
  void starving(){
    if (hungerlevel<0){
      health-=1;
    }
  }
}
    
