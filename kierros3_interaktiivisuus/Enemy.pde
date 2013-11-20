class Enemy{
  float x;
  float y;
  float width;
  float height;
  float speedX;
  float speedY;
  boolean active;

  Enemy(float x, float y, float width, float height, float speedX){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.speedX = speedX;
    this.active = true;
  }
  void draw(){
    if(this.active){
      //setSpeed();
      x = x-speedX;
      if(x<0){
        x = 1000;
        y = round(random(500));
      }
      fill(200);
      rect(x,y,width,height);
    }
  }
  void setSpeed(int speed){
    this.speedX = speed;
  }
  void setInactive(){
    this.active = false;
  }
  boolean isActive(){
    return this.active;
  }
  float getX(){
    return this.x;
  }

  float getY(){
    return this.y;
  }
}
