class Enemy{
  float x;
  float y;
  float width;
  float height;
  float speedX;
  float speedY;

  Enemy(float x, float y, float width, float height, float speedX){
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
    else if(millis() < 50000){
      speedX = 11;
    }
  }

  float getX(){
    return this.x;
  }

  float getY(){
    return this.y;
  }
}
