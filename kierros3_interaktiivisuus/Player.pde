class Player{
  int r;
  int x;
  int y;
  int speedY;
  Player(int x, int y, int r, int speedY){
    this.x = x;
    this.y = y;
    this.r =r;
    
  }
  void setRectSpecs(int x, int y){
    this.x = x;
    this.y = y;
  }
  int getX(){
    return this.x;
  }

  int getY(){
    return this.y;
  }
  int getR(){
    return this.r;
  }
}
