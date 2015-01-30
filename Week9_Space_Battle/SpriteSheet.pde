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
  
  PImage acq(int _index) {
    return sprites[_index];
  }
}
