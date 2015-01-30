//Harry Pham 79422112
Fish f;
void setup(){
  size(600,400);
  smooth();
  f = new Fish(width/2,height/2);
  frameRate(30);
}
void draw(){
  background(119,206,240);
  f.run();
}
