class Walker {
  int x,y;
  int x2,y2;
  float startx, starty;
  float startx2, starty2;
  boolean [] [] collisionlist = new boolean[width][height];
  int [] [] colorlist = new int[width][height];
  int [] [] colorlist2 = new int[width][height];
  int [] [] colorlist3 = new int[width][height];
  Walker() {
    x = width/4;
    y = height/2;
    x2 = width/4*3;
    y2 = height/2;
  }
  //Draws the line between (startx,starty) to (x,y)
  void display() {
    background(255);
    stroke(0);
    strokeWeight(2);
    line(startx,starty,x,y);
    line(startx2,starty2,x2,y2);
  }
  //Checks if there are any collisions and creates an ellipse at that area if there is
  void collisions(){
    //Subtracts the x and y coordiates from each walker respectively and if the difference is less than or equal to 10, set that points boolean value in the array to true.
    int xsubtract = Math.abs(x-x2);
    int ysubtract = Math.abs(y-y2);
    if (xsubtract <=10 && ysubtract <=10) {
      collisionlist[x][y]=true;
    }
    for (int i = 0; i < width; i++){
      for (int j = 0; j < height; j++){
        if (collisionlist[i][j]==true){
          //Draws an ellipse if the boolean value recieved from the array is true.
          fill(colorlist[i][j],colorlist2[i][j],colorlist3[i][j],127);
          stroke(colorlist[i][j],colorlist2[i][j],colorlist3[i][j],127);
          ellipse(i,j,50,50);
        }
        else if (collisionlist[i][j]==false){
          //Sets the color of the ellipse
          colorlist[i][j]=int(random(255));
          colorlist2[i][j]=int(random(255));
          colorlist3[i][j]=int(random(255));
        }
      }
    }
  }
  //Sets the startx and starty points and changes the value of x and y
  void walk() {
    startx = x;
    starty = y;
    startx2 = x2;
    starty2 = y2;
    float walkx = random(-1,1);
    float walky = random(-1,1);
    float stepsize=montecarlo();
    walkx *= stepsize * 25;
    walky *= stepsize * 25;
    x += walkx;
    y += walky;
    walkx = random(-1,1);
    walky = random(-1,1);
    stepsize=montecarlo();
    walkx *= stepsize * 25;
    walky *= stepsize * 25;
    x2 += walkx;
    y2 += walky;
    x = constrain(x,0,width-1);
    y = constrain(y,0,height-1);
    x2 = constrain(x2,0,width-1);
    y2 = constrain(y2,0,height-1);
  }
  //montecarlo taken from Nature of Code Introduction
  //Chooses a value between 0 and 1 as long as r2<r1
  float montecarlo(){
    while (true){
      float r1 = random(1);
      float probability = r1;
      float r2 = random(1);
      if (r2 < probability){
        return r1;
      }
    }
  }
}

