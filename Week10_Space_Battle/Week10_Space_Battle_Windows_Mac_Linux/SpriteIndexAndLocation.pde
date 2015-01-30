class SpriteIndexAndLocation {
  int number = 0;
  PVector location;
  SpriteIndexAndLocation(PVector _location){
    location = _location;
  }
  int currentint() {
    return number;
  }
  void addone() {
    number++;
  }
  float x(){
    return location.x;
  }
  float y(){
    return location.y;
  }
}

