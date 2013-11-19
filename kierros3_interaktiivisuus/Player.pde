class Player{
  float r;
  float x;
  float y;
  int speedY;

  Player(float x, float y, float r, float speedY){
    this.x = x;
    this.y = y;
    this.r =r;

  }
  void draw(float delta){
    if(this.y < height && this.y >0){
    this.y = y+delta;
    }
    fill(200);
    if(this.y > height-(this.r/2)){
      this.y = height-(this.r/2);
    }
    if(this.y < (this.r/2)){
      this.y = (this.r/2);
    }
    ellipse(x,y,r,r);
  }

  float getX(){
    return this.x;
  }

  float getY(){
    return this.y;
  }
  float getR(){
    return this.r/2;
  }
}
