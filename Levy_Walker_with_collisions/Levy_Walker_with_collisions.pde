//Double Levy Walker with ellipses created when there are collisions
//Harry Pham 79422112
Walker w;
void setup(){
  size(200,200);
  smooth();
  w= new Walker();
  background(255);
  frameRate(30); 
}
void draw(){
  w.walk();
  w.display();
  w.collisions();
}

