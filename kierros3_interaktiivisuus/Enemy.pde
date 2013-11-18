class Enemy{
  int x;
  int y;
  int width;
  int height;
  int speedX;
  int speedY;

  Enemy(int x, int y, int width, int height, int speedX){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  void  setRectSpecs(int x, int y){
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
