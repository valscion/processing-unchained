class Player{

  Player(int x, int y, int width, int height, int speedY){
  this.x = x;
  this.y = y;
  this.width = width;
  this.height = height;

  }
  void setRectSpecs(int x, int y){
    this.x = x;
    this.y = y;
  }
  int getX(){
    return this.x;
  }

  int getY(){
    return this.y
  }
}
