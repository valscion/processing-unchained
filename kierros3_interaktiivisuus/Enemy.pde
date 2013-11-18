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
    this.speedX = speedX;
  }
  void draw(){
    setSpeed();
    x = x-speedX;
    if(x<0){
      x = 1000;
      y = round(random(500));
    }
    fill(200);
    rect(x,y,width,height);
  }
  void setSpeed(){
    if(millis() < 10000){
      speedX = 3;
    }
    else if(millis() < 20000){
      speedX = 6;
    }
    else if(millis() < 30000){
      speedX = 7;
    }
    else if(millis() < 40000){
      speedX = 9;
    }
  }

  void  setRectSpecs(int x, int y){
    this.x = x;
    this.y = y;
  }
  int getX(){
    return this.x;
  }

  int getY(){
    return this.y;
  }
}
