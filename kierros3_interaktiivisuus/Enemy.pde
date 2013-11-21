class Enemy{
  float x;
  float y;
  float width;
  float height;
  float speedX;
  float speedY;
  boolean active;
  PImage pic;
  float multip = 0;
  Enemy(float x, float y, float width, float height, float speedX, PImage pic){
    this.pic = pic;
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
      pushMatrix();
      x = x-speedX;
      if(x<0){
        x = 1000;
        y = round(random(500));
      }
      translate(x,y);
      fill(200);
      System.out.println(speedX);
      rotate(multip*radians(2));
      image(pic, -width/2,-height/2,width,height);
      popMatrix();
      multip ++;
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
